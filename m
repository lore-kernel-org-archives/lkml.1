Return-Path: <linux-kernel-owner+w=401wt.eu-S935870AbXGQThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935870AbXGQThU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGQThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:37:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3520 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbXGQThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:37:07 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Jul 2007 12:37:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Davi Arnaut <davi@haxent.com.br>
Subject: [patch] make timerfd return a u64 and fix the __put_user
Message-ID: <Pine.LNX.4.64.0707171225050.26781@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Davi fixed a missing cast in the __put_user(), that was making timerfd 
return a single byte instead of the full value.
Talking with Michael about the timerfd man page, we think it'd be better 
to use a u64 for the returned value, to align it with the eventfd 
implementation.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/timerfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2007-07-17 12:20:15.000000000 -0700
+++ linux-2.6.mod/fs/timerfd.c	2007-07-17 12:21:09.000000000 -0700
@@ -95,7 +95,7 @@
 {
 	struct timerfd_ctx *ctx = file->private_data;
 	ssize_t res;
-	u32 ticks = 0;
+	u64 ticks = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (count < sizeof(ticks))
@@ -130,7 +130,7 @@
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks = (u32)
+			ticks = (u64)
 				hrtimer_forward(&ctx->tmr,
 						hrtimer_cb_get_time(&ctx->tmr),
 						ctx->tintv);
@@ -140,7 +140,7 @@
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
-		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
+		res = put_user(ticks, (u64 __user *) buf) ? -EFAULT: sizeof(ticks);
 	return res;
 }
 
