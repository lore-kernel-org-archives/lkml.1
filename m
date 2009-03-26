Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZCZHw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZCZHw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZCZHwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:52:14 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35514 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753208AbZCZHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:52:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Z/wfFX98VAFMIVn+j1xLrwmXNZV+fEF5xxw/TopCPQUj71gA/rLKx4HzcYbJCsR7AUPO90PhAm4blf6f+uy9CXReaahy6J4aUfhiQW8/dhDblPd16aWp+/8d6NH5FFf5C7KGgW9B6cvOAsE5dQGbHRT7UuNceqvf4ij+4ZjVmaI=  ;
X-YMail-OSG: 32ljZ78VM1lkDYClcno6fvLShdSrfzoD.7kxuZDZM7v.BnDVruc1X7cQIVHqVR4d8urbqvM0R.tfVvKkb4q3qnBPl96bz2cTn_aQDvH9xMTjisOWN9GCy5Is8qTfO8Bl4DtePHQOVM0GcWmjLy_Xmsh2g5d66BcBms576YHL_X3z.1xCotl_pCdTu3rNAN1BwHDO0KRT_UfERA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 2.6.29 2/2] MTD: support driver model updates
Date: Thu, 26 Mar 2009 00:42:50 -0700
User-Agent: KMail/1.9.10
Cc: Kay Sievers <kay.sievers@vrfy.org>
References: <200903260039.34013.david-b@pacbell.net>
In-Reply-To: <200903260039.34013.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903260042.50236.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Follow-on patch to the previous driver model patch for the MTD
framework.  This one makes various MTD drivers connect to the
driver model tree, so /sys/devices/virtual/mtd/* nodes are no
longer present ... mostly drivers used on boards I have handy.

Based on a patch from Kay Sievers.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mtd/devices/m25p80.c        |    2 ++
 drivers/mtd/devices/mtd_dataflash.c |    2 ++
 drivers/mtd/maps/omap_nor.c         |    2 ++
 drivers/mtd/maps/physmap.c          |    1 +
 drivers/mtd/maps/plat-ram.c         |    1 +
 drivers/mtd/nand/davinci_nand.c     |    2 ++
 drivers/mtd/nand/mxc_nand.c         |    1 +
 drivers/mtd/onenand/omap2.c         |    2 ++
 8 files changed, 13 insertions(+)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -678,6 +678,8 @@ static int __devinit m25p_probe(struct s
 		flash->mtd.erasesize = info->sector_size;
 	}
 
+	flash->mtd.dev.parent = &spi->dev;
+
 	dev_info(&spi->dev, "%s (%lld Kbytes)\n", info->name,
 			(long long)flash->mtd.size >> 10);
 
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -670,6 +670,8 @@ add_dataflash_otp(struct spi_device *spi
 	device->write = dataflash_write;
 	device->priv = priv;
 
+	device->dev.parent = &spi->dev;
+
 	if (revision >= 'c')
 		otp_tag = otp_setup(device, revision);
 
--- a/drivers/mtd/maps/omap_nor.c
+++ b/drivers/mtd/maps/omap_nor.c
@@ -115,6 +115,8 @@ static int __init omapflash_probe(struct
 	}
 	info->mtd->owner = THIS_MODULE;
 
+	info->mtd->dev.parent = &pdev->dev;
+
 #ifdef CONFIG_MTD_PARTITIONS
 	err = parse_mtd_partitions(info->mtd, part_probes, &info->parts, 0);
 	if (err > 0)
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -147,6 +147,7 @@ static int physmap_flash_probe(struct pl
 			devices_found++;
 		}
 		info->mtd[i]->owner = THIS_MODULE;
+		info->mtd[i]->dev.parent = &dev->dev;
 	}
 
 	if (devices_found == 1) {
--- a/drivers/mtd/maps/plat-ram.c
+++ b/drivers/mtd/maps/plat-ram.c
@@ -224,6 +224,7 @@ static int platram_probe(struct platform
 	}
 
 	info->mtd->owner = THIS_MODULE;
+	info->mtd->dev.parent = &pdev->dev;
 
 	platram_setrw(info, PLATRAM_RW);
 
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -358,6 +358,8 @@ static int __init nand_davinci_probe(str
 	info->mtd.name		= dev_name(&pdev->dev);
 	info->mtd.owner		= THIS_MODULE;
 
+	info->mtd.dev.parent	= &pdev->dev;
+
 	info->chip.IO_ADDR_R	= vaddr;
 	info->chip.IO_ADDR_W	= vaddr;
 	info->chip.chip_delay	= 0;
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -866,6 +866,7 @@ static int __init mxcnd_probe(struct pla
 	mtd = &host->mtd;
 	mtd->priv = this;
 	mtd->owner = THIS_MODULE;
+	mtd->dev.parent = &pdev->dev;
 
 	/* 50 us command delay time */
 	this->chip_delay = 5;
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -672,6 +672,8 @@ static int __devinit omap2_onenand_probe
 	c->mtd.priv = &c->onenand;
 	c->mtd.owner = THIS_MODULE;
 
+	c->mtd.dev.parent = &pdev->dev;
+
 	if (c->dma_channel >= 0) {
 		struct onenand_chip *this = &c->onenand;
 
