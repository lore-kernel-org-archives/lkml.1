Return-Path: <linux-kernel-owner+w=401wt.eu-S932485AbXBWLPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbXBWLPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbXBWLPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:15:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33205 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbXBWLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:15:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 02/14] irq: Remove set_native_irq_info
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:13:55 -0700
In-Reply-To: <m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:11:56 -0700")
Message-ID: <m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch replaces all instances of "set_native_irq_info(irq, mask)"
with "irq_desc[irq].affinity = mask".  The latter form is clearer
uses fewer abstractions, and makes access to this field uniform
accross different architectures.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/io_apic.c   |   10 +++++-----
 arch/ia64/kernel/msi_ia64.c  |    2 +-
 arch/ia64/sn/kernel/msi_sn.c |    2 +-
 arch/x86_64/kernel/io_apic.c |   10 +++++-----
 include/linux/irq.h          |   11 -----------
 5 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 4ccebd4..6fec4da 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -343,7 +343,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
 			break;
 		entry = irq_2_pin + entry->next;
 	}
-	set_native_irq_info(irq, cpumask);
+	irq_desc[irq].affinity = cpumask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -1354,7 +1354,7 @@ static void __init setup_IO_APIC_irqs(void)
 		}
 		spin_lock_irqsave(&ioapic_lock, flags);
 		__ioapic_write_entry(apic, pin, entry);
-		set_native_irq_info(irq, TARGET_CPUS);
+		irq_desc[irq].affinity = TARGET_CPUS;
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 	}
@@ -2585,7 +2585,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	set_native_irq_info(irq, mask);
+	irq_desc[irq].affinity = mask;
 }
 #endif /* CONFIG_SMP */
 
@@ -2669,7 +2669,7 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	dest = cpu_mask_to_apicid(mask);
 
 	target_ht_irq(irq, dest);
-	set_native_irq_info(irq, mask);
+	irq_desc[irq].affinity = mask;
 }
 #endif
 
@@ -2875,7 +2875,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int a
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__ioapic_write_entry(ioapic, pin, entry);
-	set_native_irq_info(irq, TARGET_CPUS);
+	irq_desc[irq].affinity = TARGET_CPUS;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return 0;
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 0d05450..e722090 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -60,7 +60,7 @@ static void ia64_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 	msg.address_lo = addr;
 
 	write_msi_msg(irq, &msg);
-	set_native_irq_info(irq, cpu_mask);
+	irq_desc[irq].affinity = cpu_mask;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index ea3dc38..49873aa 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -204,7 +204,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	set_native_irq_info(irq, cpu_mask);
+	irq_desc[irq].affinity = cpu_mask;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 357b354..1847213 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -261,7 +261,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, vector);
-	set_native_irq_info(irq, mask);
+	irq_desc[irq].affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 #endif
@@ -857,7 +857,7 @@ static void __init setup_IO_APIC_irq(int apic, int pin, int idx, int irq)
 	ioapic_write_entry(apic, pin, entry);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	set_native_irq_info(irq, TARGET_CPUS);
+	irq_desc[irq].affinity = TARGET_CPUS;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 }
@@ -1930,7 +1930,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	set_native_irq_info(irq, mask);
+	irq_desc[irq].affinity = mask;
 }
 #endif /* CONFIG_SMP */
 
@@ -2018,7 +2018,7 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, vector);
-	set_native_irq_info(irq, mask);
+	irq_desc[irq].affinity = mask;
 }
 #endif
 
@@ -2143,7 +2143,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 	ioapic_write_entry(ioapic, pin, entry);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	set_native_irq_info(irq, TARGET_CPUS);
+	irq_desc[irq].affinity = TARGET_CPUS;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return 0;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index aa5b3e6..b0a44b8 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -200,17 +200,6 @@ extern int setup_irq(unsigned int irq, struct irqaction *new);
 #endif
 
 #ifdef CONFIG_SMP
-static inline void set_native_irq_info(int irq, cpumask_t mask)
-{
-	irq_desc[irq].affinity = mask;
-}
-#else
-static inline void set_native_irq_info(int irq, cpumask_t mask)
-{
-}
-#endif
-
-#ifdef CONFIG_SMP
 
 #if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
 
-- 
1.5.0.g53756

