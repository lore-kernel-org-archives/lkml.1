Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZFEV7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZFEV7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZFEV7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:59:08 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55109 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbZFEV7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:59:06 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "Cc"
Message-Id: <20090605191851.201488971@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:24 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>
Cc: davem@davemloft.net
Subject: [this_cpu_xx 05/11] this_cpu_ptr: Straight transformations
Content-Disposition: inline; filename=this_cpu_ptr_straight_transforms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ptr and __this_cpu_ptr in locations where straight
transformations are possible because per_cpu_ptr is used with
either smp_processor_id() or raw_smp_processor_id().

cc: David Howells <dhowells@redhat.com>
cc: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 drivers/infiniband/hw/ehca/ehca_irq.c       |    3 +--
 drivers/net/chelsio/sge.c                   |    5 ++---
 drivers/net/loopback.c                      |    2 +-
 fs/ext4/mballoc.c                           |    2 +-
 include/net/netfilter/nf_conntrack_ecache.h |    2 +-
 5 files changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/net/chelsio/sge.c
===================================================================
--- linux-2.6.orig/drivers/net/chelsio/sge.c	2009-06-03 12:27:07.000000000 -0500
+++ linux-2.6/drivers/net/chelsio/sge.c	2009-06-03 12:38:53.000000000 -0500
@@ -1378,7 +1378,7 @@ static void sge_rx(struct sge *sge, stru
 	}
 	__skb_pull(skb, sizeof(*p));
 
-	st = per_cpu_ptr(sge->port_stats[p->iff], smp_processor_id());
+	st = this_cpu_ptr(sge->port_stats[p->iff]);
 
 	skb->protocol = eth_type_trans(skb, adapter->port[p->iff].dev);
 	if ((adapter->flags & RX_CSUM_ENABLED) && p->csum == 0xffff &&
@@ -1780,8 +1780,7 @@ int t1_start_xmit(struct sk_buff *skb, s
 {
 	struct adapter *adapter = dev->ml_priv;
 	struct sge *sge = adapter->sge;
-	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port],
-						smp_processor_id());
+	struct sge_port_stats *st = this_cpu_ptr(sge->port_stats[dev->if_port]);
 	struct cpl_tx_pkt *cpl;
 	struct sk_buff *orig_skb = skb;
 	int ret;
Index: linux-2.6/drivers/net/loopback.c
===================================================================
--- linux-2.6.orig/drivers/net/loopback.c	2009-06-03 12:27:07.000000000 -0500
+++ linux-2.6/drivers/net/loopback.c	2009-06-03 12:38:53.000000000 -0500
@@ -78,7 +78,7 @@ static int loopback_xmit(struct sk_buff 
 
 	/* it's OK to use per_cpu_ptr() because BHs are off */
 	pcpu_lstats = dev->ml_priv;
-	lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
+	lb_stats = this_cpu_ptr(pcpu_lstats);
 	lb_stats->bytes += skb->len;
 	lb_stats->packets++;
 
Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2009-06-03 12:27:07.000000000 -0500
+++ linux-2.6/fs/ext4/mballoc.c	2009-06-03 12:38:53.000000000 -0500
@@ -4210,7 +4210,7 @@ static void ext4_mb_group_or_file(struct
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = per_cpu_ptr(sbi->s_locality_groups, raw_smp_processor_id());
+	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
Index: linux-2.6/include/net/netfilter/nf_conntrack_ecache.h
===================================================================
--- linux-2.6.orig/include/net/netfilter/nf_conntrack_ecache.h	2009-06-03 12:27:07.000000000 -0500
+++ linux-2.6/include/net/netfilter/nf_conntrack_ecache.h	2009-06-03 12:38:53.000000000 -0500
@@ -39,7 +39,7 @@ nf_conntrack_event_cache(enum ip_conntra
 	struct nf_conntrack_ecache *ecache;
 
 	local_bh_disable();
-	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
+	ecache = __this_cpu_ptr(net->ct.ecache);
 	if (ct != ecache->ct)
 		__nf_ct_event_cache_init(ct);
 	ecache->events |= event;
Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2009-06-03 12:27:07.000000000 -0500
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c	2009-06-03 12:38:53.000000000 -0500
@@ -827,8 +827,7 @@ static void __cpuinit take_over_work(str
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 
 		list_del(&cq->entry);
-		__queue_comp_task(cq, per_cpu_ptr(pool->cpu_comp_tasks,
-						  smp_processor_id()));
+		__queue_comp_task(cq, this_cpu_ptr(pool->cpu_comp_tasks));
 	}
 
 	spin_unlock_irqrestore(&cct->task_lock, flags_cct);

-- 
