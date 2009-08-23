Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZHWL5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZHWL5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933512AbZHWL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:57:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933563AbZHWL4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:51 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 46/46] KVM: report 1GB page support to userspace
Date: Sun, 23 Aug 2009 14:56:45 +0300
Message-Id: <1251028605-31977-47-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

If userspace knows that the kernel part supports 1GB pages it can enable
the corresponding cpuid bit so that guests actually use GB pages.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |    3 ++-
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3315efa..b17d845 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -528,6 +528,8 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	bool (*gb_page_enable)(void);
+
 	const struct trace_print_flags *exit_reasons_str;
 };
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 92fc0da..10e718d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2754,6 +2754,11 @@ static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ -1, NULL }
 };
 
+static bool svm_gb_page_enable(void)
+{
+	return true;
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -2817,6 +2822,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.get_mt_mask = svm_get_mt_mask,
 
 	.exit_reasons_str = svm_exit_reasons_str,
+	.gb_page_enable = svm_gb_page_enable,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c5aaa1b..32e6d20 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3908,6 +3908,11 @@ static const struct trace_print_flags vmx_exit_reasons_str[] = {
 	{ -1, NULL }
 };
 
+static bool vmx_gb_page_enable(void)
+{
+	return false;
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -3969,6 +3974,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.exit_reasons_str = vmx_exit_reasons_str,
+	.gb_page_enable = vmx_gb_page_enable,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d1bcc59..b407d3c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1444,6 +1444,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 u32 index, int *nent, int maxnent)
 {
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
+	unsigned f_gbpages = kvm_x86_ops->gb_page_enable() ? F(GBPAGES) : 0;
 #ifdef CONFIG_X86_64
 	unsigned f_lm = F(LM);
 #else
@@ -1468,7 +1469,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* Reserved */ |
 		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
-		F(FXSR) | F(FXSR_OPT) | 0 /* GBPAGES */ | 0 /* RDTSCP */ |
+		F(FXSR) | F(FXSR_OPT) | f_gbpages | 0 /* RDTSCP */ |
 		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
 	/* cpuid 1.ecx */
 	const u32 kvm_supported_word4_x86_features =
-- 
1.6.4.1

