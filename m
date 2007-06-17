Return-Path: <linux-kernel-owner+w=401wt.eu-S1762631AbXFQKDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631AbXFQKDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759802AbXFQJpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:55161 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765AbXFQJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 25/58] KVM: VMX: Avoid saving and restoring msrs on lightweight vmexit
Date: Sun, 17 Jun 2007 12:44:06 +0300
Message-Id: <11820734802959-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

In a lightweight exit (where we exit and reenter the guest without
scheduling or exiting to userspace in between), we don't need various
msrs on the host, and avoiding shuffling them around reduces raw exit
time by 8%.

i386 compile fix by Daniel Hecken <dh@bahntechnik.de>.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    4 ++
 drivers/kvm/vmx.c |  128 ++++++++++++++++++++++++++++++-----------------------
 2 files changed, 76 insertions(+), 56 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index fc4a6c1..c252efe 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -288,6 +288,10 @@ struct kvm_vcpu {
 	u64 apic_base;
 	u64 ia32_misc_enable_msr;
 	int nmsrs;
+	int save_nmsrs;
+#ifdef CONFIG_X86_64
+	int msr_offset_kernel_gs_base;
+#endif
 	struct vmx_msr_entry *guest_msrs;
 	struct vmx_msr_entry *host_msrs;
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index a05bfa0..872ca03 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -85,19 +85,6 @@ static const u32 vmx_msr_index[] = {
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
-#ifdef CONFIG_X86_64
-static unsigned msr_offset_kernel_gs_base;
-#define NR_64BIT_MSRS 4
-/*
- * avoid save/load MSR_SYSCALL_MASK and MSR_LSTAR by std vt
- * mechanism (cpu bug AA24)
- */
-#define NR_BAD_MSRS 2
-#else
-#define NR_64BIT_MSRS 0
-#define NR_BAD_MSRS 0
-#endif
-
 static inline int is_page_fault(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
@@ -118,13 +105,23 @@ static inline int is_external_interrupt(u32 intr_info)
 		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
 }
 
-static struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
+static int __find_msr_index(struct kvm_vcpu *vcpu, u32 msr)
 {
 	int i;
 
 	for (i = 0; i < vcpu->nmsrs; ++i)
 		if (vcpu->guest_msrs[i].index == msr)
-			return &vcpu->guest_msrs[i];
+			return i;
+	return -1;
+}
+
+static struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
+{
+	int i;
+
+	i = __find_msr_index(vcpu, msr);
+	if (i >= 0)
+		return &vcpu->guest_msrs[i];
 	return NULL;
 }
 
@@ -307,10 +304,10 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
-		save_msrs(vcpu->host_msrs + msr_offset_kernel_gs_base, 1);
-		load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+		save_msrs(vcpu->host_msrs + vcpu->msr_offset_kernel_gs_base, 1);
 	}
 #endif
+	load_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
 }
 
 static void vmx_load_host_state(struct kvm_vcpu *vcpu)
@@ -337,12 +334,8 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 
 		reload_tss();
 	}
-#ifdef CONFIG_X86_64
-	if (is_long_mode(vcpu)) {
-		save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
-		load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
-	}
-#endif
+	save_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
+	load_msrs(vcpu->host_msrs, vcpu->save_nmsrs);
 }
 
 /*
@@ -464,41 +457,74 @@ static void vmx_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
 }
 
 /*
+ * Swap MSR entry in host/guest MSR entry array.
+ */
+void move_msr_up(struct kvm_vcpu *vcpu, int from, int to)
+{
+	struct vmx_msr_entry tmp;
+	tmp = vcpu->guest_msrs[to];
+	vcpu->guest_msrs[to] = vcpu->guest_msrs[from];
+	vcpu->guest_msrs[from] = tmp;
+	tmp = vcpu->host_msrs[to];
+	vcpu->host_msrs[to] = vcpu->host_msrs[from];
+	vcpu->host_msrs[from] = tmp;
+}
+
+/*
  * Set up the vmcs to automatically save and restore system
  * msrs.  Don't touch the 64-bit msrs if the guest is in legacy
  * mode, as fiddling with msrs is very expensive.
  */
 static void setup_msrs(struct kvm_vcpu *vcpu)
 {
-	int nr_skip, nr_good_msrs;
+	int index, save_nmsrs;
 
-	if (is_long_mode(vcpu))
-		nr_skip = NR_BAD_MSRS;
-	else
-		nr_skip = NR_64BIT_MSRS;
-	nr_good_msrs = vcpu->nmsrs - nr_skip;
+	save_nmsrs = 0;
+#ifdef CONFIG_X86_64
+	if (is_long_mode(vcpu)) {
+		index = __find_msr_index(vcpu, MSR_SYSCALL_MASK);
+		if (index >= 0)
+			move_msr_up(vcpu, index, save_nmsrs++);
+		index = __find_msr_index(vcpu, MSR_LSTAR);
+		if (index >= 0)
+			move_msr_up(vcpu, index, save_nmsrs++);
+		index = __find_msr_index(vcpu, MSR_CSTAR);
+		if (index >= 0)
+			move_msr_up(vcpu, index, save_nmsrs++);
+		index = __find_msr_index(vcpu, MSR_KERNEL_GS_BASE);
+		if (index >= 0)
+			move_msr_up(vcpu, index, save_nmsrs++);
+		/*
+		 * MSR_K6_STAR is only needed on long mode guests, and only
+		 * if efer.sce is enabled.
+		 */
+		index = __find_msr_index(vcpu, MSR_K6_STAR);
+		if ((index >= 0) && (vcpu->shadow_efer & EFER_SCE))
+			move_msr_up(vcpu, index, save_nmsrs++);
+	}
+#endif
+	vcpu->save_nmsrs = save_nmsrs;
 
-	/*
-	 * MSR_K6_STAR is only needed on long mode guests, and only
-	 * if efer.sce is enabled.
-	 */
-	if (find_msr_entry(vcpu, MSR_K6_STAR)) {
-		--nr_good_msrs;
 #ifdef CONFIG_X86_64
-		if (is_long_mode(vcpu) && (vcpu->shadow_efer & EFER_SCE))
-			++nr_good_msrs;
+	vcpu->msr_offset_kernel_gs_base =
+		__find_msr_index(vcpu, MSR_KERNEL_GS_BASE);
 #endif
+	index = __find_msr_index(vcpu, MSR_EFER);
+	if (index >= 0)
+		save_nmsrs = 1;
+	else {
+		save_nmsrs = 0;
+		index = 0;
 	}
-
 	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR,
-		    virt_to_phys(vcpu->guest_msrs + nr_skip));
+		    virt_to_phys(vcpu->guest_msrs + index));
 	vmcs_writel(VM_EXIT_MSR_STORE_ADDR,
-		    virt_to_phys(vcpu->guest_msrs + nr_skip));
+		    virt_to_phys(vcpu->guest_msrs + index));
 	vmcs_writel(VM_EXIT_MSR_LOAD_ADDR,
-		    virt_to_phys(vcpu->host_msrs + nr_skip));
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, nr_good_msrs); /* 22.2.2 */
-	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, nr_good_msrs);  /* 22.2.2 */
-	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, nr_good_msrs); /* 22.2.2 */
+		    virt_to_phys(vcpu->host_msrs + index));
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, save_nmsrs);
+	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, save_nmsrs);
+	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, save_nmsrs);
 }
 
 /*
@@ -595,14 +621,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_GS_BASE:
 		vmcs_writel(GUEST_GS_BASE, data);
 		break;
-	case MSR_LSTAR:
-	case MSR_SYSCALL_MASK:
-		msr = find_msr_entry(vcpu, msr_index);
-		if (msr)
-			msr->data = data;
-		if (vcpu->vmx_host_state.loaded)
-			load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
-		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
 		vmcs_write32(GUEST_SYSENTER_CS, data);
@@ -620,6 +638,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		msr = find_msr_entry(vcpu, msr_index);
 		if (msr) {
 			msr->data = data;
+			if (vcpu->vmx_host_state.loaded)
+				load_msrs(vcpu->guest_msrs,vcpu->save_nmsrs);
 			break;
 		}
 		return kvm_set_msr_common(vcpu, msr_index, data);
@@ -1331,10 +1351,6 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->host_msrs[j].reserved = 0;
 		vcpu->host_msrs[j].data = data;
 		vcpu->guest_msrs[j] = vcpu->host_msrs[j];
-#ifdef CONFIG_X86_64
-		if (index == MSR_KERNEL_GS_BASE)
-			msr_offset_kernel_gs_base = j;
-#endif
 		++vcpu->nmsrs;
 	}
 
-- 
1.5.0.6

