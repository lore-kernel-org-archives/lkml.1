Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZERJde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZERJde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZERJXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38419 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 28/43] KVM: ia64: Drop in SN2 replacement of fast path ITC emulation fault handler
Date: Mon, 18 May 2009 12:22:50 +0300
Message-Id: <1242638585-18470-29-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Copy in SN2 RTC based ITC emulation for fast exit. The two versions
have the same size, so a dropin is simpler than patching the branch
instruction to hit the SN2 version.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    2 ++
 arch/ia64/kvm/kvm-ia64.c         |   32 +++++++++++++++++++++++++++++++-
 arch/ia64/kvm/optvfault.S        |   30 ++++++++++++++++++++++++++++++
 arch/ia64/kvm/vmm.c              |   12 ++++++++----
 4 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 1243995..589536f 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -580,6 +580,8 @@ struct kvm_vmm_info{
 	kvm_vmm_entry 	*vmm_entry;
 	kvm_tramp_entry *tramp_entry;
 	unsigned long 	vmm_ivt;
+	unsigned long	patch_mov_ar;
+	unsigned long	patch_mov_ar_sn2;
 };
 
 int kvm_highest_pending_irq(struct kvm_vcpu *vcpu);
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index ebbd995..4623a90 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1671,8 +1671,37 @@ out:
 	return 0;
 }
 
+
+/*
+ * On SN2, the ITC isn't stable, so copy in fast path code to use the
+ * SN2 RTC, replacing the ITC based default verion.
+ */
+static void kvm_patch_vmm(struct kvm_vmm_info *vmm_info,
+			  struct module *module)
+{
+	unsigned long new_ar, new_ar_sn2;
+	unsigned long module_base;
+
+	if (!ia64_platform_is("sn2"))
+		return;
+
+	module_base = (unsigned long)module->module_core;
+
+	new_ar = kvm_vmm_base + vmm_info->patch_mov_ar - module_base;
+	new_ar_sn2 = kvm_vmm_base + vmm_info->patch_mov_ar_sn2 - module_base;
+
+	printk(KERN_INFO "kvm: Patching ITC emulation to use SGI SN2 RTC "
+	       "as source\n");
+
+	/*
+	 * Copy the SN2 version of mov_ar into place. They are both
+	 * the same size, so 6 bundles is sufficient (6 * 0x10).
+	 */
+	memcpy((void *)new_ar, (void *)new_ar_sn2, 0x60);
+}
+
 static int kvm_relocate_vmm(struct kvm_vmm_info *vmm_info,
-						struct module *module)
+			    struct module *module)
 {
 	unsigned long module_base;
 	unsigned long vmm_size;
@@ -1694,6 +1723,7 @@ static int kvm_relocate_vmm(struct kvm_vmm_info *vmm_info,
 		return -EFAULT;
 
 	memcpy((void *)kvm_vmm_base, (void *)module_base, vmm_size);
+	kvm_patch_vmm(vmm_info, module);
 	kvm_flush_icache(kvm_vmm_base, vmm_size);
 
 	/*Recalculate kvm_vmm_info based on new VMM*/
diff --git a/arch/ia64/kvm/optvfault.S b/arch/ia64/kvm/optvfault.S
index 32254ce..f793be3 100644
--- a/arch/ia64/kvm/optvfault.S
+++ b/arch/ia64/kvm/optvfault.S
@@ -11,6 +11,7 @@
 
 #include <asm/asmmacro.h>
 #include <asm/processor.h>
+#include <asm/kvm_host.h>
 
 #include "vti.h"
 #include "asm-offsets.h"
@@ -140,6 +141,35 @@ GLOBAL_ENTRY(kvm_asm_mov_from_ar)
 	;;
 END(kvm_asm_mov_from_ar)
 
+/*
+ * Special SGI SN2 optimized version of mov_from_ar using the SN2 RTC
+ * clock as it's source for emulating the ITC. This version will be
+ * copied on top of the original version if the host is determined to
+ * be an SN2.
+ */
+GLOBAL_ENTRY(kvm_asm_mov_from_ar_sn2)
+	add r18=VMM_VCPU_ITC_OFS_OFFSET, r21
+	movl r19 = (KVM_VMM_BASE+(1<<KVM_VMM_SHIFT))
+
+	add r16=VMM_VCPU_LAST_ITC_OFFSET,r21
+	extr.u r17=r25,6,7
+	mov r24=b0
+	;;
+	ld8 r18=[r18]
+	ld8 r19=[r19]
+	addl r20=@gprel(asm_mov_to_reg),gp
+	;;
+	add r19=r19,r18
+	shladd r17=r17,4,r20
+	;;
+	adds r30=kvm_resume_to_guest-asm_mov_to_reg,r20
+	st8 [r16] = r19
+	mov b0=r17
+	br.sptk.few b0
+	;;
+END(kvm_asm_mov_from_ar_sn2)
+
+
 
 // mov r1=rr[r3]
 GLOBAL_ENTRY(kvm_asm_mov_from_rr)
diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
index 9eee5c0..f4b4c89 100644
--- a/arch/ia64/kvm/vmm.c
+++ b/arch/ia64/kvm/vmm.c
@@ -30,15 +30,19 @@ MODULE_AUTHOR("Intel");
 MODULE_LICENSE("GPL");
 
 extern char kvm_ia64_ivt;
+extern char kvm_asm_mov_from_ar;
+extern char kvm_asm_mov_from_ar_sn2;
 extern fpswa_interface_t *vmm_fpswa_interface;
 
 long vmm_sanity = 1;
 
 struct kvm_vmm_info vmm_info = {
-	.module	     = THIS_MODULE,
-	.vmm_entry   = vmm_entry,
-	.tramp_entry = vmm_trampoline,
-	.vmm_ivt     = (unsigned long)&kvm_ia64_ivt,
+	.module			= THIS_MODULE,
+	.vmm_entry		= vmm_entry,
+	.tramp_entry		= vmm_trampoline,
+	.vmm_ivt		= (unsigned long)&kvm_ia64_ivt,
+	.patch_mov_ar		= (unsigned long)&kvm_asm_mov_from_ar,
+	.patch_mov_ar_sn2	= (unsigned long)&kvm_asm_mov_from_ar_sn2,
 };
 
 static int __init  kvm_vmm_init(void)
-- 
1.6.0.6

