Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZFXLPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZFXLPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZFXLPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:15:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:49663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZFXLPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:15:04 -0400
Subject: Re: BUS_ID_SIZE is going away
From: David Woodhouse <dwmw2@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>, catalin.marinas@arm.com
Cc: Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
In-Reply-To: <1245832038.2483.3.camel@yio.site>
References: <1245527124.30962.14.camel@yio.site>
	 <1245675383.25547.50.camel@macbook.infradead.org>
	 <1245832038.2483.3.camel@yio.site>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 12:14:55 +0100
Message-Id: <1245842095.25547.5380.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 10:27 +0200, Kay Sievers wrote:
> On Mon, 2009-06-22 at 13:56 +0100, David Woodhouse wrote:
> > I have this queued for 2.6.31 but have been on jury duty for the last 2
> > weeks so I'm hoping to get the pull request to Linus today now that I'm
> > free.
> 
> The old one is gone, but seems you merged a new one with BUS_ID_SIZE :)
> 
>   ./drivers/mtd/maps/integrator-flash.c:#define SUBDEV_NAME_SIZE	(BUS_ID_SIZE + 2)

Hm, true :)

Catalin, can you test the following? 

Btw, I'm unconvinced by the existing error handling -- if
armflash_subdev_probe() fails, it doesn't look like _that_ subdev
actually gets cleaned up in the loop at 'subdev_err:'. So we don't
release the memory region (and neither do we free the newly-kmalloced
name).

In fact, do we still need a separate platform device and driver for ARM
systems? What does it provide that the physmap driver does (and can)
not?

diff --git a/drivers/mtd/maps/integrator-flash.c b/drivers/mtd/maps/integrator-flash.c
index b08a798..b9fac5b 100644
--- a/drivers/mtd/maps/integrator-flash.c
+++ b/drivers/mtd/maps/integrator-flash.c
@@ -42,10 +42,8 @@
 #include <mach/hardware.h>
 #include <asm/system.h>
 
-#define SUBDEV_NAME_SIZE	(BUS_ID_SIZE + 2)
-
 struct armflash_subdev_info {
-	char			name[SUBDEV_NAME_SIZE];
+	char			*name;
 	struct mtd_info		*mtd;
 	struct map_info		map;
 	struct flash_platform_data *plat;
@@ -134,6 +132,8 @@ static void armflash_subdev_remove(struct armflash_subdev_info *subdev)
 		map_destroy(subdev->mtd);
 	if (subdev->map.virt)
 		iounmap(subdev->map.virt);
+	kfree(subdev->name);
+	subdev->name = NULL;
 	release_mem_region(subdev->map.phys, subdev->map.size);
 }
 
@@ -177,11 +177,14 @@ static int armflash_probe(struct platform_device *dev)
 
 		if (nr == 1)
 			/* No MTD concatenation, just use the default name */
-			snprintf(subdev->name, SUBDEV_NAME_SIZE, "%s",
-				 dev_name(&dev->dev));
+			subdev->name = kstrdup(dev_name(&dev->dev), GFP_KERNEL);
 		else
-			snprintf(subdev->name, SUBDEV_NAME_SIZE, "%s-%d",
-				 dev_name(&dev->dev), i);
+			subdev->name = kasprintf(GFP_KERNEL, "%s-%d",
+						 dev_name(&dev->dev), i);
+		if (!subdev->name) {
+			err = -ENOMEM;
+			break;
+		}
 		subdev->plat = plat;
 
 		err = armflash_subdev_probe(subdev, res);


-- 
dwmw2

