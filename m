Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZIPWg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZIPWg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760308AbZIPWgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:36:41 -0400
Received: from kroah.org ([198.145.64.141]:40954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161AbZIPWck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:02 2009
Message-Id: <20090916222902.799848712@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 14/24] mlx4_core: Allocate and map sufficient ICM memory for EQ context
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=mlx4_core-allocate-and-map-sufficient-icm-memory-for-eq-context.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland Dreier <rolandd@cisco.com>

commit fa0681d2129732027355d6b7083dd8932b9b799d upstream.

The current implementation allocates a single host page for EQ context
memory, which was OK when we only allocated a few EQs.  However, since
we now allocate an EQ for each CPU core, this patch removes the
hard-coded limit (which we exceed with 4 KB pages and 128 byte EQ
context entries with 32 CPUs) and uses the same ICM table code as all
other context tables, which ends up simplifying the code quite a bit
while fixing the problem.

This problem was actually hit in practice on a dual-socket Nehalem box
with 16 real hardware threads and sufficiently odd ACPI tables that it
shows on boot

    SMP: Allowing 32 CPUs, 16 hotplug CPUs

so num_possible_cpus() ends up 32, and mlx4 ends up creating 33 MSI-X
interrupts and 33 EQs.  This mlx4 bug means that mlx4 can't even
initialize at all on this quite mainstream system.

Reported-by: Eli Cohen <eli@mellanox.co.il>
Tested-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/mlx4/eq.c   |   42 ------------------------------------------
 drivers/net/mlx4/main.c |    9 ++++++---
 drivers/net/mlx4/mlx4.h |    7 +------
 3 files changed, 7 insertions(+), 51 deletions(-)

--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -524,48 +524,6 @@ static void mlx4_unmap_clr_int(struct ml
 	iounmap(priv->clr_base);
 }
 
-int mlx4_map_eq_icm(struct mlx4_dev *dev, u64 icm_virt)
-{
-	struct mlx4_priv *priv = mlx4_priv(dev);
-	int ret;
-
-	/*
-	 * We assume that mapping one page is enough for the whole EQ
-	 * context table.  This is fine with all current HCAs, because
-	 * we only use 32 EQs and each EQ uses 64 bytes of context
-	 * memory, or 1 KB total.
-	 */
-	priv->eq_table.icm_virt = icm_virt;
-	priv->eq_table.icm_page = alloc_page(GFP_HIGHUSER);
-	if (!priv->eq_table.icm_page)
-		return -ENOMEM;
-	priv->eq_table.icm_dma  = pci_map_page(dev->pdev, priv->eq_table.icm_page, 0,
-					       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(dev->pdev, priv->eq_table.icm_dma)) {
-		__free_page(priv->eq_table.icm_page);
-		return -ENOMEM;
-	}
-
-	ret = mlx4_MAP_ICM_page(dev, priv->eq_table.icm_dma, icm_virt);
-	if (ret) {
-		pci_unmap_page(dev->pdev, priv->eq_table.icm_dma, PAGE_SIZE,
-			       PCI_DMA_BIDIRECTIONAL);
-		__free_page(priv->eq_table.icm_page);
-	}
-
-	return ret;
-}
-
-void mlx4_unmap_eq_icm(struct mlx4_dev *dev)
-{
-	struct mlx4_priv *priv = mlx4_priv(dev);
-
-	mlx4_UNMAP_ICM(dev, priv->eq_table.icm_virt, 1);
-	pci_unmap_page(dev->pdev, priv->eq_table.icm_dma, PAGE_SIZE,
-		       PCI_DMA_BIDIRECTIONAL);
-	__free_page(priv->eq_table.icm_page);
-}
-
 int mlx4_alloc_eq_table(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -520,7 +520,10 @@ static int mlx4_init_icm(struct mlx4_dev
 		goto err_unmap_aux;
 	}
 
-	err = mlx4_map_eq_icm(dev, init_hca->eqc_base);
+	err = mlx4_init_icm_table(dev, &priv->eq_table.table,
+				  init_hca->eqc_base, dev_cap->eqc_entry_sz,
+				  dev->caps.num_eqs, dev->caps.num_eqs,
+				  0, 0);
 	if (err) {
 		mlx4_err(dev, "Failed to map EQ context memory, aborting.\n");
 		goto err_unmap_cmpt;
@@ -663,7 +666,7 @@ err_unmap_mtt:
 	mlx4_cleanup_icm_table(dev, &priv->mr_table.mtt_table);
 
 err_unmap_eq:
-	mlx4_unmap_eq_icm(dev);
+	mlx4_cleanup_icm_table(dev, &priv->eq_table.table);
 
 err_unmap_cmpt:
 	mlx4_cleanup_icm_table(dev, &priv->eq_table.cmpt_table);
@@ -693,11 +696,11 @@ static void mlx4_free_icms(struct mlx4_d
 	mlx4_cleanup_icm_table(dev, &priv->qp_table.qp_table);
 	mlx4_cleanup_icm_table(dev, &priv->mr_table.dmpt_table);
 	mlx4_cleanup_icm_table(dev, &priv->mr_table.mtt_table);
+	mlx4_cleanup_icm_table(dev, &priv->eq_table.table);
 	mlx4_cleanup_icm_table(dev, &priv->eq_table.cmpt_table);
 	mlx4_cleanup_icm_table(dev, &priv->cq_table.cmpt_table);
 	mlx4_cleanup_icm_table(dev, &priv->srq_table.cmpt_table);
 	mlx4_cleanup_icm_table(dev, &priv->qp_table.cmpt_table);
-	mlx4_unmap_eq_icm(dev);
 
 	mlx4_UNMAP_ICM_AUX(dev);
 	mlx4_free_icm(dev, priv->fw.aux_icm, 0);
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -205,9 +205,7 @@ struct mlx4_eq_table {
 	void __iomem	      **uar_map;
 	u32			clr_mask;
 	struct mlx4_eq	       *eq;
-	u64			icm_virt;
-	struct page	       *icm_page;
-	dma_addr_t		icm_dma;
+	struct mlx4_icm_table	table;
 	struct mlx4_icm_table	cmpt_table;
 	int			have_irq;
 	u8			inta_pin;
@@ -373,9 +371,6 @@ u64 mlx4_make_profile(struct mlx4_dev *d
 		      struct mlx4_dev_cap *dev_cap,
 		      struct mlx4_init_hca_param *init_hca);
 
-int mlx4_map_eq_icm(struct mlx4_dev *dev, u64 icm_virt);
-void mlx4_unmap_eq_icm(struct mlx4_dev *dev);
-
 int mlx4_cmd_init(struct mlx4_dev *dev);
 void mlx4_cmd_cleanup(struct mlx4_dev *dev);
 void mlx4_cmd_event(struct mlx4_dev *dev, u16 token, u8 status, u64 out_param);


