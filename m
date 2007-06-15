Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbXFOVtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbXFOVtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXFOVtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:49:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:42253 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbXFOVtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DrBkQ+akJPN/2Ot9d1c1nGRuaxLSUGA8LG4oFkqYkfE/bh/cLdFV5RFzXVpGh6KIlkoVxHTgRX23LTljsuv+IVqlWPlTxPMhtqQiwTRoNKYO2FVbNlcsecAwLQyVFg0Isznc/EuYWxqVGg7dXzZdG9YNgnnvJTSvhQ5vl05TUzM=
Date: Fri, 15 Jun 2007 23:49:15 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Message-ID: <20070615214915.GA10536@dreamland.darkstar.lan>
Mail-Followup-To: Avi Kivity <avi@qumranet.com>,
	kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com> <466CFD6D.2080201@qumranet.com> <20070612175246.GA5864@dreamland.darkstar.lan> <466FB1ED.3090905@qumranet.com> <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan> <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467256AA.1040001@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Fri, Jun 15, 2007 at 12:06:50PM +0300, Avi Kivity ha scritto: 
> > After a bit of thinking: it's correct but removes an optimization;
> > furthermore it may miss other instructions that write to memory mapped
> > areas.
> > A more proper fix should be "force the writeback if dst.ptr is in some
> > kind of mmio area".
> >
> 
> I think we can just disable the optimization, and (in a separate patch)
> add it back in emulator_write_phys(), where we know we're modifying
> memory and not hitting mmio.

Problem is that in emulator_write_phys() we've already lost track of the
previous (dst.orig_val) value. I moved up the decision in
cmpxchg_emulated; unfortunately this means that the non-locked write
path (write_emulated) can't do this optimization, unless I change its
signature to include the old value.

The first patch makes the writeback step uncoditional whenever we have a
destination operand (the mov check (d & Mov) may be superfluous, yes?).
The write-to-registry path still has the optimization that skips the
write if possible.


--- a/kernel/x86_emulate.c	2007-06-15 21:13:51.000000000 +0200
+++ b/kernel/x86_emulate.c	2007-06-15 22:12:15.000000000 +0200
@@ -1057,9 +1057,8 @@
 	}
 
 writeback:
-	if ((d & Mov) || (dst.orig_val != dst.val)) {
-		switch (dst.type) {
-		case OP_REG:
+	if ((d & Mov) || (d & DstMask) == DstMem || (d & DstMask) == DstReg ) {
+		if (dst.type == OP_REG && dst.orig_val != dst.val) {
 			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
 			switch (dst.bytes) {
 			case 1:
@@ -1075,8 +1074,10 @@
 				*dst.ptr = dst.val;
 				break;
 			}
-			break;
-		case OP_MEM:
+		} else if (dst.type == OP_MEM) {
+			/* Always dispatch the write, since it may hit a
+			 * MMIO area.
+			 */
 			if (lock_prefix)
 				rc = ops->cmpxchg_emulated((unsigned long)dst.
 							   ptr, &dst.orig_val,
@@ -1088,8 +1089,6 @@
 							 ctxt);
 			if (rc != 0)
 				goto done;
-		default:
-			break;
 		}
 	}
 

Next one: I've splitted emulator_write_phys into emulator_write_phys_mem
(for normal RAM) and emulator_write_phys_mmio (for the rest). The
cmpxchg code path is roughly:

if (!mapped)
        page_fault();

page = gfn_to_page(...)
if (page) {
        if (!memcmp(old, new))
                return X86EMUL_CONTINUE;

        write_mem();
        retrun X86EMUL_CONTINUE;
}
/* for mmio always do the write */
write_mmio();

I'm a bit confused about this test, found in emulator_write_phys
(original code):

if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
        return 0;

AFAICT is makes the emulator skip the write if the modified area spans
across two different (physical) pages. When this happens write_emulated
does a MMIO write. I'd expect the function to load the 2 pages and do the
memory write on both instead.
I've preserved this logic in the following patch, but I don't understand
why it's correct :|

--- a/kernel/kvm_main.c	2007-06-15 21:18:08.000000000 +0200
+++ b/kernel/kvm_main.c	2007-06-15 23:34:13.000000000 +0200
@@ -1125,26 +1125,39 @@
 	}
 }
 
-static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       const void *val, int bytes)
+static int emulator_write_phys_mem(struct kvm_vcpu *vcpu, gpa_t gpa,
+				   struct page *page, const void *val,
+				   int bytes)
 {
-	struct page *page;
 	void *virt;
-	unsigned offset = offset_in_page(gpa);
+	unsigned int offset;
+
+	offset = offset_in_page(gpa);
 
 	if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
 		return 0;
-	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-	if (!page)
-		return 0;
+
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
 	kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
 	memcpy(virt + offset_in_page(gpa), val, bytes);
 	kunmap_atomic(virt, KM_USER0);
+
 	return 1;
 }
 
+static int emulator_write_phys_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
+				    const void *val, int bytes)
+{
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_phys_addr = gpa;
+	vcpu->mmio_size = bytes;
+	vcpu->mmio_is_write = 1;
+	memcpy(vcpu->mmio_data, val, bytes);
+
+	return 0;
+}
+
 static int emulator_write_emulated(unsigned long addr,
 				   const void *val,
 				   unsigned int bytes,
@@ -1152,20 +1165,18 @@
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+	struct page *page;
 
 	if (gpa == UNMAPPED_GVA) {
 		kvm_arch_ops->inject_page_fault(vcpu, addr, 2);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (emulator_write_phys(vcpu, gpa, val, bytes))
+	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	if (page && emulator_write_phys_mem(vcpu, gpa, page, val, bytes))
 		return X86EMUL_CONTINUE;
 
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_phys_addr = gpa;
-	vcpu->mmio_size = bytes;
-	vcpu->mmio_is_write = 1;
-	memcpy(vcpu->mmio_data, val, bytes);
+	emulator_write_phys_mmio(vcpu, gpa, val, bytes);
 
 	return X86EMUL_CONTINUE;
 }
@@ -1177,12 +1188,37 @@
 				     struct x86_emulate_ctxt *ctxt)
 {
 	static int reported;
+	struct kvm_vcpu *vcpu;
+	gpa_t gpa;
+	struct page *page;
 
 	if (!reported) {
 		reported = 1;
 		printk(KERN_WARNING "kvm: emulating exchange as write\n");
 	}
-	return emulator_write_emulated(addr, new, bytes, ctxt);
+
+	vcpu = ctxt->vcpu;
+	gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+
+	if (gpa == UNMAPPED_GVA) {
+		kvm_arch_ops->inject_page_fault(vcpu, addr, 2);
+		return X86EMUL_PROPAGATE_FAULT;
+	}
+
+	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	if (page) {
+		/* Regular memory */
+		if (!memcmp(old, new, bytes))
+			return X86EMUL_CONTINUE;
+
+		if (emulator_write_phys_mem(vcpu, gpa, page, new, bytes))
+			return X86EMUL_CONTINUE;
+	}
+
+	/* MMIO */
+	emulator_write_phys_mmio(vcpu, gpa, new, bytes);
+
+	return X86EMUL_CONTINUE;
 }
 
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)


Both patches apply to kvm-28 and have been run-time tested with 32bit
guest on 32bit host, with a VMX processor.

If patches look good I'll resubmit with proper changelog and
signed-off.

Luca
-- 
The trouble with computers is that they do what you tell them, 
not what you want.
D. Cohen
