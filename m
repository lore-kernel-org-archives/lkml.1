Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZERJqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZERJqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZERJZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 26/43] KVM: ia64: Create inline function kvm_get_itc() to centralize ITC reading.
Date: Mon, 18 May 2009 12:22:48 +0300
Message-Id: <1242638585-18470-27-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Move all reading of special register 'AR_ITC' into two functions, one
in the kernel and one in the VMM module. When running on SN2, base the
result on the RTC rather the system ITC, as the ITC isn't
synchronized.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |   18 ++++++++++++++----
 arch/ia64/kvm/vcpu.c     |   20 ++++++++++++++++++--
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 14a3fab..ebbd995 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -68,6 +68,16 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+static unsigned long kvm_get_itc(struct kvm_vcpu *vcpu)
+{
+#if defined(CONFIG_IA64_SGI_SN2) || defined(CONFIG_IA64_GENERIC)
+	if (vcpu->kvm->arch.is_sn2)
+		return rtc_time();
+	else
+#endif
+		return ia64_getreg(_IA64_REG_AR_ITC);
+}
+
 static void kvm_flush_icache(unsigned long start, unsigned long len)
 {
 	int l;
@@ -457,7 +467,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
 
-		vcpu_now_itc = ia64_getreg(_IA64_REG_AR_ITC) + vcpu->arch.itc_offset;
+		vcpu_now_itc = kvm_get_itc(vcpu) + vcpu->arch.itc_offset;
 
 		if (time_after(vcpu_now_itc, vpd->itm)) {
 			vcpu->arch.timer_check = 1;
@@ -929,7 +939,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	RESTORE_REGS(saved_gp);
 
 	vcpu->arch.irq_new_pending = 1;
-	vcpu->arch.itc_offset = regs->saved_itc - ia64_getreg(_IA64_REG_AR_ITC);
+	vcpu->arch.itc_offset = regs->saved_itc - kvm_get_itc(vcpu);
 	set_bit(KVM_REQ_RESUME, &vcpu->requests);
 
 	vcpu_put(vcpu);
@@ -1210,7 +1220,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		regs->cr_iip = PALE_RESET_ENTRY;
 
 		/*Initialize itc offset for vcpus*/
-		itc_offset = 0UL - ia64_getreg(_IA64_REG_AR_ITC);
+		itc_offset = 0UL - kvm_get_itc(vcpu);
 		for (i = 0; i < kvm->arch.online_vcpus; i++) {
 			v = (struct kvm_vcpu *)((char *)vcpu +
 					sizeof(struct kvm_vcpu_data) * i);
@@ -1472,7 +1482,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	}
 	for (i = 0; i < 4; i++)
 		regs->insvc[i] = vcpu->arch.insvc[i];
-	regs->saved_itc = vcpu->arch.itc_offset + ia64_getreg(_IA64_REG_AR_ITC);
+	regs->saved_itc = vcpu->arch.itc_offset + kvm_get_itc(vcpu);
 	SAVE_REGS(xtp);
 	SAVE_REGS(metaphysical_rr0);
 	SAVE_REGS(metaphysical_rr4);
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index a18ee17..a2c6c15 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -788,13 +788,29 @@ void vcpu_set_fpreg(struct kvm_vcpu *vcpu, unsigned long reg,
 		setfpreg(reg, val, regs);   /* FIXME: handle NATs later*/
 }
 
+/*
+ * The Altix RTC is mapped specially here for the vmm module
+ */
+#define SN_RTC_BASE	(u64 *)(KVM_VMM_BASE+(1UL<<KVM_VMM_SHIFT))
+static long kvm_get_itc(struct kvm_vcpu *vcpu)
+{
+#if defined(CONFIG_IA64_SGI_SN2) || defined(CONFIG_IA64_GENERIC)
+	struct kvm *kvm = (struct kvm *)KVM_VM_BASE;
+
+	if (kvm->arch.is_sn2)
+		return (*SN_RTC_BASE);
+	else
+#endif
+		return ia64_getreg(_IA64_REG_AR_ITC);
+}
+
 /************************************************************************
  * lsapic timer
  ***********************************************************************/
 u64 vcpu_get_itc(struct kvm_vcpu *vcpu)
 {
 	unsigned long guest_itc;
-	guest_itc = VMX(vcpu, itc_offset) + ia64_getreg(_IA64_REG_AR_ITC);
+	guest_itc = VMX(vcpu, itc_offset) + kvm_get_itc(vcpu);
 
 	if (guest_itc >= VMX(vcpu, last_itc)) {
 		VMX(vcpu, last_itc) = guest_itc;
@@ -809,7 +825,7 @@ static void vcpu_set_itc(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_vcpu *v;
 	struct kvm *kvm;
 	int i;
-	long itc_offset = val - ia64_getreg(_IA64_REG_AR_ITC);
+	long itc_offset = val - kvm_get_itc(vcpu);
 	unsigned long vitv = VCPU(vcpu, itv);
 
 	kvm = (struct kvm *)KVM_VM_BASE;
-- 
1.6.0.6

