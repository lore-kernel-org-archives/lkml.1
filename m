Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbXIQJDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbXIQJDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXIQId5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:45245 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 036/104] KVM: Remove kvm_{read,write}_guest()
Date: Mon, 17 Sep 2007 10:31:18 +0200
Message-Id: <11900179473780-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

... in favor of the more general emulator_{read,write}_*.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   17 +++++------
 drivers/kvm/kvm_main.c |   74 ++---------------------------------------------
 drivers/kvm/svm.c      |    3 +-
 drivers/kvm/vmx.c      |   19 +++++++-----
 4 files changed, 25 insertions(+), 88 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1072c83..030b93b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -561,15 +561,14 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 
-int kvm_read_guest(struct kvm_vcpu *vcpu,
-	       gva_t addr,
-	       unsigned long size,
-	       void *dest);
-
-int kvm_write_guest(struct kvm_vcpu *vcpu,
-		gva_t addr,
-		unsigned long size,
-		void *data);
+int emulator_read_std(unsigned long addr,
+                      void *val,
+		      unsigned int bytes,
+		      struct kvm_vcpu *vcpu);
+int emulator_write_emulated(unsigned long addr,
+			    const void *val,
+			    unsigned int bytes,
+			    struct kvm_vcpu *vcpu);
 
 unsigned long segment_base(u16 selector);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a65a145..4bbd89e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -146,74 +146,6 @@ static inline int valid_vcpu(int n)
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
 }
 
-int kvm_read_guest(struct kvm_vcpu *vcpu, gva_t addr, unsigned long size,
-		   void *dest)
-{
-	unsigned char *host_buf = dest;
-	unsigned long req_size = size;
-
-	while (size) {
-		hpa_t paddr;
-		unsigned now;
-		unsigned offset;
-		hva_t guest_buf;
-
-		paddr = gva_to_hpa(vcpu, addr);
-
-		if (is_error_hpa(paddr))
-			break;
-
-		guest_buf = (hva_t)kmap_atomic(
-					pfn_to_page(paddr >> PAGE_SHIFT),
-					KM_USER0);
-		offset = addr & ~PAGE_MASK;
-		guest_buf |= offset;
-		now = min(size, PAGE_SIZE - offset);
-		memcpy(host_buf, (void*)guest_buf, now);
-		host_buf += now;
-		addr += now;
-		size -= now;
-		kunmap_atomic((void *)(guest_buf & PAGE_MASK), KM_USER0);
-	}
-	return req_size - size;
-}
-EXPORT_SYMBOL_GPL(kvm_read_guest);
-
-int kvm_write_guest(struct kvm_vcpu *vcpu, gva_t addr, unsigned long size,
-		    void *data)
-{
-	unsigned char *host_buf = data;
-	unsigned long req_size = size;
-
-	while (size) {
-		hpa_t paddr;
-		unsigned now;
-		unsigned offset;
-		hva_t guest_buf;
-		gfn_t gfn;
-
-		paddr = gva_to_hpa(vcpu, addr);
-
-		if (is_error_hpa(paddr))
-			break;
-
-		gfn = vcpu->mmu.gva_to_gpa(vcpu, addr) >> PAGE_SHIFT;
-		mark_page_dirty(vcpu->kvm, gfn);
-		guest_buf = (hva_t)kmap_atomic(
-				pfn_to_page(paddr >> PAGE_SHIFT), KM_USER0);
-		offset = addr & ~PAGE_MASK;
-		guest_buf |= offset;
-		now = min(size, PAGE_SIZE - offset);
-		memcpy((void*)guest_buf, host_buf, now);
-		host_buf += now;
-		addr += now;
-		size -= now;
-		kunmap_atomic((void *)(guest_buf & PAGE_MASK), KM_USER0);
-	}
-	return req_size - size;
-}
-EXPORT_SYMBOL_GPL(kvm_write_guest);
-
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->fpu_active || vcpu->guest_fpu_loaded)
@@ -1017,7 +949,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	}
 }
 
-static int emulator_read_std(unsigned long addr,
+int emulator_read_std(unsigned long addr,
 			     void *val,
 			     unsigned int bytes,
 			     struct kvm_vcpu *vcpu)
@@ -1051,6 +983,7 @@ static int emulator_read_std(unsigned long addr,
 
 	return X86EMUL_CONTINUE;
 }
+EXPORT_SYMBOL_GPL(emulator_read_std);
 
 static int emulator_write_std(unsigned long addr,
 			      const void *val,
@@ -1169,7 +1102,7 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 	return X86EMUL_CONTINUE;
 }
 
-static int emulator_write_emulated(unsigned long addr,
+int emulator_write_emulated(unsigned long addr,
 				   const void *val,
 				   unsigned int bytes,
 				   struct kvm_vcpu *vcpu)
@@ -1188,6 +1121,7 @@ static int emulator_write_emulated(unsigned long addr,
 	}
 	return emulator_write_emulated_onepage(addr, val, bytes, vcpu);
 }
+EXPORT_SYMBOL_GPL(emulator_write_emulated);
 
 static int emulator_cmpxchg_emulated(unsigned long addr,
 				     const void *old,
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index cd96673..b25f4e1 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1019,7 +1019,8 @@ static int io_get_override(struct vcpu_svm *svm,
 		       svm->vmcb->control.exit_info_2,
 		       ins_length);
 
-	if (kvm_read_guest(&svm->vcpu, rip, ins_length, inst) != ins_length)
+	if (emulator_read_std(rip, inst, ins_length, &svm->vcpu)
+	    != X86EMUL_CONTINUE)
 		/* #PF */
 		return 0;
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index cc7ee3d..f770f55 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -16,6 +16,7 @@
  */
 
 #include "kvm.h"
+#include "x86_emulate.h"
 #include "vmx.h"
 #include "segment_descriptor.h"
 
@@ -1553,8 +1554,8 @@ static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 		return;
 	}
 
-	if (kvm_read_guest(vcpu, irq * sizeof(ent), sizeof(ent), &ent) !=
-								sizeof(ent)) {
+	if (emulator_read_std(irq * sizeof(ent), &ent, sizeof(ent), vcpu) !=
+							X86EMUL_CONTINUE) {
 		vcpu_printf(vcpu, "%s: read guest err\n", __FUNCTION__);
 		return;
 	}
@@ -1564,9 +1565,9 @@ static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 	ip =  vmcs_readl(GUEST_RIP);
 
 
-	if (kvm_write_guest(vcpu, ss_base + sp - 2, 2, &flags) != 2 ||
-	    kvm_write_guest(vcpu, ss_base + sp - 4, 2, &cs) != 2 ||
-	    kvm_write_guest(vcpu, ss_base + sp - 6, 2, &ip) != 2) {
+	if (emulator_write_emulated(ss_base + sp - 2, &flags, 2, vcpu) != X86EMUL_CONTINUE ||
+	    emulator_write_emulated(ss_base + sp - 4, &cs, 2, vcpu) != X86EMUL_CONTINUE ||
+	    emulator_write_emulated(ss_base + sp - 6, &ip, 2, vcpu) != X86EMUL_CONTINUE) {
 		vcpu_printf(vcpu, "%s: write guest err\n", __FUNCTION__);
 		return;
 	}
@@ -1767,7 +1768,7 @@ static int get_io_count(struct kvm_vcpu *vcpu, unsigned long *count)
 	u64 inst;
 	gva_t rip;
 	int countr_size;
-	int i, n;
+	int i;
 
 	if ((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_VM)) {
 		countr_size = 2;
@@ -1782,9 +1783,11 @@ static int get_io_count(struct kvm_vcpu *vcpu, unsigned long *count)
 	if (countr_size != 8)
 		rip += vmcs_readl(GUEST_CS_BASE);
 
-	n = kvm_read_guest(vcpu, rip, sizeof(inst), &inst);
+	if (emulator_read_std(rip, &inst, sizeof(inst), vcpu) !=
+							X86EMUL_CONTINUE)
+		return 0;
 
-	for (i = 0; i < n; i++) {
+	for (i = 0; i < sizeof(inst); i++) {
 		switch (((u8*)&inst)[i]) {
 		case 0xf0:
 		case 0xf2:
-- 
1.5.3

