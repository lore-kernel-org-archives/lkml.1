Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZCRJTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZCRJTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZCRJTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:19:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:57624 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbZCRJTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:19:08 -0400
Date: Wed, 18 Mar 2009 09:18:38 GMT
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:tracing/tasks] tracing: replace the crude (unsigned) -1 hackery
Message-ID: <tip-2c7eea4c62ba090b7f4583c3d7337ea0019be900@git.kernel.org>
Git-Commit-ID: 2c7eea4c62ba090b7f4583c3d7337ea0019be900
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 09:18:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c7eea4c62ba090b7f4583c3d7337ea0019be900
Gitweb:     http://git.kernel.org/tip/2c7eea4c62ba090b7f4583c3d7337ea0019be900
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 18 Mar 2009 09:03:19 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 10:10:17 +0100

tracing: replace the crude (unsigned) -1 hackery

Impact: cleanup

The command line recorder uses (unsigned) -1 to mark non mapped
entries in the pid to command line maps. The validity check is
completely unintuitive: idx >= SAVED_CMDLINES

There is no need for such casting games. Use a constant to mark
unmapped entries and check for that constant to make the code readable
and understandable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7b6043e..ca673c4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -633,6 +633,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 }
 
 #define SAVED_CMDLINES 128
+#define NO_CMDLINE_MAP UINT_MAX
 static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
 static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
 static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
@@ -644,8 +645,8 @@ static atomic_t trace_record_cmdline_disabled __read_mostly;
 
 static void trace_init_cmdlines(void)
 {
-	memset(&map_pid_to_cmdline, -1, sizeof(map_pid_to_cmdline));
-	memset(&map_cmdline_to_pid, -1, sizeof(map_cmdline_to_pid));
+	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
+	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
 	cmdline_idx = 0;
 }
 
@@ -753,12 +754,12 @@ static void trace_save_cmdline(struct task_struct *tsk)
 		return;
 
 	idx = map_pid_to_cmdline[tsk->pid];
-	if (idx >= SAVED_CMDLINES) {
+	if (idx == NO_CMDLINE_MAP) {
 		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
 
 		map = map_cmdline_to_pid[idx];
-		if (map <= PID_MAX_DEFAULT)
-			map_pid_to_cmdline[map] = (unsigned)-1;
+		if (map != NO_CMDLINE_MAP)
+			map_pid_to_cmdline[map] = NO_CMDLINE_MAP;
 
 		map_pid_to_cmdline[tsk->pid] = idx;
 
@@ -786,7 +787,7 @@ void trace_find_cmdline(int pid, char comm[])
 
 	__raw_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
-	if (map >= SAVED_CMDLINES)
+	if (map == NO_CMDLINE_MAP)
 		goto out;
 
 	strcpy(comm, saved_cmdlines[map]);
