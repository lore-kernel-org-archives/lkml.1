Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbXFNX1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbXFNX1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbXFNX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:27:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:3616 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXFNX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EQjBA83ndcMs/C/poyjfD6rT6nCP+Oh6PaZwCvzF59hYqw64Sy4FcVQq9hMQ+XU1plTMmhPsqQSJ3N2QHYlB7Z7nnytnW7TL2uUtjrKI7hoG/P7NxL1LD4IbUHJuQ6u5vVEUV7t22ySHbsDIaTlNmwzVX0qOLyNh4TtVrS/O7BQ=
Message-ID: <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com>
Date: Fri, 15 Jun 2007 01:27:44 +0200
From: Luca <kronos.it@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
In-Reply-To: <20070614231359.GA5705@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46651069.5040003@qumranet.com> <466BED18.5040708@qumranet.com>
	 <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com>
	 <466CFD6D.2080201@qumranet.com>
	 <20070612175246.GA5864@dreamland.darkstar.lan>
	 <466FB1ED.3090905@qumranet.com>
	 <20070613204948.GA14710@dreamland.darkstar.lan>
	 <4670FBB5.70707@qumranet.com>
	 <20070614225324.GA4088@dreamland.darkstar.lan>
	 <20070614231359.GA5705@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Il Fri, Jun 15, 2007 at 12:53:24AM +0200, Luca Tettamanti ha scritto:
> > Il Thu, Jun 14, 2007 at 11:26:29AM +0300, Avi Kivity ha scritto:
> > > Luca Tettamanti wrote:
> > > >With GOOD_APIC apic_read_around is a nop, while apic_write_around is a
> > > >normal write. With !GOOD_APIC apic_write_around writes to the APIC reg
> > > >using xchg. With !GOOD_APIC and this patch:
> > > >
> > > >--- include/asm-i386/apic.h~       2007-04-26 05:08:32.000000000 +0200
> > > >+++ include/asm-i386/apic.h        2007-06-13 22:35:00.000000000 +0200
> > > >@@ -56,7 +56,8 @@
> > > > static __inline fastcall void native_apic_write_atomic(unsigned long reg,
> > > >                                                  unsigned long v)
> > > > {
> > > >-  xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> > > >+//        xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> > > >+  *((volatile unsigned long *)(APIC_BASE+reg)) = v;
> > > > }
> > > >
> > > > static __inline fastcall unsigned long native_apic_read(unsigned long reg)
> > > >
> > > >The kernel boots fine.
> > > >
> > >
> > > Looking at the xchg emulation code, it seems fine, but clearly it
> > > isn't.
> >
> > Btw, I've put a printk in x86_emulate.c, where it prepares the operands
> > for the xchg operations: all the write_atomic are hitting this point,
> > so the write is lost somewhere in cmpxchg_emulated->write_emulated.
>
> Got it!
> The emulator skips the writeback if the old value is unchanged, so the
> apic doesn't see the write.
>
> Forcing the writeback:
>
> -      if ((d & Mov) || (dst.orig_val != dst.val)) {
> -      if ((d & Mov) || (dst.orig_val != dst.val) || isxchg) {
>
> seems to fix the issue :D I'm not sure that fix is correct though.

After a bit of thinking: it's correct but removes an optimization;
furthermore it may miss other instructions that write to memory mapped
areas.
A more proper fix should be "force the writeback if dst.ptr is in some
kind of mmio area".

Ok, enough of reply-to-self. I'll go to sleep...
Luca
