Return-Path: <linux-kernel-owner+w=401wt.eu-S965128AbXFFGrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128AbXFFGrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXFFGro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:47:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:36091 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbXFFGrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:47:43 -0400
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
	losing TIF_SIGPENDING and other woes)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
	 <1181013756.31677.123.camel@localhost.localdomain>
	 <1181023787.2785.14.camel@entropy>
	 <1181028453.31677.127.camel@localhost.localdomain>
	 <1181087462.2788.8.camel@entropy>
	 <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com>
	 <1181088936.2788.10.camel@entropy>
	 <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
	 <1181091523.2788.28.camel@entropy>
	 <1181098204.31677.158.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706052022430.23673@alien.or.mcafeemobile.com>
	 <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 16:47:31 +1000
Message-Id: <1181112452.31677.220.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 20:37 -0700, Linus Torvalds wrote:

> I agree that it would be a limitation, but it would be a sane one.
> 
> How about we try to live with that limitation, if only to avoid the issue 
> of having the private signals being stolen by anybody else. If we actually 
> find a real-live use-case where that is bad in the future, we can re-visit 
> the issue - it's always easier to _expand_ semantics later than it is to 
> restrict them, so I think this thread is a good argument for starting it 
> out in a more restricted form before people start depending on semantics 
> that can be nasty..

Here's a patch. Let me know if I missed something.

Fix races with signalfd and TIF_SIGPENDING

We must never clear TIF_SIGPENDING for another task. This patch
ensures that by preventing recalc_sigpending_tsk() from clearing
that bit if the target task is not current.

In addition we also prevent __dequeue_signal() from calling the
DRM notifier thingy when stealing signals from another task via
signalfd.

Finally, we only dequeue shared signals when called from another
task (via signalfd), we leave private signals alone.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/kernel/signal.c
===================================================================
--- linux-work.orig/kernel/signal.c	2007-06-06 16:38:05.000000000 +1000
+++ linux-work/kernel/signal.c	2007-06-06 16:42:43.000000000 +1000
@@ -105,7 +105,12 @@ static int recalc_sigpending_tsk(struct 
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 		return 1;
 	}
-	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	/* Only clear the flag when this is issued by the target task to
+	 * clearing TIF_SIGPENDING after the target task decided to return
+	 * -ERESTARTSYS from a syscall
+	 */
+	if (t == current)
+		clear_tsk_thread_flag(t, TIF_SIGPENDING);
 	return 0;
 }
 
@@ -328,12 +333,12 @@ static int collect_signal(int sig, struc
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
-			siginfo_t *info)
+			    siginfo_t *info, int stealing)
 {
 	int sig = next_signal(pending, mask);
 
 	if (sig) {
-		if (current->notifier) {
+		if (current->notifier && !stealing) {
 			if (sigismember(current->notifier_mask, sig)) {
 				if (!(current->notifier)(current->notifier_data)) {
 					clear_thread_flag(TIF_SIGPENDING);
@@ -357,10 +362,19 @@ static int __dequeue_signal(struct sigpe
  */
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
-	int signr = __dequeue_signal(&tsk->pending, mask, info);
+	int stealing = tsk != current;
+	int signr = 0;
+
+	/* Only dequeue private signals if we are the owner, not when signals
+	 * are being stolen by another task via signalfd
+	 */
+	if (!stealing)
+		signr = __dequeue_signal(&tsk->pending, mask, info, 0);
+
+	/* No private signal, look for shared ones */
 	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
-					 mask, info);
+					 mask, info, stealing);
 		/*
 		 * itimer signal ?
 		 *


