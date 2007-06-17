Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXFQPPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXFQPPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbXFQPO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:14:56 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:25649 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXFQPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=G9qWBK6TgUxBsa/dTrO+R1wbn5krUgg0R7+3VLl7P7iQ7k2P9+456YgZub1Q2/x5xs9OVnMyLODBYirsbjZGJO3Z+0GlZ6ObOueL3Tg3tj6zVn9OJtGPwnH4xnX85kNV71NyHNk7wHKyb5dXBaAjTTteVYALsxXGoPqRCrXcckg=
Date: Sun, 17 Jun 2007 17:14:52 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Message-ID: <20070617151452.GA21971@dreamland.darkstar.lan>
Mail-Followup-To: Avi Kivity <avi@qumranet.com>,
	kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070612175246.GA5864@dreamland.darkstar.lan> <466FB1ED.3090905@qumranet.com> <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan> <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4673949B.1070505@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Sat, Jun 16, 2007 at 10:43:23AM +0300, Avi Kivity ha scritto: 
> Luca Tettamanti wrote:
> > Il Fri, Jun 15, 2007 at 12:06:50PM +0300, Avi Kivity ha scritto: 
> >   
> >>> After a bit of thinking: it's correct but removes an optimization;
> >>> furthermore it may miss other instructions that write to memory mapped
> >>> areas.
> >>> A more proper fix should be "force the writeback if dst.ptr is in some
> >>> kind of mmio area".
> >>>
> >>>       
> >> I think we can just disable the optimization, and (in a separate patch)
> >> add it back in emulator_write_phys(), where we know we're modifying
> >> memory and not hitting mmio.
> >>     
> >
> > Problem is that in emulator_write_phys() we've already lost track of the
> > previous (dst.orig_val) value. I moved up the decision in
> >   
> 
> Actually we haven't; just before the memcpy(), we can put a memcmp() to
> guard the kvm_mmu_pte_write(), which is the really expensive operation,
> especially with guest smp.

Yup, but it seemed wasteful to map (at least when highmem is in use) a
page just to check for something that we already knew. That was a
preemptive optmization though, I haven't actually benchmarked the cost
of setting up the mapping ;-)

[...]
> I think we can simply remove the if ().  For the register case, the
> check is more expensive that the write; for mmio, we don't want it; and
> for memory writes, we can put it in emulator_write_phys().

Ok, this way it's simpler. How does this look:

--- a/kernel/x86_emulate.c	2007-06-15 21:13:51.000000000 +0200
+++ b/kernel/x86_emulate.c	2007-06-17 16:57:50.000000000 +0200
@@ -1057,40 +1057,38 @@
 	}
 
 writeback:
-	if ((d & Mov) || (dst.orig_val != dst.val)) {
-		switch (dst.type) {
-		case OP_REG:
-			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
-			switch (dst.bytes) {
-			case 1:
-				*(u8 *)dst.ptr = (u8)dst.val;
-				break;
-			case 2:
-				*(u16 *)dst.ptr = (u16)dst.val;
-				break;
-			case 4:
-				*dst.ptr = (u32)dst.val;
-				break;	/* 64b: zero-ext */
-			case 8:
-				*dst.ptr = dst.val;
-				break;
-			}
+	switch (dst.type) {
+	case OP_REG:
+		/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
+		switch (dst.bytes) {
+		case 1:
+			*(u8 *)dst.ptr = (u8)dst.val;
 			break;
-		case OP_MEM:
-			if (lock_prefix)
-				rc = ops->cmpxchg_emulated((unsigned long)dst.
-							   ptr, &dst.orig_val,
-							   &dst.val, dst.bytes,
-							   ctxt);
-			else
-				rc = ops->write_emulated((unsigned long)dst.ptr,
-							 &dst.val, dst.bytes,
-							 ctxt);
-			if (rc != 0)
-				goto done;
-		default:
+		case 2:
+			*(u16 *)dst.ptr = (u16)dst.val;
+			break;
+		case 4:
+			*dst.ptr = (u32)dst.val;
+			break;	/* 64b: zero-ext */
+		case 8:
+			*dst.ptr = dst.val;
 			break;
 		}
+		break;
+	case OP_MEM:
+		if (lock_prefix)
+			rc = ops->cmpxchg_emulated((unsigned long)dst.
+						   ptr, &dst.orig_val,
+						   &dst.val, dst.bytes,
+						   ctxt);
+		else
+			rc = ops->write_emulated((unsigned long)dst.ptr,
+						 &dst.val, dst.bytes,
+						 ctxt);
+		if (rc != 0)
+			goto done;
+	default:
+		break;
 	}
 
 	/* Commit shadow register state. */

--- a/kernel/kvm_main.c	2007-06-15 21:18:08.000000000 +0200
+++ b/kernel/kvm_main.c	2007-06-17 16:59:33.000000000 +0200
@@ -1139,8 +1139,10 @@
 		return 0;
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
-	kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
-	memcpy(virt + offset_in_page(gpa), val, bytes);
+	if (memcmp(virt + offset_in_page(gpa), val, bytes)) {
+		kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
+		memcpy(virt + offset_in_page(gpa), val, bytes);
+	}
 	kunmap_atomic(virt, KM_USER0);
 	return 1;
 }



Luca
-- 
Runtime error 6D at f000:a12f : user incompetente
