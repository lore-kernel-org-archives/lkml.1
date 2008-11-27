Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbYK0MaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbYK0MaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYK0MaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:30:11 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:50297 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYK0MaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:30:09 -0500
From: Yuri Tikhonov <yur@emcraft.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][v2] xsysace: use resource_size_t instead of unsigned long
Date: Thu, 27 Nov 2008 15:21:27 +0300
User-Agent: KMail/1.9.4
Cc: Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>,
       Ilya Yanok <yanok@emcraft.com>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811271521.27642.yur@emcraft.com>
X-Spam-Score: -3.0 (---)
X-Spam-Report: Spam detection software, running on the system "pacific.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Use resource_size_t for physical address of SystemACE chip.
	This fixes the driver brokeness for 32 bit systems with 64 bit resources
	(e.g. PPC440SPe). Also this patch adds one more compatible string for more
	clean description of the hardware, and fixes a sector_t- related compilation
	warning. [...] 
	Content analysis details:   (-3.0 points, 2.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.4 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size_t for physical address of SystemACE
chip. This fixes the driver brokeness for 32 bit systems
with 64 bit resources (e.g. PPC440SPe).

Also this patch adds one more compatible string for more
clean description of the hardware, and fixes a sector_t-
related compilation warning.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/block/xsysace.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index ecab9e6..9efd3d7 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -194,7 +194,7 @@ struct ace_device {
 	int in_irq;
 
 	/* Details of hardware device */
-	unsigned long physaddr;
+	resource_size_t physaddr;
 	void __iomem *baseaddr;
 	int irq;
 	int bus_width;		/* 0 := 8 bit; 1 := 16 bit */
@@ -628,8 +628,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 
 		/* Okay, it's a data request, set it up for transfer */
 		dev_dbg(ace->dev,
-			"request: sec=%lx hcnt=%lx, ccnt=%x, dir=%i\n",
-			req->sector, req->hard_nr_sectors,
+			"request: sec=%llx hcnt=%lx, ccnt=%x, dir=%i\n",
+			(unsigned long long)req->sector, req->hard_nr_sectors,
 			req->current_nr_sectors, rq_data_dir(req));
 
 		ace->req = req;
@@ -935,7 +935,8 @@ static int __devinit ace_setup(struct ace_device *ace)
 	int rc;
 
 	dev_dbg(ace->dev, "ace_setup(ace=0x%p)\n", ace);
-	dev_dbg(ace->dev, "physaddr=0x%lx irq=%i\n", ace->physaddr, ace->irq);
+	dev_dbg(ace->dev, "physaddr=0x%llx irq=%i\n",
+		(unsigned long long)ace->physaddr, ace->irq);
 
 	spin_lock_init(&ace->lock);
 	init_completion(&ace->id_completion);
@@ -1017,8 +1018,8 @@ static int __devinit ace_setup(struct ace_device *ace)
 	/* Print the identification */
 	dev_info(ace->dev, "Xilinx SystemACE revision %i.%i.%i\n",
 		 (version >> 12) & 0xf, (version >> 8) & 0x0f, version & 0xff);
-	dev_dbg(ace->dev, "physaddr 0x%lx, mapped to 0x%p, irq=%i\n",
-		ace->physaddr, ace->baseaddr, ace->irq);
+	dev_dbg(ace->dev, "physaddr 0x%llx, mapped to 0x%p, irq=%i\n",
+		(unsigned long long)ace->physaddr, ace->baseaddr, ace->irq);
 
 	ace->media_change = 1;
 	ace_revalidate_disk(ace->gd);
@@ -1035,8 +1036,8 @@ err_alloc_disk:
 err_blk_initq:
 	iounmap(ace->baseaddr);
 err_ioremap:
-	dev_info(ace->dev, "xsysace: error initializing device at 0x%lx\n",
-	       ace->physaddr);
+	dev_info(ace->dev, "xsysace: error initializing device at 0x%llx\n",
+		 (unsigned long long)ace->physaddr);
 	return -ENOMEM;
 }
 
@@ -1059,7 +1060,7 @@ static void __devexit ace_teardown(struct ace_device 
*ace)
 }
 
 static int __devinit
-ace_alloc(struct device *dev, int id, unsigned long physaddr,
+ace_alloc(struct device *dev, int id, resource_size_t physaddr,
 	  int irq, int bus_width)
 {
 	struct ace_device *ace;
@@ -1119,7 +1120,7 @@ static void __devexit ace_free(struct device *dev)
 
 static int __devinit ace_probe(struct platform_device *dev)
 {
-	unsigned long physaddr = 0;
+	resource_size_t physaddr = 0;
 	int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */
 	int id = dev->id;
 	int irq = NO_IRQ;
@@ -1165,7 +1166,7 @@ static int __devinit
 ace_of_probe(struct of_device *op, const struct of_device_id *match)
 {
 	struct resource res;
-	unsigned long physaddr;
+	resource_size_t physaddr;
 	const u32 *id;
 	int irq, bus_width, rc;
 
@@ -1205,6 +1206,7 @@ static struct of_device_id ace_of_match[] __devinitdata 
= {
 	{ .compatible = "xlnx,opb-sysace-1.00.b", },
 	{ .compatible = "xlnx,opb-sysace-1.00.c", },
 	{ .compatible = "xlnx,xps-sysace-1.00.a", },
+	{ .compatible = "xlnx,sysace", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ace_of_match);
-- 
1.5.6.1
