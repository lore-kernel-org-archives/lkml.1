Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZEUQ5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZEUQ5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZEUQ4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:56:55 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55207 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZEUQ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:56:54 -0400
Date: Fri, 22 May 2009 01:56:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sparseirq: Enable early irq_desc allocation.
Message-ID: <20090521165647.GA320@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presently non-legacy IRQs have their irq_desc allocated with
kzalloc_node(). This assumes that all callers of irq_to_desc_cpu_alloc()
will be sufficiently late in the boot process that kmalloc is available.

While porting sparseirq support to sh this blew up immediately, as at the
time that we register the CPU's interrupt vector map only bootmem is
available.

This adds in a simple after_bootmem check to see where the allocation
needs to come from, which is likewise provided by all of the platforms
that support sparse irq today. :-)

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 kernel/irq/handle.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index d82142b..5fb3a5c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -19,7 +19,7 @@
 #include <linux/hash.h>
 #include <trace/irq.h>
 #include <linux/bootmem.h>
-
+#include <linux/mm.h>
 #include "internals.h"
 
 /*
@@ -81,13 +81,17 @@ static struct irq_desc irq_desc_init = {
 	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 };
 
-void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
+void __ref init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
 {
 	int node;
 	void *ptr;
 
 	node = cpu_to_node(cpu);
-	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
+	if (after_bootmem)
+		ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
+	else
+		ptr = alloc_bootmem_node(NODE_DATA(node),
+				nr * sizeof(*desc->kstat_irqs));
 
 	/*
 	 * don't overwite if can not get new one
@@ -187,7 +191,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+struct irq_desc * __ref irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -211,7 +215,10 @@ struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
 		goto out_unlock;
 
 	node = cpu_to_node(cpu);
-	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	if (after_bootmem)
+		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	else
+		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
 	printk(KERN_DEBUG "  alloc irq_desc for %d on cpu %d node %d\n",
 		 irq, cpu, node);
 	if (!desc) {
