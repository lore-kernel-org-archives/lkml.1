Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0BJNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:09:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0BJNJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:09:55 -0500
Date: Wed, 10 Feb 2010 14:07:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "lkml@Think-Future.de" <lkml@Think-Future.de>,
       Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] iwlwifi: use dma_alloc_coherent
Message-ID: <20100210130744.GA3935@dhcp-lab-161.englab.brq.redhat.com>
References: <20100206170348.GB9411@localhost> <20100208143118.e8e5a1ee.akpm@linux-foundation.org> <20100209165247.GB2512@dhcp-lab-161.englab.brq.redhat.com> <1265735092.2551.1835.camel@rchatre-DESK> <20100210082137.GA2519@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210082137.GA2519@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change pci_alloc_consistent() to dma_alloc_coherent() so we can use
GFP_KERNEL flag.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Tested with 3945 and 5300

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   21 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   23 ++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 ++++++++--------
 6 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 234891d..e955515 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2474,11 +2474,9 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	memset((void *)&priv->hw_params, 0,
 	       sizeof(struct iwl_hw_params));
 
-	priv->shared_virt =
-	    pci_alloc_consistent(priv->pci_dev,
-				 sizeof(struct iwl3945_shared),
-				 &priv->shared_phys);
-
+	priv->shared_virt = dma_alloc_coherent(&priv->pci_dev->dev,
+					       sizeof(struct iwl3945_shared),
+					       &priv->shared_phys, GFP_KERNEL);
 	if (!priv->shared_virt) {
 		IWL_ERR(priv, "failed to allocate pci memory\n");
 		mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5461f10..f6a7866 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1658,9 +1658,9 @@ EXPORT_SYMBOL(iwl_set_tx_power);
 void iwl_free_isr_ict(struct iwl_priv *priv)
 {
 	if (priv->ict_tbl_vir) {
-		pci_free_consistent(priv->pci_dev, (sizeof(u32) * ICT_COUNT) +
-					PAGE_SIZE, priv->ict_tbl_vir,
-					priv->ict_tbl_dma);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
+				  priv->ict_tbl_vir, priv->ict_tbl_dma);
 		priv->ict_tbl_vir = NULL;
 	}
 }
@@ -1676,9 +1676,9 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv)
 	if (priv->cfg->use_isr_legacy)
 		return 0;
 	/* allocate shrared data table */
-	priv->ict_tbl_vir = pci_alloc_consistent(priv->pci_dev, (sizeof(u32) *
-						  ICT_COUNT) + PAGE_SIZE,
-						  &priv->ict_tbl_dma);
+	priv->ict_tbl_vir = dma_alloc_coherent(&priv->pci_dev->dev,
+					(sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
+					&priv->ict_tbl_dma, GFP_KERNEL);
 	if (!priv->ict_tbl_vir)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index bd0b12e..f8481e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -80,8 +80,8 @@ static inline void iwl_free_fw_desc(struct pci_dev *pci_dev,
 				    struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		pci_free_consistent(pci_dev, desc->len,
-				    desc->v_addr, desc->p_addr);
+		dma_free_coherent(&pci_dev->dev, desc->len,
+				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
 }
@@ -89,7 +89,8 @@ static inline void iwl_free_fw_desc(struct pci_dev *pci_dev,
 static inline int iwl_alloc_fw_desc(struct pci_dev *pci_dev,
 				    struct fw_desc *desc)
 {
-	desc->v_addr = pci_alloc_consistent(pci_dev, desc->len, &desc->p_addr);
+	desc->v_addr = dma_alloc_coherent(&pci_dev->dev, desc->len,
+					  &desc->p_addr, GFP_KERNEL);
 	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 6f36b6e..cfcb3c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -350,10 +350,10 @@ void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 		}
 	}
 
-	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			    rxq->dma_addr);
-	pci_free_consistent(priv->pci_dev, sizeof(struct iwl_rb_status),
-			    rxq->rb_stts, rxq->rb_stts_dma);
+	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			  rxq->dma_addr);
+	dma_free_coherent(&priv->pci_dev->dev, sizeof(struct iwl_rb_status),
+			  rxq->rb_stts, rxq->rb_stts_dma);
 	rxq->bd = NULL;
 	rxq->rb_stts  = NULL;
 }
@@ -362,7 +362,7 @@ EXPORT_SYMBOL(iwl_rx_queue_free);
 int iwl_rx_queue_alloc(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct pci_dev *dev = priv->pci_dev;
+	struct device *dev = &priv->pci_dev->dev;
 	int i;
 
 	spin_lock_init(&rxq->lock);
@@ -370,12 +370,13 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 	INIT_LIST_HEAD(&rxq->rx_used);
 
 	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
-	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
+	rxq->bd = dma_alloc_coherent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr,
+				     GFP_KERNEL);
 	if (!rxq->bd)
 		goto err_bd;
 
-	rxq->rb_stts = pci_alloc_consistent(dev, sizeof(struct iwl_rb_status),
-					&rxq->rb_stts_dma);
+	rxq->rb_stts = dma_alloc_coherent(dev, sizeof(struct iwl_rb_status),
+					  &rxq->rb_stts_dma, GFP_KERNEL);
 	if (!rxq->rb_stts)
 		goto err_rb;
 
@@ -392,8 +393,8 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 	return 0;
 
 err_rb:
-	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			    rxq->dma_addr);
+	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			  rxq->dma_addr);
 err_bd:
 	return -ENOMEM;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 87ce2bd..281d318 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -60,7 +60,8 @@ static const u16 default_tid_to_tx_fifo[] = {
 static inline int iwl_alloc_dma_ptr(struct iwl_priv *priv,
 				    struct iwl_dma_ptr *ptr, size_t size)
 {
-	ptr->addr = pci_alloc_consistent(priv->pci_dev, size, &ptr->dma);
+	ptr->addr = dma_alloc_coherent(&priv->pci_dev->dev, size, &ptr->dma,
+				       GFP_KERNEL);
 	if (!ptr->addr)
 		return -ENOMEM;
 	ptr->size = size;
@@ -73,7 +74,7 @@ static inline void iwl_free_dma_ptr(struct iwl_priv *priv,
 	if (unlikely(!ptr->addr))
 		return;
 
-	pci_free_consistent(priv->pci_dev, ptr->size, ptr->addr, ptr->dma);
+	dma_free_coherent(&priv->pci_dev->dev, ptr->size, ptr->addr, ptr->dma);
 	memset(ptr, 0, sizeof(*ptr));
 }
 
@@ -132,7 +133,7 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
-	struct pci_dev *dev = priv->pci_dev;
+	struct device *dev = &priv->pci_dev->dev;
 	int i;
 
 	if (q->n_bd == 0)
@@ -149,8 +150,8 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, priv->hw_params.tfd_size *
-				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
+		dma_free_coherent(dev, priv->hw_params.tfd_size *
+				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
 	kfree(txq->txb);
@@ -179,7 +180,7 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
-	struct pci_dev *dev = priv->pci_dev;
+	struct device *dev = &priv->pci_dev->dev;
 	int i;
 
 	if (q->n_bd == 0)
@@ -191,8 +192,8 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, priv->hw_params.tfd_size *
-				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
+		dma_free_coherent(dev, priv->hw_params.tfd_size * txq->q.n_bd,
+				  txq->tfds, txq->q.dma_addr);
 
 	/* deallocate arrays */
 	kfree(txq->cmd);
@@ -283,7 +284,7 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 			      struct iwl_tx_queue *txq, u32 id)
 {
-	struct pci_dev *dev = priv->pci_dev;
+	struct device *dev = &priv->pci_dev->dev;
 	size_t tfd_sz = priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX;
 
 	/* Driver private data, only for Tx (not command) queues,
@@ -302,8 +303,8 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->tfds = pci_alloc_consistent(dev, tfd_sz, &txq->q.dma_addr);
-
+	txq->tfds = dma_alloc_coherent(dev, tfd_sz, &txq->q.dma_addr,
+				       GFP_KERNEL);
 	if (!txq->tfds) {
 		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n", tfd_sz);
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f8e4e4b..f297865 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -352,10 +352,10 @@ static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 {
 	if (priv->shared_virt)
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct iwl3945_shared),
-				    priv->shared_virt,
-				    priv->shared_phys);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  sizeof(struct iwl3945_shared),
+				  priv->shared_virt,
+				  priv->shared_phys);
 }
 
 static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
@@ -1253,10 +1253,10 @@ static void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rx
 		}
 	}
 
-	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			    rxq->dma_addr);
-	pci_free_consistent(priv->pci_dev, sizeof(struct iwl_rb_status),
-			    rxq->rb_stts, rxq->rb_stts_dma);
+	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			  rxq->dma_addr);
+	dma_free_coherent(&priv->pci_dev->dev, sizeof(struct iwl_rb_status),
+			  rxq->rb_stts, rxq->rb_stts_dma);
 	rxq->bd = NULL;
 	rxq->rb_stts  = NULL;
 }
-- 
1.6.2.5

