Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYBJVRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYBJVRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYBJVRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:17:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:28890 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYBJVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=KXP8xP1v0STwz5wxUUqwCEizw9UfvN720T58cOqmXROh5/DGhw0UHQfExQr3qnSLEz6ULrkrO7Prxz0hH6g7NVwX4hkouOUv4J9bA0DpA3PedhkBq2H/tbm0Z/CbX0TzUUcole/BigC0I5Ec7WrkXpsS47Fx+D1eq8+5pbOeULw=
Date: Sun, 10 Feb 2008 21:17:30 +0000 (GMT)
To: jgarzik@pobox.com, linux-ide@vger.kernel.org
cc: linux-kernel@vger.kernel.org, saeed@marvell.com, mlord@pobox.com
Subject: [PATCH] sata_mv: platform driver allocs dma without create
Message-ID: <alpine.DEB.1.00.0802102117150.9668@git.byronbradley.co.uk>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Byron Bradley <byron.bbradley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the sata_mv driver is used as a platform driver,
mv_create_dma_pools() is never called so it fails when trying
to alloc in mv_pool_start().

Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Acked-by: Mark Lord <mlord@pobox.com>
---

Mark, based on the comment from Andrew Morton on the "sata_mv: fix loop
with last port" patch I have changed your Signed-off-by to an Acked-by.
Hopefully thats correct.

 drivers/ata/sata_mv.c |   44 ++++++++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index f5333ce..04b5717 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2881,6 +2881,26 @@ done:
 	return rc;
 }

+static int mv_create_dma_pools(struct mv_host_priv *hpriv, struct device *dev)
+{
+	hpriv->crqb_pool   = dmam_pool_create("crqb_q", dev, MV_CRQB_Q_SZ,
+							     MV_CRQB_Q_SZ, 0);
+	if (!hpriv->crqb_pool)
+		return -ENOMEM;
+
+	hpriv->crpb_pool   = dmam_pool_create("crpb_q", dev, MV_CRPB_Q_SZ,
+							     MV_CRPB_Q_SZ, 0);
+	if (!hpriv->crpb_pool)
+		return -ENOMEM;
+
+	hpriv->sg_tbl_pool = dmam_pool_create("sg_tbl", dev, MV_SG_TBL_SZ,
+							     MV_SG_TBL_SZ, 0);
+	if (!hpriv->sg_tbl_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /**
  *      mv_platform_probe - handle a positive probe of an soc Marvell
  *      host
@@ -2934,6 +2954,10 @@ static int mv_platform_probe(struct platform_device *pdev)
 	hpriv->base = ioremap(res->start, res->end - res->start + 1);
 	hpriv->base -= MV_SATAHC0_REG_BASE;

+	rc = mv_create_dma_pools(hpriv, &pdev->dev);
+	if (rc)
+		return rc;
+
 	/* initialize adapter */
 	rc = mv_init_host(host, chip_soc);
 	if (rc)
@@ -3070,26 +3094,6 @@ static void mv_print_info(struct ata_host *host)
 	       scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
 }

-static int mv_create_dma_pools(struct mv_host_priv *hpriv, struct device *dev)
-{
-	hpriv->crqb_pool   = dmam_pool_create("crqb_q", dev, MV_CRQB_Q_SZ,
-							     MV_CRQB_Q_SZ, 0);
-	if (!hpriv->crqb_pool)
-		return -ENOMEM;
-
-	hpriv->crpb_pool   = dmam_pool_create("crpb_q", dev, MV_CRPB_Q_SZ,
-							     MV_CRPB_Q_SZ, 0);
-	if (!hpriv->crpb_pool)
-		return -ENOMEM;
-
-	hpriv->sg_tbl_pool = dmam_pool_create("sg_tbl", dev, MV_SG_TBL_SZ,
-							     MV_SG_TBL_SZ, 0);
-	if (!hpriv->sg_tbl_pool)
-		return -ENOMEM;
-
-	return 0;
-}
-
 /**
  *      mv_pci_init_one - handle a positive probe of a PCI Marvell host
  *      @pdev: PCI device found
-- 
1.5.4.rc2.38.gd6da3

