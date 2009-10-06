Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbZJFXoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbZJFXoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933616AbZJFXoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:44:22 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39168 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933611AbZJFXoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:44:20 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091006233730.658458848@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:37:00 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 06/19] this_cpu_ptr: Straight transformations
Content-Disposition: inline; filename=this_cpu_ptr_straight_transforms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ptr and __this_cpu_ptr in locations where straight
transformations are possible because per_cpu_ptr is used with
either smp_processor_id() or raw_smp_processor_id().

cc: David Howells <dhowells@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 drivers/infiniband/hw/ehca/ehca_irq.c |    3 +--
 drivers/net/chelsio/sge.c             |    5 ++---
 drivers/net/loopback.c                |    2 +-
 fs/ext4/mballoc.c                     |    2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/net/chelsio/sge.c
===================================================================
--- linux-2.6.orig/drivers/net/chelsio/sge.c	2009-09-29 09:31:40.000000000 -0500
+++ linux-2.6/drivers/net/chelsio/sge.c	2009-09-29 11:39:20.000000000 -0500
@@ -1378,7 +1378,7 @@ static void sge_rx(struct sge *sge, stru
 	}
 	__skb_pull(skb, sizeof(*p));
 
-	st = per_cpu_ptr(sge->port_stats[p->iff], smp_processor_id());
+	st = this_cpu_ptr(sge->port_stats[p->iff]);
 
 	skb->protocol = eth_type_trans(skb, adapter->port[p->iff].dev);
 	if ((adapter->flags & RX_CSUM_ENABLED) && p->csum == 0xffff &&
@@ -1780,8 +1780,7 @@ netdev_tx_t t1_start_xmit(struct sk_buff
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
--- linux-2.6.orig/drivers/net/loopback.c	2009-09-29 09:31:40.000000000 -0500
+++ linux-2.6/drivers/net/loopback.c	2009-09-29 11:39:20.000000000 -0500
@@ -81,7 +81,7 @@ static netdev_tx_t loopback_xmit(struct 
 
 	/* it's OK to use per_cpu_ptr() because BHs are off */
 	pcpu_lstats = dev->ml_priv;
-	lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
+	lb_stats = this_cpu_ptr(pcpu_lstats);
 
 	len = skb->len;
 	if (likely(netif_rx(skb) == NET_RX_SUCCESS)) {
Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2009-09-29 09:31:40.000000000 -0500
+++ linux-2.6/fs/ext4/mballoc.c	2009-09-29 11:39:20.000000000 -0500
@@ -4210,7 +4210,7 @@ static void ext4_mb_group_or_file(struct
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = per_cpu_ptr(sbi->s_locality_groups, raw_smp_processor_id());
+	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2009-09-29 09:31:40.000000000 -0500
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c	2009-09-29 11:39:20.000000000 -0500
@@ -826,8 +826,7 @@ static void __cpuinit take_over_work(str
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 
 		list_del(&cq->entry);
-		__queue_comp_task(cq, per_cpu_ptr(pool->cpu_comp_tasks,
-						  smp_processor_id()));
+		__queue_comp_task(cq, this_cpu_ptr(pool->cpu_comp_tasks));
 	}
 
 	spin_unlock_irqrestore(&cct->task_lock, flags_cct);

-- 
