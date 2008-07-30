Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYG3Pmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYG3Pmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYG3Pmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:42:43 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:43347 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYG3Pmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:42:42 -0400
Date: Wed, 30 Jul 2008 17:42:27 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Richard Purdie <rpurdie@rpsys.net>, Rod Whitby <rod@whitby.id.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-fsg: Change order of initialization and
 deinitialization
In-Reply-To: <20080730005853.3f343d93.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0807301716210.2294@titan.stealer.net>
References: <alpine.LNX.1.10.0807272016570.16340@titan.stealer.net> <20080730005853.3f343d93.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 30 Jul 2008 15:42:40 +0000
	Bayes: 0.0000 Tokens: new, 264; hammy, 10; neutral, 5; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Spam-Signature: 4bdf26e6718164ce9075d3d5fd5669ca13916382
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Andrew Morton wrote:

> On Sun, 27 Jul 2008 20:30:59 +0200 (CEST) Sven Wegener <sven.wegener@stealer.net> wrote:
> 
> > --- a/drivers/leds/leds-fsg.c
> > +++ b/drivers/leds/leds-fsg.c
> > @@ -161,6 +161,16 @@ static int fsg_led_probe(struct platform_device *pdev)
> >  {
> >  	int ret;
> >  
> > +	/* Map the LED chip select address space */
> > +	latch_address = (unsigned short *) ioremap(IXP4XX_EXP_BUS_BASE(2), 512);
> > +	if (!latch_address) {
> > +		ret = -ENOMEM;
> > +		goto failremap;
> > +	}
> > +
> > +	latch_value = 0xffff;
> > +	*latch_address = latch_value;
> 
> Mutter.  Shouldn't this driver be using readw/writew?  It's not even
> using a volatile pointer, so there's a decent risk that the compiler
> will optimise away important things..

I don't own a FSG-3, so I can't test my changes. Currently I don't have a 
arm cross toolchain, so I even can't compile-test anything. But you mean 
something along the lines below on top of the patch? Don't know if we need 
to writew an initial value or if the hardware sets it up properly. Using 
__raw functions to avoid the cpu_to_le16 conversion as the conversion 
isn't there in the current code.

diff --git a/drivers/leds/leds-fsg.c b/drivers/leds/leds-fsg.c
index a26fe36..42fb09d 100644
--- a/drivers/leds/leds-fsg.c
+++ b/drivers/leds/leds-fsg.c
@@ -22,80 +22,55 @@
 #include <asm/arch/hardware.h>
 #include <asm/io.h>
 
-static short __iomem *latch_address;
-static unsigned short latch_value;
+static unsigned short __iomem *latch_address;
 
 
+static void fsg_led_set(enum led_brightness value, int bit)
+{
+	unsigned short latch_value = __raw_readw(latch_address);
+
+	if (value)
+		latch_value &= ~(1 << bit);
+	else
+		latch_value |=  (1 << bit);
+
+	__raw_writew(latch_value, latch_address);
+}
+
 static void fsg_led_wlan_set(struct led_classdev *led_cdev,
 			     enum led_brightness value)
 {
-	if (value) {
-		latch_value &= ~(1 << FSG_LED_WLAN_BIT);
-		*latch_address = latch_value;
-	} else {
-		latch_value |=  (1 << FSG_LED_WLAN_BIT);
-		*latch_address = latch_value;
-	}
+	fsg_led_set(value, FSG_LED_WLAN_BIT);
 }
 
 static void fsg_led_wan_set(struct led_classdev *led_cdev,
 			    enum led_brightness value)
 {
-	if (value) {
-		latch_value &= ~(1 << FSG_LED_WAN_BIT);
-		*latch_address = latch_value;
-	} else {
-		latch_value |=  (1 << FSG_LED_WAN_BIT);
-		*latch_address = latch_value;
-	}
+	fsg_led_set(value, FSG_LED_WAN_BIT);
 }
 
 static void fsg_led_sata_set(struct led_classdev *led_cdev,
 			     enum led_brightness value)
 {
-	if (value) {
-		latch_value &= ~(1 << FSG_LED_SATA_BIT);
-		*latch_address = latch_value;
-	} else {
-		latch_value |=  (1 << FSG_LED_SATA_BIT);
-		*latch_address = latch_value;
-	}
+	fsg_led_set(value, FSG_LED_SATA_BIT);
 }
 
 static void fsg_led_usb_set(struct led_classdev *led_cdev,
 			    enum led_brightness value)
 {
-	if (value) {
-		latch_value &= ~(1 << FSG_LED_USB_BIT);
-		*latch_address = latch_value;
-	} else {
-		latch_value |=  (1 << FSG_LED_USB_BIT);
-		*latch_address = latch_value;
-	}
+	fsg_led_set(value, FSG_LED_USB_BIT);
 }
 
 static void fsg_led_sync_set(struct led_classdev *led_cdev,
 			     enum led_brightness value)
 {
-	if (value) {
-		latch_value &= ~(1 << FSG_LED_SYNC_BIT);
-		*latch_address = latch_value;
-	} else {
-		latch_value |=  (1 << FSG_LED_SYNC_BIT);
-		*latch_address = latch_value;
-	}
+	fsg_led_set(value, FSG_LED_SYNC_BIT);
 }
 
 static void fsg_led_ring_set(struct led_classdev *led_cdev,
 			     enum led_brightness value)
 {
-	if (value) {
-		latch_value &= ~(1 << FSG_LED_RING_BIT);
-		*latch_address = latch_value;
-	} else {
-		latch_value |=  (1 << FSG_LED_RING_BIT);
-		*latch_address = latch_value;
-	}
+	fsg_led_set(value, FSG_LED_RING_BIT);
 }
 
 
@@ -168,9 +143,6 @@ static int fsg_led_probe(struct platform_device *pdev)
 		goto failremap;
 	}
 
-	latch_value = 0xffff;
-	*latch_address = latch_value;
-
 	ret = led_classdev_register(&pdev->dev, &fsg_wlan_led);
 	if (ret < 0)
 		goto failwlan;
