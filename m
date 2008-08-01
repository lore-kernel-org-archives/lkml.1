Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYHAPZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYHAPZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYHAPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:25:05 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:23680 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751240AbYHAPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:25:03 -0400
Message-ID: <48932ACD.3080805@LiPPERTEmbedded.de>
Date: Fri, 01 Aug 2008 17:25:01 +0200
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>
CC: linux-geode@bombadil.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: MFGPT driver inhibits boot on some boards
References: <48916864.901@LiPPERTEmbedded.de> <20080731143635.GA12585@cosmic.amd.com>
In-Reply-To: <20080731143635.GA12585@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2008 15:25:25.0320 (UTC) FILETIME=[D21EF480:01C8F3EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've implemented all of 4,3,2, see patch at the very end:

> Possible solution 4: only touch the CMP actually requested. But also
> fail if this CMP is set to IRQ2, because this means VSA is using its
> twin.

> Possible solution 3: keep the IRQ already chosen in MSR_PIC_ZSEL_LOW
> unless it's 0, only in that case use IRQ7

> Possible solution 2: make geode_mfgpt_set_irq() check the bit and fail
> if the IRQ is routed to LPC. (I think I'd prefer this over 1.)


Jordan Crouse wrote:
> This goes against our basic policy of not trusting the BIOS.

I'd say distrust, yes, but not ignore it.

If a preset IRQ exists, my implementation prefers this over defaulting
to 7. "mfgpt_irq=nn" overrides both.

> The main problem with this is configuring your second timer wrong, and
> it fires on the wrong interrupt.

Can't happen, I think. Now geode_mfgpt_set_irq() checks if the requested
CMP can be safely used on a timer. If the user of the MFGPT hasn't
called geode_mfgpt_set_irq() for a given CMP, geode_mfgpt_toggle_event()
will not have been called either, so no IRQ is triggered, even if the
user erroneously programs the wrong CMP.


Now about the baseaddr issue:

> This does sound like a problem with your particular system - Linux can
> move the resource space, but if it has to, then I generally consider
> that to be a BIOS issue.

Yes, I know it is.  I did't go into detail, because this is the
Linux-kernel mailing list after all, and my mail was long enough
already.  Luckily, I have access to our BIOS' sources, that's why I
wrote in my first mail "The baseaddr issue is not that serious for me, I
will probably be able to fix the bogus resource conflict."

Actually there are 2 bogus conflicts:

The IO resources shown in the distinct headers for GPIO, MFGPT and SMB
(00:10.0 to 00:10.2) are identical with BAR0,1,2 in the ISA header
(00:0F.0). Of course they are identical, because that's 2 PCI headers
for the same thing, but Linux cannot know that and sees a collision.

This conflict will go away when the headers 10.0 to 10.2 get hidden, so
I think I'll do just that. No one is using them anyway. I guess I'll try
and create a BIOS setup entry, but make it default to 'disabled'.

But this alone isn't enough.

The second 'conflict' is due to a bug in the VSA code that implements
the reads and writes to the virtual PCI headers. When Linux (or anyone)
writes FFFFFFFF to the BAR to probe the size, reads return wrong values.
Because of this, the IO resource size for SMB is read as 8 KB instead of
8 bytes. And this supposedly bigger sized SMB collides with MFGPT IO
space, which is located 256 bytes past SMB.

Funny enough, as I found out today, responsible for this mess is again
crappy VSA code that was needed to synchronize the mentioned double PCI
headers for GPIO, MFGPT and SMB in 0F.0 and 10.x.  :-(

Have a nice weekend.

Jens
_____________________________________________________________________
mfgpt: check IRQ before using MFGPT as clocksource

Adds a simple IRQ autodetection to the AMD Geode MFGPT driver, and more
importantly, adds some checks, if IRQs can actually be received on the
chosen line.  This fixes cases where MFGPT is selected as clocksource
though not producing any ticks, so the kernel simply starves during
boot.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

--- linux-2.6.26/include/asm-x86/geode.h
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
@@ -157,29 +159,41 @@
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
+	/* IRQ already set to 2 means VSA is using the timer's Siamese twin */
+	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer % 4) * 4;
+	rdmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
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
 
@@ -242,7 +256,7 @@
 static unsigned int mfgpt_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
 static u16 mfgpt_event_clock;
 
-static int irq = 7;
+static int irq;
 static int __init mfgpt_setup(char *str)
 {
 	get_option(&str, &irq);
@@ -346,7 +360,7 @@ int __init mfgpt_timer_setup(void)
 	mfgpt_event_clock = timer;
 
 	/* Set up the IRQ on the MFGPT side */
-	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, irq)) {
+	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, &irq)) {
 		printk(KERN_ERR "mfgpt-timer:  Could not set up IRQ %d\n", irq);
 		return -EIO;
 	}
@@ -374,13 +388,14 @@ int __init mfgpt_timer_setup(void)
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

