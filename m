Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYLHLm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYLHLm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYLHLhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48282 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYLHLhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 45/45] KVM: ppc: create struct kvm_vcpu_44x and introduce container_of() accessor
Date: Mon,  8 Dec 2008 13:36:56 +0200
Message-Id: <1228736216-15787-46-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This patch doesn't yet move all 44x-specific data into the new structure, but
is the first step down that path. In the future we may also want to create a
struct kvm_vcpu_booke.

Based on patch from Liu Yu <yu.liu@freescale.com>.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_44x.h  |   47 ++++++++++++++++++++++++++
 arch/powerpc/include/asm/kvm_host.h |   13 -------
 arch/powerpc/include/asm/kvm_ppc.h  |    6 +++
 arch/powerpc/kernel/asm-offsets.c   |   14 +++++---
 arch/powerpc/kvm/44x.c              |   62 +++++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/44x_tlb.c          |   37 +++++++++++++-------
 arch/powerpc/kvm/booke.c            |    9 ++---
 arch/powerpc/kvm/booke_interrupts.S |    6 ++--
 arch/powerpc/kvm/powerpc.c          |   23 +------------
 9 files changed, 154 insertions(+), 63 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_44x.h

diff --git a/arch/powerpc/include/asm/kvm_44x.h b/arch/powerpc/include/asm/kvm_44x.h
new file mode 100644
index 0000000..dece093
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_44x.h
@@ -0,0 +1,47 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#ifndef __ASM_44X_H__
+#define __ASM_44X_H__
+
+#include <linux/kvm_host.h>
+
+/* XXX Can't include mmu-44x.h because it redefines struct mm_context. */
+#define PPC44x_TLB_SIZE 64
+
+struct kvmppc_vcpu_44x {
+	/* Unmodified copy of the guest's TLB. */
+	struct kvmppc_44x_tlbe guest_tlb[PPC44x_TLB_SIZE];
+	/* TLB that's actually used when the guest is running. */
+	struct kvmppc_44x_tlbe shadow_tlb[PPC44x_TLB_SIZE];
+	/* Pages which are referenced in the shadow TLB. */
+	struct page *shadow_pages[PPC44x_TLB_SIZE];
+
+	/* Track which TLB entries we've modified in the current exit. */
+	u8 shadow_tlb_mod[PPC44x_TLB_SIZE];
+
+	struct kvm_vcpu vcpu;
+};
+
+static inline struct kvmppc_vcpu_44x *to_44x(struct kvm_vcpu *vcpu)
+{
+	return container_of(vcpu, struct kvmppc_vcpu_44x, vcpu);
+}
+
+#endif /* __ASM_44X_H__ */
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index f5850d7..765d8ec 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -74,20 +74,7 @@ struct kvmppc_44x_tlbe {
 struct kvm_arch {
 };
 
-/* XXX Can't include mmu-44x.h because it redefines struct mm_context. */
-#define PPC44x_TLB_SIZE 64
-
 struct kvm_vcpu_arch {
-	/* Unmodified copy of the guest's TLB. */
-	struct kvmppc_44x_tlbe guest_tlb[PPC44x_TLB_SIZE];
-	/* TLB that's actually used when the guest is running. */
-	struct kvmppc_44x_tlbe shadow_tlb[PPC44x_TLB_SIZE];
-	/* Pages which are referenced in the shadow TLB. */
-	struct page *shadow_pages[PPC44x_TLB_SIZE];
-
-	/* Track which TLB entries we've modified in the current exit. */
-	u8 shadow_tlb_mod[PPC44x_TLB_SIZE];
-
 	u32 host_stack;
 	u32 host_pid;
 	u32 host_dbcr0;
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index d593325..976ecc4 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -62,6 +62,9 @@ extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 
 /* Core-specific hooks */
 
+extern struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm,
+                                                unsigned int id);
+extern void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_check_processor_compat(void);
 extern int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
@@ -85,6 +88,9 @@ extern int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 extern int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs);
 extern int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt);
 
+extern int kvmppc_booke_init(void);
+extern void kvmppc_booke_exit(void);
+
 extern void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu);
 
 #endif /* __POWERPC_KVM_PPC_H__ */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 1d15420..b6367e8 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -23,9 +23,6 @@
 #include <linux/mm.h>
 #include <linux/suspend.h>
 #include <linux/hrtimer.h>
-#ifdef CONFIG_KVM
-#include <linux/kvm_host.h>
-#endif
 #ifdef CONFIG_PPC64
 #include <linux/time.h>
 #include <linux/hardirq.h>
@@ -51,6 +48,9 @@
 #ifdef CONFIG_PPC_ISERIES
 #include <asm/iseries/alpaca.h>
 #endif
+#ifdef CONFIG_KVM
+#include <asm/kvm_44x.h>
+#endif
 
 #if defined(CONFIG_BOOKE) || defined(CONFIG_40x)
 #include "head_booke.h"
@@ -357,10 +357,14 @@ int main(void)
 #ifdef CONFIG_KVM
 	DEFINE(TLBE_BYTES, sizeof(struct kvmppc_44x_tlbe));
 
+	DEFINE(VCPU_TO_44X, offsetof(struct kvmppc_vcpu_44x, vcpu));
+	DEFINE(VCPU44x_SHADOW_TLB,
+	       offsetof(struct kvmppc_vcpu_44x, shadow_tlb));
+	DEFINE(VCPU44x_SHADOW_MOD,
+	       offsetof(struct kvmppc_vcpu_44x, shadow_tlb_mod));
+
 	DEFINE(VCPU_HOST_STACK, offsetof(struct kvm_vcpu, arch.host_stack));
 	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
-	DEFINE(VCPU_SHADOW_TLB, offsetof(struct kvm_vcpu, arch.shadow_tlb));
-	DEFINE(VCPU_SHADOW_MOD, offsetof(struct kvm_vcpu, arch.shadow_tlb_mod));
 	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
 	DEFINE(VCPU_LR, offsetof(struct kvm_vcpu, arch.lr));
 	DEFINE(VCPU_CR, offsetof(struct kvm_vcpu, arch.cr));
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index f5d7028..22054b1 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -18,9 +18,13 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/err.h>
+
 #include <asm/reg.h>
 #include <asm/cputable.h>
 #include <asm/tlbflush.h>
+#include <asm/kvm_44x.h>
+#include <asm/kvm_ppc.h>
 
 #include "44x_tlb.h"
 
@@ -124,7 +128,8 @@ int kvmppc_core_check_processor_compat(void)
 
 int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
 {
-	struct kvmppc_44x_tlbe *tlbe = &vcpu->arch.guest_tlb[0];
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	struct kvmppc_44x_tlbe *tlbe = &vcpu_44x->guest_tlb[0];
 
 	tlbe->tid = 0;
 	tlbe->word0 = PPC44x_TLB_16M | PPC44x_TLB_VALID;
@@ -150,6 +155,7 @@ int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
 int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
                                struct kvm_translation *tr)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	struct kvmppc_44x_tlbe *gtlbe;
 	int index;
 	gva_t eaddr;
@@ -166,7 +172,7 @@ int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
 		return 0;
 	}
 
-	gtlbe = &vcpu->arch.guest_tlb[index];
+	gtlbe = &vcpu_44x->guest_tlb[index];
 
 	tr->physical_address = tlb_xlate(gtlbe, eaddr);
 	/* XXX what does "writeable" and "usermode" even mean? */
@@ -174,3 +180,55 @@ int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
+{
+	struct kvmppc_vcpu_44x *vcpu_44x;
+	struct kvm_vcpu *vcpu;
+	int err;
+
+	vcpu_44x = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	if (!vcpu_44x) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	vcpu = &vcpu_44x->vcpu;
+	err = kvm_vcpu_init(vcpu, kvm, id);
+	if (err)
+		goto free_vcpu;
+
+	return vcpu;
+
+free_vcpu:
+	kmem_cache_free(kvm_vcpu_cache, vcpu_44x);
+out:
+	return ERR_PTR(err);
+}
+
+void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+
+	kvm_vcpu_uninit(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu_44x);
+}
+
+static int kvmppc_44x_init(void)
+{
+	int r;
+
+	r = kvmppc_booke_init();
+	if (r)
+		return r;
+
+	return kvm_init(NULL, sizeof(struct kvmppc_vcpu_44x), THIS_MODULE);
+}
+
+static void kvmppc_44x_exit(void)
+{
+	kvmppc_booke_exit();
+}
+
+module_init(kvmppc_44x_init);
+module_exit(kvmppc_44x_exit);
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index bb6da13..8b65fbd 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -24,6 +24,7 @@
 #include <linux/highmem.h>
 #include <asm/mmu-44x.h>
 #include <asm/kvm_ppc.h>
+#include <asm/kvm_44x.h>
 
 #include "44x_tlb.h"
 
@@ -43,7 +44,7 @@ void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
 			"nr", "tid", "word0", "word1", "word2");
 
 	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
-		tlbe = &vcpu->arch.guest_tlb[i];
+		tlbe = &vcpu_44x->guest_tlb[i];
 		if (tlbe->word0 & PPC44x_TLB_VALID)
 			printk(" G%2d |  %02X | %08X | %08X | %08X |\n",
 			       i, tlbe->tid, tlbe->word0, tlbe->word1,
@@ -51,7 +52,7 @@ void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
-		tlbe = &vcpu->arch.shadow_tlb[i];
+		tlbe = &vcpu_44x->shadow_tlb[i];
 		if (tlbe->word0 & PPC44x_TLB_VALID)
 			printk(" S%2d | %02X | %08X | %08X | %08X |\n",
 			       i, tlbe->tid, tlbe->word0, tlbe->word1,
@@ -82,11 +83,12 @@ static u32 kvmppc_44x_tlb_shadow_attrib(u32 attrib, int usermode)
 int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
                          unsigned int as)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	int i;
 
 	/* XXX Replace loop with fancy data structures. */
 	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
-		struct kvmppc_44x_tlbe *tlbe = &vcpu->arch.guest_tlb[i];
+		struct kvmppc_44x_tlbe *tlbe = &vcpu_44x->guest_tlb[i];
 		unsigned int tid;
 
 		if (eaddr < get_tlb_eaddr(tlbe))
@@ -114,25 +116,27 @@ int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
 struct kvmppc_44x_tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu,
                                                gva_t eaddr)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
 	unsigned int index;
 
 	index = kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
 	if (index == -1)
 		return NULL;
-	return &vcpu->arch.guest_tlb[index];
+	return &vcpu_44x->guest_tlb[index];
 }
 
 struct kvmppc_44x_tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu,
                                                gva_t eaddr)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	unsigned int as = !!(vcpu->arch.msr & MSR_DS);
 	unsigned int index;
 
 	index = kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
 	if (index == -1)
 		return NULL;
-	return &vcpu->arch.guest_tlb[index];
+	return &vcpu_44x->guest_tlb[index];
 }
 
 static int kvmppc_44x_tlbe_is_writable(struct kvmppc_44x_tlbe *tlbe)
@@ -143,8 +147,9 @@ static int kvmppc_44x_tlbe_is_writable(struct kvmppc_44x_tlbe *tlbe)
 static void kvmppc_44x_shadow_release(struct kvm_vcpu *vcpu,
                                       unsigned int index)
 {
-	struct kvmppc_44x_tlbe *stlbe = &vcpu->arch.shadow_tlb[index];
-	struct page *page = vcpu->arch.shadow_pages[index];
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[index];
+	struct page *page = vcpu_44x->shadow_pages[index];
 
 	if (get_tlb_v(stlbe)) {
 		if (kvmppc_44x_tlbe_is_writable(stlbe))
@@ -164,7 +169,9 @@ void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu)
 
 void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i)
 {
-    vcpu->arch.shadow_tlb_mod[i] = 1;
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+
+	vcpu_44x->shadow_tlb_mod[i] = 1;
 }
 
 /* Caller must ensure that the specified guest TLB entry is safe to insert into
@@ -172,6 +179,7 @@ void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i)
 void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
                     u32 flags)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	struct page *new_page;
 	struct kvmppc_44x_tlbe *stlbe;
 	hpa_t hpaddr;
@@ -182,7 +190,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	victim = kvmppc_tlb_44x_pos++;
 	if (kvmppc_tlb_44x_pos > tlb_44x_hwater)
 		kvmppc_tlb_44x_pos = 0;
-	stlbe = &vcpu->arch.shadow_tlb[victim];
+	stlbe = &vcpu_44x->shadow_tlb[victim];
 
 	/* Get reference to new page. */
 	new_page = gfn_to_page(vcpu->kvm, gfn);
@@ -196,7 +204,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	/* Drop reference to old page. */
 	kvmppc_44x_shadow_release(vcpu, victim);
 
-	vcpu->arch.shadow_pages[victim] = new_page;
+	vcpu_44x->shadow_pages[victim] = new_page;
 
 	/* XXX Make sure (va, size) doesn't overlap any other
 	 * entries. 440x6 user manual says the result would be
@@ -224,12 +232,13 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 static void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
                                   gva_t eend, u32 asid)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	unsigned int pid = !(asid & 0xff);
 	int i;
 
 	/* XXX Replace loop with fancy data structures. */
 	for (i = 0; i <= tlb_44x_hwater; i++) {
-		struct kvmppc_44x_tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
+		struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
 		unsigned int tid;
 
 		if (!get_tlb_v(stlbe))
@@ -259,12 +268,13 @@ static void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
  * switching address spaces. */
 void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	int i;
 
 	if (vcpu->arch.swap_pid) {
 		/* XXX Replace loop with fancy data structures. */
 		for (i = 0; i <= tlb_44x_hwater; i++) {
-			struct kvmppc_44x_tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
+			struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
 
 			/* Future optimization: clear only userspace mappings. */
 			kvmppc_44x_shadow_release(vcpu, i);
@@ -303,6 +313,7 @@ static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
 
 int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 {
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	u64 eaddr;
 	u64 raddr;
 	u64 asid;
@@ -317,7 +328,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 		return EMULATE_FAIL;
 	}
 
-	tlbe = &vcpu->arch.guest_tlb[index];
+	tlbe = &vcpu_44x->guest_tlb[index];
 
 	/* Invalidate shadow mappings for the about-to-be-clobbered TLBE. */
 	if (tlbe->word0 & PPC44x_TLB_VALID) {
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index c619d1b..883e9db 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -573,7 +573,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return kvmppc_core_vcpu_translate(vcpu, tr);
 }
 
-static int kvmppc_booke_init(void)
+int kvmppc_booke_init(void)
 {
 	unsigned long ivor[16];
 	unsigned long max_ivor = 0;
@@ -618,14 +618,11 @@ static int kvmppc_booke_init(void)
 	flush_icache_range(kvmppc_booke_handlers,
 	                   kvmppc_booke_handlers + max_ivor + kvmppc_handler_len);
 
-	return kvm_init(NULL, sizeof(struct kvm_vcpu), THIS_MODULE);
+	return 0;
 }
 
-static void __exit kvmppc_booke_exit(void)
+void __exit kvmppc_booke_exit(void)
 {
 	free_pages(kvmppc_booke_handlers, VCPU_SIZE_ORDER);
 	kvm_exit();
 }
-
-module_init(kvmppc_booke_init)
-module_exit(kvmppc_booke_exit)
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 95e165b..8d6929b 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -349,8 +349,8 @@ lightweight_exit:
 	lis	r5, tlb_44x_hwater@ha
 	lwz	r5, tlb_44x_hwater@l(r5)
 	mtctr	r5
-	addi	r9, r4, VCPU_SHADOW_TLB
-	addi	r5, r4, VCPU_SHADOW_MOD
+	addi	r9, r4, -VCPU_TO_44X + VCPU44x_SHADOW_TLB
+	addi	r5, r4, -VCPU_TO_44X + VCPU44x_SHADOW_MOD
 	li	r3, 0
 1:
 	lbzx	r7, r3, r5
@@ -377,7 +377,7 @@ lightweight_exit:
 	/* Clear bitmap of modified TLB entries */
 	li	r5, PPC44x_TLB_SIZE>>2
 	mtctr	r5
-	addi	r5, r4, VCPU_SHADOW_MOD - 4
+	addi	r5, r4, -VCPU_TO_44X + VCPU44x_SHADOW_MOD - 4
 	li	r6, 0
 1:
 	stwu	r6, 4(r5)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 800fe97..dd279ee 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -170,31 +170,12 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
 
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
-	struct kvm_vcpu *vcpu;
-	int err;
-
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		goto free_vcpu;
-
-	return vcpu;
-
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-out:
-	return ERR_PTR(err);
+	return kvmppc_core_vcpu_create(kvm, id);
 }
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	kvmppc_core_vcpu_free(vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
1.6.0.3

