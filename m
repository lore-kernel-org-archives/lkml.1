Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZBTXMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZBTXMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZBTXL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:11:59 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:50261 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754534AbZBTXL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:11:57 -0500
X-BigFish: VPS5(z34a4jzzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KFE0FD-02-10X-01
Date: Sat, 21 Feb 2009 00:10:44 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/3] x86: hpet: provide separate functions to stop and
	start the counter
Message-ID: <20090220231044.GJ6298@alberich.amd.com>
References: <20090220230729.GK4834@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090220230729.GK4834@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 23:11:05.0774 (UTC) FILETIME=[81C924E0:01C993B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By splitting up existing hpet_start_counter function.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/hpet.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 84450b1..20acc6a 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -231,27 +231,37 @@ static struct clock_event_device hpet_clockevent = {
 	.rating		= 50,
 };
 
-static void hpet_start_counter(void)
+static void hpet_stop_counter(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
-
 	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 	hpet_writel(0, HPET_COUNTER);
 	hpet_writel(0, HPET_COUNTER + 4);
+}
+
+static void hpet_start_counter(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
 	cfg |= HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 }
 
+static void hpet_restart_counter(void)
+{
+	hpet_stop_counter();
+	hpet_start_counter();
+}
+
 static void hpet_resume_device(void)
 {
 	force_hpet_resume();
 }
 
-static void hpet_restart_counter(void)
+static void hpet_resume_counter(void)
 {
 	hpet_resume_device();
-	hpet_start_counter();
+	hpet_restart_counter();
 }
 
 static void hpet_enable_legacy_int(void)
@@ -738,7 +748,7 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_restart_counter,
+	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
@@ -750,7 +760,7 @@ static int hpet_clocksource_register(void)
 	cycle_t t1;
 
 	/* Start the counter */
-	hpet_start_counter();
+	hpet_restart_counter();
 
 	/* Verify whether hpet counter works */
 	t1 = read_hpet();
-- 
1.6.1.3



