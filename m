Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYHDMk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYHDMk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYHDMkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:40:16 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:4022 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752389AbYHDMkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:40:14 -0400
Message-ID: <4896F8B0.80209@LiPPERTEmbedded.de>
Date: Mon, 04 Aug 2008 14:40:16 +0200
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Andres Salomon <dilinger@debian.org>, linux-geode@bombadil.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] geode-mfgpt: check IRQ before using MFGPT as clocksource
References: <48916864.901@LiPPERTEmbedded.de> <20080731143635.GA12585@cosmic.amd.com> <48932ACD.3080805@LiPPERTEmbedded.de> <20080801160026.GB19184@cosmic.amd.com>
In-Reply-To: <20080801160026.GB19184@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2008 12:40:36.0783 (UTC) FILETIME=[4B5533F0:01C8F62F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a simple IRQ autodetection to the AMD Geode MFGPT driver, and more
importantly, adds some checks, if IRQs can actually be received on the
chosen line.  This fixes cases where MFGPT is selected as clocksource
though not producing any ticks, so the kernel simply starves during
boot.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

Hi Jordan,

extended (and hopefully clarified) the comment. (However, kept the
expression Siamese twin, because I happen to like it.  :-)

Do you think this might qualify as patch for the stable series?? After
all, it fixes a hang ... though only on some boards and one can work
around it with a cmdline param ...

Regards,
Jens

--- linux-2.6.26.1/include/asm-x86/geode.h
+++ mfgpt-irq-fix/include/asm-x86/geode.h
@@ -50,6 +50,7 @@
 #define MSR_PIC_YSEL_HIGH	0x51400021
 #define MSR_PIC_ZSEL_LOW	0x51400022
 #define MSR_PIC_ZSEL_HIGH	0x51400023
+#define MSR_PIC_IRQM_LPC	0x51400025
 
 #define MSR_MFGPT_IRQ		0x51400028
 #define MSR_MFGPT_NR		0x51400029
@@ -237,7 +238,7 @@
 }
 
 extern int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable);
-extern int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable);
+extern int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable);
 extern int geode_mfgpt_alloc_timer(int timer, int domain);
 
 #define geode_mfgpt_setup_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 1)
--- linux-2.6.26/arch/x86/kernel/mfgpt_32.c
+++ mfgpt-irq-fix/arch/x86/kernel/mfgpt_32.c
@@ -33,6 +33,8 @@
 #include <linux/module.h>
 #include <asm/geode.h>
 
+#define MFGPT_DEFAULT_IRQ	7
+
 static struct mfgpt_timer_t {
 	unsigned int avail:1;
 } mfgpt_timers[MFGPT_MAX_TIMERS];
@@ -157,29 +159,48 @@
 }
 EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
 
-int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable)
+int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable)
 {
-	u32 val, dummy;
-	int offset;
+	u32 zsel, lpc, dummy;
+	int shift;
 
 	if (timer < 0 || timer >= MFGPT_MAX_TIMERS)
 		return -EIO;
 
-	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
+	/*
+	 * Unfortunately, MFGPTs come in pairs sharing their IRQ lines. If VSA
+	 * is using the same CMP of the timer's Siamese twin, the IRQ is set to
+	 * 2, and we mustn't use nor change it.
+	 * XXX: Likewise, 2 Linux drivers might clash if the 2nd overwrites the
+	 * IRQ of the 1st. This can only happen if forcing an IRQ, calling this
+	 * with *irq==0 is safe. Currently there _are_ no 2 drivers.
+	 */
+	rdmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
+	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer % 4) * 4;
+	if (((zsel >> shift) & 0xF) == 2)
 		return -EIO;
 
-	rdmsr(MSR_PIC_ZSEL_LOW, val, dummy);
-
-	offset = (timer % 4) * 4;
+	/* Choose IRQ: if none supplied, keep IRQ already set or use default */
+	if (!*irq)
+		*irq = (zsel >> shift) & 0xF;
+	if (!*irq)
+		*irq = MFGPT_DEFAULT_IRQ;
 
-	val &= ~((0xF << offset) | (0xF << (offset + 16)));
+	/* Can't use IRQ if it's 0 (=disabled), 2, or routed to LPC */
+	if (*irq < 1 || *irq == 2 || *irq > 15)
+		return -EIO;
+	rdmsr(MSR_PIC_IRQM_LPC, lpc, dummy);
+	if (lpc & (1 << *irq))
+		return -EIO;
 
+	/* All chosen and checked - go for it */
+	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
+		return -EIO;
 	if (enable) {
-		val |= (irq & 0x0F) << (offset);
-		val |= (irq & 0x0F) << (offset + 16);
+		zsel = (zsel & ~(0xF << shift)) | (*irq << shift);
+		wrmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
 	}
 
-	wrmsr(MSR_PIC_ZSEL_LOW, val, dummy);
 	return 0;
 }
 
@@ -242,7 +263,7 @@
 static unsigned int mfgpt_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
 static u16 mfgpt_event_clock;
 
-static int irq = 7;
+static int irq;
 static int __init mfgpt_setup(char *str)
 {
 	get_option(&str, &irq);
@@ -346,7 +367,7 @@ int __init mfgpt_timer_setup(void)
 	mfgpt_event_clock = timer;
 
 	/* Set up the IRQ on the MFGPT side */
-	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, irq)) {
+	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, &irq)) {
 		printk(KERN_ERR "mfgpt-timer:  Could not set up IRQ %d\n", irq);
 		return -EIO;
 	}
@@ -374,13 +395,14 @@ int __init mfgpt_timer_setup(void)
 			&mfgpt_clockevent);
 
 	printk(KERN_INFO
-	       "mfgpt-timer:  registering the MFGPT timer as a clock event.\n");
+	       "mfgpt-timer:  Registering MFGPT timer %d as a clock event, using IRQ %d\n",
+	       timer, irq);
 	clockevents_register_device(&mfgpt_clockevent);
 
 	return 0;
 
 err:
-	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, irq);
+	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, &irq);
 	printk(KERN_ERR
 	       "mfgpt-timer:  Unable to set up the MFGPT clock source\n");
 	return -EIO;
_

