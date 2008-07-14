Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYGNShK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYGNShK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYGNSg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:36:57 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:57336 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYGNSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:36:57 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K40ECV-03-9LU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@qumranet.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] allow enabling/disabling NPT by reloading only the architecture module
Date: Mon, 14 Jul 2008 20:36:36 +0200
Message-ID: <1216060596-6224-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 14 Jul 2008 18:36:36.0914 (UTC) FILETIME=[8C49C920:01C8E5E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NPT is enabled after loading both KVM modules on AMD and it should be
disabled, both KVM modules must be reloaded. If only the architecture module is
reloaded the behavior is undefined. With this patch it is possible to disable
NPT only by reloading the kvm_amd module.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |    6 ++++++
 arch/x86/kvm/svm.c         |    3 ++-
 include/asm-x86/kvm_host.h |    1 +
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bcd0adb..6376e50 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1874,6 +1874,12 @@ void kvm_enable_tdp(void)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_tdp);
 
+void kvm_disable_tdp(void)
+{
+	tdp_enabled = false;
+}
+EXPORT_SYMBOL_GPL(kvm_disable_tdp);
+
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0c3320e..09e753f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -452,7 +452,8 @@ static __init int svm_hardware_setup(void)
 	if (npt_enabled) {
 		printk(KERN_INFO "kvm: Nested Paging enabled\n");
 		kvm_enable_tdp();
-	}
+	} else
+		kvm_disable_tdp();
 
 	return 0;
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index b893a85..f760749 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -567,6 +567,7 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
 void kvm_enable_tdp(void);
+void kvm_disable_tdp(void);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
-- 
1.5.3.7


