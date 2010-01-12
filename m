Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089Ab0ALK27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0ALK27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0ALK25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:28:57 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:2376 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754060Ab0ALK24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:28:56 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 05:28:56 EST
Message-ID: <4B4C4B86.7090509@LiPPERTEmbedded.de>
Date: Tue, 12 Jan 2010 11:14:30 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@collabora.co.uk>
CC: linux-kernel@vger.kernel.org, linux-geode@bombadil.infradead.org
Subject: [PATCH] geode-mfgpt: restore previous behavior for selecting IRQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2010 10:14:32.0806 (UTC) FILETIME=[08E0F060:01CA9370]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

geode-mfgpt: restore previous behavior for selecting IRQ

The MFGPT IRQ used to be, in order of decreasing priority,
* IRQ supplied by the user as a boot-time parameter,
* IRQ previously set by the BIOS or another driver,
* default IRQ given at compile time.

Return to this behavior, which got broken when splitting the
MFGPT/clocksource driver for 2.6.33-rc1.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

Hi Andres,

a bit more detail. Up to 2.6.32 the MFGPT IRQ was chosen like this:

static int irq;
static int __init mfgpt_setup(char *str)
{
	get_option(&str, &irq);
	return 1;
}
__setup("mfgpt_irq=", mfgpt_setup);
[...]
/* Choose IRQ: if none supplied, keep IRQ already set or use default */
if (!*irq)
	*irq = (zsel >> shift) & 0xF;	// may have been set by the BIOS
if (!*irq)
	*irq = MFGPT_DEFAULT_IRQ;	// #defined as 7

The code in 2.6.33-rc3 after the MFGPT/clocksource split looks like this:

static int timer_irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;	// defaults to 7
module_param_named(irq, timer_irq, int, 0644);
[...]
if (!*irq)
	*irq = (zsel >> shift) & 0xF;		// gets ignored now
if (!*irq)
	*irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;	// again!?

The patch removes the first of the two ocurrances of
CONFIG_CS5535_MFGPT_DEFAULT_IRQ, reverting the IRQ selection to the previous
(working) behavior.


BTW, while looking into this I stumbled upon the fact that cs5535_mfgpt_init()
doesn't free up the timer in the error path if cs5535_mfgpt_setup_irq() or
setup_irq() fail. However, some comments in cs5535-mfgpt.c (stating that it's
not possible to release the individual timer hardware) make me think this might
have been skipped on purpose? Could you please have a look?

Thanks,
Jens

--- linux-2.6.33-rc3-git4/drivers/clocksource/cs5535-clockevt.c
+++ previous_behavior/drivers/clocksource/cs5535-clockevt.c
@@ -21,7 +21,7 @@
 
 #define DRV_NAME "cs5535-clockevt"
 
-static int timer_irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;
+static int timer_irq;
 module_param_named(irq, timer_irq, int, 0644);
 MODULE_PARM_DESC(irq, "Which IRQ to use for the clock source MFGPT ticks.");
 
_

