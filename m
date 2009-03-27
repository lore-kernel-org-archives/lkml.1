Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZC0Od7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZC0Od7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbZC0Oca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:32:30 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:30487
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754451AbZC0OcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:32:24 -0400
X-BigFish: VPS1(zzzz1202hzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KH65PI-01-IGX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] kvm x86: report 1GB page support to userspace
Date: Fri, 27 Mar 2009 15:31:59 +0100
Message-ID: <1238164319-16092-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0634 (UTC) FILETIME=[CA4B2DA0:01C9AEE8]
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
 arch/x86/kvm/svm.c              |    7 +++++++
 arch/x86/kvm/vmx.c              |    7 +++++++
 arch/x86/kvm/x86.c              |    6 +++++-
 include/linux/kvm.h             |    1 +
 5 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a1df2a3..6593198 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -542,6 +542,8 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	int (*get_mt_mask_shift)(void);
+
+	bool (*gb_page_enable)(void);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1fcbc17..d140686 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2604,6 +2604,11 @@ static int svm_get_mt_mask_shift(void)
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
@@ -2661,6 +2666,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
 	.get_mt_mask_shift = svm_get_mt_mask_shift,
+
+	.gb_page_enable = svm_gb_page_enable,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 37ae13d..e54af3f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3647,6 +3647,11 @@ static int vmx_get_mt_mask_shift(void)
 	return VMX_EPT_MT_EPTE_SHIFT;
 }
 
+static bool vmx_gb_page_enable(void)
+{
+	return false;
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -3702,6 +3707,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
 	.get_mt_mask_shift = vmx_get_mt_mask_shift,
+
+	.gb_page_enable = vmx_gb_page_enable,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ae4918c..c94f231 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1009,7 +1009,7 @@ out:
 
 int kvm_dev_ioctl_check_extension(long ext)
 {
-	int r;
+	int r = 0;
 
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
@@ -1027,6 +1027,10 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 		r = 1;
 		break;
+	case KVM_CAP_1GB_PAGES:
+		if (kvm_x86_ops->gb_page_enable())
+			r = 1;
+		break;
 	case KVM_CAP_COALESCED_MMIO:
 		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ee755e2..e79eb26 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -413,6 +413,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_DEVICE_MSIX 28
 #endif
 #define KVM_CAP_ASSIGN_DEV_IRQ 29
+#define KVM_CAP_1GB_PAGES 30
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.5.6.4


