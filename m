Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXC0QMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXC0QMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXC0QMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:12:32 -0400
Received: from il.qumranet.com ([82.166.9.18]:48973 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837AbXC0QMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:12:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [GIT PULL] KVM updates for 2.6.21-rc5
Date: Tue, 27 Mar 2007 18:12:31 +0200
Message-Id: <1175011951175-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'linus' branch of

  git://kvm.qumranet.com/home/avi/kvm.git

to receive the following updates:

Avi Kivity (1):
      KVM: Prevent system selectors leaking into guest on real->protected
      mode transition on vmx

Ingo Molnar (1):
      KVM: always reload segment selectors

The updates fix a potential oops, and allow guests to use the ACPI-enabled
bios.

 drivers/kvm/vmx.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)


diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index bfa0ce4..fbbf9d6 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -618,7 +618,7 @@ static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 
-	if (vmcs_readl(sf->base) == save->base) {
+	if (vmcs_readl(sf->base) == save->base && (save->base & AR_S_MASK)) {
 		vmcs_write16(sf->selector, save->selector);
 		vmcs_writel(sf->base, save->base);
 		vmcs_write32(sf->limit, save->limit);
@@ -1888,6 +1888,27 @@ again:
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
+	/*
+	 * Reload segment selectors ASAP. (it's needed for a functional
+	 * kernel: x86 relies on having __KERNEL_PDA in %fs and x86_64
+	 * relies on having 0 in %gs for the CPU PDA to work.)
+	 */
+	if (fs_gs_ldt_reload_needed) {
+		load_ldt(ldt_sel);
+		load_fs(fs_sel);
+		/*
+		 * If we have to reload gs, we must take care to
+		 * preserve our gs base.
+		 */
+		local_irq_disable();
+		load_gs(gs_sel);
+#ifdef CONFIG_X86_64
+		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
+#endif
+		local_irq_enable();
+
+		reload_tss();
+	}
 	++kvm_stat.exits;
 
 	save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
@@ -1905,22 +1926,6 @@ again:
 		kvm_run->exit_reason = vmcs_read32(VM_INSTRUCTION_ERROR);
 		r = 0;
 	} else {
-		if (fs_gs_ldt_reload_needed) {
-			load_ldt(ldt_sel);
-			load_fs(fs_sel);
-			/*
-			 * If we have to reload gs, we must take care to
-			 * preserve our gs base.
-			 */
-			local_irq_disable();
-			load_gs(gs_sel);
-#ifdef CONFIG_X86_64
-			wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
-#endif
-			local_irq_enable();
-
-			reload_tss();
-		}
 		/*
 		 * Profile KVM exit RIPs:
 		 */
