Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbXEUUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbXEUUlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXEUUlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:41:10 -0400
Received: from haxent.com ([65.99.219.155]:2574 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbXEUUlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:41:08 -0400
Message-ID: <465203DD.4080802@haxent.com.br>
Date: Mon, 21 May 2007 17:41:01 -0300
From: Davi Arnaut <davi@haxent.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: + signalfd-retrieve-multiple-signals-with-one-read-call.patch
 added to -mm tree
References: <20070521192551.GA153@tv-sign.ru> <Pine.LNX.4.64.0705211313090.24209@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705211313090.24209@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Mon, 21 May 2007, Oleg Nesterov wrote:
> 
>>> +		schedule();
>>> +		locked = signalfd_lock(ctx, &lk);
>>> +		if (unlikely(!locked)) {
>>> +			/*
>>> +			 * Let the caller read zero byte, ala socket
>>> +			 * recv() when the peer disconnect. This test
>>> +			 * must be done before doing a dequeue_signal(),
>>> +			 * because if the sighand has been orphaned,
>>> +			 * the dequeue_signal() call is going to crash.
>>> +			 */
>> Imho, the comment is a bit confusing. dequeue_signal() needs ->siglock
>> even if signalfd_ctx is not orphaned.
> 
> The comment looks clear to me. It states:
> 
> 1) The policy of returning 0 when the sighand has been detached
> 
> 2) That we _must_not_ call dequeue_signal() in case signalfd_lock() fails
> 
> #ACK on the code mod below.
>
> - Davide
> 

Andrew, please apply on top.

Simplify signalfd locking following suggestions by Oleg Nesterov.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

Index: linux-2.6/fs/signalfd.c
===================================================================
--- linux-2.6.orig/fs/signalfd.c
+++ linux-2.6/fs/signalfd.c
@@ -211,13 +211,11 @@ static int signalfd_copyinfo(struct sign
 static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 				int nonblock)
 {
-	int locked;
 	ssize_t ret;
 	struct signalfd_lockctx lk;
 	DECLARE_WAITQUEUE(wait, current);
 
-	locked = signalfd_lock(ctx, &lk);
-	if (!locked)
+	if (!signalfd_lock(ctx, &lk))
 		return 0;
 
 	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
@@ -235,24 +233,24 @@ static ssize_t signalfd_dequeue(struct s
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+		signalfd_unlock(&lk);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
 		}
-		signalfd_unlock(&lk);
 		schedule();
-		locked = signalfd_lock(ctx, &lk);
-		if (unlikely(!locked)) {
+		ret = signalfd_lock(ctx, &lk);
+		if (unlikely(!ret)) {
 			/*
 			 * Let the caller read zero byte, ala socket
 			 * recv() when the peer disconnect. This test
 			 * must be done before doing a dequeue_signal(),
 			 * because if the sighand has been orphaned,
-			 * the dequeue_signal() call is going to crash.
+			 * the dequeue_signal() call is going to crash
+			 * because ->sighand will be long gone.
 			 */
-			 ret = 0;
 			 break;
 		}
 	}
@@ -260,9 +258,6 @@ static ssize_t signalfd_dequeue(struct s
 	remove_wait_queue(&ctx->wqh, &wait);
 	__set_current_state(TASK_RUNNING);
 
-	if (likely(locked))
-		signalfd_unlock(&lk);
-
 	return ret;
 }
 
 

