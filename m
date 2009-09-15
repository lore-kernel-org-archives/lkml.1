Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZIOTHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZIOTHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbZIOTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:07:23 -0400
Received: from kroah.org ([198.145.64.141]:35809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbZIOTHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:07:21 -0400
Date: Tue, 15 Sep 2009 11:07:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.34
Message-ID: <20090915180721.GB32060@kroah.com>
References: <20090915180703.GA32060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915180703.GA32060@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 1b2c0fb..1debf9a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .33
+EXTRAVERSION = .34
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index d991167..c68c57b 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1842,7 +1842,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 				nic->ru_running = RU_SUSPENDED;
 		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
 					       sizeof(struct rfd),
-					       PCI_DMA_BIDIRECTIONAL);
+					       PCI_DMA_FROMDEVICE);
 		return -ENODATA;
 	}
 
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 0e78b00..4d89e5f 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1271,10 +1271,20 @@ int jffs2_nor_wbuf_flash_setup(struct jffs2_sb_info *c) {
 	if (!c->wbuf)
 		return -ENOMEM;
 
+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+	c->wbuf_verify = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
+	if (!c->wbuf_verify) {
+		kfree(c->wbuf);
+		return -ENOMEM;
+	}
+#endif
 	return 0;
 }
 
 void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c) {
+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+	kfree(c->wbuf_verify);
+#endif
 	kfree(c->wbuf);
 }
 
diff --git a/mm/slub.c b/mm/slub.c
index f0175b4..cbf856b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2447,8 +2447,6 @@ static inline int kmem_cache_close(struct kmem_cache *s)
  */
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	if (s->flags & SLAB_DESTROY_BY_RCU)
-		rcu_barrier();
 	down_write(&slub_lock);
 	s->refcount--;
 	if (!s->refcount) {
@@ -2459,6 +2457,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
 				"still has objects.\n", s->name, __func__);
 			dump_stack();
 		}
+		if (s->flags & SLAB_DESTROY_BY_RCU)
+			rcu_barrier();
 		sysfs_slab_remove(s);
 	} else
 		up_write(&slub_lock);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 7c52fe2..656f6fb 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -446,7 +446,7 @@ int net_assign_generic(struct net *net, int id, void *data)
 
 	ng->len = id;
 	INIT_RCU_HEAD(&ng->rcu);
-	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len);
+	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
 	call_rcu(&old_ng->rcu, net_generic_release);
