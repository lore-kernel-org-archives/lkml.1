Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXJVMKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXJVMKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXJVMJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:09:53 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42321 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbXJVMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:09:52 -0400
Message-ID: <471C930D.4000004@tiscali.nl>
Date: Mon, 22 Oct 2007 14:09:49 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unlock before bug returns
References: <471C0697.1040906@tiscali.nl>	<471C11E5.2000003@tiscali.nl> <20071022001045.131ea465@bree.surriel.com>
In-Reply-To: <20071022001045.131ea465@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> should we bother to unlock before panicking, or is the unlock not
>> required either?
> 
> BUG() kills the current process, but not the whole system.
> 
> Unlocking the lock means that the rest of the system has somewhat
> of a chance of surviving.  Not unlocking means a guaranteed hang
> for the rest of the system, making a BUG() no better than panic.
> 
> Please keep the unlock.

In that case I guess the pathc below fixes some more unlockings before
bugging.

in the third patch: maybe BUG before "page_cache_release(page)"?
I also spotted some cases where it was attempted to free after BUG().
should that occur before BUG() as well?

--

    Unlock before BUG()
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 88629a3..679c8b4 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -100,8 +100,10 @@ static ssize_t vol_attribute_show(struct device *dev,
 		ret = sprintf(buf, "%lld\n", vol->used_bytes);
 	else if (attr == &attr_vol_upd_marker)
 		ret = sprintf(buf, "%d\n", vol->upd_marker);
-	else
+	else    {
+		spin_unlock(&vol->ubi->volumes_lock);
 		BUG();
+	}
 	spin_unlock(&vol->ubi->volumes_lock);
 	return ret;
 }
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index e3c8284..67ed205 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -8722,6 +8722,7 @@ static int ipw_wx_get_freq(struct net_device *dev,
 			break;
 
 		default:
+			mutex_unlock(&priv->mutex);
 			BUG();
 		}
 	} else
diff --git a/fs/buffer.c b/fs/buffer.c
index 76403b1..460c17d 100644
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
index cfa6be4..20c58dc 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1606,8 +1606,10 @@ void __init kmem_cache_init(void)
 		struct kmem_cache *cachep;
 		mutex_lock(&cache_chain_mutex);
 		list_for_each_entry(cachep, &cache_chain, next)
-			if (enable_cpucache(cachep))
+			if (enable_cpucache(cachep)) {
+				mutex_unlock(&cache_chain_mutex);
 				BUG();
+			}
 		mutex_unlock(&cache_chain_mutex);
 	}
 
diff --git a/net/rxrpc/ar-ack.c b/net/rxrpc/ar-ack.c
index 657ee69..c56e773 100644
--- a/net/rxrpc/ar-ack.c
+++ b/net/rxrpc/ar-ack.c
@@ -752,8 +752,10 @@ all_acked:
 		sp->call = call;
 		rxrpc_get_call(call);
 		spin_lock_bh(&call->lock);
-		if (rxrpc_queue_rcv_skb(call, skb, true, true) < 0)
+		if (rxrpc_queue_rcv_skb(call, skb, true, true) < 0) {
+			spin_unlock_bh(&call->lock);
 			BUG();
+		}
 		spin_unlock_bh(&call->lock);
 		goto process_further;
 	}
diff --git a/net/rxrpc/ar-call.c b/net/rxrpc/ar-call.c
index 3c04b00..0d30466 100644
--- a/net/rxrpc/ar-call.c
+++ b/net/rxrpc/ar-call.c
@@ -426,8 +426,10 @@ void rxrpc_release_call(struct rxrpc_call *call)
 	       call->rx_first_oos);
 
 	spin_lock_bh(&call->lock);
-	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags))
+	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		spin_unlock_bh(&call->lock);
 		BUG();
+	}
 	spin_unlock_bh(&call->lock);
 
 	/* dissociate from the socket
