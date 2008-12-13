Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYLMMEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYLMMEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 07:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYLMMDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 07:03:55 -0500
Received: from ozlabs.org ([203.10.76.45]:42561 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYLMMDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 07:03:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/4] x86: fix cpu_mask_to_apicid_and to include cpu_online_mask
Date: Sat, 13 Dec 2008 22:33:48 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <200812122136.34780.rusty@rustcorp.com.au> <49429332.8030105@sgi.com>
In-Reply-To: <49429332.8030105@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812132233.48858.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 December 2008 03:07:06 Mike Travis wrote:
> Rusty Russell wrote:
> > On Thursday 11 December 2008 21:58:08 Mike Travis wrote:
> >> Impact: fix potential problem.
> >>
> >> In determining the destination apicid, there are usually three cpumasks
> >> that are considered: the incoming cpumask arg, cfg->domain and the
> >> cpu_online_mask.  Since we are just introducing the cpu_mask_to_apicid_and
> >> function, make sure it includes the cpu_online_mask in it's evaluation.
> > 
> > Yerk.  Can we really "fail" cpu_mask_to_apicid_and with no repercussions?
> > And does it make sense to try to fix this there?
> 
> Fail?  The only failure is if there is not a cpu that satisfies the conjunction
> of the three masks, in which case it returns BAD_APICID.

That patch showed cpumask_alloc_var in some implementations of
cpu_mask_to_apicid_and.  This is bad.

> The old procedure was to:
> 
> function(..., cpumask_t mask)
> {
> 	cpumask_t tmp;
> 
> 	cpus_and(tmp, mask, cfg->domain);
> 	...
> 	cpus_and(tmp, tmp, cpu_online_map);
> 	dest = cpu_mask_to_apicid(tmp);
> 	...
> }
> 
> So making cpu_mask_to_apicid_and return:
> 
> 	dest = cpu_mask_to_apicid(mask1 & mask2 & cpu_online_mask);
> 
> maintains this compatibility.

But that was the purpose of x86:set_desc_affinity.patch.  It centralized
those conventions, and other than being a nice cleanup, it got that right.

See below.

Now, there are some places which call cpu_mask_to_apicid_and() and don't
include the online mask, but I checked: they were that way before.  Possibly
an existing bug?

Otherwise, it could be that setting the desc->affinity earlier (as this patch
does) has caused a problem.  Which of these code paths were you running?

Cheers,
Rusty.

===
x86: centralize common code for set_affinity variants.

Impact: cleanup, remove on-stack cpumasks

Everyone checks that a cpu is online, calls assign_irq_vector, and
also uses a temporary cpumask.

I *think* it's legal to set the desc->affinity in place in all cases,
so I avoid the temporary cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/io_apic.c |  112 ++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 76 deletions(-)

diff -r 07e2723b2a5d arch/x86/kernel/io_apic.c
--- a/arch/x86/kernel/io_apic.c	Tue Nov 18 11:20:08 2008 +1030
+++ b/arch/x86/kernel/io_apic.c	Tue Nov 18 11:40:35 2008 +1030
@@ -361,33 +361,38 @@
 
 static int assign_irq_vector(int irq, const struct cpumask *mask);
 
+/* Either sets desc->affinity to a valid value, and returns cpu_mask_to_apicid
+ * of that, or returns BAD_APICID and leaves desc->affinity untouched. */
+static unsigned int set_desc_affinity(unsigned irq, const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return BAD_APICID;
+
+	cfg = irq_cfg(irq);
+	if (assign_irq_vector(irq, mask))
+		return BAD_APICID;
+
+	desc = irq_to_desc(irq);
+	cpumask_and(&desc->affinity, to_cpumask(cfg->domain), mask);
+	return cpu_mask_to_apicid(&desc->affinity);
+}
+
 static void set_ioapic_affinity_irq(unsigned int irq,
 				    const struct cpumask *mask)
 {
-	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
-	cpumask_t tmp;
-	struct irq_desc *desc;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
-
-	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
-		return;
-
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
-	/*
-	 * Only the high 8 bits are valid.
-	 */
-	dest = SET_APIC_LOGICAL_ID(dest);
-
-	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__target_IO_APIC_irq(irq, dest, cfg->vector);
-	cpumask_copy(&desc->affinity, mask);
+	dest = set_desc_affinity(irq, mask);
+	if (dest != BAD_APICID) {
+		/* Only the high 8 bits are valid. */
+		dest = SET_APIC_LOGICAL_ID(dest);
+		__target_IO_APIC_irq(irq, dest, irq_cfg(irq)->vector);
+	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 #endif /* CONFIG_SMP */
@@ -3017,32 +3022,21 @@
 #ifdef CONFIG_SMP
 static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
-	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
-	struct irq_desc *desc;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	dest = set_desc_affinity(irq, mask);
+	if (dest == BAD_APICID)
 		return;
-
-	if (assign_irq_vector(irq, mask))
-		return;
-
-	cfg = irq_cfg(irq);
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
 
 	read_msi_msg(irq, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.data |= MSI_DATA_VECTOR(irq_cfg(irq)->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	desc = irq_to_desc(irq);
-	cpumask_copy(&desc->affinity, mask);
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -3055,23 +3049,17 @@
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp;
 	struct irte irte;
 	struct irq_desc *desc;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
 
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	dest = set_desc_affinity(irq, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = irq_cfg(irq);
-	cpumask_and(&tmp, to_cpumask(cfg->domain), mask);
-	dest = cpu_mask_to_apicid(&tmp);
-
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
 
@@ -3106,9 +3094,6 @@
 		}
 		cfg->move_in_progress = 0;
 	}
-
-	desc = irq_to_desc(irq);
-	cpumask_copy(&desc->affinity, mask);
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -3315,19 +3300,12 @@
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
-	struct irq_desc *desc;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
-
-	if (assign_irq_vector(irq, mask))
+	dest = set_desc_affinity(irq, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = irq_cfg(irq);
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
-
 	dmar_msi_read(irq, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
@@ -3336,8 +3314,6 @@
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
-	cpumask_copy(&desc->affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3373,20 +3349,14 @@
 static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
-
-	if (assign_irq_vector(irq, mask))
+	dest = set_desc_affinity(irq, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = irq_cfg(irq);
-	cpumask_and(&tmp, to_cpumask(cfg->domain), mask);
-	dest = cpu_mask_to_apicid(&tmp);
 
 	hpet_msi_read(irq, &msg);
 
@@ -3396,8 +3366,6 @@
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
-	cpumask_copy(&desc->affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3455,22 +3423,14 @@
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp;
-	struct irq_desc *desc;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
-
-	if (assign_irq_vector(irq, mask))
+	dest = set_desc_affinity(irq, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = irq_cfg(irq);
-	cpumask_and(&tmp, to_cpumask(cfg->domain), mask);
-	dest = cpu_mask_to_apicid(&tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	desc = irq_to_desc(irq);
-	cpumask_copy(&desc->affinity, mask);
 }
 #endif
 
