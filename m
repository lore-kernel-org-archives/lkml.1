Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYJZVMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYJZVMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 17:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYJZVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 17:12:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:54672 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYJZVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 17:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=ckCP5ELWpguQTHkIZUKNF54CjJcXvYZ1NiMOvQZHd4jN3wZrr1hilnH/yQh5mhmwFp
         z9zxgcKx4ColX5mpN8oo07fjAlvqOJp1TrWwGiK3u6UhGM7xhVvJYXoUZ1lwegQIbzq6
         i/bgNs+9aayDyraZRPq8SUAlgR69J1sbzlB5Q=
Message-ID: <4904DD15.4040005@gmail.com>
Date: Sun, 26 Oct 2008 22:11:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: Add a script to produce a hierarchical view of a
 function trace
Content-Type: multipart/mixed;
 boundary="------------080203060400060009090106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080203060400060009090106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This script parses a function trace and then produces a hierarchical view of the 
function call stack after processing it into a tree.

You can see the result on attachment. You will find the raw trace and the hierarchical view.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/scripts/draw_functrace.py b/scripts/draw_functrace.py
new file mode 100755
index 0000000..e6496bd
--- /dev/null
+++ b/scripts/draw_functrace.py
@@ -0,0 +1,119 @@
+#!/usr/bin/python
+
+"""
+Copyright 2008 (c) Frederic Weisbecker <fweisbec@gmail.com>
+Licensed under the terms of the GNU GPL License version 2
+
+This script parses a trace provided by the function tracer in
+kernel/trace/trace_functions.c
+The resulted trace is processed into a tree to produce a more human
+view of the call stack by drawing textual but hierarchical tree of
+calls. Only the functions's names and the the call time are provided.
+
+Usage:
+	Be sure that you have CONFIG_FUNCTION_TRACER
+	# mkdir /debugfs
+	# mount -t debug debug /debug
+	# echo function > /debug/tracing/current_tracer
+	# cat /debug/tracing/current_tracer > ~/raw_trace_func
+	Wait some times but not too much, the scripts is a bit slow.
+	Break the pipe (Ctrl + Z)
+	$ scripts/draw_functrace.py < raw_trace_func > draw_functrace
+	Then you have your drawn trace in draw_functrace
+"""
+
+
+import sys, re
+
+class CallTree:
+	""" This class provides a tree representation of the functions
+		call stack. If a function has no parent in the kernel (interrupt,
+		syscall, kernel thread...) then it is attached to a virtual parent
+		called ROOT.
+	"""
+	ROOT = None
+
+	def __init__(self, func, time = None, parent = None):
+		self._func = func
+		self._time = time
+		if parent is None:
+			self._parent = CallTree.ROOT
+		else:
+			self._parent = parent
+		self._children = []
+
+	def calls(self, func, calltime):
+		""" If a function calls another one, call this method to insert it
+			into the tree at the appropriate place.
+			@return: A reference to the newly created child node.
+		"""
+		child = CallTree(func, calltime, self)
+		self._children.append(child)
+		return child
+
+	def getParent(self, func):
+		""" Retrieve the last parent of the current node that
+			has the name given by func. If this function is not
+			on a parent, then create it as new child of root
+			@return: A reference to the parent.
+		"""
+		tree = self
+		while tree != CallTree.ROOT and tree._func != func:
+			tree = tree._parent
+		if tree == CallTree.ROOT:
+			child = CallTree.ROOT.calls(func, None)
+			return child
+		return tree
+
+	def __repr__(self):
+		return self.__toString("", True)
+
+	def __toString(self, branch, lastChild):
+		if self._time is not None:
+			s = "%s----%s (%s)\n" % (branch, self._func, self._time)
+		else:
+			s = "%s----%s\n" % (branch, self._func)
+
+		i = 0
+		if lastChild:
+			branch = branch[:-1] + " "
+		while i < len(self._children):
+			if i != len(self._children) - 1:
+				s += "%s" % self._children[i].__toString(branch +\
+									 "    |", False)
+			else:
+				s += "%s" % self._children[i].__toString(branch +\
+									 "    |", True)
+			i += 1
+		return s
+
+class BrokenLineException(Exception):
+	"""If the last line is not complete because of the pipe breakage,
+	   we want to stop the processing and ignore this line.
+	"""
+	pass
+
+
+def parseLine(line):
+	m = re.match("[^]]+?\\]   ([0-9.]+): (\\w+) <-(\\w+)", line.strip())
+	if m is None:
+		raise BrokenLineException
+	return (m.group(1), m.group(2), m.group(3))
+
+
+def main():
+	CallTree.ROOT = CallTree("Root (Nowhere)", None, None)
+	tree = CallTree.ROOT
+
+	for line in sys.stdin:
+		try:
+			calltime, callee, caller = parseLine(line)
+		except BrokenLineException:
+			break
+		tree = tree.getParent(caller)
+		tree = tree.calls(callee, calltime)
+
+	print CallTree.ROOT
+
+if __name__ == "__main__":
+	main()

--------------080203060400060009090106
Content-Type: text/plain;
 name="trace.func"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="trace.func"

            Xorg-3856  [001]   463.031395: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031396: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031397: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031397: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031397: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031398: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031399: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031399: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031400: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031401: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031401: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031401: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031402: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031402: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031403: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031404: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031404: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031405: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031405: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031406: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031406: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031406: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031408: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031408: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031408: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031409: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031410: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031410: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031410: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031411: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031412: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031412: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031413: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031414: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031414: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031414: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031415: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031415: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031416: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031417: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031417: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031418: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031418: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031419: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031419: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031419: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031421: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031421: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031422: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031422: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031423: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031423: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031423: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031424: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031425: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031426: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031426: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031427: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031427: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031427: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031428: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031428: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031430: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031430: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031430: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031431: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031432: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031432: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031432: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031432: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031434: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031434: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031435: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031436: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031436: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031436: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031436: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031437: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031438: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031439: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031439: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031440: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031440: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031441: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031441: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031441: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031443: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031443: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031443: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031444: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031445: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031445: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031445: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031446: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031447: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031447: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031448: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031449: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031449: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031449: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031450: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031450: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031452: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031452: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031452: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031453: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031454: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031454: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031454: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031454: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031456: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031456: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031457: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031458: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031458: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031458: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031459: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031459: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031460: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031461: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031461: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031462: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031462: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031463: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031463: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031463: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031465: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031465: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031465: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031466: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031467: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031467: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031467: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031468: hpet_readl <-read_hpet
            Xorg-3856  [001]   463.031469: copy_to_user <-sys_gettimeofday
            Xorg-3856  [001]   463.031469: might_fault <-copy_to_user
            Xorg-3856  [001]   463.031470: __copy_to_user_ll <-copy_to_user
            Xorg-3856  [001]   463.031471: sys_gettimeofday <-sysenter_do_call
            Xorg-3856  [001]   463.031471: do_gettimeofday <-sys_gettimeofday
            Xorg-3856  [001]   463.031471: getnstimeofday <-do_gettimeofday
            Xorg-3856  [001]   463.031472: read_hpet <-getnstimeofday
            Xorg-3856  [001]   463.031472: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   463.071408: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   463.071409: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   463.071409: unix_poll <-sock_poll
     firefox-bin-4313  [000]   463.071409: __pollwait <-unix_poll
     firefox-bin-4313  [000]   463.071410: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   463.071410: fput <-do_sys_poll
     firefox-bin-4313  [000]   463.071411: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   463.071411: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   463.071411: unix_poll <-sock_poll
     firefox-bin-4313  [000]   463.071412: __pollwait <-unix_poll
     firefox-bin-4313  [000]   463.071412: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   463.071413: fput <-do_sys_poll
     firefox-bin-4313  [000]   463.071413: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   463.071413: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   463.071414: __pollwait <-pipe_poll
     firefox-bin-4313  [000]   463.071414: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   463.071415: fput <-do_sys_poll
     firefox-bin-4313  [000]   463.071415: hrtimer_init <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   463.071416: ktime_add_safe <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   463.071416: hrtimer_init_sleeper <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   463.071416: hrtimer_start_range_ns <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   463.071417: lock_hrtimer_base <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   463.071417: ktime_add_safe <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   463.071417: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   463.071418: enqueue_hrtimer <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   463.071421: __switch_to <-schedule
     firefox-bin-4313  [000]   463.071422: __switch_to_xtra <-__switch_to
            Xorg-3856  [000]   463.071424: math_state_restore <-do_device_not_available
            Xorg-3856  [000]   463.071697: sys_select <-sysenter_do_call
            Xorg-3856  [000]   463.071697: copy_from_user <-sys_select
            Xorg-3856  [000]   463.071698: might_fault <-copy_from_user
            Xorg-3856  [000]   463.071698: __copy_from_user_ll <-copy_from_user
            Xorg-3856  [000]   463.071699: poll_select_set_timeout <-sys_select
            Xorg-3856  [000]   463.071699: core_sys_select <-sys_select
            Xorg-3856  [000]   463.071700: copy_from_user <-core_sys_select
            Xorg-3856  [000]   463.071700: might_fault <-copy_from_user
            Xorg-3856  [000]   463.071700: __copy_from_user_ll <-copy_from_user
            Xorg-3856  [000]   463.071701: do_select <-core_sys_select
            Xorg-3856  [000]   463.071702: poll_initwait <-do_select
            Xorg-3856  [000]   463.071703: fget_light <-do_select
            Xorg-3856  [000]   463.071703: sock_poll <-do_select
            Xorg-3856  [000]   463.071704: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071704: fget_light <-do_select
            Xorg-3856  [000]   463.071705: sock_poll <-do_select
            Xorg-3856  [000]   463.071705: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071706: fget_light <-do_select
            Xorg-3856  [000]   463.071706: tty_poll <-do_select
            Xorg-3856  [000]   463.071707: tty_paranoia_check <-tty_poll
            Xorg-3856  [000]   463.071707: tty_ldisc_ref_wait <-tty_poll
            Xorg-3856  [000]   463.071708: tty_ldisc_try <-tty_ldisc_ref_wait
            Xorg-3856  [000]   463.071709: n_tty_poll <-tty_poll
            Xorg-3856  [000]   463.071709: tty_hung_up_p <-n_tty_poll
            Xorg-3856  [000]   463.071710: tty_chars_in_buffer <-n_tty_poll
            Xorg-3856  [000]   463.071710: con_chars_in_buffer <-tty_chars_in_buffer
            Xorg-3856  [000]   463.071710: tty_write_room <-n_tty_poll
            Xorg-3856  [000]   463.071711: con_write_room <-tty_write_room
            Xorg-3856  [000]   463.071711: tty_ldisc_deref <-tty_poll
            Xorg-3856  [000]   463.071712: fget_light <-do_select
            Xorg-3856  [000]   463.071712: sock_poll <-do_select
            Xorg-3856  [000]   463.071713: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071713: fget_light <-do_select
            Xorg-3856  [000]   463.071714: sock_poll <-do_select
            Xorg-3856  [000]   463.071714: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071715: fget_light <-do_select
            Xorg-3856  [000]   463.071715: sock_poll <-do_select
            Xorg-3856  [000]   463.071715: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071716: fget_light <-do_select
            Xorg-3856  [000]   463.071716: sock_poll <-do_select
            Xorg-3856  [000]   463.071717: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071717: fget_light <-do_select
            Xorg-3856  [000]   463.071718: sock_poll <-do_select
            Xorg-3856  [000]   463.071718: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071718: fget_light <-do_select
            Xorg-3856  [000]   463.071719: sock_poll <-do_select
            Xorg-3856  [000]   463.071719: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071719: fget_light <-do_select
            Xorg-3856  [000]   463.071720: sock_poll <-do_select
            Xorg-3856  [000]   463.071721: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071721: fget_light <-do_select
            Xorg-3856  [000]   463.071721: sock_poll <-do_select
            Xorg-3856  [000]   463.071722: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071722: fget_light <-do_select
            Xorg-3856  [000]   463.071723: sock_poll <-do_select
            Xorg-3856  [000]   463.071723: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071724: fget_light <-do_select
            Xorg-3856  [000]   463.071724: sock_poll <-do_select
            Xorg-3856  [000]   463.071724: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071725: fget_light <-do_select
            Xorg-3856  [000]   463.071725: sock_poll <-do_select
            Xorg-3856  [000]   463.071726: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071726: fget_light <-do_select
            Xorg-3856  [000]   463.071726: sock_poll <-do_select
            Xorg-3856  [000]   463.071727: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071727: fget_light <-do_select
            Xorg-3856  [000]   463.071728: sock_poll <-do_select
            Xorg-3856  [000]   463.071728: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071729: fget_light <-do_select
            Xorg-3856  [000]   463.071729: sock_poll <-do_select
            Xorg-3856  [000]   463.071729: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071730: fget_light <-do_select
            Xorg-3856  [000]   463.071730: sock_poll <-do_select
            Xorg-3856  [000]   463.071731: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071731: fget_light <-do_select
            Xorg-3856  [000]   463.071731: sock_poll <-do_select
            Xorg-3856  [000]   463.071732: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071732: fget_light <-do_select
            Xorg-3856  [000]   463.071733: sock_poll <-do_select
            Xorg-3856  [000]   463.071733: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071733: fget_light <-do_select
            Xorg-3856  [000]   463.071734: sock_poll <-do_select
            Xorg-3856  [000]   463.071734: unix_poll <-sock_poll
            Xorg-3856  [000]   463.071735: poll_freewait <-do_select
            Xorg-3856  [000]   463.071735: might_fault <-core_sys_select
            Xorg-3856  [000]   463.071735: __copy_to_user_ll <-core_sys_select
            Xorg-3856  [000]   463.071736: poll_select_copy_remaining <-sys_select
            Xorg-3856  [000]   463.072435: smp_apic_timer_interrupt <-apic_timer_interrupt
            Xorg-3856  [000]   463.072436: native_apic_mem_write <-smp_apic_timer_interrupt
            Xorg-3856  [000]   463.072436: irq_enter <-smp_apic_timer_interrupt
            Xorg-3856  [000]   463.072437: hrtimer_interrupt <-smp_apic_timer_interrupt
            Xorg-3856  [000]   463.072437: ktime_get <-hrtimer_interrupt
            Xorg-3856  [000]   463.072437: ktime_get_ts <-ktime_get
            Xorg-3856  [000]   463.072438: getnstimeofday <-ktime_get_ts
            Xorg-3856  [000]   463.072438: read_hpet <-getnstimeofday
            Xorg-3856  [000]   463.072438: hpet_readl <-read_hpet
            Xorg-3856  [000]   463.072440: set_normalized_timespec <-ktime_get_ts
            Xorg-3856  [000]   463.072441: __run_hrtimer <-hrtimer_interrupt
            Xorg-3856  [000]   463.072442: __remove_hrtimer <-__run_hrtimer
            Xorg-3856  [000]   463.072442: timer_stats_update_stats <-__run_hrtimer
            Xorg-3856  [000]   463.072442: tick_sched_timer <-__run_hrtimer
            Xorg-3856  [000]   463.072443: ktime_get <-tick_sched_timer
            Xorg-3856  [000]   463.072443: ktime_get_ts <-ktime_get
            Xorg-3856  [000]   463.072443: getnstimeofday <-ktime_get_ts
            Xorg-3856  [000]   463.072444: read_hpet <-getnstimeofday
            Xorg-3856  [000]   463.072444: hpet_readl <-read_hpet
            Xorg-3856  [000]   463.072446: set_normalized_timespec <-ktime_get_ts
            Xorg-3856  [000]   463.072446: tick_do_update_jiffies64 <-tick_sched_timer
            Xorg-3856  [000]   463.072446: do_timer <-tick_do_update_jiffies64
            Xorg-3856  [000]   463.072447: update_wall_time <-do_timer
            Xorg-3856  [000]   463.072447: read_hpet <-update_wall_time
            Xorg-3856  [000]   463.072447: hpet_readl <-read_hpet
            Xorg-3856  [000]   463.072449: update_xtime_cache <-update_wall_time
            Xorg-3856  [000]   463.072449: clocksource_get_next <-update_wall_time
            Xorg-3856  [000]   463.072450: update_process_times <-tick_sched_timer
            Xorg-3856  [000]   463.072451: account_process_tick <-update_process_times
            Xorg-3856  [000]   463.072451: run_local_timers <-update_process_times
            Xorg-3856  [000]   463.072451: hrtimer_run_queues <-run_local_timers
            Xorg-3856  [000]   463.072452: raise_softirq <-run_local_timers
            Xorg-3856  [000]   463.072452: softlockup_tick <-run_local_timers
            Xorg-3856  [000]   463.072453: get_timestamp <-softlockup_tick
            Xorg-3856  [000]   463.072453: rcu_pending <-update_process_times
            Xorg-3856  [000]   463.072454: __rcu_pending <-rcu_pending
            Xorg-3856  [000]   463.072454: __rcu_pending <-rcu_pending
            Xorg-3856  [000]   463.072454: printk_tick <-update_process_times
            Xorg-3856  [000]   463.072455: ktime_get <-sched_clock_tick
            Xorg-3856  [000]   463.072455: ktime_get_ts <-ktime_get
            Xorg-3856  [000]   463.072455: getnstimeofday <-ktime_get_ts
            Xorg-3856  [000]   463.072456: read_hpet <-getnstimeofday
            Xorg-3856  [000]   463.072456: hpet_readl <-read_hpet
            Xorg-3856  [000]   463.072458: set_normalized_timespec <-ktime_get_ts
            Xorg-3856  [000]   463.072459: run_posix_cpu_timers <-update_process_times
            Xorg-3856  [000]   463.072460: profile_tick <-tick_sched_timer
            Xorg-3856  [000]   463.072460: hrtimer_forward <-tick_sched_timer
            Xorg-3856  [000]   463.072460: ktime_add_safe <-hrtimer_forward
            Xorg-3856  [000]   463.072461: ktime_add_safe <-hrtimer_forward
            Xorg-3856  [000]   463.072461: enqueue_hrtimer <-__run_hrtimer
            Xorg-3856  [000]   463.072462: tick_program_event <-hrtimer_interrupt
            Xorg-3856  [000]   463.072462: tick_dev_program_event <-tick_program_event
            Xorg-3856  [000]   463.072463: ktime_get <-tick_dev_program_event
            Xorg-3856  [000]   463.072463: ktime_get_ts <-ktime_get
            Xorg-3856  [000]   463.072463: getnstimeofday <-ktime_get_ts
            Xorg-3856  [000]   463.072464: read_hpet <-getnstimeofday
            Xorg-3856  [000]   463.072464: hpet_readl <-read_hpet
            Xorg-3856  [000]   463.072465: set_normalized_timespec <-ktime_get_ts
            Xorg-3856  [000]   463.072466: clockevents_program_event <-tick_dev_program_event
            Xorg-3856  [000]   463.072466: lapic_next_event <-clockevents_program_event
            Xorg-3856  [000]   463.072467: native_apic_mem_write <-lapic_next_event
            Xorg-3856  [000]   463.072467: irq_exit <-smp_apic_timer_interrupt
            Xorg-3856  [000]   463.072467: do_softirq <-irq_exit
            Xorg-3856  [000]   463.072468: __do_softirq <-do_softirq
            Xorg-3856  [000]   463.072468: __local_bh_disable <-__do_softirq
            Xorg-3856  [000]   463.072469: run_timer_softirq <-__do_softirq
            Xorg-3856  [000]   463.072469: hrtimer_run_pending <-run_timer_softirq
            Xorg-3856  [000]   463.072470: _local_bh_enable <-__do_softirq
            Xorg-3856  [000]   463.076430: smp_apic_timer_interrupt <-apic_timer_interrupt
            Xorg-3856  [000]   463.076431: native_apic_mem_write <-smp_apic_timer_interrupt
            Xorg-3856  [000]   463.076431: irq_enter <-smp_apic_timer_interrupt
            Xorg-3856  [000]   463.076431: hrtimer_interrupt <-smp_apic_timer_interrupt
            Xorg-3856  [000]   463.076432: ktime_get <-hrtimer_interrupt
            Xorg-3856  [000]   463.076432: ktime_get_ts <-ktime_get
            Xorg-3856  [000]   463.076433: getnstimeofday <-ktime_get_ts
            Xorg-3856  [000]   463.076433: read_hpet <-getnstimeofday
            Xorg-3856  [000]   463.076433: hpet_readl <-read_hpet
            Xorg-3856  [000]   463.076435: set_normalized_timespec <-ktime_get_ts
            Xorg-3856  [000]   463.076436: __run_hrtimer <-hrtimer_interrupt
            Xorg-3856  [000]   463.076436: __remove_hrtimer <-__run_hrtimer
            Xorg-3856  [000]   463.076437: timer_stats_update_stats <-__run_hrtimer
            Xorg-3856  [000]   463.076437: tick_sched_timer <-__run_hrtimer
            Xorg-3856  [000]   463.076437: ktime_get <-tick_sched_timer
            Xorg-3856  [000]   463.076438: ktime_get_ts <-ktime_get
            Xorg-3856  [000]   463.076438: getnstimeofday <-ktime_get_ts
            Xorg-3856  [000]   463.076438: read_hpet <-getnstimeofday
            Xorg-3856  [000]   463.076439: hpet_readl <-read_hpet
            Xorg-3856  [000]   463.076440: set_normalized_timespec <-ktime_get_ts
            Xorg-3856  [000]   463.076440: tick_do_update_jiffies64 <-tick_sched_timer
          <idle>-0     [001]   475.329280: ktime_get <-sched_clock_tick
          <idle>-0     [001]   475.329280: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.329281: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.329281: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.329281: hpet_readl <-read_hpet
          <idle>-0     [001]   475.329283: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.329283: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [001]   475.329284: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.329284: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.329285: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.329285: delay_tsc <-__delay
          <idle>-0     [001]   475.329286: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.329286: delay_tsc <-__delay
          <idle>-0     [001]   475.329286: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.329287: delay_tsc <-__delay
          <idle>-0     [001]   475.329287: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.329287: delay_tsc <-__delay
          <idle>-0     [001]   475.329288: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.329288: delay_tsc <-__delay
          <idle>-0     [001]   475.329289: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.329289: delay_tsc <-__delay
          <idle>-0     [001]   475.329290: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.329290: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.329290: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.329290: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.329291: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.329291: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.329292: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.329292: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [001]   475.329292: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.329293: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.329293: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.329293: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.329294: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.329294: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.329294: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.329295: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.329295: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.329295: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.329296: hpet_readl <-read_hpet
          <idle>-0     [001]   475.329297: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.329298: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.329298: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.329298: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.329299: menu_reflect <-cpuidle_idle_call
          <idle>-0     [001]   475.329300: rcu_pending <-cpu_idle
          <idle>-0     [001]   475.329300: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.329300: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.329301: cpuidle_idle_call <-cpu_idle
          <idle>-0     [001]   475.329301: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [001]   475.329301: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [001]   475.329302: ktime_get <-hrtimer_interrupt
          <idle>-0     [001]   475.329302: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.329302: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.329303: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.329303: hpet_readl <-read_hpet
          <idle>-0     [001]   475.329304: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.329305: tick_program_event <-hrtimer_interrupt
          <idle>-0     [001]   475.329306: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.329306: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.329306: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.329307: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.329307: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.329307: hpet_readl <-read_hpet
          <idle>-0     [001]   475.329309: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.329309: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.329309: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.329310: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.329310: menu_select <-cpuidle_idle_call
          <idle>-0     [001]   475.329310: pm_qos_requirement <-menu_select
          <idle>-0     [001]   475.329311: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [001]   475.329311: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [001]   475.329312: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.329312: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.329312: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.329313: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.329313: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.329313: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.329314: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.329314: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.329314: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.329315: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [001]   475.329315: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [001]   475.329318: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [001]   475.329318: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [001]   475.335374: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [001]   475.335375: ktime_get <-sched_clock_tick
          <idle>-0     [001]   475.335375: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335376: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335376: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335376: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335378: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335378: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [001]   475.335379: do_IRQ <-common_interrupt
          <idle>-0     [001]   475.335379: irq_enter <-do_IRQ
          <idle>-0     [001]   475.335380: tick_check_idle <-irq_enter
          <idle>-0     [001]   475.335380: tick_check_oneshot_broadcast <-tick_check_idle
          <idle>-0     [001]   475.335381: clockevents_set_mode <-tick_check_oneshot_broadcast
          <idle>-0     [001]   475.335381: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.335381: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [001]   475.335382: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.335382: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.335382: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.335383: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.335383: tick_nohz_stop_idle <-tick_check_idle
          <idle>-0     [001]   475.335383: ktime_get <-tick_nohz_stop_idle
          <idle>-0     [001]   475.335384: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335384: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335384: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335385: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335386: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335387: ktime_get <-sched_clock_tick
          <idle>-0     [001]   475.335387: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335387: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335388: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335388: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335389: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335390: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [001]   475.335390: tick_nohz_update_jiffies <-tick_check_idle
          <idle>-0     [001]   475.335391: ktime_get <-tick_nohz_update_jiffies
          <idle>-0     [001]   475.335391: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335391: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335391: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335392: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335393: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335393: tick_do_update_jiffies64 <-tick_nohz_update_jiffies
          <idle>-0     [001]   475.335394: touch_softlockup_watchdog <-tick_nohz_update_jiffies
          <idle>-0     [001]   475.335394: ktime_get <-tick_check_idle
          <idle>-0     [001]   475.335394: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335395: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335395: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335395: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335397: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335397: tick_nohz_restart <-tick_check_idle
          <idle>-0     [001]   475.335397: hrtimer_cancel <-tick_nohz_restart
          <idle>-0     [001]   475.335398: hrtimer_try_to_cancel <-hrtimer_cancel
          <idle>-0     [001]   475.335398: lock_hrtimer_base <-hrtimer_try_to_cancel
          <idle>-0     [001]   475.335399: __remove_hrtimer <-hrtimer_try_to_cancel
          <idle>-0     [001]   475.335399: hrtimer_force_reprogram <-__remove_hrtimer
          <idle>-0     [001]   475.335399: tick_program_event <-hrtimer_force_reprogram
          <idle>-0     [001]   475.335400: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.335400: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.335400: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335401: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335401: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335401: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335403: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335403: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.335403: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.335404: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.335404: hrtimer_forward <-tick_nohz_restart
          <idle>-0     [001]   475.335405: ktime_divns <-hrtimer_forward
          <idle>-0     [001]   475.335405: ktime_add_safe <-hrtimer_forward
          <idle>-0     [001]   475.335406: ktime_add_safe <-hrtimer_forward
          <idle>-0     [001]   475.335406: hrtimer_start_range_ns <-tick_nohz_restart
          <idle>-0     [001]   475.335406: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [001]   475.335407: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [001]   475.335407: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [001]   475.335407: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [001]   475.335408: hrtimer_reprogram <-enqueue_hrtimer
          <idle>-0     [001]   475.335408: tick_program_event <-hrtimer_reprogram
          <idle>-0     [001]   475.335408: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.335409: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.335409: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335409: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335410: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335410: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335412: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335412: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.335412: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.335413: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.335413: handle_edge_irq <-do_IRQ
          <idle>-0     [001]   475.335414: ack_apic_edge <-handle_edge_irq
          <idle>-0     [001]   475.335414: irq_complete_move <-ack_apic_edge
          <idle>-0     [001]   475.335414: irq_cfg <-irq_complete_move
          <idle>-0     [001]   475.335415: move_native_irq <-ack_apic_edge
          <idle>-0     [001]   475.335415: native_apic_mem_write <-ack_apic_edge
          <idle>-0     [001]   475.335415: handle_IRQ_event <-handle_edge_irq
          <idle>-0     [001]   475.335416: timer_interrupt <-handle_IRQ_event
          <idle>-0     [001]   475.335416: tick_handle_oneshot_broadcast <-timer_interrupt
          <idle>-0     [001]   475.335417: ktime_get <-tick_handle_oneshot_broadcast
          <idle>-0     [001]   475.335417: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335417: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335418: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335418: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335419: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335420: tick_do_broadcast <-tick_handle_oneshot_broadcast
          <idle>-0     [001]   475.335420: tick_broadcast_set_event <-tick_handle_oneshot_broadcast
          <idle>-0     [001]   475.335420: tick_dev_program_event <-tick_broadcast_set_event
          <idle>-0     [001]   475.335421: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.335421: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.335421: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.335422: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.335422: hpet_readl <-read_hpet
          <idle>-0     [001]   475.335423: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.335424: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.335424: hpet_legacy_next_event <-clockevents_program_event
          <idle>-0     [001]   475.335425: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [001]   475.335426: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [001]   475.335427: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [001]   475.335429: note_interrupt <-handle_edge_irq
          <idle>-0     [001]   475.335430: irq_exit <-do_IRQ
          <idle>-0     [001]   475.335430: tick_nohz_stop_sched_tick <-irq_exit
          <idle>-0     [001]   475.335430: ktime_get <-tick_nohz_stop_sched_tick
          <idle>-0     [001]   475.448961: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.448961: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.448961: hpet_readl <-read_hpet
          <idle>-0     [001]   475.448963: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.448963: ktime_get <-sched_clock_tick
          <idle>-0     [001]   475.448963: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.448964: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.448964: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.448964: hpet_readl <-read_hpet
          <idle>-0     [001]   475.448966: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.448966: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [001]   475.448967: tick_nohz_update_jiffies <-tick_check_idle
          <idle>-0     [001]   475.448967: handle_edge_irq <-do_IRQ
          <idle>-0     [001]   475.448968: ack_apic_edge <-handle_edge_irq
          <idle>-0     [001]   475.448968: irq_complete_move <-ack_apic_edge
          <idle>-0     [001]   475.448968: irq_cfg <-irq_complete_move
          <idle>-0     [001]   475.448969: move_native_irq <-ack_apic_edge
          <idle>-0     [001]   475.448969: native_apic_mem_write <-ack_apic_edge
          <idle>-0     [001]   475.448970: handle_IRQ_event <-handle_edge_irq
          <idle>-0     [001]   475.448970: timer_interrupt <-handle_IRQ_event
          <idle>-0     [001]   475.448970: tick_handle_oneshot_broadcast <-timer_interrupt
          <idle>-0     [001]   475.448971: ktime_get <-tick_handle_oneshot_broadcast
          <idle>-0     [001]   475.448971: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.448971: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.448972: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.448972: hpet_readl <-read_hpet
          <idle>-0     [001]   475.448973: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.448974: tick_do_broadcast <-tick_handle_oneshot_broadcast
          <idle>-0     [001]   475.448974: hrtimer_interrupt <-tick_do_broadcast
          <idle>-0     [001]   475.448975: ktime_get <-hrtimer_interrupt
          <idle>-0     [001]   475.448975: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.448975: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.448976: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.448976: hpet_readl <-read_hpet
          <idle>-0     [001]   475.448977: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.448978: __run_hrtimer <-hrtimer_interrupt
          <idle>-0     [001]   475.448978: __remove_hrtimer <-__run_hrtimer
          <idle>-0     [001]   475.448979: timer_stats_update_stats <-__run_hrtimer
          <idle>-0     [001]   475.448979: tick_sched_timer <-__run_hrtimer
          <idle>-0     [001]   475.448980: ktime_get <-tick_sched_timer
          <idle>-0     [001]   475.448980: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.448980: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.448981: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.448981: hpet_readl <-read_hpet
          <idle>-0     [001]   475.448982: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.448983: tick_do_update_jiffies64 <-tick_sched_timer
          <idle>-0     [001]   475.448983: update_process_times <-tick_sched_timer
          <idle>-0     [001]   475.448983: account_process_tick <-update_process_times
          <idle>-0     [001]   475.448984: run_local_timers <-update_process_times
          <idle>-0     [001]   475.448984: hrtimer_run_queues <-run_local_timers
          <idle>-0     [001]   475.448984: raise_softirq <-run_local_timers
          <idle>-0     [001]   475.448985: softlockup_tick <-run_local_timers
          <idle>-0     [001]   475.448985: __touch_softlockup_watchdog <-softlockup_tick
          <idle>-0     [001]   475.448986: get_timestamp <-__touch_softlockup_watchdog
          <idle>-0     [001]   475.448986: rcu_pending <-update_process_times
          <idle>-0     [001]   475.448986: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.448987: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.448987: printk_tick <-update_process_times
          <idle>-0     [001]   475.448987: ktime_get <-sched_clock_tick
          <idle>-0     [001]   475.448988: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.448988: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.448988: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.448989: hpet_readl <-read_hpet
          <idle>-0     [001]   475.448990: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.448992: run_posix_cpu_timers <-update_process_times
          <idle>-0     [001]   475.448992: profile_tick <-tick_sched_timer
          <idle>-0     [001]   475.448993: profile_pc <-profile_tick
          <idle>-0     [001]   475.448993: hrtimer_forward <-tick_sched_timer
          <idle>-0     [001]   475.448993: ktime_add_safe <-hrtimer_forward
          <idle>-0     [001]   475.448994: ktime_add_safe <-hrtimer_forward
          <idle>-0     [001]   475.448994: enqueue_hrtimer <-__run_hrtimer
          <idle>-0     [001]   475.448995: tick_program_event <-hrtimer_interrupt
          <idle>-0     [001]   475.448995: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.448995: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.448996: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.448996: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.448996: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.448997: hpet_readl <-read_hpet
          <idle>-0     [001]   475.448998: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.448999: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.448999: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.448999: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.449000: note_interrupt <-handle_edge_irq
          <idle>-0     [001]   475.449000: irq_exit <-do_IRQ
          <idle>-0     [001]   475.449001: do_softirq <-irq_exit
          <idle>-0     [001]   475.449001: __do_softirq <-do_softirq
          <idle>-0     [001]   475.449001: __local_bh_disable <-__do_softirq
          <idle>-0     [001]   475.449002: run_timer_softirq <-__do_softirq
          <idle>-0     [001]   475.449002: hrtimer_run_pending <-run_timer_softirq
          <idle>-0     [001]   475.449003: _local_bh_enable <-__do_softirq
          <idle>-0     [001]   475.449004: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.449004: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.449004: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.449005: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.449005: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.449006: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.449006: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.449006: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.449007: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.449007: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.449007: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.449008: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.449008: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.449008: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.449009: hpet_readl <-read_hpet
          <idle>-0     [001]   475.449010: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.449010: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.449011: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.449011: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.449012: menu_reflect <-cpuidle_idle_call
          <idle>-0     [001]   475.449012: tick_nohz_restart_sched_tick <-cpu_idle
          <idle>-0     [001]   475.449013: tick_nohz_stop_idle <-tick_nohz_restart_sched_tick
          <idle>-0     [001]   475.449017: msecs_to_jiffies <-schedule
          <idle>-0     [001]   475.449018: tick_nohz_stop_sched_tick <-cpu_idle
          <idle>-0     [001]   475.449018: ktime_get <-tick_nohz_stop_sched_tick
          <idle>-0     [001]   475.449018: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.449019: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.449019: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.449019: hpet_readl <-read_hpet
          <idle>-0     [001]   475.449021: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.449021: get_next_timer_interrupt <-tick_nohz_stop_sched_tick
          <idle>-0     [001]   475.449022: hrtimer_get_next_event <-get_next_timer_interrupt
          <idle>-0     [001]   475.449023: rcu_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [001]   475.449023: rcu_pending <-rcu_needs_cpu
          <idle>-0     [001]   475.449023: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.449024: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.449024: printk_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [001]   475.449024: hrtimer_start <-tick_nohz_stop_sched_tick
          <idle>-0     [001]   475.449025: hrtimer_start_range_ns <-hrtimer_start
          <idle>-0     [001]   475.449025: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [001]   475.449026: __remove_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [001]   475.449026: hrtimer_force_reprogram <-__remove_hrtimer
          <idle>-0     [001]   475.449026: tick_program_event <-hrtimer_force_reprogram
          <idle>-0     [001]   475.449027: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.449027: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.449027: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.449028: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.449028: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.449028: hpet_readl <-read_hpet
          <idle>-0     [001]   475.449030: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.449030: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.449030: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.449031: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.449031: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [001]   475.449031: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [001]   475.449032: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [001]   475.449032: hrtimer_reprogram <-enqueue_hrtimer
          <idle>-0     [001]   475.449033: tick_program_event <-hrtimer_reprogram
          <idle>-0     [001]   475.449033: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.449033: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.449033: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.449034: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.449034: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.449034: hpet_readl <-read_hpet
          <idle>-0     [001]   475.449036: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.449036: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.449037: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.449037: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.449038: rcu_pending <-cpu_idle
          <idle>-0     [001]   475.449038: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.449038: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.449039: cpuidle_idle_call <-cpu_idle
          <idle>-0     [001]   475.449039: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [001]   475.449039: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [001]   475.449040: ktime_get <-hrtimer_interrupt
          <idle>-0     [001]   475.449040: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.449040: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.449041: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.449041: hpet_readl <-read_hpet
          <idle>-0     [001]   475.449042: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.449043: tick_program_event <-hrtimer_interrupt
          <idle>-0     [001]   475.449044: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.449044: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.449044: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.449045: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.449045: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.449045: hpet_readl <-read_hpet
          <idle>-0     [001]   475.449047: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.449047: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.449047: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.449048: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.449048: menu_select <-cpuidle_idle_call
          <idle>-0     [001]   475.449049: pm_qos_requirement <-menu_select
          <idle>-0     [001]   475.449049: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [001]   475.449049: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [001]   475.449050: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.449050: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.449050: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.449051: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.449051: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.449051: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.449052: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.449052: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.449053: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.449053: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [001]   475.449053: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [001]   475.449054: tick_broadcast_set_event <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.449054: tick_dev_program_event <-tick_broadcast_set_event
          <idle>-0     [001]   475.449054: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.449055: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.449055: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.449055: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.449056: hpet_readl <-read_hpet
          <idle>-0     [001]   475.449057: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512734: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.512734: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.512735: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.512735: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [000]   475.512735: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [000]   475.512738: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [000]   475.512738: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.512767: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.512768: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.512768: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512769: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512769: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512769: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512771: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512771: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.512772: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.512772: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.512773: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.512773: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.512773: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.512774: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.512774: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.512774: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.512775: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.512775: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [000]   475.512775: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.512776: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.512776: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.512777: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.512777: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.512777: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.512778: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.512778: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512778: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512779: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512779: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512780: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512781: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.512781: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.512781: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.512782: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.512783: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.512783: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.512783: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.512784: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.512784: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.512784: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.512785: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.512785: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512785: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512786: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512786: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512788: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512788: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.512789: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.512789: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.512789: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512790: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512790: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512790: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512792: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512792: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.512792: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.512793: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.512793: menu_select <-cpuidle_idle_call
          <idle>-0     [000]   475.512793: pm_qos_requirement <-menu_select
          <idle>-0     [000]   475.512794: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [000]   475.512794: acpi_idle_enter_c1 <-cpuidle_idle_call
          <idle>-0     [000]   475.512796: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_c1
          <idle>-0     [000]   475.512797: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.512857: do_IRQ <-common_interrupt
          <idle>-0     [000]   475.512857: irq_enter <-do_IRQ
          <idle>-0     [000]   475.512857: tick_check_idle <-irq_enter
          <idle>-0     [000]   475.512858: tick_check_oneshot_broadcast <-tick_check_idle
          <idle>-0     [000]   475.512858: tick_nohz_stop_idle <-tick_check_idle
          <idle>-0     [000]   475.512858: ktime_get <-tick_nohz_stop_idle
          <idle>-0     [000]   475.512859: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512859: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512859: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512860: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512861: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512861: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.512862: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512862: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512862: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512863: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512864: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512865: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.512865: tick_nohz_update_jiffies <-tick_check_idle
          <idle>-0     [000]   475.512865: ktime_get <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.512866: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512866: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512866: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512867: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512868: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512869: tick_do_update_jiffies64 <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.512869: touch_softlockup_watchdog <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.512869: ktime_get <-tick_check_idle
          <idle>-0     [000]   475.512870: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512870: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512870: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512871: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512872: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512873: tick_nohz_restart <-tick_check_idle
          <idle>-0     [000]   475.512873: hrtimer_cancel <-tick_nohz_restart
          <idle>-0     [000]   475.512873: hrtimer_try_to_cancel <-hrtimer_cancel
          <idle>-0     [000]   475.512874: lock_hrtimer_base <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.512874: __remove_hrtimer <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.512875: hrtimer_forward <-tick_nohz_restart
          <idle>-0     [000]   475.512875: hrtimer_start_range_ns <-tick_nohz_restart
          <idle>-0     [000]   475.512875: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512876: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512876: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512877: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512877: hrtimer_reprogram <-enqueue_hrtimer
          <idle>-0     [000]   475.512877: tick_program_event <-hrtimer_reprogram
          <idle>-0     [000]   475.512878: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.512878: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.512878: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512879: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512879: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512879: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512881: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512881: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.512882: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.512882: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.512883: handle_edge_irq <-do_IRQ
          <idle>-0     [000]   475.512883: ack_apic_edge <-handle_edge_irq
          <idle>-0     [000]   475.512883: irq_complete_move <-ack_apic_edge
          <idle>-0     [000]   475.512884: irq_cfg <-irq_complete_move
          <idle>-0     [000]   475.512884: move_native_irq <-ack_apic_edge
          <idle>-0     [000]   475.512884: native_apic_mem_write <-ack_apic_edge
          <idle>-0     [000]   475.512885: handle_IRQ_event <-handle_edge_irq
          <idle>-0     [000]   475.512885: timer_interrupt <-handle_IRQ_event
          <idle>-0     [000]   475.512886: tick_handle_oneshot_broadcast <-timer_interrupt
          <idle>-0     [000]   475.512886: ktime_get <-tick_handle_oneshot_broadcast
          <idle>-0     [000]   475.512887: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512887: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512887: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512888: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512889: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512889: tick_do_broadcast <-tick_handle_oneshot_broadcast
          <idle>-0     [000]   475.512890: tick_broadcast_set_event <-tick_handle_oneshot_broadcast
          <idle>-0     [000]   475.512890: tick_dev_program_event <-tick_broadcast_set_event
          <idle>-0     [000]   475.512890: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.512891: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512891: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512891: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512892: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512893: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512894: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.512894: hpet_legacy_next_event <-clockevents_program_event
          <idle>-0     [000]   475.512894: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.512896: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.512897: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.512899: note_interrupt <-handle_edge_irq
          <idle>-0     [000]   475.512899: irq_exit <-do_IRQ
          <idle>-0     [000]   475.512900: tick_nohz_stop_sched_tick <-irq_exit
          <idle>-0     [000]   475.512900: ktime_get <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.512900: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512901: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512901: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512901: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512903: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512903: get_next_timer_interrupt <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.512905: hrtimer_get_next_event <-get_next_timer_interrupt
          <idle>-0     [000]   475.512906: rcu_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.512906: rcu_pending <-rcu_needs_cpu
          <idle>-0     [000]   475.512906: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.512907: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.512907: printk_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.512907: hrtimer_start <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.512908: hrtimer_start_range_ns <-hrtimer_start
          <idle>-0     [000]   475.512908: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512908: __remove_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512909: hrtimer_force_reprogram <-__remove_hrtimer
          <idle>-0     [000]   475.512909: tick_program_event <-hrtimer_force_reprogram
          <idle>-0     [000]   475.512910: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.512910: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.512910: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512911: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512911: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512911: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512913: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512913: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.512913: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.512914: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.512914: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512914: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512915: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.512916: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.512916: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.512916: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.512917: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.512917: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.512917: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.512918: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.512918: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.512919: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.512919: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.512919: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.512919: hpet_readl <-read_hpet
          <idle>-0     [000]   475.512921: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.512922: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.521886: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.521886: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.521886: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.521887: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.521887: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.521887: hpet_readl <-read_hpet
          <idle>-0     [000]   475.521889: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.521889: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.521890: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.521890: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.521890: menu_select <-cpuidle_idle_call
          <idle>-0     [000]   475.521891: pm_qos_requirement <-menu_select
          <idle>-0     [000]   475.521891: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [000]   475.521891: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [000]   475.521892: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521892: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.521893: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.521893: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.521893: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.521894: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.521894: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.521895: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.521895: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.521895: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [000]   475.521896: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [000]   475.521898: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521898: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.521917: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521918: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.521918: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.521918: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.521919: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.521919: hpet_readl <-read_hpet
          <idle>-0     [000]   475.521921: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.521921: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.521922: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521922: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.521923: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.521923: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.521923: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.521924: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.521924: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.521924: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.521925: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.521925: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [000]   475.521925: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.521926: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.521926: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.521927: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.521927: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.521927: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.521928: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.521928: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.521928: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.521929: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.521929: hpet_readl <-read_hpet
          <idle>-0     [000]   475.521930: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.521931: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.521931: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.521932: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.521932: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.521933: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.521933: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.521933: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.521934: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.521934: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.521934: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.521935: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.521935: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.521935: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.521936: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.521936: hpet_readl <-read_hpet
          <idle>-0     [000]   475.521938: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.521938: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.521939: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.521939: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.521939: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.521940: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.521940: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.521940: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.521940: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.521940: hpet_readl <-read_hpet
          <idle>-0     [001]   475.521941: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.521941: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.521941: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.521942: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.521942: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.521942: hpet_readl <-read_hpet
          <idle>-0     [000]   475.521942: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.521942: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.521943: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.521943: menu_select <-cpuidle_idle_call
          <idle>-0     [001]   475.521943: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.521944: pm_qos_requirement <-menu_select
          <idle>-0     [001]   475.521944: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.521944: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [001]   475.521944: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.521944: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [001]   475.521945: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.521945: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521945: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.521945: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.521945: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.521946: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.521946: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.521946: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.521946: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.521946: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.521946: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.521947: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.521947: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.521947: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.521947: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.521947: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.521948: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.521948: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.521948: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [001]   475.521948: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.521948: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [001]   475.521948: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.521949: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.521949: hpet_readl <-read_hpet
          <idle>-0     [000]   475.521951: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521951: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [001]   475.521951: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.521952: tick_program_event <-hrtimer_interrupt
          <idle>-0     [001]   475.521953: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.521953: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.521953: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.521954: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.521954: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.521954: hpet_readl <-read_hpet
          <idle>-0     [001]   475.521956: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.521956: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.521956: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.521957: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.521957: menu_select <-cpuidle_idle_call
          <idle>-0     [001]   475.521957: pm_qos_requirement <-menu_select
          <idle>-0     [001]   475.521958: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [001]   475.521958: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [001]   475.521959: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.521959: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.521959: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.521960: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.521960: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.521960: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.521961: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.521961: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.521962: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.521962: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [001]   475.521962: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [001]   475.521965: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [001]   475.521965: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.521984: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521985: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.521985: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.521985: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.521985: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521986: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.521986: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.521986: hpet_readl <-read_hpet
          <idle>-0     [001]   475.521986: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.521987: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.521987: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.521987: hpet_readl <-read_hpet
          <idle>-0     [000]   475.521987: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.521988: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.521988: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.521989: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.521989: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.521989: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.521989: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.521990: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.521990: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.521990: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.521990: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.521990: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.521991: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521991: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.521991: delay_tsc <-__delay
          <idle>-0     [000]   475.521991: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.521991: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521992: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.521992: delay_tsc <-__delay
          <idle>-0     [000]   475.521992: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [001]   475.521992: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521992: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.521992: delay_tsc <-__delay
          <idle>-0     [000]   475.521993: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.521993: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521993: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.521993: delay_tsc <-__delay
          <idle>-0     [000]   475.521993: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.521994: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.521994: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521994: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.521994: delay_tsc <-__delay
          <idle>-0     [000]   475.521994: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.521995: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521995: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.521995: delay_tsc <-__delay
          <idle>-0     [000]   475.521995: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.521995: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521995: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.521996: delay_tsc <-__delay
          <idle>-0     [000]   475.521996: hpet_readl <-read_hpet
          <idle>-0     [001]   475.521996: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.521996: delay_tsc <-__delay
          <idle>-0     [001]   475.521997: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521997: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.521997: delay_tsc <-__delay
          <idle>-0     [000]   475.521997: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.521998: __delay <-_raw_spin_lock
          <idle>-0     [000]   475.521998: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.521998: delay_tsc <-__delay
          <idle>-0     [000]   475.521998: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.521998: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.521999: delay_tsc <-__delay
          <idle>-0     [000]   475.521999: menu_reflect <-cpuidle_idle_call
          <idle>-0     [001]   475.521999: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.521999: rcu_pending <-cpu_idle
          <idle>-0     [001]   475.522000: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.522000: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.522000: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.522000: __rcu_pending <-rcu_pending
          <idle>-0     [001]   475.522000: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.522000: cpuidle_idle_call <-cpu_idle
          <idle>-0     [001]   475.522001: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.522001: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.522001: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [001]   475.522001: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.522001: ktime_get <-hrtimer_interrupt
          <idle>-0     [001]   475.522002: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.522002: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.522002: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [000]   475.522002: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.522002: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.522002: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.522003: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.522003: hpet_readl <-read_hpet
          <idle>-0     [001]   475.522003: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.522003: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.522004: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.522004: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.522004: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.522004: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.522005: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.522005: tick_program_event <-hrtimer_interrupt
          <idle>-0     [001]   475.522005: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.522005: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.522005: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.522006: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.522006: hpet_readl <-read_hpet
          <idle>-0     [000]   475.522006: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.522006: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.522007: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.522007: hpet_readl <-read_hpet
          <idle>-0     [001]   475.522007: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.522008: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.522008: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.522008: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.522009: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.522009: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.522009: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.522009: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.522009: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.522010: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.522010: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.522010: menu_select <-cpuidle_idle_call
          <idle>-0     [001]   475.522010: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.522010: pm_qos_requirement <-menu_select
          <idle>-0     [001]   475.522011: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.522011: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [001]   475.522011: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.522011: acpi_idle_enter_c1 <-cpuidle_idle_call
          <idle>-0     [001]   475.522011: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [001]   475.522012: ktime_get <-hrtimer_interrupt
          <idle>-0     [001]   475.522012: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.522012: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.522013: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.522013: hpet_readl <-read_hpet
          <idle>-0     [000]   475.522013: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_c1
          <idle>-0     [000]   475.522014: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [001]   475.522014: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.522015: tick_program_event <-hrtimer_interrupt
          <idle>-0     [001]   475.522015: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.522016: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.522016: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.522016: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.522017: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.522017: hpet_readl <-read_hpet
          <idle>-0     [001]   475.522018: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.522019: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.522019: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.522019: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.522020: menu_select <-cpuidle_idle_call
          <idle>-0     [001]   475.522020: pm_qos_requirement <-menu_select
          <idle>-0     [001]   475.522020: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [001]   475.522021: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [001]   475.522021: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.522021: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.522022: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.522022: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.522023: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.522023: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.522023: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.522024: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.522024: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.522024: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [001]   475.522025: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [001]   475.522027: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [001]   475.522028: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.524841: do_IRQ <-common_interrupt
          <idle>-0     [000]   475.524841: irq_enter <-do_IRQ
          <idle>-0     [000]   475.524841: tick_check_idle <-irq_enter
          <idle>-0     [000]   475.524842: tick_check_oneshot_broadcast <-tick_check_idle
          <idle>-0     [000]   475.524842: tick_nohz_stop_idle <-tick_check_idle
          <idle>-0     [000]   475.524843: ktime_get <-tick_nohz_stop_idle
          <idle>-0     [000]   475.524843: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.524843: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.524844: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.524844: hpet_readl <-read_hpet
          <idle>-0     [000]   475.524845: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.524846: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.524846: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.524846: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.524847: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.524847: hpet_readl <-read_hpet
          <idle>-0     [000]   475.524848: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.524849: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.524849: tick_nohz_update_jiffies <-tick_check_idle
          <idle>-0     [000]   475.524850: ktime_get <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.524850: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.524850: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.524851: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.524851: hpet_readl <-read_hpet
          <idle>-0     [000]   475.524852: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.524853: tick_do_update_jiffies64 <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.524853: do_timer <-tick_do_update_jiffies64
          <idle>-0     [000]   475.524854: update_wall_time <-do_timer
          <idle>-0     [000]   475.524854: read_hpet <-update_wall_time
          <idle>-0     [000]   475.524854: hpet_readl <-read_hpet
          <idle>-0     [000]   475.524856: update_xtime_cache <-update_wall_time
          <idle>-0     [000]   475.524856: clocksource_get_next <-update_wall_time
          <idle>-0     [000]   475.524857: touch_softlockup_watchdog <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.524857: ktime_get <-tick_check_idle
          <idle>-0     [000]   475.524858: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.524858: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.524858: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.524859: hpet_readl <-read_hpet
          <idle>-0     [000]   475.524860: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.524860: tick_nohz_restart <-tick_check_idle
          <idle>-0     [001]   475.524955: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [001]   475.524956: ktime_get <-sched_clock_tick
          <idle>-0     [001]   475.524956: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.524956: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.524957: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.524957: hpet_readl <-read_hpet
          <idle>-0     [001]   475.524959: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.524959: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [001]   475.524960: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [001]   475.524960: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [001]   475.524960: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524961: delay_tsc <-__delay
          <idle>-0     [001]   475.524961: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524962: delay_tsc <-__delay
          <idle>-0     [001]   475.524962: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524962: delay_tsc <-__delay
          <idle>-0     [001]   475.524963: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524963: delay_tsc <-__delay
          <idle>-0     [001]   475.524964: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524964: delay_tsc <-__delay
          <idle>-0     [001]   475.524964: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524965: delay_tsc <-__delay
          <idle>-0     [001]   475.524965: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524966: delay_tsc <-__delay
          <idle>-0     [001]   475.524966: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524966: delay_tsc <-__delay
          <idle>-0     [001]   475.524967: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524967: delay_tsc <-__delay
          <idle>-0     [001]   475.524968: __delay <-_raw_spin_lock
          <idle>-0     [001]   475.524968: delay_tsc <-__delay
          <idle>-0     [001]   475.524968: clockevents_do_notify <-clockevents_notify
          <idle>-0     [001]   475.524969: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [001]   475.524969: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [001]   475.524969: tick_notify <-notifier_call_chain
          <idle>-0     [001]   475.524970: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [001]   475.524970: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.524971: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [001]   475.524971: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [001]   475.524971: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.524972: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.524972: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [001]   475.524973: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [001]   475.524973: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [001]   475.524973: tick_dev_program_event <-tick_program_event
          <idle>-0     [001]   475.524974: ktime_get <-tick_dev_program_event
          <idle>-0     [001]   475.524974: ktime_get_ts <-ktime_get
          <idle>-0     [001]   475.524974: getnstimeofday <-ktime_get_ts
          <idle>-0     [001]   475.524975: read_hpet <-getnstimeofday
          <idle>-0     [001]   475.524975: hpet_readl <-read_hpet
          <idle>-0     [001]   475.524976: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [001]   475.524977: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [001]   475.524977: lapic_next_event <-clockevents_program_event
          <idle>-0     [001]   475.524977: native_apic_mem_write <-lapic_next_event
          <idle>-0     [001]   475.524978: menu_reflect <-cpuidle_idle_call
          <idle>-0     [001]   475.524979: rcu_pending <-cpu_idle
          <idle>-0     [001]   475.524979: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.524984: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.524984: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.524985: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.524985: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.524985: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.524986: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.524986: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.524987: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.524987: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [000]   475.524987: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [000]   475.524990: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [000]   475.524990: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.525019: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.525019: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.525020: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.525020: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.525020: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.525021: hpet_readl <-read_hpet
          <idle>-0     [000]   475.525022: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.525023: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.525023: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.525024: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.525024: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.525024: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.525025: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.525025: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.525025: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.525026: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.525026: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.525027: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [000]   475.525027: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.525027: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.525028: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.525028: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.525028: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.525029: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.525029: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.525030: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.525030: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.525030: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.525031: hpet_readl <-read_hpet
          <idle>-0     [000]   475.525032: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.525032: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.525033: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.525033: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.525034: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.525034: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.525035: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.525035: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.525035: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.525036: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.525036: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.525036: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.525037: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.525037: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.525037: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.525038: hpet_readl <-read_hpet
          <idle>-0     [000]   475.525039: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.525040: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.525040: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.525041: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.525041: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.525041: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.525042: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.525042: hpet_readl <-read_hpet
          <idle>-0     [000]   475.525043: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.525044: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.525044: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.525044: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.525045: menu_select <-cpuidle_idle_call
          <idle>-0     [000]   475.525045: pm_qos_requirement <-menu_select
          <idle>-0     [000]   475.525046: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [000]   475.525046: acpi_idle_enter_c1 <-cpuidle_idle_call
          <idle>-0     [000]   475.525048: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_c1
          <idle>-0     [000]   475.525048: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.530871: smp_apic_timer_interrupt <-apic_timer_interrupt
          <idle>-0     [000]   475.530871: native_apic_mem_write <-smp_apic_timer_interrupt
          <idle>-0     [000]   475.530871: irq_enter <-smp_apic_timer_interrupt
          <idle>-0     [000]   475.530872: tick_check_idle <-irq_enter
          <idle>-0     [000]   475.530872: tick_check_oneshot_broadcast <-tick_check_idle
          <idle>-0     [000]   475.530872: tick_nohz_stop_idle <-tick_check_idle
          <idle>-0     [000]   475.530873: ktime_get <-tick_nohz_stop_idle
          <idle>-0     [000]   475.530873: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530873: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530874: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530874: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530875: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530876: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.530876: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530876: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530877: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530877: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530878: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530879: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.530879: tick_nohz_update_jiffies <-tick_check_idle
          <idle>-0     [000]   475.530880: ktime_get <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.530880: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530880: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530881: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530881: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530882: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530883: tick_do_update_jiffies64 <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.530883: do_timer <-tick_do_update_jiffies64
          <idle>-0     [000]   475.530884: update_wall_time <-do_timer
          <idle>-0     [000]   475.530884: read_hpet <-update_wall_time
          <idle>-0     [000]   475.530884: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530886: update_xtime_cache <-update_wall_time
          <idle>-0     [000]   475.530886: clocksource_get_next <-update_wall_time
          <idle>-0     [000]   475.530887: touch_softlockup_watchdog <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.530887: ktime_get <-tick_check_idle
          <idle>-0     [000]   475.530888: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530888: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530888: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530889: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530890: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530890: tick_nohz_restart <-tick_check_idle
          <idle>-0     [000]   475.530891: hrtimer_cancel <-tick_nohz_restart
          <idle>-0     [000]   475.530891: hrtimer_try_to_cancel <-hrtimer_cancel
          <idle>-0     [000]   475.530891: lock_hrtimer_base <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.530892: __remove_hrtimer <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.530892: hrtimer_forward <-tick_nohz_restart
          <idle>-0     [000]   475.530893: ktime_divns <-hrtimer_forward
          <idle>-0     [000]   475.530893: ktime_add_safe <-hrtimer_forward
          <idle>-0     [000]   475.530893: ktime_add_safe <-hrtimer_forward
          <idle>-0     [000]   475.530894: hrtimer_start_range_ns <-tick_nohz_restart
          <idle>-0     [000]   475.530894: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530895: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530895: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530895: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530896: hrtimer_interrupt <-smp_apic_timer_interrupt
          <idle>-0     [000]   475.530896: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.530897: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530897: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530897: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530898: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530900: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530901: __run_hrtimer <-hrtimer_interrupt
          <idle>-0     [000]   475.530901: __remove_hrtimer <-__run_hrtimer
          <idle>-0     [000]   475.530901: timer_stats_update_stats <-__run_hrtimer
          <idle>-0     [000]   475.530902: hrtimer_wakeup <-__run_hrtimer
          <idle>-0     [000]   475.530906: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.530907: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.530907: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.530907: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530908: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530908: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530908: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530910: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530910: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.530911: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.530911: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.530912: irq_exit <-smp_apic_timer_interrupt
          <idle>-0     [000]   475.530912: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.530913: tick_nohz_restart_sched_tick <-cpu_idle
          <idle>-0     [000]   475.530913: tick_nohz_stop_idle <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   475.530913: ktime_get <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   475.530914: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530914: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530914: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530915: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530916: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530917: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   475.530917: touch_softlockup_watchdog <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   475.530917: tick_nohz_restart <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   475.530918: hrtimer_cancel <-tick_nohz_restart
          <idle>-0     [000]   475.530918: hrtimer_try_to_cancel <-hrtimer_cancel
          <idle>-0     [000]   475.530918: lock_hrtimer_base <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.530919: __remove_hrtimer <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.530919: hrtimer_force_reprogram <-__remove_hrtimer
          <idle>-0     [000]   475.530920: tick_program_event <-hrtimer_force_reprogram
          <idle>-0     [000]   475.530920: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.530920: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.530921: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530921: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530921: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530922: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530923: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530924: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.530924: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.530924: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.530925: hrtimer_forward <-tick_nohz_restart
          <idle>-0     [000]   475.530925: ktime_divns <-hrtimer_forward
          <idle>-0     [000]   475.530926: ktime_add_safe <-hrtimer_forward
          <idle>-0     [000]   475.530926: ktime_add_safe <-hrtimer_forward
          <idle>-0     [000]   475.530926: hrtimer_start_range_ns <-tick_nohz_restart
          <idle>-0     [000]   475.530927: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530927: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530927: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530928: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.530928: hrtimer_reprogram <-enqueue_hrtimer
          <idle>-0     [000]   475.530928: tick_program_event <-hrtimer_reprogram
          <idle>-0     [000]   475.530929: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.530929: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.530929: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.530930: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.530930: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.530930: hpet_readl <-read_hpet
          <idle>-0     [000]   475.530932: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.530932: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.530933: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.530933: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.530935: __switch_to <-schedule
          <idle>-0     [000]   475.530935: math_state_restore <-__switch_to
     firefox-bin-4313  [000]   475.530936: hrtimer_cancel <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   475.530940: hrtimer_try_to_cancel <-hrtimer_cancel
     firefox-bin-4313  [000]   475.530940: lock_hrtimer_base <-hrtimer_try_to_cancel
     firefox-bin-4313  [000]   475.530941: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530941: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530942: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530942: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530943: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530943: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530943: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530944: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530944: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530945: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530945: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530946: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530946: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530946: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530947: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530947: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530947: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530948: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530948: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530949: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530949: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530949: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530950: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530950: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530951: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530951: poll_freewait <-do_sys_poll
     firefox-bin-4313  [000]   475.530951: free_poll_entry <-poll_freewait
     firefox-bin-4313  [000]   475.530952: remove_wait_queue <-free_poll_entry
     firefox-bin-4313  [000]   475.530952: fput <-free_poll_entry
     firefox-bin-4313  [000]   475.530952: free_poll_entry <-poll_freewait
     firefox-bin-4313  [000]   475.530953: remove_wait_queue <-free_poll_entry
     firefox-bin-4313  [000]   475.530953: fput <-free_poll_entry
     firefox-bin-4313  [000]   475.530954: free_poll_entry <-poll_freewait
     firefox-bin-4313  [000]   475.530954: remove_wait_queue <-free_poll_entry
     firefox-bin-4313  [000]   475.530955: fput <-free_poll_entry
     firefox-bin-4313  [000]   475.530955: free_poll_entry <-poll_freewait
     firefox-bin-4313  [000]   475.530955: remove_wait_queue <-free_poll_entry
     firefox-bin-4313  [000]   475.530956: fput <-free_poll_entry
     firefox-bin-4313  [000]   475.530956: free_poll_entry <-poll_freewait
     firefox-bin-4313  [000]   475.530956: remove_wait_queue <-free_poll_entry
     firefox-bin-4313  [000]   475.530957: fput <-free_poll_entry
     firefox-bin-4313  [000]   475.530957: free_poll_entry <-poll_freewait
     firefox-bin-4313  [000]   475.530958: remove_wait_queue <-free_poll_entry
     firefox-bin-4313  [000]   475.530958: fput <-free_poll_entry
     firefox-bin-4313  [000]   475.530958: free_poll_entry <-poll_freewait
     firefox-bin-4313  [000]   475.530959: remove_wait_queue <-free_poll_entry
     firefox-bin-4313  [000]   475.530959: fput <-free_poll_entry
     firefox-bin-4313  [000]   475.530961: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.530962: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530962: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.530962: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.530963: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.530964: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530965: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.530965: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.530968: sys_ioctl <-sysenter_do_call
     firefox-bin-4313  [000]   475.530968: fget_light <-sys_ioctl
     firefox-bin-4313  [000]   475.530969: security_file_ioctl <-sys_ioctl
     firefox-bin-4313  [000]   475.530969: cap_file_ioctl <-security_file_ioctl
     firefox-bin-4313  [000]   475.530970: do_vfs_ioctl <-sys_ioctl
     firefox-bin-4313  [000]   475.530970: vfs_ioctl <-do_vfs_ioctl
     firefox-bin-4313  [000]   475.530970: sock_ioctl <-vfs_ioctl
     firefox-bin-4313  [000]   475.530971: unix_ioctl <-sock_ioctl
     firefox-bin-4313  [000]   475.530971: might_fault <-unix_ioctl
     firefox-bin-4313  [000]   475.530972: fput <-sys_ioctl
     firefox-bin-4313  [000]   475.530973: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.530973: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530974: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.530974: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.530974: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.530976: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530976: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.530977: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.530978: sys_poll <-sysenter_do_call
     firefox-bin-4313  [000]   475.530979: poll_select_set_timeout <-sys_poll
     firefox-bin-4313  [000]   475.530979: do_sys_poll <-sys_poll
     firefox-bin-4313  [000]   475.530979: copy_from_user <-do_sys_poll
     firefox-bin-4313  [000]   475.530980: might_fault <-copy_from_user
     firefox-bin-4313  [000]   475.530980: __copy_from_user_ll <-copy_from_user
     firefox-bin-4313  [000]   475.530981: poll_initwait <-do_sys_poll
     firefox-bin-4313  [000]   475.530981: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530981: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530982: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530982: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530983: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530983: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530983: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530984: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530984: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530984: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530985: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530985: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530986: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530986: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530986: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530987: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530987: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530987: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530988: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.530988: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.530989: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.530989: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.530989: poll_freewait <-do_sys_poll
     firefox-bin-4313  [000]   475.530991: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.530992: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530992: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.530993: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.530993: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.530994: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530995: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.530995: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.530996: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.530996: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530997: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.530997: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.530997: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.530999: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.530999: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.530999: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531001: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531001: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531001: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531002: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531002: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531003: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531004: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531004: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531005: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531005: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531005: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531006: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531006: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531007: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531008: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531008: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531013: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531014: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531014: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531015: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531015: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531016: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531017: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531017: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531018: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531019: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531019: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531019: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531020: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531021: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531021: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531022: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531022: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531023: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531023: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531023: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531024: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531025: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531026: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531026: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531027: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531027: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531028: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531028: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531028: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531030: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531030: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531030: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531031: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531031: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531032: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531032: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531032: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531034: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531034: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531035: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531036: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531036: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531036: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531037: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531037: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531038: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531039: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531039: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531042: sys_ioctl <-sysenter_do_call
     firefox-bin-4313  [000]   475.531042: fget_light <-sys_ioctl
     firefox-bin-4313  [000]   475.531043: security_file_ioctl <-sys_ioctl
     firefox-bin-4313  [000]   475.531043: cap_file_ioctl <-security_file_ioctl
     firefox-bin-4313  [000]   475.531043: do_vfs_ioctl <-sys_ioctl
     firefox-bin-4313  [000]   475.531044: vfs_ioctl <-do_vfs_ioctl
     firefox-bin-4313  [000]   475.531044: sock_ioctl <-vfs_ioctl
     firefox-bin-4313  [000]   475.531044: unix_ioctl <-sock_ioctl
     firefox-bin-4313  [000]   475.531045: might_fault <-unix_ioctl
     firefox-bin-4313  [000]   475.531045: fput <-sys_ioctl
     firefox-bin-4313  [000]   475.531047: sys_gettimeofday <-sysenter_do_call
     firefox-bin-4313  [000]   475.531047: do_gettimeofday <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531047: getnstimeofday <-do_gettimeofday
     firefox-bin-4313  [000]   475.531048: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531048: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531049: copy_to_user <-sys_gettimeofday
     firefox-bin-4313  [000]   475.531050: might_fault <-copy_to_user
     firefox-bin-4313  [000]   475.531050: __copy_to_user_ll <-copy_to_user
     firefox-bin-4313  [000]   475.531052: sys_poll <-sysenter_do_call
     firefox-bin-4313  [000]   475.531055: poll_select_set_timeout <-sys_poll
     firefox-bin-4313  [000]   475.531056: ktime_get_ts <-poll_select_set_timeout
     firefox-bin-4313  [000]   475.531056: getnstimeofday <-ktime_get_ts
     firefox-bin-4313  [000]   475.531056: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531057: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531058: set_normalized_timespec <-ktime_get_ts
     firefox-bin-4313  [000]   475.531059: timespec_add_safe <-poll_select_set_timeout
     firefox-bin-4313  [000]   475.531059: set_normalized_timespec <-timespec_add_safe
     firefox-bin-4313  [000]   475.531059: do_sys_poll <-sys_poll
     firefox-bin-4313  [000]   475.531060: copy_from_user <-do_sys_poll
     firefox-bin-4313  [000]   475.531060: might_fault <-copy_from_user
     firefox-bin-4313  [000]   475.531060: __copy_from_user_ll <-copy_from_user
     firefox-bin-4313  [000]   475.531061: poll_initwait <-do_sys_poll
     firefox-bin-4313  [000]   475.531061: estimate_accuracy <-do_sys_poll
     firefox-bin-4313  [000]   475.531062: ktime_get_ts <-estimate_accuracy
     firefox-bin-4313  [000]   475.531062: getnstimeofday <-ktime_get_ts
     firefox-bin-4313  [000]   475.531062: read_hpet <-getnstimeofday
     firefox-bin-4313  [000]   475.531063: hpet_readl <-read_hpet
     firefox-bin-4313  [000]   475.531064: set_normalized_timespec <-ktime_get_ts
     firefox-bin-4313  [000]   475.531064: set_normalized_timespec <-estimate_accuracy
     firefox-bin-4313  [000]   475.531065: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.531065: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.531066: __pollwait <-pipe_poll
     firefox-bin-4313  [000]   475.531066: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   475.531067: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.531067: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.531067: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.531068: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.531068: __pollwait <-unix_poll
     firefox-bin-4313  [000]   475.531068: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   475.531069: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.531069: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.531070: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.531070: __pollwait <-pipe_poll
     firefox-bin-4313  [000]   475.531071: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   475.531071: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.531072: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.531072: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.531072: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.531073: __pollwait <-unix_poll
     firefox-bin-4313  [000]   475.531073: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   475.531074: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.531074: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.531074: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.531075: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.531075: __pollwait <-unix_poll
     firefox-bin-4313  [000]   475.531076: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   475.531076: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.531077: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.531077: sock_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.531077: unix_poll <-sock_poll
     firefox-bin-4313  [000]   475.531078: __pollwait <-unix_poll
     firefox-bin-4313  [000]   475.531078: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   475.531079: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.531079: fget_light <-do_sys_poll
     firefox-bin-4313  [000]   475.531079: pipe_poll <-do_sys_poll
     firefox-bin-4313  [000]   475.531080: __pollwait <-pipe_poll
     firefox-bin-4313  [000]   475.531080: add_wait_queue <-__pollwait
     firefox-bin-4313  [000]   475.531081: fput <-do_sys_poll
     firefox-bin-4313  [000]   475.531081: hrtimer_init <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   475.531082: ktime_add_safe <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   475.531082: hrtimer_init_sleeper <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   475.531082: hrtimer_start_range_ns <-schedule_hrtimeout_range
     firefox-bin-4313  [000]   475.531083: lock_hrtimer_base <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   475.531083: ktime_add_safe <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   475.531084: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   475.531084: enqueue_hrtimer <-hrtimer_start_range_ns
     firefox-bin-4313  [000]   475.531087: msecs_to_jiffies <-schedule
     firefox-bin-4313  [000]   475.531088: __switch_to <-schedule
          <idle>-0     [000]   475.531089: tick_nohz_stop_sched_tick <-cpu_idle
          <idle>-0     [000]   475.531089: ktime_get <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.531090: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531090: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531090: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531091: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531092: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531093: get_next_timer_interrupt <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.531094: hrtimer_get_next_event <-get_next_timer_interrupt
          <idle>-0     [000]   475.531095: rcu_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.531096: rcu_pending <-rcu_needs_cpu
          <idle>-0     [000]   475.531096: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531096: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531097: printk_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.531097: hrtimer_start <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.531098: hrtimer_start_range_ns <-hrtimer_start
          <idle>-0     [000]   475.531098: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [000]   475.531098: __remove_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.531099: hrtimer_force_reprogram <-__remove_hrtimer
          <idle>-0     [000]   475.531099: tick_program_event <-hrtimer_force_reprogram
          <idle>-0     [000]   475.531099: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.531100: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.531100: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531100: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531101: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531101: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531103: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531103: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.531103: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.531104: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.531104: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [000]   475.531105: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [000]   475.531105: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.531106: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.531106: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531106: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531107: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.531107: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.531107: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.531108: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.531108: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531108: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531109: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531109: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531111: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531111: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.531112: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.531112: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.531112: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531113: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531113: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531113: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531115: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531115: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.531115: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.531116: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.531116: menu_select <-cpuidle_idle_call
          <idle>-0     [000]   475.531117: pm_qos_requirement <-menu_select
          <idle>-0     [000]   475.531117: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [000]   475.531117: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [000]   475.531118: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531118: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.531118: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.531119: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.531119: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.531119: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.531120: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.531120: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.531121: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.531121: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [000]   475.531122: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [000]   475.531124: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531125: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.531144: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531144: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.531144: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531145: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531145: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531145: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531147: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531147: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.531148: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531148: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.531149: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.531149: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.531149: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.531150: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.531150: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.531151: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.531151: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.531151: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [000]   475.531152: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531152: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531152: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531153: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531153: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.531154: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.531154: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.531154: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531155: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531155: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531155: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531157: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531157: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.531157: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.531158: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.531159: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.531159: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.531159: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531160: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531160: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.531160: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.531161: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.531161: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.531161: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531162: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531162: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531162: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531164: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531165: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.531165: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.531165: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.531166: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531166: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531166: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531167: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531168: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531169: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.531169: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.531169: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.531170: menu_select <-cpuidle_idle_call
          <idle>-0     [000]   475.531170: pm_qos_requirement <-menu_select
          <idle>-0     [000]   475.531170: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [000]   475.531171: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [000]   475.531171: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531174: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.531175: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.531175: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.531175: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.531176: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.531176: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.531177: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.531177: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.531177: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [000]   475.531178: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [000]   475.531180: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531181: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.531210: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531210: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.531210: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531211: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531211: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531211: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531213: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531213: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.531214: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.531214: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.531215: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.531215: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.531215: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.531216: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.531216: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.531217: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.531217: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.531217: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [000]   475.531218: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531218: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531218: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531219: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.531219: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.531220: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.531220: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.531220: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531220: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531221: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531221: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531223: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531223: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.531223: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.531224: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.531224: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.531225: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.531225: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531225: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.531226: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.531226: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.531227: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.531227: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.531227: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531228: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531228: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531228: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531230: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531230: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.531231: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.531231: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.531231: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.531232: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.531232: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.531232: hpet_readl <-read_hpet
          <idle>-0     [000]   475.531234: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.531234: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.531235: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.531235: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.531235: menu_select <-cpuidle_idle_call
          <idle>-0     [000]   475.531236: pm_qos_requirement <-menu_select
          <idle>-0     [000]   475.531236: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [000]   475.531237: acpi_idle_enter_c1 <-cpuidle_idle_call
          <idle>-0     [000]   475.531239: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_c1
          <idle>-0     [000]   475.531239: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.532829: do_IRQ <-common_interrupt
          <idle>-0     [000]   475.532830: irq_enter <-do_IRQ
          <idle>-0     [000]   475.532830: tick_check_idle <-irq_enter
          <idle>-0     [000]   475.532830: tick_check_oneshot_broadcast <-tick_check_idle
          <idle>-0     [000]   475.532831: tick_nohz_stop_idle <-tick_check_idle
          <idle>-0     [000]   475.532831: ktime_get <-tick_nohz_stop_idle
          <idle>-0     [000]   475.532831: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532831: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532832: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532832: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532834: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532834: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.532834: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532835: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532835: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532835: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532837: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532837: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.532838: tick_nohz_update_jiffies <-tick_check_idle
          <idle>-0     [000]   475.532838: ktime_get <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.532838: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532839: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532839: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532839: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532841: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532841: tick_do_update_jiffies64 <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.532842: do_timer <-tick_do_update_jiffies64
          <idle>-0     [000]   475.532842: update_wall_time <-do_timer
          <idle>-0     [000]   475.532842: read_hpet <-update_wall_time
          <idle>-0     [000]   475.532843: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532844: update_xtime_cache <-update_wall_time
          <idle>-0     [000]   475.532844: clocksource_get_next <-update_wall_time
          <idle>-0     [000]   475.532845: touch_softlockup_watchdog <-tick_nohz_update_jiffies
          <idle>-0     [000]   475.532845: ktime_get <-tick_check_idle
          <idle>-0     [000]   475.532846: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532846: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532846: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532847: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532848: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532849: tick_nohz_restart <-tick_check_idle
          <idle>-0     [000]   475.532849: hrtimer_cancel <-tick_nohz_restart
          <idle>-0     [000]   475.532849: hrtimer_try_to_cancel <-hrtimer_cancel
          <idle>-0     [000]   475.532849: lock_hrtimer_base <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.532850: __remove_hrtimer <-hrtimer_try_to_cancel
          <idle>-0     [000]   475.532850: hrtimer_forward <-tick_nohz_restart
          <idle>-0     [000]   475.532851: ktime_add_safe <-hrtimer_forward
          <idle>-0     [000]   475.532851: ktime_add_safe <-hrtimer_forward
          <idle>-0     [000]   475.532852: hrtimer_start_range_ns <-tick_nohz_restart
          <idle>-0     [000]   475.532852: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532852: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532853: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532853: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532854: hrtimer_reprogram <-enqueue_hrtimer
          <idle>-0     [000]   475.532854: tick_program_event <-hrtimer_reprogram
          <idle>-0     [000]   475.532854: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.532855: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.532855: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532855: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532856: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532856: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532857: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532858: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.532858: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.532858: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.532859: handle_edge_irq <-do_IRQ
          <idle>-0     [000]   475.532860: ack_apic_edge <-handle_edge_irq
          <idle>-0     [000]   475.532860: irq_complete_move <-ack_apic_edge
          <idle>-0     [000]   475.532860: irq_cfg <-irq_complete_move
          <idle>-0     [000]   475.532861: move_native_irq <-ack_apic_edge
          <idle>-0     [000]   475.532861: native_apic_mem_write <-ack_apic_edge
          <idle>-0     [000]   475.532861: handle_IRQ_event <-handle_edge_irq
          <idle>-0     [000]   475.532862: timer_interrupt <-handle_IRQ_event
          <idle>-0     [000]   475.532862: tick_handle_oneshot_broadcast <-timer_interrupt
          <idle>-0     [000]   475.532863: ktime_get <-tick_handle_oneshot_broadcast
          <idle>-0     [000]   475.532863: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532863: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532864: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532864: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532865: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532866: tick_do_broadcast <-tick_handle_oneshot_broadcast
          <idle>-0     [000]   475.532866: tick_broadcast_set_event <-tick_handle_oneshot_broadcast
          <idle>-0     [000]   475.532867: tick_dev_program_event <-tick_broadcast_set_event
          <idle>-0     [000]   475.532867: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.532867: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532868: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532868: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532868: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532870: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532870: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.532870: hpet_legacy_next_event <-clockevents_program_event
          <idle>-0     [000]   475.532871: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.532872: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.532874: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.532875: note_interrupt <-handle_edge_irq
          <idle>-0     [000]   475.532876: irq_exit <-do_IRQ
          <idle>-0     [000]   475.532876: tick_nohz_stop_sched_tick <-irq_exit
          <idle>-0     [000]   475.532877: ktime_get <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.532877: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532877: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532878: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532878: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532879: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532880: get_next_timer_interrupt <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.532882: hrtimer_get_next_event <-get_next_timer_interrupt
          <idle>-0     [000]   475.532882: rcu_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.532882: rcu_pending <-rcu_needs_cpu
          <idle>-0     [000]   475.532883: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.532883: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.532883: printk_needs_cpu <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.532884: hrtimer_start <-tick_nohz_stop_sched_tick
          <idle>-0     [000]   475.532884: hrtimer_start_range_ns <-hrtimer_start
          <idle>-0     [000]   475.532885: lock_hrtimer_base <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532885: __remove_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532885: hrtimer_force_reprogram <-__remove_hrtimer
          <idle>-0     [000]   475.532886: tick_program_event <-hrtimer_force_reprogram
          <idle>-0     [000]   475.532886: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.532886: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.532887: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532887: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532887: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532888: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532889: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532890: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.532890: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.532890: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.532891: ktime_add_safe <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532891: __timer_stats_hrtimer_set_start_info <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532891: enqueue_hrtimer <-hrtimer_start_range_ns
          <idle>-0     [000]   475.532892: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.532896: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.532896: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.532896: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.532897: cpuidle_idle_call <-cpu_idle
          <idle>-0     [000]   475.532897: hrtimer_peek_ahead_timers <-cpuidle_idle_call
          <idle>-0     [000]   475.532898: hrtimer_interrupt <-hrtimer_peek_ahead_timers
          <idle>-0     [000]   475.532898: ktime_get <-hrtimer_interrupt
          <idle>-0     [000]   475.532898: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532899: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532899: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532899: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532901: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532901: tick_program_event <-hrtimer_interrupt
          <idle>-0     [000]   475.532902: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.532902: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.532902: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532903: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532903: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532903: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532905: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532905: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.532905: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.532906: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.532906: menu_select <-cpuidle_idle_call
          <idle>-0     [000]   475.532907: pm_qos_requirement <-menu_select
          <idle>-0     [000]   475.532907: tick_nohz_get_sleep_length <-menu_select
          <idle>-0     [000]   475.532907: acpi_idle_enter_simple <-cpuidle_idle_call
          <idle>-0     [000]   475.532908: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.532908: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.532908: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.532909: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.532909: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.532909: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.532910: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.532910: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.532911: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.532911: native_apic_mem_read <-lapic_timer_setup
          <idle>-0     [000]   475.532912: native_apic_mem_write <-lapic_timer_setup
          <idle>-0     [000]   475.532912: tick_broadcast_set_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.532912: tick_dev_program_event <-tick_broadcast_set_event
          <idle>-0     [000]   475.532913: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.532913: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532913: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532914: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532914: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532915: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532916: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.532916: hpet_legacy_next_event <-clockevents_program_event
          <idle>-0     [000]   475.532916: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.532918: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.532919: hpet_readl <-hpet_legacy_next_event
          <idle>-0     [000]   475.532923: acpi_processor_ffh_cstate_enter <-acpi_idle_enter_simple
          <idle>-0     [000]   475.532923: mwait_idle_with_hints <-acpi_processor_ffh_cstate_enter
          <idle>-0     [000]   475.532942: tsc_halts_in_c <-acpi_idle_enter_simple
          <idle>-0     [000]   475.532943: ktime_get <-sched_clock_tick
          <idle>-0     [000]   475.532943: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532943: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532944: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532944: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532945: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532946: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
          <idle>-0     [000]   475.532946: acpi_state_timer_broadcast <-acpi_idle_enter_simple
          <idle>-0     [000]   475.532947: clockevents_notify <-acpi_state_timer_broadcast
          <idle>-0     [000]   475.532947: clockevents_do_notify <-clockevents_notify
          <idle>-0     [000]   475.532948: raw_notifier_call_chain <-clockevents_do_notify
          <idle>-0     [000]   475.532948: __raw_notifier_call_chain <-raw_notifier_call_chain
          <idle>-0     [000]   475.532948: tick_notify <-notifier_call_chain
          <idle>-0     [000]   475.532949: tick_broadcast_oneshot_control <-tick_notify
          <idle>-0     [000]   475.532949: clockevents_set_mode <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.532950: lapic_timer_setup <-clockevents_set_mode
          <idle>-0     [000]   475.532950: __setup_APIC_LVTT <-lapic_timer_setup
          <idle>-0     [000]   475.532950: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.532951: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.532951: native_apic_mem_read <-__setup_APIC_LVTT
          <idle>-0     [000]   475.532951: native_apic_mem_write <-__setup_APIC_LVTT
          <idle>-0     [000]   475.532952: tick_program_event <-tick_broadcast_oneshot_control
          <idle>-0     [000]   475.532952: tick_dev_program_event <-tick_program_event
          <idle>-0     [000]   475.532952: ktime_get <-tick_dev_program_event
          <idle>-0     [000]   475.532953: ktime_get_ts <-ktime_get
          <idle>-0     [000]   475.532953: getnstimeofday <-ktime_get_ts
          <idle>-0     [000]   475.532953: read_hpet <-getnstimeofday
          <idle>-0     [000]   475.532954: hpet_readl <-read_hpet
          <idle>-0     [000]   475.532955: set_normalized_timespec <-ktime_get_ts
          <idle>-0     [000]   475.532955: clockevents_program_event <-tick_dev_program_event
          <idle>-0     [000]   475.532956: lapic_next_event <-clockevents_program_event
          <idle>-0     [000]   475.532956: native_apic_mem_write <-lapic_next_event
          <idle>-0     [000]   475.532957: menu_reflect <-cpuidle_idle_call
          <idle>-0     [000]   475.532957: rcu_pending <-cpu_idle
          <idle>-0     [000]   475.532958: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.532958: __rcu_pending <-rcu_pending
          <idle>-0     [000]   475.532958: cpuidle_idle_call <-cpu_idle

--------------080203060400060009090106
Content-Type: text/x-log;
 name="machin.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="machin.log"

----Root (Nowhere)
     |----copy_to_user
     |    |----__copy_to_user_ll (463.031395)
     |----sysenter_do_call
     |    |----sys_gettimeofday (463.031396)
     |    |    |----do_gettimeofday (463.031397)
     |    |    |    |----getnstimeofday (463.031397)
     |    |    |         |----read_hpet (463.031397)
     |    |    |              |----hpet_readl (463.031398)
     |    |    |----copy_to_user (463.031399)
     |    |         |----might_fault (463.031399)
     |    |         |----__copy_to_user_ll (463.031400)
     |    |----sys_gettimeofday (463.031401)
     |    |    |----do_gettimeofday (463.031401)
     |    |    |    |----getnstimeofday (463.031401)
     |    |    |         |----read_hpet (463.031402)
     |    |    |              |----hpet_readl (463.031402)
     |    |    |----copy_to_user (463.031403)
     |    |         |----might_fault (463.031404)
     |    |         |----__copy_to_user_ll (463.031404)
     |    |----sys_gettimeofday (463.031405)
     |    |    |----do_gettimeofday (463.031405)
     |    |    |    |----getnstimeofday (463.031406)
     |    |    |         |----read_hpet (463.031406)
     |    |    |              |----hpet_readl (463.031406)
     |    |    |----copy_to_user (463.031408)
     |    |         |----might_fault (463.031408)
     |    |         |----__copy_to_user_ll (463.031408)
     |    |----sys_gettimeofday (463.031409)
     |    |    |----do_gettimeofday (463.031410)
     |    |    |    |----getnstimeofday (463.031410)
     |    |    |         |----read_hpet (463.031410)
     |    |    |              |----hpet_readl (463.031411)
     |    |    |----copy_to_user (463.031412)
     |    |         |----might_fault (463.031412)
     |    |         |----__copy_to_user_ll (463.031413)
     |    |----sys_gettimeofday (463.031414)
     |    |    |----do_gettimeofday (463.031414)
     |    |    |    |----getnstimeofday (463.031414)
     |    |    |         |----read_hpet (463.031415)
     |    |    |              |----hpet_readl (463.031415)
     |    |    |----copy_to_user (463.031416)
     |    |         |----might_fault (463.031417)
     |    |         |----__copy_to_user_ll (463.031417)
     |    |----sys_gettimeofday (463.031418)
     |    |    |----do_gettimeofday (463.031418)
     |    |    |    |----getnstimeofday (463.031419)
     |    |    |         |----read_hpet (463.031419)
     |    |    |              |----hpet_readl (463.031419)
     |    |    |----copy_to_user (463.031421)
     |    |         |----might_fault (463.031421)
     |    |         |----__copy_to_user_ll (463.031422)
     |    |----sys_gettimeofday (463.031422)
     |    |    |----do_gettimeofday (463.031423)
     |    |    |    |----getnstimeofday (463.031423)
     |    |    |         |----read_hpet (463.031423)
     |    |    |              |----hpet_readl (463.031424)
     |    |    |----copy_to_user (463.031425)
     |    |         |----might_fault (463.031426)
     |    |         |----__copy_to_user_ll (463.031426)
     |    |----sys_gettimeofday (463.031427)
     |    |    |----do_gettimeofday (463.031427)
     |    |    |    |----getnstimeofday (463.031427)
     |    |    |         |----read_hpet (463.031428)
     |    |    |              |----hpet_readl (463.031428)
     |    |    |----copy_to_user (463.031430)
     |    |         |----might_fault (463.031430)
     |    |         |----__copy_to_user_ll (463.031430)
     |    |----sys_gettimeofday (463.031431)
     |    |    |----do_gettimeofday (463.031432)
     |    |    |    |----getnstimeofday (463.031432)
     |    |    |         |----read_hpet (463.031432)
     |    |    |              |----hpet_readl (463.031432)
     |    |    |----copy_to_user (463.031434)
     |    |         |----might_fault (463.031434)
     |    |         |----__copy_to_user_ll (463.031435)
     |    |----sys_gettimeofday (463.031436)
     |    |    |----do_gettimeofday (463.031436)
     |    |    |    |----getnstimeofday (463.031436)
     |    |    |         |----read_hpet (463.031436)
     |    |    |              |----hpet_readl (463.031437)
     |    |    |----copy_to_user (463.031438)
     |    |         |----might_fault (463.031439)
     |    |         |----__copy_to_user_ll (463.031439)
     |    |----sys_gettimeofday (463.031440)
     |    |    |----do_gettimeofday (463.031440)
     |    |    |    |----getnstimeofday (463.031441)
     |    |    |         |----read_hpet (463.031441)
     |    |    |              |----hpet_readl (463.031441)
     |    |    |----copy_to_user (463.031443)
     |    |         |----might_fault (463.031443)
     |    |         |----__copy_to_user_ll (463.031443)
     |    |----sys_gettimeofday (463.031444)
     |    |    |----do_gettimeofday (463.031445)
     |    |    |    |----getnstimeofday (463.031445)
     |    |    |         |----read_hpet (463.031445)
     |    |    |              |----hpet_readl (463.031446)
     |    |    |----copy_to_user (463.031447)
     |    |         |----might_fault (463.031447)
     |    |         |----__copy_to_user_ll (463.031448)
     |    |----sys_gettimeofday (463.031449)
     |    |    |----do_gettimeofday (463.031449)
     |    |    |    |----getnstimeofday (463.031449)
     |    |    |         |----read_hpet (463.031450)
     |    |    |              |----hpet_readl (463.031450)
     |    |    |----copy_to_user (463.031452)
     |    |         |----might_fault (463.031452)
     |    |         |----__copy_to_user_ll (463.031452)
     |    |----sys_gettimeofday (463.031453)
     |    |    |----do_gettimeofday (463.031454)
     |    |    |    |----getnstimeofday (463.031454)
     |    |    |         |----read_hpet (463.031454)
     |    |    |              |----hpet_readl (463.031454)
     |    |    |----copy_to_user (463.031456)
     |    |         |----might_fault (463.031456)
     |    |         |----__copy_to_user_ll (463.031457)
     |    |----sys_gettimeofday (463.031458)
     |    |    |----do_gettimeofday (463.031458)
     |    |    |    |----getnstimeofday (463.031458)
     |    |    |         |----read_hpet (463.031459)
     |    |    |              |----hpet_readl (463.031459)
     |    |    |----copy_to_user (463.031460)
     |    |         |----might_fault (463.031461)
     |    |         |----__copy_to_user_ll (463.031461)
     |    |----sys_gettimeofday (463.031462)
     |    |    |----do_gettimeofday (463.031462)
     |    |    |    |----getnstimeofday (463.031463)
     |    |    |         |----read_hpet (463.031463)
     |    |    |              |----hpet_readl (463.031463)
     |    |    |----copy_to_user (463.031465)
     |    |         |----might_fault (463.031465)
     |    |         |----__copy_to_user_ll (463.031465)
     |    |----sys_gettimeofday (463.031466)
     |    |    |----do_gettimeofday (463.031467)
     |    |    |    |----getnstimeofday (463.031467)
     |    |    |         |----read_hpet (463.031467)
     |    |    |              |----hpet_readl (463.031468)
     |    |    |----copy_to_user (463.031469)
     |    |         |----might_fault (463.031469)
     |    |         |----__copy_to_user_ll (463.031470)
     |    |----sys_gettimeofday (463.031471)
     |         |----do_gettimeofday (463.031471)
     |              |----getnstimeofday (463.031471)
     |                   |----read_hpet (463.031472)
     |                        |----hpet_readl (463.031472)
     |----do_sys_poll
     |    |----fget_light (463.071408)
     |    |----sock_poll (463.071409)
     |    |    |----unix_poll (463.071409)
     |    |         |----__pollwait (463.071409)
     |    |              |----add_wait_queue (463.071410)
     |    |----fput (463.071410)
     |    |----fget_light (463.071411)
     |    |----sock_poll (463.071411)
     |    |    |----unix_poll (463.071411)
     |    |         |----__pollwait (463.071412)
     |    |              |----add_wait_queue (463.071412)
     |    |----fput (463.071413)
     |    |----fget_light (463.071413)
     |    |----pipe_poll (463.071413)
     |    |    |----__pollwait (463.071414)
     |    |         |----add_wait_queue (463.071414)
     |    |----fput (463.071415)
     |----schedule_hrtimeout_range
     |    |----hrtimer_init (463.071415)
     |    |----ktime_add_safe (463.071416)
     |    |----hrtimer_init_sleeper (463.071416)
     |    |----hrtimer_start_range_ns (463.071416)
     |         |----lock_hrtimer_base (463.071417)
     |         |----ktime_add_safe (463.071417)
     |         |----__timer_stats_hrtimer_set_start_info (463.071417)
     |         |----enqueue_hrtimer (463.071418)
     |----schedule
     |    |----__switch_to (463.071421)
     |         |----__switch_to_xtra (463.071422)
     |----do_device_not_available
     |    |----math_state_restore (463.071424)
     |----sysenter_do_call
     |    |----sys_select (463.071697)
     |         |----copy_from_user (463.071697)
     |         |    |----might_fault (463.071698)
     |         |    |----__copy_from_user_ll (463.071698)
     |         |----poll_select_set_timeout (463.071699)
     |         |----core_sys_select (463.071699)
     |         |    |----copy_from_user (463.071700)
     |         |    |    |----might_fault (463.071700)
     |         |    |    |----__copy_from_user_ll (463.071700)
     |         |    |----do_select (463.071701)
     |         |    |    |----poll_initwait (463.071702)
     |         |    |    |----fget_light (463.071703)
     |         |    |    |----sock_poll (463.071703)
     |         |    |    |    |----unix_poll (463.071704)
     |         |    |    |----fget_light (463.071704)
     |         |    |    |----sock_poll (463.071705)
     |         |    |    |    |----unix_poll (463.071705)
     |         |    |    |----fget_light (463.071706)
     |         |    |    |----tty_poll (463.071706)
     |         |    |    |    |----tty_paranoia_check (463.071707)
     |         |    |    |    |----tty_ldisc_ref_wait (463.071707)
     |         |    |    |    |    |----tty_ldisc_try (463.071708)
     |         |    |    |    |----n_tty_poll (463.071709)
     |         |    |    |    |    |----tty_hung_up_p (463.071709)
     |         |    |    |    |    |----tty_chars_in_buffer (463.071710)
     |         |    |    |    |    |    |----con_chars_in_buffer (463.071710)
     |         |    |    |    |    |----tty_write_room (463.071710)
     |         |    |    |    |         |----con_write_room (463.071711)
     |         |    |    |    |----tty_ldisc_deref (463.071711)
     |         |    |    |----fget_light (463.071712)
     |         |    |    |----sock_poll (463.071712)
     |         |    |    |    |----unix_poll (463.071713)
     |         |    |    |----fget_light (463.071713)
     |         |    |    |----sock_poll (463.071714)
     |         |    |    |    |----unix_poll (463.071714)
     |         |    |    |----fget_light (463.071715)
     |         |    |    |----sock_poll (463.071715)
     |         |    |    |    |----unix_poll (463.071715)
     |         |    |    |----fget_light (463.071716)
     |         |    |    |----sock_poll (463.071716)
     |         |    |    |    |----unix_poll (463.071717)
     |         |    |    |----fget_light (463.071717)
     |         |    |    |----sock_poll (463.071718)
     |         |    |    |    |----unix_poll (463.071718)
     |         |    |    |----fget_light (463.071718)
     |         |    |    |----sock_poll (463.071719)
     |         |    |    |    |----unix_poll (463.071719)
     |         |    |    |----fget_light (463.071719)
     |         |    |    |----sock_poll (463.071720)
     |         |    |    |    |----unix_poll (463.071721)
     |         |    |    |----fget_light (463.071721)
     |         |    |    |----sock_poll (463.071721)
     |         |    |    |    |----unix_poll (463.071722)
     |         |    |    |----fget_light (463.071722)
     |         |    |    |----sock_poll (463.071723)
     |         |    |    |    |----unix_poll (463.071723)
     |         |    |    |----fget_light (463.071724)
     |         |    |    |----sock_poll (463.071724)
     |         |    |    |    |----unix_poll (463.071724)
     |         |    |    |----fget_light (463.071725)
     |         |    |    |----sock_poll (463.071725)
     |         |    |    |    |----unix_poll (463.071726)
     |         |    |    |----fget_light (463.071726)
     |         |    |    |----sock_poll (463.071726)
     |         |    |    |    |----unix_poll (463.071727)
     |         |    |    |----fget_light (463.071727)
     |         |    |    |----sock_poll (463.071728)
     |         |    |    |    |----unix_poll (463.071728)
     |         |    |    |----fget_light (463.071729)
     |         |    |    |----sock_poll (463.071729)
     |         |    |    |    |----unix_poll (463.071729)
     |         |    |    |----fget_light (463.071730)
     |         |    |    |----sock_poll (463.071730)
     |         |    |    |    |----unix_poll (463.071731)
     |         |    |    |----fget_light (463.071731)
     |         |    |    |----sock_poll (463.071731)
     |         |    |    |    |----unix_poll (463.071732)
     |         |    |    |----fget_light (463.071732)
     |         |    |    |----sock_poll (463.071733)
     |         |    |    |    |----unix_poll (463.071733)
     |         |    |    |----fget_light (463.071733)
     |         |    |    |----sock_poll (463.071734)
     |         |    |    |    |----unix_poll (463.071734)
     |         |    |    |----poll_freewait (463.071735)
     |         |    |----might_fault (463.071735)
     |         |    |----__copy_to_user_ll (463.071735)
     |         |----poll_select_copy_remaining (463.071736)
     |----apic_timer_interrupt
     |    |----smp_apic_timer_interrupt (463.072435)
     |         |----native_apic_mem_write (463.072436)
     |         |----irq_enter (463.072436)
     |         |----hrtimer_interrupt (463.072437)
     |              |----ktime_get (463.072437)
     |              |    |----ktime_get_ts (463.072437)
     |              |         |----getnstimeofday (463.072438)
     |              |         |    |----read_hpet (463.072438)
     |              |         |         |----hpet_readl (463.072438)
     |              |         |----set_normalized_timespec (463.072440)
     |              |----__run_hrtimer (463.072441)
     |                   |----__remove_hrtimer (463.072442)
     |                   |----timer_stats_update_stats (463.072442)
     |                   |----tick_sched_timer (463.072442)
     |                        |----ktime_get (463.072443)
     |                        |    |----ktime_get_ts (463.072443)
     |                        |         |----getnstimeofday (463.072443)
     |                        |         |    |----read_hpet (463.072444)
     |                        |         |         |----hpet_readl (463.072444)
     |                        |         |----set_normalized_timespec (463.072446)
     |                        |----tick_do_update_jiffies64 (463.072446)
     |                        |    |----do_timer (463.072446)
     |                        |         |----update_wall_time (463.072447)
     |                        |              |----read_hpet (463.072447)
     |                        |              |    |----hpet_readl (463.072447)
     |                        |              |----update_xtime_cache (463.072449)
     |                        |              |----clocksource_get_next (463.072449)
     |                        |----update_process_times (463.072450)
     |                             |----account_process_tick (463.072451)
     |                             |----run_local_timers (463.072451)
     |                             |    |----hrtimer_run_queues (463.072451)
     |                             |    |----raise_softirq (463.072452)
     |                             |    |----softlockup_tick (463.072452)
     |                             |         |----get_timestamp (463.072453)
     |                             |----rcu_pending (463.072453)
     |                             |    |----__rcu_pending (463.072454)
     |                             |    |----__rcu_pending (463.072454)
     |                             |----printk_tick (463.072454)
     |----sched_clock_tick
     |    |----ktime_get (463.072455)
     |         |----ktime_get_ts (463.072455)
     |              |----getnstimeofday (463.072455)
     |              |    |----read_hpet (463.072456)
     |              |         |----hpet_readl (463.072456)
     |              |----set_normalized_timespec (463.072458)
     |----update_process_times
     |    |----run_posix_cpu_timers (463.072459)
     |----tick_sched_timer
     |    |----profile_tick (463.072460)
     |    |----hrtimer_forward (463.072460)
     |         |----ktime_add_safe (463.072460)
     |         |----ktime_add_safe (463.072461)
     |----__run_hrtimer
     |    |----enqueue_hrtimer (463.072461)
     |----hrtimer_interrupt
     |    |----tick_program_event (463.072462)
     |         |----tick_dev_program_event (463.072462)
     |              |----ktime_get (463.072463)
     |              |    |----ktime_get_ts (463.072463)
     |              |         |----getnstimeofday (463.072463)
     |              |         |    |----read_hpet (463.072464)
     |              |         |         |----hpet_readl (463.072464)
     |              |         |----set_normalized_timespec (463.072465)
     |              |----clockevents_program_event (463.072466)
     |                   |----lapic_next_event (463.072466)
     |                        |----native_apic_mem_write (463.072467)
     |----smp_apic_timer_interrupt
     |    |----irq_exit (463.072467)
     |         |----do_softirq (463.072467)
     |              |----__do_softirq (463.072468)
     |                   |----__local_bh_disable (463.072468)
     |                   |----run_timer_softirq (463.072469)
     |                   |    |----hrtimer_run_pending (463.072469)
     |                   |----_local_bh_enable (463.072470)
     |----apic_timer_interrupt
     |    |----smp_apic_timer_interrupt (463.076430)
     |         |----native_apic_mem_write (463.076431)
     |         |----irq_enter (463.076431)
     |         |----hrtimer_interrupt (463.076431)
     |              |----ktime_get (463.076432)
     |              |    |----ktime_get_ts (463.076432)
     |              |         |----getnstimeofday (463.076433)
     |              |         |    |----read_hpet (463.076433)
     |              |         |         |----hpet_readl (463.076433)
     |              |         |----set_normalized_timespec (463.076435)
     |              |----__run_hrtimer (463.076436)
     |                   |----__remove_hrtimer (463.076436)
     |                   |----timer_stats_update_stats (463.076437)
     |                   |----tick_sched_timer (463.076437)
     |                        |----ktime_get (463.076437)
     |                        |    |----ktime_get_ts (463.076438)
     |                        |         |----getnstimeofday (463.076438)
     |                        |         |    |----read_hpet (463.076438)
     |                        |         |         |----hpet_readl (463.076439)
     |                        |         |----set_normalized_timespec (463.076440)
     |                        |----tick_do_update_jiffies64 (463.076440)
     |----sched_clock_tick
     |    |----ktime_get (475.329280)
     |         |----ktime_get_ts (475.329280)
     |              |----getnstimeofday (475.329281)
     |              |    |----read_hpet (475.329281)
     |              |         |----hpet_readl (475.329281)
     |              |----set_normalized_timespec (475.329283)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.329283)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.329284)
     |         |----clockevents_notify (475.329284)
     |----_raw_spin_lock
     |    |----__delay (475.329285)
     |    |    |----delay_tsc (475.329285)
     |    |----__delay (475.329286)
     |    |    |----delay_tsc (475.329286)
     |    |----__delay (475.329286)
     |    |    |----delay_tsc (475.329287)
     |    |----__delay (475.329287)
     |    |    |----delay_tsc (475.329287)
     |    |----__delay (475.329288)
     |    |    |----delay_tsc (475.329288)
     |    |----__delay (475.329289)
     |         |----delay_tsc (475.329289)
     |----clockevents_notify
     |    |----clockevents_do_notify (475.329290)
     |         |----raw_notifier_call_chain (475.329290)
     |              |----__raw_notifier_call_chain (475.329290)
     |----notifier_call_chain
     |    |----tick_notify (475.329290)
     |         |----tick_broadcast_oneshot_control (475.329291)
     |              |----clockevents_set_mode (475.329291)
     |              |    |----lapic_timer_setup (475.329292)
     |              |         |----__setup_APIC_LVTT (475.329292)
     |              |              |----native_apic_mem_read (475.329292)
     |              |              |----native_apic_mem_write (475.329293)
     |              |              |----native_apic_mem_read (475.329293)
     |              |              |----native_apic_mem_write (475.329293)
     |              |----tick_program_event (475.329294)
     |                   |----tick_dev_program_event (475.329294)
     |                        |----ktime_get (475.329294)
     |                        |    |----ktime_get_ts (475.329295)
     |                        |         |----getnstimeofday (475.329295)
     |                        |         |    |----read_hpet (475.329295)
     |                        |         |         |----hpet_readl (475.329296)
     |                        |         |----set_normalized_timespec (475.329297)
     |                        |----clockevents_program_event (475.329298)
     |                             |----lapic_next_event (475.329298)
     |                                  |----native_apic_mem_write (475.329298)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.329299)
     |----cpu_idle
     |    |----rcu_pending (475.329300)
     |    |    |----__rcu_pending (475.329300)
     |    |    |----__rcu_pending (475.329300)
     |    |----cpuidle_idle_call (475.329301)
     |         |----hrtimer_peek_ahead_timers (475.329301)
     |         |    |----hrtimer_interrupt (475.329301)
     |         |         |----ktime_get (475.329302)
     |         |         |    |----ktime_get_ts (475.329302)
     |         |         |         |----getnstimeofday (475.329302)
     |         |         |         |    |----read_hpet (475.329303)
     |         |         |         |         |----hpet_readl (475.329303)
     |         |         |         |----set_normalized_timespec (475.329304)
     |         |         |----tick_program_event (475.329305)
     |         |              |----tick_dev_program_event (475.329306)
     |         |                   |----ktime_get (475.329306)
     |         |                   |    |----ktime_get_ts (475.329306)
     |         |                   |         |----getnstimeofday (475.329307)
     |         |                   |         |    |----read_hpet (475.329307)
     |         |                   |         |         |----hpet_readl (475.329307)
     |         |                   |         |----set_normalized_timespec (475.329309)
     |         |                   |----clockevents_program_event (475.329309)
     |         |                        |----lapic_next_event (475.329309)
     |         |                             |----native_apic_mem_write (475.329310)
     |         |----menu_select (475.329310)
     |         |    |----pm_qos_requirement (475.329310)
     |         |    |----tick_nohz_get_sleep_length (475.329311)
     |         |----acpi_idle_enter_simple (475.329311)
     |              |----acpi_state_timer_broadcast (475.329312)
     |                   |----clockevents_notify (475.329312)
     |                        |----clockevents_do_notify (475.329312)
     |                             |----raw_notifier_call_chain (475.329313)
     |                                  |----__raw_notifier_call_chain (475.329313)
     |----notifier_call_chain
     |    |----tick_notify (475.329313)
     |         |----tick_broadcast_oneshot_control (475.329314)
     |              |----clockevents_set_mode (475.329314)
     |                   |----lapic_timer_setup (475.329314)
     |                        |----native_apic_mem_read (475.329315)
     |                        |----native_apic_mem_write (475.329315)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.329318)
     |    |    |----mwait_idle_with_hints (475.329318)
     |    |----tsc_halts_in_c (475.335374)
     |----sched_clock_tick
     |    |----ktime_get (475.335375)
     |         |----ktime_get_ts (475.335375)
     |              |----getnstimeofday (475.335376)
     |              |    |----read_hpet (475.335376)
     |              |         |----hpet_readl (475.335376)
     |              |----set_normalized_timespec (475.335378)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.335378)
     |----common_interrupt
     |    |----do_IRQ (475.335379)
     |         |----irq_enter (475.335379)
     |              |----tick_check_idle (475.335380)
     |                   |----tick_check_oneshot_broadcast (475.335380)
     |                   |    |----clockevents_set_mode (475.335381)
     |                   |         |----lapic_timer_setup (475.335381)
     |                   |              |----__setup_APIC_LVTT (475.335381)
     |                   |                   |----native_apic_mem_read (475.335382)
     |                   |                   |----native_apic_mem_write (475.335382)
     |                   |                   |----native_apic_mem_read (475.335382)
     |                   |                   |----native_apic_mem_write (475.335383)
     |                   |----tick_nohz_stop_idle (475.335383)
     |                        |----ktime_get (475.335383)
     |                             |----ktime_get_ts (475.335384)
     |                                  |----getnstimeofday (475.335384)
     |                                  |    |----read_hpet (475.335384)
     |                                  |         |----hpet_readl (475.335385)
     |                                  |----set_normalized_timespec (475.335386)
     |----sched_clock_tick
     |    |----ktime_get (475.335387)
     |         |----ktime_get_ts (475.335387)
     |              |----getnstimeofday (475.335387)
     |              |    |----read_hpet (475.335388)
     |              |         |----hpet_readl (475.335388)
     |              |----set_normalized_timespec (475.335389)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.335390)
     |----tick_check_idle
     |    |----tick_nohz_update_jiffies (475.335390)
     |    |    |----ktime_get (475.335391)
     |    |    |    |----ktime_get_ts (475.335391)
     |    |    |         |----getnstimeofday (475.335391)
     |    |    |         |    |----read_hpet (475.335391)
     |    |    |         |         |----hpet_readl (475.335392)
     |    |    |         |----set_normalized_timespec (475.335393)
     |    |    |----tick_do_update_jiffies64 (475.335393)
     |    |    |----touch_softlockup_watchdog (475.335394)
     |    |----ktime_get (475.335394)
     |    |    |----ktime_get_ts (475.335394)
     |    |         |----getnstimeofday (475.335395)
     |    |         |    |----read_hpet (475.335395)
     |    |         |         |----hpet_readl (475.335395)
     |    |         |----set_normalized_timespec (475.335397)
     |    |----tick_nohz_restart (475.335397)
     |         |----hrtimer_cancel (475.335397)
     |         |    |----hrtimer_try_to_cancel (475.335398)
     |         |         |----lock_hrtimer_base (475.335398)
     |         |         |----__remove_hrtimer (475.335399)
     |         |              |----hrtimer_force_reprogram (475.335399)
     |         |                   |----tick_program_event (475.335399)
     |         |                        |----tick_dev_program_event (475.335400)
     |         |                             |----ktime_get (475.335400)
     |         |                             |    |----ktime_get_ts (475.335400)
     |         |                             |         |----getnstimeofday (475.335401)
     |         |                             |         |    |----read_hpet (475.335401)
     |         |                             |         |         |----hpet_readl (475.335401)
     |         |                             |         |----set_normalized_timespec (475.335403)
     |         |                             |----clockevents_program_event (475.335403)
     |         |                                  |----lapic_next_event (475.335403)
     |         |                                       |----native_apic_mem_write (475.335404)
     |         |----hrtimer_forward (475.335404)
     |         |    |----ktime_divns (475.335405)
     |         |    |----ktime_add_safe (475.335405)
     |         |    |----ktime_add_safe (475.335406)
     |         |----hrtimer_start_range_ns (475.335406)
     |              |----lock_hrtimer_base (475.335406)
     |              |----ktime_add_safe (475.335407)
     |              |----__timer_stats_hrtimer_set_start_info (475.335407)
     |              |----enqueue_hrtimer (475.335407)
     |                   |----hrtimer_reprogram (475.335408)
     |                        |----tick_program_event (475.335408)
     |                             |----tick_dev_program_event (475.335408)
     |                                  |----ktime_get (475.335409)
     |                                  |    |----ktime_get_ts (475.335409)
     |                                  |         |----getnstimeofday (475.335409)
     |                                  |         |    |----read_hpet (475.335410)
     |                                  |         |         |----hpet_readl (475.335410)
     |                                  |         |----set_normalized_timespec (475.335412)
     |                                  |----clockevents_program_event (475.335412)
     |                                       |----lapic_next_event (475.335412)
     |                                            |----native_apic_mem_write (475.335413)
     |----do_IRQ
     |    |----handle_edge_irq (475.335413)
     |    |    |----ack_apic_edge (475.335414)
     |    |    |    |----irq_complete_move (475.335414)
     |    |    |    |    |----irq_cfg (475.335414)
     |    |    |    |----move_native_irq (475.335415)
     |    |    |    |----native_apic_mem_write (475.335415)
     |    |    |----handle_IRQ_event (475.335415)
     |    |    |    |----timer_interrupt (475.335416)
     |    |    |         |----tick_handle_oneshot_broadcast (475.335416)
     |    |    |              |----ktime_get (475.335417)
     |    |    |              |    |----ktime_get_ts (475.335417)
     |    |    |              |         |----getnstimeofday (475.335417)
     |    |    |              |         |    |----read_hpet (475.335418)
     |    |    |              |         |         |----hpet_readl (475.335418)
     |    |    |              |         |----set_normalized_timespec (475.335419)
     |    |    |              |----tick_do_broadcast (475.335420)
     |    |    |              |----tick_broadcast_set_event (475.335420)
     |    |    |                   |----tick_dev_program_event (475.335420)
     |    |    |                        |----ktime_get (475.335421)
     |    |    |                        |    |----ktime_get_ts (475.335421)
     |    |    |                        |         |----getnstimeofday (475.335421)
     |    |    |                        |         |    |----read_hpet (475.335422)
     |    |    |                        |         |         |----hpet_readl (475.335422)
     |    |    |                        |         |----set_normalized_timespec (475.335423)
     |    |    |                        |----clockevents_program_event (475.335424)
     |    |    |                             |----hpet_legacy_next_event (475.335424)
     |    |    |                                  |----hpet_readl (475.335425)
     |    |    |                                  |----hpet_readl (475.335426)
     |    |    |                                  |----hpet_readl (475.335427)
     |    |    |----note_interrupt (475.335429)
     |    |----irq_exit (475.335430)
     |         |----tick_nohz_stop_sched_tick (475.335430)
     |              |----ktime_get (475.335430)
     |----ktime_get_ts
     |    |----getnstimeofday (475.448961)
     |    |    |----read_hpet (475.448961)
     |    |         |----hpet_readl (475.448961)
     |    |----set_normalized_timespec (475.448963)
     |----sched_clock_tick
     |    |----ktime_get (475.448963)
     |         |----ktime_get_ts (475.448963)
     |              |----getnstimeofday (475.448964)
     |              |    |----read_hpet (475.448964)
     |              |         |----hpet_readl (475.448964)
     |              |----set_normalized_timespec (475.448966)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.448966)
     |----tick_check_idle
     |    |----tick_nohz_update_jiffies (475.448967)
     |----do_IRQ
     |    |----handle_edge_irq (475.448967)
     |         |----ack_apic_edge (475.448968)
     |         |    |----irq_complete_move (475.448968)
     |         |    |    |----irq_cfg (475.448968)
     |         |    |----move_native_irq (475.448969)
     |         |    |----native_apic_mem_write (475.448969)
     |         |----handle_IRQ_event (475.448970)
     |              |----timer_interrupt (475.448970)
     |                   |----tick_handle_oneshot_broadcast (475.448970)
     |                        |----ktime_get (475.448971)
     |                        |    |----ktime_get_ts (475.448971)
     |                        |         |----getnstimeofday (475.448971)
     |                        |         |    |----read_hpet (475.448972)
     |                        |         |         |----hpet_readl (475.448972)
     |                        |         |----set_normalized_timespec (475.448973)
     |                        |----tick_do_broadcast (475.448974)
     |                             |----hrtimer_interrupt (475.448974)
     |                                  |----ktime_get (475.448975)
     |                                  |    |----ktime_get_ts (475.448975)
     |                                  |         |----getnstimeofday (475.448975)
     |                                  |         |    |----read_hpet (475.448976)
     |                                  |         |         |----hpet_readl (475.448976)
     |                                  |         |----set_normalized_timespec (475.448977)
     |                                  |----__run_hrtimer (475.448978)
     |                                       |----__remove_hrtimer (475.448978)
     |                                       |----timer_stats_update_stats (475.448979)
     |                                       |----tick_sched_timer (475.448979)
     |                                            |----ktime_get (475.448980)
     |                                            |    |----ktime_get_ts (475.448980)
     |                                            |         |----getnstimeofday (475.448980)
     |                                            |         |    |----read_hpet (475.448981)
     |                                            |         |         |----hpet_readl (475.448981)
     |                                            |         |----set_normalized_timespec (475.448982)
     |                                            |----tick_do_update_jiffies64 (475.448983)
     |                                            |----update_process_times (475.448983)
     |                                                 |----account_process_tick (475.448983)
     |                                                 |----run_local_timers (475.448984)
     |                                                 |    |----hrtimer_run_queues (475.448984)
     |                                                 |    |----raise_softirq (475.448984)
     |                                                 |    |----softlockup_tick (475.448985)
     |                                                 |         |----__touch_softlockup_watchdog (475.448985)
     |                                                 |              |----get_timestamp (475.448986)
     |                                                 |----rcu_pending (475.448986)
     |                                                 |    |----__rcu_pending (475.448986)
     |                                                 |    |----__rcu_pending (475.448987)
     |                                                 |----printk_tick (475.448987)
     |----sched_clock_tick
     |    |----ktime_get (475.448987)
     |         |----ktime_get_ts (475.448988)
     |              |----getnstimeofday (475.448988)
     |              |    |----read_hpet (475.448988)
     |              |         |----hpet_readl (475.448989)
     |              |----set_normalized_timespec (475.448990)
     |----update_process_times
     |    |----run_posix_cpu_timers (475.448992)
     |----tick_sched_timer
     |    |----profile_tick (475.448992)
     |    |    |----profile_pc (475.448993)
     |    |----hrtimer_forward (475.448993)
     |         |----ktime_add_safe (475.448993)
     |         |----ktime_add_safe (475.448994)
     |----__run_hrtimer
     |    |----enqueue_hrtimer (475.448994)
     |----hrtimer_interrupt
     |    |----tick_program_event (475.448995)
     |         |----tick_dev_program_event (475.448995)
     |              |----ktime_get (475.448995)
     |              |    |----ktime_get_ts (475.448996)
     |              |         |----getnstimeofday (475.448996)
     |              |         |    |----read_hpet (475.448996)
     |              |         |         |----hpet_readl (475.448997)
     |              |         |----set_normalized_timespec (475.448998)
     |              |----clockevents_program_event (475.448999)
     |                   |----lapic_next_event (475.448999)
     |                        |----native_apic_mem_write (475.448999)
     |----handle_edge_irq
     |    |----note_interrupt (475.449000)
     |----do_IRQ
     |    |----irq_exit (475.449000)
     |         |----do_softirq (475.449001)
     |              |----__do_softirq (475.449001)
     |                   |----__local_bh_disable (475.449001)
     |                   |----run_timer_softirq (475.449002)
     |                   |    |----hrtimer_run_pending (475.449002)
     |                   |----_local_bh_enable (475.449003)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.449004)
     |         |----clockevents_notify (475.449004)
     |              |----clockevents_do_notify (475.449004)
     |                   |----raw_notifier_call_chain (475.449005)
     |                        |----__raw_notifier_call_chain (475.449005)
     |----notifier_call_chain
     |    |----tick_notify (475.449006)
     |         |----tick_broadcast_oneshot_control (475.449006)
     |              |----clockevents_set_mode (475.449006)
     |              |----tick_program_event (475.449007)
     |                   |----tick_dev_program_event (475.449007)
     |                        |----ktime_get (475.449007)
     |                        |    |----ktime_get_ts (475.449008)
     |                        |         |----getnstimeofday (475.449008)
     |                        |         |    |----read_hpet (475.449008)
     |                        |         |         |----hpet_readl (475.449009)
     |                        |         |----set_normalized_timespec (475.449010)
     |                        |----clockevents_program_event (475.449010)
     |                             |----lapic_next_event (475.449011)
     |                                  |----native_apic_mem_write (475.449011)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.449012)
     |----cpu_idle
     |    |----tick_nohz_restart_sched_tick (475.449012)
     |         |----tick_nohz_stop_idle (475.449013)
     |----schedule
     |    |----msecs_to_jiffies (475.449017)
     |----cpu_idle
     |    |----tick_nohz_stop_sched_tick (475.449018)
     |    |    |----ktime_get (475.449018)
     |    |    |    |----ktime_get_ts (475.449018)
     |    |    |         |----getnstimeofday (475.449019)
     |    |    |         |    |----read_hpet (475.449019)
     |    |    |         |         |----hpet_readl (475.449019)
     |    |    |         |----set_normalized_timespec (475.449021)
     |    |    |----get_next_timer_interrupt (475.449021)
     |    |    |    |----hrtimer_get_next_event (475.449022)
     |    |    |----rcu_needs_cpu (475.449023)
     |    |    |    |----rcu_pending (475.449023)
     |    |    |         |----__rcu_pending (475.449023)
     |    |    |         |----__rcu_pending (475.449024)
     |    |    |----printk_needs_cpu (475.449024)
     |    |    |----hrtimer_start (475.449024)
     |    |         |----hrtimer_start_range_ns (475.449025)
     |    |              |----lock_hrtimer_base (475.449025)
     |    |              |----__remove_hrtimer (475.449026)
     |    |              |    |----hrtimer_force_reprogram (475.449026)
     |    |              |         |----tick_program_event (475.449026)
     |    |              |              |----tick_dev_program_event (475.449027)
     |    |              |                   |----ktime_get (475.449027)
     |    |              |                   |    |----ktime_get_ts (475.449027)
     |    |              |                   |         |----getnstimeofday (475.449028)
     |    |              |                   |         |    |----read_hpet (475.449028)
     |    |              |                   |         |         |----hpet_readl (475.449028)
     |    |              |                   |         |----set_normalized_timespec (475.449030)
     |    |              |                   |----clockevents_program_event (475.449030)
     |    |              |                        |----lapic_next_event (475.449030)
     |    |              |                             |----native_apic_mem_write (475.449031)
     |    |              |----ktime_add_safe (475.449031)
     |    |              |----__timer_stats_hrtimer_set_start_info (475.449031)
     |    |              |----enqueue_hrtimer (475.449032)
     |    |                   |----hrtimer_reprogram (475.449032)
     |    |                        |----tick_program_event (475.449033)
     |    |                             |----tick_dev_program_event (475.449033)
     |    |                                  |----ktime_get (475.449033)
     |    |                                  |    |----ktime_get_ts (475.449033)
     |    |                                  |         |----getnstimeofday (475.449034)
     |    |                                  |         |    |----read_hpet (475.449034)
     |    |                                  |         |         |----hpet_readl (475.449034)
     |    |                                  |         |----set_normalized_timespec (475.449036)
     |    |                                  |----clockevents_program_event (475.449036)
     |    |                                       |----lapic_next_event (475.449037)
     |    |                                            |----native_apic_mem_write (475.449037)
     |    |----rcu_pending (475.449038)
     |    |    |----__rcu_pending (475.449038)
     |    |    |----__rcu_pending (475.449038)
     |    |----cpuidle_idle_call (475.449039)
     |         |----hrtimer_peek_ahead_timers (475.449039)
     |         |    |----hrtimer_interrupt (475.449039)
     |         |         |----ktime_get (475.449040)
     |         |         |    |----ktime_get_ts (475.449040)
     |         |         |         |----getnstimeofday (475.449040)
     |         |         |         |    |----read_hpet (475.449041)
     |         |         |         |         |----hpet_readl (475.449041)
     |         |         |         |----set_normalized_timespec (475.449042)
     |         |         |----tick_program_event (475.449043)
     |         |              |----tick_dev_program_event (475.449044)
     |         |                   |----ktime_get (475.449044)
     |         |                   |    |----ktime_get_ts (475.449044)
     |         |                   |         |----getnstimeofday (475.449045)
     |         |                   |         |    |----read_hpet (475.449045)
     |         |                   |         |         |----hpet_readl (475.449045)
     |         |                   |         |----set_normalized_timespec (475.449047)
     |         |                   |----clockevents_program_event (475.449047)
     |         |                        |----lapic_next_event (475.449047)
     |         |                             |----native_apic_mem_write (475.449048)
     |         |----menu_select (475.449048)
     |         |    |----pm_qos_requirement (475.449049)
     |         |    |----tick_nohz_get_sleep_length (475.449049)
     |         |----acpi_idle_enter_simple (475.449049)
     |              |----acpi_state_timer_broadcast (475.449050)
     |                   |----clockevents_notify (475.449050)
     |                        |----clockevents_do_notify (475.449050)
     |                             |----raw_notifier_call_chain (475.449051)
     |                                  |----__raw_notifier_call_chain (475.449051)
     |----notifier_call_chain
     |    |----tick_notify (475.449051)
     |         |----tick_broadcast_oneshot_control (475.449052)
     |         |    |----clockevents_set_mode (475.449052)
     |         |    |    |----lapic_timer_setup (475.449053)
     |         |    |         |----native_apic_mem_read (475.449053)
     |         |    |         |----native_apic_mem_write (475.449053)
     |         |    |----tick_broadcast_set_event (475.449054)
     |         |         |----tick_dev_program_event (475.449054)
     |         |              |----ktime_get (475.449054)
     |         |                   |----ktime_get_ts (475.449055)
     |         |                        |----getnstimeofday (475.449055)
     |         |                        |    |----read_hpet (475.449055)
     |         |                        |         |----hpet_readl (475.449056)
     |         |                        |----set_normalized_timespec (475.449057)
     |         |----tick_broadcast_oneshot_control (475.512734)
     |              |----clockevents_set_mode (475.512734)
     |                   |----lapic_timer_setup (475.512735)
     |                        |----native_apic_mem_read (475.512735)
     |                        |----native_apic_mem_write (475.512735)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.512738)
     |    |    |----mwait_idle_with_hints (475.512738)
     |    |----tsc_halts_in_c (475.512767)
     |----sched_clock_tick
     |    |----ktime_get (475.512768)
     |         |----ktime_get_ts (475.512768)
     |              |----getnstimeofday (475.512769)
     |              |    |----read_hpet (475.512769)
     |              |         |----hpet_readl (475.512769)
     |              |----set_normalized_timespec (475.512771)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.512771)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.512772)
     |         |----clockevents_notify (475.512772)
     |              |----clockevents_do_notify (475.512773)
     |                   |----raw_notifier_call_chain (475.512773)
     |                        |----__raw_notifier_call_chain (475.512773)
     |----notifier_call_chain
     |    |----tick_notify (475.512774)
     |         |----tick_broadcast_oneshot_control (475.512774)
     |              |----clockevents_set_mode (475.512774)
     |              |    |----lapic_timer_setup (475.512775)
     |              |         |----__setup_APIC_LVTT (475.512775)
     |              |              |----native_apic_mem_read (475.512775)
     |              |              |----native_apic_mem_write (475.512776)
     |              |              |----native_apic_mem_read (475.512776)
     |              |              |----native_apic_mem_write (475.512777)
     |              |----tick_program_event (475.512777)
     |                   |----tick_dev_program_event (475.512777)
     |                        |----ktime_get (475.512778)
     |                        |    |----ktime_get_ts (475.512778)
     |                        |         |----getnstimeofday (475.512778)
     |                        |         |    |----read_hpet (475.512779)
     |                        |         |         |----hpet_readl (475.512779)
     |                        |         |----set_normalized_timespec (475.512780)
     |                        |----clockevents_program_event (475.512781)
     |                             |----lapic_next_event (475.512781)
     |                                  |----native_apic_mem_write (475.512781)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.512782)
     |----cpu_idle
     |    |----rcu_pending (475.512783)
     |    |    |----__rcu_pending (475.512783)
     |    |    |----__rcu_pending (475.512783)
     |    |----cpuidle_idle_call (475.512784)
     |         |----hrtimer_peek_ahead_timers (475.512784)
     |         |    |----hrtimer_interrupt (475.512784)
     |         |         |----ktime_get (475.512785)
     |         |         |    |----ktime_get_ts (475.512785)
     |         |         |         |----getnstimeofday (475.512785)
     |         |         |         |    |----read_hpet (475.512786)
     |         |         |         |         |----hpet_readl (475.512786)
     |         |         |         |----set_normalized_timespec (475.512788)
     |         |         |----tick_program_event (475.512788)
     |         |              |----tick_dev_program_event (475.512789)
     |         |                   |----ktime_get (475.512789)
     |         |                   |    |----ktime_get_ts (475.512789)
     |         |                   |         |----getnstimeofday (475.512790)
     |         |                   |         |    |----read_hpet (475.512790)
     |         |                   |         |         |----hpet_readl (475.512790)
     |         |                   |         |----set_normalized_timespec (475.512792)
     |         |                   |----clockevents_program_event (475.512792)
     |         |                        |----lapic_next_event (475.512792)
     |         |                             |----native_apic_mem_write (475.512793)
     |         |----menu_select (475.512793)
     |         |    |----pm_qos_requirement (475.512793)
     |         |    |----tick_nohz_get_sleep_length (475.512794)
     |         |----acpi_idle_enter_c1 (475.512794)
     |              |----acpi_processor_ffh_cstate_enter (475.512796)
     |                   |----mwait_idle_with_hints (475.512797)
     |----common_interrupt
     |    |----do_IRQ (475.512857)
     |         |----irq_enter (475.512857)
     |              |----tick_check_idle (475.512857)
     |                   |----tick_check_oneshot_broadcast (475.512858)
     |                   |----tick_nohz_stop_idle (475.512858)
     |                        |----ktime_get (475.512858)
     |                             |----ktime_get_ts (475.512859)
     |                                  |----getnstimeofday (475.512859)
     |                                  |    |----read_hpet (475.512859)
     |                                  |         |----hpet_readl (475.512860)
     |                                  |----set_normalized_timespec (475.512861)
     |----sched_clock_tick
     |    |----ktime_get (475.512861)
     |         |----ktime_get_ts (475.512862)
     |              |----getnstimeofday (475.512862)
     |              |    |----read_hpet (475.512862)
     |              |         |----hpet_readl (475.512863)
     |              |----set_normalized_timespec (475.512864)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.512865)
     |----tick_check_idle
     |    |----tick_nohz_update_jiffies (475.512865)
     |    |    |----ktime_get (475.512865)
     |    |    |    |----ktime_get_ts (475.512866)
     |    |    |         |----getnstimeofday (475.512866)
     |    |    |         |    |----read_hpet (475.512866)
     |    |    |         |         |----hpet_readl (475.512867)
     |    |    |         |----set_normalized_timespec (475.512868)
     |    |    |----tick_do_update_jiffies64 (475.512869)
     |    |    |----touch_softlockup_watchdog (475.512869)
     |    |----ktime_get (475.512869)
     |    |    |----ktime_get_ts (475.512870)
     |    |         |----getnstimeofday (475.512870)
     |    |         |    |----read_hpet (475.512870)
     |    |         |         |----hpet_readl (475.512871)
     |    |         |----set_normalized_timespec (475.512872)
     |    |----tick_nohz_restart (475.512873)
     |         |----hrtimer_cancel (475.512873)
     |         |    |----hrtimer_try_to_cancel (475.512873)
     |         |         |----lock_hrtimer_base (475.512874)
     |         |         |----__remove_hrtimer (475.512874)
     |         |----hrtimer_forward (475.512875)
     |         |----hrtimer_start_range_ns (475.512875)
     |              |----lock_hrtimer_base (475.512875)
     |              |----ktime_add_safe (475.512876)
     |              |----__timer_stats_hrtimer_set_start_info (475.512876)
     |              |----enqueue_hrtimer (475.512877)
     |                   |----hrtimer_reprogram (475.512877)
     |                        |----tick_program_event (475.512877)
     |                             |----tick_dev_program_event (475.512878)
     |                                  |----ktime_get (475.512878)
     |                                  |    |----ktime_get_ts (475.512878)
     |                                  |         |----getnstimeofday (475.512879)
     |                                  |         |    |----read_hpet (475.512879)
     |                                  |         |         |----hpet_readl (475.512879)
     |                                  |         |----set_normalized_timespec (475.512881)
     |                                  |----clockevents_program_event (475.512881)
     |                                       |----lapic_next_event (475.512882)
     |                                            |----native_apic_mem_write (475.512882)
     |----do_IRQ
     |    |----handle_edge_irq (475.512883)
     |    |    |----ack_apic_edge (475.512883)
     |    |    |    |----irq_complete_move (475.512883)
     |    |    |    |    |----irq_cfg (475.512884)
     |    |    |    |----move_native_irq (475.512884)
     |    |    |    |----native_apic_mem_write (475.512884)
     |    |    |----handle_IRQ_event (475.512885)
     |    |    |    |----timer_interrupt (475.512885)
     |    |    |         |----tick_handle_oneshot_broadcast (475.512886)
     |    |    |              |----ktime_get (475.512886)
     |    |    |              |    |----ktime_get_ts (475.512887)
     |    |    |              |         |----getnstimeofday (475.512887)
     |    |    |              |         |    |----read_hpet (475.512887)
     |    |    |              |         |         |----hpet_readl (475.512888)
     |    |    |              |         |----set_normalized_timespec (475.512889)
     |    |    |              |----tick_do_broadcast (475.512889)
     |    |    |              |----tick_broadcast_set_event (475.512890)
     |    |    |                   |----tick_dev_program_event (475.512890)
     |    |    |                        |----ktime_get (475.512890)
     |    |    |                        |    |----ktime_get_ts (475.512891)
     |    |    |                        |         |----getnstimeofday (475.512891)
     |    |    |                        |         |    |----read_hpet (475.512891)
     |    |    |                        |         |         |----hpet_readl (475.512892)
     |    |    |                        |         |----set_normalized_timespec (475.512893)
     |    |    |                        |----clockevents_program_event (475.512894)
     |    |    |                             |----hpet_legacy_next_event (475.512894)
     |    |    |                                  |----hpet_readl (475.512894)
     |    |    |                                  |----hpet_readl (475.512896)
     |    |    |                                  |----hpet_readl (475.512897)
     |    |    |----note_interrupt (475.512899)
     |    |----irq_exit (475.512899)
     |         |----tick_nohz_stop_sched_tick (475.512900)
     |              |----ktime_get (475.512900)
     |              |    |----ktime_get_ts (475.512900)
     |              |         |----getnstimeofday (475.512901)
     |              |         |    |----read_hpet (475.512901)
     |              |         |         |----hpet_readl (475.512901)
     |              |         |----set_normalized_timespec (475.512903)
     |              |----get_next_timer_interrupt (475.512903)
     |              |    |----hrtimer_get_next_event (475.512905)
     |              |----rcu_needs_cpu (475.512906)
     |              |    |----rcu_pending (475.512906)
     |              |         |----__rcu_pending (475.512906)
     |              |         |----__rcu_pending (475.512907)
     |              |----printk_needs_cpu (475.512907)
     |              |----hrtimer_start (475.512907)
     |                   |----hrtimer_start_range_ns (475.512908)
     |                        |----lock_hrtimer_base (475.512908)
     |                        |----__remove_hrtimer (475.512908)
     |                        |    |----hrtimer_force_reprogram (475.512909)
     |                        |         |----tick_program_event (475.512909)
     |                        |              |----tick_dev_program_event (475.512910)
     |                        |                   |----ktime_get (475.512910)
     |                        |                   |    |----ktime_get_ts (475.512910)
     |                        |                   |         |----getnstimeofday (475.512911)
     |                        |                   |         |    |----read_hpet (475.512911)
     |                        |                   |         |         |----hpet_readl (475.512911)
     |                        |                   |         |----set_normalized_timespec (475.512913)
     |                        |                   |----clockevents_program_event (475.512913)
     |                        |                        |----lapic_next_event (475.512913)
     |                        |                             |----native_apic_mem_write (475.512914)
     |                        |----ktime_add_safe (475.512914)
     |                        |----__timer_stats_hrtimer_set_start_info (475.512914)
     |                        |----enqueue_hrtimer (475.512915)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.512916)
     |----cpu_idle
     |    |----rcu_pending (475.512916)
     |    |    |----__rcu_pending (475.512916)
     |    |    |----__rcu_pending (475.512917)
     |    |----cpuidle_idle_call (475.512917)
     |         |----hrtimer_peek_ahead_timers (475.512917)
     |         |    |----hrtimer_interrupt (475.512918)
     |         |         |----ktime_get (475.512918)
     |         |         |    |----ktime_get_ts (475.512919)
     |         |         |         |----getnstimeofday (475.512919)
     |         |         |         |    |----read_hpet (475.512919)
     |         |         |         |         |----hpet_readl (475.512919)
     |         |         |         |----set_normalized_timespec (475.512921)
     |         |         |----tick_program_event (475.512922)
     |         |              |----tick_dev_program_event (475.521886)
     |         |                   |----ktime_get (475.521886)
     |         |                   |    |----ktime_get_ts (475.521886)
     |         |                   |         |----getnstimeofday (475.521887)
     |         |                   |         |    |----read_hpet (475.521887)
     |         |                   |         |         |----hpet_readl (475.521887)
     |         |                   |         |----set_normalized_timespec (475.521889)
     |         |                   |----clockevents_program_event (475.521889)
     |         |                        |----lapic_next_event (475.521890)
     |         |                             |----native_apic_mem_write (475.521890)
     |         |----menu_select (475.521890)
     |         |    |----pm_qos_requirement (475.521891)
     |         |    |----tick_nohz_get_sleep_length (475.521891)
     |         |----acpi_idle_enter_simple (475.521891)
     |              |----acpi_state_timer_broadcast (475.521892)
     |                   |----clockevents_notify (475.521892)
     |                        |----clockevents_do_notify (475.521893)
     |                             |----raw_notifier_call_chain (475.521893)
     |                                  |----__raw_notifier_call_chain (475.521893)
     |----notifier_call_chain
     |    |----tick_notify (475.521894)
     |         |----tick_broadcast_oneshot_control (475.521894)
     |              |----clockevents_set_mode (475.521895)
     |                   |----lapic_timer_setup (475.521895)
     |                        |----native_apic_mem_read (475.521895)
     |                        |----native_apic_mem_write (475.521896)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.521898)
     |    |    |----mwait_idle_with_hints (475.521898)
     |    |----tsc_halts_in_c (475.521917)
     |----sched_clock_tick
     |    |----ktime_get (475.521918)
     |         |----ktime_get_ts (475.521918)
     |              |----getnstimeofday (475.521918)
     |              |    |----read_hpet (475.521919)
     |              |         |----hpet_readl (475.521919)
     |              |----set_normalized_timespec (475.521921)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.521921)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.521922)
     |         |----clockevents_notify (475.521922)
     |              |----clockevents_do_notify (475.521923)
     |                   |----raw_notifier_call_chain (475.521923)
     |                        |----__raw_notifier_call_chain (475.521923)
     |----notifier_call_chain
     |    |----tick_notify (475.521924)
     |         |----tick_broadcast_oneshot_control (475.521924)
     |              |----clockevents_set_mode (475.521924)
     |              |    |----lapic_timer_setup (475.521925)
     |              |         |----__setup_APIC_LVTT (475.521925)
     |              |              |----native_apic_mem_read (475.521925)
     |              |              |----native_apic_mem_write (475.521926)
     |              |              |----native_apic_mem_read (475.521926)
     |              |              |----native_apic_mem_write (475.521927)
     |              |----tick_program_event (475.521927)
     |                   |----tick_dev_program_event (475.521927)
     |                        |----ktime_get (475.521928)
     |                        |    |----ktime_get_ts (475.521928)
     |                        |         |----getnstimeofday (475.521928)
     |                        |         |    |----read_hpet (475.521929)
     |                        |         |         |----hpet_readl (475.521929)
     |                        |         |----set_normalized_timespec (475.521930)
     |                        |----clockevents_program_event (475.521931)
     |                             |----lapic_next_event (475.521931)
     |                                  |----native_apic_mem_write (475.521932)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.521932)
     |----cpu_idle
     |    |----rcu_pending (475.521933)
     |    |    |----__rcu_pending (475.521933)
     |    |    |----__rcu_pending (475.521933)
     |    |----cpuidle_idle_call (475.521934)
     |         |----hrtimer_peek_ahead_timers (475.521934)
     |              |----hrtimer_interrupt (475.521934)
     |                   |----ktime_get (475.521935)
     |                   |    |----ktime_get_ts (475.521935)
     |                   |         |----getnstimeofday (475.521935)
     |                   |         |    |----read_hpet (475.521936)
     |                   |         |         |----hpet_readl (475.521936)
     |                   |         |----set_normalized_timespec (475.521938)
     |                   |----tick_program_event (475.521938)
     |                        |----tick_dev_program_event (475.521939)
     |                             |----ktime_get (475.521939)
     |                                  |----ktime_get_ts (475.521939)
     |                                       |----getnstimeofday (475.521940)
     |----tick_broadcast_oneshot_control
     |    |----tick_program_event (475.521940)
     |----getnstimeofday
     |    |----read_hpet (475.521940)
     |----tick_program_event
     |    |----tick_dev_program_event (475.521940)
     |----read_hpet
     |    |----hpet_readl (475.521940)
     |----tick_dev_program_event
     |    |----ktime_get (475.521941)
     |         |----ktime_get_ts (475.521941)
     |              |----getnstimeofday (475.521941)
     |              |    |----read_hpet (475.521942)
     |              |----set_normalized_timespec (475.521942)
     |----read_hpet
     |    |----hpet_readl (475.521942)
     |----tick_dev_program_event
     |    |----clockevents_program_event (475.521942)
     |         |----lapic_next_event (475.521942)
     |              |----native_apic_mem_write (475.521943)
     |----cpuidle_idle_call
     |    |----menu_select (475.521943)
     |----ktime_get_ts
     |    |----set_normalized_timespec (475.521943)
     |----menu_select
     |    |----pm_qos_requirement (475.521944)
     |----tick_dev_program_event
     |    |----clockevents_program_event (475.521944)
     |----menu_select
     |    |----tick_nohz_get_sleep_length (475.521944)
     |----clockevents_program_event
     |    |----lapic_next_event (475.521944)
     |----cpuidle_idle_call
     |    |----acpi_idle_enter_simple (475.521944)
     |----lapic_next_event
     |    |----native_apic_mem_write (475.521945)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.521945)
     |         |----clockevents_notify (475.521945)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.521945)
     |----clockevents_notify
     |    |----clockevents_do_notify (475.521945)
     |----cpu_idle
     |    |----rcu_pending (475.521946)
     |----clockevents_do_notify
     |    |----raw_notifier_call_chain (475.521946)
     |----rcu_pending
     |    |----__rcu_pending (475.521946)
     |----raw_notifier_call_chain
     |    |----__raw_notifier_call_chain (475.521946)
     |----rcu_pending
     |    |----__rcu_pending (475.521946)
     |----notifier_call_chain
     |    |----tick_notify (475.521946)
     |----cpu_idle
     |    |----cpuidle_idle_call (475.521947)
     |----tick_notify
     |    |----tick_broadcast_oneshot_control (475.521947)
     |----cpuidle_idle_call
     |    |----hrtimer_peek_ahead_timers (475.521947)
     |----tick_broadcast_oneshot_control
     |    |----clockevents_set_mode (475.521947)
     |----hrtimer_peek_ahead_timers
     |    |----hrtimer_interrupt (475.521947)
     |----clockevents_set_mode
     |    |----lapic_timer_setup (475.521948)
     |----hrtimer_interrupt
     |    |----ktime_get (475.521948)
     |----lapic_timer_setup
     |    |----native_apic_mem_read (475.521948)
     |----ktime_get
     |    |----ktime_get_ts (475.521948)
     |----lapic_timer_setup
     |    |----native_apic_mem_write (475.521948)
     |----ktime_get_ts
     |    |----getnstimeofday (475.521948)
     |         |----read_hpet (475.521949)
     |              |----hpet_readl (475.521949)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.521951)
     |         |----mwait_idle_with_hints (475.521951)
     |----ktime_get_ts
     |    |----set_normalized_timespec (475.521951)
     |----hrtimer_interrupt
     |    |----tick_program_event (475.521952)
     |         |----tick_dev_program_event (475.521953)
     |              |----ktime_get (475.521953)
     |              |    |----ktime_get_ts (475.521953)
     |              |         |----getnstimeofday (475.521954)
     |              |         |    |----read_hpet (475.521954)
     |              |         |         |----hpet_readl (475.521954)
     |              |         |----set_normalized_timespec (475.521956)
     |              |----clockevents_program_event (475.521956)
     |                   |----lapic_next_event (475.521956)
     |                        |----native_apic_mem_write (475.521957)
     |----cpuidle_idle_call
     |    |----menu_select (475.521957)
     |    |    |----pm_qos_requirement (475.521957)
     |    |    |----tick_nohz_get_sleep_length (475.521958)
     |    |----acpi_idle_enter_simple (475.521958)
     |         |----acpi_state_timer_broadcast (475.521959)
     |              |----clockevents_notify (475.521959)
     |                   |----clockevents_do_notify (475.521959)
     |                        |----raw_notifier_call_chain (475.521960)
     |                             |----__raw_notifier_call_chain (475.521960)
     |----notifier_call_chain
     |    |----tick_notify (475.521960)
     |         |----tick_broadcast_oneshot_control (475.521961)
     |              |----clockevents_set_mode (475.521961)
     |                   |----lapic_timer_setup (475.521962)
     |                        |----native_apic_mem_read (475.521962)
     |                        |----native_apic_mem_write (475.521962)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.521965)
     |    |    |----mwait_idle_with_hints (475.521965)
     |    |----tsc_halts_in_c (475.521984)
     |----sched_clock_tick
     |    |----ktime_get (475.521985)
     |         |----ktime_get_ts (475.521985)
     |              |----getnstimeofday (475.521985)
     |----acpi_idle_enter_simple
     |    |----tsc_halts_in_c (475.521985)
     |----getnstimeofday
     |    |----read_hpet (475.521986)
     |----sched_clock_tick
     |    |----ktime_get (475.521986)
     |----read_hpet
     |    |----hpet_readl (475.521986)
     |----ktime_get
     |    |----ktime_get_ts (475.521986)
     |         |----getnstimeofday (475.521987)
     |         |    |----read_hpet (475.521987)
     |         |         |----hpet_readl (475.521987)
     |         |----set_normalized_timespec (475.521987)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.521988)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.521988)
     |----ktime_get_ts
     |    |----set_normalized_timespec (475.521989)
     |----acpi_state_timer_broadcast
     |    |----clockevents_notify (475.521989)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.521989)
     |----clockevents_notify
     |    |----clockevents_do_notify (475.521989)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.521990)
     |----clockevents_do_notify
     |    |----raw_notifier_call_chain (475.521990)
     |----acpi_state_timer_broadcast
     |    |----clockevents_notify (475.521990)
     |----raw_notifier_call_chain
     |    |----__raw_notifier_call_chain (475.521990)
     |----notifier_call_chain
     |    |----tick_notify (475.521990)
     |----_raw_spin_lock
     |    |----__delay (475.521991)
     |----tick_notify
     |    |----tick_broadcast_oneshot_control (475.521991)
     |----__delay
     |    |----delay_tsc (475.521991)
     |----tick_broadcast_oneshot_control
     |    |----clockevents_set_mode (475.521991)
     |----_raw_spin_lock
     |    |----__delay (475.521991)
     |----clockevents_set_mode
     |    |----lapic_timer_setup (475.521992)
     |----__delay
     |    |----delay_tsc (475.521992)
     |----lapic_timer_setup
     |    |----__setup_APIC_LVTT (475.521992)
     |----_raw_spin_lock
     |    |----__delay (475.521992)
     |----__setup_APIC_LVTT
     |    |----native_apic_mem_read (475.521992)
     |----__delay
     |    |----delay_tsc (475.521992)
     |----__setup_APIC_LVTT
     |    |----native_apic_mem_write (475.521993)
     |----_raw_spin_lock
     |    |----__delay (475.521993)
     |----__setup_APIC_LVTT
     |    |----native_apic_mem_read (475.521993)
     |----__delay
     |    |----delay_tsc (475.521993)
     |----__setup_APIC_LVTT
     |    |----native_apic_mem_write (475.521993)
     |----tick_broadcast_oneshot_control
     |    |----tick_program_event (475.521994)
     |----_raw_spin_lock
     |    |----__delay (475.521994)
     |----tick_program_event
     |    |----tick_dev_program_event (475.521994)
     |----__delay
     |    |----delay_tsc (475.521994)
     |----tick_dev_program_event
     |    |----ktime_get (475.521994)
     |----_raw_spin_lock
     |    |----__delay (475.521995)
     |----ktime_get
     |    |----ktime_get_ts (475.521995)
     |----__delay
     |    |----delay_tsc (475.521995)
     |----ktime_get_ts
     |    |----getnstimeofday (475.521995)
     |----_raw_spin_lock
     |    |----__delay (475.521995)
     |----getnstimeofday
     |    |----read_hpet (475.521995)
     |----__delay
     |    |----delay_tsc (475.521996)
     |----read_hpet
     |    |----hpet_readl (475.521996)
     |----_raw_spin_lock
     |    |----__delay (475.521996)
     |    |    |----delay_tsc (475.521996)
     |    |----__delay (475.521997)
     |----ktime_get_ts
     |    |----set_normalized_timespec (475.521997)
     |----__delay
     |    |----delay_tsc (475.521997)
     |----tick_dev_program_event
     |    |----clockevents_program_event (475.521997)
     |----_raw_spin_lock
     |    |----__delay (475.521998)
     |----clockevents_program_event
     |    |----lapic_next_event (475.521998)
     |----__delay
     |    |----delay_tsc (475.521998)
     |----lapic_next_event
     |    |----native_apic_mem_write (475.521998)
     |----_raw_spin_lock
     |    |----__delay (475.521998)
     |         |----delay_tsc (475.521999)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.521999)
     |----clockevents_notify
     |    |----clockevents_do_notify (475.521999)
     |----cpu_idle
     |    |----rcu_pending (475.521999)
     |----clockevents_do_notify
     |    |----raw_notifier_call_chain (475.522000)
     |----rcu_pending
     |    |----__rcu_pending (475.522000)
     |----raw_notifier_call_chain
     |    |----__raw_notifier_call_chain (475.522000)
     |----rcu_pending
     |    |----__rcu_pending (475.522000)
     |----notifier_call_chain
     |    |----tick_notify (475.522000)
     |----cpu_idle
     |    |----cpuidle_idle_call (475.522000)
     |----tick_notify
     |    |----tick_broadcast_oneshot_control (475.522001)
     |----cpuidle_idle_call
     |    |----hrtimer_peek_ahead_timers (475.522001)
     |         |----hrtimer_interrupt (475.522001)
     |----tick_broadcast_oneshot_control
     |    |----clockevents_set_mode (475.522001)
     |----hrtimer_interrupt
     |    |----ktime_get (475.522001)
     |----clockevents_set_mode
     |    |----lapic_timer_setup (475.522002)
     |----ktime_get
     |    |----ktime_get_ts (475.522002)
     |----lapic_timer_setup
     |    |----__setup_APIC_LVTT (475.522002)
     |----ktime_get_ts
     |    |----getnstimeofday (475.522002)
     |----__setup_APIC_LVTT
     |    |----native_apic_mem_read (475.522002)
     |----getnstimeofday
     |    |----read_hpet (475.522002)
     |----__setup_APIC_LVTT
     |    |----native_apic_mem_write (475.522003)
     |----read_hpet
     |    |----hpet_readl (475.522003)
     |----__setup_APIC_LVTT
     |    |----native_apic_mem_read (475.522003)
     |    |----native_apic_mem_write (475.522003)
     |----tick_broadcast_oneshot_control
     |    |----tick_program_event (475.522004)
     |         |----tick_dev_program_event (475.522004)
     |----ktime_get_ts
     |    |----set_normalized_timespec (475.522004)
     |----tick_dev_program_event
     |    |----ktime_get (475.522004)
     |         |----ktime_get_ts (475.522005)
     |----hrtimer_interrupt
     |    |----tick_program_event (475.522005)
     |----ktime_get_ts
     |    |----getnstimeofday (475.522005)
     |----tick_program_event
     |    |----tick_dev_program_event (475.522005)
     |----getnstimeofday
     |    |----read_hpet (475.522005)
     |----tick_dev_program_event
     |    |----ktime_get (475.522006)
     |----read_hpet
     |    |----hpet_readl (475.522006)
     |----ktime_get
     |    |----ktime_get_ts (475.522006)
     |         |----getnstimeofday (475.522006)
     |         |    |----read_hpet (475.522007)
     |         |         |----hpet_readl (475.522007)
     |         |----set_normalized_timespec (475.522007)
     |----tick_dev_program_event
     |    |----clockevents_program_event (475.522008)
     |         |----lapic_next_event (475.522008)
     |              |----native_apic_mem_write (475.522008)
     |----ktime_get_ts
     |    |----set_normalized_timespec (475.522009)
     |----tick_dev_program_event
     |    |----clockevents_program_event (475.522009)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.522009)
     |----clockevents_program_event
     |    |----lapic_next_event (475.522009)
     |----cpu_idle
     |    |----rcu_pending (475.522009)
     |----lapic_next_event
     |    |----native_apic_mem_write (475.522010)
     |----rcu_pending
     |    |----__rcu_pending (475.522010)
     |----cpuidle_idle_call
     |    |----menu_select (475.522010)
     |----rcu_pending
     |    |----__rcu_pending (475.522010)
     |----menu_select
     |    |----pm_qos_requirement (475.522010)
     |----cpu_idle
     |    |----cpuidle_idle_call (475.522011)
     |----menu_select
     |    |----tick_nohz_get_sleep_length (475.522011)
     |----cpuidle_idle_call
     |    |----hrtimer_peek_ahead_timers (475.522011)
     |    |----acpi_idle_enter_c1 (475.522011)
     |----hrtimer_peek_ahead_timers
     |    |----hrtimer_interrupt (475.522011)
     |         |----ktime_get (475.522012)
     |              |----ktime_get_ts (475.522012)
     |                   |----getnstimeofday (475.522012)
     |                        |----read_hpet (475.522013)
     |                             |----hpet_readl (475.522013)
     |----acpi_idle_enter_c1
     |    |----acpi_processor_ffh_cstate_enter (475.522013)
     |         |----mwait_idle_with_hints (475.522014)
     |----ktime_get_ts
     |    |----set_normalized_timespec (475.522014)
     |----hrtimer_interrupt
     |    |----tick_program_event (475.522015)
     |         |----tick_dev_program_event (475.522015)
     |              |----ktime_get (475.522016)
     |              |    |----ktime_get_ts (475.522016)
     |              |         |----getnstimeofday (475.522016)
     |              |         |    |----read_hpet (475.522017)
     |              |         |         |----hpet_readl (475.522017)
     |              |         |----set_normalized_timespec (475.522018)
     |              |----clockevents_program_event (475.522019)
     |                   |----lapic_next_event (475.522019)
     |                        |----native_apic_mem_write (475.522019)
     |----cpuidle_idle_call
     |    |----menu_select (475.522020)
     |    |    |----pm_qos_requirement (475.522020)
     |    |    |----tick_nohz_get_sleep_length (475.522020)
     |    |----acpi_idle_enter_simple (475.522021)
     |         |----acpi_state_timer_broadcast (475.522021)
     |              |----clockevents_notify (475.522021)
     |                   |----clockevents_do_notify (475.522022)
     |                        |----raw_notifier_call_chain (475.522022)
     |                             |----__raw_notifier_call_chain (475.522023)
     |----notifier_call_chain
     |    |----tick_notify (475.522023)
     |         |----tick_broadcast_oneshot_control (475.522023)
     |              |----clockevents_set_mode (475.522024)
     |                   |----lapic_timer_setup (475.522024)
     |                        |----native_apic_mem_read (475.522024)
     |                        |----native_apic_mem_write (475.522025)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.522027)
     |         |----mwait_idle_with_hints (475.522028)
     |----common_interrupt
     |    |----do_IRQ (475.524841)
     |         |----irq_enter (475.524841)
     |              |----tick_check_idle (475.524841)
     |                   |----tick_check_oneshot_broadcast (475.524842)
     |                   |----tick_nohz_stop_idle (475.524842)
     |                        |----ktime_get (475.524843)
     |                             |----ktime_get_ts (475.524843)
     |                                  |----getnstimeofday (475.524843)
     |                                  |    |----read_hpet (475.524844)
     |                                  |         |----hpet_readl (475.524844)
     |                                  |----set_normalized_timespec (475.524845)
     |----sched_clock_tick
     |    |----ktime_get (475.524846)
     |         |----ktime_get_ts (475.524846)
     |              |----getnstimeofday (475.524846)
     |              |    |----read_hpet (475.524847)
     |              |         |----hpet_readl (475.524847)
     |              |----set_normalized_timespec (475.524848)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.524849)
     |----tick_check_idle
     |    |----tick_nohz_update_jiffies (475.524849)
     |    |    |----ktime_get (475.524850)
     |    |    |    |----ktime_get_ts (475.524850)
     |    |    |         |----getnstimeofday (475.524850)
     |    |    |         |    |----read_hpet (475.524851)
     |    |    |         |         |----hpet_readl (475.524851)
     |    |    |         |----set_normalized_timespec (475.524852)
     |    |    |----tick_do_update_jiffies64 (475.524853)
     |    |    |    |----do_timer (475.524853)
     |    |    |         |----update_wall_time (475.524854)
     |    |    |              |----read_hpet (475.524854)
     |    |    |              |    |----hpet_readl (475.524854)
     |    |    |              |----update_xtime_cache (475.524856)
     |    |    |              |----clocksource_get_next (475.524856)
     |    |    |----touch_softlockup_watchdog (475.524857)
     |    |----ktime_get (475.524857)
     |    |    |----ktime_get_ts (475.524858)
     |    |         |----getnstimeofday (475.524858)
     |    |         |    |----read_hpet (475.524858)
     |    |         |         |----hpet_readl (475.524859)
     |    |         |----set_normalized_timespec (475.524860)
     |    |----tick_nohz_restart (475.524860)
     |----acpi_idle_enter_simple
     |    |----tsc_halts_in_c (475.524955)
     |----sched_clock_tick
     |    |----ktime_get (475.524956)
     |         |----ktime_get_ts (475.524956)
     |              |----getnstimeofday (475.524956)
     |              |    |----read_hpet (475.524957)
     |              |         |----hpet_readl (475.524957)
     |              |----set_normalized_timespec (475.524959)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.524959)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.524960)
     |         |----clockevents_notify (475.524960)
     |----_raw_spin_lock
     |    |----__delay (475.524960)
     |    |    |----delay_tsc (475.524961)
     |    |----__delay (475.524961)
     |    |    |----delay_tsc (475.524962)
     |    |----__delay (475.524962)
     |    |    |----delay_tsc (475.524962)
     |    |----__delay (475.524963)
     |    |    |----delay_tsc (475.524963)
     |    |----__delay (475.524964)
     |    |    |----delay_tsc (475.524964)
     |    |----__delay (475.524964)
     |    |    |----delay_tsc (475.524965)
     |    |----__delay (475.524965)
     |    |    |----delay_tsc (475.524966)
     |    |----__delay (475.524966)
     |    |    |----delay_tsc (475.524966)
     |    |----__delay (475.524967)
     |    |    |----delay_tsc (475.524967)
     |    |----__delay (475.524968)
     |         |----delay_tsc (475.524968)
     |----clockevents_notify
     |    |----clockevents_do_notify (475.524968)
     |         |----raw_notifier_call_chain (475.524969)
     |              |----__raw_notifier_call_chain (475.524969)
     |----notifier_call_chain
     |    |----tick_notify (475.524969)
     |         |----tick_broadcast_oneshot_control (475.524970)
     |              |----clockevents_set_mode (475.524970)
     |              |    |----lapic_timer_setup (475.524971)
     |              |         |----__setup_APIC_LVTT (475.524971)
     |              |              |----native_apic_mem_read (475.524971)
     |              |              |----native_apic_mem_write (475.524972)
     |              |              |----native_apic_mem_read (475.524972)
     |              |              |----native_apic_mem_write (475.524973)
     |              |----tick_program_event (475.524973)
     |                   |----tick_dev_program_event (475.524973)
     |                        |----ktime_get (475.524974)
     |                        |    |----ktime_get_ts (475.524974)
     |                        |         |----getnstimeofday (475.524974)
     |                        |         |    |----read_hpet (475.524975)
     |                        |         |         |----hpet_readl (475.524975)
     |                        |         |----set_normalized_timespec (475.524976)
     |                        |----clockevents_program_event (475.524977)
     |                             |----lapic_next_event (475.524977)
     |                                  |----native_apic_mem_write (475.524977)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.524978)
     |----cpu_idle
     |    |----rcu_pending (475.524979)
     |         |----__rcu_pending (475.524979)
     |----acpi_state_timer_broadcast
     |    |----clockevents_notify (475.524984)
     |         |----clockevents_do_notify (475.524984)
     |              |----raw_notifier_call_chain (475.524985)
     |                   |----__raw_notifier_call_chain (475.524985)
     |----notifier_call_chain
     |    |----tick_notify (475.524985)
     |         |----tick_broadcast_oneshot_control (475.524986)
     |              |----clockevents_set_mode (475.524986)
     |                   |----lapic_timer_setup (475.524987)
     |                        |----native_apic_mem_read (475.524987)
     |                        |----native_apic_mem_write (475.524987)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.524990)
     |    |    |----mwait_idle_with_hints (475.524990)
     |    |----tsc_halts_in_c (475.525019)
     |----sched_clock_tick
     |    |----ktime_get (475.525019)
     |         |----ktime_get_ts (475.525020)
     |              |----getnstimeofday (475.525020)
     |              |    |----read_hpet (475.525020)
     |              |         |----hpet_readl (475.525021)
     |              |----set_normalized_timespec (475.525022)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.525023)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.525023)
     |         |----clockevents_notify (475.525024)
     |              |----clockevents_do_notify (475.525024)
     |                   |----raw_notifier_call_chain (475.525024)
     |                        |----__raw_notifier_call_chain (475.525025)
     |----notifier_call_chain
     |    |----tick_notify (475.525025)
     |         |----tick_broadcast_oneshot_control (475.525025)
     |              |----clockevents_set_mode (475.525026)
     |              |    |----lapic_timer_setup (475.525026)
     |              |         |----__setup_APIC_LVTT (475.525027)
     |              |              |----native_apic_mem_read (475.525027)
     |              |              |----native_apic_mem_write (475.525027)
     |              |              |----native_apic_mem_read (475.525028)
     |              |              |----native_apic_mem_write (475.525028)
     |              |----tick_program_event (475.525028)
     |                   |----tick_dev_program_event (475.525029)
     |                        |----ktime_get (475.525029)
     |                        |    |----ktime_get_ts (475.525030)
     |                        |         |----getnstimeofday (475.525030)
     |                        |         |    |----read_hpet (475.525030)
     |                        |         |         |----hpet_readl (475.525031)
     |                        |         |----set_normalized_timespec (475.525032)
     |                        |----clockevents_program_event (475.525032)
     |                             |----lapic_next_event (475.525033)
     |                                  |----native_apic_mem_write (475.525033)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.525034)
     |----cpu_idle
     |    |----rcu_pending (475.525034)
     |    |    |----__rcu_pending (475.525035)
     |    |    |----__rcu_pending (475.525035)
     |    |----cpuidle_idle_call (475.525035)
     |         |----hrtimer_peek_ahead_timers (475.525036)
     |         |    |----hrtimer_interrupt (475.525036)
     |         |         |----ktime_get (475.525036)
     |         |         |    |----ktime_get_ts (475.525037)
     |         |         |         |----getnstimeofday (475.525037)
     |         |         |         |    |----read_hpet (475.525037)
     |         |         |         |         |----hpet_readl (475.525038)
     |         |         |         |----set_normalized_timespec (475.525039)
     |         |         |----tick_program_event (475.525040)
     |         |              |----tick_dev_program_event (475.525040)
     |         |                   |----ktime_get (475.525041)
     |         |                   |    |----ktime_get_ts (475.525041)
     |         |                   |         |----getnstimeofday (475.525041)
     |         |                   |         |    |----read_hpet (475.525042)
     |         |                   |         |         |----hpet_readl (475.525042)
     |         |                   |         |----set_normalized_timespec (475.525043)
     |         |                   |----clockevents_program_event (475.525044)
     |         |                        |----lapic_next_event (475.525044)
     |         |                             |----native_apic_mem_write (475.525044)
     |         |----menu_select (475.525045)
     |         |    |----pm_qos_requirement (475.525045)
     |         |    |----tick_nohz_get_sleep_length (475.525046)
     |         |----acpi_idle_enter_c1 (475.525046)
     |              |----acpi_processor_ffh_cstate_enter (475.525048)
     |                   |----mwait_idle_with_hints (475.525048)
     |----apic_timer_interrupt
     |    |----smp_apic_timer_interrupt (475.530871)
     |         |----native_apic_mem_write (475.530871)
     |         |----irq_enter (475.530871)
     |              |----tick_check_idle (475.530872)
     |                   |----tick_check_oneshot_broadcast (475.530872)
     |                   |----tick_nohz_stop_idle (475.530872)
     |                        |----ktime_get (475.530873)
     |                             |----ktime_get_ts (475.530873)
     |                                  |----getnstimeofday (475.530873)
     |                                  |    |----read_hpet (475.530874)
     |                                  |         |----hpet_readl (475.530874)
     |                                  |----set_normalized_timespec (475.530875)
     |----sched_clock_tick
     |    |----ktime_get (475.530876)
     |         |----ktime_get_ts (475.530876)
     |              |----getnstimeofday (475.530876)
     |              |    |----read_hpet (475.530877)
     |              |         |----hpet_readl (475.530877)
     |              |----set_normalized_timespec (475.530878)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.530879)
     |----tick_check_idle
     |    |----tick_nohz_update_jiffies (475.530879)
     |    |    |----ktime_get (475.530880)
     |    |    |    |----ktime_get_ts (475.530880)
     |    |    |         |----getnstimeofday (475.530880)
     |    |    |         |    |----read_hpet (475.530881)
     |    |    |         |         |----hpet_readl (475.530881)
     |    |    |         |----set_normalized_timespec (475.530882)
     |    |    |----tick_do_update_jiffies64 (475.530883)
     |    |    |    |----do_timer (475.530883)
     |    |    |         |----update_wall_time (475.530884)
     |    |    |              |----read_hpet (475.530884)
     |    |    |              |    |----hpet_readl (475.530884)
     |    |    |              |----update_xtime_cache (475.530886)
     |    |    |              |----clocksource_get_next (475.530886)
     |    |    |----touch_softlockup_watchdog (475.530887)
     |    |----ktime_get (475.530887)
     |    |    |----ktime_get_ts (475.530888)
     |    |         |----getnstimeofday (475.530888)
     |    |         |    |----read_hpet (475.530888)
     |    |         |         |----hpet_readl (475.530889)
     |    |         |----set_normalized_timespec (475.530890)
     |    |----tick_nohz_restart (475.530890)
     |         |----hrtimer_cancel (475.530891)
     |         |    |----hrtimer_try_to_cancel (475.530891)
     |         |         |----lock_hrtimer_base (475.530891)
     |         |         |----__remove_hrtimer (475.530892)
     |         |----hrtimer_forward (475.530892)
     |         |    |----ktime_divns (475.530893)
     |         |    |----ktime_add_safe (475.530893)
     |         |    |----ktime_add_safe (475.530893)
     |         |----hrtimer_start_range_ns (475.530894)
     |              |----lock_hrtimer_base (475.530894)
     |              |----ktime_add_safe (475.530895)
     |              |----__timer_stats_hrtimer_set_start_info (475.530895)
     |              |----enqueue_hrtimer (475.530895)
     |----smp_apic_timer_interrupt
     |    |----hrtimer_interrupt (475.530896)
     |    |    |----ktime_get (475.530896)
     |    |    |    |----ktime_get_ts (475.530897)
     |    |    |         |----getnstimeofday (475.530897)
     |    |    |         |    |----read_hpet (475.530897)
     |    |    |         |         |----hpet_readl (475.530898)
     |    |    |         |----set_normalized_timespec (475.530900)
     |    |    |----__run_hrtimer (475.530901)
     |    |    |    |----__remove_hrtimer (475.530901)
     |    |    |    |----timer_stats_update_stats (475.530901)
     |    |    |    |----hrtimer_wakeup (475.530902)
     |    |    |----tick_program_event (475.530906)
     |    |         |----tick_dev_program_event (475.530907)
     |    |              |----ktime_get (475.530907)
     |    |              |    |----ktime_get_ts (475.530907)
     |    |              |         |----getnstimeofday (475.530908)
     |    |              |         |    |----read_hpet (475.530908)
     |    |              |         |         |----hpet_readl (475.530908)
     |    |              |         |----set_normalized_timespec (475.530910)
     |    |              |----clockevents_program_event (475.530910)
     |    |                   |----lapic_next_event (475.530911)
     |    |                        |----native_apic_mem_write (475.530911)
     |    |----irq_exit (475.530912)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.530912)
     |----cpu_idle
     |    |----tick_nohz_restart_sched_tick (475.530913)
     |         |----tick_nohz_stop_idle (475.530913)
     |         |----ktime_get (475.530913)
     |         |    |----ktime_get_ts (475.530914)
     |         |         |----getnstimeofday (475.530914)
     |         |         |    |----read_hpet (475.530914)
     |         |         |         |----hpet_readl (475.530915)
     |         |         |----set_normalized_timespec (475.530916)
     |         |----tick_do_update_jiffies64 (475.530917)
     |         |----touch_softlockup_watchdog (475.530917)
     |         |----tick_nohz_restart (475.530917)
     |              |----hrtimer_cancel (475.530918)
     |              |    |----hrtimer_try_to_cancel (475.530918)
     |              |         |----lock_hrtimer_base (475.530918)
     |              |         |----__remove_hrtimer (475.530919)
     |              |              |----hrtimer_force_reprogram (475.530919)
     |              |                   |----tick_program_event (475.530920)
     |              |                        |----tick_dev_program_event (475.530920)
     |              |                             |----ktime_get (475.530920)
     |              |                             |    |----ktime_get_ts (475.530921)
     |              |                             |         |----getnstimeofday (475.530921)
     |              |                             |         |    |----read_hpet (475.530921)
     |              |                             |         |         |----hpet_readl (475.530922)
     |              |                             |         |----set_normalized_timespec (475.530923)
     |              |                             |----clockevents_program_event (475.530924)
     |              |                                  |----lapic_next_event (475.530924)
     |              |                                       |----native_apic_mem_write (475.530924)
     |              |----hrtimer_forward (475.530925)
     |              |    |----ktime_divns (475.530925)
     |              |    |----ktime_add_safe (475.530926)
     |              |    |----ktime_add_safe (475.530926)
     |              |----hrtimer_start_range_ns (475.530926)
     |                   |----lock_hrtimer_base (475.530927)
     |                   |----ktime_add_safe (475.530927)
     |                   |----__timer_stats_hrtimer_set_start_info (475.530927)
     |                   |----enqueue_hrtimer (475.530928)
     |                        |----hrtimer_reprogram (475.530928)
     |                             |----tick_program_event (475.530928)
     |                                  |----tick_dev_program_event (475.530929)
     |                                       |----ktime_get (475.530929)
     |                                       |    |----ktime_get_ts (475.530929)
     |                                       |         |----getnstimeofday (475.530930)
     |                                       |         |    |----read_hpet (475.530930)
     |                                       |         |         |----hpet_readl (475.530930)
     |                                       |         |----set_normalized_timespec (475.530932)
     |                                       |----clockevents_program_event (475.530932)
     |                                            |----lapic_next_event (475.530933)
     |                                                 |----native_apic_mem_write (475.530933)
     |----schedule
     |    |----__switch_to (475.530935)
     |         |----math_state_restore (475.530935)
     |----schedule_hrtimeout_range
     |    |----hrtimer_cancel (475.530936)
     |         |----hrtimer_try_to_cancel (475.530940)
     |              |----lock_hrtimer_base (475.530940)
     |----do_sys_poll
     |    |----fget_light (475.530941)
     |    |----pipe_poll (475.530941)
     |    |----fput (475.530942)
     |    |----fget_light (475.530942)
     |    |----sock_poll (475.530943)
     |    |    |----unix_poll (475.530943)
     |    |----fput (475.530943)
     |    |----fget_light (475.530944)
     |    |----pipe_poll (475.530944)
     |    |----fput (475.530945)
     |    |----fget_light (475.530945)
     |    |----sock_poll (475.530946)
     |    |    |----unix_poll (475.530946)
     |    |----fput (475.530946)
     |    |----fget_light (475.530947)
     |    |----sock_poll (475.530947)
     |    |    |----unix_poll (475.530947)
     |    |----fput (475.530948)
     |    |----fget_light (475.530948)
     |    |----sock_poll (475.530949)
     |    |    |----unix_poll (475.530949)
     |    |----fput (475.530949)
     |    |----fget_light (475.530950)
     |    |----pipe_poll (475.530950)
     |    |----fput (475.530951)
     |    |----poll_freewait (475.530951)
     |         |----free_poll_entry (475.530951)
     |         |    |----remove_wait_queue (475.530952)
     |         |    |----fput (475.530952)
     |         |----free_poll_entry (475.530952)
     |         |    |----remove_wait_queue (475.530953)
     |         |    |----fput (475.530953)
     |         |----free_poll_entry (475.530954)
     |         |    |----remove_wait_queue (475.530954)
     |         |    |----fput (475.530955)
     |         |----free_poll_entry (475.530955)
     |         |    |----remove_wait_queue (475.530955)
     |         |    |----fput (475.530956)
     |         |----free_poll_entry (475.530956)
     |         |    |----remove_wait_queue (475.530956)
     |         |    |----fput (475.530957)
     |         |----free_poll_entry (475.530957)
     |         |    |----remove_wait_queue (475.530958)
     |         |    |----fput (475.530958)
     |         |----free_poll_entry (475.530958)
     |              |----remove_wait_queue (475.530959)
     |              |----fput (475.530959)
     |----sysenter_do_call
     |    |----sys_gettimeofday (475.530961)
     |    |    |----do_gettimeofday (475.530962)
     |    |    |    |----getnstimeofday (475.530962)
     |    |    |         |----read_hpet (475.530962)
     |    |    |              |----hpet_readl (475.530963)
     |    |    |----copy_to_user (475.530964)
     |    |         |----might_fault (475.530965)
     |    |         |----__copy_to_user_ll (475.530965)
     |    |----sys_ioctl (475.530968)
     |    |    |----fget_light (475.530968)
     |    |    |----security_file_ioctl (475.530969)
     |    |    |    |----cap_file_ioctl (475.530969)
     |    |    |----do_vfs_ioctl (475.530970)
     |    |    |    |----vfs_ioctl (475.530970)
     |    |    |         |----sock_ioctl (475.530970)
     |    |    |              |----unix_ioctl (475.530971)
     |    |    |                   |----might_fault (475.530971)
     |    |    |----fput (475.530972)
     |    |----sys_gettimeofday (475.530973)
     |    |    |----do_gettimeofday (475.530973)
     |    |    |    |----getnstimeofday (475.530974)
     |    |    |         |----read_hpet (475.530974)
     |    |    |              |----hpet_readl (475.530974)
     |    |    |----copy_to_user (475.530976)
     |    |         |----might_fault (475.530976)
     |    |         |----__copy_to_user_ll (475.530977)
     |    |----sys_poll (475.530978)
     |    |    |----poll_select_set_timeout (475.530979)
     |    |    |----do_sys_poll (475.530979)
     |    |         |----copy_from_user (475.530979)
     |    |         |    |----might_fault (475.530980)
     |    |         |    |----__copy_from_user_ll (475.530980)
     |    |         |----poll_initwait (475.530981)
     |    |         |----fget_light (475.530981)
     |    |         |----pipe_poll (475.530981)
     |    |         |----fput (475.530982)
     |    |         |----fget_light (475.530982)
     |    |         |----sock_poll (475.530983)
     |    |         |    |----unix_poll (475.530983)
     |    |         |----fput (475.530983)
     |    |         |----fget_light (475.530984)
     |    |         |----pipe_poll (475.530984)
     |    |         |----fput (475.530984)
     |    |         |----fget_light (475.530985)
     |    |         |----sock_poll (475.530985)
     |    |         |    |----unix_poll (475.530986)
     |    |         |----fput (475.530986)
     |    |         |----fget_light (475.530986)
     |    |         |----sock_poll (475.530987)
     |    |         |    |----unix_poll (475.530987)
     |    |         |----fput (475.530987)
     |    |         |----fget_light (475.530988)
     |    |         |----sock_poll (475.530988)
     |    |         |    |----unix_poll (475.530989)
     |    |         |----fput (475.530989)
     |    |         |----poll_freewait (475.530989)
     |    |----sys_gettimeofday (475.530991)
     |    |    |----do_gettimeofday (475.530992)
     |    |    |    |----getnstimeofday (475.530992)
     |    |    |         |----read_hpet (475.530993)
     |    |    |              |----hpet_readl (475.530993)
     |    |    |----copy_to_user (475.530994)
     |    |         |----might_fault (475.530995)
     |    |         |----__copy_to_user_ll (475.530995)
     |    |----sys_gettimeofday (475.530996)
     |    |    |----do_gettimeofday (475.530996)
     |    |    |    |----getnstimeofday (475.530997)
     |    |    |         |----read_hpet (475.530997)
     |    |    |              |----hpet_readl (475.530997)
     |    |    |----copy_to_user (475.530999)
     |    |         |----might_fault (475.530999)
     |    |         |----__copy_to_user_ll (475.530999)
     |    |----sys_gettimeofday (475.531001)
     |    |    |----do_gettimeofday (475.531001)
     |    |    |    |----getnstimeofday (475.531001)
     |    |    |         |----read_hpet (475.531002)
     |    |    |              |----hpet_readl (475.531002)
     |    |    |----copy_to_user (475.531003)
     |    |         |----might_fault (475.531004)
     |    |         |----__copy_to_user_ll (475.531004)
     |    |----sys_gettimeofday (475.531005)
     |    |    |----do_gettimeofday (475.531005)
     |    |    |    |----getnstimeofday (475.531005)
     |    |    |         |----read_hpet (475.531006)
     |    |    |              |----hpet_readl (475.531006)
     |    |    |----copy_to_user (475.531007)
     |    |         |----might_fault (475.531008)
     |    |         |----__copy_to_user_ll (475.531008)
     |    |----sys_gettimeofday (475.531013)
     |    |    |----do_gettimeofday (475.531014)
     |    |    |    |----getnstimeofday (475.531014)
     |    |    |         |----read_hpet (475.531015)
     |    |    |              |----hpet_readl (475.531015)
     |    |    |----copy_to_user (475.531016)
     |    |         |----might_fault (475.531017)
     |    |         |----__copy_to_user_ll (475.531017)
     |    |----sys_gettimeofday (475.531018)
     |    |    |----do_gettimeofday (475.531019)
     |    |    |    |----getnstimeofday (475.531019)
     |    |    |         |----read_hpet (475.531019)
     |    |    |              |----hpet_readl (475.531020)
     |    |    |----copy_to_user (475.531021)
     |    |         |----might_fault (475.531021)
     |    |         |----__copy_to_user_ll (475.531022)
     |    |----sys_gettimeofday (475.531022)
     |    |    |----do_gettimeofday (475.531023)
     |    |    |    |----getnstimeofday (475.531023)
     |    |    |         |----read_hpet (475.531023)
     |    |    |              |----hpet_readl (475.531024)
     |    |    |----copy_to_user (475.531025)
     |    |         |----might_fault (475.531026)
     |    |         |----__copy_to_user_ll (475.531026)
     |    |----sys_gettimeofday (475.531027)
     |    |    |----do_gettimeofday (475.531027)
     |    |    |    |----getnstimeofday (475.531028)
     |    |    |         |----read_hpet (475.531028)
     |    |    |              |----hpet_readl (475.531028)
     |    |    |----copy_to_user (475.531030)
     |    |         |----might_fault (475.531030)
     |    |         |----__copy_to_user_ll (475.531030)
     |    |----sys_gettimeofday (475.531031)
     |    |    |----do_gettimeofday (475.531031)
     |    |    |    |----getnstimeofday (475.531032)
     |    |    |         |----read_hpet (475.531032)
     |    |    |              |----hpet_readl (475.531032)
     |    |    |----copy_to_user (475.531034)
     |    |         |----might_fault (475.531034)
     |    |         |----__copy_to_user_ll (475.531035)
     |    |----sys_gettimeofday (475.531036)
     |    |    |----do_gettimeofday (475.531036)
     |    |    |    |----getnstimeofday (475.531036)
     |    |    |         |----read_hpet (475.531037)
     |    |    |              |----hpet_readl (475.531037)
     |    |    |----copy_to_user (475.531038)
     |    |         |----might_fault (475.531039)
     |    |         |----__copy_to_user_ll (475.531039)
     |    |----sys_ioctl (475.531042)
     |    |    |----fget_light (475.531042)
     |    |    |----security_file_ioctl (475.531043)
     |    |    |    |----cap_file_ioctl (475.531043)
     |    |    |----do_vfs_ioctl (475.531043)
     |    |    |    |----vfs_ioctl (475.531044)
     |    |    |         |----sock_ioctl (475.531044)
     |    |    |              |----unix_ioctl (475.531044)
     |    |    |                   |----might_fault (475.531045)
     |    |    |----fput (475.531045)
     |    |----sys_gettimeofday (475.531047)
     |    |    |----do_gettimeofday (475.531047)
     |    |    |    |----getnstimeofday (475.531047)
     |    |    |         |----read_hpet (475.531048)
     |    |    |              |----hpet_readl (475.531048)
     |    |    |----copy_to_user (475.531049)
     |    |         |----might_fault (475.531050)
     |    |         |----__copy_to_user_ll (475.531050)
     |    |----sys_poll (475.531052)
     |         |----poll_select_set_timeout (475.531055)
     |         |    |----ktime_get_ts (475.531056)
     |         |    |    |----getnstimeofday (475.531056)
     |         |    |    |    |----read_hpet (475.531056)
     |         |    |    |         |----hpet_readl (475.531057)
     |         |    |    |----set_normalized_timespec (475.531058)
     |         |    |----timespec_add_safe (475.531059)
     |         |         |----set_normalized_timespec (475.531059)
     |         |----do_sys_poll (475.531059)
     |              |----copy_from_user (475.531060)
     |              |    |----might_fault (475.531060)
     |              |    |----__copy_from_user_ll (475.531060)
     |              |----poll_initwait (475.531061)
     |              |----estimate_accuracy (475.531061)
     |              |    |----ktime_get_ts (475.531062)
     |              |    |    |----getnstimeofday (475.531062)
     |              |    |    |    |----read_hpet (475.531062)
     |              |    |    |         |----hpet_readl (475.531063)
     |              |    |    |----set_normalized_timespec (475.531064)
     |              |    |----set_normalized_timespec (475.531064)
     |              |----fget_light (475.531065)
     |              |----pipe_poll (475.531065)
     |              |    |----__pollwait (475.531066)
     |              |         |----add_wait_queue (475.531066)
     |              |----fput (475.531067)
     |              |----fget_light (475.531067)
     |              |----sock_poll (475.531067)
     |              |    |----unix_poll (475.531068)
     |              |         |----__pollwait (475.531068)
     |              |              |----add_wait_queue (475.531068)
     |              |----fput (475.531069)
     |              |----fget_light (475.531069)
     |              |----pipe_poll (475.531070)
     |              |    |----__pollwait (475.531070)
     |              |         |----add_wait_queue (475.531071)
     |              |----fput (475.531071)
     |              |----fget_light (475.531072)
     |              |----sock_poll (475.531072)
     |              |    |----unix_poll (475.531072)
     |              |         |----__pollwait (475.531073)
     |              |              |----add_wait_queue (475.531073)
     |              |----fput (475.531074)
     |              |----fget_light (475.531074)
     |              |----sock_poll (475.531074)
     |              |    |----unix_poll (475.531075)
     |              |         |----__pollwait (475.531075)
     |              |              |----add_wait_queue (475.531076)
     |              |----fput (475.531076)
     |              |----fget_light (475.531077)
     |              |----sock_poll (475.531077)
     |              |    |----unix_poll (475.531077)
     |              |         |----__pollwait (475.531078)
     |              |              |----add_wait_queue (475.531078)
     |              |----fput (475.531079)
     |              |----fget_light (475.531079)
     |              |----pipe_poll (475.531079)
     |              |    |----__pollwait (475.531080)
     |              |         |----add_wait_queue (475.531080)
     |              |----fput (475.531081)
     |----schedule_hrtimeout_range
     |    |----hrtimer_init (475.531081)
     |    |----ktime_add_safe (475.531082)
     |    |----hrtimer_init_sleeper (475.531082)
     |    |----hrtimer_start_range_ns (475.531082)
     |         |----lock_hrtimer_base (475.531083)
     |         |----ktime_add_safe (475.531083)
     |         |----__timer_stats_hrtimer_set_start_info (475.531084)
     |         |----enqueue_hrtimer (475.531084)
     |----schedule
     |    |----msecs_to_jiffies (475.531087)
     |    |----__switch_to (475.531088)
     |----cpu_idle
     |    |----tick_nohz_stop_sched_tick (475.531089)
     |    |    |----ktime_get (475.531089)
     |    |    |    |----ktime_get_ts (475.531090)
     |    |    |         |----getnstimeofday (475.531090)
     |    |    |         |    |----read_hpet (475.531090)
     |    |    |         |         |----hpet_readl (475.531091)
     |    |    |         |----set_normalized_timespec (475.531092)
     |    |    |----get_next_timer_interrupt (475.531093)
     |    |    |    |----hrtimer_get_next_event (475.531094)
     |    |    |----rcu_needs_cpu (475.531095)
     |    |    |    |----rcu_pending (475.531096)
     |    |    |         |----__rcu_pending (475.531096)
     |    |    |         |----__rcu_pending (475.531096)
     |    |    |----printk_needs_cpu (475.531097)
     |    |    |----hrtimer_start (475.531097)
     |    |         |----hrtimer_start_range_ns (475.531098)
     |    |              |----lock_hrtimer_base (475.531098)
     |    |              |----__remove_hrtimer (475.531098)
     |    |              |    |----hrtimer_force_reprogram (475.531099)
     |    |              |         |----tick_program_event (475.531099)
     |    |              |              |----tick_dev_program_event (475.531099)
     |    |              |                   |----ktime_get (475.531100)
     |    |              |                   |    |----ktime_get_ts (475.531100)
     |    |              |                   |         |----getnstimeofday (475.531100)
     |    |              |                   |         |    |----read_hpet (475.531101)
     |    |              |                   |         |         |----hpet_readl (475.531101)
     |    |              |                   |         |----set_normalized_timespec (475.531103)
     |    |              |                   |----clockevents_program_event (475.531103)
     |    |              |                        |----lapic_next_event (475.531103)
     |    |              |                             |----native_apic_mem_write (475.531104)
     |    |              |----ktime_add_safe (475.531104)
     |    |              |----__timer_stats_hrtimer_set_start_info (475.531105)
     |    |              |----enqueue_hrtimer (475.531105)
     |    |----rcu_pending (475.531106)
     |    |    |----__rcu_pending (475.531106)
     |    |    |----__rcu_pending (475.531106)
     |    |----cpuidle_idle_call (475.531107)
     |         |----hrtimer_peek_ahead_timers (475.531107)
     |         |    |----hrtimer_interrupt (475.531107)
     |         |         |----ktime_get (475.531108)
     |         |         |    |----ktime_get_ts (475.531108)
     |         |         |         |----getnstimeofday (475.531108)
     |         |         |         |    |----read_hpet (475.531109)
     |         |         |         |         |----hpet_readl (475.531109)
     |         |         |         |----set_normalized_timespec (475.531111)
     |         |         |----tick_program_event (475.531111)
     |         |              |----tick_dev_program_event (475.531112)
     |         |                   |----ktime_get (475.531112)
     |         |                   |    |----ktime_get_ts (475.531112)
     |         |                   |         |----getnstimeofday (475.531113)
     |         |                   |         |    |----read_hpet (475.531113)
     |         |                   |         |         |----hpet_readl (475.531113)
     |         |                   |         |----set_normalized_timespec (475.531115)
     |         |                   |----clockevents_program_event (475.531115)
     |         |                        |----lapic_next_event (475.531115)
     |         |                             |----native_apic_mem_write (475.531116)
     |         |----menu_select (475.531116)
     |         |    |----pm_qos_requirement (475.531117)
     |         |    |----tick_nohz_get_sleep_length (475.531117)
     |         |----acpi_idle_enter_simple (475.531117)
     |              |----acpi_state_timer_broadcast (475.531118)
     |                   |----clockevents_notify (475.531118)
     |                        |----clockevents_do_notify (475.531118)
     |                             |----raw_notifier_call_chain (475.531119)
     |                                  |----__raw_notifier_call_chain (475.531119)
     |----notifier_call_chain
     |    |----tick_notify (475.531119)
     |         |----tick_broadcast_oneshot_control (475.531120)
     |              |----clockevents_set_mode (475.531120)
     |                   |----lapic_timer_setup (475.531121)
     |                        |----native_apic_mem_read (475.531121)
     |                        |----native_apic_mem_write (475.531122)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.531124)
     |    |    |----mwait_idle_with_hints (475.531125)
     |    |----tsc_halts_in_c (475.531144)
     |----sched_clock_tick
     |    |----ktime_get (475.531144)
     |         |----ktime_get_ts (475.531144)
     |              |----getnstimeofday (475.531145)
     |              |    |----read_hpet (475.531145)
     |              |         |----hpet_readl (475.531145)
     |              |----set_normalized_timespec (475.531147)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.531147)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.531148)
     |         |----clockevents_notify (475.531148)
     |              |----clockevents_do_notify (475.531149)
     |                   |----raw_notifier_call_chain (475.531149)
     |                        |----__raw_notifier_call_chain (475.531149)
     |----notifier_call_chain
     |    |----tick_notify (475.531150)
     |         |----tick_broadcast_oneshot_control (475.531150)
     |              |----clockevents_set_mode (475.531151)
     |              |    |----lapic_timer_setup (475.531151)
     |              |         |----__setup_APIC_LVTT (475.531151)
     |              |              |----native_apic_mem_read (475.531152)
     |              |              |----native_apic_mem_write (475.531152)
     |              |              |----native_apic_mem_read (475.531152)
     |              |              |----native_apic_mem_write (475.531153)
     |              |----tick_program_event (475.531153)
     |                   |----tick_dev_program_event (475.531154)
     |                        |----ktime_get (475.531154)
     |                        |    |----ktime_get_ts (475.531154)
     |                        |         |----getnstimeofday (475.531155)
     |                        |         |    |----read_hpet (475.531155)
     |                        |         |         |----hpet_readl (475.531155)
     |                        |         |----set_normalized_timespec (475.531157)
     |                        |----clockevents_program_event (475.531157)
     |                             |----lapic_next_event (475.531157)
     |                                  |----native_apic_mem_write (475.531158)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.531159)
     |----cpu_idle
     |    |----rcu_pending (475.531159)
     |    |    |----__rcu_pending (475.531159)
     |    |    |----__rcu_pending (475.531160)
     |    |----cpuidle_idle_call (475.531160)
     |         |----hrtimer_peek_ahead_timers (475.531160)
     |         |    |----hrtimer_interrupt (475.531161)
     |         |         |----ktime_get (475.531161)
     |         |         |    |----ktime_get_ts (475.531161)
     |         |         |         |----getnstimeofday (475.531162)
     |         |         |         |    |----read_hpet (475.531162)
     |         |         |         |         |----hpet_readl (475.531162)
     |         |         |         |----set_normalized_timespec (475.531164)
     |         |         |----tick_program_event (475.531165)
     |         |              |----tick_dev_program_event (475.531165)
     |         |                   |----ktime_get (475.531165)
     |         |                   |    |----ktime_get_ts (475.531166)
     |         |                   |         |----getnstimeofday (475.531166)
     |         |                   |         |    |----read_hpet (475.531166)
     |         |                   |         |         |----hpet_readl (475.531167)
     |         |                   |         |----set_normalized_timespec (475.531168)
     |         |                   |----clockevents_program_event (475.531169)
     |         |                        |----lapic_next_event (475.531169)
     |         |                             |----native_apic_mem_write (475.531169)
     |         |----menu_select (475.531170)
     |         |    |----pm_qos_requirement (475.531170)
     |         |    |----tick_nohz_get_sleep_length (475.531170)
     |         |----acpi_idle_enter_simple (475.531171)
     |              |----acpi_state_timer_broadcast (475.531171)
     |                   |----clockevents_notify (475.531174)
     |                        |----clockevents_do_notify (475.531175)
     |                             |----raw_notifier_call_chain (475.531175)
     |                                  |----__raw_notifier_call_chain (475.531175)
     |----notifier_call_chain
     |    |----tick_notify (475.531176)
     |         |----tick_broadcast_oneshot_control (475.531176)
     |              |----clockevents_set_mode (475.531177)
     |                   |----lapic_timer_setup (475.531177)
     |                        |----native_apic_mem_read (475.531177)
     |                        |----native_apic_mem_write (475.531178)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.531180)
     |    |    |----mwait_idle_with_hints (475.531181)
     |    |----tsc_halts_in_c (475.531210)
     |----sched_clock_tick
     |    |----ktime_get (475.531210)
     |         |----ktime_get_ts (475.531210)
     |              |----getnstimeofday (475.531211)
     |              |    |----read_hpet (475.531211)
     |              |         |----hpet_readl (475.531211)
     |              |----set_normalized_timespec (475.531213)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.531213)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.531214)
     |         |----clockevents_notify (475.531214)
     |              |----clockevents_do_notify (475.531215)
     |                   |----raw_notifier_call_chain (475.531215)
     |                        |----__raw_notifier_call_chain (475.531215)
     |----notifier_call_chain
     |    |----tick_notify (475.531216)
     |         |----tick_broadcast_oneshot_control (475.531216)
     |              |----clockevents_set_mode (475.531217)
     |              |    |----lapic_timer_setup (475.531217)
     |              |         |----__setup_APIC_LVTT (475.531217)
     |              |              |----native_apic_mem_read (475.531218)
     |              |              |----native_apic_mem_write (475.531218)
     |              |              |----native_apic_mem_read (475.531218)
     |              |              |----native_apic_mem_write (475.531219)
     |              |----tick_program_event (475.531219)
     |                   |----tick_dev_program_event (475.531220)
     |                        |----ktime_get (475.531220)
     |                        |    |----ktime_get_ts (475.531220)
     |                        |         |----getnstimeofday (475.531220)
     |                        |         |    |----read_hpet (475.531221)
     |                        |         |         |----hpet_readl (475.531221)
     |                        |         |----set_normalized_timespec (475.531223)
     |                        |----clockevents_program_event (475.531223)
     |                             |----lapic_next_event (475.531223)
     |                                  |----native_apic_mem_write (475.531224)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.531224)
     |----cpu_idle
     |    |----rcu_pending (475.531225)
     |    |    |----__rcu_pending (475.531225)
     |    |    |----__rcu_pending (475.531225)
     |    |----cpuidle_idle_call (475.531226)
     |         |----hrtimer_peek_ahead_timers (475.531226)
     |         |    |----hrtimer_interrupt (475.531227)
     |         |         |----ktime_get (475.531227)
     |         |         |    |----ktime_get_ts (475.531227)
     |         |         |         |----getnstimeofday (475.531228)
     |         |         |         |    |----read_hpet (475.531228)
     |         |         |         |         |----hpet_readl (475.531228)
     |         |         |         |----set_normalized_timespec (475.531230)
     |         |         |----tick_program_event (475.531230)
     |         |              |----tick_dev_program_event (475.531231)
     |         |                   |----ktime_get (475.531231)
     |         |                   |    |----ktime_get_ts (475.531231)
     |         |                   |         |----getnstimeofday (475.531232)
     |         |                   |         |    |----read_hpet (475.531232)
     |         |                   |         |         |----hpet_readl (475.531232)
     |         |                   |         |----set_normalized_timespec (475.531234)
     |         |                   |----clockevents_program_event (475.531234)
     |         |                        |----lapic_next_event (475.531235)
     |         |                             |----native_apic_mem_write (475.531235)
     |         |----menu_select (475.531235)
     |         |    |----pm_qos_requirement (475.531236)
     |         |    |----tick_nohz_get_sleep_length (475.531236)
     |         |----acpi_idle_enter_c1 (475.531237)
     |              |----acpi_processor_ffh_cstate_enter (475.531239)
     |                   |----mwait_idle_with_hints (475.531239)
     |----common_interrupt
     |    |----do_IRQ (475.532829)
     |         |----irq_enter (475.532830)
     |              |----tick_check_idle (475.532830)
     |                   |----tick_check_oneshot_broadcast (475.532830)
     |                   |----tick_nohz_stop_idle (475.532831)
     |                        |----ktime_get (475.532831)
     |                             |----ktime_get_ts (475.532831)
     |                                  |----getnstimeofday (475.532831)
     |                                  |    |----read_hpet (475.532832)
     |                                  |         |----hpet_readl (475.532832)
     |                                  |----set_normalized_timespec (475.532834)
     |----sched_clock_tick
     |    |----ktime_get (475.532834)
     |         |----ktime_get_ts (475.532834)
     |              |----getnstimeofday (475.532835)
     |              |    |----read_hpet (475.532835)
     |              |         |----hpet_readl (475.532835)
     |              |----set_normalized_timespec (475.532837)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.532837)
     |----tick_check_idle
     |    |----tick_nohz_update_jiffies (475.532838)
     |    |    |----ktime_get (475.532838)
     |    |    |    |----ktime_get_ts (475.532838)
     |    |    |         |----getnstimeofday (475.532839)
     |    |    |         |    |----read_hpet (475.532839)
     |    |    |         |         |----hpet_readl (475.532839)
     |    |    |         |----set_normalized_timespec (475.532841)
     |    |    |----tick_do_update_jiffies64 (475.532841)
     |    |    |    |----do_timer (475.532842)
     |    |    |         |----update_wall_time (475.532842)
     |    |    |              |----read_hpet (475.532842)
     |    |    |              |    |----hpet_readl (475.532843)
     |    |    |              |----update_xtime_cache (475.532844)
     |    |    |              |----clocksource_get_next (475.532844)
     |    |    |----touch_softlockup_watchdog (475.532845)
     |    |----ktime_get (475.532845)
     |    |    |----ktime_get_ts (475.532846)
     |    |         |----getnstimeofday (475.532846)
     |    |         |    |----read_hpet (475.532846)
     |    |         |         |----hpet_readl (475.532847)
     |    |         |----set_normalized_timespec (475.532848)
     |    |----tick_nohz_restart (475.532849)
     |         |----hrtimer_cancel (475.532849)
     |         |    |----hrtimer_try_to_cancel (475.532849)
     |         |         |----lock_hrtimer_base (475.532849)
     |         |         |----__remove_hrtimer (475.532850)
     |         |----hrtimer_forward (475.532850)
     |         |    |----ktime_add_safe (475.532851)
     |         |    |----ktime_add_safe (475.532851)
     |         |----hrtimer_start_range_ns (475.532852)
     |              |----lock_hrtimer_base (475.532852)
     |              |----ktime_add_safe (475.532852)
     |              |----__timer_stats_hrtimer_set_start_info (475.532853)
     |              |----enqueue_hrtimer (475.532853)
     |                   |----hrtimer_reprogram (475.532854)
     |                        |----tick_program_event (475.532854)
     |                             |----tick_dev_program_event (475.532854)
     |                                  |----ktime_get (475.532855)
     |                                  |    |----ktime_get_ts (475.532855)
     |                                  |         |----getnstimeofday (475.532855)
     |                                  |         |    |----read_hpet (475.532856)
     |                                  |         |         |----hpet_readl (475.532856)
     |                                  |         |----set_normalized_timespec (475.532857)
     |                                  |----clockevents_program_event (475.532858)
     |                                       |----lapic_next_event (475.532858)
     |                                            |----native_apic_mem_write (475.532858)
     |----do_IRQ
     |    |----handle_edge_irq (475.532859)
     |    |    |----ack_apic_edge (475.532860)
     |    |    |    |----irq_complete_move (475.532860)
     |    |    |    |    |----irq_cfg (475.532860)
     |    |    |    |----move_native_irq (475.532861)
     |    |    |    |----native_apic_mem_write (475.532861)
     |    |    |----handle_IRQ_event (475.532861)
     |    |    |    |----timer_interrupt (475.532862)
     |    |    |         |----tick_handle_oneshot_broadcast (475.532862)
     |    |    |              |----ktime_get (475.532863)
     |    |    |              |    |----ktime_get_ts (475.532863)
     |    |    |              |         |----getnstimeofday (475.532863)
     |    |    |              |         |    |----read_hpet (475.532864)
     |    |    |              |         |         |----hpet_readl (475.532864)
     |    |    |              |         |----set_normalized_timespec (475.532865)
     |    |    |              |----tick_do_broadcast (475.532866)
     |    |    |              |----tick_broadcast_set_event (475.532866)
     |    |    |                   |----tick_dev_program_event (475.532867)
     |    |    |                        |----ktime_get (475.532867)
     |    |    |                        |    |----ktime_get_ts (475.532867)
     |    |    |                        |         |----getnstimeofday (475.532868)
     |    |    |                        |         |    |----read_hpet (475.532868)
     |    |    |                        |         |         |----hpet_readl (475.532868)
     |    |    |                        |         |----set_normalized_timespec (475.532870)
     |    |    |                        |----clockevents_program_event (475.532870)
     |    |    |                             |----hpet_legacy_next_event (475.532870)
     |    |    |                                  |----hpet_readl (475.532871)
     |    |    |                                  |----hpet_readl (475.532872)
     |    |    |                                  |----hpet_readl (475.532874)
     |    |    |----note_interrupt (475.532875)
     |    |----irq_exit (475.532876)
     |         |----tick_nohz_stop_sched_tick (475.532876)
     |              |----ktime_get (475.532877)
     |              |    |----ktime_get_ts (475.532877)
     |              |         |----getnstimeofday (475.532877)
     |              |         |    |----read_hpet (475.532878)
     |              |         |         |----hpet_readl (475.532878)
     |              |         |----set_normalized_timespec (475.532879)
     |              |----get_next_timer_interrupt (475.532880)
     |              |    |----hrtimer_get_next_event (475.532882)
     |              |----rcu_needs_cpu (475.532882)
     |              |    |----rcu_pending (475.532882)
     |              |         |----__rcu_pending (475.532883)
     |              |         |----__rcu_pending (475.532883)
     |              |----printk_needs_cpu (475.532883)
     |              |----hrtimer_start (475.532884)
     |                   |----hrtimer_start_range_ns (475.532884)
     |                        |----lock_hrtimer_base (475.532885)
     |                        |----__remove_hrtimer (475.532885)
     |                        |    |----hrtimer_force_reprogram (475.532885)
     |                        |         |----tick_program_event (475.532886)
     |                        |              |----tick_dev_program_event (475.532886)
     |                        |                   |----ktime_get (475.532886)
     |                        |                   |    |----ktime_get_ts (475.532887)
     |                        |                   |         |----getnstimeofday (475.532887)
     |                        |                   |         |    |----read_hpet (475.532887)
     |                        |                   |         |         |----hpet_readl (475.532888)
     |                        |                   |         |----set_normalized_timespec (475.532889)
     |                        |                   |----clockevents_program_event (475.532890)
     |                        |                        |----lapic_next_event (475.532890)
     |                        |                             |----native_apic_mem_write (475.532890)
     |                        |----ktime_add_safe (475.532891)
     |                        |----__timer_stats_hrtimer_set_start_info (475.532891)
     |                        |----enqueue_hrtimer (475.532891)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.532892)
     |----cpu_idle
     |    |----rcu_pending (475.532896)
     |    |    |----__rcu_pending (475.532896)
     |    |    |----__rcu_pending (475.532896)
     |    |----cpuidle_idle_call (475.532897)
     |         |----hrtimer_peek_ahead_timers (475.532897)
     |         |    |----hrtimer_interrupt (475.532898)
     |         |         |----ktime_get (475.532898)
     |         |         |    |----ktime_get_ts (475.532898)
     |         |         |         |----getnstimeofday (475.532899)
     |         |         |         |    |----read_hpet (475.532899)
     |         |         |         |         |----hpet_readl (475.532899)
     |         |         |         |----set_normalized_timespec (475.532901)
     |         |         |----tick_program_event (475.532901)
     |         |              |----tick_dev_program_event (475.532902)
     |         |                   |----ktime_get (475.532902)
     |         |                   |    |----ktime_get_ts (475.532902)
     |         |                   |         |----getnstimeofday (475.532903)
     |         |                   |         |    |----read_hpet (475.532903)
     |         |                   |         |         |----hpet_readl (475.532903)
     |         |                   |         |----set_normalized_timespec (475.532905)
     |         |                   |----clockevents_program_event (475.532905)
     |         |                        |----lapic_next_event (475.532905)
     |         |                             |----native_apic_mem_write (475.532906)
     |         |----menu_select (475.532906)
     |         |    |----pm_qos_requirement (475.532907)
     |         |    |----tick_nohz_get_sleep_length (475.532907)
     |         |----acpi_idle_enter_simple (475.532907)
     |              |----acpi_state_timer_broadcast (475.532908)
     |                   |----clockevents_notify (475.532908)
     |                        |----clockevents_do_notify (475.532908)
     |                             |----raw_notifier_call_chain (475.532909)
     |                                  |----__raw_notifier_call_chain (475.532909)
     |----notifier_call_chain
     |    |----tick_notify (475.532909)
     |         |----tick_broadcast_oneshot_control (475.532910)
     |              |----clockevents_set_mode (475.532910)
     |              |    |----lapic_timer_setup (475.532911)
     |              |         |----native_apic_mem_read (475.532911)
     |              |         |----native_apic_mem_write (475.532912)
     |              |----tick_broadcast_set_event (475.532912)
     |                   |----tick_dev_program_event (475.532912)
     |                        |----ktime_get (475.532913)
     |                        |    |----ktime_get_ts (475.532913)
     |                        |         |----getnstimeofday (475.532913)
     |                        |         |    |----read_hpet (475.532914)
     |                        |         |         |----hpet_readl (475.532914)
     |                        |         |----set_normalized_timespec (475.532915)
     |                        |----clockevents_program_event (475.532916)
     |                             |----hpet_legacy_next_event (475.532916)
     |                                  |----hpet_readl (475.532916)
     |                                  |----hpet_readl (475.532918)
     |                                  |----hpet_readl (475.532919)
     |----acpi_idle_enter_simple
     |    |----acpi_processor_ffh_cstate_enter (475.532923)
     |    |    |----mwait_idle_with_hints (475.532923)
     |    |----tsc_halts_in_c (475.532942)
     |----sched_clock_tick
     |    |----ktime_get (475.532943)
     |         |----ktime_get_ts (475.532943)
     |              |----getnstimeofday (475.532943)
     |              |    |----read_hpet (475.532944)
     |              |         |----hpet_readl (475.532944)
     |              |----set_normalized_timespec (475.532945)
     |----sched_clock_idle_wakeup_event
     |    |----touch_softlockup_watchdog (475.532946)
     |----acpi_idle_enter_simple
     |    |----acpi_state_timer_broadcast (475.532946)
     |         |----clockevents_notify (475.532947)
     |              |----clockevents_do_notify (475.532947)
     |                   |----raw_notifier_call_chain (475.532948)
     |                        |----__raw_notifier_call_chain (475.532948)
     |----notifier_call_chain
     |    |----tick_notify (475.532948)
     |         |----tick_broadcast_oneshot_control (475.532949)
     |              |----clockevents_set_mode (475.532949)
     |              |    |----lapic_timer_setup (475.532950)
     |              |         |----__setup_APIC_LVTT (475.532950)
     |              |              |----native_apic_mem_read (475.532950)
     |              |              |----native_apic_mem_write (475.532951)
     |              |              |----native_apic_mem_read (475.532951)
     |              |              |----native_apic_mem_write (475.532951)
     |              |----tick_program_event (475.532952)
     |                   |----tick_dev_program_event (475.532952)
     |                        |----ktime_get (475.532952)
     |                        |    |----ktime_get_ts (475.532953)
     |                        |         |----getnstimeofday (475.532953)
     |                        |         |    |----read_hpet (475.532953)
     |                        |         |         |----hpet_readl (475.532954)
     |                        |         |----set_normalized_timespec (475.532955)
     |                        |----clockevents_program_event (475.532955)
     |                             |----lapic_next_event (475.532956)
     |                                  |----native_apic_mem_write (475.532956)
     |----cpuidle_idle_call
     |    |----menu_reflect (475.532957)
     |----cpu_idle
          |----rcu_pending (475.532957)
          |    |----__rcu_pending (475.532958)
          |    |----__rcu_pending (475.532958)
          |----cpuidle_idle_call (475.532958)


--------------080203060400060009090106--
