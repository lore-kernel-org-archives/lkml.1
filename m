Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbZAHSk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbZAHSk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZAHSkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:40:49 -0500
Received: from relay2.sgi.com ([192.48.179.30]:59179 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754816AbZAHSkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:40:49 -0500
Message-ID: <496648AC.4000409@sgi.com>
Date: Thu, 08 Jan 2009 10:40:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cpumask: update irq_desc to use cpumask_var_t: fix
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>	 <20090107195832.465094000@polaris-admin.engr.sgi.com> <86802c440901071227n2d110757ye1bd12e689502ebc@mail.gmail.com> <49652D92.8020105@sgi.com> <49656FCF.9090602@kernel.org>
In-Reply-To: <49656FCF.9090602@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
...
> static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
>                  struct irq_desc *desc, int cpu)
> {
>         memcpy(desc, old_desc, sizeof(struct irq_desc));
> 
> 
> will overwrite new_desc->affinity and pending_mask
> 
> YH

I've appended this to the patchset:

Subject: cpumask: fix bug in use cpumask_var_t in irq_desc

Impact: fix bug where new irq_desc uses old cpumask pointers which are freed.

As Yinghai pointed out, init_copy_one_irq_desc() copies the old desc to
the new desc overwriting the cpumask pointers.  Since the old_desc and
the cpumask pointers are freed, then memory corruption will occur if
these old pointers are used.

Move the allocation of these pointers to after the copy.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/irq.h       |    9 +++++++--
 kernel/irq/handle.c       |    8 +-------
 kernel/irq/numa_migrate.c |   13 ++++++++-----
 3 files changed, 16 insertions(+), 14 deletions(-)

--- linux-2.6-for-ingo.orig/include/linux/irq.h
+++ linux-2.6-for-ingo/include/linux/irq.h
@@ -426,15 +426,18 @@ extern int set_irq_msi(unsigned int irq,
 /**
  * init_alloc_desc_masks - allocate cpumasks for irq_desc
  * @desc:	pointer to irq_desc struct
+ * @cpu:	cpu which will be handling the cpumasks
  * @boot:	true if need bootmem
  *
  * Allocates affinity and pending_mask cpumask if required.
  * Returns true if successful (or not required).
  * Side effect: affinity has all bits set, pending_mask has all bits clear.
  */
-static inline bool init_alloc_desc_masks(struct irq_desc *desc, int node,
+static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
 								bool boot)
 {
+	int node;
+
 	if (boot) {
 		alloc_bootmem_cpumask_var(&desc->affinity);
 		cpumask_setall(desc->affinity);
@@ -446,6 +449,8 @@ static inline bool init_alloc_desc_masks
 		return true;
 	}
 
+	node = cpu_to_node(cpu);
+
 	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
 		return false;
 	cpumask_setall(desc->affinity);
@@ -484,7 +489,7 @@ static inline void init_copy_desc_masks(
 
 #else /* !CONFIG_SMP */
 
-static inline bool init_alloc_desc_masks(struct irq_desc *desc, int node,
+static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
 								bool boot)
 {
 	return true;
--- linux-2.6-for-ingo.orig/kernel/irq/handle.c
+++ linux-2.6-for-ingo/kernel/irq/handle.c
@@ -85,8 +85,6 @@ void init_kstat_irqs(struct irq_desc *de
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
 {
-	int node = cpu_to_node(cpu);
-
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
 	spin_lock_init(&desc->lock);
@@ -100,7 +98,7 @@ static void init_one_irq_desc(int irq, s
 		printk(KERN_ERR "can not alloc kstat_irqs\n");
 		BUG_ON(1);
 	}
-	if (!init_alloc_desc_masks(desc, node, false)) {
+	if (!init_alloc_desc_masks(desc, cpu, false)) {
 		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
 		BUG_ON(1);
 	}
@@ -188,10 +186,6 @@ struct irq_desc *irq_to_desc_alloc_cpu(u
 		printk(KERN_ERR "can not alloc irq_desc\n");
 		BUG_ON(1);
 	}
-	if (!init_alloc_desc_masks(desc, node, false)) {
-		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
-		BUG_ON(1);
-	}
 	init_one_irq_desc(irq, desc, cpu);
 
 	irq_desc_ptrs[irq] = desc;
--- linux-2.6-for-ingo.orig/kernel/irq/numa_migrate.c
+++ linux-2.6-for-ingo/kernel/irq/numa_migrate.c
@@ -38,16 +38,22 @@ static void free_kstat_irqs(struct irq_d
 	old_desc->kstat_irqs = NULL;
 }
 
-static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
+static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
 		 struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, old_desc, sizeof(struct irq_desc));
+	if (!init_alloc_desc_masks(desc, cpu, false)) {
+		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
+				"for migration.\n", irq);
+		return false;
+	}
 	spin_lock_init(&desc->lock);
 	desc->cpu = cpu;
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
 	init_copy_desc_masks(old_desc, desc);
 	arch_init_copy_chip_data(old_desc, desc, cpu);
+	return true;
 }
 
 static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
@@ -83,15 +89,12 @@ static struct irq_desc *__real_move_irq_
 		desc = old_desc;
 		goto out_unlock;
 	}
-	if (!init_alloc_desc_masks(desc, node, false)) {
-		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
-				"for migration.\n", irq);
+	if (!init_copy_one_irq_desc(irq, old_desc, desc, cpu)) {
 		/* still use old one */
 		kfree(desc);
 		desc = old_desc;
 		goto out_unlock;
 	}
-	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
 
 	irq_desc_ptrs[irq] = desc;
 

