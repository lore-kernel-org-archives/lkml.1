Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZFEW26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZFEW26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZFEW2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:28:50 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45551 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752512AbZFEW2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:28:49 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191851.012334412@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:23 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 04/11] Use this_cpu ops for network statistics
Content-Disposition: inline; filename=this_cpu_net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/net/neighbour.h              |    7 +------
 include/net/netfilter/nf_conntrack.h |    9 ++-------
 2 files changed, 3 insertions(+), 13 deletions(-)

Index: linux-2.6/include/net/neighbour.h
===================================================================
--- linux-2.6.orig/include/net/neighbour.h	2009-06-03 16:23:29.000000000 -0500
+++ linux-2.6/include/net/neighbour.h	2009-06-03 16:36:23.000000000 -0500
@@ -89,12 +89,7 @@ struct neigh_statistics
 	unsigned long unres_discards;	/* number of unresolved drops */
 };
 
-#define NEIGH_CACHE_STAT_INC(tbl, field)				\
-	do {								\
-		preempt_disable();					\
-		(per_cpu_ptr((tbl)->stats, smp_processor_id())->field)++; \
-		preempt_enable();					\
-	} while (0)
+#define NEIGH_CACHE_STAT_INC(tbl, field) this_cpu_inc((tbl)->stats->field)
 
 struct neighbour
 {
Index: linux-2.6/include/net/netfilter/nf_conntrack.h
===================================================================
--- linux-2.6.orig/include/net/netfilter/nf_conntrack.h	2009-06-03 16:23:29.000000000 -0500
+++ linux-2.6/include/net/netfilter/nf_conntrack.h	2009-06-03 16:37:17.000000000 -0500
@@ -291,14 +291,9 @@ extern int nf_conntrack_set_hashsize(con
 extern unsigned int nf_conntrack_htable_size;
 extern unsigned int nf_conntrack_max;
 
-#define NF_CT_STAT_INC(net, count)	\
-	(per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++)
+#define NF_CT_STAT_INC(net, count) __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count)		\
-do {							\
-	local_bh_disable();				\
-	per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++;	\
-	local_bh_enable();				\
-} while (0)
+	this_cpu_inc((net)->ct.stat->count)
 
 #define MODULE_ALIAS_NFCT_HELPER(helper) \
         MODULE_ALIAS("nfct-helper-" helper)

-- 
