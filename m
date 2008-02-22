Return-Path: <linux-kernel-owner+w=401wt.eu-S935147AbYBVM4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147AbYBVM4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYBVM4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:56:11 -0500
Received: from sacred.ru ([62.205.161.221]:50965 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYBVM4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:56:10 -0500
Message-ID: <47BEC663.7050904@openvz.org>
Date: Fri, 22 Feb 2008 15:56:03 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 22 Feb 2008 15:55:51 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both function do the same thing after proper locking, but
with different sigpening structs, so move the common code
into a helper.

After this we have 4 places that look very similar:
send_sigqueue: calls do_send_sigqueue and signal_wakeup
send_group_sigqueue: calls do_send_sigqueue and __group_complete_signal
__group_send_sig_info: calls send_signal and __group_complete_signal
specific_send_sig_info: calls send_signal and signal_wakeup

Besides, send_signal performs actions similar to do_send_sigqueue's
and __group_complete_signal - to signal_wakeup.

It looks like they can be consolidated gracefully.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/signal.c |   86 ++++++++++++++++++------------------------------------
 1 files changed, 29 insertions(+), 57 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8b1b404..c6bb821 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1291,10 +1291,33 @@ void sigqueue_free(struct sigqueue *q)
 	__sigqueue_free(q);
 }
 
+static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
+		struct sigpending *pending)
+{
+	if (unlikely(!list_empty(&q->list))) {
+		/*
+		 * If an SI_TIMER entry is already queue just increment
+		 * the overrun count.
+		 */
+
+		BUG_ON(q->info.si_code != SI_TIMER);
+		q->info.si_overrun++;
+		return 0;
+	}
+
+	if (sig_ignored(t, sig))
+		return 1;
+
+	signalfd_notify(t, sig);
+	list_add_tail(&q->list, &pending->list);
+	sigaddset(&pending->signal, sig);
+	return 0;
+}
+
 int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret = -1;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
@@ -1308,37 +1331,14 @@ int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 	 */
 	rcu_read_lock();
 
-	if (!likely(lock_task_sighand(p, &flags))) {
-		ret = -1;
+	if (!likely(lock_task_sighand(p, &flags)))
 		goto out_err;
-	}
 
-	if (unlikely(!list_empty(&q->list))) {
-		/*
-		 * If an SI_TIMER entry is already queue just increment
-		 * the overrun count.
-		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
-		q->info.si_overrun++;
-		goto out;
-	}
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(p, sig)) {
-		ret = 1;
-		goto out;
-	}
-	/*
-	 * Deliver the signal to listening signalfds. This must be called
-	 * with the sighand lock held.
-	 */
-	signalfd_notify(p, sig);
+	ret = do_send_sigqueue(sig, q, p, &p->pending);
 
-	list_add_tail(&q->list, &p->pending.list);
-	sigaddset(&p->pending.signal, sig);
 	if (!sigismember(&p->blocked, sig))
 		signal_wake_up(p, sig == SIGKILL);
 
-out:
 	unlock_task_sighand(p, &flags);
 out_err:
 	rcu_read_unlock();
@@ -1350,7 +1350,7 @@ int
 send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
@@ -1359,38 +1359,10 @@ send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	handle_stop_signal(sig, p);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(p, sig)) {
-		ret = 1;
-		goto out;
-	}
-
-	if (unlikely(!list_empty(&q->list))) {
-		/*
-		 * If an SI_TIMER entry is already queue just increment
-		 * the overrun count.  Other uses should not try to
-		 * send the signal multiple times.
-		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
-		q->info.si_overrun++;
-		goto out;
-	} 
-	/*
-	 * Deliver the signal to listening signalfds. This must be called
-	 * with the sighand lock held.
-	 */
-	signalfd_notify(p, sig);
-
-	/*
-	 * Put this signal on the shared-pending queue.
-	 * We always use the shared queue for process-wide signals,
-	 * to avoid several races.
-	 */
-	list_add_tail(&q->list, &p->signal->shared_pending.list);
-	sigaddset(&p->signal->shared_pending.signal, sig);
+	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
 
 	__group_complete_signal(sig, p);
-out:
+
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	read_unlock(&tasklist_lock);
 	return ret;
-- 
1.5.3.4

