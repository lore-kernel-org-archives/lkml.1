Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbXLZLOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbXLZLOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXLZLGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:43 -0500
Received: from il.qumranet.com ([82.166.9.18]:50471 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 25/55] KVM: Portability: Move x86 emulation and mmio device hook to x86.c
Date: Wed, 26 Dec 2007 13:05:30 +0200
Message-Id: <1198667160-22953-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch moves the following functions to from kvm_main.c to x86.c:
emulator_read/write_std, vcpu_find_pervcpu_dev, vcpu_find_mmio_dev,
emulator_read/write_emulated, emulator_write_phys,
emulator_write_emulated_onepage, emulator_cmpxchg_emulated,
get_setment_base, emulate_invlpg, emulate_clts, emulator_get/set_dr,
kvm_report_emulation_failure, emulate_instruction

The following data type is moved to x86.c:
struct x86_emulate_ops emulate_ops

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |  357 -----------------------------------------------
 drivers/kvm/x86.c      |  358 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 358 insertions(+), 357 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5eccf27..2c5529c 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -827,369 +827,12 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	}
 }
 
-int emulator_read_std(unsigned long addr,
-			     void *val,
-			     unsigned int bytes,
-			     struct kvm_vcpu *vcpu)
-{
-	void *data = val;
-
-	while (bytes) {
-		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
-		unsigned offset = addr & (PAGE_SIZE-1);
-		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
-		int ret;
-
-		if (gpa == UNMAPPED_GVA)
-			return X86EMUL_PROPAGATE_FAULT;
-		ret = kvm_read_guest(vcpu->kvm, gpa, data, tocopy);
-		if (ret < 0)
-			return X86EMUL_UNHANDLEABLE;
-
-		bytes -= tocopy;
-		data += tocopy;
-		addr += tocopy;
-	}
-
-	return X86EMUL_CONTINUE;
-}
-EXPORT_SYMBOL_GPL(emulator_read_std);
-
-static int emulator_write_std(unsigned long addr,
-			      const void *val,
-			      unsigned int bytes,
-			      struct kvm_vcpu *vcpu)
-{
-	pr_unimpl(vcpu, "emulator_write_std: addr %lx n %d\n", addr, bytes);
-	return X86EMUL_UNHANDLEABLE;
-}
-
-/*
- * Only apic need an MMIO device hook, so shortcut now..
- */
-static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
-						gpa_t addr)
-{
-	struct kvm_io_device *dev;
-
-	if (vcpu->apic) {
-		dev = &vcpu->apic->dev;
-		if (dev->in_range(dev, addr))
-			return dev;
-	}
-	return NULL;
-}
-
-static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
-						gpa_t addr)
-{
-	struct kvm_io_device *dev;
-
-	dev = vcpu_find_pervcpu_dev(vcpu, addr);
-	if (dev == NULL)
-		dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr);
-	return dev;
-}
-
 static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
 					       gpa_t addr)
 {
 	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr);
 }
 
-static int emulator_read_emulated(unsigned long addr,
-				  void *val,
-				  unsigned int bytes,
-				  struct kvm_vcpu *vcpu)
-{
-	struct kvm_io_device *mmio_dev;
-	gpa_t                 gpa;
-
-	if (vcpu->mmio_read_completed) {
-		memcpy(val, vcpu->mmio_data, bytes);
-		vcpu->mmio_read_completed = 0;
-		return X86EMUL_CONTINUE;
-	}
-
-	gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
-
-	/* For APIC access vmexit */
-	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
-		goto mmio;
-
-	if (emulator_read_std(addr, val, bytes, vcpu)
-			== X86EMUL_CONTINUE)
-		return X86EMUL_CONTINUE;
-	if (gpa == UNMAPPED_GVA)
-		return X86EMUL_PROPAGATE_FAULT;
-
-mmio:
-	/*
-	 * Is this MMIO handled locally?
-	 */
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
-	if (mmio_dev) {
-		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
-		return X86EMUL_CONTINUE;
-	}
-
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_phys_addr = gpa;
-	vcpu->mmio_size = bytes;
-	vcpu->mmio_is_write = 0;
-
-	return X86EMUL_UNHANDLEABLE;
-}
-
-static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       const void *val, int bytes)
-{
-	int ret;
-
-	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
-	if (ret < 0)
-		return 0;
-	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
-	return 1;
-}
-
-static int emulator_write_emulated_onepage(unsigned long addr,
-					   const void *val,
-					   unsigned int bytes,
-					   struct kvm_vcpu *vcpu)
-{
-	struct kvm_io_device *mmio_dev;
-	gpa_t                 gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
-
-	if (gpa == UNMAPPED_GVA) {
-		kvm_x86_ops->inject_page_fault(vcpu, addr, 2);
-		return X86EMUL_PROPAGATE_FAULT;
-	}
-
-	/* For APIC access vmexit */
-	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
-		goto mmio;
-
-	if (emulator_write_phys(vcpu, gpa, val, bytes))
-		return X86EMUL_CONTINUE;
-
-mmio:
-	/*
-	 * Is this MMIO handled locally?
-	 */
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
-	if (mmio_dev) {
-		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
-		return X86EMUL_CONTINUE;
-	}
-
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_phys_addr = gpa;
-	vcpu->mmio_size = bytes;
-	vcpu->mmio_is_write = 1;
-	memcpy(vcpu->mmio_data, val, bytes);
-
-	return X86EMUL_CONTINUE;
-}
-
-int emulator_write_emulated(unsigned long addr,
-				   const void *val,
-				   unsigned int bytes,
-				   struct kvm_vcpu *vcpu)
-{
-	/* Crossing a page boundary? */
-	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
-		int rc, now;
-
-		now = -addr & ~PAGE_MASK;
-		rc = emulator_write_emulated_onepage(addr, val, now, vcpu);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
-		addr += now;
-		val += now;
-		bytes -= now;
-	}
-	return emulator_write_emulated_onepage(addr, val, bytes, vcpu);
-}
-EXPORT_SYMBOL_GPL(emulator_write_emulated);
-
-static int emulator_cmpxchg_emulated(unsigned long addr,
-				     const void *old,
-				     const void *new,
-				     unsigned int bytes,
-				     struct kvm_vcpu *vcpu)
-{
-	static int reported;
-
-	if (!reported) {
-		reported = 1;
-		printk(KERN_WARNING "kvm: emulating exchange as write\n");
-	}
-	return emulator_write_emulated(addr, new, bytes, vcpu);
-}
-
-static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
-{
-	return kvm_x86_ops->get_segment_base(vcpu, seg);
-}
-
-int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
-{
-	return X86EMUL_CONTINUE;
-}
-
-int emulate_clts(struct kvm_vcpu *vcpu)
-{
-	kvm_x86_ops->set_cr0(vcpu, vcpu->cr0 & ~X86_CR0_TS);
-	return X86EMUL_CONTINUE;
-}
-
-int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long *dest)
-{
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-
-	switch (dr) {
-	case 0 ... 3:
-		*dest = kvm_x86_ops->get_dr(vcpu, dr);
-		return X86EMUL_CONTINUE;
-	default:
-		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __FUNCTION__, dr);
-		return X86EMUL_UNHANDLEABLE;
-	}
-}
-
-int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long value)
-{
-	unsigned long mask = (ctxt->mode == X86EMUL_MODE_PROT64) ? ~0ULL : ~0U;
-	int exception;
-
-	kvm_x86_ops->set_dr(ctxt->vcpu, dr, value & mask, &exception);
-	if (exception) {
-		/* FIXME: better handling */
-		return X86EMUL_UNHANDLEABLE;
-	}
-	return X86EMUL_CONTINUE;
-}
-
-void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
-{
-	static int reported;
-	u8 opcodes[4];
-	unsigned long rip = vcpu->rip;
-	unsigned long rip_linear;
-
-	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
-
-	if (reported)
-		return;
-
-	emulator_read_std(rip_linear, (void *)opcodes, 4, vcpu);
-
-	printk(KERN_ERR "emulation failed (%s) rip %lx %02x %02x %02x %02x\n",
-	       context, rip, opcodes[0], opcodes[1], opcodes[2], opcodes[3]);
-	reported = 1;
-}
-EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
-
-struct x86_emulate_ops emulate_ops = {
-	.read_std            = emulator_read_std,
-	.write_std           = emulator_write_std,
-	.read_emulated       = emulator_read_emulated,
-	.write_emulated      = emulator_write_emulated,
-	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
-};
-
-int emulate_instruction(struct kvm_vcpu *vcpu,
-			struct kvm_run *run,
-			unsigned long cr2,
-			u16 error_code,
-			int no_decode)
-{
-	int r;
-
-	vcpu->mmio_fault_cr2 = cr2;
-	kvm_x86_ops->cache_regs(vcpu);
-
-	vcpu->mmio_is_write = 0;
-	vcpu->pio.string = 0;
-
-	if (!no_decode) {
-		int cs_db, cs_l;
-		kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
-
-		vcpu->emulate_ctxt.vcpu = vcpu;
-		vcpu->emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
-		vcpu->emulate_ctxt.cr2 = cr2;
-		vcpu->emulate_ctxt.mode =
-			(vcpu->emulate_ctxt.eflags & X86_EFLAGS_VM)
-			? X86EMUL_MODE_REAL : cs_l
-			? X86EMUL_MODE_PROT64 :	cs_db
-			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
-
-		if (vcpu->emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
-			vcpu->emulate_ctxt.cs_base = 0;
-			vcpu->emulate_ctxt.ds_base = 0;
-			vcpu->emulate_ctxt.es_base = 0;
-			vcpu->emulate_ctxt.ss_base = 0;
-		} else {
-			vcpu->emulate_ctxt.cs_base =
-					get_segment_base(vcpu, VCPU_SREG_CS);
-			vcpu->emulate_ctxt.ds_base =
-					get_segment_base(vcpu, VCPU_SREG_DS);
-			vcpu->emulate_ctxt.es_base =
-					get_segment_base(vcpu, VCPU_SREG_ES);
-			vcpu->emulate_ctxt.ss_base =
-					get_segment_base(vcpu, VCPU_SREG_SS);
-		}
-
-		vcpu->emulate_ctxt.gs_base =
-					get_segment_base(vcpu, VCPU_SREG_GS);
-		vcpu->emulate_ctxt.fs_base =
-					get_segment_base(vcpu, VCPU_SREG_FS);
-
-		r = x86_decode_insn(&vcpu->emulate_ctxt, &emulate_ops);
-		if (r)  {
-			if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
-				return EMULATE_DONE;
-			return EMULATE_FAIL;
-		}
-	}
-
-	r = x86_emulate_insn(&vcpu->emulate_ctxt, &emulate_ops);
-
-	if (vcpu->pio.string)
-		return EMULATE_DO_MMIO;
-
-	if ((r || vcpu->mmio_is_write) && run) {
-		run->exit_reason = KVM_EXIT_MMIO;
-		run->mmio.phys_addr = vcpu->mmio_phys_addr;
-		memcpy(run->mmio.data, vcpu->mmio_data, 8);
-		run->mmio.len = vcpu->mmio_size;
-		run->mmio.is_write = vcpu->mmio_is_write;
-	}
-
-	if (r) {
-		if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
-			return EMULATE_DONE;
-		if (!vcpu->mmio_needed) {
-			kvm_report_emulation_failure(vcpu, "mmio");
-			return EMULATE_FAIL;
-		}
-		return EMULATE_DO_MMIO;
-	}
-
-	kvm_x86_ops->decache_regs(vcpu);
-	kvm_x86_ops->set_rflags(vcpu, vcpu->emulate_ctxt.eflags);
-
-	if (vcpu->mmio_is_write) {
-		vcpu->mmio_needed = 0;
-		return EMULATE_DO_MMIO;
-	}
-
-	return EMULATE_DONE;
-}
-EXPORT_SYMBOL_GPL(emulate_instruction);
-
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 7862743..fe3733d 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -983,6 +983,364 @@ static __init void kvm_init_msr_list(void)
 	num_msrs_to_save = j;
 }
 
+/*
+ * Only apic need an MMIO device hook, so shortcut now..
+ */
+static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
+						gpa_t addr)
+{
+	struct kvm_io_device *dev;
+
+	if (vcpu->apic) {
+		dev = &vcpu->apic->dev;
+		if (dev->in_range(dev, addr))
+			return dev;
+	}
+	return NULL;
+}
+
+
+static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
+						gpa_t addr)
+{
+	struct kvm_io_device *dev;
+
+	dev = vcpu_find_pervcpu_dev(vcpu, addr);
+	if (dev == NULL)
+		dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr);
+	return dev;
+}
+
+int emulator_read_std(unsigned long addr,
+			     void *val,
+			     unsigned int bytes,
+			     struct kvm_vcpu *vcpu)
+{
+	void *data = val;
+
+	while (bytes) {
+		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+		unsigned offset = addr & (PAGE_SIZE-1);
+		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
+		int ret;
+
+		if (gpa == UNMAPPED_GVA)
+			return X86EMUL_PROPAGATE_FAULT;
+		ret = kvm_read_guest(vcpu->kvm, gpa, data, tocopy);
+		if (ret < 0)
+			return X86EMUL_UNHANDLEABLE;
+
+		bytes -= tocopy;
+		data += tocopy;
+		addr += tocopy;
+	}
+
+	return X86EMUL_CONTINUE;
+}
+EXPORT_SYMBOL_GPL(emulator_read_std);
+
+static int emulator_write_std(unsigned long addr,
+			      const void *val,
+			      unsigned int bytes,
+			      struct kvm_vcpu *vcpu)
+{
+	pr_unimpl(vcpu, "emulator_write_std: addr %lx n %d\n", addr, bytes);
+	return X86EMUL_UNHANDLEABLE;
+}
+
+static int emulator_read_emulated(unsigned long addr,
+				  void *val,
+				  unsigned int bytes,
+				  struct kvm_vcpu *vcpu)
+{
+	struct kvm_io_device *mmio_dev;
+	gpa_t                 gpa;
+
+	if (vcpu->mmio_read_completed) {
+		memcpy(val, vcpu->mmio_data, bytes);
+		vcpu->mmio_read_completed = 0;
+		return X86EMUL_CONTINUE;
+	}
+
+	gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+
+	/* For APIC access vmexit */
+	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
+		goto mmio;
+
+	if (emulator_read_std(addr, val, bytes, vcpu)
+			== X86EMUL_CONTINUE)
+		return X86EMUL_CONTINUE;
+	if (gpa == UNMAPPED_GVA)
+		return X86EMUL_PROPAGATE_FAULT;
+
+mmio:
+	/*
+	 * Is this MMIO handled locally?
+	 */
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
+	if (mmio_dev) {
+		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
+		return X86EMUL_CONTINUE;
+	}
+
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_phys_addr = gpa;
+	vcpu->mmio_size = bytes;
+	vcpu->mmio_is_write = 0;
+
+	return X86EMUL_UNHANDLEABLE;
+}
+
+static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       const void *val, int bytes)
+{
+	int ret;
+
+	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
+	if (ret < 0)
+		return 0;
+	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
+	return 1;
+}
+
+static int emulator_write_emulated_onepage(unsigned long addr,
+					   const void *val,
+					   unsigned int bytes,
+					   struct kvm_vcpu *vcpu)
+{
+	struct kvm_io_device *mmio_dev;
+	gpa_t                 gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+
+	if (gpa == UNMAPPED_GVA) {
+		kvm_x86_ops->inject_page_fault(vcpu, addr, 2);
+		return X86EMUL_PROPAGATE_FAULT;
+	}
+
+	/* For APIC access vmexit */
+	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
+		goto mmio;
+
+	if (emulator_write_phys(vcpu, gpa, val, bytes))
+		return X86EMUL_CONTINUE;
+
+mmio:
+	/*
+	 * Is this MMIO handled locally?
+	 */
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
+	if (mmio_dev) {
+		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
+		return X86EMUL_CONTINUE;
+	}
+
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_phys_addr = gpa;
+	vcpu->mmio_size = bytes;
+	vcpu->mmio_is_write = 1;
+	memcpy(vcpu->mmio_data, val, bytes);
+
+	return X86EMUL_CONTINUE;
+}
+
+int emulator_write_emulated(unsigned long addr,
+				   const void *val,
+				   unsigned int bytes,
+				   struct kvm_vcpu *vcpu)
+{
+	/* Crossing a page boundary? */
+	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
+		int rc, now;
+
+		now = -addr & ~PAGE_MASK;
+		rc = emulator_write_emulated_onepage(addr, val, now, vcpu);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
+		addr += now;
+		val += now;
+		bytes -= now;
+	}
+	return emulator_write_emulated_onepage(addr, val, bytes, vcpu);
+}
+EXPORT_SYMBOL_GPL(emulator_write_emulated);
+
+static int emulator_cmpxchg_emulated(unsigned long addr,
+				     const void *old,
+				     const void *new,
+				     unsigned int bytes,
+				     struct kvm_vcpu *vcpu)
+{
+	static int reported;
+
+	if (!reported) {
+		reported = 1;
+		printk(KERN_WARNING "kvm: emulating exchange as write\n");
+	}
+	return emulator_write_emulated(addr, new, bytes, vcpu);
+}
+
+static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	return kvm_x86_ops->get_segment_base(vcpu, seg);
+}
+
+int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
+{
+	return X86EMUL_CONTINUE;
+}
+
+int emulate_clts(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops->set_cr0(vcpu, vcpu->cr0 & ~X86_CR0_TS);
+	return X86EMUL_CONTINUE;
+}
+
+int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long *dest)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch (dr) {
+	case 0 ... 3:
+		*dest = kvm_x86_ops->get_dr(vcpu, dr);
+		return X86EMUL_CONTINUE;
+	default:
+		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __FUNCTION__, dr);
+		return X86EMUL_UNHANDLEABLE;
+	}
+}
+
+int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long value)
+{
+	unsigned long mask = (ctxt->mode == X86EMUL_MODE_PROT64) ? ~0ULL : ~0U;
+	int exception;
+
+	kvm_x86_ops->set_dr(ctxt->vcpu, dr, value & mask, &exception);
+	if (exception) {
+		/* FIXME: better handling */
+		return X86EMUL_UNHANDLEABLE;
+	}
+	return X86EMUL_CONTINUE;
+}
+
+void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
+{
+	static int reported;
+	u8 opcodes[4];
+	unsigned long rip = vcpu->rip;
+	unsigned long rip_linear;
+
+	rip_linear = rip + get_segment_base(vcpu, VCPU_SREG_CS);
+
+	if (reported)
+		return;
+
+	emulator_read_std(rip_linear, (void *)opcodes, 4, vcpu);
+
+	printk(KERN_ERR "emulation failed (%s) rip %lx %02x %02x %02x %02x\n",
+	       context, rip, opcodes[0], opcodes[1], opcodes[2], opcodes[3]);
+	reported = 1;
+}
+EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
+
+struct x86_emulate_ops emulate_ops = {
+	.read_std            = emulator_read_std,
+	.write_std           = emulator_write_std,
+	.read_emulated       = emulator_read_emulated,
+	.write_emulated      = emulator_write_emulated,
+	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
+};
+
+int emulate_instruction(struct kvm_vcpu *vcpu,
+			struct kvm_run *run,
+			unsigned long cr2,
+			u16 error_code,
+			int no_decode)
+{
+	int r;
+
+	vcpu->mmio_fault_cr2 = cr2;
+	kvm_x86_ops->cache_regs(vcpu);
+
+	vcpu->mmio_is_write = 0;
+	vcpu->pio.string = 0;
+
+	if (!no_decode) {
+		int cs_db, cs_l;
+		kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+
+		vcpu->emulate_ctxt.vcpu = vcpu;
+		vcpu->emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
+		vcpu->emulate_ctxt.cr2 = cr2;
+		vcpu->emulate_ctxt.mode =
+			(vcpu->emulate_ctxt.eflags & X86_EFLAGS_VM)
+			? X86EMUL_MODE_REAL : cs_l
+			? X86EMUL_MODE_PROT64 :	cs_db
+			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
+
+		if (vcpu->emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
+			vcpu->emulate_ctxt.cs_base = 0;
+			vcpu->emulate_ctxt.ds_base = 0;
+			vcpu->emulate_ctxt.es_base = 0;
+			vcpu->emulate_ctxt.ss_base = 0;
+		} else {
+			vcpu->emulate_ctxt.cs_base =
+					get_segment_base(vcpu, VCPU_SREG_CS);
+			vcpu->emulate_ctxt.ds_base =
+					get_segment_base(vcpu, VCPU_SREG_DS);
+			vcpu->emulate_ctxt.es_base =
+					get_segment_base(vcpu, VCPU_SREG_ES);
+			vcpu->emulate_ctxt.ss_base =
+					get_segment_base(vcpu, VCPU_SREG_SS);
+		}
+
+		vcpu->emulate_ctxt.gs_base =
+					get_segment_base(vcpu, VCPU_SREG_GS);
+		vcpu->emulate_ctxt.fs_base =
+					get_segment_base(vcpu, VCPU_SREG_FS);
+
+		r = x86_decode_insn(&vcpu->emulate_ctxt, &emulate_ops);
+		if (r)  {
+			if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
+				return EMULATE_DONE;
+			return EMULATE_FAIL;
+		}
+	}
+
+	r = x86_emulate_insn(&vcpu->emulate_ctxt, &emulate_ops);
+
+	if (vcpu->pio.string)
+		return EMULATE_DO_MMIO;
+
+	if ((r || vcpu->mmio_is_write) && run) {
+		run->exit_reason = KVM_EXIT_MMIO;
+		run->mmio.phys_addr = vcpu->mmio_phys_addr;
+		memcpy(run->mmio.data, vcpu->mmio_data, 8);
+		run->mmio.len = vcpu->mmio_size;
+		run->mmio.is_write = vcpu->mmio_is_write;
+	}
+
+	if (r) {
+		if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
+			return EMULATE_DONE;
+		if (!vcpu->mmio_needed) {
+			kvm_report_emulation_failure(vcpu, "mmio");
+			return EMULATE_FAIL;
+		}
+		return EMULATE_DO_MMIO;
+	}
+
+	kvm_x86_ops->decache_regs(vcpu);
+	kvm_x86_ops->set_rflags(vcpu, vcpu->emulate_ctxt.eflags);
+
+	if (vcpu->mmio_is_write) {
+		vcpu->mmio_needed = 0;
+		return EMULATE_DO_MMIO;
+	}
+
+	return EMULATE_DONE;
+}
+EXPORT_SYMBOL_GPL(emulate_instruction);
+
 __init void kvm_arch_init(void)
 {
 	kvm_init_msr_list();
-- 
1.5.3.7

