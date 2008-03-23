Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbYCWNCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbYCWNCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 09:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762007AbYCWNCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 09:02:15 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46059 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761987AbYCWNCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 09:02:14 -0400
Date: Sun, 23 Mar 2008 16:06:48 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] signals: fix /sbin/init protection from unwanted signals
Message-ID: <20080323130648.GA236@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global init has a lot of long standing problems with the unhandled fatal
signals.

	- The "is_global_init(current)" check in get_signal_to_deliver()
	  protects only the main thread. Sub-thread can dequee the fatal
	  signal and shutdown the whole thread group except the main thread.
	  If it dequeues SIGSTOP /sbin/init will be stopped, this is not
	  right too. Note that we can't use is_global_init(->group_leader),
	  this breaks exec and this can't solve other problems we have.

	- Even if afterwards ignored, the fatal signals sets SIGNAL_GROUP_EXIT
	  on delivery. This breaks exec, has other bad implications, and this
	  is just wrong.

Introduce the new SIGNAL_UNKILLABLE flag to fix these problems. It also
helps to solve some other problems addressed by the subsequent patches.

Currently we use this flag for the global init only, but it could also be
used by kthreads and (perhaps) by the sub-namespace inits.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

 include/linux/sched.h |    2 ++
 init/main.c           |    2 ++
 kernel/signal.c       |    9 ++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

--- 25/include/linux/sched.h~1_INIT_SIGS	2008-03-08 17:35:43.000000000 +0300
+++ 25/include/linux/sched.h	2008-03-08 17:35:43.000000000 +0300
@@ -562,6 +562,8 @@ struct signal_struct {
 #define SIGNAL_CLD_CONTINUED	0x00000020
 #define SIGNAL_CLD_MASK		(SIGNAL_CLD_STOPPED|SIGNAL_CLD_CONTINUED)
 
+#define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
+
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
 {
--- 25/init/main.c~1_INIT_SIGS	2008-02-15 16:59:17.000000000 +0300
+++ 25/init/main.c	2008-03-16 13:57:51.000000000 +0300
@@ -787,6 +787,8 @@ static int noinline init_post(void)
 	(void) sys_dup(0);
 	(void) sys_dup(0);
 
+	current->signal->flags |= SIGNAL_UNKILLABLE;
+
 	if (ramdisk_execute_command) {
 		run_init_process(ramdisk_execute_command);
 		printk(KERN_WARNING "Failed to execute %s\n",
--- 25/kernel/signal.c~1_INIT_SIGS	2008-03-14 11:33:20.000000000 +0300
+++ 25/kernel/signal.c	2008-03-16 15:45:56.000000000 +0300
@@ -713,7 +713,8 @@ static void complete_signal(int sig, str
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
+	if (sig_fatal(p, sig) &&
+	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
 		/*
@@ -1600,7 +1601,8 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
+					 != SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*
@@ -1729,7 +1731,8 @@ relock:
 		/*
 		 * Global init gets no signals it doesn't want.
 		 */
-		if (is_global_init(current))
+		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
+		    !signal_group_exit(signal))
 			continue;
 
 		if (sig_kernel_stop(signr)) {

