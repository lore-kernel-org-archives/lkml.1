Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0BMIJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:09:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/39] KVM: PPC: Use accessor functions for GPR access
Date: Sat, 13 Feb 2010 10:01:26 +0200
Message-Id: <1266048119-14325-7-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

All code in PPC KVM currently accesses gprs in the vcpu struct directly.

While there's nothing wrong with that wrt the current way gprs are stored
and loaded, it doesn't suffice for the PACA acceleration that will follow
in this patchset.

So let's just create little wrapper inline functions that we call whenever
a GPR needs to be read from or written to. The compiled code shouldn't really
change at all for now.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h   |   26 ++++++++
 arch/powerpc/kvm/44x_emulate.c       |   25 ++++----
 arch/powerpc/kvm/44x_tlb.c           |   14 ++--
 arch/powerpc/kvm/book3s.c            |    8 +-
 arch/powerpc/kvm/book3s_64_emulate.c |   77 +++++++++++++------------
 arch/powerpc/kvm/booke.c             |   16 +++---
 arch/powerpc/kvm/booke_emulate.c     |  107 +++++++++++++++++-----------------
 arch/powerpc/kvm/e500_emulate.c      |   95 ++++++++++++++++--------------
 arch/powerpc/kvm/e500_tlb.c          |    4 +-
 arch/powerpc/kvm/emulate.c           |  106 ++++++++++++++++++---------------
 arch/powerpc/kvm/powerpc.c           |   21 ++++---
 11 files changed, 274 insertions(+), 225 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index abfd0c4..ba01b9c 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -96,4 +96,30 @@ extern void kvmppc_booke_exit(void);
 
 extern void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_PPC_BOOK3S
+
+static inline void kvmppc_set_gpr(struct kvm_vcpu *vcpu, int num, ulong val)
+{
+	vcpu->arch.gpr[num] = val;
+}
+
+static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
+{
+	return vcpu->arch.gpr[num];
+}
+
+#else
+
+static inline void kvmppc_set_gpr(struct kvm_vcpu *vcpu, int num, ulong val)
+{
+	vcpu->arch.gpr[num] = val;
+}
+
+static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
+{
+	return vcpu->arch.gpr[num];
+}
+
+#endif
+
 #endif /* __POWERPC_KVM_PPC_H__ */
diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.c
index 61af58f..65ea083 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -65,13 +65,14 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 */
 			switch (dcrn) {
 			case DCRN_CPR0_CONFIG_ADDR:
-				vcpu->arch.gpr[rt] = vcpu->arch.cpr0_cfgaddr;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.cpr0_cfgaddr);
 				break;
 			case DCRN_CPR0_CONFIG_DATA:
 				local_irq_disable();
 				mtdcr(DCRN_CPR0_CONFIG_ADDR,
 					  vcpu->arch.cpr0_cfgaddr);
-				vcpu->arch.gpr[rt] = mfdcr(DCRN_CPR0_CONFIG_DATA);
+				kvmppc_set_gpr(vcpu, rt,
+					       mfdcr(DCRN_CPR0_CONFIG_DATA));
 				local_irq_enable();
 				break;
 			default:
@@ -93,11 +94,11 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			/* emulate some access in kernel */
 			switch (dcrn) {
 			case DCRN_CPR0_CONFIG_ADDR:
-				vcpu->arch.cpr0_cfgaddr = vcpu->arch.gpr[rs];
+				vcpu->arch.cpr0_cfgaddr = kvmppc_get_gpr(vcpu, rs);
 				break;
 			default:
 				run->dcr.dcrn = dcrn;
-				run->dcr.data = vcpu->arch.gpr[rs];
+				run->dcr.data = kvmppc_get_gpr(vcpu, rs);
 				run->dcr.is_write = 1;
 				vcpu->arch.dcr_needed = 1;
 				kvmppc_account_exit(vcpu, DCR_EXITS);
@@ -146,13 +147,13 @@ int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 
 	switch (sprn) {
 	case SPRN_PID:
-		kvmppc_set_pid(vcpu, vcpu->arch.gpr[rs]); break;
+		kvmppc_set_pid(vcpu, kvmppc_get_gpr(vcpu, rs)); break;
 	case SPRN_MMUCR:
-		vcpu->arch.mmucr = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.mmucr = kvmppc_get_gpr(vcpu, rs); break;
 	case SPRN_CCR0:
-		vcpu->arch.ccr0 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ccr0 = kvmppc_get_gpr(vcpu, rs); break;
 	case SPRN_CCR1:
-		vcpu->arch.ccr1 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.ccr1 = kvmppc_get_gpr(vcpu, rs); break;
 	default:
 		emulated = kvmppc_booke_emulate_mtspr(vcpu, sprn, rs);
 	}
@@ -167,13 +168,13 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 
 	switch (sprn) {
 	case SPRN_PID:
-		vcpu->arch.gpr[rt] = vcpu->arch.pid; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.pid); break;
 	case SPRN_MMUCR:
-		vcpu->arch.gpr[rt] = vcpu->arch.mmucr; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.mmucr); break;
 	case SPRN_CCR0:
-		vcpu->arch.gpr[rt] = vcpu->arch.ccr0; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ccr0); break;
 	case SPRN_CCR1:
-		vcpu->arch.gpr[rt] = vcpu->arch.ccr1; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ccr1); break;
 	default:
 		emulated = kvmppc_booke_emulate_mfspr(vcpu, sprn, rt);
 	}
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index ff3cb63..8b37736 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -439,7 +439,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	struct kvmppc_44x_tlbe *tlbe;
 	unsigned int gtlb_index;
 
-	gtlb_index = vcpu->arch.gpr[ra];
+	gtlb_index = kvmppc_get_gpr(vcpu, ra);
 	if (gtlb_index > KVM44x_GUEST_TLB_SIZE) {
 		printk("%s: index %d\n", __func__, gtlb_index);
 		kvmppc_dump_vcpu(vcpu);
@@ -455,15 +455,15 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	switch (ws) {
 	case PPC44x_TLB_PAGEID:
 		tlbe->tid = get_mmucr_stid(vcpu);
-		tlbe->word0 = vcpu->arch.gpr[rs];
+		tlbe->word0 = kvmppc_get_gpr(vcpu, rs);
 		break;
 
 	case PPC44x_TLB_XLAT:
-		tlbe->word1 = vcpu->arch.gpr[rs];
+		tlbe->word1 = kvmppc_get_gpr(vcpu, rs);
 		break;
 
 	case PPC44x_TLB_ATTRIB:
-		tlbe->word2 = vcpu->arch.gpr[rs];
+		tlbe->word2 = kvmppc_get_gpr(vcpu, rs);
 		break;
 
 	default:
@@ -500,9 +500,9 @@ int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc)
 	unsigned int as = get_mmucr_sts(vcpu);
 	unsigned int pid = get_mmucr_stid(vcpu);
 
-	ea = vcpu->arch.gpr[rb];
+	ea = kvmppc_get_gpr(vcpu, rb);
 	if (ra)
-		ea += vcpu->arch.gpr[ra];
+		ea += kvmppc_get_gpr(vcpu, ra);
 
 	gtlb_index = kvmppc_44x_tlb_index(vcpu, ea, pid, as);
 	if (rc) {
@@ -511,7 +511,7 @@ int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc)
 		else
 			vcpu->arch.cr |= 0x20000000;
 	}
-	vcpu->arch.gpr[rt] = gtlb_index;
+	kvmppc_set_gpr(vcpu, rt, gtlb_index);
 
 	kvmppc_set_exit_type(vcpu, EMULATED_TLBSX_EXITS);
 	return EMULATE_DONE;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index fd2a4d5..574b24f 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -658,7 +658,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	}
 	case BOOK3S_INTERRUPT_SYSCALL:
 #ifdef EXIT_DEBUG
-		printk(KERN_INFO "Syscall Nr %d\n", (int)vcpu->arch.gpr[0]);
+		printk(KERN_INFO "Syscall Nr %d\n", (int)kvmppc_get_gpr(vcpu, 0));
 #endif
 		vcpu->stat.syscall_exits++;
 		kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
@@ -734,7 +734,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	regs->sprg7 = vcpu->arch.sprg6;
 
 	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
-		regs->gpr[i] = vcpu->arch.gpr[i];
+		regs->gpr[i] = kvmppc_get_gpr(vcpu, i);
 
 	return 0;
 }
@@ -759,8 +759,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	vcpu->arch.sprg6 = regs->sprg5;
 	vcpu->arch.sprg7 = regs->sprg6;
 
-	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gpr); i++)
-		vcpu->arch.gpr[i] = regs->gpr[i];
+	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
+		kvmppc_set_gpr(vcpu, i, regs->gpr[i]);
 
 	return 0;
 }
diff --git a/arch/powerpc/kvm/book3s_64_emulate.c b/arch/powerpc/kvm/book3s_64_emulate.c
index 1027eac..2b0ee7e 100644
--- a/arch/powerpc/kvm/book3s_64_emulate.c
+++ b/arch/powerpc/kvm/book3s_64_emulate.c
@@ -65,11 +65,11 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	case 31:
 		switch (get_xop(inst)) {
 		case OP_31_XOP_MFMSR:
-			vcpu->arch.gpr[get_rt(inst)] = vcpu->arch.msr;
+			kvmppc_set_gpr(vcpu, get_rt(inst), vcpu->arch.msr);
 			break;
 		case OP_31_XOP_MTMSRD:
 		{
-			ulong rs = vcpu->arch.gpr[get_rs(inst)];
+			ulong rs = kvmppc_get_gpr(vcpu, get_rs(inst));
 			if (inst & 0x10000) {
 				vcpu->arch.msr &= ~(MSR_RI | MSR_EE);
 				vcpu->arch.msr |= rs & (MSR_RI | MSR_EE);
@@ -78,30 +78,30 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			break;
 		}
 		case OP_31_XOP_MTMSR:
-			kvmppc_set_msr(vcpu, vcpu->arch.gpr[get_rs(inst)]);
+			kvmppc_set_msr(vcpu, kvmppc_get_gpr(vcpu, get_rs(inst)));
 			break;
 		case OP_31_XOP_MFSRIN:
 		{
 			int srnum;
 
-			srnum = (vcpu->arch.gpr[get_rb(inst)] >> 28) & 0xf;
+			srnum = (kvmppc_get_gpr(vcpu, get_rb(inst)) >> 28) & 0xf;
 			if (vcpu->arch.mmu.mfsrin) {
 				u32 sr;
 				sr = vcpu->arch.mmu.mfsrin(vcpu, srnum);
-				vcpu->arch.gpr[get_rt(inst)] = sr;
+				kvmppc_set_gpr(vcpu, get_rt(inst), sr);
 			}
 			break;
 		}
 		case OP_31_XOP_MTSRIN:
 			vcpu->arch.mmu.mtsrin(vcpu,
-				(vcpu->arch.gpr[get_rb(inst)] >> 28) & 0xf,
-				vcpu->arch.gpr[get_rs(inst)]);
+				(kvmppc_get_gpr(vcpu, get_rb(inst)) >> 28) & 0xf,
+				kvmppc_get_gpr(vcpu, get_rs(inst)));
 			break;
 		case OP_31_XOP_TLBIE:
 		case OP_31_XOP_TLBIEL:
 		{
 			bool large = (inst & 0x00200000) ? true : false;
-			ulong addr = vcpu->arch.gpr[get_rb(inst)];
+			ulong addr = kvmppc_get_gpr(vcpu, get_rb(inst));
 			vcpu->arch.mmu.tlbie(vcpu, addr, large);
 			break;
 		}
@@ -111,14 +111,16 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			if (!vcpu->arch.mmu.slbmte)
 				return EMULATE_FAIL;
 
-			vcpu->arch.mmu.slbmte(vcpu, vcpu->arch.gpr[get_rs(inst)],
-						vcpu->arch.gpr[get_rb(inst)]);
+			vcpu->arch.mmu.slbmte(vcpu,
+					kvmppc_get_gpr(vcpu, get_rs(inst)),
+					kvmppc_get_gpr(vcpu, get_rb(inst)));
 			break;
 		case OP_31_XOP_SLBIE:
 			if (!vcpu->arch.mmu.slbie)
 				return EMULATE_FAIL;
 
-			vcpu->arch.mmu.slbie(vcpu, vcpu->arch.gpr[get_rb(inst)]);
+			vcpu->arch.mmu.slbie(vcpu,
+					kvmppc_get_gpr(vcpu, get_rb(inst)));
 			break;
 		case OP_31_XOP_SLBIA:
 			if (!vcpu->arch.mmu.slbia)
@@ -132,9 +134,9 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			} else {
 				ulong t, rb;
 
-				rb = vcpu->arch.gpr[get_rb(inst)];
+				rb = kvmppc_get_gpr(vcpu, get_rb(inst));
 				t = vcpu->arch.mmu.slbmfee(vcpu, rb);
-				vcpu->arch.gpr[get_rt(inst)] = t;
+				kvmppc_set_gpr(vcpu, get_rt(inst), t);
 			}
 			break;
 		case OP_31_XOP_SLBMFEV:
@@ -143,20 +145,20 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			} else {
 				ulong t, rb;
 
-				rb = vcpu->arch.gpr[get_rb(inst)];
+				rb = kvmppc_get_gpr(vcpu, get_rb(inst));
 				t = vcpu->arch.mmu.slbmfev(vcpu, rb);
-				vcpu->arch.gpr[get_rt(inst)] = t;
+				kvmppc_set_gpr(vcpu, get_rt(inst), t);
 			}
 			break;
 		case OP_31_XOP_DCBZ:
 		{
-			ulong rb =  vcpu->arch.gpr[get_rb(inst)];
+			ulong rb = kvmppc_get_gpr(vcpu, get_rb(inst));
 			ulong ra = 0;
 			ulong addr;
 			u32 zeros[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
 
 			if (get_ra(inst))
-				ra = vcpu->arch.gpr[get_ra(inst)];
+				ra = kvmppc_get_gpr(vcpu, get_ra(inst));
 
 			addr = (ra + rb) & ~31ULL;
 			if (!(vcpu->arch.msr & MSR_SF))
@@ -233,43 +235,44 @@ static void kvmppc_write_bat(struct kvm_vcpu *vcpu, int sprn, u32 val)
 int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 {
 	int emulated = EMULATE_DONE;
+	ulong spr_val = kvmppc_get_gpr(vcpu, rs);
 
 	switch (sprn) {
 	case SPRN_SDR1:
-		to_book3s(vcpu)->sdr1 = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->sdr1 = spr_val;
 		break;
 	case SPRN_DSISR:
-		to_book3s(vcpu)->dsisr = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->dsisr = spr_val;
 		break;
 	case SPRN_DAR:
-		vcpu->arch.dear = vcpu->arch.gpr[rs];
+		vcpu->arch.dear = spr_val;
 		break;
 	case SPRN_HIOR:
-		to_book3s(vcpu)->hior = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->hior = spr_val;
 		break;
 	case SPRN_IBAT0U ... SPRN_IBAT3L:
 	case SPRN_IBAT4U ... SPRN_IBAT7L:
 	case SPRN_DBAT0U ... SPRN_DBAT3L:
 	case SPRN_DBAT4U ... SPRN_DBAT7L:
-		kvmppc_write_bat(vcpu, sprn, (u32)vcpu->arch.gpr[rs]);
+		kvmppc_write_bat(vcpu, sprn, (u32)spr_val);
 		/* BAT writes happen so rarely that we're ok to flush
 		 * everything here */
 		kvmppc_mmu_pte_flush(vcpu, 0, 0);
 		break;
 	case SPRN_HID0:
-		to_book3s(vcpu)->hid[0] = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->hid[0] = spr_val;
 		break;
 	case SPRN_HID1:
-		to_book3s(vcpu)->hid[1] = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->hid[1] = spr_val;
 		break;
 	case SPRN_HID2:
-		to_book3s(vcpu)->hid[2] = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->hid[2] = spr_val;
 		break;
 	case SPRN_HID4:
-		to_book3s(vcpu)->hid[4] = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->hid[4] = spr_val;
 		break;
 	case SPRN_HID5:
-		to_book3s(vcpu)->hid[5] = vcpu->arch.gpr[rs];
+		to_book3s(vcpu)->hid[5] = spr_val;
 		/* guest HID5 set can change is_dcbz32 */
 		if (vcpu->arch.mmu.is_dcbz32(vcpu) &&
 		    (mfmsr() & MSR_HV))
@@ -299,38 +302,38 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 
 	switch (sprn) {
 	case SPRN_SDR1:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->sdr1;
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->sdr1);
 		break;
 	case SPRN_DSISR:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->dsisr;
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->dsisr);
 		break;
 	case SPRN_DAR:
-		vcpu->arch.gpr[rt] = vcpu->arch.dear;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dear);
 		break;
 	case SPRN_HIOR:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->hior;
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->hior);
 		break;
 	case SPRN_HID0:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->hid[0];
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->hid[0]);
 		break;
 	case SPRN_HID1:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->hid[1];
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->hid[1]);
 		break;
 	case SPRN_HID2:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->hid[2];
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->hid[2]);
 		break;
 	case SPRN_HID4:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->hid[4];
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->hid[4]);
 		break;
 	case SPRN_HID5:
-		vcpu->arch.gpr[rt] = to_book3s(vcpu)->hid[5];
+		kvmppc_set_gpr(vcpu, rt, to_book3s(vcpu)->hid[5]);
 		break;
 	case SPRN_THRM1:
 	case SPRN_THRM2:
 	case SPRN_THRM3:
 	case SPRN_CTRLF:
 	case SPRN_CTRLT:
-		vcpu->arch.gpr[rt] = 0;
+		kvmppc_set_gpr(vcpu, rt, 0);
 		break;
 	default:
 		printk(KERN_INFO "KVM: invalid SPR read: %d\n", sprn);
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index d8b6342..49af80e 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -69,10 +69,10 @@ void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < 32; i += 4) {
 		printk("gpr%02d: %08lx %08lx %08lx %08lx\n", i,
-		       vcpu->arch.gpr[i],
-		       vcpu->arch.gpr[i+1],
-		       vcpu->arch.gpr[i+2],
-		       vcpu->arch.gpr[i+3]);
+		       kvmppc_get_gpr(vcpu, i),
+		       kvmppc_get_gpr(vcpu, i+1),
+		       kvmppc_get_gpr(vcpu, i+2),
+		       kvmppc_get_gpr(vcpu, i+3));
 	}
 }
 
@@ -431,7 +431,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pc = 0;
 	vcpu->arch.msr = 0;
-	vcpu->arch.gpr[1] = (16<<20) - 8; /* -8 for the callee-save LR slot */
+	kvmppc_set_gpr(vcpu, 1, (16<<20) - 8); /* -8 for the callee-save LR slot */
 
 	vcpu->arch.shadow_pid = 1;
 
@@ -466,7 +466,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	regs->sprg7 = vcpu->arch.sprg6;
 
 	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
-		regs->gpr[i] = vcpu->arch.gpr[i];
+		regs->gpr[i] = kvmppc_get_gpr(vcpu, i);
 
 	return 0;
 }
@@ -491,8 +491,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	vcpu->arch.sprg6 = regs->sprg5;
 	vcpu->arch.sprg7 = regs->sprg6;
 
-	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gpr); i++)
-		vcpu->arch.gpr[i] = regs->gpr[i];
+	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
+		kvmppc_set_gpr(vcpu, i, regs->gpr[i]);
 
 	return 0;
 }
diff --git a/arch/powerpc/kvm/booke_emulate.c b/arch/powerpc/kvm/booke_emulate.c
index aebc65e..cbc790e 100644
--- a/arch/powerpc/kvm/booke_emulate.c
+++ b/arch/powerpc/kvm/booke_emulate.c
@@ -62,20 +62,20 @@ int kvmppc_booke_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 		case OP_31_XOP_MFMSR:
 			rt = get_rt(inst);
-			vcpu->arch.gpr[rt] = vcpu->arch.msr;
+			kvmppc_set_gpr(vcpu, rt, vcpu->arch.msr);
 			kvmppc_set_exit_type(vcpu, EMULATED_MFMSR_EXITS);
 			break;
 
 		case OP_31_XOP_MTMSR:
 			rs = get_rs(inst);
 			kvmppc_set_exit_type(vcpu, EMULATED_MTMSR_EXITS);
-			kvmppc_set_msr(vcpu, vcpu->arch.gpr[rs]);
+			kvmppc_set_msr(vcpu, kvmppc_get_gpr(vcpu, rs));
 			break;
 
 		case OP_31_XOP_WRTEE:
 			rs = get_rs(inst);
 			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
-							 | (vcpu->arch.gpr[rs] & MSR_EE);
+					| (kvmppc_get_gpr(vcpu, rs) & MSR_EE);
 			kvmppc_set_exit_type(vcpu, EMULATED_WRTEE_EXITS);
 			break;
 
@@ -101,22 +101,23 @@ int kvmppc_booke_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 {
 	int emulated = EMULATE_DONE;
+	ulong spr_val = kvmppc_get_gpr(vcpu, rs);
 
 	switch (sprn) {
 	case SPRN_DEAR:
-		vcpu->arch.dear = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.dear = spr_val; break;
 	case SPRN_ESR:
-		vcpu->arch.esr = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.esr = spr_val; break;
 	case SPRN_DBCR0:
-		vcpu->arch.dbcr0 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.dbcr0 = spr_val; break;
 	case SPRN_DBCR1:
-		vcpu->arch.dbcr1 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.dbcr1 = spr_val; break;
 	case SPRN_DBSR:
-		vcpu->arch.dbsr &= ~vcpu->arch.gpr[rs]; break;
+		vcpu->arch.dbsr &= ~spr_val; break;
 	case SPRN_TSR:
-		vcpu->arch.tsr &= ~vcpu->arch.gpr[rs]; break;
+		vcpu->arch.tsr &= ~spr_val; break;
 	case SPRN_TCR:
-		vcpu->arch.tcr = vcpu->arch.gpr[rs];
+		vcpu->arch.tcr = spr_val;
 		kvmppc_emulate_dec(vcpu);
 		break;
 
@@ -124,64 +125,64 @@ int kvmppc_booke_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 	 * loaded into the real SPRGs when resuming the
 	 * guest. */
 	case SPRN_SPRG4:
-		vcpu->arch.sprg4 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.sprg4 = spr_val; break;
 	case SPRN_SPRG5:
-		vcpu->arch.sprg5 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.sprg5 = spr_val; break;
 	case SPRN_SPRG6:
-		vcpu->arch.sprg6 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.sprg6 = spr_val; break;
 	case SPRN_SPRG7:
-		vcpu->arch.sprg7 = vcpu->arch.gpr[rs]; break;
+		vcpu->arch.sprg7 = spr_val; break;
 
 	case SPRN_IVPR:
-		vcpu->arch.ivpr = vcpu->arch.gpr[rs];
+		vcpu->arch.ivpr = spr_val;
 		break;
 	case SPRN_IVOR0:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL] = spr_val;
 		break;
 	case SPRN_IVOR1:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK] = spr_val;
 		break;
 	case SPRN_IVOR2:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE] = spr_val;
 		break;
 	case SPRN_IVOR3:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE] = spr_val;
 		break;
 	case SPRN_IVOR4:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL] = spr_val;
 		break;
 	case SPRN_IVOR5:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT] = spr_val;
 		break;
 	case SPRN_IVOR6:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM] = spr_val;
 		break;
 	case SPRN_IVOR7:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL] = spr_val;
 		break;
 	case SPRN_IVOR8:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL] = spr_val;
 		break;
 	case SPRN_IVOR9:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL] = spr_val;
 		break;
 	case SPRN_IVOR10:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER] = spr_val;
 		break;
 	case SPRN_IVOR11:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_FIT] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_FIT] = spr_val;
 		break;
 	case SPRN_IVOR12:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG] = spr_val;
 		break;
 	case SPRN_IVOR13:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS] = spr_val;
 		break;
 	case SPRN_IVOR14:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS] = spr_val;
 		break;
 	case SPRN_IVOR15:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG] = spr_val;
 		break;
 
 	default:
@@ -197,65 +198,65 @@ int kvmppc_booke_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 
 	switch (sprn) {
 	case SPRN_IVPR:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivpr; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivpr); break;
 	case SPRN_DEAR:
-		vcpu->arch.gpr[rt] = vcpu->arch.dear; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dear); break;
 	case SPRN_ESR:
-		vcpu->arch.gpr[rt] = vcpu->arch.esr; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.esr); break;
 	case SPRN_DBCR0:
-		vcpu->arch.gpr[rt] = vcpu->arch.dbcr0; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbcr0); break;
 	case SPRN_DBCR1:
-		vcpu->arch.gpr[rt] = vcpu->arch.dbcr1; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbcr1); break;
 	case SPRN_DBSR:
-		vcpu->arch.gpr[rt] = vcpu->arch.dbsr; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbsr); break;
 
 	case SPRN_IVOR0:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL]);
 		break;
 	case SPRN_IVOR1:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_MACHINE_CHECK]);
 		break;
 	case SPRN_IVOR2:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_DATA_STORAGE]);
 		break;
 	case SPRN_IVOR3:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_INST_STORAGE]);
 		break;
 	case SPRN_IVOR4:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_EXTERNAL]);
 		break;
 	case SPRN_IVOR5:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_ALIGNMENT]);
 		break;
 	case SPRN_IVOR6:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_PROGRAM]);
 		break;
 	case SPRN_IVOR7:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_FP_UNAVAIL]);
 		break;
 	case SPRN_IVOR8:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_SYSCALL]);
 		break;
 	case SPRN_IVOR9:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_AP_UNAVAIL]);
 		break;
 	case SPRN_IVOR10:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_DECREMENTER]);
 		break;
 	case SPRN_IVOR11:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_FIT];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_FIT]);
 		break;
 	case SPRN_IVOR12:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_WATCHDOG]);
 		break;
 	case SPRN_IVOR13:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_DTLB_MISS]);
 		break;
 	case SPRN_IVOR14:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_ITLB_MISS]);
 		break;
 	case SPRN_IVOR15:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_DEBUG]);
 		break;
 
 	default:
diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index be95b8d..7644f7a 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -74,54 +74,55 @@ int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 	int emulated = EMULATE_DONE;
+	ulong spr_val = kvmppc_get_gpr(vcpu, rs);
 
 	switch (sprn) {
 	case SPRN_PID:
 		vcpu_e500->pid[0] = vcpu->arch.shadow_pid =
-			vcpu->arch.pid = vcpu->arch.gpr[rs];
+			vcpu->arch.pid = spr_val;
 		break;
 	case SPRN_PID1:
-		vcpu_e500->pid[1] = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->pid[1] = spr_val; break;
 	case SPRN_PID2:
-		vcpu_e500->pid[2] = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->pid[2] = spr_val; break;
 	case SPRN_MAS0:
-		vcpu_e500->mas0 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->mas0 = spr_val; break;
 	case SPRN_MAS1:
-		vcpu_e500->mas1 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->mas1 = spr_val; break;
 	case SPRN_MAS2:
-		vcpu_e500->mas2 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->mas2 = spr_val; break;
 	case SPRN_MAS3:
-		vcpu_e500->mas3 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->mas3 = spr_val; break;
 	case SPRN_MAS4:
-		vcpu_e500->mas4 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->mas4 = spr_val; break;
 	case SPRN_MAS6:
-		vcpu_e500->mas6 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->mas6 = spr_val; break;
 	case SPRN_MAS7:
-		vcpu_e500->mas7 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->mas7 = spr_val; break;
 	case SPRN_L1CSR1:
-		vcpu_e500->l1csr1 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->l1csr1 = spr_val; break;
 	case SPRN_HID0:
-		vcpu_e500->hid0 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->hid0 = spr_val; break;
 	case SPRN_HID1:
-		vcpu_e500->hid1 = vcpu->arch.gpr[rs]; break;
+		vcpu_e500->hid1 = spr_val; break;
 
 	case SPRN_MMUCSR0:
 		emulated = kvmppc_e500_emul_mt_mmucsr0(vcpu_e500,
-				vcpu->arch.gpr[rs]);
+				spr_val);
 		break;
 
 	/* extra exceptions */
 	case SPRN_IVOR32:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL] = spr_val;
 		break;
 	case SPRN_IVOR33:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_DATA] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_DATA] = spr_val;
 		break;
 	case SPRN_IVOR34:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_ROUND] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_ROUND] = spr_val;
 		break;
 	case SPRN_IVOR35:
-		vcpu->arch.ivor[BOOKE_IRQPRIO_PERFORMANCE_MONITOR] = vcpu->arch.gpr[rs];
+		vcpu->arch.ivor[BOOKE_IRQPRIO_PERFORMANCE_MONITOR] = spr_val;
 		break;
 
 	default:
@@ -138,63 +139,71 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 
 	switch (sprn) {
 	case SPRN_PID:
-		vcpu->arch.gpr[rt] = vcpu_e500->pid[0]; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->pid[0]); break;
 	case SPRN_PID1:
-		vcpu->arch.gpr[rt] = vcpu_e500->pid[1]; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->pid[1]); break;
 	case SPRN_PID2:
-		vcpu->arch.gpr[rt] = vcpu_e500->pid[2]; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->pid[2]); break;
 	case SPRN_MAS0:
-		vcpu->arch.gpr[rt] = vcpu_e500->mas0; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas0); break;
 	case SPRN_MAS1:
-		vcpu->arch.gpr[rt] = vcpu_e500->mas1; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas1); break;
 	case SPRN_MAS2:
-		vcpu->arch.gpr[rt] = vcpu_e500->mas2; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas2); break;
 	case SPRN_MAS3:
-		vcpu->arch.gpr[rt] = vcpu_e500->mas3; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas3); break;
 	case SPRN_MAS4:
-		vcpu->arch.gpr[rt] = vcpu_e500->mas4; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas4); break;
 	case SPRN_MAS6:
-		vcpu->arch.gpr[rt] = vcpu_e500->mas6; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas6); break;
 	case SPRN_MAS7:
-		vcpu->arch.gpr[rt] = vcpu_e500->mas7; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas7); break;
 
 	case SPRN_TLB0CFG:
-		vcpu->arch.gpr[rt] = mfspr(SPRN_TLB0CFG);
-		vcpu->arch.gpr[rt] &= ~0xfffUL;
-		vcpu->arch.gpr[rt] |= vcpu_e500->guest_tlb_size[0];
+	{
+		ulong tmp = SPRN_TLB0CFG;
+
+		tmp &= ~0xfffUL;
+		tmp |= vcpu_e500->guest_tlb_size[0];
+		kvmppc_set_gpr(vcpu, rt, tmp);
 		break;
+	}
 
 	case SPRN_TLB1CFG:
-		vcpu->arch.gpr[rt] = mfspr(SPRN_TLB1CFG);
-		vcpu->arch.gpr[rt] &= ~0xfffUL;
-		vcpu->arch.gpr[rt] |= vcpu_e500->guest_tlb_size[1];
+	{
+		ulong tmp = SPRN_TLB1CFG;
+
+		tmp &= ~0xfffUL;
+		tmp |= vcpu_e500->guest_tlb_size[1];
+		kvmppc_set_gpr(vcpu, rt, tmp);
 		break;
+	}
 
 	case SPRN_L1CSR1:
-		vcpu->arch.gpr[rt] = vcpu_e500->l1csr1; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->l1csr1); break;
 	case SPRN_HID0:
-		vcpu->arch.gpr[rt] = vcpu_e500->hid0; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->hid0); break;
 	case SPRN_HID1:
-		vcpu->arch.gpr[rt] = vcpu_e500->hid1; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->hid1); break;
 
 	case SPRN_MMUCSR0:
-		vcpu->arch.gpr[rt] = 0; break;
+		kvmppc_set_gpr(vcpu, rt, 0); break;
 
 	case SPRN_MMUCFG:
-		vcpu->arch.gpr[rt] = mfspr(SPRN_MMUCFG); break;
+		kvmppc_set_gpr(vcpu, rt, mfspr(SPRN_MMUCFG)); break;
 
 	/* extra exceptions */
 	case SPRN_IVOR32:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL]);
 		break;
 	case SPRN_IVOR33:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_DATA];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_DATA]);
 		break;
 	case SPRN_IVOR34:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_ROUND];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_FP_ROUND]);
 		break;
 	case SPRN_IVOR35:
-		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_PERFORMANCE_MONITOR];
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_PERFORMANCE_MONITOR]);
 		break;
 	default:
 		emulated = kvmppc_booke_emulate_mfspr(vcpu, sprn, rt);
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index fb1e1dc..6a7fc01 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -417,7 +417,7 @@ int kvmppc_e500_emul_tlbivax(struct kvm_vcpu *vcpu, int ra, int rb)
 	int esel, tlbsel;
 	gva_t ea;
 
-	ea = ((ra) ? vcpu->arch.gpr[ra] : 0) + vcpu->arch.gpr[rb];
+	ea = ((ra) ? kvmppc_get_gpr(vcpu, ra) : 0) + kvmppc_get_gpr(vcpu, rb);
 
 	ia = (ea >> 2) & 0x1;
 
@@ -470,7 +470,7 @@ int kvmppc_e500_emul_tlbsx(struct kvm_vcpu *vcpu, int rb)
 	struct tlbe *gtlbe = NULL;
 	gva_t ea;
 
-	ea = vcpu->arch.gpr[rb];
+	ea = kvmppc_get_gpr(vcpu, rb);
 
 	for (tlbsel = 0; tlbsel < 2; tlbsel++) {
 		esel = kvmppc_e500_tlb_index(vcpu_e500, ea, tlbsel, pid, as);
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 303457b..38219af 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -170,14 +170,14 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		case OP_31_XOP_STWX:
 			rs = get_rs(inst);
 			emulated = kvmppc_handle_store(run, vcpu,
-			                               vcpu->arch.gpr[rs],
+						       kvmppc_get_gpr(vcpu, rs),
 			                               4, 1);
 			break;
 
 		case OP_31_XOP_STBX:
 			rs = get_rs(inst);
 			emulated = kvmppc_handle_store(run, vcpu,
-			                               vcpu->arch.gpr[rs],
+						       kvmppc_get_gpr(vcpu, rs),
 			                               1, 1);
 			break;
 
@@ -186,14 +186,14 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			ra = get_ra(inst);
 			rb = get_rb(inst);
 
-			ea = vcpu->arch.gpr[rb];
+			ea = kvmppc_get_gpr(vcpu, rb);
 			if (ra)
-				ea += vcpu->arch.gpr[ra];
+				ea += kvmppc_get_gpr(vcpu, ra);
 
 			emulated = kvmppc_handle_store(run, vcpu,
-			                               vcpu->arch.gpr[rs],
+						       kvmppc_get_gpr(vcpu, rs),
 			                               1, 1);
-			vcpu->arch.gpr[rs] = ea;
+			kvmppc_set_gpr(vcpu, rs, ea);
 			break;
 
 		case OP_31_XOP_LHZX:
@@ -206,12 +206,12 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			ra = get_ra(inst);
 			rb = get_rb(inst);
 
-			ea = vcpu->arch.gpr[rb];
+			ea = kvmppc_get_gpr(vcpu, rb);
 			if (ra)
-				ea += vcpu->arch.gpr[ra];
+				ea += kvmppc_get_gpr(vcpu, ra);
 
 			emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
-			vcpu->arch.gpr[ra] = ea;
+			kvmppc_set_gpr(vcpu, ra, ea);
 			break;
 
 		case OP_31_XOP_MFSPR:
@@ -220,47 +220,49 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 
 			switch (sprn) {
 			case SPRN_SRR0:
-				vcpu->arch.gpr[rt] = vcpu->arch.srr0; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.srr0); break;
 			case SPRN_SRR1:
-				vcpu->arch.gpr[rt] = vcpu->arch.srr1; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.srr1); break;
 			case SPRN_PVR:
-				vcpu->arch.gpr[rt] = vcpu->arch.pvr; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.pvr); break;
 			case SPRN_PIR:
-				vcpu->arch.gpr[rt] = vcpu->vcpu_id; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->vcpu_id); break;
 			case SPRN_MSSSR0:
-				vcpu->arch.gpr[rt] = 0; break;
+				kvmppc_set_gpr(vcpu, rt, 0); break;
 
 			/* Note: mftb and TBRL/TBWL are user-accessible, so
 			 * the guest can always access the real TB anyways.
 			 * In fact, we probably will never see these traps. */
 			case SPRN_TBWL:
-				vcpu->arch.gpr[rt] = get_tb() >> 32; break;
+				kvmppc_set_gpr(vcpu, rt, get_tb() >> 32); break;
 			case SPRN_TBWU:
-				vcpu->arch.gpr[rt] = get_tb(); break;
+				kvmppc_set_gpr(vcpu, rt, get_tb()); break;
 
 			case SPRN_SPRG0:
-				vcpu->arch.gpr[rt] = vcpu->arch.sprg0; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.sprg0); break;
 			case SPRN_SPRG1:
-				vcpu->arch.gpr[rt] = vcpu->arch.sprg1; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.sprg1); break;
 			case SPRN_SPRG2:
-				vcpu->arch.gpr[rt] = vcpu->arch.sprg2; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.sprg2); break;
 			case SPRN_SPRG3:
-				vcpu->arch.gpr[rt] = vcpu->arch.sprg3; break;
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.sprg3); break;
 			/* Note: SPRG4-7 are user-readable, so we don't get
 			 * a trap. */
 
 			case SPRN_DEC:
 			{
 				u64 jd = get_tb() - vcpu->arch.dec_jiffies;
-				vcpu->arch.gpr[rt] = vcpu->arch.dec - jd;
-				pr_debug(KERN_INFO "mfDEC: %x - %llx = %lx\n", vcpu->arch.dec, jd, vcpu->arch.gpr[rt]);
+				kvmppc_set_gpr(vcpu, rt, vcpu->arch.dec - jd);
+				pr_debug(KERN_INFO "mfDEC: %x - %llx = %lx\n",
+					 vcpu->arch.dec, jd,
+					 kvmppc_get_gpr(vcpu, rt));
 				break;
 			}
 			default:
 				emulated = kvmppc_core_emulate_mfspr(vcpu, sprn, rt);
 				if (emulated == EMULATE_FAIL) {
 					printk("mfspr: unknown spr %x\n", sprn);
-					vcpu->arch.gpr[rt] = 0;
+					kvmppc_set_gpr(vcpu, rt, 0);
 				}
 				break;
 			}
@@ -272,7 +274,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			rb = get_rb(inst);
 
 			emulated = kvmppc_handle_store(run, vcpu,
-			                               vcpu->arch.gpr[rs],
+						       kvmppc_get_gpr(vcpu, rs),
 			                               2, 1);
 			break;
 
@@ -281,14 +283,14 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			ra = get_ra(inst);
 			rb = get_rb(inst);
 
-			ea = vcpu->arch.gpr[rb];
+			ea = kvmppc_get_gpr(vcpu, rb);
 			if (ra)
-				ea += vcpu->arch.gpr[ra];
+				ea += kvmppc_get_gpr(vcpu, ra);
 
 			emulated = kvmppc_handle_store(run, vcpu,
-			                               vcpu->arch.gpr[rs],
+						       kvmppc_get_gpr(vcpu, rs),
 			                               2, 1);
-			vcpu->arch.gpr[ra] = ea;
+			kvmppc_set_gpr(vcpu, ra, ea);
 			break;
 
 		case OP_31_XOP_MTSPR:
@@ -296,9 +298,9 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			rs = get_rs(inst);
 			switch (sprn) {
 			case SPRN_SRR0:
-				vcpu->arch.srr0 = vcpu->arch.gpr[rs]; break;
+				vcpu->arch.srr0 = kvmppc_get_gpr(vcpu, rs); break;
 			case SPRN_SRR1:
-				vcpu->arch.srr1 = vcpu->arch.gpr[rs]; break;
+				vcpu->arch.srr1 = kvmppc_get_gpr(vcpu, rs); break;
 
 			/* XXX We need to context-switch the timebase for
 			 * watchdog and FIT. */
@@ -308,18 +310,18 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			case SPRN_MSSSR0: break;
 
 			case SPRN_DEC:
-				vcpu->arch.dec = vcpu->arch.gpr[rs];
+				vcpu->arch.dec = kvmppc_get_gpr(vcpu, rs);
 				kvmppc_emulate_dec(vcpu);
 				break;
 
 			case SPRN_SPRG0:
-				vcpu->arch.sprg0 = vcpu->arch.gpr[rs]; break;
+				vcpu->arch.sprg0 = kvmppc_get_gpr(vcpu, rs); break;
 			case SPRN_SPRG1:
-				vcpu->arch.sprg1 = vcpu->arch.gpr[rs]; break;
+				vcpu->arch.sprg1 = kvmppc_get_gpr(vcpu, rs); break;
 			case SPRN_SPRG2:
-				vcpu->arch.sprg2 = vcpu->arch.gpr[rs]; break;
+				vcpu->arch.sprg2 = kvmppc_get_gpr(vcpu, rs); break;
 			case SPRN_SPRG3:
-				vcpu->arch.sprg3 = vcpu->arch.gpr[rs]; break;
+				vcpu->arch.sprg3 = kvmppc_get_gpr(vcpu, rs); break;
 
 			default:
 				emulated = kvmppc_core_emulate_mtspr(vcpu, sprn, rs);
@@ -351,7 +353,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			rb = get_rb(inst);
 
 			emulated = kvmppc_handle_store(run, vcpu,
-			                               vcpu->arch.gpr[rs],
+						       kvmppc_get_gpr(vcpu, rs),
 			                               4, 0);
 			break;
 
@@ -366,7 +368,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			rb = get_rb(inst);
 
 			emulated = kvmppc_handle_store(run, vcpu,
-			                               vcpu->arch.gpr[rs],
+						       kvmppc_get_gpr(vcpu, rs),
 			                               2, 0);
 			break;
 
@@ -385,7 +387,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		ra = get_ra(inst);
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 4, 1);
-		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		kvmppc_set_gpr(vcpu, ra, vcpu->arch.paddr_accessed);
 		break;
 
 	case OP_LBZ:
@@ -397,35 +399,39 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		ra = get_ra(inst);
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 1, 1);
-		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		kvmppc_set_gpr(vcpu, ra, vcpu->arch.paddr_accessed);
 		break;
 
 	case OP_STW:
 		rs = get_rs(inst);
-		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		emulated = kvmppc_handle_store(run, vcpu,
+					       kvmppc_get_gpr(vcpu, rs),
 		                               4, 1);
 		break;
 
 	case OP_STWU:
 		ra = get_ra(inst);
 		rs = get_rs(inst);
-		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		emulated = kvmppc_handle_store(run, vcpu,
+					       kvmppc_get_gpr(vcpu, rs),
 		                               4, 1);
-		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		kvmppc_set_gpr(vcpu, ra, vcpu->arch.paddr_accessed);
 		break;
 
 	case OP_STB:
 		rs = get_rs(inst);
-		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		emulated = kvmppc_handle_store(run, vcpu,
+					       kvmppc_get_gpr(vcpu, rs),
 		                               1, 1);
 		break;
 
 	case OP_STBU:
 		ra = get_ra(inst);
 		rs = get_rs(inst);
-		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		emulated = kvmppc_handle_store(run, vcpu,
+					       kvmppc_get_gpr(vcpu, rs),
 		                               1, 1);
-		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		kvmppc_set_gpr(vcpu, ra, vcpu->arch.paddr_accessed);
 		break;
 
 	case OP_LHZ:
@@ -437,21 +443,23 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		ra = get_ra(inst);
 		rt = get_rt(inst);
 		emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
-		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		kvmppc_set_gpr(vcpu, ra, vcpu->arch.paddr_accessed);
 		break;
 
 	case OP_STH:
 		rs = get_rs(inst);
-		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		emulated = kvmppc_handle_store(run, vcpu,
+					       kvmppc_get_gpr(vcpu, rs),
 		                               2, 1);
 		break;
 
 	case OP_STHU:
 		ra = get_ra(inst);
 		rs = get_rs(inst);
-		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		emulated = kvmppc_handle_store(run, vcpu,
+					       kvmppc_get_gpr(vcpu, rs),
 		                               2, 1);
-		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		kvmppc_set_gpr(vcpu, ra, vcpu->arch.paddr_accessed);
 		break;
 
 	default:
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 4633e78..2c29116 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -270,34 +270,35 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 static void kvmppc_complete_dcr_load(struct kvm_vcpu *vcpu,
                                      struct kvm_run *run)
 {
-	ulong *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
-	*gpr = run->dcr.data;
+	kvmppc_set_gpr(vcpu, vcpu->arch.io_gpr, run->dcr.data);
 }
 
 static void kvmppc_complete_mmio_load(struct kvm_vcpu *vcpu,
                                       struct kvm_run *run)
 {
-	ulong *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
+	ulong gpr;
 
-	if (run->mmio.len > sizeof(*gpr)) {
+	if (run->mmio.len > sizeof(gpr)) {
 		printk(KERN_ERR "bad MMIO length: %d\n", run->mmio.len);
 		return;
 	}
 
 	if (vcpu->arch.mmio_is_bigendian) {
 		switch (run->mmio.len) {
-		case 4: *gpr = *(u32 *)run->mmio.data; break;
-		case 2: *gpr = *(u16 *)run->mmio.data; break;
-		case 1: *gpr = *(u8 *)run->mmio.data; break;
+		case 4: gpr = *(u32 *)run->mmio.data; break;
+		case 2: gpr = *(u16 *)run->mmio.data; break;
+		case 1: gpr = *(u8 *)run->mmio.data; break;
 		}
 	} else {
 		/* Convert BE data from userland back to LE. */
 		switch (run->mmio.len) {
-		case 4: *gpr = ld_le32((u32 *)run->mmio.data); break;
-		case 2: *gpr = ld_le16((u16 *)run->mmio.data); break;
-		case 1: *gpr = *(u8 *)run->mmio.data; break;
+		case 4: gpr = ld_le32((u32 *)run->mmio.data); break;
+		case 2: gpr = ld_le16((u16 *)run->mmio.data); break;
+		case 1: gpr = *(u8 *)run->mmio.data; break;
 		}
 	}
+
+	kvmppc_set_gpr(vcpu, vcpu->arch.io_gpr, gpr);
 }
 
 int kvmppc_handle_load(struct kvm_run *run, struct kvm_vcpu *vcpu,
-- 
1.6.5.3

