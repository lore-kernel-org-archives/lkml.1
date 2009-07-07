Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbZGGQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbZGGQmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZGGQlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:41:46 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53570 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbZGGQlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:41:44 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KMF7OV-03-MPJ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/6] kvm x86: report 1GB page support to userspace
Date: Tue, 7 Jul 2009 18:41:07 +0200
Message-ID: <1246984867-15952-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
References: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Jul 2009 16:41:16.0428 (UTC) FILETIME=[BF3DECC0:01C9FF21]
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
index be2315b..f1f9149 100644
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
index fc14bdf..b0fc342 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2755,6 +2755,11 @@ static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ -1, NULL }
 };
 
+static bool svm_gb_page_enable(void)
+{
+	return npt_enabled;
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
index 3a75db3..02529fb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3903,6 +3903,11 @@ static const struct trace_print_flags vmx_exit_reasons_str[] = {
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
@@ -3964,6 +3969,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.exit_reasons_str = vmx_exit_reasons_str,
+	.gb_page_enable = vmx_gb_page_enable,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95fa45c..ae9017b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1450,6 +1450,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 u32 index, int *nent, int maxnent)
 {
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
+	unsigned f_gbpages = kvm_x86_ops->gb_page_enable() ? F(GBPAGES) : 0;
 #ifdef CONFIG_X86_64
 	unsigned f_lm = F(LM);
 #else
@@ -1474,7 +1475,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
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


