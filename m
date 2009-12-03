Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZLCBOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZLCBOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZLCBOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:14:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:52569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZLCBOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:14:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,331,1257148800"; 
   d="scan'208";a="575155193"
Subject: Re: [RFC][PATCH] Setting /proc/irq/[n]/smp_affinity failure on 8
 cpu systems
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: John Blackwood <john.blackwood@ccur.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B169397.5020609@ccur.com>
References: <4B169397.5020609@ccur.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 02 Dec 2009 17:13:23 -0800
Message-Id: <1259802804.2652.58.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 08:19 -0800, John Blackwood wrote:
> I would like to mention an irq set affinity issue occurs on an
> older Dell PowerEdge 6650 system:
>     - 8 cpus (4 are hyper-threaded),
>     - uses the struct apic 'apic_default' support
>     - 32 bit (x86) kernel
> 
> This issue is that once you change the irq smp_affinity of an irq
> to be less than all cpus in the system, you can never change really
> the
> irq smp_affinity back to be all cpus in the system (0xff) again,
> even though no error status is returned on the "/bin/echo ff >
> /proc/irq/[n]/smp_affinity" operation.
> 
> This is due to that fact that BAD_APICID has the same value as
> all cpus (0xff) on 32bit kernels, and thus the value returned from
> set_desc_affinity() via the cpu_mask_to_apicid_and() function is
> treated
> as a failure in set_ioapic_affinity_irq_desc(), and no affinity
> changes
> are made.
> 
> It seems like changing the BAD_APICID value from 0xFF to 0xFFFF for
> CONFIG_X86_32 might be one possible solution, and it seems to function
> properly for this Dell PowerEdge 6650 system.

John, Thanks for the root cause and analysis. As you noticed, 0xff is a
valid logical apicid. Similarly 0xffff is a valid logical x2apic cluster
id. So while your patch fixes your issue, it doesn't completely fix the
issue. Can you please check if the appended patch works and ack if it
passes your test?

thanks,
suresh
---

Subject: x86, irq: allow 0xff for /proc/irq/[n]/smp_affinity on a 8 cpu system

John Blackwood reported:
> on an older Dell PowerEdge 6650 system with 8 cpus (4 are hyper-threaded),
> and  32 bit (x86) kernel, once you change the irq smp_affinity of an irq
> to be less than all cpus in the system, you can never change really the
> irq smp_affinity back to be all cpus in the system (0xff) again,
> even though no error status is returned on the "/bin/echo ff >
> /proc/irq/[n]/smp_affinity" operation.
>
> This is due to that fact that BAD_APICID has the same value as
> all cpus (0xff) on 32bit kernels, and thus the value returned from
> set_desc_affinity() via the cpu_mask_to_apicid_and() function is treated
> as a failure in set_ioapic_affinity_irq_desc(), and no affinity changes
> are made.

set_desc_affinity() is already checking if the incoming cpu mask
intersects with the cpu online mask or not. So there is no need
for the apic op cpu_mask_to_apicid_and() to check again
and return BAD_APICID.

Remove the BAD_APICID return value from cpu_mask_to_apicid_and()
and also fix set_desc_affinity() to return -1 instead of using BAD_APICID
to represent error conditions (as cpu_mask_to_apicid_and() can return
logical or physical apicid values and BAD_APICID is really to represent
bad physical apic id).

Reported-by: John Blackwood <john.blackwood@ccur.com>
Root-caused-by: John Blackwood <john.blackwood@ccur.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/apic_flat_64.c   |    5 +----
 arch/x86/kernel/apic/bigsmp_32.c      |    5 +----
 arch/x86/kernel/apic/io_apic.c        |   32 ++++++++++++++------------------
 arch/x86/kernel/apic/x2apic_cluster.c |    5 +----
 arch/x86/kernel/apic/x2apic_phys.c    |    5 +----
 arch/x86/kernel/apic/x2apic_uv_x.c    |    5 +----
 6 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index d0c99ab..eacbd2b 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -306,10 +306,7 @@ physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
 struct apic apic_physflat =  {
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 38dcecf..cb804c5 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -131,10 +131,7 @@ static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	if (cpu < nr_cpu_ids)
-		return bigsmp_cpu_to_logical_apicid(cpu);
-
-	return BAD_APICID;
+	return bigsmp_cpu_to_logical_apicid(cpu);
 }
 
 static int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5d498f..98ced70 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2276,26 +2276,28 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 
 /*
  * Either sets desc->affinity to a valid value, and returns
- * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
+ * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
  * leaves desc->affinity untouched.
  */
 unsigned int
-set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
+set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
+		  unsigned int *dest_id)
 {
 	struct irq_cfg *cfg;
 	unsigned int irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
-		return BAD_APICID;
+		return -1;
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
 	if (assign_irq_vector(irq, cfg, mask))
-		return BAD_APICID;
+		return -1;
 
 	cpumask_copy(desc->affinity, mask);
 
-	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+	*dest_id = apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+	return 0;
 }
 
 static int
@@ -2311,12 +2313,11 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	cfg = desc->chip_data;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	dest = set_desc_affinity(desc, mask);
-	if (dest != BAD_APICID) {
+	ret = set_desc_affinity(desc, mask, &dest);
+	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, cfg);
-		ret = 0;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -3351,8 +3352,7 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3384,8 +3384,7 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	if (get_irte(irq, &irte))
 		return -1;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	irte.vector = cfg->vector;
@@ -3567,8 +3566,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3623,8 +3621,7 @@ static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3730,8 +3727,7 @@ static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index a5371ec..cf69c59 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -148,10 +148,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_logical_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_logical_apicid, cpu);
 }
 
 static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index a8989aa..8972f38 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -146,10 +146,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
 static unsigned int x2apic_phys_get_apic_id(unsigned long x)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 03f3964..f7205cb 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -225,10 +225,7 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)


