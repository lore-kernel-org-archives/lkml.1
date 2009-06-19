Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZFSNS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZFSNS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbZFSNRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:17:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47944 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbZFSNRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:17:00 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KLHM7S-03-BJ6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/8] kvm x86: report 1GB page support to userspace
Date: Fri, 19 Jun 2009 15:16:29 +0200
Message-ID: <1245417389-5527-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jun 2009 13:16:38.0787 (UTC) FILETIME=[2DC31530:01C9F0E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If userspace knows that the kernel part supports 1GB pages it can enable
the corresponding cpuid bit so that guests actually use GB pages.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |    3 ++-
 4 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26ea9b8..c120882 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -527,6 +527,7 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	bool (*gb_page_enable)(void);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c283201..ccb75fb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2718,6 +2718,11 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return 0;
 }
 
+static bool svm_gb_page_enable(void)
+{
+	return npt_enabled;
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -2779,6 +2784,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
 	.get_mt_mask = svm_get_mt_mask,
+	.gb_page_enable = svm_gb_page_enable,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9332938..4418ba6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3891,6 +3891,11 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return ret;
 }
 
+static bool vmx_gb_page_enable(void)
+{
+	return false;
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -3950,6 +3955,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
 	.get_mt_mask = vmx_get_mt_mask,
+	.gb_page_enable = vmx_gb_page_enable,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 71090d2..ddfb77e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1371,6 +1371,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 u32 index, int *nent, int maxnent)
 {
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
+	unsigned f_gbpages = kvm_x86_ops->gb_page_enable() ? F(GBPAGES) : 0;
 #ifdef CONFIG_X86_64
 	unsigned f_lm = F(LM);
 #else
@@ -1395,7 +1396,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* Reserved */ |
 		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
-		F(FXSR) | F(FXSR_OPT) | 0 /* GBPAGES */ | 0 /* RDTSCP */ |
+		F(FXSR) | F(FXSR_OPT) | f_gbpages | 0 /* RDTSCP */ |
 		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
 	/* cpuid 1.ecx */
 	const u32 kvm_supported_word4_x86_features =
-- 
1.6.3.1


