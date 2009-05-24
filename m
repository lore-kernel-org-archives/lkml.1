Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZEXP5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZEXP5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbZEXPxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:53:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 19/45] KVM: Add AMD cpuid bit: cr8_legacy, abm, misaligned sse, sse4, 3dnow prefetch
Date: Sun, 24 May 2009 18:50:04 +0300
Message-Id: <1243180230-2480-20-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   71 +++++++++++++++++++++++++++------------------------
 1 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a403df1..95a2a83 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1243,44 +1243,47 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	entry->flags = 0;
 }
 
+#define F(x) bit(X86_FEATURE_##x)
+
 static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 u32 index, int *nent, int maxnent)
 {
-	const u32 kvm_supported_word0_x86_features = bit(X86_FEATURE_FPU) |
-		bit(X86_FEATURE_VME) | bit(X86_FEATURE_DE) |
-		bit(X86_FEATURE_PSE) | bit(X86_FEATURE_TSC) |
-		bit(X86_FEATURE_MSR) | bit(X86_FEATURE_PAE) |
-		bit(X86_FEATURE_MCE) |
-		bit(X86_FEATURE_CX8) | bit(X86_FEATURE_APIC) |
-		bit(X86_FEATURE_SEP) | bit(X86_FEATURE_MTRR) |
-		bit(X86_FEATURE_PGE) | bit(X86_FEATURE_MCA) |
-		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PAT) |
-		bit(X86_FEATURE_PSE36) |
-		bit(X86_FEATURE_CLFLSH) | bit(X86_FEATURE_MMX) |
-		bit(X86_FEATURE_FXSR) | bit(X86_FEATURE_XMM) |
-		bit(X86_FEATURE_XMM2) | bit(X86_FEATURE_SELFSNOOP);
-	const u32 kvm_supported_word1_x86_features = bit(X86_FEATURE_FPU) |
-		bit(X86_FEATURE_VME) | bit(X86_FEATURE_DE) |
-		bit(X86_FEATURE_PSE) | bit(X86_FEATURE_TSC) |
-		bit(X86_FEATURE_MSR) | bit(X86_FEATURE_PAE) |
-		bit(X86_FEATURE_CX8) | bit(X86_FEATURE_APIC) |
-		bit(X86_FEATURE_PGE) |
-		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PSE36) |
-		bit(X86_FEATURE_MMX) | bit(X86_FEATURE_FXSR) |
-		bit(X86_FEATURE_SYSCALL) |
-		(is_efer_nx() ? bit(X86_FEATURE_NX) : 0) |
+	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
 #ifdef CONFIG_X86_64
-		bit(X86_FEATURE_LM) |
+	unsigned f_lm = F(LM);
+#else
+	unsigned f_lm = 0;
 #endif
-		bit(X86_FEATURE_FXSR_OPT) |
-		bit(X86_FEATURE_MMXEXT) |
-		bit(X86_FEATURE_3DNOWEXT) |
-		bit(X86_FEATURE_3DNOW);
-	const u32 kvm_supported_word3_x86_features =
-		bit(X86_FEATURE_XMM3) | bit(X86_FEATURE_CX16);
+
+	/* cpuid 1.edx */
+	const u32 kvm_supported_word0_x86_features =
+		F(FPU) | F(VME) | F(DE) | F(PSE) |
+		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
+		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
+		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
+		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLSH) |
+		0 /* Reserved, DS, ACPI */ | F(MMX) |
+		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
+		0 /* HTT, TM, Reserved, PBE */;
+	/* cpuid 0x80000001.edx */
+	const u32 kvm_supported_word1_x86_features =
+		F(FPU) | F(VME) | F(DE) | F(PSE) |
+		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
+		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
+		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
+		F(PAT) | F(PSE36) | 0 /* Reserved */ |
+		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
+		F(FXSR) | F(FXSR_OPT) | 0 /* GBPAGES */ | 0 /* RDTSCP */ |
+		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
+	/* cpuid 1.ecx */
+	const u32 kvm_supported_word4_x86_features =
+		F(XMM3) | F(CX16);
+	/* cpuid 0x80000001.ecx */
 	const u32 kvm_supported_word6_x86_features =
-		bit(X86_FEATURE_LAHF_LM) | bit(X86_FEATURE_CMP_LEGACY) |
-		bit(X86_FEATURE_SVM);
+		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
+		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
+		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
+		0 /* SKINIT */ | 0 /* WDT */;
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
@@ -1293,7 +1296,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	case 1:
 		entry->edx &= kvm_supported_word0_x86_features;
-		entry->ecx &= kvm_supported_word3_x86_features;
+		entry->ecx &= kvm_supported_word4_x86_features;
 		break;
 	/* function 2 entries are STATEFUL. That is, repeated cpuid commands
 	 * may return different values. This forces us to get_cpu() before
@@ -1355,6 +1358,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	put_cpu();
 }
 
+#undef F
+
 static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 				     struct kvm_cpuid_entry2 __user *entries)
 {
-- 
1.6.0.6

