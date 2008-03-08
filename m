Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYCHPI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYCHPI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYCHPGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:06:41 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34566 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYCHPGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:06:39 -0500
Date: Sat, 8 Mar 2008 18:10:26 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] signals: join send_sigqueue() with send_group_sigqueue()
Message-ID: <20080308151026.GA25194@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We export send_sigqueue() and send_group_sigqueue() for the only user,
posix_timer_event(). This is a bit silly, because both are just trivial helpers
on top of do_send_sigqueue() and because the we pass the unused .si_signo
parameter.

Kill them both, rename do_send_sigqueue() to send_sigqueue(), and export it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    3 +--
 kernel/signal.c       |   15 +--------------
 kernel/posix-timers.c |    6 ++----
 3 files changed, 4 insertions(+), 20 deletions(-)

--- 25/include/linux/sched.h~6_SSQ_UNIFY	2008-03-07 17:26:31.000000000 +0300
+++ 25/include/linux/sched.h	2008-03-08 17:35:43.000000000 +0300
@@ -1708,8 +1708,7 @@ extern void zap_other_threads(struct tas
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
-extern int send_sigqueue(int, struct sigqueue *,  struct task_struct *);
-extern int send_group_sigqueue(int, struct sigqueue *,  struct task_struct *);
+extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
 
--- 25/kernel/signal.c~6_SSQ_UNIFY	2008-03-08 17:15:59.000000000 +0300
+++ 25/kernel/signal.c	2008-03-08 17:38:50.000000000 +0300
@@ -1240,8 +1240,7 @@ void sigqueue_free(struct sigqueue *q)
 	__sigqueue_free(q);
 }
 
-static int do_send_sigqueue(struct sigqueue *q, struct task_struct *t,
-				int group)
+int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 {
 	int sig = q->info.si_signo;
 	struct sigpending *pending;
@@ -1266,7 +1265,6 @@ static int do_send_sigqueue(struct sigqu
 		 * If an SI_TIMER entry is already queue just increment
 		 * the overrun count.
 		 */
-
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
 		goto out;
@@ -1283,17 +1281,6 @@ ret:
 	return ret;
 }
 
-int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
-{
-	return do_send_sigqueue(q, p, 0);
-}
-
-int
-send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
-{
-	return do_send_sigqueue(q, p, 1);
-}
-
 /*
  * Wake up any threads in the parent blocked in wait* syscalls.
  */
--- 25/kernel/posix-timers.c~6_SSQ_UNIFY	2008-02-15 16:59:17.000000000 +0300
+++ 25/kernel/posix-timers.c	2008-03-08 17:41:18.000000000 +0300
@@ -311,8 +311,7 @@ int posix_timer_event(struct k_itimer *t
 
 	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
 		struct task_struct *leader;
-		int ret = send_sigqueue(timr->it_sigev_signo, timr->sigq,
-					timr->it_process);
+		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
 
 		if (likely(ret >= 0))
 			return ret;
@@ -323,8 +322,7 @@ int posix_timer_event(struct k_itimer *t
 		timr->it_process = leader;
 	}
 
-	return send_group_sigqueue(timr->it_sigev_signo, timr->sigq,
-				   timr->it_process);
+	return send_sigqueue(timr->sigq, timr->it_process, 1);
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 

