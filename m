Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbYAFOmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbYAFOmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbYAFOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:46605 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 05/33] KVM: Portability: Split mmu-related static inline functions to mmu.h
Date: Sun,  6 Jan 2008 16:39:11 +0200
Message-Id: <1199630379-28638-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Since these functions need to know the details of kvm or kvm_vcpu structure,
it can't be put in x86.h.  Create mmu.h to hold them.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 +
 drivers/kvm/mmu.c |    1 +
 drivers/kvm/mmu.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/svm.c |    1 +
 drivers/kvm/vmx.c |    1 +
 drivers/kvm/x86.c |    7 +++++++
 drivers/kvm/x86.h |   44 --------------------------------------------
 7 files changed, 55 insertions(+), 44 deletions(-)
 create mode 100644 drivers/kvm/mmu.h

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 668a830..c040bb3 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -396,6 +396,7 @@ void kvm_arch_hardware_disable(void *garbage);
 int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index da1dedb..1dc0e8c 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -20,6 +20,7 @@
 #include "vmx.h"
 #include "kvm.h"
 #include "x86.h"
+#include "mmu.h"
 
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/drivers/kvm/mmu.h b/drivers/kvm/mmu.h
new file mode 100644
index 0000000..9ebfd1c
--- /dev/null
+++ b/drivers/kvm/mmu.h
@@ -0,0 +1,44 @@
+#ifndef __KVM_X86_MMU_H
+#define __KVM_X86_MMU_H
+
+#include "kvm.h"
+
+static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
+		__kvm_mmu_free_some_pages(vcpu);
+}
+
+static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
+{
+	if (likely(vcpu->arch.mmu.root_hpa != INVALID_PAGE))
+		return 0;
+
+	return kvm_mmu_load(vcpu);
+}
+
+static inline int is_long_mode(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_X86_64
+	return vcpu->arch.shadow_efer & EFER_LME;
+#else
+	return 0;
+#endif
+}
+
+static inline int is_pae(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.cr4 & X86_CR4_PAE;
+}
+
+static inline int is_pse(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.cr4 & X86_CR4_PSE;
+}
+
+static inline int is_paging(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.cr0 & X86_CR0_PG;
+}
+
+#endif
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 6c100b1..35ad96d 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -17,6 +17,7 @@
 #include "kvm_svm.h"
 #include "x86_emulate.h"
 #include "irq.h"
+#include "mmu.h"
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index e26e299..456eb9c 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -21,6 +21,7 @@
 #include "irq.h"
 #include "vmx.h"
 #include "segment_descriptor.h"
+#include "mmu.h"
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 5a2f33a..60f9722 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -19,6 +19,7 @@
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
 #include "irq.h"
+#include "mmu.h"
 
 #include <linux/kvm.h>
 #include <linux/fs.h>
@@ -3139,3 +3140,9 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 
 	return 0;
 }
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE
+	       || vcpu->arch.mp_state == VCPU_MP_STATE_SIPI_RECEIVED;
+}
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 0e01ac7..0da4be9 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -334,44 +334,6 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
-static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
-{
-	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-		__kvm_mmu_free_some_pages(vcpu);
-}
-
-static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
-{
-	if (likely(vcpu->arch.mmu.root_hpa != INVALID_PAGE))
-		return 0;
-
-	return kvm_mmu_load(vcpu);
-}
-
-static inline int is_long_mode(struct kvm_vcpu *vcpu)
-{
-#ifdef CONFIG_X86_64
-	return vcpu->arch.shadow_efer & EFER_LME;
-#else
-	return 0;
-#endif
-}
-
-static inline int is_pae(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.cr4 & X86_CR4_PAE;
-}
-
-static inline int is_pse(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.cr4 & X86_CR4_PSE;
-}
-
-static inline int is_paging(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.cr0 & X86_CR0_PG;
-}
-
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
 
@@ -490,10 +452,4 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
-static inline int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE
-	       || vcpu->arch.mp_state == VCPU_MP_STATE_SIPI_RECEIVED;
-}
-
 #endif
-- 
1.5.3.7

