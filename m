Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbZBFOK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbZBFOK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZBFOKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:10:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZBFOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:10:03 -0500
Date: Fri, 6 Feb 2009 15:09:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: clean up hpet timer reinit
Message-ID: <20090206140943.GD3415@elte.hu>
References: <498BF9DA.5030302@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498BF9DA.5030302@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pavel Emelyanov <xemul@openvz.org> wrote:

> Sorry for late response - took some time to re-check this...

Applied to tip:timers/urgent, thanks Pavel!

Note, since i've already queued up the minimal fix i've created a delta 
cleanup patch from your v2 patch - see it below. (It is the exact same end 
result in terms of code, just a nicer splitup.)

	Ingo

------------------->
>From ff08f76d738d0ec0f334b187f61e160caa321d54 Mon Sep 17 00:00:00 2001
From: Pavel Emelyanov <xemul@openvz.org>
Date: Wed, 4 Feb 2009 13:40:31 +0300
Subject: [PATCH] x86: clean up hpet timer reinit

Implement Linus's suggestion: introduce the hpet_cnt_ahead()
helper function to compare hpet time values - like other
wrapping counter comparisons are abstracted away elsewhere.
(jiffies, ktime_t, etc.)

Reported-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/hpet.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index c761f91..388254f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -897,7 +897,7 @@ static unsigned long hpet_rtc_flags;
 static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
-static unsigned long hpet_t1_cmp;
+static u32 hpet_t1_cmp;
 static unsigned long hpet_default_delta;
 static unsigned long hpet_pie_delta;
 static unsigned long hpet_pie_limit;
@@ -905,6 +905,14 @@ static unsigned long hpet_pie_limit;
 static rtc_irq_handler irq_handler;
 
 /*
+ * Check that the hpet counter c1 is ahead of the c2
+ */
+static inline int hpet_cnt_ahead(u32 c1, u32 c2)
+{
+	return (s32)(c2 - c1) < 0;
+}
+
+/*
  * Registers a IRQ handler.
  */
 int hpet_register_irq_handler(rtc_irq_handler handler)
@@ -1075,7 +1083,7 @@ static void hpet_rtc_timer_reinit(void)
 		hpet_t1_cmp += delta;
 		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
 		lost_ints++;
-	} while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
+	} while (!hpet_cnt_ahead(hpet_t1_cmp, hpet_readl(HPET_COUNTER)));
 
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)
