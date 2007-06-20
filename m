Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbXFTUNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbXFTUNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762643AbXFTUMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:12:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1339 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762101AbXFTUMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:12:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 20 Jun 2007 13:12:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] exclude sync signals from signalfd sets
In-Reply-To: <alpine.LFD.0.98.0706201255530.3593@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706201309280.4018@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0706201209570.6029@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706201255530.3593@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Linus Torvalds wrote:

> 
> 
> On Wed, 20 Jun 2007, Davide Libenzi wrote:
> > 
> > The following patch excludes synchronous signals from being dequeued
> > by a signalfd.
> 
> I really prefer the current code. Listign special cases is just ugly. Just 
> make it so that thread-local signals stay thread-local, and it's all good.

Hmm, I thought the behaviour implemented by the patch was pretty clean. 
But anyway, if we leave the current code (as it is in your current tree), 
we need the patch below to avoid spurious poll returns.



- Davide


---
 fs/signalfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/signalfd.c
===================================================================
--- linux-2.6.mod.orig/fs/signalfd.c	2007-06-20 13:08:25.000000000 -0700
+++ linux-2.6.mod/fs/signalfd.c	2007-06-20 13:09:00.000000000 -0700
@@ -133,7 +133,8 @@
 	 * the peer disconnects.
 	 */
 	if (signalfd_lock(ctx, &lk)) {
-		if (next_signal(&lk.tsk->pending, &ctx->sigmask) > 0 ||
+		if ((lk.tsk == current &&
+		     next_signal(&lk.tsk->pending, &ctx->sigmask) > 0) ||
 		    next_signal(&lk.tsk->signal->shared_pending,
 				&ctx->sigmask) > 0)
 			events |= POLLIN;
