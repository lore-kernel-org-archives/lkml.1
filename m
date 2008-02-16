Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYBPTw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYBPTw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYBPTww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:52:52 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:56483 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYBPTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:52:51 -0500
Message-ID: <47B73F0D.3090202@tiscali.nl>
Date: Sat, 16 Feb 2008 20:52:45 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/{exit.c, signal.c, power/process.c}: replace
 !likely(x) by likely(!x)
References: <47B70810.5030608@tiscali.nl> <47B732EF.4050504@zytor.com> <47B739AA.6070108@tiscali.nl> <47B73A22.60806@zytor.com>
In-Reply-To: <47B73A22.60806@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Roel Kluin wrote:
>> H. Peter Anvin wrote:
>>> Roel Kluin wrote:
>>>> Not entirely sure who to send this to
>>>> ---
>>>> Replace !likely(x) by likely(!x)
>>> Whoa...
>>>
>>> Are you sure this is correct?
>>>
>>> !likely(x) is equivalent to unlikely(!x), not the opposite, so this is a
>>> functional change...
>>>
>> You are right, sorry, Need more caffeine. I will send the right patch
>> later.
> 
> Note I didn't say it was wrong, I just wanted a bit more explanation
> about why it's right, if it is.

No, I just wanted to move the '!' within the parentheses, I didn't want
to change semantics. below is how I guess the patch should have been. 
Thanks for your response.
---
Replace !likely(x) by unlikely(!x)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/kernel/signal.c b/kernel/signal.c
index 84917fe..cf5d45a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1308,7 +1308,7 @@ int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 	 */
 	rcu_read_lock();
 
-	if (!likely(lock_task_sighand(p, &flags))) {
+	if (unlikely(!lock_task_sighand(p, &flags))) {
 		ret = -1;
 		goto out_err;
 	}
@@ -1548,7 +1548,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(current->ptrace & PT_PTRACED))
+	if (unlikely(!(current->ptrace & PT_PTRACED)))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1574,7 +1574,7 @@ static int sigkill_pending(struct task_struct *tsk)
 {
 	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
 		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
-		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
+		 likely(!sigismember(&tsk->blocked, SIGKILL)));
 }
 
 /*
@@ -1625,7 +1625,7 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 	spin_unlock_irq(&current->sighand->siglock);
 	try_to_freeze();
 	read_lock(&tasklist_lock);
-	if (!unlikely(killed) && may_ptrace_stop()) {
+	if (likely(!killed) && may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();
@@ -1717,8 +1717,8 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
-		    unlikely(sig->group_exit_task))
+		if (unlikely(!(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		    sig->group_exit_task))
 			return 0;
 		/*
 		 * There is no group stop already in progress.

