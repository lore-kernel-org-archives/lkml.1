Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZEVBk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZEVBk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 21:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZEVBkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 21:40:17 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42273 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZEVBkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 21:40:16 -0400
Date: Fri, 22 May 2009 10:40:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparseirq: Enable early irq_desc allocation.
Message-ID: <20090522014008.GA2806@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
References: <20090521165647.GA320@linux-sh.org> <4A15B8F2.9000804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A15B8F2.9000804@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 01:26:26PM -0700, Yinghai Lu wrote:
> can you check tip?
> we change _cpu to node already.
> 
> also only sh have after_bootmem now.
> arch/sh/mm/init.c:int after_bootmem = 0;
> arch/sh/mm/init.c:      after_bootmem = 1;
> arch/sh/mm/ioremap_64.c:        extern int after_bootmem;
> arch/sh/mm/ioremap_64.c:        if (after_bootmem) {
> include/linux/mm.h:extern int after_bootmem;
> 
> for x86 we have bootmem_state ...
> arch/x86/include/asm/page_types.h:enum bootmem_state {
> arch/x86/include/asm/page_types.h:extern enum bootmem_state bootmem_state;
> arch/x86/kernel/setup.c:        bootmem_state = DURING_BOOTMEM;
> arch/x86/mm/init.c:enum bootmem_state bootmem_state = BEFORE_BOOTMEM;
> arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
> arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
> arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM && !start) {
> arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM &&
> arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
> 
> Andrew,
> do we need to move bootmem_state back to linux/mm.h?

No need, I just switched to slab_is_available() in the respin. Here is
v2, against -tip:

--

sparseirq: Enable early irq_desc allocation, v2.

Presently non-legacy IRQs have their irq_desc allocated with
kzalloc_node(). This assumes that all callers of irq_to_desc_node_alloc()
will be sufficiently late in the boot process that kmalloc is available.

While porting sparseirq support to sh this blew up immediately, as at the
time that we register the CPU's interrupt vector map only bootmem is
available. Check slab_is_available() to work out which path to use.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 V2 updated for -tip, and switched to slab_is_available().

 kernel/irq/handle.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 33ff8f5..b5a47d6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -18,8 +18,8 @@
 #include <linux/rculist.h>
 #include <linux/hash.h>
 #include <linux/bootmem.h>
+#include <linux/slab.h>
 #include <trace/events/irq.h>
-
 #include "internals.h"
 
 /*
@@ -81,11 +81,16 @@ static struct irq_desc irq_desc_init = {
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
@@ -186,7 +191,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
+struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -208,7 +213,11 @@ struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
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
