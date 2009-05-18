Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZERJej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZERJej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZERJX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38418 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 25/43] KVM: ia64: Map in SN2 RTC registers to the VMM module
Date: Mon, 18 May 2009 12:22:47 +0300
Message-Id: <1242638585-18470-26-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

On SN2, map in the SN2 RTC registers to the VMM module, needed for ITC
emulation.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    2 +
 arch/ia64/include/asm/pgtable.h  |    2 +
 arch/ia64/kvm/kvm-ia64.c         |   43 +++++++++++++++++++++++++++++++++----
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 5608488..1243995 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -371,6 +371,7 @@ struct kvm_vcpu_arch {
 	int last_run_cpu;
 	int vmm_tr_slot;
 	int vm_tr_slot;
+	int sn_rtc_tr_slot;
 
 #define KVM_MP_STATE_RUNNABLE          0
 #define KVM_MP_STATE_UNINITIALIZED     1
@@ -465,6 +466,7 @@ struct kvm_arch {
 	unsigned long	vmm_init_rr;
 
 	int		online_vcpus;
+	int		is_sn2;
 
 	struct kvm_ioapic *vioapic;
 	struct kvm_vm_stat stat;
diff --git a/arch/ia64/include/asm/pgtable.h b/arch/ia64/include/asm/pgtable.h
index 7a9bff4..0a9cc73 100644
--- a/arch/ia64/include/asm/pgtable.h
+++ b/arch/ia64/include/asm/pgtable.h
@@ -146,6 +146,8 @@
 #define PAGE_GATE	__pgprot(__ACCESS_BITS | _PAGE_PL_0 | _PAGE_AR_X_RX)
 #define PAGE_KERNEL	__pgprot(__DIRTY_BITS  | _PAGE_PL_0 | _PAGE_AR_RWX)
 #define PAGE_KERNELRX	__pgprot(__ACCESS_BITS | _PAGE_PL_0 | _PAGE_AR_RX)
+#define PAGE_KERNEL_UC	__pgprot(__DIRTY_BITS  | _PAGE_PL_0 | _PAGE_AR_RWX | \
+				 _PAGE_MA_UC)
 
 # ifndef __ASSEMBLY__
 
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index acf43ec..14a3fab 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -41,6 +41,9 @@
 #include <asm/div64.h>
 #include <asm/tlb.h>
 #include <asm/elf.h>
+#include <asm/sn/addrs.h>
+#include <asm/sn/clksupport.h>
+#include <asm/sn/shub_mmr.h>
 
 #include "misc.h"
 #include "vti.h"
@@ -119,8 +122,7 @@ void kvm_arch_hardware_enable(void *garbage)
 	unsigned long saved_psr;
 	int slot;
 
-	pte = pte_val(mk_pte_phys(__pa(kvm_vmm_base),
-				PAGE_KERNEL));
+	pte = pte_val(mk_pte_phys(__pa(kvm_vmm_base), PAGE_KERNEL));
 	local_irq_save(saved_psr);
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
 	local_irq_restore(saved_psr);
@@ -425,6 +427,23 @@ static int handle_switch_rr6(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int kvm_sn2_setup_mappings(struct kvm_vcpu *vcpu)
+{
+	unsigned long pte, rtc_phys_addr, map_addr;
+	int slot;
+
+	map_addr = KVM_VMM_BASE + (1UL << KVM_VMM_SHIFT);
+	rtc_phys_addr = LOCAL_MMR_OFFSET | SH_RTC;
+	pte = pte_val(mk_pte_phys(rtc_phys_addr, PAGE_KERNEL_UC));
+	slot = ia64_itr_entry(0x3, map_addr, pte, PAGE_SHIFT);
+	vcpu->arch.sn_rtc_tr_slot = slot;
+	if (slot < 0) {
+		printk(KERN_ERR "Mayday mayday! RTC mapping failed!\n");
+		slot = 0;
+	}
+	return slot;
+}
+
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 
@@ -563,18 +582,29 @@ static int kvm_insert_vmm_mapping(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out;
 	vcpu->arch.vm_tr_slot = r;
+
+#if defined(CONFIG_IA64_SGI_SN2) || defined(CONFIG_IA64_GENERIC)
+	if (kvm->arch.is_sn2) {
+		r = kvm_sn2_setup_mappings(vcpu);
+		if (r < 0)
+			goto out;
+	}
+#endif
+
 	r = 0;
 out:
 	return r;
-
 }
 
 static void kvm_purge_vmm_mapping(struct kvm_vcpu *vcpu)
 {
-
+	struct kvm *kvm = vcpu->kvm;
 	ia64_ptr_entry(0x3, vcpu->arch.vmm_tr_slot);
 	ia64_ptr_entry(0x3, vcpu->arch.vm_tr_slot);
-
+#if defined(CONFIG_IA64_SGI_SN2) || defined(CONFIG_IA64_GENERIC)
+	if (kvm->arch.is_sn2)
+		ia64_ptr_entry(0x3, vcpu->arch.sn_rtc_tr_slot);
+#endif
 }
 
 static int kvm_vcpu_pre_transition(struct kvm_vcpu *vcpu)
@@ -800,6 +830,9 @@ struct  kvm *kvm_arch_create_vm(void)
 
 	if (IS_ERR(kvm))
 		return ERR_PTR(-ENOMEM);
+
+	kvm->arch.is_sn2 = ia64_platform_is("sn2");
+
 	kvm_init_vm(kvm);
 
 	kvm->arch.online_vcpus = 0;
-- 
1.6.0.6

