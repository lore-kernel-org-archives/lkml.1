Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbXIQJEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbXIQJEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbXIQIeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:04 -0400
Received: from il.qumranet.com ([82.166.9.18]:45244 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 035/104] KVM: Change the emulator_{read,write,cmpxchg}_* functions to take a vcpu
Date: Mon, 17 Sep 2007 10:31:17 +0200
Message-Id: <1190017947521-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

... instead of a x86_emulate_ctxt, so that other callers can use it easily.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c    |   25 +++++++++++--------------
 drivers/kvm/x86_emulate.c |   35 ++++++++++++++++++++---------------
 drivers/kvm/x86_emulate.h |   10 +++++-----
 3 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 6ad1b04..a65a145 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1020,9 +1020,8 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 static int emulator_read_std(unsigned long addr,
 			     void *val,
 			     unsigned int bytes,
-			     struct x86_emulate_ctxt *ctxt)
+			     struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
 	void *data = val;
 
 	while (bytes) {
@@ -1056,7 +1055,7 @@ static int emulator_read_std(unsigned long addr,
 static int emulator_write_std(unsigned long addr,
 			      const void *val,
 			      unsigned int bytes,
-			      struct x86_emulate_ctxt *ctxt)
+			      struct kvm_vcpu *vcpu)
 {
 	printk(KERN_ERR "emulator_write_std: addr %lx n %d\n",
 	       addr, bytes);
@@ -1083,9 +1082,8 @@ static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
 static int emulator_read_emulated(unsigned long addr,
 				  void *val,
 				  unsigned int bytes,
-				  struct x86_emulate_ctxt *ctxt)
+				  struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu      *vcpu = ctxt->vcpu;
 	struct kvm_io_device *mmio_dev;
 	gpa_t                 gpa;
 
@@ -1093,7 +1091,7 @@ static int emulator_read_emulated(unsigned long addr,
 		memcpy(val, vcpu->mmio_data, bytes);
 		vcpu->mmio_read_completed = 0;
 		return X86EMUL_CONTINUE;
-	} else if (emulator_read_std(addr, val, bytes, ctxt)
+	} else if (emulator_read_std(addr, val, bytes, vcpu)
 		   == X86EMUL_CONTINUE)
 		return X86EMUL_CONTINUE;
 
@@ -1140,9 +1138,8 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 static int emulator_write_emulated_onepage(unsigned long addr,
 					   const void *val,
 					   unsigned int bytes,
-					   struct x86_emulate_ctxt *ctxt)
+					   struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu      *vcpu = ctxt->vcpu;
 	struct kvm_io_device *mmio_dev;
 	gpa_t                 gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
 
@@ -1175,28 +1172,28 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 static int emulator_write_emulated(unsigned long addr,
 				   const void *val,
 				   unsigned int bytes,
-				   struct x86_emulate_ctxt *ctxt)
+				   struct kvm_vcpu *vcpu)
 {
 	/* Crossing a page boundary? */
 	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
 		int rc, now;
 
 		now = -addr & ~PAGE_MASK;
-		rc = emulator_write_emulated_onepage(addr, val, now, ctxt);
+		rc = emulator_write_emulated_onepage(addr, val, now, vcpu);
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
 		addr += now;
 		val += now;
 		bytes -= now;
 	}
-	return emulator_write_emulated_onepage(addr, val, bytes, ctxt);
+	return emulator_write_emulated_onepage(addr, val, bytes, vcpu);
 }
 
 static int emulator_cmpxchg_emulated(unsigned long addr,
 				     const void *old,
 				     const void *new,
 				     unsigned int bytes,
-				     struct x86_emulate_ctxt *ctxt)
+				     struct kvm_vcpu *vcpu)
 {
 	static int reported;
 
@@ -1204,7 +1201,7 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 		reported = 1;
 		printk(KERN_WARNING "kvm: emulating exchange as write\n");
 	}
-	return emulator_write_emulated(addr, new, bytes, ctxt);
+	return emulator_write_emulated(addr, new, bytes, vcpu);
 }
 
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
@@ -1266,7 +1263,7 @@ static void report_emulation_failure(struct x86_emulate_ctxt *ctxt)
 	if (reported)
 		return;
 
-	emulator_read_std(rip_linear, (void *)opcodes, 4, ctxt);
+	emulator_read_std(rip_linear, (void *)opcodes, 4, ctxt->vcpu);
 
 	printk(KERN_ERR "emulation failed but !mmio_needed?"
 	       " rip %lx %02x %02x %02x %02x\n",
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 2136da5..44eb28d 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -420,7 +420,7 @@ struct operand {
 #define insn_fetch(_type, _size, _eip)                                  \
 ({	unsigned long _x;						\
 	rc = ops->read_std((unsigned long)(_eip) + ctxt->cs_base, &_x,	\
-                                                  (_size), ctxt);       \
+                                                  (_size), ctxt->vcpu); \
 	if ( rc != 0 )							\
 		goto done;						\
 	(_eip) += (_size);						\
@@ -469,10 +469,12 @@ static int read_descriptor(struct x86_emulate_ctxt *ctxt,
 	if (op_bytes == 2)
 		op_bytes = 3;
 	*address = 0;
-	rc = ops->read_std((unsigned long)ptr, (unsigned long *)size, 2, ctxt);
+	rc = ops->read_std((unsigned long)ptr, (unsigned long *)size, 2,
+			   ctxt->vcpu);
 	if (rc)
 		return rc;
-	rc = ops->read_std((unsigned long)ptr + 2, address, op_bytes, ctxt);
+	rc = ops->read_std((unsigned long)ptr + 2, address, op_bytes,
+			   ctxt->vcpu);
 	return rc;
 }
 
@@ -780,7 +782,7 @@ done_prefixes:
 		src.type = OP_MEM;
 		src.ptr = (unsigned long *)cr2;
 		if ((rc = ops->read_emulated((unsigned long)src.ptr,
-					     &src.val, src.bytes, ctxt)) != 0)
+					     &src.val, src.bytes, ctxt->vcpu)) != 0)
 			goto done;
 		src.orig_val = src.val;
 		break;
@@ -850,7 +852,7 @@ done_prefixes:
 		}
 		if (!(d & Mov) && /* optimisation - avoid slow emulated read */
 		    ((rc = ops->read_emulated((unsigned long)dst.ptr,
-					      &dst.val, dst.bytes, ctxt)) != 0))
+					      &dst.val, dst.bytes, ctxt->vcpu)) != 0))
 			goto done;
 		break;
 	}
@@ -963,7 +965,7 @@ done_prefixes:
 			dst.bytes = 8;
 		if ((rc = ops->read_std(register_address(ctxt->ss_base,
 							 _regs[VCPU_REGS_RSP]),
-					&dst.val, dst.bytes, ctxt)) != 0)
+					&dst.val, dst.bytes, ctxt->vcpu)) != 0)
 			goto done;
 		register_address_increment(_regs[VCPU_REGS_RSP], dst.bytes);
 		break;
@@ -1048,7 +1050,7 @@ done_prefixes:
 				dst.bytes = 8;
 				if ((rc = ops->read_std((unsigned long)dst.ptr,
 							&dst.val, 8,
-							ctxt)) != 0)
+							ctxt->vcpu)) != 0)
 					goto done;
 			}
 			register_address_increment(_regs[VCPU_REGS_RSP],
@@ -1056,7 +1058,7 @@ done_prefixes:
 			if ((rc = ops->write_std(
 				     register_address(ctxt->ss_base,
 						      _regs[VCPU_REGS_RSP]),
-				     &dst.val, dst.bytes, ctxt)) != 0)
+				     &dst.val, dst.bytes, ctxt->vcpu)) != 0)
 				goto done;
 			no_wb = 1;
 			break;
@@ -1091,11 +1093,11 @@ writeback:
 				rc = ops->cmpxchg_emulated((unsigned long)dst.
 							   ptr, &dst.orig_val,
 							   &dst.val, dst.bytes,
-							   ctxt);
+							   ctxt->vcpu);
 			else
 				rc = ops->write_emulated((unsigned long)dst.ptr,
 							 &dst.val, dst.bytes,
-							 ctxt);
+							 ctxt->vcpu);
 			if (rc != 0)
 				goto done;
 		default:
@@ -1130,7 +1132,7 @@ special_insn:
 							_regs[VCPU_REGS_RDI]);
 		if ((rc = ops->read_emulated(register_address(
 		      override_base ? *override_base : ctxt->ds_base,
-		      _regs[VCPU_REGS_RSI]), &dst.val, dst.bytes, ctxt)) != 0)
+		      _regs[VCPU_REGS_RSI]), &dst.val, dst.bytes, ctxt->vcpu)) != 0)
 			goto done;
 		register_address_increment(_regs[VCPU_REGS_RSI],
 			     (_eflags & EFLG_DF) ? -dst.bytes : dst.bytes);
@@ -1152,7 +1154,8 @@ special_insn:
 		dst.type = OP_REG;
 		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
 		dst.ptr = (unsigned long *)&_regs[VCPU_REGS_RAX];
-		if ((rc = ops->read_emulated(cr2, &dst.val, dst.bytes, ctxt)) != 0)
+		if ((rc = ops->read_emulated(cr2, &dst.val, dst.bytes,
+					     ctxt->vcpu)) != 0)
 			goto done;
 		register_address_increment(_regs[VCPU_REGS_RSI],
 			   (_eflags & EFLG_DF) ? -dst.bytes : dst.bytes);
@@ -1171,7 +1174,8 @@ special_insn:
 
 pop_instruction:
 		if ((rc = ops->read_std(register_address(ctxt->ss_base,
-			_regs[VCPU_REGS_RSP]), dst.ptr, op_bytes, ctxt)) != 0)
+			_regs[VCPU_REGS_RSP]), dst.ptr, op_bytes, ctxt->vcpu))
+			!= 0)
 			goto done;
 
 		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
@@ -1378,7 +1382,8 @@ twobyte_special_insn:
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
 		{
 			u64 old, new;
-			if ((rc = ops->read_emulated(cr2, &old, 8, ctxt)) != 0)
+			if ((rc = ops->read_emulated(cr2, &old, 8, ctxt->vcpu))
+									!= 0)
 				goto done;
 			if (((u32) (old >> 0) != (u32) _regs[VCPU_REGS_RAX]) ||
 			    ((u32) (old >> 32) != (u32) _regs[VCPU_REGS_RDX])) {
@@ -1389,7 +1394,7 @@ twobyte_special_insn:
 				new = ((u64)_regs[VCPU_REGS_RCX] << 32)
 					| (u32) _regs[VCPU_REGS_RBX];
 				if ((rc = ops->cmpxchg_emulated(cr2, &old,
-							  &new, 8, ctxt)) != 0)
+							  &new, 8, ctxt->vcpu)) != 0)
 					goto done;
 				_eflags |= EFLG_ZF;
 			}
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index 574cca7..92c73aa 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -60,7 +60,7 @@ struct x86_emulate_ops {
 	 *  @bytes: [IN ] Number of bytes to read from memory.
 	 */
 	int (*read_std)(unsigned long addr, void *val,
-			unsigned int bytes, struct x86_emulate_ctxt * ctxt);
+			unsigned int bytes, struct kvm_vcpu *vcpu);
 
 	/*
 	 * write_std: Write bytes of standard (non-emulated/special) memory.
@@ -71,7 +71,7 @@ struct x86_emulate_ops {
 	 *  @bytes: [IN ] Number of bytes to write to memory.
 	 */
 	int (*write_std)(unsigned long addr, const void *val,
-			 unsigned int bytes, struct x86_emulate_ctxt * ctxt);
+			 unsigned int bytes, struct kvm_vcpu *vcpu);
 
 	/*
 	 * read_emulated: Read bytes from emulated/special memory area.
@@ -82,7 +82,7 @@ struct x86_emulate_ops {
 	int (*read_emulated) (unsigned long addr,
 			      void *val,
 			      unsigned int bytes,
-			      struct x86_emulate_ctxt * ctxt);
+			      struct kvm_vcpu *vcpu);
 
 	/*
 	 * write_emulated: Read bytes from emulated/special memory area.
@@ -94,7 +94,7 @@ struct x86_emulate_ops {
 	int (*write_emulated) (unsigned long addr,
 			       const void *val,
 			       unsigned int bytes,
-			       struct x86_emulate_ctxt * ctxt);
+			       struct kvm_vcpu *vcpu);
 
 	/*
 	 * cmpxchg_emulated: Emulate an atomic (LOCKed) CMPXCHG operation on an
@@ -108,7 +108,7 @@ struct x86_emulate_ops {
 				 const void *old,
 				 const void *new,
 				 unsigned int bytes,
-				 struct x86_emulate_ctxt * ctxt);
+				 struct kvm_vcpu *vcpu);
 
 };
 
-- 
1.5.3

