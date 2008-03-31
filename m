Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYCaOsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYCaOsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYCaOhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:52 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51327
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYCaOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 30/40] KVM: SVM: allocate the MSR permission map per VCPU
Date: Mon, 31 Mar 2008 17:37:14 +0300
Message-Id: <1206974244-9716-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch changes the kvm-amd module to allocate the SVM MSR permission map
per VCPU instead of a global map for all VCPUs. With this we have more
flexibility allowing specific guests to access virtualized MSRs. This is
required for LBR virtualization.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/kvm_svm.h |    2 +
 arch/x86/kvm/svm.c     |   67 +++++++++++++++++++++++-------------------------
 2 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/kvm_svm.h b/arch/x86/kvm/kvm_svm.h
index ecdfe97..65ef0fc 100644
--- a/arch/x86/kvm/kvm_svm.h
+++ b/arch/x86/kvm/kvm_svm.h
@@ -39,6 +39,8 @@ struct vcpu_svm {
 	unsigned long host_db_regs[NUM_DB_REGS];
 	unsigned long host_dr6;
 	unsigned long host_dr7;
+
+	u32 *msrpm;
 };
 
 #endif
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d934819..281a2ff 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -65,7 +65,6 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 }
 
 unsigned long iopm_base;
-unsigned long msrpm_base;
 
 struct kvm_ldttss_desc {
 	u16 limit0;
@@ -370,12 +369,29 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	BUG();
 }
 
+static void svm_vcpu_init_msrpm(u32 *msrpm)
+{
+	memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
+
+#ifdef CONFIG_X86_64
+	set_msr_interception(msrpm, MSR_GS_BASE, 1, 1);
+	set_msr_interception(msrpm, MSR_FS_BASE, 1, 1);
+	set_msr_interception(msrpm, MSR_KERNEL_GS_BASE, 1, 1);
+	set_msr_interception(msrpm, MSR_LSTAR, 1, 1);
+	set_msr_interception(msrpm, MSR_CSTAR, 1, 1);
+	set_msr_interception(msrpm, MSR_SYSCALL_MASK, 1, 1);
+#endif
+	set_msr_interception(msrpm, MSR_K6_STAR, 1, 1);
+	set_msr_interception(msrpm, MSR_IA32_SYSENTER_CS, 1, 1);
+	set_msr_interception(msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+	set_msr_interception(msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
+}
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
 	struct page *iopm_pages;
-	struct page *msrpm_pages;
-	void *iopm_va, *msrpm_va;
+	void *iopm_va;
 	int r;
 
 	iopm_pages = alloc_pages(GFP_KERNEL, IOPM_ALLOC_ORDER);
@@ -388,37 +404,13 @@ static __init int svm_hardware_setup(void)
 	clear_bit(0x80, iopm_va); /* allow direct access to PC debug port */
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
-
-	msrpm_pages = alloc_pages(GFP_KERNEL, MSRPM_ALLOC_ORDER);
-
-	r = -ENOMEM;
-	if (!msrpm_pages)
-		goto err_1;
-
-	msrpm_va = page_address(msrpm_pages);
-	memset(msrpm_va, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
-	msrpm_base = page_to_pfn(msrpm_pages) << PAGE_SHIFT;
-
-#ifdef CONFIG_X86_64
-	set_msr_interception(msrpm_va, MSR_GS_BASE, 1, 1);
-	set_msr_interception(msrpm_va, MSR_FS_BASE, 1, 1);
-	set_msr_interception(msrpm_va, MSR_KERNEL_GS_BASE, 1, 1);
-	set_msr_interception(msrpm_va, MSR_LSTAR, 1, 1);
-	set_msr_interception(msrpm_va, MSR_CSTAR, 1, 1);
-	set_msr_interception(msrpm_va, MSR_SYSCALL_MASK, 1, 1);
-#endif
-	set_msr_interception(msrpm_va, MSR_K6_STAR, 1, 1);
-	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_CS, 1, 1);
-	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_ESP, 1, 1);
-	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_EIP, 1, 1);
-
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
 	for_each_online_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-			goto err_2;
+			goto err;
 	}
 
 	svm_features = cpuid_edx(SVM_CPUID_FUNC);
@@ -438,10 +430,7 @@ static __init int svm_hardware_setup(void)
 
 	return 0;
 
-err_2:
-	__free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
-	msrpm_base = 0;
-err_1:
+err:
 	__free_pages(iopm_pages, IOPM_ALLOC_ORDER);
 	iopm_base = 0;
 	return r;
@@ -449,9 +438,8 @@ err_1:
 
 static __exit void svm_hardware_unsetup(void)
 {
-	__free_pages(pfn_to_page(msrpm_base >> PAGE_SHIFT), MSRPM_ALLOC_ORDER);
 	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
-	iopm_base = msrpm_base = 0;
+	iopm_base = 0;
 }
 
 static void init_seg(struct vmcb_seg *seg)
@@ -536,7 +524,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 				(1ULL << INTERCEPT_MWAIT);
 
 	control->iopm_base_pa = iopm_base;
-	control->msrpm_base_pa = msrpm_base;
+	control->msrpm_base_pa = __pa(svm->msrpm);
 	control->tsc_offset = 0;
 	control->int_ctl = V_INTR_MASKING_MASK;
 
@@ -615,6 +603,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	struct vcpu_svm *svm;
 	struct page *page;
+	struct page *msrpm_pages;
 	int err;
 
 	svm = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
@@ -633,6 +622,13 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto uninit;
 	}
 
+	err = -ENOMEM;
+	msrpm_pages = alloc_pages(GFP_KERNEL, MSRPM_ALLOC_ORDER);
+	if (!msrpm_pages)
+		goto uninit;
+	svm->msrpm = page_address(msrpm_pages);
+	svm_vcpu_init_msrpm(svm->msrpm);
+
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
@@ -661,6 +657,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
+	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
 }
-- 
1.5.4.5

