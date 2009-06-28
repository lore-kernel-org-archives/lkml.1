Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZF1MvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZF1MvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZF1MvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:51:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56503 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZF1MvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:51:13 -0400
Date: Sun, 28 Jun 2009 15:51:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org
Subject: [PATCH] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090628125114.GO20289@redhat.com>
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d1430ef..7438c5c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -260,7 +260,7 @@ config SMP
 
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
+	depends on X86_LOCAL_APIC && X86_64
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8c7c042..48a63b6 100644
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
@@ -1400,22 +1399,14 @@ void __init enable_IR_x2apic(void)
 		goto end;
 	}
 
-	local_irq_save(flags);
 	mask_IO_APIC_setup(ioapic_entries);
-	mask_8259A();
 
 	ret = enable_intr_remapping(x2apic_supported());
 	if (ret)
 		goto end_restore;
-
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
@@ -1423,30 +1414,50 @@ end_restore:
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
+	/* IR is required if x2apic is enabled by BIOS even when running in kvm
+	 * since this indicates present of APIC ID > 255 */
+	if (!enable_IR() && (x2apic_preenabled || !kvm_para_available()))
+		goto nox2apic;
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
