Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbZHSNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbZHSNMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZHSNMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:12:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50557 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751922AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/47] KVM: VMX: conditionally disable 2M pages
Date: Wed, 19 Aug 2009 16:02:09 +0300
Message-Id: <1250686963-8357-14-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Disable usage of 2M pages if VMX_EPT_2MB_PAGE_BIT (bit 16) is clear
in MSR_IA32_VMX_EPT_VPID_CAP and EPT is enabled.

[avi: s/largepages_disabled/largepages_enabled/ to avoid negative logic]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c       |    3 +++
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   14 ++++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 94c07ad..fc8d49c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1381,6 +1381,9 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_tpr_shadow())
 		kvm_x86_ops->update_cr8_intercept = NULL;
 
+	if (enable_ept && !cpu_has_vmx_ept_2m_page())
+		kvm_disable_largepages();
+
 	return alloc_kvm_area();
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c6e4d02..6988858 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -224,6 +224,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
 				int user_alloc);
+void kvm_disable_largepages(void);
 void kvm_arch_flush_shadow(struct kvm *kvm);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 777fe53..48d5e69 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -85,6 +85,8 @@ static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 
 static bool kvm_rebooting;
 
+static bool largepages_enabled = true;
+
 #ifdef KVM_CAP_DEVICE_ASSIGNMENT
 static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
 						      int assigned_dev_id)
@@ -1174,9 +1176,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		ugfn = new.userspace_addr >> PAGE_SHIFT;
 		/*
 		 * If the gfn and userspace address are not aligned wrt each
-		 * other, disable large page support for this slot
+		 * other, or if explicitly asked to, disable large page
+		 * support for this slot
 		 */
-		if ((base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE - 1))
+		if ((base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE - 1) ||
+		    !largepages_enabled)
 			for (i = 0; i < largepages; ++i)
 				new.lpage_info[i].write_count = 1;
 	}
@@ -1291,6 +1295,12 @@ out:
 	return r;
 }
 
+void kvm_disable_largepages(void)
+{
+	largepages_enabled = false;
+}
+EXPORT_SYMBOL_GPL(kvm_disable_largepages);
+
 int is_error_page(struct page *page)
 {
 	return page == bad_page;
-- 
1.6.3.3

