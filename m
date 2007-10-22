Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbXJVRvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbXJVRvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXJVRva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:51:30 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:57017 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXJVRv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:51:29 -0400
Message-ID: <471CE31E.8020009@tiscali.nl>
Date: Mon, 22 Oct 2007 19:51:26 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH retry] return hidden bug and unlock bugs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patches shouldn't alter behavior when CONFIG_BUG is disabled. It is meant
as a replacement for the previous patches.

Concerning the patch changing fs/buffer.c, I am still wondering whether
"page_cache_release(page)" should be placed before or after the BUG().
--
    Unlock before BUG(), but don't change behavior in the case when
    CONFIG_BUG is disabled
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index e1c4707..6a69425 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -365,8 +365,8 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
 		printk(KERN_ERR "Bogus pci_unmap_single: dma_addr %lx "
 		       " base %lx size %x\n", dma_addr, arena->dma_base,
 		       arena->size);
-		return;
 		BUG();
+		return;
 	}
 
 	npages = calc_npages((dma_addr & ~PAGE_MASK) + size);
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 5a4cc20..12bd0eb 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -357,8 +357,8 @@ void gpmc_cs_free(int cs)
 	spin_lock(&gpmc_mem_lock);
 	if (cs >= GPMC_CS_NUM || !gpmc_cs_reserved(cs)) {
 		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
-		BUG();
 		spin_unlock(&gpmc_mem_lock);
+		BUG();
 		return;
 	}
 	gpmc_cs_disable_mem(cs);
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 88629a3..e72bead 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -100,8 +100,11 @@ static ssize_t vol_attribute_show(struct device *dev,
 		ret = sprintf(buf, "%lld\n", vol->used_bytes);
 	else if (attr == &attr_vol_upd_marker)
 		ret = sprintf(buf, "%d\n", vol->upd_marker);
-	else
+	else {
+		spin_unlock(&vol->ubi->volumes_lock);
 		BUG();
+		return -EINVAL;
+	}
 	spin_unlock(&vol->ubi->volumes_lock);
 	return ret;
 }
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index e3c8284..f337578 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -8722,7 +8722,9 @@ static int ipw_wx_get_freq(struct net_device *dev,
 			break;
 
 		default:
+			mutex_unlock(&priv->mutex);
 			BUG();
+			return -EINVAL;
 		}
 	} else
 		wrqu->freq.m = 0;
diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..90a3785 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1051,9 +1051,9 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	return page;
 
 failed:
-	BUG();
 	unlock_page(page);
 	page_cache_release(page);
+	BUG();
 	return NULL;
 }
 
diff --git a/mm/slab.c b/mm/slab.c
index cfa6be4..2dd48c1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1604,11 +1604,16 @@ void __init kmem_cache_init(void)
 	/* 6) resize the head arrays to their final sizes */
 	{
 		struct kmem_cache *cachep;
+		int fail = 0;
 		mutex_lock(&cache_chain_mutex);
 		list_for_each_entry(cachep, &cache_chain, next)
-			if (enable_cpucache(cachep))
+			if (enable_cpucache(cachep)) {
+				fail = 1;
+				mutex_unlock(&cache_chain_mutex);
 				BUG();
-		mutex_unlock(&cache_chain_mutex);
+			}
+		if (fail != 1)
+			mutex_unlock(&cache_chain_mutex);
 	}
 
 	/* Annotate slab for lockdep -- annotate the malloc caches */
diff --git a/net/rxrpc/ar-ack.c b/net/rxrpc/ar-ack.c
index 657ee69..e551b0b 100644
--- a/net/rxrpc/ar-ack.c
+++ b/net/rxrpc/ar-ack.c
@@ -752,8 +752,11 @@ all_acked:
 		sp->call = call;
 		rxrpc_get_call(call);
 		spin_lock_bh(&call->lock);
-		if (rxrpc_queue_rcv_skb(call, skb, true, true) < 0)
+		if (rxrpc_queue_rcv_skb(call, skb, true, true) < 0) {
+			spin_unlock_bh(&call->lock);
 			BUG();
+			goto process_further;
+		}
 		spin_unlock_bh(&call->lock);
 		goto process_further;
 	}
diff --git a/net/rxrpc/ar-call.c b/net/rxrpc/ar-call.c
index 3c04b00..48804e1 100644
--- a/net/rxrpc/ar-call.c
+++ b/net/rxrpc/ar-call.c
@@ -426,9 +426,12 @@ void rxrpc_release_call(struct rxrpc_call *call)
 	       call->rx_first_oos);
 
 	spin_lock_bh(&call->lock);
-	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags))
+	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		spin_unlock_bh(&call->lock);
 		BUG();
-	spin_unlock_bh(&call->lock);
+	} else {
+		spin_unlock_bh(&call->lock);
+	}
 
 	/* dissociate from the socket
 	 * - the socket's ref on the call is passed to the death timer
