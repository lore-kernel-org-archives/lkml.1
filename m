Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYCaOoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYCaOoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYCaOhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:43 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51306
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYCaOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 23/40] KVM: export information about NPT to generic x86 code
Date: Mon, 31 Mar 2008 17:37:07 +0300
Message-Id: <1206974244-9716-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The generic x86 code has to know if the specific implementation uses Nested
Paging. In the generic code Nested Paging is called Two Dimensional Paging
(TDP) to avoid confusion with (future) TDP implementations of other vendors.
This patch exports the availability of TDP to the generic x86 code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   15 +++++++++++++++
 arch/x86/kvm/svm.c         |    4 +++-
 include/asm-x86/kvm_host.h |    2 ++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6651dfa..21cfa28 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -32,6 +32,15 @@
 #include <asm/cmpxchg.h>
 #include <asm/io.h>
 
+/*
+ * When setting this variable to true it enables Two-Dimensional-Paging
+ * where the hardware walks 2 page tables:
+ * 1. the guest-virtual to guest-physical
+ * 2. while doing 1. it walks guest-physical to host-physical
+ * If the hardware supports that we don't need to do shadow paging.
+ */
+static bool tdp_enabled = false;
+
 #undef MMU_DEBUG
 
 #undef AUDIT
@@ -1582,6 +1591,12 @@ out:
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
+void kvm_enable_tdp(void)
+{
+	tdp_enabled = true;
+}
+EXPORT_SYMBOL_GPL(kvm_enable_tdp);
+
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fb5d6c2..9e29a13 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -426,8 +426,10 @@ static __init int svm_hardware_setup(void)
 		npt_enabled = false;
 	}
 
-	if (npt_enabled)
+	if (npt_enabled) {
 		printk(KERN_INFO "kvm: Nested Paging enabled\n");
+		kvm_enable_tdp();
+	}
 
 	return 0;
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 92668fa..15fb2e8 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -492,6 +492,8 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
+void kvm_enable_tdp(void);
+
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
 
-- 
1.5.4.5

