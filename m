Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbYBGMuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbYBGMuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759416AbYBGMsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:43 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40685 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987AbYBGMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:26 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 4/8] X86: export information about NPT to generic x86
 code
Date: Thu,  7 Feb 2008 13:47:41 +0100
Message-ID: <1202388465-8657-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0720 (UTC)
 FILETIME=[A30E8B80:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB421852IW10730680-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic x86 code has to know if the specific implementation uses Nested
Paging. In the generic code Nested Paging is called Two Dimensional Paging
(TDP) to avoid confusion with (future) TDP implementations of other vendors.
This patch exports the availability of TDP to the generic x86 code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |   15 +++++++++++++++
 arch/x86/kvm/svm.c         |    4 +++-
 include/asm-x86/kvm_host.h |    2 ++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 635e70c..3477395 100644
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
@@ -1562,6 +1571,12 @@ out:
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
index 8173ba6..f400499 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -423,8 +423,10 @@ static __init int svm_hardware_setup(void)
 		npt_enabled = false;
 	}
 
-	if (npt_enabled)
+	if (npt_enabled) {
 		printk(KERN_INFO "kvm: Nested Paging enabled\n");
+		kvm_enable_tdp();
+	}
 
 	return 0;
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 67ae307..7661da0 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -491,6 +491,8 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
+void kvm_enable_tdp(void);
+
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
 
-- 
1.5.3.7



