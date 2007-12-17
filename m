Return-Path: <linux-kernel-owner+w=401wt.eu-S937533AbXLQUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937533AbXLQUVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936501AbXLQUUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:20:44 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:36719 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936129AbXLQUUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:20:43 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 17 Dec 2007 12:20:41 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/2] timerfd - make the returned time to be the remaining
 time till the next expiration
Message-ID: <Pine.LNX.4.64.0712171216160.10687@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the returned time to be the remaining time till the next expiration.
If the timer is already expired, and there's no next expiration, zero will
be returned.
Andrew, this goes on top of the ones you already have in -mm.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/timerfd.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2007-12-14 16:04:36.000000000 -0800
+++ linux-2.6.mod/fs/timerfd.c	2007-12-14 16:05:32.000000000 -0800
@@ -49,6 +49,15 @@
 	return HRTIMER_NORESTART;
 }
 
+static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx) {
+	ktime_t now, remaining;
+
+	now = ctx->tmr.base->get_time();
+	remaining = ktime_sub(ctx->tmr.expires, now);
+
+	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
+}
+
 static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			  const struct itimerspec *ktmr)
 {
@@ -240,7 +249,7 @@
 	if (ctx->expired && ctx->tintv.tv64)
 		hrtimer_forward_now(&ctx->tmr, ctx->tintv);
 
-	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
 
 	/*
@@ -274,7 +283,7 @@
 			hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
 		hrtimer_restart(&ctx->tmr);
 	}
-	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
 	spin_unlock_irq(&ctx->wqh.lock);
 	fput(file);
