Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbXDZJX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbXDZJX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbXDZJWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:53040 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933805AbXDZJW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 16/18] KVM: Allow passing 64-bit values to the emulated read/write API
Date: Thu, 26 Apr 2007 12:22:16 +0300
Message-Id: <11775793384136-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the API somewhat (by eliminating the special-case
cmpxchg8b on i386).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c    |   45 ++++++++-----------------------------------
 drivers/kvm/x86_emulate.c |   46 ++++++++------------------------------------
 drivers/kvm/x86_emulate.h |   32 +++++-------------------------
 3 files changed, 24 insertions(+), 99 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 911c817..6755403 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -970,7 +970,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 }
 
 static int emulator_read_std(unsigned long addr,
-			     unsigned long *val,
+			     void *val,
 			     unsigned int bytes,
 			     struct x86_emulate_ctxt *ctxt)
 {
@@ -1006,7 +1006,7 @@ static int emulator_read_std(unsigned long addr,
 }
 
 static int emulator_write_std(unsigned long addr,
-			      unsigned long val,
+			      const void *val,
 			      unsigned int bytes,
 			      struct x86_emulate_ctxt *ctxt)
 {
@@ -1016,7 +1016,7 @@ static int emulator_write_std(unsigned long addr,
 }
 
 static int emulator_read_emulated(unsigned long addr,
-				  unsigned long *val,
+				  void *val,
 				  unsigned int bytes,
 				  struct x86_emulate_ctxt *ctxt)
 {
@@ -1044,7 +1044,7 @@ static int emulator_read_emulated(unsigned long addr,
 }
 
 static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       unsigned long val, int bytes)
+			       const void *val, int bytes)
 {
 	struct page *page;
 	void *virt;
@@ -1057,14 +1057,14 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	kvm_mmu_pre_write(vcpu, gpa, bytes);
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
-	memcpy(virt + offset_in_page(gpa), &val, bytes);
+	memcpy(virt + offset_in_page(gpa), val, bytes);
 	kunmap_atomic(virt, KM_USER0);
 	kvm_mmu_post_write(vcpu, gpa, bytes);
 	return 1;
 }
 
 static int emulator_write_emulated(unsigned long addr,
-				   unsigned long val,
+				   const void *val,
 				   unsigned int bytes,
 				   struct x86_emulate_ctxt *ctxt)
 {
@@ -1083,14 +1083,14 @@ static int emulator_write_emulated(unsigned long addr,
 	vcpu->mmio_phys_addr = gpa;
 	vcpu->mmio_size = bytes;
 	vcpu->mmio_is_write = 1;
-	memcpy(vcpu->mmio_data, &val, bytes);
+	memcpy(vcpu->mmio_data, val, bytes);
 
 	return X86EMUL_CONTINUE;
 }
 
 static int emulator_cmpxchg_emulated(unsigned long addr,
-				     unsigned long old,
-				     unsigned long new,
+				     const void *old,
+				     const void *new,
 				     unsigned int bytes,
 				     struct x86_emulate_ctxt *ctxt)
 {
@@ -1103,30 +1103,6 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 	return emulator_write_emulated(addr, new, bytes, ctxt);
 }
 
-#ifdef CONFIG_X86_32
-
-static int emulator_cmpxchg8b_emulated(unsigned long addr,
-				       unsigned long old_lo,
-				       unsigned long old_hi,
-				       unsigned long new_lo,
-				       unsigned long new_hi,
-				       struct x86_emulate_ctxt *ctxt)
-{
-	static int reported;
-	int r;
-
-	if (!reported) {
-		reported = 1;
-		printk(KERN_WARNING "kvm: emulating exchange8b as write\n");
-	}
-	r = emulator_write_emulated(addr, new_lo, 4, ctxt);
-	if (r != X86EMUL_CONTINUE)
-		return r;
-	return emulator_write_emulated(addr+4, new_hi, 4, ctxt);
-}
-
-#endif
-
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	return kvm_arch_ops->get_segment_base(vcpu, seg);
@@ -1201,9 +1177,6 @@ struct x86_emulate_ops emulate_ops = {
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
 	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
-#ifdef CONFIG_X86_32
-	.cmpxchg8b_emulated  = emulator_cmpxchg8b_emulated,
-#endif
 };
 
 int emulate_instruction(struct kvm_vcpu *vcpu,
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index bcf872b..7ade090 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1045,7 +1045,7 @@ done_prefixes:
 			if ((rc = ops->write_std(
 				     register_address(ctxt->ss_base,
 						      _regs[VCPU_REGS_RSP]),
-				     dst.val, dst.bytes, ctxt)) != 0)
+				     &dst.val, dst.bytes, ctxt)) != 0)
 				goto done;
 			dst.val = dst.orig_val;	/* skanky: disable writeback */
 			break;
@@ -1078,12 +1078,12 @@ writeback:
 		case OP_MEM:
 			if (lock_prefix)
 				rc = ops->cmpxchg_emulated((unsigned long)dst.
-							   ptr, dst.orig_val,
-							   dst.val, dst.bytes,
+							   ptr, &dst.orig_val,
+							   &dst.val, dst.bytes,
 							   ctxt);
 			else
 				rc = ops->write_emulated((unsigned long)dst.ptr,
-							 dst.val, dst.bytes,
+							 &dst.val, dst.bytes,
 							 ctxt);
 			if (rc != 0)
 				goto done;
@@ -1321,36 +1321,8 @@ twobyte_special_insn:
 		realmode_set_cr(ctxt->vcpu, modrm_reg, modrm_val, &_eflags);
 		break;
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
-#if defined(__i386__)
 		{
-			unsigned long old_lo, old_hi;
-			if (((rc = ops->read_emulated(cr2 + 0, &old_lo, 4,
-						      ctxt)) != 0)
-			    || ((rc = ops->read_emulated(cr2 + 4, &old_hi, 4,
-							 ctxt)) != 0))
-				goto done;
-			if ((old_lo != _regs[VCPU_REGS_RAX])
-			    || (old_hi != _regs[VCPU_REGS_RDX])) {
-				_regs[VCPU_REGS_RAX] = old_lo;
-				_regs[VCPU_REGS_RDX] = old_hi;
-				_eflags &= ~EFLG_ZF;
-			} else if (ops->cmpxchg8b_emulated == NULL) {
-				rc = X86EMUL_UNHANDLEABLE;
-				goto done;
-			} else {
-				if ((rc = ops->cmpxchg8b_emulated(cr2, old_lo,
-							  old_hi,
-							  _regs[VCPU_REGS_RBX],
-							  _regs[VCPU_REGS_RCX],
-							  ctxt)) != 0)
-					goto done;
-				_eflags |= EFLG_ZF;
-			}
-			break;
-		}
-#elif defined(CONFIG_X86_64)
-		{
-			unsigned long old, new;
+			u64 old, new;
 			if ((rc = ops->read_emulated(cr2, &old, 8, ctxt)) != 0)
 				goto done;
 			if (((u32) (old >> 0) != (u32) _regs[VCPU_REGS_RAX]) ||
@@ -1359,15 +1331,15 @@ twobyte_special_insn:
 				_regs[VCPU_REGS_RDX] = (u32) (old >> 32);
 				_eflags &= ~EFLG_ZF;
 			} else {
-				new = (_regs[VCPU_REGS_RCX] << 32) | (u32) _regs[VCPU_REGS_RBX];
-				if ((rc = ops->cmpxchg_emulated(cr2, old,
-							  new, 8, ctxt)) != 0)
+				new = ((u64)_regs[VCPU_REGS_RCX] << 32)
+					| (u32) _regs[VCPU_REGS_RBX];
+				if ((rc = ops->cmpxchg_emulated(cr2, &old,
+							  &new, 8, ctxt)) != 0)
 					goto done;
 				_eflags |= EFLG_ZF;
 			}
 			break;
 		}
-#endif
 	}
 	goto writeback;
 
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index 5d41bd5..ea3407d 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -59,8 +59,7 @@ struct x86_emulate_ops {
 	 *  @val:   [OUT] Value read from memory, zero-extended to 'u_long'.
 	 *  @bytes: [IN ] Number of bytes to read from memory.
 	 */
-	int (*read_std)(unsigned long addr,
-			unsigned long *val,
+	int (*read_std)(unsigned long addr, void *val,
 			unsigned int bytes, struct x86_emulate_ctxt * ctxt);
 
 	/*
@@ -71,8 +70,7 @@ struct x86_emulate_ops {
 	 *                required).
 	 *  @bytes: [IN ] Number of bytes to write to memory.
 	 */
-	int (*write_std)(unsigned long addr,
-			 unsigned long val,
+	int (*write_std)(unsigned long addr, const void *val,
 			 unsigned int bytes, struct x86_emulate_ctxt * ctxt);
 
 	/*
@@ -82,7 +80,7 @@ struct x86_emulate_ops {
 	 *  @bytes: [IN ] Number of bytes to read from memory.
 	 */
 	int (*read_emulated) (unsigned long addr,
-			      unsigned long *val,
+			      void *val,
 			      unsigned int bytes,
 			      struct x86_emulate_ctxt * ctxt);
 
@@ -94,7 +92,7 @@ struct x86_emulate_ops {
 	 *  @bytes: [IN ] Number of bytes to write to memory.
 	 */
 	int (*write_emulated) (unsigned long addr,
-			       unsigned long val,
+			       const void *val,
 			       unsigned int bytes,
 			       struct x86_emulate_ctxt * ctxt);
 
@@ -107,29 +105,11 @@ struct x86_emulate_ops {
 	 *  @bytes: [IN ] Number of bytes to access using CMPXCHG.
 	 */
 	int (*cmpxchg_emulated) (unsigned long addr,
-				 unsigned long old,
-				 unsigned long new,
+				 const void *old,
+				 const void *new,
 				 unsigned int bytes,
 				 struct x86_emulate_ctxt * ctxt);
 
-	/*
-	 * cmpxchg8b_emulated: Emulate an atomic (LOCKed) CMPXCHG8B operation on an
-	 *                     emulated/special memory area.
-	 *  @addr:  [IN ] Linear address to access.
-	 *  @old:   [IN ] Value expected to be current at @addr.
-	 *  @new:   [IN ] Value to write to @addr.
-	 * NOTES:
-	 *  1. This function is only ever called when emulating a real CMPXCHG8B.
-	 *  2. This function is *never* called on x86/64 systems.
-	 *  2. Not defining this function (i.e., specifying NULL) is equivalent
-	 *     to defining a function that always returns X86EMUL_UNHANDLEABLE.
-	 */
-	int (*cmpxchg8b_emulated) (unsigned long addr,
-				   unsigned long old_lo,
-				   unsigned long old_hi,
-				   unsigned long new_lo,
-				   unsigned long new_hi,
-				   struct x86_emulate_ctxt * ctxt);
 };
 
 struct cpu_user_regs;
-- 
1.5.0.6

