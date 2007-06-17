Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbXFQJtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbXFQJtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbXFQJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:51 -0400
Received: from il.qumranet.com ([82.166.9.18]:55176 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758143AbXFQJon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 12/58] KVM: Fix potential guest state leak into host
Date: Sun, 17 Jun 2007 12:43:53 +0300
Message-Id: <11820734802892-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The lightweight vmexit path avoids saving and reloading certain host
state.  However in certain cases lightweight vmexit handling can schedule()
which requires reloading the host state.

So we store the host state in the vcpu structure, and reloaded it if we
relinquish the vcpu.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    5 ++
 drivers/kvm/vmx.c |  160 +++++++++++++++++++++++++++++-----------------------
 2 files changed, 94 insertions(+), 71 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index f6ee189..bb32383 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -306,6 +306,11 @@ struct kvm_vcpu {
 	char *guest_fx_image;
 	int fpu_active;
 	int guest_fpu_loaded;
+	struct vmx_host_state {
+		int loaded;
+		u16 fs_sel, gs_sel, ldt_sel;
+		int fs_gs_ldt_reload_needed;
+	} vmx_host_state;
 
 	int mmio_needed;
 	int mmio_read_completed;
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 49cadd3..677b38c 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -237,6 +237,93 @@ static void vmcs_set_bits(unsigned long field, u32 mask)
 	vmcs_writel(field, vmcs_readl(field) | mask);
 }
 
+static void reload_tss(void)
+{
+#ifndef CONFIG_X86_64
+
+	/*
+	 * VT restores TR but not its size.  Useless.
+	 */
+	struct descriptor_table gdt;
+	struct segment_descriptor *descs;
+
+	get_gdt(&gdt);
+	descs = (void *)gdt.base;
+	descs[GDT_ENTRY_TSS].type = 9; /* available TSS */
+	load_TR_desc();
+#endif
+}
+
+static void vmx_save_host_state(struct kvm_vcpu *vcpu)
+{
+	struct vmx_host_state *hs = &vcpu->vmx_host_state;
+
+	if (hs->loaded)
+		return;
+
+	hs->loaded = 1;
+	/*
+	 * Set host fs and gs selectors.  Unfortunately, 22.2.3 does not
+	 * allow segment selectors with cpl > 0 or ti == 1.
+	 */
+	hs->ldt_sel = read_ldt();
+	hs->fs_gs_ldt_reload_needed = hs->ldt_sel;
+	hs->fs_sel = read_fs();
+	if (!(hs->fs_sel & 7))
+		vmcs_write16(HOST_FS_SELECTOR, hs->fs_sel);
+	else {
+		vmcs_write16(HOST_FS_SELECTOR, 0);
+		hs->fs_gs_ldt_reload_needed = 1;
+	}
+	hs->gs_sel = read_gs();
+	if (!(hs->gs_sel & 7))
+		vmcs_write16(HOST_GS_SELECTOR, hs->gs_sel);
+	else {
+		vmcs_write16(HOST_GS_SELECTOR, 0);
+		hs->fs_gs_ldt_reload_needed = 1;
+	}
+
+#ifdef CONFIG_X86_64
+	vmcs_writel(HOST_FS_BASE, read_msr(MSR_FS_BASE));
+	vmcs_writel(HOST_GS_BASE, read_msr(MSR_GS_BASE));
+#else
+	vmcs_writel(HOST_FS_BASE, segment_base(hs->fs_sel));
+	vmcs_writel(HOST_GS_BASE, segment_base(hs->gs_sel));
+#endif
+}
+
+static void vmx_load_host_state(struct kvm_vcpu *vcpu)
+{
+	struct vmx_host_state *hs = &vcpu->vmx_host_state;
+
+	if (!hs->loaded)
+		return;
+
+	hs->loaded = 0;
+	if (hs->fs_gs_ldt_reload_needed) {
+		load_ldt(hs->ldt_sel);
+		load_fs(hs->fs_sel);
+		/*
+		 * If we have to reload gs, we must take care to
+		 * preserve our gs base.
+		 */
+		local_irq_disable();
+		load_gs(hs->gs_sel);
+#ifdef CONFIG_X86_64
+		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
+#endif
+		local_irq_enable();
+
+		reload_tss();
+	}
+#ifdef CONFIG_X86_64
+	if (is_long_mode(vcpu)) {
+		save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+		load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
+	}
+#endif
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -283,6 +370,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	vmx_load_host_state(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	put_cpu();
 }
@@ -397,23 +485,6 @@ static void guest_write_tsc(u64 guest_tsc)
 	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
 }
 
-static void reload_tss(void)
-{
-#ifndef CONFIG_X86_64
-
-	/*
-	 * VT restores TR but not its size.  Useless.
-	 */
-	struct descriptor_table gdt;
-	struct segment_descriptor *descs;
-
-	get_gdt(&gdt);
-	descs = (void *)gdt.base;
-	descs[GDT_ENTRY_TSS].type = 9; /* available TSS */
-	load_TR_desc();
-#endif
-}
-
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1823,40 +1894,9 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u8 fail;
-	u16 fs_sel, gs_sel, ldt_sel;
-	int fs_gs_ldt_reload_needed;
 	int r;
 
 preempted:
-	/*
-	 * Set host fs and gs selectors.  Unfortunately, 22.2.3 does not
-	 * allow segment selectors with cpl > 0 or ti == 1.
-	 */
-	ldt_sel = read_ldt();
-	fs_gs_ldt_reload_needed = ldt_sel;
-	fs_sel = read_fs();
-	if (!(fs_sel & 7))
-		vmcs_write16(HOST_FS_SELECTOR, fs_sel);
-	else {
-		vmcs_write16(HOST_FS_SELECTOR, 0);
-		fs_gs_ldt_reload_needed = 1;
-	}
-	gs_sel = read_gs();
-	if (!(gs_sel & 7))
-		vmcs_write16(HOST_GS_SELECTOR, gs_sel);
-	else {
-		vmcs_write16(HOST_GS_SELECTOR, 0);
-		fs_gs_ldt_reload_needed = 1;
-	}
-
-#ifdef CONFIG_X86_64
-	vmcs_writel(HOST_FS_BASE, read_msr(MSR_FS_BASE));
-	vmcs_writel(HOST_GS_BASE, read_msr(MSR_GS_BASE));
-#else
-	vmcs_writel(HOST_FS_BASE, segment_base(fs_sel));
-	vmcs_writel(HOST_GS_BASE, segment_base(gs_sel));
-#endif
-
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
@@ -1871,6 +1911,7 @@ preempted:
 #endif
 
 again:
+	vmx_save_host_state(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
 	/*
@@ -2040,29 +2081,6 @@ again:
 	}
 
 out:
-	if (fs_gs_ldt_reload_needed) {
-		load_ldt(ldt_sel);
-		load_fs(fs_sel);
-		/*
-		 * If we have to reload gs, we must take care to
-		 * preserve our gs base.
-		 */
-		local_irq_disable();
-		load_gs(gs_sel);
-#ifdef CONFIG_X86_64
-		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
-#endif
-		local_irq_enable();
-
-		reload_tss();
-	}
-#ifdef CONFIG_X86_64
-	if (is_long_mode(vcpu)) {
-		save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
-		load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
-	}
-#endif
-
 	if (r > 0) {
 		kvm_resched(vcpu);
 		goto preempted;
-- 
1.5.0.6

