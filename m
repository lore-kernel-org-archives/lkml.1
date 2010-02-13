Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0BMIK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:10:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/39] KVM: x86: Rename gb_page_enable() to get_lpage_level() in kvm_x86_ops
Date: Sat, 13 Feb 2010 10:01:23 +0200
Message-Id: <1266048119-14325-4-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Then the callback can provide the maximum supported large page level, which
is more flexible.

Also move the gb page support into x86_64 specific.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/svm.c              |    6 +++---
 arch/x86/kvm/vmx.c              |    6 +++---
 arch/x86/kvm/x86.c              |    4 +++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 741b897..a4de557 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -528,7 +528,7 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
-	bool (*gb_page_enable)(void);
+	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
 
 	const struct trace_print_flags *exit_reasons_str;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b373ae6..cf64fc0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2911,9 +2911,9 @@ static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ -1, NULL }
 };
 
-static bool svm_gb_page_enable(void)
+static int svm_get_lpage_level(void)
 {
-	return true;
+	return PT_PDPE_LEVEL;
 }
 
 static bool svm_rdtscp_supported(void)
@@ -2986,7 +2986,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.get_mt_mask = svm_get_mt_mask,
 
 	.exit_reasons_str = svm_exit_reasons_str,
-	.gb_page_enable = svm_gb_page_enable,
+	.get_lpage_level = svm_get_lpage_level,
 
 	.cpuid_update = svm_cpuid_update,
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f4486f4..0fd0892 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4036,9 +4036,9 @@ static const struct trace_print_flags vmx_exit_reasons_str[] = {
 
 #undef _ER
 
-static bool vmx_gb_page_enable(void)
+static int vmx_get_lpage_level(void)
 {
-	return false;
+	return PT_DIRECTORY_LEVEL;
 }
 
 static inline u32 bit(int bitno)
@@ -4131,7 +4131,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.exit_reasons_str = vmx_exit_reasons_str,
-	.gb_page_enable = vmx_gb_page_enable,
+	.get_lpage_level = vmx_get_lpage_level,
 
 	.cpuid_update = vmx_cpuid_update,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aff3479..c990424 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1641,10 +1641,12 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 u32 index, int *nent, int maxnent)
 {
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
-	unsigned f_gbpages = kvm_x86_ops->gb_page_enable() ? F(GBPAGES) : 0;
 #ifdef CONFIG_X86_64
+	unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
+				? F(GBPAGES) : 0;
 	unsigned f_lm = F(LM);
 #else
+	unsigned f_gbpages = 0;
 	unsigned f_lm = 0;
 #endif
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
-- 
1.6.5.3

