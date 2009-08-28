Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZH1TwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZH1TwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZH1Tv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:51:59 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:49017 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZH1Tv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:51:59 -0400
Date: Fri, 28 Aug 2009 15:51:34 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: akpm@linux-foundation.org, deepak@laptop.org, Tobias_Mueller@twam.info,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       cjb@laptop.org, linux-geode@lists.infradead.org
Subject: Re: [PATCH 1/3] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
 support
Message-ID: <20090828155134.7fa6fbfd@mycelium.queued.net>
In-Reply-To: <20090823112214.3adca590@i1501.lan.towertech.it>
References: <20090818175314.16c81ca4@mycelium.queued.net>
	<20090823112214.3adca590@i1501.lan.towertech.it>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009 11:22:14 +0200
Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

> On Tue, 18 Aug 2009 17:53:14 -0400
> Andres Salomon <dilinger@collabora.co.uk> wrote:
> 
> > 
> > This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip
> > backend (allowing GPIO users to use the generic GPIO API if
> > desired) while also allowing architecture-specific users directly
> > (via the cs5535_gpio_* functions).
> > 
> > Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a
> > mips cpu), which is why this is in drivers/gpio rather than
> > arch/x86. Currently, it conflicts with older geode GPIO support;
> > once MFGPT support is reworked to also be more generic, the older
> > geode code will be removed.
> > 
> > Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> 
>  fwiw,
> 
>  Reviewed-by: Alessandro Zummo <a.zummo@towertech.it>
> 

Thanks!

> > +	dev_info(&pdev->dev, "allocated PCI BAR #%d: base
> > 0x%llx\n", GPIO_BAR,
> > +			(unsigned long long)
> > cs5535_gpio_chip.base);
> 
>  shouldn't this be dev_dbg ?
> 

I prefer to see it when the driver is loaded (as info).

> > 
> > +	/* finally, register with the generic GPIO API */
> > +	err = gpiochip_add(&cs5535_gpio_chip.chip);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "failed to register gpio
> > chip\n");
> 
>  gpiochip_add already uses pr_err for error conditions, there's no
> need to report twice.
> 

Hm, you're right.   Andrew, can you please add/merge the patch below?


> > +		goto release_region;
> > +	}
> > +
> > +	printk(KERN_INFO DRV_NAME ": GPIO support successfully
> > loaded.\n");
> 
>  I'd use dev_xxx here, maybe it's worth to have a generic one
>  in gpiochip_add .
> 
> 

Noted and changed (along w/ a few other printks).  Thanks!



From: Andres Salomon <dilinger@collabora.co.uk>
Subject: [PATCH] cs5535-gpio: make printk usage consistent

Clean up places where we were using printk()s instead of dev_*.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/gpio/cs5535-gpio.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index ec1f0e8..0fdbe94 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -134,8 +134,8 @@ static int chip_gpio_request(struct gpio_chip *c, unsigned offset)
 
 	/* check if this pin is available */
 	if ((mask & (1 << offset)) == 0) {
-		printk(KERN_INFO DRV_NAME
-			": pin %u is not available (check mask)\n", offset);
+		dev_info(&chip->pdev->dev,
+			"pin %u is not available (check mask)\n", offset);
 		spin_unlock_irqrestore(&chip->lock, flags);
 		return -EINVAL;
 	}
@@ -265,18 +265,15 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
 	mask &= ~(1 << 28);
 
 	if (mask_orig != mask)
-		printk(KERN_INFO DRV_NAME
-				": mask changed from 0x%08lX to 0x%08lX\n",
+		dev_info(&pdev->dev, "mask changed from 0x%08lX to 0x%08lX\n",
 				mask_orig, mask);
 
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs5535_gpio_chip.chip);
-	if (err) {
-		dev_err(&pdev->dev, "failed to register gpio chip\n");
+	if (err)
 		goto release_region;
-	}
 
-	printk(KERN_INFO DRV_NAME ": GPIO support successfully loaded.\n");
+	dev_info(&pdev->dev, DRV_NAME ": GPIO support successfully loaded.\n");
 	return 0;
 
 release_region:
-- 
1.5.6.5






