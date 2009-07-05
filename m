Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZGEGgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZGEGgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 02:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZGEGfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 02:35:52 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48506 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZGEGfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 02:35:51 -0400
Date: Sun, 5 Jul 2009 08:35:51 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/ata: Use resource_size
Message-ID: <Pine.LNX.4.64.0907050835260.27464@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the function resource_size, which reduces the chance of introducing
off-by-one errors in calculating the resource size.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/ata/pata_octeon_cf.c |    2 +-
 drivers/ata/pata_platform.c  |    8 ++++----
 drivers/ata/pata_rb532_cf.c  |    2 +-
 drivers/ata/sata_mv.c        |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -u -p a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
--- a/drivers/ata/pata_octeon_cf.c 2009-04-13 16:04:29.000000000 +0200
+++ b/drivers/ata/pata_octeon_cf.c 2009-07-04 21:39:00.000000000 +0200
@@ -840,7 +840,7 @@ static int __devinit octeon_cf_probe(str
 	ocd = pdev->dev.platform_data;
 
 	cs0 = devm_ioremap_nocache(&pdev->dev, res_cs0->start,
-				   res_cs0->end - res_cs0->start + 1);
+				   resource_size(res_cs0));
 
 	if (!cs0)
 		return -ENOMEM;
diff -u -p a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
--- a/drivers/ata/pata_platform.c 2009-01-09 22:41:01.000000000 +0100
+++ b/drivers/ata/pata_platform.c 2009-07-04 21:37:16.000000000 +0200
@@ -151,14 +151,14 @@ int __devinit __pata_platform_probe(stru
 	 */
 	if (mmio) {
 		ap->ioaddr.cmd_addr = devm_ioremap(dev, io_res->start,
-				io_res->end - io_res->start + 1);
+				resource_size(io_res));
 		ap->ioaddr.ctl_addr = devm_ioremap(dev, ctl_res->start,
-				ctl_res->end - ctl_res->start + 1);
+				resource_size(ctl_res));
 	} else {
 		ap->ioaddr.cmd_addr = devm_ioport_map(dev, io_res->start,
-				io_res->end - io_res->start + 1);
+				resource_size(io_res));
 		ap->ioaddr.ctl_addr = devm_ioport_map(dev, ctl_res->start,
-				ctl_res->end - ctl_res->start + 1);
+				resource_size(ctl_res));
 	}
 	if (!ap->ioaddr.cmd_addr || !ap->ioaddr.ctl_addr) {
 		dev_err(dev, "failed to map IO/CTL base\n");
diff -u -p a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
--- a/drivers/ata/pata_rb532_cf.c 2009-03-28 23:34:54.000000000 +0100
+++ b/drivers/ata/pata_rb532_cf.c 2009-07-04 21:37:20.000000000 +0200
@@ -151,7 +151,7 @@ static __devinit int rb532_pata_driver_p
 	info->irq = irq;
 
 	info->iobase = devm_ioremap_nocache(&pdev->dev, res->start,
-				res->end - res->start + 1);
+				resource_size(res));
 	if (!info->iobase)
 		return -ENOMEM;
 
diff -u -p a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c 2009-05-16 16:21:16.000000000 +0200
+++ b/drivers/ata/sata_mv.c 2009-07-04 21:37:17.000000000 +0200
@@ -4013,7 +4013,7 @@ static int mv_platform_probe(struct plat
 
 	host->iomap = NULL;
 	hpriv->base = devm_ioremap(&pdev->dev, res->start,
-				   res->end - res->start + 1);
+				   resource_size(res));
 	hpriv->base -= SATAHC0_REG_BASE;
 
 	/*
