Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbYLHLn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbYLHLn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYLHLhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbYLHLhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 38/45] KVM: ppc: Move 440-specific TLB code into 44x_tlb.c
Date: Mon,  8 Dec 2008 13:36:49 +0200
Message-Id: <1228736216-15787-39-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This will make it easier to provide implementations for other cores.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    4 +-
 arch/powerpc/kvm/44x_tlb.c         |  138 +++++++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/booke_guest.c     |   26 -------
 arch/powerpc/kvm/emulate.c         |  120 ++-----------------------------
 4 files changed, 145 insertions(+), 143 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index bb62ad8..4adb4a3 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -58,11 +58,11 @@ extern int kvmppc_handle_store(struct kvm_run *run, struct kvm_vcpu *vcpu,
 extern int kvmppc_emulate_instruction(struct kvm_run *run,
                                       struct kvm_vcpu *vcpu);
 extern int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu);
+extern int kvmppc_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws);
+extern int kvmppc_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc);
 
 extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn,
                            u64 asid, u32 flags);
-extern void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
-                                  gva_t eend, u32 asid);
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index ad72c6f..dd75ab8 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -32,6 +32,34 @@
 
 static unsigned int kvmppc_tlb_44x_pos;
 
+#ifdef DEBUG
+void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_44x_tlbe *tlbe;
+	int i;
+
+	printk("vcpu %d TLB dump:\n", vcpu->vcpu_id);
+	printk("| %2s | %3s | %8s | %8s | %8s |\n",
+			"nr", "tid", "word0", "word1", "word2");
+
+	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
+		tlbe = &vcpu->arch.guest_tlb[i];
+		if (tlbe->word0 & PPC44x_TLB_VALID)
+			printk(" G%2d |  %02X | %08X | %08X | %08X |\n",
+			       i, tlbe->tid, tlbe->word0, tlbe->word1,
+			       tlbe->word2);
+	}
+
+	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
+		tlbe = &vcpu->arch.shadow_tlb[i];
+		if (tlbe->word0 & PPC44x_TLB_VALID)
+			printk(" S%2d | %02X | %08X | %08X | %08X |\n",
+			       i, tlbe->tid, tlbe->word0, tlbe->word1,
+			       tlbe->word2);
+	}
+}
+#endif
+
 static u32 kvmppc_44x_tlb_shadow_attrib(u32 attrib, int usermode)
 {
 	/* Mask off reserved bits. */
@@ -191,8 +219,8 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 			handler);
 }
 
-void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
-                           gva_t eend, u32 asid)
+static void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
+                                  gva_t eend, u32 asid)
 {
 	unsigned int pid = !(asid & 0xff);
 	int i;
@@ -249,3 +277,109 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 
 	vcpu->arch.shadow_pid = !usermode;
 }
+
+static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
+                             const struct tlbe *tlbe)
+{
+	gpa_t gpa;
+
+	if (!get_tlb_v(tlbe))
+		return 0;
+
+	/* Does it match current guest AS? */
+	/* XXX what about IS != DS? */
+	if (get_tlb_ts(tlbe) != !!(vcpu->arch.msr & MSR_IS))
+		return 0;
+
+	gpa = get_tlb_raddr(tlbe);
+	if (!gfn_to_memslot(vcpu->kvm, gpa >> PAGE_SHIFT))
+		/* Mapping is not for RAM. */
+		return 0;
+
+	return 1;
+}
+
+int kvmppc_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
+{
+	u64 eaddr;
+	u64 raddr;
+	u64 asid;
+	u32 flags;
+	struct tlbe *tlbe;
+	unsigned int index;
+
+	index = vcpu->arch.gpr[ra];
+	if (index > PPC44x_TLB_SIZE) {
+		printk("%s: index %d\n", __func__, index);
+		kvmppc_dump_vcpu(vcpu);
+		return EMULATE_FAIL;
+	}
+
+	tlbe = &vcpu->arch.guest_tlb[index];
+
+	/* Invalidate shadow mappings for the about-to-be-clobbered TLBE. */
+	if (tlbe->word0 & PPC44x_TLB_VALID) {
+		eaddr = get_tlb_eaddr(tlbe);
+		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
+		kvmppc_mmu_invalidate(vcpu, eaddr, get_tlb_end(tlbe), asid);
+	}
+
+	switch (ws) {
+	case PPC44x_TLB_PAGEID:
+		tlbe->tid = vcpu->arch.mmucr & 0xff;
+		tlbe->word0 = vcpu->arch.gpr[rs];
+		break;
+
+	case PPC44x_TLB_XLAT:
+		tlbe->word1 = vcpu->arch.gpr[rs];
+		break;
+
+	case PPC44x_TLB_ATTRIB:
+		tlbe->word2 = vcpu->arch.gpr[rs];
+		break;
+
+	default:
+		return EMULATE_FAIL;
+	}
+
+	if (tlbe_is_host_safe(vcpu, tlbe)) {
+		eaddr = get_tlb_eaddr(tlbe);
+		raddr = get_tlb_raddr(tlbe);
+		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
+		flags = tlbe->word2 & 0xffff;
+
+		/* Create a 4KB mapping on the host. If the guest wanted a
+		 * large page, only the first 4KB is mapped here and the rest
+		 * are mapped on the fly. */
+		kvmppc_mmu_map(vcpu, eaddr, raddr >> PAGE_SHIFT, asid, flags);
+	}
+
+	KVMTRACE_5D(GTLB_WRITE, vcpu, index,
+	            tlbe->tid, tlbe->word0, tlbe->word1, tlbe->word2,
+	            handler);
+
+	return EMULATE_DONE;
+}
+
+int kvmppc_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc)
+{
+	u32 ea;
+	int index;
+	unsigned int as = get_mmucr_sts(vcpu);
+	unsigned int pid = get_mmucr_stid(vcpu);
+
+	ea = vcpu->arch.gpr[rb];
+	if (ra)
+		ea += vcpu->arch.gpr[ra];
+
+	index = kvmppc_44x_tlb_index(vcpu, ea, pid, as);
+	if (rc) {
+		if (index < 0)
+			vcpu->arch.cr &= ~0x20000000;
+		else
+			vcpu->arch.cr |= 0x20000000;
+	}
+	vcpu->arch.gpr[rt] = index;
+
+	return EMULATE_DONE;
+}
diff --git a/arch/powerpc/kvm/booke_guest.c b/arch/powerpc/kvm/booke_guest.c
index 7b2591e..c0f8532 100644
--- a/arch/powerpc/kvm/booke_guest.c
+++ b/arch/powerpc/kvm/booke_guest.c
@@ -111,32 +111,6 @@ const unsigned char priority_exception[] = {
 };
 
 
-void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
-{
-	struct tlbe *tlbe;
-	int i;
-
-	printk("vcpu %d TLB dump:\n", vcpu->vcpu_id);
-	printk("| %2s | %3s | %8s | %8s | %8s |\n",
-			"nr", "tid", "word0", "word1", "word2");
-
-	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
-		tlbe = &vcpu->arch.guest_tlb[i];
-		if (tlbe->word0 & PPC44x_TLB_VALID)
-			printk(" G%2d |  %02X | %08X | %08X | %08X |\n",
-			       i, tlbe->tid, tlbe->word0, tlbe->word1,
-			       tlbe->word2);
-	}
-
-	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
-		tlbe = &vcpu->arch.shadow_tlb[i];
-		if (tlbe->word0 & PPC44x_TLB_VALID)
-			printk(" S%2d | %02X | %08X | %08X | %08X |\n",
-			       i, tlbe->tid, tlbe->word0, tlbe->word1,
-			       tlbe->word2);
-	}
-}
-
 /* TODO: use vcpu_printf() */
 void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 0fce4fb..0ce8ed5 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -29,8 +29,6 @@
 #include <asm/byteorder.h>
 #include <asm/kvm_ppc.h>
 
-#include "44x_tlb.h"
-
 /* Instruction decoding */
 static inline unsigned int get_op(u32 inst)
 {
@@ -87,96 +85,6 @@ static inline unsigned int get_d(u32 inst)
 	return inst & 0xffff;
 }
 
-static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
-                             const struct tlbe *tlbe)
-{
-	gpa_t gpa;
-
-	if (!get_tlb_v(tlbe))
-		return 0;
-
-	/* Does it match current guest AS? */
-	/* XXX what about IS != DS? */
-	if (get_tlb_ts(tlbe) != !!(vcpu->arch.msr & MSR_IS))
-		return 0;
-
-	gpa = get_tlb_raddr(tlbe);
-	if (!gfn_to_memslot(vcpu->kvm, gpa >> PAGE_SHIFT))
-		/* Mapping is not for RAM. */
-		return 0;
-
-	return 1;
-}
-
-static int kvmppc_emul_tlbwe(struct kvm_vcpu *vcpu, u32 inst)
-{
-	u64 eaddr;
-	u64 raddr;
-	u64 asid;
-	u32 flags;
-	struct tlbe *tlbe;
-	unsigned int ra;
-	unsigned int rs;
-	unsigned int ws;
-	unsigned int index;
-
-	ra = get_ra(inst);
-	rs = get_rs(inst);
-	ws = get_ws(inst);
-
-	index = vcpu->arch.gpr[ra];
-	if (index > PPC44x_TLB_SIZE) {
-		printk("%s: index %d\n", __func__, index);
-		kvmppc_dump_vcpu(vcpu);
-		return EMULATE_FAIL;
-	}
-
-	tlbe = &vcpu->arch.guest_tlb[index];
-
-	/* Invalidate shadow mappings for the about-to-be-clobbered TLBE. */
-	if (tlbe->word0 & PPC44x_TLB_VALID) {
-		eaddr = get_tlb_eaddr(tlbe);
-		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
-		kvmppc_mmu_invalidate(vcpu, eaddr, get_tlb_end(tlbe), asid);
-	}
-
-	switch (ws) {
-	case PPC44x_TLB_PAGEID:
-		tlbe->tid = vcpu->arch.mmucr & 0xff;
-		tlbe->word0 = vcpu->arch.gpr[rs];
-		break;
-
-	case PPC44x_TLB_XLAT:
-		tlbe->word1 = vcpu->arch.gpr[rs];
-		break;
-
-	case PPC44x_TLB_ATTRIB:
-		tlbe->word2 = vcpu->arch.gpr[rs];
-		break;
-
-	default:
-		return EMULATE_FAIL;
-	}
-
-	if (tlbe_is_host_safe(vcpu, tlbe)) {
-		eaddr = get_tlb_eaddr(tlbe);
-		raddr = get_tlb_raddr(tlbe);
-		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
-		flags = tlbe->word2 & 0xffff;
-
-		/* Create a 4KB mapping on the host. If the guest wanted a
-		 * large page, only the first 4KB is mapped here and the rest
-		 * are mapped on the fly. */
-		kvmppc_mmu_map(vcpu, eaddr, raddr >> PAGE_SHIFT, asid, flags);
-	}
-
-	KVMTRACE_5D(GTLB_WRITE, vcpu, index,
-			tlbe->tid, tlbe->word0, tlbe->word1, tlbe->word2,
-			handler);
-
-	return EMULATE_DONE;
-}
-
 static void kvmppc_emulate_dec(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.tcr & TCR_DIE) {
@@ -222,6 +130,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	int rc;
 	int rs;
 	int rt;
+	int ws;
 	int sprn;
 	int dcrn;
 	enum emulation_result emulated = EMULATE_DONE;
@@ -630,33 +539,18 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			break;
 
 		case 978:                                       /* tlbwe */
-			emulated = kvmppc_emul_tlbwe(vcpu, inst);
+			ra = get_ra(inst);
+			rs = get_rs(inst);
+			ws = get_ws(inst);
+			emulated = kvmppc_emul_tlbwe(vcpu, ra, rs, ws);
 			break;
 
-		case 914:       {                               /* tlbsx */
-			int index;
-			unsigned int as = get_mmucr_sts(vcpu);
-			unsigned int pid = get_mmucr_stid(vcpu);
-
+		case 914:                                       /* tlbsx */
 			rt = get_rt(inst);
 			ra = get_ra(inst);
 			rb = get_rb(inst);
 			rc = get_rc(inst);
-
-			ea = vcpu->arch.gpr[rb];
-			if (ra)
-				ea += vcpu->arch.gpr[ra];
-
-			index = kvmppc_44x_tlb_index(vcpu, ea, pid, as);
-			if (rc) {
-				if (index < 0)
-					vcpu->arch.cr &= ~0x20000000;
-				else
-					vcpu->arch.cr |= 0x20000000;
-			}
-			vcpu->arch.gpr[rt] = index;
-
-			}
+			emulated = kvmppc_emul_tlbsx(vcpu, rt, ra, rb, rc);
 			break;
 
 		case 790:                                       /* lhbrx */
-- 
1.6.0.3

