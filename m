Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZBZOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZBZOa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZBZORk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 30/40] KVM: VMX: initialize TSC offset relative to vm creation time
Date: Thu, 26 Feb 2009 16:15:20 +0200
Message-Id: <1235657730-27683-31-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

VMX initializes the TSC offset for each vcpu at different times, and
also reinitializes it for vcpus other than 0 on APIC SIPI message.

This bug causes the TSC's to appear unsynchronized in the guest, even if
the host is good.

Older Linux kernels don't handle the situation very well, so
gettimeofday is likely to go backwards in time:

http://www.mail-archive.com/kvm@vger.kernel.org/msg02955.html
http://sourceforge.net/tracker/index.php?func=detail&aid=2025534&group_id=180599&atid=893831

Fix it by initializating the offset of each vcpu relative to vm creation
time, and moving it from vmx_vcpu_reset to vmx_vcpu_setup, out of the
APIC MP init path.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx.c              |   19 +++++++++++--------
 arch/x86/kvm/x86.c              |    2 ++
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2a01d0..9efc446 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -398,6 +398,7 @@ struct kvm_arch{
 
 	unsigned long irq_sources_bitmap;
 	unsigned long irq_states[KVM_IOAPIC_NUM_PINS];
+	u64 vm_init_tsc;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index cee81c9..3312047 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -865,11 +865,8 @@ static u64 guest_read_tsc(void)
  * writes 'guest_tsc' into guest's timestamp counter "register"
  * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
  */
-static void guest_write_tsc(u64 guest_tsc)
+static void guest_write_tsc(u64 guest_tsc, u64 host_tsc)
 {
-	u64 host_tsc;
-
-	rdtscll(host_tsc);
 	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
 }
 
@@ -934,6 +931,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_msr_entry *msr;
+	u64 host_tsc;
 	int ret = 0;
 
 	switch (msr_index) {
@@ -959,7 +957,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_TIME_STAMP_COUNTER:
-		guest_write_tsc(data);
+		rdtscll(host_tsc);
+		guest_write_tsc(data, host_tsc);
 		break;
 	case MSR_P6_PERFCTR0:
 	case MSR_P6_PERFCTR1:
@@ -2109,7 +2108,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
 	u32 host_sysenter_cs, msr_low, msr_high;
 	u32 junk;
-	u64 host_pat;
+	u64 host_pat, tsc_this, tsc_base;
 	unsigned long a;
 	struct descriptor_table dt;
 	int i;
@@ -2237,6 +2236,12 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
 
+	tsc_base = vmx->vcpu.kvm->arch.vm_init_tsc;
+	rdtscll(tsc_this);
+	if (tsc_this < vmx->vcpu.kvm->arch.vm_init_tsc)
+		tsc_base = tsc_this;
+
+	guest_write_tsc(0, tsc_base);
 
 	return 0;
 }
@@ -2328,8 +2333,6 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
 	vmcs_write32(GUEST_PENDING_DBG_EXCEPTIONS, 0);
 
-	guest_write_tsc(0);
-
 	/* Special registers */
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 873602b..3b2acfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4170,6 +4170,8 @@ struct  kvm *kvm_arch_create_vm(void)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
+	rdtscll(kvm->arch.vm_init_tsc);
+
 	return kvm;
 }
 
-- 
1.6.0.6

