Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYCQWAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYCQWAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYCQV75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:59:57 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:53592 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYCQV74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:59:56 -0400
Message-ID: <47DEEA09.9000108@keyaccess.nl>
Date: Mon, 17 Mar 2008 23:00:41 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Michael Cree <mcree@orcon.net.nz>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080313042402.CE3D7DBA2@gherkin.frus.com>
In-Reply-To: <20080313042402.CE3D7DBA2@gherkin.frus.com>
Content-Type: multipart/mixed;
 boundary="------------050005060905050709030305"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050005060905050709030305
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 13-03-08 05:24, Bob Tracy wrote:

> Rene Herman wrote:
>> Okay, and applying the attached just makes your sound completely dead in the 
>> water?
>> (patch to delete es1888_init function)
> 
> Oddly enough, the patch had no effect whatsoever (at least with the
> ALSA drivers: I didn't try building a kernel with the OSS "sb" driver).
> Just to make sure I wasn't "benefiting" from initialization inherited
> from a prior boot, I even powered-down the machine for 30 seconds
> before booting on the new kernel.  snd-sb8 still works, and snd-es18xx
> is still broken (in exactly the same way as before).

Okay, thought I'd stare at this thing a bit -- there's no specific 1888 
documentation available it seems but I did notice something in the 1878 
datasheet which might mean something. The docs says that bits 0-1 are don't 
care for DMA but don't for IRQ, so could it possibly be as simple as the 
attached?

1878 sheet doesn't document register 0x7f, it seems...

Assuming it's not just this, this thing is going to require quite a bit of 
trial and error and without the hardware this will be troublesome. I expect 
this is not it, since the arch init code also doesn't care about bit 0 when 
setting that same register for IRQ 5.

If this is not it -- I'd try s/0x50/0x10/ in that line, even completely 
commenting out the IRQ setting line (with the arch code built in) and just 
generally frolic around 'till something blows up...

Rene.


--------------050005060905050709030305
Content-Type: text/plain;
 name="es18xx_trial_and_error.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="es18xx_trial_and_error.diff"

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 90498e4..71d1b96 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1449,16 +1449,16 @@ static int __devinit snd_es18xx_initialize(struct snd_es18xx *chip)
 		switch (chip->irq) {
 		case 2:
 		case 9:
-			irqmask = 0;
+			irqmask = 0x0;
 			break;
 		case 5:
-			irqmask = 1;
+			irqmask = 0x5;
 			break;
 		case 7:
-			irqmask = 2;
+			irqmask = 0xa;
 			break;
 		case 10:
-			irqmask = 3;
+			irqmask = 0xf;
 			break;
 		default:
 			snd_printk(KERN_ERR "invalid irq %d\n", chip->irq);
@@ -1497,7 +1497,7 @@ static int __devinit snd_es18xx_initialize(struct snd_es18xx *chip)
 		}
 
 		/* Enable and set Audio 1 IRQ */
-		snd_es18xx_write(chip, 0xB1, 0x50 | (irqmask << 2));
+		snd_es18xx_write(chip, 0xB1, 0x50 | irqmask);
 		/* Enable and set Audio 1 DMA */
 		snd_es18xx_write(chip, 0xB2, 0x50 | (dma1mask << 2));
 		/* Set Audio 2 DMA */
@@ -1513,7 +1513,9 @@ static int __devinit snd_es18xx_initialize(struct snd_es18xx *chip)
 			   FM enabled */
 			snd_es18xx_mixer_write(chip, 0x40, 0x43 | (chip->mpu_port & 0xf0) >> 1);
 		}
+#if 0
 		snd_es18xx_mixer_write(chip, 0x7f, ((irqmask + 1) << 1) | 0x01);
+#endif
 	}
 	if (chip->caps & ES18XX_NEW_RATE) {
 		/* Change behaviour of register A1

--------------050005060905050709030305--
