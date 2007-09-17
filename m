Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbXIQJJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbXIQJJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXIQIeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:45258 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 011/104] KVM: Use standard CR3 flags, tighten checking
Date: Mon, 17 Sep 2007 10:30:53 +0200
Message-Id: <1190017946110-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

The kernel now has asm/cpu-features.h: use those macros instead of inventing
our own.

Also spell out definition of CR3_RESEVED_BITS, fix spelling and
tighten it for the non-PAE case.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    9 +++------
 drivers/kvm/kvm_main.c    |   33 +++++++++++++++++++++------------
 drivers/kvm/paging_tmpl.h |    2 +-
 3 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 7117c3b..983c33f 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -19,12 +19,9 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
-#define CR3_WPT_MASK (1ULL << 3)
-#define CR3_PCD_MASK (1ULL << 4)
-
-#define CR3_RESEVED_BITS 0x07ULL
-#define CR3_L_MODE_RESEVED_BITS (~((1ULL << 40) - 1) | 0x0fe7ULL)
-#define CR3_FLAGS_MASK ((1ULL << 5) - 1)
+#define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
+#define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
+#define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
 
 #define CR4_VME_MASK (1ULL << 0)
 #define CR4_PSE_MASK (1ULL << 4)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5d8febe..34a571d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -571,23 +571,32 @@ EXPORT_SYMBOL_GPL(set_cr4);
 void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	if (is_long_mode(vcpu)) {
-		if (cr3 & CR3_L_MODE_RESEVED_BITS) {
+		if (cr3 & CR3_L_MODE_RESERVED_BITS) {
 			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
 			inject_gp(vcpu);
 			return;
 		}
 	} else {
-		if (cr3 & CR3_RESEVED_BITS) {
-			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
-			inject_gp(vcpu);
-			return;
-		}
-		if (is_paging(vcpu) && is_pae(vcpu) &&
-		    !load_pdptrs(vcpu, cr3)) {
-			printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
-			       "reserved bits\n");
-			inject_gp(vcpu);
-			return;
+		if (is_pae(vcpu)) {
+			if (cr3 & CR3_PAE_RESERVED_BITS) {
+				printk(KERN_DEBUG
+				       "set_cr3: #GP, reserved bits\n");
+				inject_gp(vcpu);
+				return;
+			}
+			if (is_paging(vcpu) && !load_pdptrs(vcpu, cr3)) {
+				printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
+				       "reserved bits\n");
+				inject_gp(vcpu);
+				return;
+			}
+		} else {
+			if (cr3 & CR3_NONPAE_RESERVED_BITS) {
+				printk(KERN_DEBUG
+				       "set_cr3: #GP, reserved bits\n");
+				inject_gp(vcpu);
+				return;
+			}
 		}
 	}
 
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 4b5391c..01901ec 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -99,7 +99,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	walker->table = kmap_atomic(pfn_to_page(hpa >> PAGE_SHIFT), KM_USER0);
 
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
-	       (vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) == 0);
+	       (vcpu->cr3 & CR3_NONPAE_RESERVED_BITS) == 0);
 
 	walker->inherited_ar = PT_USER_MASK | PT_WRITABLE_MASK;
 
-- 
1.5.3

