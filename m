Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYCHPGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYCHPGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYCHPGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:06:23 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34558 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYCHPGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:06:22 -0500
Date: Sat, 8 Mar 2008 18:10:21 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] signals: move the definition of __group_complete_signal() up
Message-ID: <20080308151021.GA25179@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the unchanged definition of __group_complete_signal() so that send_signal
can see it. To simplify the reading of the next patches.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~1_GCS_MOVE	2008-03-08 16:16:22.000000000 +0300
+++ 25/kernel/signal.c	2008-03-08 16:16:52.000000000 +0300
@@ -652,6 +652,102 @@ static void handle_stop_signal(int sig, 
 	}
 }
 
+/*
+ * Test if P wants to take SIG.  After we've checked all threads with this,
+ * it's equivalent to finding no threads not blocking SIG.  Any threads not
+ * blocking SIG were ruled out because they are not running and already
+ * have pending signals.  Such threads will dequeue from the shared queue
+ * as soon as they're available, so putting the signal on the shared queue
+ * will be equivalent to sending it to one such thread.
+ */
+static inline int wants_signal(int sig, struct task_struct *p)
+{
+	if (sigismember(&p->blocked, sig))
+		return 0;
+	if (p->flags & PF_EXITING)
+		return 0;
+	if (sig == SIGKILL)
+		return 1;
+	if (task_is_stopped_or_traced(p))
+		return 0;
+	return task_curr(p) || !signal_pending(p);
+}
+
+static void
+__group_complete_signal(int sig, struct task_struct *p)
+{
+	struct signal_struct *signal = p->signal;
+	struct task_struct *t;
+
+	/*
+	 * Now find a thread we can wake up to take the signal off the queue.
+	 *
+	 * If the main thread wants the signal, it gets first crack.
+	 * Probably the least surprising to the average bear.
+	 */
+	if (wants_signal(sig, p))
+		t = p;
+	else if (thread_group_empty(p))
+		/*
+		 * There is just one thread and it does not need to be woken.
+		 * It will dequeue unblocked signals before it runs again.
+		 */
+		return;
+	else {
+		/*
+		 * Otherwise try to find a suitable thread.
+		 */
+		t = signal->curr_target;
+		while (!wants_signal(sig, t)) {
+			t = next_thread(t);
+			if (t == signal->curr_target)
+				/*
+				 * No thread needs to be woken.
+				 * Any eligible threads will see
+				 * the signal in the queue soon.
+				 */
+				return;
+		}
+		signal->curr_target = t;
+	}
+
+	/*
+	 * Found a killable thread.  If the signal will be fatal,
+	 * then start taking the whole group down immediately.
+	 */
+	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
+	    !sigismember(&t->real_blocked, sig) &&
+	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
+		/*
+		 * This signal will be fatal to the whole group.
+		 */
+		if (!sig_kernel_coredump(sig)) {
+			/*
+			 * Start a group exit and wake everybody up.
+			 * This way we don't have other threads
+			 * running and doing things after a slower
+			 * thread has the fatal signal pending.
+			 */
+			signal->flags = SIGNAL_GROUP_EXIT;
+			signal->group_exit_code = sig;
+			signal->group_stop_count = 0;
+			t = p;
+			do {
+				sigaddset(&t->pending.signal, SIGKILL);
+				signal_wake_up(t, 1);
+			} while_each_thread(p, t);
+			return;
+		}
+	}
+
+	/*
+	 * The signal is already in the shared-pending queue.
+	 * Tell the chosen thread to wake up and dequeue it.
+	 */
+	signal_wake_up(t, sig == SIGKILL);
+	return;
+}
+
 static inline int legacy_queue(struct sigpending *signals, int sig)
 {
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
@@ -817,102 +913,6 @@ force_sig_specific(int sig, struct task_
 	force_sig_info(sig, SEND_SIG_FORCED, t);
 }
 
-/*
- * Test if P wants to take SIG.  After we've checked all threads with this,
- * it's equivalent to finding no threads not blocking SIG.  Any threads not
- * blocking SIG were ruled out because they are not running and already
- * have pending signals.  Such threads will dequeue from the shared queue
- * as soon as they're available, so putting the signal on the shared queue
- * will be equivalent to sending it to one such thread.
- */
-static inline int wants_signal(int sig, struct task_struct *p)
-{
-	if (sigismember(&p->blocked, sig))
-		return 0;
-	if (p->flags & PF_EXITING)
-		return 0;
-	if (sig == SIGKILL)
-		return 1;
-	if (task_is_stopped_or_traced(p))
-		return 0;
-	return task_curr(p) || !signal_pending(p);
-}
-
-static void
-__group_complete_signal(int sig, struct task_struct *p)
-{
-	struct signal_struct *signal = p->signal;
-	struct task_struct *t;
-
-	/*
-	 * Now find a thread we can wake up to take the signal off the queue.
-	 *
-	 * If the main thread wants the signal, it gets first crack.
-	 * Probably the least surprising to the average bear.
-	 */
-	if (wants_signal(sig, p))
-		t = p;
-	else if (thread_group_empty(p))
-		/*
-		 * There is just one thread and it does not need to be woken.
-		 * It will dequeue unblocked signals before it runs again.
-		 */
-		return;
-	else {
-		/*
-		 * Otherwise try to find a suitable thread.
-		 */
-		t = signal->curr_target;
-		while (!wants_signal(sig, t)) {
-			t = next_thread(t);
-			if (t == signal->curr_target)
-				/*
-				 * No thread needs to be woken.
-				 * Any eligible threads will see
-				 * the signal in the queue soon.
-				 */
-				return;
-		}
-		signal->curr_target = t;
-	}
-
-	/*
-	 * Found a killable thread.  If the signal will be fatal,
-	 * then start taking the whole group down immediately.
-	 */
-	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
-	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
-		/*
-		 * This signal will be fatal to the whole group.
-		 */
-		if (!sig_kernel_coredump(sig)) {
-			/*
-			 * Start a group exit and wake everybody up.
-			 * This way we don't have other threads
-			 * running and doing things after a slower
-			 * thread has the fatal signal pending.
-			 */
-			signal->flags = SIGNAL_GROUP_EXIT;
-			signal->group_exit_code = sig;
-			signal->group_stop_count = 0;
-			t = p;
-			do {
-				sigaddset(&t->pending.signal, SIGKILL);
-				signal_wake_up(t, 1);
-			} while_each_thread(p, t);
-			return;
-		}
-	}
-
-	/*
-	 * The signal is already in the shared-pending queue.
-	 * Tell the chosen thread to wake up and dequeue it.
-	 */
-	signal_wake_up(t, sig == SIGKILL);
-	return;
-}
-
 int
 __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {

