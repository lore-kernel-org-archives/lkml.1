Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZGUFBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZGUFBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZGUFBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:01:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:58059 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZGUFBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:01:11 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/3] taskstats: Add a netlink based notification of fork/clone
Date: Tue, 21 Jul 2009 10:31:41 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: balbir@linux.vnet.ibm.com, Guillaume Chazarain <guichaz@gmail.com>,
       procps-feedback@lists.sf.net, Albert Cahalan <albert@users.sf.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211031.42766.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I was looking to write an application that displays live graph of taskstats. I
found that to check whether a new task has been forked/cloned in the system,
one has to hold the list of current tasks and keep polling by walking the
/proc and compare with the stored list of current tasks, which is quiet
inefficient. And for applications which just want to record the history of
tasks forked/exited the system, it is quiet possible to loose a short-lived
process.

In taskstats, we already have TASKSTATS_CMD_ATTR_REGISTER_CPUMASK which when
sent by an application, taskstat is sent to the application, whenever a task
exits. This patch set adds a similar command to send notification with
TGID/TID, whenever a new task forks.

Modifying iotop to make use of this notification, results in improvement of
the iotop's performance. Attached is the patch to iotop, that I used to
measure performance benefits. Both the user and sys time show improvement with
this approach. On systems with lots of tasks, the current way of
polling/walking the proc looking for new tasks won't scale.

Using tracepoints/ftrace is an option, but they are not really suitable for
these kind of applications. For example, ftrace supports only one tracer at a
time! Or they are intended to be used by applications as well? Or is there any
other mechanism already for this?

Thanks
Nikanth

diff --git a/iotop/data.py b/iotop/data.py
index dc98bd2..26bd6fb 100644
--- a/iotop/data.py
+++ b/iotop/data.py
@@ -10,7 +10,7 @@ import sys
 import time
 
 from iotop import ioprio, vmstat
-from netlink import Connection, NETLINK_GENERIC, U32Attr, NLM_F_REQUEST
+from netlink import Connection, NETLINK_GENERIC, U32Attr, NLM_F_REQUEST, StrAttr
 from genetlink import Controller, GeNlMessage
 
 #
@@ -95,6 +95,8 @@ class Stats(DumpableObject):
 
 TASKSTATS_CMD_GET = 1
 TASKSTATS_CMD_ATTR_PID = 1
+TASKSTATS_CMD_ATTR_REGISTER_CPUMASK = 3
+TASKSTATS_CMD_ATTR_REGISTER_FORK_CPUMASK = 5
 
 class TaskStatsNetlink(object):
     # Keep in sync with format_stats() and pinfo.did_some_io()
@@ -312,8 +314,18 @@ class ProcessList(DumpableObject):
         self.timestamp = time.time()
         self.vmstat = vmstat.VmStat()
 
+        self.connection = Connection(NETLINK_GENERIC)
+        self.connection.descriptor.setblocking(0)
+        controller = Controller(self.connection)
+        self.family_id = controller.get_family_id('TASKSTATS')
+
+        request = GeNlMessage(self.family_id, cmd=TASKSTATS_CMD_GET,
+                                attrs=[StrAttr(TASKSTATS_CMD_ATTR_REGISTER_FORK_CPUMASK, '00')],
+                                flags=NLM_F_REQUEST)
+        request.send(self.connection)
+
         # A first time as we are interested in the delta
-        self.update_process_counts()
+        self.initialize_process_counts()
 
     def get_process(self, pid):
         """Either get the specified PID from self.processes or build a new
@@ -352,7 +364,7 @@ class ProcessList(DumpableObject):
 
         return tids
 
-    def update_process_counts(self):
+    def initialize_process_counts(self):
         new_timestamp = time.time()
         self.duration = new_timestamp - self.timestamp
         self.timestamp = new_timestamp
@@ -370,7 +382,36 @@ class ProcessList(DumpableObject):
 
         return self.vmstat.delta()
 
+    def update_process_counts(self):
+        new_timestamp = time.time()
+        self.duration = new_timestamp - self.timestamp
+        self.timestamp = new_timestamp
+
+        for process in self.processes.itervalues():
+            for tid, thread in process.threads.items():
+                stats = self.taskstats_connection.get_single_task_stats(tid)
+                if stats:
+                    thread.update_stats(stats)
+		    thread.mark = False
+
+        return self.vmstat.delta()
+
+    def add_new_tasks(self):
+	e = None
+        while (e == None): #using non-blocking socket!
+            try:
+                reply = self.connection.recv()
+                reply_length, reply_type, _align, tid, _align, tgid = struct.unpack('HHHiHi', reply.payload[4:24])
+                if not self.options.processes:
+                    pinfo = self.get_process(tid)
+                else:
+                    pinfo = self.get_process(tgid)
+                pinfo.get_thread(tid)
+            except BaseException, e:
+                pass
+
     def refresh_processes(self):
+        self.add_new_tasks()
         for process in self.processes.itervalues():
             for thread in process.threads.itervalues():
                 thread.mark = True

