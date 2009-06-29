Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbZF2KIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbZF2KIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZF2KIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:08:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52467 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZF2KIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:08:36 -0400
Date: Mon, 29 Jun 2009 13:08:37 +0300
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sheng Yang <sheng@linux.intel.com>, kvm@vger.kernel.org, avi@redhat.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: [PATCH v2] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090629100837.GW20289@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM would like to provide x2APIC interface to a guest without emulating
interrupt remapping device. The reason KVM prefers guest to use x2APIC
is that x2APIC interface is better virtualizable and provides better
performance than mmio xAPIC interface:

- msr exits are faster than mmio (no page table walk, emulation)
- no need to read back ICR to look at the busy bit
- one 64 bit ICR write instead of two 32 bit writes
- shared code with the Hyper-V paravirt interface

Included patch changes x2APIC enabling logic to enable it even if IR
initialization failed, but kernel runs under KVM and no apic id is
greater than 255 (if there is one spec requires BIOS to move to x2apic
mode before starting an OS).

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---

v2:
  Add help message to Kconfig
  Force physical mode if IR is not available.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d1430ef..3e5b6ea 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -260,12 +260,15 @@ config SMP
 
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
+	depends on X86_LOCAL_APIC && X86_64
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
 	  This allows 32-bit apic IDs (so it can support very large systems),
-	  and accesses the local apic via MSRs not via mmio.
+	  and accesses the local apic via MSRs not via mmio. CONFIG_INTR_REMAP
+	  is required for x2apic to take affect when running on physical
+	  machine. If you intend to run the kernel as KVM guest x2apic can
+	  be used without interrupt remapping.
 
 	  If you don't know what to do here, say N.
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8c7c042..19d97ae 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -49,6 +49,7 @@
 #include <asm/mtrr.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
+#include <asm/kvm_para.h>
 
 unsigned int num_processors;
 
@@ -1363,11 +1364,10 @@ void enable_x2apic(void)
 }
 #endif /* CONFIG_X86_X2APIC */
 
-void __init enable_IR_x2apic(void)
+int __init enable_IR(void)
 {
 #ifdef CONFIG_INTR_REMAP
 	int ret;
-	unsigned long flags;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	ret = dmar_table_init();
@@ -1381,11 +1381,10 @@ void __init enable_IR_x2apic(void)
 		goto ir_failed;
 	}
 
-
 	if (!x2apic_preenabled && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
-		return;
+		goto ir_failed;
 	}
 
 	ioapic_entries = alloc_ioapic_entries();
@@ -1400,9 +1399,7 @@ void __init enable_IR_x2apic(void)
 		goto end;
 	}
 
-	local_irq_save(flags);
 	mask_IO_APIC_setup(ioapic_entries);
-	mask_8259A();
 
 	ret = enable_intr_remapping(x2apic_supported());
 	if (ret)
@@ -1410,12 +1407,7 @@ void __init enable_IR_x2apic(void)
 
 	pr_info("Enabled Interrupt-remapping\n");
 
-	if (x2apic_supported() && !x2apic_mode) {
-		x2apic_mode = 1;
-		enable_x2apic();
-		pr_info("Enabled x2apic\n");
-	}
-
+	return 1;
 end_restore:
 	if (ret)
 		/*
@@ -1423,30 +1415,57 @@ end_restore:
 		 */
 		restore_IO_APIC_setup(ioapic_entries);
 
-	unmask_8259A();
-	local_irq_restore(flags);
-
 end:
 	if (ioapic_entries)
 		free_ioapic_entries(ioapic_entries);
 
-	if (!ret)
-		return;
-
 ir_failed:
-	if (x2apic_preenabled)
+#endif
+	return 0;
+}
+
+void __init enable_IR_x2apic(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	mask_8259A();
+
+	if (!enable_IR()) {
+		/* IR is required if x2apic is enabled by BIOS even
+		 * when running in kvm since this indicates present
+		 * of APIC ID > 255 */
+	       	if (x2apic_preenabled || !kvm_para_available())
+			goto nox2apic;
+		else
+			/* without IR all CPUs can be addressed by IOAPIC/MSI
+			 * only in physical mode */
+			x2apic_phys = 1;
+	}
+
+	if (x2apic_supported() && !x2apic_mode) {
+		x2apic_mode = 1;
+		enable_x2apic();
+		pr_info("Enabled x2apic\n");
+	}
+
+	unmask_8259A();
+	local_irq_restore(flags);
+	return;
+
+nox2apic:
+	unmask_8259A();
+	local_irq_restore(flags);
+
+	if (x2apic_preenabled) {
+#ifdef CONFIG_INTR_REMAP
 		panic("x2apic enabled by bios. But IR enabling failed");
-	else if (cpu_has_x2apic)
-		pr_info("Not enabling x2apic,Intr-remapping\n");
 #else
-	if (!cpu_has_x2apic)
-		return;
-
-	if (x2apic_preenabled)
 		panic("x2apic enabled prior OS handover,"
 		      " enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
 #endif
-
+	} else if (cpu_has_x2apic)
+		pr_info("Not enabling x2apic,Intr-remapping\n");
 	return;
 }
 
--
			Gleb.
