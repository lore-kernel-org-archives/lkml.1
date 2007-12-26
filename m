Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbXLZLSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbXLZLSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXLZLGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:50486 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 24/55] KVM: Portability: Move kvm_get/set_msr[_common] to x86.c
Date: Wed, 26 Dec 2007 13:05:29 +0200
Message-Id: <1198667160-22953-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch moves the implementation of the functions of kvm_get/set_msr,
kvm_get/set_msr_common, and set_efer from kvm_main.c to x86.c. The
definition of EFER_RESERVED_BITS is moved too.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |  133 -----------------------------------------------
 drivers/kvm/x86.c      |  134 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 133 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 7186791..5eccf27 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -90,8 +90,6 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
-#define EFER_RESERVED_BITS 0xfffffffffffff2fe
-
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 
@@ -1356,137 +1354,6 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 	}
 }
 
-int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
-{
-	u64 data;
-
-	switch (msr) {
-	case 0xc0010010: /* SYSCFG */
-	case 0xc0010015: /* HWCR */
-	case MSR_IA32_PLATFORM_ID:
-	case MSR_IA32_P5_MC_ADDR:
-	case MSR_IA32_P5_MC_TYPE:
-	case MSR_IA32_MC0_CTL:
-	case MSR_IA32_MCG_STATUS:
-	case MSR_IA32_MCG_CAP:
-	case MSR_IA32_MC0_MISC:
-	case MSR_IA32_MC0_MISC+4:
-	case MSR_IA32_MC0_MISC+8:
-	case MSR_IA32_MC0_MISC+12:
-	case MSR_IA32_MC0_MISC+16:
-	case MSR_IA32_UCODE_REV:
-	case MSR_IA32_PERF_STATUS:
-	case MSR_IA32_EBL_CR_POWERON:
-		/* MTRR registers */
-	case 0xfe:
-	case 0x200 ... 0x2ff:
-		data = 0;
-		break;
-	case 0xcd: /* fsb frequency */
-		data = 3;
-		break;
-	case MSR_IA32_APICBASE:
-		data = kvm_get_apic_base(vcpu);
-		break;
-	case MSR_IA32_MISC_ENABLE:
-		data = vcpu->ia32_misc_enable_msr;
-		break;
-#ifdef CONFIG_X86_64
-	case MSR_EFER:
-		data = vcpu->shadow_efer;
-		break;
-#endif
-	default:
-		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
-		return 1;
-	}
-	*pdata = data;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(kvm_get_msr_common);
-
-/*
- * Reads an msr value (of 'msr_index') into 'pdata'.
- * Returns 0 on success, non-0 otherwise.
- * Assumes vcpu_load() was already called.
- */
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
-{
-	return kvm_x86_ops->get_msr(vcpu, msr_index, pdata);
-}
-
-#ifdef CONFIG_X86_64
-
-static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
-{
-	if (efer & EFER_RESERVED_BITS) {
-		printk(KERN_DEBUG "set_efer: 0x%llx #GP, reserved bits\n",
-		       efer);
-		inject_gp(vcpu);
-		return;
-	}
-
-	if (is_paging(vcpu)
-	    && (vcpu->shadow_efer & EFER_LME) != (efer & EFER_LME)) {
-		printk(KERN_DEBUG "set_efer: #GP, change LME while paging\n");
-		inject_gp(vcpu);
-		return;
-	}
-
-	kvm_x86_ops->set_efer(vcpu, efer);
-
-	efer &= ~EFER_LMA;
-	efer |= vcpu->shadow_efer & EFER_LMA;
-
-	vcpu->shadow_efer = efer;
-}
-
-#endif
-
-int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
-{
-	switch (msr) {
-#ifdef CONFIG_X86_64
-	case MSR_EFER:
-		set_efer(vcpu, data);
-		break;
-#endif
-	case MSR_IA32_MC0_STATUS:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
-		       __FUNCTION__, data);
-		break;
-	case MSR_IA32_MCG_STATUS:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
-			__FUNCTION__, data);
-		break;
-	case MSR_IA32_UCODE_REV:
-	case MSR_IA32_UCODE_WRITE:
-	case 0x200 ... 0x2ff: /* MTRRs */
-		break;
-	case MSR_IA32_APICBASE:
-		kvm_set_apic_base(vcpu, data);
-		break;
-	case MSR_IA32_MISC_ENABLE:
-		vcpu->ia32_misc_enable_msr = data;
-		break;
-	default:
-		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x\n", msr);
-		return 1;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(kvm_set_msr_common);
-
-/*
- * Writes msr value into into the appropriate "register".
- * Returns 0 on success, non-0 otherwise.
- * Assumes vcpu_load() was already called.
- */
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
-{
-	return kvm_x86_ops->set_msr(vcpu, msr_index, data);
-}
-
 void kvm_resched(struct kvm_vcpu *vcpu)
 {
 	if (!need_resched())
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index a728af8..7862743 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -38,6 +38,7 @@
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
+#define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
 unsigned long segment_base(u16 selector)
 {
@@ -324,6 +325,44 @@ static u32 emulated_msrs[] = {
 	MSR_IA32_MISC_ENABLE,
 };
 
+#ifdef CONFIG_X86_64
+
+static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	if (efer & EFER_RESERVED_BITS) {
+		printk(KERN_DEBUG "set_efer: 0x%llx #GP, reserved bits\n",
+		       efer);
+		inject_gp(vcpu);
+		return;
+	}
+
+	if (is_paging(vcpu)
+	    && (vcpu->shadow_efer & EFER_LME) != (efer & EFER_LME)) {
+		printk(KERN_DEBUG "set_efer: #GP, change LME while paging\n");
+		inject_gp(vcpu);
+		return;
+	}
+
+	kvm_x86_ops->set_efer(vcpu, efer);
+
+	efer &= ~EFER_LMA;
+	efer |= vcpu->shadow_efer & EFER_LMA;
+
+	vcpu->shadow_efer = efer;
+}
+
+#endif
+
+/*
+ * Writes msr value into into the appropriate "register".
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
+{
+	return kvm_x86_ops->set_msr(vcpu, msr_index, data);
+}
+
 /*
  * Adapt set_msr() to msr_io()'s calling convention
  */
@@ -332,6 +371,101 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	return kvm_set_msr(vcpu, index, *data);
 }
 
+
+int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	switch (msr) {
+#ifdef CONFIG_X86_64
+	case MSR_EFER:
+		set_efer(vcpu, data);
+		break;
+#endif
+	case MSR_IA32_MC0_STATUS:
+		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
+		       __FUNCTION__, data);
+		break;
+	case MSR_IA32_MCG_STATUS:
+		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
+			__FUNCTION__, data);
+		break;
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_UCODE_WRITE:
+	case 0x200 ... 0x2ff: /* MTRRs */
+		break;
+	case MSR_IA32_APICBASE:
+		kvm_set_apic_base(vcpu, data);
+		break;
+	case MSR_IA32_MISC_ENABLE:
+		vcpu->ia32_misc_enable_msr = data;
+		break;
+	default:
+		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x\n", msr);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_set_msr_common);
+
+
+/*
+ * Reads an msr value (of 'msr_index') into 'pdata'.
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
+{
+	return kvm_x86_ops->get_msr(vcpu, msr_index, pdata);
+}
+
+int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+{
+	u64 data;
+
+	switch (msr) {
+	case 0xc0010010: /* SYSCFG */
+	case 0xc0010015: /* HWCR */
+	case MSR_IA32_PLATFORM_ID:
+	case MSR_IA32_P5_MC_ADDR:
+	case MSR_IA32_P5_MC_TYPE:
+	case MSR_IA32_MC0_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MC0_MISC:
+	case MSR_IA32_MC0_MISC+4:
+	case MSR_IA32_MC0_MISC+8:
+	case MSR_IA32_MC0_MISC+12:
+	case MSR_IA32_MC0_MISC+16:
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_PERF_STATUS:
+	case MSR_IA32_EBL_CR_POWERON:
+		/* MTRR registers */
+	case 0xfe:
+	case 0x200 ... 0x2ff:
+		data = 0;
+		break;
+	case 0xcd: /* fsb frequency */
+		data = 3;
+		break;
+	case MSR_IA32_APICBASE:
+		data = kvm_get_apic_base(vcpu);
+		break;
+	case MSR_IA32_MISC_ENABLE:
+		data = vcpu->ia32_misc_enable_msr;
+		break;
+#ifdef CONFIG_X86_64
+	case MSR_EFER:
+		data = vcpu->shadow_efer;
+		break;
+#endif
+	default:
+		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
+		return 1;
+	}
+	*pdata = data;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_get_msr_common);
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
-- 
1.5.3.7

