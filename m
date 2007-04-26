Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXDZJZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXDZJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbXDZJYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:24:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:53034 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933793AbXDZJW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:27 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 10/18] KVM: VMX: Don't switch 64-bit msrs for 32-bit guests
Date: Thu, 26 Apr 2007 12:22:10 +0300
Message-Id: <11775793383091-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some msrs are only used by x86_64 instructions, and are therefore
not needed when the guest is legacy mode.  By not bothering to switch
them, we reduce vmexit latency by 2400 cycles (from about 8800) when
running a 32-bt guest on a 64-bit host.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   58 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 3745e6c..6270df5 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -80,6 +80,9 @@ static const u32 vmx_msr_index[] = {
 
 #ifdef CONFIG_X86_64
 static unsigned msr_offset_kernel_gs_base;
+#define NR_64BIT_MSRS 4
+#else
+#define NR_64BIT_MSRS 0
 #endif
 
 static inline int is_page_fault(u32 intr_info)
@@ -301,6 +304,32 @@ static void vmx_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
 }
 
 /*
+ * Set up the vmcs to automatically save and restore system
+ * msrs.  Don't touch the 64-bit msrs if the guest is in legacy
+ * mode, as fiddling with msrs is very expensive.
+ */
+static void setup_msrs(struct kvm_vcpu *vcpu)
+{
+	int nr_skip, nr_good_msrs;
+
+	if (is_long_mode(vcpu))
+		nr_skip = NR_BAD_MSRS;
+	else
+		nr_skip = NR_64BIT_MSRS;
+	nr_good_msrs = vcpu->nmsrs - nr_skip;
+
+	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR,
+		    virt_to_phys(vcpu->guest_msrs + nr_skip));
+	vmcs_writel(VM_EXIT_MSR_STORE_ADDR,
+		    virt_to_phys(vcpu->guest_msrs + nr_skip));
+	vmcs_writel(VM_EXIT_MSR_LOAD_ADDR,
+		    virt_to_phys(vcpu->host_msrs + nr_skip));
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, nr_good_msrs); /* 22.2.2 */
+	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, nr_good_msrs);  /* 22.2.2 */
+	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, nr_good_msrs); /* 22.2.2 */
+}
+
+/*
  * reads and returns guest's timestamp counter "register"
  * guest_tsc = host_tsc + tsc_offset    -- 21.3
  */
@@ -825,6 +854,7 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 		msr->data = efer & ~EFER_LME;
 	}
+	setup_msrs(vcpu);
 }
 
 #endif
@@ -988,7 +1018,6 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	struct descriptor_table dt;
 	int i;
 	int ret = 0;
-	int nr_good_msrs;
 	extern asmlinkage void kvm_vmx_return(void);
 
 	if (!init_rmode_tss(vcpu->kvm)) {
@@ -1140,19 +1169,10 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 		++vcpu->nmsrs;
 	}
 
-	nr_good_msrs = vcpu->nmsrs - NR_BAD_MSRS;
-	vmcs_writel(VM_ENTRY_MSR_LOAD_ADDR,
-		    virt_to_phys(vcpu->guest_msrs + NR_BAD_MSRS));
-	vmcs_writel(VM_EXIT_MSR_STORE_ADDR,
-		    virt_to_phys(vcpu->guest_msrs + NR_BAD_MSRS));
-	vmcs_writel(VM_EXIT_MSR_LOAD_ADDR,
-		    virt_to_phys(vcpu->host_msrs + NR_BAD_MSRS));
+	setup_msrs(vcpu);
+
 	vmcs_write32_fixedbits(MSR_IA32_VMX_EXIT_CTLS, VM_EXIT_CONTROLS,
 		     	       (HOST_IS_64 << 9));  /* 22.2,1, 20.7.1 */
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, nr_good_msrs); /* 22.2.2 */
-	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, nr_good_msrs);  /* 22.2.2 */
-	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, nr_good_msrs); /* 22.2.2 */
-
 
 	/* 22.2.1, 20.8.1 */
 	vmcs_write32_fixedbits(MSR_IA32_VMX_ENTRY_CTLS,
@@ -1769,9 +1789,11 @@ again:
 	fx_restore(vcpu->guest_fx_image);
 
 #ifdef CONFIG_X86_64
-	save_msrs(vcpu->host_msrs + msr_offset_kernel_gs_base, 1);
+	if (is_long_mode(vcpu)) {
+		save_msrs(vcpu->host_msrs + msr_offset_kernel_gs_base, 1);
+		load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+	}
 #endif
-	load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
 
 	asm (
 		/* Store host registers */
@@ -1915,8 +1937,12 @@ again:
 	}
 	++kvm_stat.exits;
 
-	save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
-	load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
+#ifdef CONFIG_X86_64
+	if (is_long_mode(vcpu)) {
+		save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+		load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
+	}
+#endif
 
 	fx_save(vcpu->guest_fx_image);
 	fx_restore(vcpu->host_fx_image);
-- 
1.5.0.6

