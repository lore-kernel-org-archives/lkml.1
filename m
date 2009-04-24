Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbZDXMAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbZDXMAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZDXL7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:59:11 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:51457
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754939AbZDXL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:59:04 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KILTA3-02-NGW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.or>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] kvm x86: report 1GB page support to userspace
Date: Fri, 24 Apr 2009 13:58:47 +0200
Message-ID: <1240574327-21575-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Apr 2009 11:58:48.0409 (UTC) FILETIME=[06DDF490:01C9C4D4]
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
index 6215d10..6318d22 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -524,6 +524,8 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	int (*get_mt_mask_shift)(void);
+
+	bool (*gb_page_enable)(void);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 053f3c5..0b641c5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2622,6 +2622,11 @@ static int svm_get_mt_mask_shift(void)
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
@@ -2679,6 +2684,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
 	.get_mt_mask_shift = svm_get_mt_mask_shift,
+
+	.gb_page_enable = svm_gb_page_enable,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c6997c0..a1baf52 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3683,6 +3683,11 @@ static int vmx_get_mt_mask_shift(void)
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
@@ -3738,6 +3743,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
 	.get_mt_mask_shift = vmx_get_mt_mask_shift,
+
+	.gb_page_enable = vmx_gb_page_enable,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8cb8542..dec5af3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1011,7 +1011,7 @@ out:
 
 int kvm_dev_ioctl_check_extension(long ext)
 {
-	int r;
+	int r = 0;
 
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
@@ -1029,6 +1029,10 @@ int kvm_dev_ioctl_check_extension(long ext)
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
index 3db5d8d..958c582 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -415,6 +415,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_ASSIGN_DEV_IRQ 29
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
+#define KVM_CAP_1GB_PAGES 31
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.6.2.3


