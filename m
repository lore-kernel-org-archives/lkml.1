Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYHXJJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYHXJJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYHXJD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:51456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbYHXJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AGm4ecM4nIeM7wbsbkgGdM5qy3vdYQnrhdOeys7Uw+05E3/ge2tXSujz5xvYbA9jOQ
         x1vmSRMnKfsGQV2a3aLgPFs3xszhqHOuC0Y4F9h2pdqRlUS4datL7j9o/Vo7WzBHoO+W
         rRpk1aCBbbVtVM7Wr88SXKAXDIvHdWR5lD7Nw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 17/18] x86: apic copy apic_64.c to apic_32.c
Date: Sun, 24 Aug 2008 02:01:55 -0700
Message-Id: <1219568516-681-18-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |  188 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 188 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index b21b772..6e99af5 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -90,6 +90,24 @@ static __init int setup_apicpmtimer(char *s)
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
+#ifdef CONFIG_X86_64
+#define HAVE_X2APIC
+#endif
+
+#ifdef HAVE_X2APIC
+int x2apic;
+/* x2apic enabled before OS handover */
+int x2apic_preenabled;
+int disable_x2apic;
+static __init int setup_nox2apic(char *str)
+{
+	disable_x2apic = 1;
+	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+	return 0;
+}
+early_param("nox2apic", setup_nox2apic);
+#endif
+
 unsigned long mp_lapic_addr;
 int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
@@ -231,6 +249,42 @@ static struct apic_ops xapic_ops = {
 struct apic_ops __read_mostly *apic_ops = &xapic_ops;
 EXPORT_SYMBOL_GPL(apic_ops);
 
+#ifdef HAVE_X2APIC
+static void x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return;
+}
+
+static u32 safe_x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return 0;
+}
+
+void x2apic_icr_write(u32 low, u32 id)
+{
+	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
+}
+
+u64 x2apic_icr_read(void)
+{
+	unsigned long val;
+
+	rdmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), val);
+	return val;
+}
+
+static struct apic_ops x2apic_ops = {
+	.read = native_apic_msr_read,
+	.write = native_apic_msr_write,
+	.icr_read = x2apic_icr_read,
+	.icr_write = x2apic_icr_write,
+	.wait_icr_idle = x2apic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_x2apic_wait_icr_idle,
+};
+#endif
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
@@ -1308,6 +1362,127 @@ void __cpuinit end_local_APIC_setup(void)
 	apic_pm_activate();
 }
 
+#ifdef HAVE_X2APIC
+void check_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+
+	if (msr & X2APIC_ENABLE) {
+		printk("x2apic enabled by BIOS, switching to x2apic ops\n");
+		x2apic_preenabled = x2apic = 1;
+		apic_ops = &x2apic_ops;
+	}
+}
+
+void enable_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (!(msr & X2APIC_ENABLE)) {
+		printk("Enabling x2apic\n");
+		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
+	}
+}
+
+void enable_IR_x2apic(void)
+{
+#ifdef CONFIG_INTR_REMAP
+	int ret;
+	unsigned long flags;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	if (!x2apic_preenabled && disable_x2apic) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of nox2apic\n");
+		return;
+	}
+
+	if (x2apic_preenabled && disable_x2apic)
+		panic("Bios already enabled x2apic, can't enforce nox2apic");
+
+	if (!x2apic_preenabled && skip_ioapic_setup) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of skipping io-apic setup\n");
+		return;
+	}
+
+	ret = dmar_table_init();
+	if (ret) {
+		printk(KERN_INFO
+		       "dmar_table_init() failed with %d:\n", ret);
+
+		if (x2apic_preenabled)
+			panic("x2apic enabled by bios. But IR enabling failed");
+		else
+			printk(KERN_INFO
+			       "Not enabling x2apic,Intr-remapping\n");
+		return;
+	}
+
+	local_irq_save(flags);
+	mask_8259A();
+	save_mask_IO_APIC_setup();
+
+	ret = enable_intr_remapping(1);
+
+	if (ret && x2apic_preenabled) {
+		local_irq_restore(flags);
+		panic("x2apic enabled by bios. But IR enabling failed");
+	}
+
+	if (ret)
+		goto end;
+
+	if (!x2apic) {
+		x2apic = 1;
+		apic_ops = &x2apic_ops;
+		enable_x2apic();
+	}
+end:
+	if (ret)
+		/*
+		 * IR enabling failed
+		 */
+		restore_IO_APIC_setup();
+	else
+		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
+
+	unmask_8259A();
+	local_irq_restore(flags);
+
+	if (!ret) {
+		if (!x2apic_preenabled)
+			printk(KERN_INFO
+			       "Enabled x2apic and interrupt-remapping\n");
+		else
+			printk(KERN_INFO
+			       "Enabled Interrupt-remapping\n");
+	} else
+		printk(KERN_ERR
+		       "Failed to enable Interrupt-remapping and x2apic\n");
+#else
+	if (!cpu_has_x2apic)
+		return;
+
+	if (x2apic_preenabled)
+		panic("x2apic enabled prior OS handover,"
+		      " enable CONFIG_INTR_REMAP");
+
+	printk(KERN_INFO "Enable CONFIG_INTR_REMAP for enabling intr-remapping "
+	       " and x2apic\n");
+#endif
+
+	return;
+}
+#endif /* HAVE_X2APIC */
+
 #ifdef CONFIG_X86_64
 /*
  * Detect and enable local APICs on non-SMP boards.
@@ -1438,6 +1613,13 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
+#ifdef HAVE_X2APIC
+	if (x2apic) {
+		boot_cpu_physical_apicid = read_apic_id();
+		return;
+	}
+#endif
+
 	/*
 	 * If no local APIC can be found then set up a fake all
 	 * zeroes page to simulate the local APIC and another
@@ -1501,6 +1683,7 @@ int __init APIC_init_uniprocessor(void)
 #ifdef CONFIG_X86_64
 	setup_apic_routing();
 #endif
+
 	verify_local_APIC();
 	connect_bsp_APIC();
 
@@ -1879,6 +2062,11 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_save(flags);
 
+#ifdef HAVE_X2APIC
+	if (x2apic)
+		enable_x2apic();
+	else
+#endif
 	{
 		/*
 		 * Make sure the APICBASE points to the right address
-- 
1.5.4.5

