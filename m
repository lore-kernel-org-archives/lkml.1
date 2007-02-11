Return-Path: <linux-kernel-owner+w=401wt.eu-S1750767AbXBKSS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767AbXBKSS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXBKSS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:18:26 -0500
Received: from averell.tiscali.it ([213.205.33.55]:59146 "EHLO
	averell.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXBKSS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:18:26 -0500
Date: Sun, 11 Feb 2007 19:17:43 +0100
From: Luca Tettamanti <kronos@people.it>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Message-ID: <20070211181743.GA15801@dreamland.darkstar.lan>
References: <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com> <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com> <20070130203301.GA15067@dreamland.darkstar.lan> <20070204201713.GA12867@dreamland.darkstar.lan> <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com> <20070205201824.GA13431@dreamland.darkstar.lan> <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com> <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org> <20070207234837.GA27822@dreamland.darkstar.lan> <cb7bb73a0702071619p5984c39fs16e3d05c11d45585@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb7bb73a0702071619p5984c39fs16e3d05c11d45585@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.

Il Thu, Feb 08, 2007 at 01:19:08AM +0100, Giuseppe Bilotta ha scritto: 
> On 2/8/07, Luca Tettamanti <kronos@people.it> wrote:
> >Il Tue, Feb 06, 2007 at 09:22:00PM +0000, James Simmons ha scritto:
> >> There is no stand alone nvidia card i2c driver. Its the issue of sharing
> >> device interfaces with the same hardware problem again!!!
> >
> >Nah, nvidiafb registers the I2C busses, you can drive them with whatever
> >you want through the devices exported by I2C core.
> >The fact the none of them work makes me think that the EDID is coming
> >from the BIOS, we do VBE calls in real mode during early kernel setup.
> 
> So what am I supposed to do to dump it, since neither i2cdump neither
> get-edid seem to work?

Good question :)

The following patch fixes a real bug in SCL control and add a few debug
info. Can you try it?

diff --git a/drivers/video/nvidia/nv_i2c.c b/drivers/video/nvidia/nv_i2c.c
index 8454adf..ca8bd7e 100644
--- a/drivers/video/nvidia/nv_i2c.c
+++ b/drivers/video/nvidia/nv_i2c.c
@@ -25,6 +25,12 @@
 
 #include "../edid.h"
 
+#define DDC_SDA_READ_MASK  (1 << 3)
+#define DDC_SCL_READ_MASK  (1 << 2)
+#define DDC_SDA_WRITE_MASK (1 << 4)
+#define DDC_SCL_WRITE_MASK (1 << 5)
+
+
 static void nvidia_gpio_setscl(void *data, int state)
 {
 	struct nvidia_i2c_chan *chan = data;
@@ -35,9 +41,9 @@ static void nvidia_gpio_setscl(void *data, int state)
 	val = VGA_RD08(par->PCIO, 0x3d5) & 0xf0;
 
 	if (state)
-		val |= 0x20;
+		val |= DDC_SDA_WRITE_MASK;
 	else
-		val &= ~0x20;
+		val &= ~DDC_SDA_WRITE_MASK;
 
 	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base + 1);
 	VGA_WR08(par->PCIO, 0x3d5, val | 0x1);
@@ -53,9 +59,9 @@ static void nvidia_gpio_setsda(void *data, int state)
 	val = VGA_RD08(par->PCIO, 0x3d5) & 0xf0;
 
 	if (state)
-		val |= 0x10;
+		val |= DDC_SDA_WRITE_MASK;
 	else
-		val &= ~0x10;
+		val &= ~DDC_SDA_WRITE_MASK;
 
 	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base + 1);
 	VGA_WR08(par->PCIO, 0x3d5, val | 0x1);
@@ -68,11 +74,9 @@ static int nvidia_gpio_getscl(void *data)
 	u32 val = 0;
 
 	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base);
-	if (VGA_RD08(par->PCIO, 0x3d5) & 0x04)
+	if (VGA_RD08(par->PCIO, 0x3d5) & DDC_SCL_READ_MASK)
 		val = 1;
 
-	val = VGA_RD08(par->PCIO, 0x3d5);
-
 	return val;
 }
 
@@ -83,7 +87,7 @@ static int nvidia_gpio_getsda(void *data)
 	u32 val = 0;
 
 	VGA_WR08(par->PCIO, 0x3d4, chan->ddc_base);
-	if (VGA_RD08(par->PCIO, 0x3d5) & 0x08)
+	if (VGA_RD08(par->PCIO, 0x3d5) & DDC_SDA_READ_MASK)
 		val = 1;
 
 	return val;
@@ -188,7 +192,7 @@ static u8 *nvidia_do_probe_i2c_edid(struct nvidia_i2c_chan *chan)
 
 	if (i2c_transfer(&chan->adapter, msgs, 2) == 2)
 		return buf;
-	dev_dbg(&chan->par->pci_dev->dev, "Unable to read EDID block.\n");
+	dev_warn(&chan->par->pci_dev->dev, "Unable to read EDID block.\n");
 	kfree(buf);
 	return NULL;
 }
@@ -208,7 +212,10 @@ int nvidia_probe_i2c_connector(struct fb_info *info, int conn, u8 **out_edid)
 
 	if (!edid && conn == 1) {
 		/* try to get from firmware */
-		const u8 *e = fb_firmware_edid(info->device);
+		const u8 *e;
+		printk("I2C probe failed for connector %d, falling back to firmware\n", conn);
+		
+		e = fb_firmware_edid(info->device);
 
 		if (e != NULL)
 			edid = kmemdup(e, EDID_LENGTH, GFP_KERNEL);

Luca
-- 
"La teoria e` quando sappiamo come funzionano le cose ma non funzionano.
 La pratica e` quando le cose funzionano ma non sappiamo perche`.
 Abbiamo unito la teoria e la pratica: le cose non funzionano piu` e non
 sappiamo il perche`." -- A. Einstein
