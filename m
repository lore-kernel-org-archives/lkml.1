Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbXIQI61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbXIQI61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXIQIdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:45309 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 084/104] KVM: Clean up unloved invlpg emulation
Date: Mon, 17 Sep 2007 10:32:06 +0200
Message-Id: <11900179492313-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

invlpg shouldn't fetch the "src" address, since it may not be valid,
however SVM's "solution" which neuters emulation of all group 7
instruction is horrible and breaks kvm-lite.  The simplest fix is to
put a special check in for invlpg.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    2 --
 drivers/kvm/svm.c         |    2 --
 drivers/kvm/x86_emulate.c |   16 +++-------------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 7c35352..9bf9ac6 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -539,8 +539,6 @@ static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
 hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva);
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 
-void kvm_emulator_want_group7_invlpg(void);
-
 extern hpa_t bad_page_address;
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index dbd4e81..e51f6b7 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -376,8 +376,6 @@ static __init int svm_hardware_setup(void)
 	void *iopm_va, *msrpm_va;
 	int r;
 
-	kvm_emulator_want_group7_invlpg();
-
 	iopm_pages = alloc_pages(GFP_KERNEL, IOPM_ALLOC_ORDER);
 
 	if (!iopm_pages)
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 7439b34..342594d 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -213,19 +213,6 @@ static u16 twobyte_table[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
-/*
- * Tell the emulator that of the Group 7 instructions (sgdt, lidt, etc.) we
- * are interested only in invlpg and not in any of the rest.
- *
- * invlpg is a special instruction in that the data it references may not
- * be mapped.
- */
-void kvm_emulator_want_group7_invlpg(void)
-{
-	twobyte_table[1] &= ~SrcMem;
-}
-EXPORT_SYMBOL_GPL(kvm_emulator_want_group7_invlpg);
-
 /* Type, address-of, and value of an instruction's operand. */
 struct operand {
 	enum { OP_REG, OP_MEM, OP_IMM } type;
@@ -791,6 +778,9 @@ done_prefixes:
 		goto srcmem_common;
 	case SrcMem:
 		src.bytes = (d & ByteOp) ? 1 : op_bytes;
+		/* Don't fetch the address for invlpg: it could be unmapped. */
+		if (twobyte && b == 0x01 && modrm_reg == 7)
+			break;
 	      srcmem_common:
 		src.type = OP_MEM;
 		src.ptr = (unsigned long *)cr2;
-- 
1.5.3

