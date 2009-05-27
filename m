Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbZE0SO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbZE0SO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763403AbZE0SN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:13:57 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42154 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760966AbZE0SNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:13:55 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "Cc"
Message-Id: <20090527180715.496502293@gentwo.org>
References: <20090527180635.008102701@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 13:47:00 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>
Cc: davem@davemloft.net
Subject: [my_cpu_ptr 2/5] Straight transformations
Content-Disposition: inline; filename=my_cpu_ptr_straight_transforms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use my_cpu_ptr and __my_cpu_ptr in locations where straight
transformations are possible because per_cpu_ptr is used with
either smp_processor_id() or raw_smp_processor_id().

Cc: David Howells <dhowells@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 drivers/infiniband/hw/ehca/ehca_irq.c       |    3 +--
 drivers/net/chelsio/sge.c                   |    5 ++---
 drivers/net/loopback.c                      |    2 +-
 fs/ext4/mballoc.c                           |    2 +-
 include/net/neighbour.h                     |    2 +-
 include/net/netfilter/nf_conntrack.h        |    4 ++--
 include/net/netfilter/nf_conntrack_ecache.h |    2 +-
 include/net/snmp.h                          |    4 ++--
 8 files changed, 11 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/net/chelsio/sge.c
===================================================================
--- linux-2.6.orig/drivers/net/chelsio/sge.c	2009-05-27 11:39:44.000000000 -0500
+++ linux-2.6/drivers/net/chelsio/sge.c	2009-05-27 11:40:25.000000000 -0500
@@ -1378,7 +1378,7 @@ static void sge_rx(struct sge *sge, stru
 	}
 	__skb_pull(skb, sizeof(*p));
 
-	st = per_cpu_ptr(sge->port_stats[p->iff], smp_processor_id());
+	st = my_cpu_ptr(sge->port_stats[p->iff]);
 
 	skb->protocol = eth_type_trans(skb, adapter->port[p->iff].dev);
 	if ((adapter->flags & RX_CSUM_ENABLED) && p->csum == 0xffff &&
@@ -1780,8 +1780,7 @@ int t1_start_xmit(struct sk_buff *skb, s
 {
 	struct adapter *adapter = dev->ml_priv;
 	struct sge *sge = adapter->sge;
-	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port],
-						smp_processor_id());
+	struct sge_port_stats *st = my_cpu_ptr(sge->port_stats[dev->if_port]);
 	struct cpl_tx_pkt *cpl;
 	struct sk_buff *orig_skb = skb;
 	int ret;
Index: linux-2.6/drivers/net/loopback.c
===================================================================
--- linux-2.6.orig/drivers/net/loopback.c	2009-05-27 11:39:44.000000000 -0500
+++ linux-2.6/drivers/net/loopback.c	2009-05-27 11:40:12.000000000 -0500
@@ -78,7 +78,7 @@ static int loopback_xmit(struct sk_buff 
 
 	/* it's OK to use per_cpu_ptr() because BHs are off */
 	pcpu_lstats = dev->ml_priv;
-	lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
+	lb_stats = my_cpu_ptr(pcpu_lstats);
 	lb_stats->bytes += skb->len;
 	lb_stats->packets++;
 
Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2009-05-27 11:39:44.000000000 -0500
+++ linux-2.6/fs/ext4/mballoc.c	2009-05-27 11:40:12.000000000 -0500
@@ -4210,7 +4210,7 @@ static void ext4_mb_group_or_file(struct
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = per_cpu_ptr(sbi->s_locality_groups, raw_smp_processor_id());
+	ac->ac_lg = __my_cpu_ptr(sbi->s_locality_groups);
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
Index: linux-2.6/include/net/neighbour.h
===================================================================
--- linux-2.6.orig/include/net/neighbour.h	2009-05-27 11:39:44.000000000 -0500
+++ linux-2.6/include/net/neighbour.h	2009-05-27 11:40:12.000000000 -0500
@@ -92,7 +92,7 @@ struct neigh_statistics
 #define NEIGH_CACHE_STAT_INC(tbl, field)				\
 	do {								\
 		preempt_disable();					\
-		(per_cpu_ptr((tbl)->stats, smp_processor_id())->field)++; \
+		(my_cpu_ptr((tbl)->stats)->field)++;			\
 		preempt_enable();					\
 	} while (0)
 
Index: linux-2.6/include/net/netfilter/nf_conntrack.h
===================================================================
--- linux-2.6.orig/include/net/netfilter/nf_conntrack.h	2009-05-27 11:39:44.000000000 -0500
+++ linux-2.6/include/net/netfilter/nf_conntrack.h	2009-05-27 11:40:12.000000000 -0500
@@ -292,11 +292,11 @@ extern unsigned int nf_conntrack_htable_
 extern unsigned int nf_conntrack_max;
 
 #define NF_CT_STAT_INC(net, count)	\
-	(per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++)
+	(__my_cpu_ptr((net)->ct.stat)->count++)
 #define NF_CT_STAT_INC_ATOMIC(net, count)		\
 do {							\
 	local_bh_disable();				\
-	per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++;	\
+	__my_cpu_ptr((net)->ct.stat)->count++;		\
 	local_bh_enable();				\
 } while (0)
 
Index: linux-2.6/include/net/netfilter/nf_conntrack_ecache.h
===================================================================
--- linux-2.6.orig/include/net/netfilter/nf_conntrack_ecache.h	2009-05-27 11:39:44.000000000 -0500
+++ linux-2.6/include/net/netfilter/nf_conntrack_ecache.h	2009-05-27 11:40:12.000000000 -0500
@@ -39,7 +39,7 @@ nf_conntrack_event_cache(enum ip_conntra
 	struct nf_conntrack_ecache *ecache;
 
 	local_bh_disable();
-	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
+	ecache = __my_cpu_ptr(net->ct.ecache);
 	if (ct != ecache->ct)
 		__nf_ct_event_cache_init(ct);
 	ecache->events |= event;
Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2009-05-27 11:40:23.000000000 -0500
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c	2009-05-27 11:40:25.000000000 -0500
@@ -827,8 +827,7 @@ static void __cpuinit take_over_work(str
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 
 		list_del(&cq->entry);
-		__queue_comp_task(cq, per_cpu_ptr(pool->cpu_comp_tasks,
-						  smp_processor_id()));
+		__queue_comp_task(cq, my_cpu_ptr(pool->cpu_comp_tasks));
 	}
 
 	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2009-05-27 11:40:23.000000000 -0500
+++ linux-2.6/include/net/snmp.h	2009-05-27 11:40:25.000000000 -0500
@@ -137,7 +137,7 @@ struct linux_xfrm_mib {
 #define SNMP_STAT_USRPTR(name)	(name[1])
 
 #define SNMP_INC_STATS_BH(mib, field) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field]++)
+	(__my_cpu_ptr(mib[0])->mibs[field]++)
 #define SNMP_INC_STATS_USER(mib, field) \
 	do { \
 		per_cpu_ptr(mib[1], get_cpu())->mibs[field]++; \
@@ -154,7 +154,7 @@ struct linux_xfrm_mib {
 		put_cpu(); \
 	} while (0)
 #define SNMP_ADD_STATS_BH(mib, field, addend) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field] += addend)
+	(__my_cpu_ptr(mib[0])->mibs[field] += addend)
 #define SNMP_ADD_STATS_USER(mib, field, addend) 	\
 	do { \
 		per_cpu_ptr(mib[1], get_cpu())->mibs[field] += addend; \

-- 
