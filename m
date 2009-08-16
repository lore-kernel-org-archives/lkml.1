Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZHPJgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZHPJgC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZHPJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:35:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45352 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/48] KVM: SVM: Fold kvm_svm.h info svm.c
Date: Sun, 16 Aug 2009 12:29:41 +0300
Message-Id: <1250415008-17175-22-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_svm.h is only included from svm.c, so fold it in.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/kvm_svm.h |   54 ------------------------------------------------
 arch/x86/kvm/svm.c     |   42 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 55 deletions(-)
 delete mode 100644 arch/x86/kvm/kvm_svm.h

diff --git a/arch/x86/kvm/kvm_svm.h b/arch/x86/kvm/kvm_svm.h
deleted file mode 100644
index 39fddc0..0000000
--- a/arch/x86/kvm/kvm_svm.h
+++ /dev/null
@@ -1,54 +0,0 @@
-#ifndef __KVM_SVM_H
-#define __KVM_SVM_H
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/list.h>
-#include <linux/kvm_host.h>
-#include <asm/msr.h>
-
-#include <asm/svm.h>
-
-static const u32 host_save_user_msrs[] = {
-#ifdef CONFIG_X86_64
-	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
-	MSR_FS_BASE,
-#endif
-	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
-};
-
-#define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
-
-struct kvm_vcpu;
-
-struct vcpu_svm {
-	struct kvm_vcpu vcpu;
-	struct vmcb *vmcb;
-	unsigned long vmcb_pa;
-	struct svm_cpu_data *svm_data;
-	uint64_t asid_generation;
-	uint64_t sysenter_cs;
-	uint64_t sysenter_esp;
-	uint64_t sysenter_eip;
-
-	u64 next_rip;
-
-	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
-	u64 host_gs_base;
-	unsigned long host_cr2;
-
-	u32 *msrpm;
-	struct vmcb *hsave;
-	u64 hsave_msr;
-
-	u64 nested_vmcb;
-
-	/* These are the merged vectors */
-	u32 *nested_msrpm;
-
-	/* gpa pointers to the real vectors */
-	u64 nested_vmcb_msrpm;
-};
-
-#endif
-
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index df6e7fb..14a98ab 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -15,7 +15,6 @@
  */
 #include <linux/kvm_host.h>
 
-#include "kvm_svm.h"
 #include "irq.h"
 #include "mmu.h"
 #include "kvm_cache_regs.h"
@@ -57,6 +56,47 @@ MODULE_LICENSE("GPL");
 #define nsvm_printk(fmt, args...) do {} while(0)
 #endif
 
+static const u32 host_save_user_msrs[] = {
+#ifdef CONFIG_X86_64
+	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
+	MSR_FS_BASE,
+#endif
+	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
+};
+
+#define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
+
+struct kvm_vcpu;
+
+struct vcpu_svm {
+	struct kvm_vcpu vcpu;
+	struct vmcb *vmcb;
+	unsigned long vmcb_pa;
+	struct svm_cpu_data *svm_data;
+	uint64_t asid_generation;
+	uint64_t sysenter_cs;
+	uint64_t sysenter_esp;
+	uint64_t sysenter_eip;
+
+	u64 next_rip;
+
+	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
+	u64 host_gs_base;
+	unsigned long host_cr2;
+
+	u32 *msrpm;
+	struct vmcb *hsave;
+	u64 hsave_msr;
+
+	u64 nested_vmcb;
+
+	/* These are the merged vectors */
+	u32 *nested_msrpm;
+
+	/* gpa pointers to the real vectors */
+	u64 nested_vmcb_msrpm;
+};
+
 /* enable NPT for AMD64 and X86 with PAE */
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static bool npt_enabled = true;
-- 
1.6.3.3

