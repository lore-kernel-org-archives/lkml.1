Return-Path: <linux-kernel-owner+w=401wt.eu-S934151AbXFSUZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbXFSUZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762575AbXFSUZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:25:24 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:12107 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763496AbXFSUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SkW3hK2PIYeqwzO7KlugraIr0SS3nj31K6t5/VQTmyExKizAOAJ5ykqfOHzoq2yr0B22QWBZwH591pPVbPXq3iwStf+1KZPSA7HzJx/6qtpZzll0KDN0OClsmigyeFDlv4gpq+wyg0a819nHuL7Cj5qYgfqz3m2SeaXt4ni7BJ8=
Date: Tue, 19 Jun 2007 22:25:24 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: kvm-devel@lists.sourceforge.net
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, David Brown <dmlb2000@gmail.com>
Subject: Re: [PATCH 1/2] kvm: Fix x86 emulator writeback
Message-ID: <20070619202524.GA17672@dreamland.darkstar.lan>
Mail-Followup-To: kvm-devel@lists.sourceforge.net,
	Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
	David Brown <dmlb2000@gmail.com>
References: <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan> <4675523C.9020703@qumranet.com> <20070617165201.GA23885@dreamland.darkstar.lan> <46765954.60102@qumranet.com> <46766D57.8040206@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46766D57.8040206@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Mon, Jun 18, 2007 at 02:32:39PM +0300, Avi Kivity ha scritto: 
> >Unfortunately, this kills Windows XP (first run with a guest crash, 
> >second with a host oops), so I reverted it.  I'd guess some operation  
> >which doesn't need writeback ends up in the modified code.  
> >Previously, the check caused it to skip writeback, but now it writes 
> >back random memory, causing a crash.
> >
> 
> There are comments around like
> 
> >    /* Disable writeback. */
> >    dst.orig_val = dst.val;
> 
> Best option is probably to add an explicit disable_writeback flag and 
> set it there.

I've tested this patch with linux, solaris and winxp, on a 32 bit guest.
So far everything is fine ;)
David, this patch should fix the lockup you're seeing.

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 633c2ed..9b7b0b9 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1139,8 +1139,10 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
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
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index a4a8481..eb10448 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -482,6 +482,7 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	int mode = ctxt->mode;
 	unsigned long modrm_ea;
 	int use_modrm_ea, index_reg = 0, base_reg = 0, scale, rip_relative = 0;
+	int no_wb = 0;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 	unsigned long _regs[NR_VCPU_REGS];
@@ -1048,7 +1049,7 @@ done_prefixes:
 						      _regs[VCPU_REGS_RSP]),
 				     &dst.val, dst.bytes, ctxt)) != 0)
 				goto done;
-			dst.val = dst.orig_val;	/* skanky: disable writeback */
+			no_wb = 1;	/* skanky: disable writeback */
 			break;
 		default:
 			goto cannot_emulate;
@@ -1057,7 +1058,7 @@ done_prefixes:
 	}
 
 writeback:
-	if ((d & Mov) || (dst.orig_val != dst.val)) {
+	if (!no_wb) {
 		switch (dst.type) {
 		case OP_REG:
 			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
@@ -1306,7 +1307,7 @@ twobyte_insn:
 
 twobyte_special_insn:
 	/* Disable writeback. */
-	dst.orig_val = dst.val;
+	no_wb = 1;
 	switch (b) {
 	case 0x09:		/* wbinvd */
 		break;


Luca
-- 
"Ci sono le balle, le megaballe e le statistiche".
 Mark Twain
