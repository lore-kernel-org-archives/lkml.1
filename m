Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0BMIC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:02:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/39] KVM: VMX: Enable EPT 1GB page support
Date: Sat, 13 Feb 2010 10:01:24 +0200
Message-Id: <1266048119-14325-5-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/vmx.h |    1 +
 arch/x86/kvm/mmu.c         |    8 +++++---
 arch/x86/kvm/vmx.c         |   11 ++++++++++-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 713ed9a..43f1e9b 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -364,6 +364,7 @@ enum vmcs_field {
 #define VMX_EPTP_UC_BIT				(1ull << 8)
 #define VMX_EPTP_WB_BIT				(1ull << 14)
 #define VMX_EPT_2MB_PAGE_BIT			(1ull << 16)
+#define VMX_EPT_1GB_PAGE_BIT			(1ull << 17)
 #define VMX_EPT_EXTENT_INDIVIDUAL_BIT		(1ull << 24)
 #define VMX_EPT_EXTENT_CONTEXT_BIT		(1ull << 25)
 #define VMX_EPT_EXTENT_GLOBAL_BIT		(1ull << 26)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 12ccf14..4f5508c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -500,8 +500,7 @@ out:
 static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 {
 	struct kvm_memory_slot *slot;
-	int host_level;
-	int level = PT_PAGE_TABLE_LEVEL;
+	int host_level, level, max_level;
 
 	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
 	if (slot && slot->dirty_bitmap)
@@ -512,7 +511,10 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	if (host_level == PT_PAGE_TABLE_LEVEL)
 		return host_level;
 
-	for (level = PT_DIRECTORY_LEVEL; level <= host_level; ++level)
+	max_level = kvm_x86_ops->get_lpage_level() < host_level ?
+		kvm_x86_ops->get_lpage_level() : host_level;
+
+	for (level = PT_DIRECTORY_LEVEL; level <= max_level; ++level)
 		if (has_wrprotected_page(vcpu->kvm, large_gfn, level))
 			break;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0fd0892..9b197b2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -318,6 +318,11 @@ static inline bool cpu_has_vmx_ept_2m_page(void)
 	return !!(vmx_capability.ept & VMX_EPT_2MB_PAGE_BIT);
 }
 
+static inline bool cpu_has_vmx_ept_1g_page(void)
+{
+	return !!(vmx_capability.ept & VMX_EPT_1GB_PAGE_BIT);
+}
+
 static inline int cpu_has_vmx_invept_individual_addr(void)
 {
 	return !!(vmx_capability.ept & VMX_EPT_EXTENT_INDIVIDUAL_BIT);
@@ -4038,7 +4043,11 @@ static const struct trace_print_flags vmx_exit_reasons_str[] = {
 
 static int vmx_get_lpage_level(void)
 {
-	return PT_DIRECTORY_LEVEL;
+	if (enable_ept && !cpu_has_vmx_ept_1g_page())
+		return PT_DIRECTORY_LEVEL;
+	else
+		/* For shadow and EPT supported 1GB page */
+		return PT_PDPE_LEVEL;
 }
 
 static inline u32 bit(int bitno)
-- 
1.6.5.3

