Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZBKVaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZBKVaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbZBKV2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:28:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:48923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121AbZBKV2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,194,1233561600"; 
   d="scan'208";a="386031264"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.sc.intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, Chris Wright <chrisw@sous-sol.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Date: Wed, 11 Feb 2009 23:27:58 +0200
Subject: RE: [PATCH]iwlan dma mapping read and write changes
Thread-Topic: [PATCH]iwlan dma mapping read and write changes
Thread-Index: AcmMdlJaWAR3uEQCSk+2bWe8qK6D+QAGMJOA
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
 <20090211182648.GA1661@linux-os.sc.intel.com>
In-Reply-To: <20090211182648.GA1661@linux-os.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Yu, Fenghua
>Sent: Wednesday, February 11, 2009 8:27 PM
>To: David Woodhouse; Ingo Molnar; Stephen Rothwell; Andrew Morton; Johannes
>Berg; Grumbach, Emmanuel; Winkler, Tomas; Zhu, Yi; Chris Wright
>Cc: LKML; iommu@lists.linux-foundation.org
>Subject: [PATCH]iwlan dma mapping read and write changes
>
>When iwlan runs on IOMMU, IOMMU generates a lot of PTE write faults because
>PTE
>write bit is not set on some of PTE's. This is because iwlan driver calls
>DMA
>mapping with PCI_DMA_TODEVICE which is read only in mapping PTE. But iwlan
>device
>actually writes to the mapped page to update its contents. This issue is
>not
>exposed in swiotlb. But VT-d hardware can capture this fault and stop the
>fault
>transaction.
>
>The following patch fixes the issue.
>
>Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>

Indeed the firmware/ucode write back to host memory to update retry counter for APMDU packets. I'm not sure if this is needed for legacy traffic, though.   

>---
>
> iwl-tx.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
>
>--- a/drivers/net/wireless/iwlwifi/iwl-tx.c.orig	2009-02-10
>21:28:45.000000000 -0800
>+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c	2009-02-10
>21:41:02.000000000 -0800
>@@ -148,7 +148,7 @@ static void iwl_hw_txq_free_tfd(struct i
> 		pci_unmap_single(dev,
> 				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
> 				pci_unmap_len(&txq->cmd[index]->meta, len),
>-				PCI_DMA_TODEVICE);
>+				PCI_DMA_BIDIRECTIONAL);
>
> 	/* Unmap chunks, if any. */
> 	for (i = 1; i < num_tbs; i++) {
>@@ -964,7 +964,7 @@ int iwl_tx_skb(struct iwl_priv *priv, st
> 	 * within command buffer array. */
> 	txcmd_phys = pci_map_single(priv->pci_dev,
> 				    out_cmd, sizeof(struct iwl_cmd),
>-				    PCI_DMA_TODEVICE);
>+				    PCI_DMA_BIDIRECTIONAL);
> 	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
> 	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
> 	/* Add buffer containing Tx command and MAC(!) header to TFD's
>@@ -1115,7 +1115,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *pr
> 			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
>
> 	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
>-				   len, PCI_DMA_TODEVICE);
>+				   len, PCI_DMA_BIDIRECTIONAL);
> 	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
> 	pci_unmap_len_set(&out_cmd->meta, len, len);
> 	phys_addr += offsetof(struct iwl_cmd, hdr);
>@@ -1212,7 +1212,7 @@ static void iwl_hcmd_queue_reclaim(struc
> 	pci_unmap_single(priv->pci_dev,
> 		pci_unmap_addr(&txq->cmd[cmd_idx]->meta, mapping),
> 		pci_unmap_len(&txq->cmd[cmd_idx]->meta, len),
>-		PCI_DMA_TODEVICE);
>+		PCI_DMA_BIDIRECTIONAL);
>
> 	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
> 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

