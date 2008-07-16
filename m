Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYGPOu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYGPOu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbYGPOut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:50:49 -0400
Received: from mail12.svc.cra.dublin.eircom.net ([159.134.118.28]:41421 "HELO
	mail12.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752686AbYGPOus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:50:48 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>
Subject: [PATCH] posix-timers: Do not modify an already queued timer signal
Date: Wed, 16 Jul 2008 15:50:46 +0100
Message-Id: <1216219846-663-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a timer fires, posix_timer_event() zeroes out its
pre-allocated siginfo structure, initialises it and then
queues up the signal with send_sigqueue().

However, we may have previously queued up this signal, in
which case we only want to increment si_overrun and
re-initialising the siginfo structure is incorrect.

Also, since we are modifying an already queued signal
without the protection of the sighand spinlock, we may also
race with e.g. collect_signal() causing it to fail to find
a signal on the pending list because it happens to look at
the siginfo struct after it was zeroed and before it was
re-initialised.

The race was observed with a modified kvm-userspace when
running a guest under heavy network load. When it occurs,
KVM never sees another SIGALRM signal because although
the signal is queued up the appropriate bit is never set
in the pending mask. Manually sending the process a SIGALRM
kicks it out of this state.

The fix is simple - only modify the pre-allocated sigqueue
once we're sure that it hasn't already been queued.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>

---
 include/linux/sched.h |    2 +-
 kernel/posix-timers.c |   20 +++++++++++---------
 kernel/signal.c       |    5 +++--
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2134917..718f7ec 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1791,7 +1791,7 @@ extern void zap_other_threads(struct task_struct *p);
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
-extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
+extern int send_sigqueue(struct sigqueue *, siginfo_t *, struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index dbd8398..b42c964 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -298,19 +298,21 @@ void do_schedule_next_timer(struct siginfo *info)
 
 int posix_timer_event(struct k_itimer *timr,int si_private)
 {
-	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
-	timr->sigq->info.si_sys_private = si_private;
+	siginfo_t info;
+
+	memset(&info, 0, sizeof(siginfo_t));
+	info.si_sys_private = si_private;
 	/* Send signal to the process that owns this timer.*/
 
-	timr->sigq->info.si_signo = timr->it_sigev_signo;
-	timr->sigq->info.si_errno = 0;
-	timr->sigq->info.si_code = SI_TIMER;
-	timr->sigq->info.si_tid = timr->it_id;
-	timr->sigq->info.si_value = timr->it_sigev_value;
+	info.si_signo = timr->it_sigev_signo;
+	info.si_errno = 0;
+	info.si_code = SI_TIMER;
+	info.si_tid = timr->it_id;
+	info.si_value = timr->it_sigev_value;
 
 	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
 		struct task_struct *leader;
-		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
+		int ret = send_sigqueue(timr->sigq, &info, timr->it_process, 0);
 
 		if (likely(ret >= 0))
 			return ret;
@@ -321,7 +323,7 @@ int posix_timer_event(struct k_itimer *timr,int si_private)
 		timr->it_process = leader;
 	}
 
-	return send_sigqueue(timr->sigq, timr->it_process, 1);
+	return send_sigqueue(timr->sigq, &info, timr->it_process, 1);
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 6c0958e..50e0b13 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1292,9 +1292,9 @@ void sigqueue_free(struct sigqueue *q)
 		__sigqueue_free(q);
 }
 
-int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
+int send_sigqueue(struct sigqueue *q, siginfo_t *info, struct task_struct *t, int group)
 {
-	int sig = q->info.si_signo;
+	int sig = info->si_signo;
 	struct sigpending *pending;
 	unsigned long flags;
 	int ret;
@@ -1322,6 +1322,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;
+	copy_siginfo(&q->info, info);
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-- 
1.5.5.1

