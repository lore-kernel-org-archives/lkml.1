Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbZLKPhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbZLKPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759163AbZLKPhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:37:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:57534 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096AbZLKPhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:37:10 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 6/9] kgdb: allow for cpu switch when single stepping
Date: Fri, 11 Dec 2009 09:36:14 -0600
Message-Id: <1260545777-8089-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-6-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-5-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-6-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:34.0113 (UTC) FILETIME=[B80E6B10:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb core should not assume that a single step operation of a
kernel thread will complete on the same CPU.  The single step flag is
set at the "thread" level and it is possible in a multi cpu system
that a kernel thread can get scheduled on another cpu the next time it
is run.

As a further safety net in case a slave cpu is hung, the debug master
cpu will try 100 times before giving up and assuming control of the
slave cpus is no longer possible.  It is more useful to be able to get
some information out of kgdb instead of spinning forever.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 29357a9..ca21fe9 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -129,6 +129,7 @@ struct task_struct		*kgdb_usethread;
 struct task_struct		*kgdb_contthread;
 
 int				kgdb_single_step;
+pid_t				kgdb_sstep_pid;
 
 /* Our I/O buffers. */
 static char			remcom_in_buffer[BUFMAX];
@@ -1400,6 +1401,7 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks = &kgdb_var;
 	unsigned long flags;
+	int sstep_tries = 100;
 	int error = 0;
 	int i, cpu;
 
@@ -1430,13 +1432,14 @@ acquirelock:
 		cpu_relax();
 
 	/*
-	 * Do not start the debugger connection on this CPU if the last
-	 * instance of the exception handler wanted to come into the
-	 * debugger on a different CPU via a single step
+	 * For single stepping, try to only enter on the processor
+	 * that was single stepping.  To gaurd against a deadlock, the
+	 * kernel will only try for the value of sstep_tries before
+	 * giving up and continuing on.
 	 */
 	if (atomic_read(&kgdb_cpu_doing_single_step) != -1 &&
-	    atomic_read(&kgdb_cpu_doing_single_step) != cpu) {
-
+	    (kgdb_info[cpu].task &&
+	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
 		touch_softlockup_watchdog();
 		clocksource_touch_watchdog();
@@ -1529,6 +1532,13 @@ acquirelock:
 	}
 
 kgdb_restore:
+	if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
+		int sstep_cpu = atomic_read(&kgdb_cpu_doing_single_step);
+		if (kgdb_info[sstep_cpu].task)
+			kgdb_sstep_pid = kgdb_info[sstep_cpu].task->pid;
+		else
+			kgdb_sstep_pid = 0;
+	}
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
 	touch_softlockup_watchdog();
-- 
1.6.4.rc1

