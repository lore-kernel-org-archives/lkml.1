Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZGLMGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZGLMGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 08:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZGLMGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 08:06:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37708 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZGLMGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 08:06:15 -0400
Date: Sun, 12 Jul 2009 15:06:04 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: [PATCH] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090712120604.GA28046@redhat.com>
References: <20090701133007.GC27539@redhat.com> <1246482017.27006.10670.camel@localhost.localdomain> <20090703082905.GF21833@elte.hu> <20090705143254.GJ881@redhat.com> <20090710135618.GC26264@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710135618.GC26264@elte.hu>
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
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

This is based on x86 tree commit 5b9eea3e7 with checkpatch complains
fixed.

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0a1c283..6e67916 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -49,6 +49,7 @@
 #include <asm/mtrr.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
+#include <asm/kvm_para.h>
 
 unsigned int num_processors;
 
@@ -1361,52 +1362,74 @@ void enable_x2apic(void)
 }
 #endif /* CONFIG_X86_X2APIC */
 
-void __init enable_IR_x2apic(void)
+int __init enable_IR(void)
 {
 #ifdef CONFIG_INTR_REMAP
 	int ret;
-	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	ret = dmar_table_init();
 	if (ret) {
 		pr_debug("dmar_table_init() failed with %d:\n", ret);
-		goto ir_failed;
+		return 0;
 	}
 
 	if (!intr_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
-		goto ir_failed;
+		return 0;
 	}
 
-
 	if (!x2apic_preenabled && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
-		return;
+		return 0;
 	}
 
+	if (enable_intr_remapping(x2apic_supported()))
+		return 0;
+
+	pr_info("Enabled Interrupt-remapping\n");
+
+	return 1;
+
+#endif
+	return 0;
+}
+
+void __init enable_IR_x2apic(void)
+{
+	unsigned long flags;
+	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	int ret, x2apic_enabled = 0;
+
 	ioapic_entries = alloc_ioapic_entries();
 	if (!ioapic_entries) {
-		pr_info("Allocate ioapic_entries failed: %d\n", ret);
-		goto end;
+		pr_info("Allocate ioapic_entries failed\n");
+		goto out;
 	}
 
 	ret = save_IO_APIC_setup(ioapic_entries);
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto end;
+		goto out;
 	}
 
 	local_irq_save(flags);
-	mask_IO_APIC_setup(ioapic_entries);
 	mask_8259A();
+	mask_IO_APIC_setup(ioapic_entries);
 
-	ret = enable_intr_remapping(x2apic_supported());
-	if (ret)
-		goto end_restore;
+	ret = enable_IR();
+	if (!ret) {
+		/* IR is required if x2apic is enabled by BIOS even
+		 * when running in kvm since this indicates present
+		 * of APIC ID > 255 */
+		if (max_physical_apicid > 255 || !kvm_para_available())
+			goto nox2apic;
+		/* without IR all CPUs can be addressed by IOAPIC/MSI
+		 * only in physical mode */
+		x2apic_phys = 1;
+	}
 
-	pr_info("Enabled Interrupt-remapping\n");
+	x2apic_enabled = 1;
 
 	if (x2apic_supported() && !x2apic_mode) {
 		x2apic_mode = 1;
@@ -1414,41 +1437,30 @@ void __init enable_IR_x2apic(void)
 		pr_info("Enabled x2apic\n");
 	}
 
-end_restore:
-	if (ret)
-		/*
-		 * IR enabling failed
-		 */
+nox2apic:
+	if (!ret) /* IR enabling failed */
 		restore_IO_APIC_setup(ioapic_entries);
-
 	unmask_8259A();
 	local_irq_restore(flags);
 
-end:
+out:
 	if (ioapic_entries)
 		free_ioapic_entries(ioapic_entries);
 
-	if (!ret)
+	if (x2apic_enabled)
 		return;
 
-ir_failed:
-	if (x2apic_preenabled)
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
-		      " enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
+				" enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
 #endif
-
-	return;
+	} else if (cpu_has_x2apic)
+		pr_info("Not enabling x2apic,Intr-remapping\n");
 }
 
-
 #ifdef CONFIG_X86_64
 /*
  * Detect and enable local APICs on non-SMP boards.
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index bc3e880..f3b1037 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -50,11 +50,11 @@ static struct apic *apic_probe[] __initdata = {
 void __init default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_X2APIC
-	if (x2apic_mode && (apic != &apic_x2apic_phys &&
+	if (x2apic_mode
 #ifdef CONFIG_X86_UV
-		       apic != &apic_x2apic_uv_x &&
+		       && apic != &apic_x2apic_uv_x
 #endif
-		       apic != &apic_x2apic_cluster)) {
+		       ) {
 		if (x2apic_phys)
 			apic = &apic_x2apic_phys;
 		else
--
			Gleb.
