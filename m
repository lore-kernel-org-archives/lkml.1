Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXIQJAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXIQJAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXIQIdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:45296 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbXIQIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 052/104] KVM: Cleanup string I/O instruction emulation
Date: Mon, 17 Sep 2007 10:31:34 +0200
Message-Id: <11900179481015-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Both vmx and svm decode the I/O instructions, and both botch the job,
requiring the instruction prefixes to be fetched in order to completely
decode the instruction.

So, if we see a string I/O instruction, use the x86 emulator to decode it,
as it already has all the prefix decoding machinery.

This patch defines ins/outs opcodes in x86_emulate.c and calls
emulate_instruction() from io_interception() (svm.c) and from handle_io()
(vmx.c).  It removes all vmx/svm prefix instruction decoders
(get_addr_size(), io_get_override(), io_address(), get_io_count())

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c    |    3 +
 drivers/kvm/svm.c         |  149 +++------------------------------------------
 drivers/kvm/vmx.c         |   76 ++++-------------------
 drivers/kvm/x86_emulate.c |   49 +++++++++++++--
 4 files changed, 69 insertions(+), 208 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 62adaee..661d065 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1221,7 +1221,10 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	emulate_ctxt.fs_base = get_segment_base(vcpu, VCPU_SREG_FS);
 
 	vcpu->mmio_is_write = 0;
+	vcpu->pio.string = 0;
 	r = x86_emulate_memop(&emulate_ctxt, &emulate_ops);
+	if (vcpu->pio.string)
+		return EMULATE_DO_MMIO;
 
 	if ((r || vcpu->mmio_is_write) && run) {
 		run->exit_reason = KVM_EXIT_MMIO;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 436bdff..a83ff01 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -98,20 +98,6 @@ static inline u32 svm_has(u32 feat)
 	return svm_features & feat;
 }
 
-static unsigned get_addr_size(struct vcpu_svm *svm)
-{
-	struct vmcb_save_area *sa = &svm->vmcb->save;
-	u16 cs_attrib;
-
-	if (!(sa->cr0 & X86_CR0_PE) || (sa->rflags & X86_EFLAGS_VM))
-		return 2;
-
-	cs_attrib = sa->cs.attrib;
-
-	return (cs_attrib & SVM_SELECTOR_L_MASK) ? 8 :
-				(cs_attrib & SVM_SELECTOR_DB_MASK) ? 4 : 2;
-}
-
 static inline u8 pop_irq(struct kvm_vcpu *vcpu)
 {
 	int word_index = __ffs(vcpu->irq_summary);
@@ -995,147 +981,32 @@ static int shutdown_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	return 0;
 }
 
-static int io_get_override(struct vcpu_svm *svm,
-			  struct vmcb_seg **seg,
-			  int *addr_override)
-{
-	u8 inst[MAX_INST_SIZE];
-	unsigned ins_length;
-	gva_t rip;
-	int i;
-
-	rip =  svm->vmcb->save.rip;
-	ins_length = svm->next_rip - rip;
-	rip += svm->vmcb->save.cs.base;
-
-	if (ins_length > MAX_INST_SIZE)
-		printk(KERN_DEBUG
-		       "%s: inst length err, cs base 0x%llx rip 0x%llx "
-		       "next rip 0x%llx ins_length %u\n",
-		       __FUNCTION__,
-		       svm->vmcb->save.cs.base,
-		       svm->vmcb->save.rip,
-		       svm->vmcb->control.exit_info_2,
-		       ins_length);
-
-	if (emulator_read_std(rip, inst, ins_length, &svm->vcpu)
-	    != X86EMUL_CONTINUE)
-		/* #PF */
-		return 0;
-
-	*addr_override = 0;
-	*seg = NULL;
-	for (i = 0; i < ins_length; i++)
-		switch (inst[i]) {
-		case 0xf0:
-		case 0xf2:
-		case 0xf3:
-		case 0x66:
-			continue;
-		case 0x67:
-			*addr_override = 1;
-			continue;
-		case 0x2e:
-			*seg = &svm->vmcb->save.cs;
-			continue;
-		case 0x36:
-			*seg = &svm->vmcb->save.ss;
-			continue;
-		case 0x3e:
-			*seg = &svm->vmcb->save.ds;
-			continue;
-		case 0x26:
-			*seg = &svm->vmcb->save.es;
-			continue;
-		case 0x64:
-			*seg = &svm->vmcb->save.fs;
-			continue;
-		case 0x65:
-			*seg = &svm->vmcb->save.gs;
-			continue;
-		default:
-			return 1;
-		}
-	printk(KERN_DEBUG "%s: unexpected\n", __FUNCTION__);
-	return 0;
-}
-
-static unsigned long io_address(struct vcpu_svm *svm, int ins, gva_t *address)
-{
-	unsigned long addr_mask;
-	unsigned long *reg;
-	struct vmcb_seg *seg;
-	int addr_override;
-	struct vmcb_save_area *save_area = &svm->vmcb->save;
-	u16 cs_attrib = save_area->cs.attrib;
-	unsigned addr_size = get_addr_size(svm);
-
-	if (!io_get_override(svm, &seg, &addr_override))
-		return 0;
-
-	if (addr_override)
-		addr_size = (addr_size == 2) ? 4: (addr_size >> 1);
-
-	if (ins) {
-		reg = &svm->vcpu.regs[VCPU_REGS_RDI];
-		seg = &svm->vmcb->save.es;
-	} else {
-		reg = &svm->vcpu.regs[VCPU_REGS_RSI];
-		seg = (seg) ? seg : &svm->vmcb->save.ds;
-	}
-
-	addr_mask = ~0ULL >> (64 - (addr_size * 8));
-
-	if ((cs_attrib & SVM_SELECTOR_L_MASK) &&
-	    !(svm->vmcb->save.rflags & X86_EFLAGS_VM)) {
-		*address = (*reg & addr_mask);
-		return addr_mask;
-	}
-
-	if (!(seg->attrib & SVM_SELECTOR_P_SHIFT)) {
-		svm_inject_gp(&svm->vcpu, 0);
-		return 0;
-	}
-
-	*address = (*reg & addr_mask) + seg->base;
-	return addr_mask;
-}
-
 static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	u32 io_info = svm->vmcb->control.exit_info_1; //address size bug?
 	int size, down, in, string, rep;
 	unsigned port;
-	unsigned long count;
-	gva_t address = 0;
 
 	++svm->vcpu.stat.io_exits;
 
 	svm->next_rip = svm->vmcb->control.exit_info_2;
 
+	string = (io_info & SVM_IOIO_STR_MASK) != 0;
+
+	if (string) {
+		if (emulate_instruction(&svm->vcpu, kvm_run, 0, 0) == EMULATE_DO_MMIO)
+			return 0;
+		return 1;
+	}
+
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
 	port = io_info >> 16;
 	size = (io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT;
-	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	rep = (io_info & SVM_IOIO_REP_MASK) != 0;
-	count = 1;
 	down = (svm->vmcb->save.rflags & X86_EFLAGS_DF) != 0;
 
-	if (string) {
-		unsigned addr_mask;
-
-		addr_mask = io_address(svm, in, &address);
-		if (!addr_mask) {
-			printk(KERN_DEBUG "%s: get io address failed\n",
-			       __FUNCTION__);
-			return 1;
-		}
-
-		if (rep)
-			count = svm->vcpu.regs[VCPU_REGS_RCX] & addr_mask;
-	}
-	return kvm_setup_pio(&svm->vcpu, kvm_run, in, size, count, string,
-			     down, address, rep, port);
+	return kvm_setup_pio(&svm->vcpu, kvm_run, in, size, 1, 0,
+			     down, 0, rep, port);
 }
 
 static int nop_on_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 30c627d..044722b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1763,82 +1763,30 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 0;
 }
 
-static int get_io_count(struct kvm_vcpu *vcpu, unsigned long *count)
-{
-	u64 inst;
-	gva_t rip;
-	int countr_size;
-	int i;
-
-	if ((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_VM)) {
-		countr_size = 2;
-	} else {
-		u32 cs_ar = vmcs_read32(GUEST_CS_AR_BYTES);
-
-		countr_size = (cs_ar & AR_L_MASK) ? 8:
-			      (cs_ar & AR_DB_MASK) ? 4: 2;
-	}
-
-	rip =  vmcs_readl(GUEST_RIP);
-	if (countr_size != 8)
-		rip += vmcs_readl(GUEST_CS_BASE);
-
-	if (emulator_read_std(rip, &inst, sizeof(inst), vcpu) !=
-							X86EMUL_CONTINUE)
-		return 0;
-
-	for (i = 0; i < sizeof(inst); i++) {
-		switch (((u8*)&inst)[i]) {
-		case 0xf0:
-		case 0xf2:
-		case 0xf3:
-		case 0x2e:
-		case 0x36:
-		case 0x3e:
-		case 0x26:
-		case 0x64:
-		case 0x65:
-		case 0x66:
-			break;
-		case 0x67:
-			countr_size = (countr_size == 2) ? 4: (countr_size >> 1);
-		default:
-			goto done;
-		}
-	}
-	return 0;
-done:
-	countr_size *= 8;
-	*count = vcpu->regs[VCPU_REGS_RCX] & (~0ULL >> (64 - countr_size));
-	//printk("cx: %lx\n", vcpu->regs[VCPU_REGS_RCX]);
-	return 1;
-}
-
 static int handle_io(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification;
 	int size, down, in, string, rep;
 	unsigned port;
-	unsigned long count;
-	gva_t address;
 
 	++vcpu->stat.io_exits;
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
-	in = (exit_qualification & 8) != 0;
-	size = (exit_qualification & 7) + 1;
 	string = (exit_qualification & 16) != 0;
+
+	if (string) {
+		if (emulate_instruction(vcpu, kvm_run, 0, 0) == EMULATE_DO_MMIO)
+			return 0;
+		return 1;
+	}
+
+	size = (exit_qualification & 7) + 1;
+	in = (exit_qualification & 8) != 0;
 	down = (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_DF) != 0;
-	count = 1;
 	rep = (exit_qualification & 32) != 0;
 	port = exit_qualification >> 16;
-	address = 0;
-	if (string) {
-		if (rep && !get_io_count(vcpu, &count))
-			return 1;
-		address = vmcs_readl(GUEST_LINEAR_ADDRESS);
-	}
-	return kvm_setup_pio(vcpu, kvm_run, in, size, count, string, down,
-			     address, rep, port);
+
+	return kvm_setup_pio(vcpu, kvm_run, in, size, 1, 0, down,
+			     0, rep, port);
 }
 
 static void
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 44eb28d..d553719 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -103,9 +103,12 @@ static u8 opcode_table[256] = {
 	/* 0x58 - 0x5F */
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	/* 0x60 - 0x6F */
+	/* 0x60 - 0x6B */
 	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0x6C - 0x6F */
+	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* insb, insw/insd */
+	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* outsb, outsw/outsd */
 	/* 0x70 - 0x7F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x80 - 0x87 */
@@ -428,10 +431,11 @@ struct operand {
 })
 
 /* Access/update address held in a register, based on addressing mode. */
+#define address_mask(reg)						\
+	((ad_bytes == sizeof(unsigned long)) ? 				\
+		(reg) :	((reg) & ((1UL << (ad_bytes << 3)) - 1)))
 #define register_address(base, reg)                                     \
-	((base) + ((ad_bytes == sizeof(unsigned long)) ? (reg) :	\
-		   ((reg) & ((1UL << (ad_bytes << 3)) - 1))))
-
+	((base) + address_mask(reg))
 #define register_address_increment(reg, inc)                            \
 	do {								\
 		/* signed type ensures sign extension to long */        \
@@ -1116,6 +1120,41 @@ done:
 special_insn:
 	if (twobyte)
 		goto twobyte_special_insn;
+	switch(b) {
+	case 0x6c:		/* insb */
+	case 0x6d:		/* insw/insd */
+		 if (kvm_setup_pio(ctxt->vcpu, NULL,
+				1, 					/* in */
+				(d & ByteOp) ? 1 : op_bytes, 		/* size */
+				rep_prefix ?
+				address_mask(_regs[VCPU_REGS_RCX]) : 1,	/* count */
+				1, 					/* strings */
+				(_eflags & EFLG_DF),			/* down */
+				register_address(ctxt->es_base,
+						 _regs[VCPU_REGS_RDI]),	/* address */
+				rep_prefix,
+				_regs[VCPU_REGS_RDX]			/* port */
+				) == 0)
+			return -1;
+		return 0;
+	case 0x6e:		/* outsb */
+	case 0x6f:		/* outsw/outsd */
+		if (kvm_setup_pio(ctxt->vcpu, NULL,
+				0, 					/* in */
+				(d & ByteOp) ? 1 : op_bytes, 		/* size */
+				rep_prefix ?
+				address_mask(_regs[VCPU_REGS_RCX]) : 1,	/* count */
+				1, 					/* strings */
+				(_eflags & EFLG_DF),			/* down */
+				register_address(override_base ?
+						 *override_base : ctxt->ds_base,
+						 _regs[VCPU_REGS_RSI]),	/* address */
+				rep_prefix,
+				_regs[VCPU_REGS_RDX]			/* port */
+				) == 0)
+			return -1;
+		return 0;
+	}
 	if (rep_prefix) {
 		if (_regs[VCPU_REGS_RCX] == 0) {
 			ctxt->vcpu->rip = _eip;
-- 
1.5.3

