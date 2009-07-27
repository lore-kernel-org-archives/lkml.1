Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZG0OgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZG0OgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZG0OgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:36:05 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:11981 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752023AbZG0OgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:36:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-WSS-ID: 0KNG2ZF-03-X0E-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] kvm x86: report 1GB page support to userspace
Date: Mon, 27 Jul 2009 16:30:48 +0200
Message-ID: <1248705048-22607-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
References: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Jul 2009 14:30:51.0036 (UTC) FILETIME=[D734DDC0:01CA0EC6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If userspace knows that the kernel part supports 1GB pages it can enable
the corresponding cpuid bit so that guests actually use GB pages.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
index b720b02..70e81f5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2755,6 +2755,11 @@ static const struct trace_print_flags svm_exit_reasons_str[] = {
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
@@ -2818,6 +2823,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.get_mt_mask = svm_get_mt_mask,
 
 	.exit_reasons_str = svm_exit_reasons_str,
+	.gb_page_enable = svm_gb_page_enable,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7931c72..bf12865 100644
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
index 2539e9a..bbdc34d 100644
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
1.6.3.3


