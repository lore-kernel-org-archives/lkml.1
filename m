Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbYB2Ne6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbYB2Ne6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYB2Net
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:34:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58730 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbYB2Net (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:34:49 -0500
Date: Fri, 29 Feb 2008 14:34:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: huggie@earth.li, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080229133433.GA15532@elte.hu>
References: <20080229115256.GG24533@paranoidfreak.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229115256.GG24533@paranoidfreak.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Huggins <huggie@earth.li> wrote:

> [ Please Cc me on replies ]
> 
> I had a bug with sdhci which Pierre Ossman looked at for me.
> 
> In the end essentially the fix was to use HZ=1000 and nothing else. 
> Pierre seemed to think that this was a bug in the scheduler.

does the patch below help, even if you keep HZ=100? This doesnt look 
like a scheduler issue, it's more of a timer/timing issue. Different HZ 
means different msleep() results - and the mmc code does a loop of small 
msleep delays.

	Ingo

-------------->
---
 drivers/mmc/core/core.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/drivers/mmc/core/core.h
===================================================================
--- linux.orig/drivers/mmc/core/core.h
+++ linux/drivers/mmc/core/core.h
@@ -36,12 +36,7 @@ void mmc_set_timing(struct mmc_host *hos
 
 static inline void mmc_delay(unsigned int ms)
 {
-	if (ms < 1000 / HZ) {
-		cond_resched();
-		mdelay(ms);
-	} else {
-		msleep(ms);
-	}
+	mdelay(ms);
 }
 
 void mmc_rescan(struct work_struct *work);
