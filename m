Return-Path: <linux-kernel-owner+w=401wt.eu-S1762821AbXFQKDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbXFQKDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759818AbXFQJpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:55160 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 27/58] KVM: VMX: Avoid saving and restoring msr_efer on lightweight vmexit
Date: Sun, 17 Jun 2007 12:44:08 +0300
Message-Id: <11820734803416-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

MSR_EFER.LME/LMA bits are automatically save/restored by VMX
hardware, KVM only needs to save NX/SCE bits at time of heavy
weight VM Exit. But clearing NX bits in host envirnment may
cause system hang if the host page table is using EXB bits,
thus we leave NX bits as it is. If Host NX=1 and guest NX=0, we
can do guest page table EXB bits check before inserting a shadow
pte (though no guest is expecting to see this kind of gp fault).
If host NX=0, we present guest no Execute-Disable feature to guest,
thus no host NX=0, guest NX=1 combination.

This patch reduces raw vmexit time by ~27%.

Me: fix compile warnings on i386.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +
 drivers/kvm/kvm_main.c |   23 ++++++++++++++++
 drivers/kvm/vmx.c      |   67 +++++++++++++++++++++++++++++++++---------------
 3 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index c252efe..db2bc6f 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -255,6 +255,7 @@ struct kvm_stat {
 	u32 request_irq_exits;
 	u32 irq_exits;
 	u32 light_exits;
+	u32 efer_reload;
 };
 
 struct kvm_vcpu {
@@ -289,6 +290,7 @@ struct kvm_vcpu {
 	u64 ia32_misc_enable_msr;
 	int nmsrs;
 	int save_nmsrs;
+	int msr_offset_efer;
 #ifdef CONFIG_X86_64
 	int msr_offset_kernel_gs_base;
 #endif
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 095d673..af07cd5 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -73,6 +73,7 @@ static struct kvm_stats_debugfs_item {
 	{ "request_irq", STAT_OFFSET(request_irq_exits) },
 	{ "irq_exits", STAT_OFFSET(irq_exits) },
 	{ "light_exits", STAT_OFFSET(light_exits) },
+	{ "efer_reload", STAT_OFFSET(efer_reload) },
 	{ NULL }
 };
 
@@ -2378,6 +2379,27 @@ out:
 	return r;
 }
 
+static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
+{
+	u64 efer;
+	int i;
+	struct kvm_cpuid_entry *e, *entry;
+
+	rdmsrl(MSR_EFER, efer);
+	entry = NULL;
+	for (i = 0; i < vcpu->cpuid_nent; ++i) {
+		e = &vcpu->cpuid_entries[i];
+		if (e->function == 0x80000001) {
+			entry = e;
+			break;
+		}
+	}
+	if (entry && (entry->edx & EFER_NX) && !(efer & EFER_NX)) {
+		entry->edx &= ~(1 << 20);
+		printk(KERN_INFO ": guest NX capability removed\n");
+	}
+}
+
 static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 				    struct kvm_cpuid *cpuid,
 				    struct kvm_cpuid_entry __user *entries)
@@ -2392,6 +2414,7 @@ static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
 		goto out;
 	vcpu->cpuid_nent = cpuid->nent;
+	cpuid_fix_nx_cap(vcpu);
 	return 0;
 
 out:
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index dc99191..93e5bb2 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -42,6 +42,7 @@ static struct page *vmx_io_bitmap_b;
 #else
 #define HOST_IS_64 0
 #endif
+#define EFER_SAVE_RESTORE_BITS ((u64)EFER_SCE)
 
 static struct vmcs_descriptor {
 	int size;
@@ -85,6 +86,18 @@ static const u32 vmx_msr_index[] = {
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
+static inline u64 msr_efer_save_restore_bits(struct vmx_msr_entry msr)
+{
+	return (u64)msr.data & EFER_SAVE_RESTORE_BITS;
+}
+
+static inline int msr_efer_need_save_restore(struct kvm_vcpu *vcpu)
+{
+	int efer_offset = vcpu->msr_offset_efer;
+	return msr_efer_save_restore_bits(vcpu->host_msrs[efer_offset]) !=
+		msr_efer_save_restore_bits(vcpu->guest_msrs[efer_offset]);
+}
+
 static inline int is_page_fault(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
@@ -265,6 +278,19 @@ static void reload_tss(void)
 #endif
 }
 
+static void load_transition_efer(struct kvm_vcpu *vcpu)
+{
+	u64 trans_efer;
+	int efer_offset = vcpu->msr_offset_efer;
+
+	trans_efer = vcpu->host_msrs[efer_offset].data;
+	trans_efer &= ~EFER_SAVE_RESTORE_BITS;
+	trans_efer |= msr_efer_save_restore_bits(
+				vcpu->guest_msrs[efer_offset]);
+	wrmsrl(MSR_EFER, trans_efer);
+	vcpu->stat.efer_reload++;
+}
+
 static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 {
 	struct vmx_host_state *hs = &vcpu->vmx_host_state;
@@ -308,6 +334,8 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 	}
 #endif
 	load_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
+	if (msr_efer_need_save_restore(vcpu))
+		load_transition_efer(vcpu);
 }
 
 static void vmx_load_host_state(struct kvm_vcpu *vcpu)
@@ -336,6 +364,8 @@ static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 	}
 	save_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
 	load_msrs(vcpu->host_msrs, vcpu->save_nmsrs);
+	if (msr_efer_need_save_restore(vcpu))
+		load_msrs(vcpu->host_msrs + vcpu->msr_offset_efer, 1);
 }
 
 /*
@@ -477,11 +507,13 @@ void move_msr_up(struct kvm_vcpu *vcpu, int from, int to)
  */
 static void setup_msrs(struct kvm_vcpu *vcpu)
 {
-	int index, save_nmsrs;
+	int save_nmsrs;
 
 	save_nmsrs = 0;
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
+		int index;
+
 		index = __find_msr_index(vcpu, MSR_SYSCALL_MASK);
 		if (index >= 0)
 			move_msr_up(vcpu, index, save_nmsrs++);
@@ -509,22 +541,7 @@ static void setup_msrs(struct kvm_vcpu *vcpu)
 	vcpu->msr_offset_kernel_gs_base =
 		__find_msr_index(vcpu, MSR_KERNEL_GS_BASE);
 #endif
-	index = __find_msr_index(vcpu, MSR_EFER);
-	if (index >= 0)
-		save_nmsrs = 1;
-	else {
-		save_nmsrs = 0;
-		index = 0;
-	}
-	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR,
-		    virt_to_phys(vcpu->guest_msrs + index));
-	vmcs_writel(VM_EXIT_MSR_STORE_ADDR,
-		    virt_to_phys(vcpu->guest_msrs + index));
-	vmcs_writel(VM_EXIT_MSR_LOAD_ADDR,
-		    virt_to_phys(vcpu->host_msrs + index));
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, save_nmsrs);
-	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, save_nmsrs);
-	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, save_nmsrs);
+	vcpu->msr_offset_efer = __find_msr_index(vcpu, MSR_EFER);
 }
 
 /*
@@ -611,10 +628,15 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	struct vmx_msr_entry *msr;
+	int ret = 0;
+
 	switch (msr_index) {
 #ifdef CONFIG_X86_64
 	case MSR_EFER:
-		return kvm_set_msr_common(vcpu, msr_index, data);
+		ret = kvm_set_msr_common(vcpu, msr_index, data);
+		if (vcpu->vmx_host_state.loaded)
+			load_transition_efer(vcpu);
+		break;
 	case MSR_FS_BASE:
 		vmcs_writel(GUEST_FS_BASE, data);
 		break;
@@ -639,13 +661,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		if (msr) {
 			msr->data = data;
 			if (vcpu->vmx_host_state.loaded)
-				load_msrs(vcpu->guest_msrs,vcpu->save_nmsrs);
+				load_msrs(vcpu->guest_msrs, vcpu->save_nmsrs);
 			break;
 		}
-		return kvm_set_msr_common(vcpu, msr_index, data);
+		ret = kvm_set_msr_common(vcpu, msr_index, data);
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -1326,6 +1348,9 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	asm ("mov $.Lkvm_vmx_return, %0" : "=r"(kvm_vmx_return));
 	vmcs_writel(HOST_RIP, kvm_vmx_return); /* 22.2.5 */
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
+	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
 
 	rdmsr(MSR_IA32_SYSENTER_CS, host_sysenter_cs, junk);
 	vmcs_write32(HOST_IA32_SYSENTER_CS, host_sysenter_cs);
-- 
1.5.0.6

