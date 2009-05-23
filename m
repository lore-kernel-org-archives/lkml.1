Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZEWM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZEWM7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 08:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZEWM7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 08:59:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:34412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbZEWM7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 08:59:07 -0400
Date: Sat, 23 May 2009 12:57:52 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, mel@csn.ul.ie, lethal@linux-sh.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, mel@csn.ul.ie, lethal@linux-sh.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090522014008.GA2806@linux-sh.org>
References: <20090522014008.GA2806@linux-sh.org>
Subject: [tip:irq/numa] sparseirq: Allow early irq_desc allocation
Message-ID: <tip-948cd52906baf1f92aeea2f9b5c515db1b2e592a@git.kernel.org>
Git-Commit-ID: 948cd52906baf1f92aeea2f9b5c515db1b2e592a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 23 May 2009 12:57:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  948cd52906baf1f92aeea2f9b5c515db1b2e592a
Gitweb:     http://git.kernel.org/tip/948cd52906baf1f92aeea2f9b5c515db1b2e592a
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Fri, 22 May 2009 10:40:09 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 May 2009 14:55:24 +0200

sparseirq: Allow early irq_desc allocation

Presently non-legacy IRQs have their irq_desc allocated with
kzalloc_node(). This assumes that all callers of irq_to_desc_node_alloc()
will be sufficiently late in the boot process that kmalloc is available.

While porting sparseirq support to sh this blew up immediately, as at the
time that we register the CPU's interrupt vector map only bootmem is
available. Check slab_is_available() to work out which path to use.

[ Impact: fix SH early boot crash with sparseirq enabled ]

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
LKML-Reference: <20090522014008.GA2806@linux-sh.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/handle.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index a3c671e..18041a2 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
@@ -81,11 +82,16 @@ static struct irq_desc irq_desc_init = {
 	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 };
 
-void init_kstat_irqs(struct irq_desc *desc, int node, int nr)
+void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 {
 	void *ptr;
 
-	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
+	if (slab_is_available())
+		ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
+				   GFP_ATOMIC, node);
+	else
+		ptr = alloc_bootmem_node(NODE_DATA(node),
+				nr * sizeof(*desc->kstat_irqs));
 
 	/*
 	 * don't overwite if can not get new one
@@ -186,7 +192,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
+struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -208,7 +214,11 @@ struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
 	if (desc)
 		goto out_unlock;
 
-	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	if (slab_is_available())
+		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	else
+		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
+
 	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
 		printk(KERN_ERR "can not alloc irq_desc\n");
