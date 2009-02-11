Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZBKS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZBKS07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbZBKS0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:26:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:52023 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbZBKS0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:26:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,193,1233561600"; 
   d="scan'208";a="109650733"
Date: Wed, 11 Feb 2009 10:26:48 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.sc.intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: [PATCH]iwlan dma mapping read and write changes
Message-ID: <20090211182648.GA1661@linux-os.sc.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001165606.GA21279@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When iwlan runs on IOMMU, IOMMU generates a lot of PTE write faults because PTE
write bit is not set on some of PTE's. This is because iwlan driver calls DMA
mapping with PCI_DMA_TODEVICE which is read only in mapping PTE. But iwlan device
actually writes to the mapped page to update its contents. This issue is not
exposed in swiotlb. But VT-d hardware can capture this fault and stop the fault
transaction.

The following patch fixes the issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 iwl-tx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c.orig	2009-02-10 21:28:45.000000000 -0800
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c	2009-02-10 21:41:02.000000000 -0800
@@ -148,7 +148,7 @@ static void iwl_hw_txq_free_tfd(struct i
 		pci_unmap_single(dev,
 				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
 				pci_unmap_len(&txq->cmd[index]->meta, len),
-				PCI_DMA_TODEVICE);
+				PCI_DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++) {
@@ -964,7 +964,7 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 	 * within command buffer array. */
 	txcmd_phys = pci_map_single(priv->pci_dev,
 				    out_cmd, sizeof(struct iwl_cmd),
-				    PCI_DMA_TODEVICE);
+				    PCI_DMA_BIDIRECTIONAL);
 	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
 	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
@@ -1115,7 +1115,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *pr
 			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
 
 	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
-				   len, PCI_DMA_TODEVICE);
+				   len, PCI_DMA_BIDIRECTIONAL);
 	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
 	pci_unmap_len_set(&out_cmd->meta, len, len);
 	phys_addr += offsetof(struct iwl_cmd, hdr);
@@ -1212,7 +1212,7 @@ static void iwl_hcmd_queue_reclaim(struc
 	pci_unmap_single(priv->pci_dev,
 		pci_unmap_addr(&txq->cmd[cmd_idx]->meta, mapping),
 		pci_unmap_len(&txq->cmd[cmd_idx]->meta, len),
-		PCI_DMA_TODEVICE);
+		PCI_DMA_BIDIRECTIONAL);
 
 	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
