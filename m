Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXFNXNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXFNXNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXFNXNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:13:33 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:18308 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbXFNXNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JY0qn8w6P1enA6+ERzcMuMvnvVHnNr9zJaoZYq6azbUT7bgKtmeaWfcrLKCmx/0T/2CmFCn26jkOSNLPxb8nHdZVpzHDNSayDYaqeB/7O13Yg5+NDNt4OnKIfea6WEQHGap/1tLqriVbfuIHMpJhtimgAiDk8rltLIpaWfEJ30Y=
Date: Fri, 15 Jun 2007 01:13:59 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Message-ID: <20070614231359.GA5705@dreamland.darkstar.lan>
Mail-Followup-To: Avi Kivity <avi@qumranet.com>,
	kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <46651069.5040003@qumranet.com> <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com> <466BED18.5040708@qumranet.com> <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com> <466CFD6D.2080201@qumranet.com> <20070612175246.GA5864@dreamland.darkstar.lan> <466FB1ED.3090905@qumranet.com> <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614225324.GA4088@dreamland.darkstar.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Fri, Jun 15, 2007 at 12:53:24AM +0200, Luca Tettamanti ha scritto: 
> Il Thu, Jun 14, 2007 at 11:26:29AM +0300, Avi Kivity ha scritto: 
> > Luca Tettamanti wrote:
> > >With GOOD_APIC apic_read_around is a nop, while apic_write_around is a
> > >normal write. With !GOOD_APIC apic_write_around writes to the APIC reg
> > >using xchg. With !GOOD_APIC and this patch:
> > >
> > >--- include/asm-i386/apic.h~	2007-04-26 05:08:32.000000000 +0200
> > >+++ include/asm-i386/apic.h	2007-06-13 22:35:00.000000000 +0200
> > >@@ -56,7 +56,8 @@
> > > static __inline fastcall void native_apic_write_atomic(unsigned long reg,
> > > 						       unsigned long v)
> > > {
> > >-	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> > >+//	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> > >+	*((volatile unsigned long *)(APIC_BASE+reg)) = v;
> > > }
> > > 
> > > static __inline fastcall unsigned long native_apic_read(unsigned long reg)
> > >
> > >The kernel boots fine. 
> > >  
> > 
> > Looking at the xchg emulation code, it seems fine, but clearly it 
> > isn't.
> 
> Btw, I've put a printk in x86_emulate.c, where it prepares the operands
> for the xchg operations: all the write_atomic are hitting this point,
> so the write is lost somewhere in cmpxchg_emulated->write_emulated.

Got it!
The emulator skips the writeback if the old value is unchanged, so the
apic doesn't see the write.

Forcing the writeback:

-      if ((d & Mov) || (dst.orig_val != dst.val)) {
-      if ((d & Mov) || (dst.orig_val != dst.val) || isxchg) {

seems to fix the issue :D I'm not sure that fix is correct though. This
is the patch I'm using:


--- a/kernel/x86_emulate.c	2007-06-03 10:31:15.000000000 +0200
+++ b/kernel/x86_emulate.c	2007-06-15 01:12:12.000000000 +0200
@@ -486,6 +486,7 @@
 	unsigned long _regs[NR_VCPU_REGS];
 	unsigned long _eip = ctxt->vcpu->rip, _eflags = ctxt->eflags;
 	unsigned long modrm_val = 0;
+	int isxchg = 0;
 
 	memcpy(_regs, ctxt->vcpu->regs, sizeof _regs);
 
@@ -912,6 +913,7 @@
 		break;
 	case 0x86 ... 0x87:	/* xchg */
 		/* Write back the register source. */
+		isxchg = 1;
 		switch (dst.bytes) {
 		case 1:
 			*(u8 *) src.ptr = (u8) dst.val;
@@ -1056,7 +1058,7 @@
 	}
 
 writeback:
-	if ((d & Mov) || (dst.orig_val != dst.val)) {
+	if ((d & Mov) || (dst.orig_val != dst.val) || isxchg) {
 		switch (dst.type) {
 		case OP_REG:
 			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */

Luca
-- 
"Su cio` di cui non si puo` parlare e` bene tacere".
 Ludwig Wittgenstein
