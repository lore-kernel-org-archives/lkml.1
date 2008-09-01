Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYIAXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYIAXRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYIAXPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:40571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYIAXPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:37 -0400
Date: Mon, 1 Sep 2008 16:06:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 3/13] hrtimer: convert timerfd to the new hrtimer apis
Message-ID: <20080901160633.749a4af3@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: convert timerfd to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts timerfd to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/timerfd.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index c502c60..0862f0e 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -52,11 +52,9 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 
 static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 {
-	ktime_t now, remaining;
-
-	now = ctx->tmr.base->get_time();
-	remaining = ktime_sub(ctx->tmr.expires, now);
+	ktime_t remaining;
 
+	remaining = hrtimer_expires_remaining(&ctx->tmr);
 	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
 }
 
@@ -74,7 +72,7 @@ static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 	ctx->ticks = 0;
 	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
 	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
-	ctx->tmr.expires = texp;
+	hrtimer_set_expires(&ctx->tmr, texp);
 	ctx->tmr.function = timerfd_tmrproc;
 	if (texp.tv64 != 0)
 		hrtimer_start(&ctx->tmr, texp, htmode);
-- 
1.5.5.1

