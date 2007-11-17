Return-Path: <linux-kernel-owner+w=401wt.eu-S1765215AbXKQSbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765215AbXKQSbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbXKQSbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:31:14 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56462 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420AbXKQSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:31:11 -0500
Date: Sat, 17 Nov 2007 21:31:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] do_task_stat: don't use task_pid_nr_ns() lockless
Message-ID: <20071117183109.GA2605@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Without rcu/tasklist/siglock lock task_pid_nr_ns() may read the freed memory,
move the callsite under ->siglock.

Sadly, we can report pid == 0 if the task was detached.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 24/fs/proc/array.c~dtst	2007-11-09 12:57:30.000000000 +0300
+++ 24/fs/proc/array.c	2007-11-17 21:26:55.000000000 +0300
@@ -392,7 +392,7 @@ static int do_task_stat(struct task_stru
 	sigset_t sigign, sigcatch;
 	char state;
 	int res;
-	pid_t ppid = 0, pgid = -1, sid = -1;
+	pid_t pid = 0, ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
 	struct mm_struct *mm;
 	unsigned long long start_time;
@@ -403,9 +403,6 @@ static int do_task_stat(struct task_stru
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
-	struct pid_namespace *ns;
-
-	ns = current->nsproxy->pid_ns;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -425,6 +422,7 @@ static int do_task_stat(struct task_stru
 
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
+		struct pid_namespace *ns = current->nsproxy->pid_ns;
 		struct signal_struct *sig = task->signal;
 
 		if (sig->tty) {
@@ -461,6 +459,7 @@ static int do_task_stat(struct task_stru
 			gtime = cputime_add(gtime, sig->gtime);
 		}
 
+		pid = task_pid_nr_ns(task, ns);
 		sid = task_session_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 		ppid = task_ppid_nr_ns(task, ns);
@@ -495,7 +494,7 @@ static int do_task_stat(struct task_stru
 	res = sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
 %lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
-		task_pid_nr_ns(task, ns),
+		pid,
 		tcomm,
 		state,
 		ppid,

