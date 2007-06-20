Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbXFTVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbXFTVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXFTVyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:54:22 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1446 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXFTVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:54:22 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 20 Jun 2007 14:54:17 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] avoid spurious POLLIN returns in signalfd
Message-ID: <Pine.LNX.4.64.0706201450300.4018@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new code in kernel/signal.c does not allow fetching private signals 
from another task. This patch avoid spurious POLLIN returns from a 
signalfd poll(2) operation.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


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
