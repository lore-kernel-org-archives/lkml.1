Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbXFNWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbXFNWxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXFNWw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:52:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:29382 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbXFNWw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Qml+hYt6bBHFId90DjtMtbY4fXytbfpCOgqheWcJPVMh0ZOeSRUXN1G+qLwX4W2/XkI9IcnUupb6p2Fmy5p629nEkCdMBPmECr5rwzqRVK2muVJXGtxEh4rNDoBoZ0P31klnQxuN8Edt7yIpv4rfTzMrGceMKcueVaIb/K21zjQ=
Date: Fri, 15 Jun 2007 00:53:24 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Message-ID: <20070614225324.GA4088@dreamland.darkstar.lan>
Reply-To: kronos@dreamland.darkstar.lan
Mail-Followup-To: Avi Kivity <avi@qumranet.com>,
	kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070604212207.GA22365@dreamland.darkstar.lan> <46651069.5040003@qumranet.com> <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com> <466BED18.5040708@qumranet.com> <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com> <466CFD6D.2080201@qumranet.com> <20070612175246.GA5864@dreamland.darkstar.lan> <466FB1ED.3090905@qumranet.com> <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4670FBB5.70707@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Thu, Jun 14, 2007 at 11:26:29AM +0300, Avi Kivity ha scritto: 
> Luca Tettamanti wrote:
> >With GOOD_APIC apic_read_around is a nop, while apic_write_around is a
> >normal write. With !GOOD_APIC apic_write_around writes to the APIC reg
> >using xchg. With !GOOD_APIC and this patch:
> >
> >--- include/asm-i386/apic.h~	2007-04-26 05:08:32.000000000 +0200
> >+++ include/asm-i386/apic.h	2007-06-13 22:35:00.000000000 +0200
> >@@ -56,7 +56,8 @@
> > static __inline fastcall void native_apic_write_atomic(unsigned long reg,
> > 						       unsigned long v)
> > {
> >-	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> >+//	xchg((volatile unsigned long *)(APIC_BASE+reg), v);
> >+	*((volatile unsigned long *)(APIC_BASE+reg)) = v;
> > }
> > 
> > static __inline fastcall unsigned long native_apic_read(unsigned long reg)
> >
> >The kernel boots fine. 
> >  
> 
> Looking at the xchg emulation code, it seems fine, but clearly it 
> isn't.

Btw, I've put a printk in x86_emulate.c, where it prepares the operands
for the xchg operations: all the write_atomic are hitting this point,
so the write is lost somewhere in cmpxchg_emulated->write_emulated.

Luca
-- 
Il dottore mi ha detto di smettere di fare cene intime per quattro.
A meno che non ci siamo altre tre persone.
