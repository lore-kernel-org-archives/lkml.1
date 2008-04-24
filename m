Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYDXM5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYDXM5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYDXM5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:57:13 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3337 "EHLO mail.araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYDXM5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:57:12 -0400
Date: Thu, 24 Apr 2008 12:57:08 +0000 (GMT)
From: Michael Abbott <michael@araneidae.co.uk>
To: Ben Dooks <ben-linux@fluff.org>, linux-net@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] DM9000: Reimplement 2-resource device specification (fwd)
Message-ID: <20080424125217.M52274@saturn.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Abbott <michael.abbott@diamond.ac.uk>

[PATCH] DM9000: Reimplement 2-resource device specification

In commit 1a5f1c4ff80f522555d78d4dd0109f18395c6d83 a change was made to
the handling of the resources passed the DM9000 device.  Unfortunately,
if only two resources are passed (the read and write register in the same
area) the pointer db->irq_res ends up being used without being initialised.

This patch tidies this up a little.  Only one architecture class,
blackfin, uses two resource specification, so it may be better to enforce
three resource specification as before by simply removing the 0 and 2
resource branches from dm9000_probe.

This patch implements the data resource, if it is not specified, by setting
io_data = io_addr+4 -- this is the original behaviour.

The memory region releasing has also been revisited, as the old 
implemention looks horribly broken to me.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
  drivers/net/dm9000.c |  122 +++++++++++++++++++++----------------------------
  1 files changed, 52 insertions(+), 70 deletions(-)

I'm not so confident of this patch, and it does include a small amout of 
peripherally related reformatting.  I'm afraid I've not been able to test 
this very thoroughly, thought it does appear to work.

diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
index 9ad9499..7f3e78f 100644
--- a/drivers/net/dm9000.c
+++ b/drivers/net/dm9000.c
@@ -469,6 +469,8 @@ static const struct ethtool_ops dm9000_ethtool_ops = {
   	.set_eeprom		= dm9000_set_eeprom,
  };

+#define res_size(_r) (((_r)->end - (_r)->start) + 1)
+

  /* dm9000_release_board
   *
@@ -478,11 +480,13 @@ static const struct ethtool_ops dm9000_ethtool_ops = {
  static void
  dm9000_release_board(struct platform_device *pdev, struct board_info *db)
  {
-	if (db->data_res == NULL) {
-		if (db->addr_res != NULL)
-			release_mem_region((unsigned long)db->io_addr, 4);
-		return;
-	}
+	/* Release the allocated mem regions. */
+	if (db->addr_req != NULL)
+		release_mem_region(
+			db->addr_res->start, res_size(db->addr_res));
+	if (db->data_req != NULL)
+		release_mem_region(
+			db->data_res->start, res_size(db->data_res));

  	/* unmap our resources */

@@ -502,8 +506,6 @@ dm9000_release_board(struct platform_device *pdev, struct board_info *db)
  	}
  }

-#define res_size(_r) (((_r)->end - (_r)->start) + 1)
-
  /*
   * Search DM9000 board, allocate space and register it
   */
@@ -514,10 +516,9 @@ dm9000_probe(struct platform_device *pdev)
  	struct board_info *db;	/* Point a board information structure */
  	struct net_device *ndev;
  	const unsigned char *mac_src;
-	unsigned long base;
  	int ret = 0;
  	int iosize;
-	int i;
+	int addrsize;
  	u32 id_val;

  	/* Init network device */
@@ -540,105 +541,86 @@ dm9000_probe(struct platform_device *pdev)
  	spin_lock_init(&db->lock);
  	mutex_init(&db->addr_lock);

-	if (pdev->num_resources < 2) {
-		ret = -ENODEV;
+	/* Process the platform resources to configure the address register,
+	 * data register and IRQ. */
+	db->addr_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	db->irq_res  = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (db->addr_res == NULL || db->irq_res == NULL) {
+		dev_err(db->dev, "insufficient resources\n");
+		ret = -ENOENT;
  		goto out;
-	} else if (pdev->num_resources == 2) {
-		base = pdev->resource[0].start;
-
-		if (!request_mem_region(base, 4, ndev->name)) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		ndev->base_addr = base;
-		ndev->irq = pdev->resource[1].start;
-		db->io_addr = (void __iomem *)base;
-		db->io_data = (void __iomem *)(base + 4);
-
-		/* ensure at least we have a default set of IO routines */
-		dm9000_set_io(db, 2);
-
-	} else {
-		db->addr_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		db->data_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		db->irq_res  = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-
-		if (db->addr_res == NULL || db->data_res == NULL ||
-		    db->irq_res == NULL) {
-			dev_err(db->dev, "insufficient resources\n");
-			ret = -ENOENT;
-			goto out;
-		}
-
-		i = res_size(db->addr_res);
-		db->addr_req = request_mem_region(db->addr_res->start, i,
-						  pdev->name);
-
-		if (db->addr_req == NULL) {
-			dev_err(db->dev, "cannot claim address reg area\n");
-			ret = -EIO;
-			goto out;
-		}
-
-		db->io_addr = ioremap(db->addr_res->start, i);
-
-		if (db->io_addr == NULL) {
-			dev_err(db->dev, "failed to ioremap address reg\n");
+	}
+
+	addrsize = res_size(db->addr_res);
+	db->addr_req = request_mem_region(
+		db->addr_res->start, addrsize, pdev->name);
+	if (db->addr_req == NULL) {
+		dev_err(db->dev, "cannot claim address reg area\n");
+		ret = -EIO;
+		goto out;
+	}
+	db->io_addr = ioremap(db->addr_res->start, addrsize);
+	if (db->io_addr == NULL) {
+		dev_err(db->dev, "failed to ioremap address reg\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	db->data_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (db->data_res == NULL) {
+		/* Special case: if no separate data resource is provided
+		 * then use io_addr+4 as the io_data address and take the
+		 * remaining io length from the resource. */
+		iosize = addrsize - 4;
+		if (iosize < 1) {
+			dev_err(db->dev, "no space allocated for data reg\n");
  			ret = -EINVAL;
  			goto out;
  		}
-
+		db->io_data = db->io_addr + 4;
+	} else {
  		iosize = res_size(db->data_res);
  		db->data_req = request_mem_region(db->data_res->start, iosize,
  						  pdev->name);
-
  		if (db->data_req == NULL) {
  			dev_err(db->dev, "cannot claim data reg area\n");
  			ret = -EIO;
  			goto out;
  		}
-
  		db->io_data = ioremap(db->data_res->start, iosize);
-
  		if (db->io_data == NULL) {
  			dev_err(db->dev,"failed to ioremap data reg\n");
  			ret = -EINVAL;
  			goto out;
  		}
+	}

-		/* fill in parameters for net-dev structure */
+	/* fill in parameters for net-dev structure */

-		ndev->base_addr = (unsigned long)db->io_addr;
-		ndev->irq	= db->irq_res->start;
+	ndev->base_addr = (unsigned long)db->io_addr;
+	ndev->irq	= db->irq_res->start;
+
+	/* ensure at least we have a default set of IO routines */
+	dm9000_set_io(db, iosize);

-		/* ensure at least we have a default set of IO routines */
-		dm9000_set_io(db, iosize);
-	}

  	/* check to see if anything is being over-ridden */
  	if (pdata != NULL) {
  		/* check to see if the driver wants to over-ride the
  		 * default IO width */
-
  		if (pdata->flags & DM9000_PLATF_8BITONLY)
  			dm9000_set_io(db, 1);
-
  		if (pdata->flags & DM9000_PLATF_16BITONLY)
  			dm9000_set_io(db, 2);
-
  		if (pdata->flags & DM9000_PLATF_32BITONLY)
  			dm9000_set_io(db, 4);

  		/* check to see if there are any IO routine
  		 * over-rides */
-
  		if (pdata->inblk != NULL)
  			db->inblk = pdata->inblk;
-
  		if (pdata->outblk != NULL)
  			db->outblk = pdata->outblk;
-
  		if (pdata->dumpblk != NULL)
  			db->dumpblk = pdata->dumpblk;

@@ -647,7 +629,7 @@ dm9000_probe(struct platform_device *pdev)

  	dm9000_reset(db);

-	/* try two times, DM9000 sometimes gets the first read wrong */
+	/* try several times, DM9000 sometimes gets the first read wrong */
  	for (i = 0; i < 8; i++) {
  		id_val  = ior(db, DM9000_VIDL);
  		id_val |= (u32)ior(db, DM9000_VIDH) << 8;
-- 
1.5.5
