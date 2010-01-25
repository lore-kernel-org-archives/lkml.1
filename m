Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106Ab0AYNMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0AYNMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398Ab0AYNMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:12:30 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:30552 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750853Ab0AYNM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:12:29 -0500
Message-ID: <4B5D98ED.6090301@LiPPERTEmbedded.de>
Date: Mon, 25 Jan 2010 14:13:17 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@collabora.co.uk>
CC: Jordan Crouse <jordan.crouse@amd.com>, linux-geode@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cs5535-clockevt: free timer in IRQ setup error path
References: <4B4C4B86.7090509@LiPPERTEmbedded.de> <20100118103430.6480d1a8@mycelium.queued.net>
In-Reply-To: <20100118103430.6480d1a8@mycelium.queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2010 13:13:20.0280 (UTC) FILETIME=[2A525180:01CA9DC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535-clockevt: free timer in IRQ setup error path

Due to a hardware limitation cs5535_mfgpt_free_timer() cannot actually release
the timer hardware, but it will at least free the now unreferenced struct
associated with it so calling it is the cleaner thing to do.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

Hi Andres,

> > cs5535_mfgpt_init() doesn't free up the timer in the error path

> Yeah, we can't really free the timer, unfortunately.
> It actually might not be a bad idea to reverse the code so that the
> IRQ allocation happens first, since we can clean that up if mfgpt
> allocation fails.

The problem is that cs5535_mfgpt_setup_irq() depends on the return value of cs5535_mfgpt_alloc_timer(), because it needs to know the timer nr both to read out the previous IRQ (if any) and to setup the IRQ. (And setup_irq() in turn depends on cs5535_mfgpt_setup_irq() for getting the actual IRQ number.) I guess for reversing the order we'd have to split both cs5535_mfgpt_alloc_timer() and cs5535_mfgpt_setup_irq() into two parts, one to do all checking and detecting and a second run to actually touch the hardware. But I don't fancy the mess this is likely to result in ...

For now all I'm able to provide is this small patch that inserts the missing cs5535_mfgpt_free_timer() calls. This at least plugs the (really minor) mem leak - better than nothing.

Maybe cs5535_mfgpt_free_timer() can be made more intelligent to set mfgpt->avail again if the hardware isn't actually in a non-reversible state yet, but I don't know what this depends on and I lack the time to explore this further.

Fortunately not freeing the timers only affects users who manually want to try several IRQs by repeatedly doing "modprobe cs5535-clockevt irq=..." and who after 3-6 failed attempts will have to reboot to get another batch of free timers. Once the module was loaded successfully it cannot be unloaded anyway.

Best regards,
Jens

--- linux-2.6.33-rc5/drivers/clocksource/cs5535-clockevt.c
+++ timer_freed_on_error/drivers/clocksource/cs5535-clockevt.c
@@ -154,14 +154,14 @@
 	if (cs5535_mfgpt_setup_irq(timer, MFGPT_CMP2, &timer_irq)) {
 		printk(KERN_ERR DRV_NAME ": Could not set up IRQ %d\n",
 				timer_irq);
-		return -EIO;
+		goto err_timer;
 	}
 
 	/* And register it with the kernel */
 	ret = setup_irq(timer_irq, &mfgptirq);
 	if (ret) {
 		printk(KERN_ERR DRV_NAME ": Unable to set up the interrupt.\n");
-		goto err;
+		goto err_irq;
 	}
 
 	/* Set the clock scale and enable the event mode for CMP2 */
@@ -184,8 +184,10 @@
 
 	return 0;
 
-err:
+err_irq:
 	cs5535_mfgpt_release_irq(cs5535_event_clock, MFGPT_CMP2, &timer_irq);
+err_timer:
+	cs5535_mfgpt_free_timer(cs5535_event_clock);
 	printk(KERN_ERR DRV_NAME ": Unable to set up the MFGPT clock source\n");
 	return -EIO;
 }
_

