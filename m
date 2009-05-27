Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbZE0SPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbZE0SPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764011AbZE0SN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:13:58 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35494 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761061AbZE0SNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:13:55 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090527180716.187512073@gentwo.org>
References: <20090527180635.008102701@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 13:47:01 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
       Eric Biederman <ebiederm@aristanetworks.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David L Stevens <dlstevens@us.ibm.com>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [my_cpu_ptr 3/5] Elimninate get/put_cpu
Content-Disposition: inline; filename=my_cpu_ptr_eliminate_get_put_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where we can use my_cpu_ptr and as the result
of using my_cpu_ptr we no longer need to determine the
current executing cpu.

In those places no get/put_cpu combination is needed anymore.
The local cpu variable can be eliminated.

Preemption still needs to be disabled and enabled since the
modifications of the per cpu variables is not atomic. There may
be multiple per cpu variables modified and those must all
be from the same processor.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Biederman <ebiederm@aristanetworks.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David L Stevens <dlstevens@us.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 drivers/dma/dmaengine.c |   34 +++++++++++++++-------------------
 drivers/net/veth.c      |    7 +++----
 fs/nfs/iostat.h         |   21 +++++++++------------
 include/net/snmp.h      |   31 +++++++++++++++++--------------
 4 files changed, 44 insertions(+), 49 deletions(-)

Index: linux-2.6/drivers/dma/dmaengine.c
===================================================================
--- linux-2.6.orig/drivers/dma/dmaengine.c	2009-05-27 11:47:09.000000000 -0500
+++ linux-2.6/drivers/dma/dmaengine.c	2009-05-27 11:48:42.000000000 -0500
@@ -327,11 +327,10 @@ arch_initcall(dma_channel_table_init);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
 {
 	struct dma_chan *chan;
-	int cpu;
 
-	cpu = get_cpu();
-	chan = per_cpu_ptr(channel_table[tx_type], cpu)->chan;
-	put_cpu();
+	preempt_disable()
+	chan = my_cpu_ptr(channel_table[tx_type])->chan;
+	preempt_enable();
 
 	return chan;
 }
@@ -803,7 +802,6 @@ dma_async_memcpy_buf_to_buf(struct dma_c
 	struct dma_async_tx_descriptor *tx;
 	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
-	int cpu;
 	unsigned long flags;
 
 	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
@@ -822,10 +820,10 @@ dma_async_memcpy_buf_to_buf(struct dma_c
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
+	preempt_disable();
+	my_cpu_ptr(chan->local)->bytes_transferred += len;
+	my_cpu_ptr(chan->local)->memcpy_count++;
+	preempt_enable();
 
 	return cookie;
 }
@@ -852,7 +850,6 @@ dma_async_memcpy_buf_to_pg(struct dma_ch
 	struct dma_async_tx_descriptor *tx;
 	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
-	int cpu;
 	unsigned long flags;
 
 	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
@@ -869,10 +866,10 @@ dma_async_memcpy_buf_to_pg(struct dma_ch
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
+	preempt_disable();
+	my_cpu_ptr(chan->local)->bytes_transferred += len;
+	my_cpu_ptr(chan->local)->memcpy_count++;
+	preempt_enable();
 
 	return cookie;
 }
@@ -901,7 +898,6 @@ dma_async_memcpy_pg_to_pg(struct dma_cha
 	struct dma_async_tx_descriptor *tx;
 	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
-	int cpu;
 	unsigned long flags;
 
 	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
@@ -919,10 +915,10 @@ dma_async_memcpy_pg_to_pg(struct dma_cha
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
+	preempt_disable();
+	my_cpu_ptr(chan->local)->bytes_transferred += len;
+	my_cpu_ptr(chan->local)->memcpy_count++;
+	preempt_disable();
 
 	return cookie;
 }
Index: linux-2.6/drivers/net/veth.c
===================================================================
--- linux-2.6.orig/drivers/net/veth.c	2009-05-27 11:47:09.000000000 -0500
+++ linux-2.6/drivers/net/veth.c	2009-05-27 11:48:42.000000000 -0500
@@ -153,7 +153,7 @@ static int veth_xmit(struct sk_buff *skb
 	struct net_device *rcv = NULL;
 	struct veth_priv *priv, *rcv_priv;
 	struct veth_net_stats *stats, *rcv_stats;
-	int length, cpu;
+	int length;
 
 	skb_orphan(skb);
 
@@ -161,9 +161,8 @@ static int veth_xmit(struct sk_buff *skb
 	rcv = priv->peer;
 	rcv_priv = netdev_priv(rcv);
 
-	cpu = smp_processor_id();
-	stats = per_cpu_ptr(priv->stats, cpu);
-	rcv_stats = per_cpu_ptr(rcv_priv->stats, cpu);
+	stats = my_cpu_ptr(priv->stats);
+	rcv_stats = my_cpu_ptr(rcv_priv->stats);
 
 	if (!(rcv->flags & IFF_UP))
 		goto tx_drop;
Index: linux-2.6/fs/nfs/iostat.h
===================================================================
--- linux-2.6.orig/fs/nfs/iostat.h	2009-05-27 11:47:09.000000000 -0500
+++ linux-2.6/fs/nfs/iostat.h	2009-05-27 11:48:42.000000000 -0500
@@ -26,12 +26,11 @@ static inline void nfs_inc_server_stats(
 					enum nfs_stat_eventcounters stat)
 {
 	struct nfs_iostats *iostats;
-	int cpu;
 
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
+	preempt_disable();
+	iostats = my_cpu_ptr(server->io_stats);
 	iostats->events[stat]++;
-	put_cpu_no_resched();
+	preempt_enable_no_resched();
 }
 
 static inline void nfs_inc_stats(const struct inode *inode,
@@ -45,12 +44,11 @@ static inline void nfs_add_server_stats(
 					unsigned long addend)
 {
 	struct nfs_iostats *iostats;
-	int cpu;
 
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
+	preempt_disable();
+	iostats = my_cpu_ptr(server->io_stats);
 	iostats->bytes[stat] += addend;
-	put_cpu_no_resched();
+	preempt_enable_no_resched();
 }
 
 static inline void nfs_add_stats(const struct inode *inode,
@@ -66,12 +64,11 @@ static inline void nfs_add_fscache_stats
 					 unsigned long addend)
 {
 	struct nfs_iostats *iostats;
-	int cpu;
 
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(NFS_SERVER(inode)->io_stats, cpu);
+	preempt_disable();
+	iostats = my_cpu_ptr(NFS_SERVER(inode)->io_stats);
 	iostats->fscache[stat] += addend;
-	put_cpu_no_resched();
+	preempt_enable_no_resched();
 }
 #endif
 
Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2009-05-27 11:47:09.000000000 -0500
+++ linux-2.6/include/net/snmp.h	2009-05-27 11:48:42.000000000 -0500
@@ -139,26 +139,29 @@ struct linux_xfrm_mib {
 #define SNMP_INC_STATS_BH(mib, field) 	\
 	(__my_cpu_ptr(mib[0])->mibs[field]++)
 #define SNMP_INC_STATS_USER(mib, field) \
-	do { \
-		per_cpu_ptr(mib[1], get_cpu())->mibs[field]++; \
-		put_cpu(); \
-	} while (0)
+ 	do { \
+		preempt_disable();				\
+		my_cpu_ptr(mib[1])->mibs[field]++;		\
+		preempt_enable();				\
+  	} while (0)
 #define SNMP_INC_STATS(mib, field) 	\
-	do { \
-		per_cpu_ptr(mib[!in_softirq()], get_cpu())->mibs[field]++; \
-		put_cpu(); \
-	} while (0)
+ 	do { \
+		preempt_disable();				\
+		my_cpu_ptr(mib[!in_softirq()])->mibs[field]++;	\
+		preempt_enable(); \
+ 	} while (0)
 #define SNMP_DEC_STATS(mib, field) 	\
 	do { \
-		per_cpu_ptr(mib[!in_softirq()], get_cpu())->mibs[field]--; \
-		put_cpu(); \
+		preempt_disable();				\
+		my_cpu_ptr(mib[!in_softirq()])->mibs[field]--;	\
+		preempt_enable();				\
 	} while (0)
 #define SNMP_ADD_STATS_BH(mib, field, addend) 	\
 	(__my_cpu_ptr(mib[0])->mibs[field] += addend)
 #define SNMP_ADD_STATS_USER(mib, field, addend) 	\
-	do { \
-		per_cpu_ptr(mib[1], get_cpu())->mibs[field] += addend; \
-		put_cpu(); \
+ 	do { \
+		preempt_disable();				\
+		my_cpu_ptr(mib[1])->mibs[field] += addend;	\
+		preempt_enable();				\
 	} while (0)
-
 #endif

-- 
