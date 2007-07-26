Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbXGZPTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbXGZPTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762732AbXGZPTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:19:38 -0400
Received: from web50103.mail.re2.yahoo.com ([206.190.38.31]:35222 "HELO
	web50103.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760520AbXGZPTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:19:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=o9mr4bnZ4hf5KZrxiF8kd3DWyTmXI1OUlutxX3vCSbXkDBc0dgfB3+vydyUnFVMnmyYbB8tiKC4PMXpEHJKeB2TwndsbxnqrcNF0fbNKB8bubOK+0NPbTmhB6zZoC0vTyfY6LYl+muAiwYpyzBvzxHhAONkaGbX2AwWMWSyyUfc=;
X-YMail-OSG: gzLA9cgVM1mn9i_.ksPyqLgBfS3SsbGghBQIDjE65Hie30MRUnj3_bPBVUEhqMMunPn_xioQ.R0HnFmiugOUc2Il9awHfthd6stBqsoIEJfKCuaGSbRbFz5lNNuNRKpvOxAzeDN9c3M-
Date: Thu, 26 Jul 2007 08:19:33 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH 3/4] include asm-mips add missing edac h file
To: Andrew Morton <akpm@linux-foundation.org>, dougthompson@xmission.com
Cc: greg@kroah.com, ralf@linux-mips.org, egor@pasemi.com,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20070725222500.e537531d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <975861.36218.qm@web50103.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Jul 2007 14:55:01 -0600 dougthompson@xmission.com wrote:
> 
> > --- /dev/null
> > +++ linux-2.6.23-rc1/include/asm-mips/edac.h
> > @@ -0,0 +1,35 @@
> > +#ifndef ASM_EDAC_H
> > +#define ASM_EDAC_H
> > +
> > +/* ECC atomic, DMA, SMP and interrupt safe scrub function */
> > +
> > +static __inline__ void atomic_scrub(void *va, u32 size)
> 
> Please don't use __inline__ or __inline.  Good old "inline" will do.

ok, thanks.

I have to admit, since I don't know MIPS assembly, the guys at Sicortex.com developed
this function.

> 
> <cc's the checkpatch maintainer>
> 
> <edits the diff>

thanks

> 
> > +{
> > +	unsigned long *virt_addr = va;
> > +	unsigned long temp;
> > +	u32 i;
> > +
> > +	for (i = 0; i < size / sizeof(unsigned long); i++, virt_addr++) {
> > +
> > +		/*
> > +		 * Very carefully read and write to memory atomically
> > +		 * so we are interrupt, DMA and SMP safe.
> > +		 *
> > +		 * Intel: asm("lock; addl $0, %0"::"m"(*virt_addr));
> > +		 */
> > +
> > +		__asm__ __volatile__ (
> > +		"       .set    mips3                                   \n"
> > +		"1:     ll      %0, %1          # atomic_add            \n"
> > +		"       ll      %0, %1          # atomic_add            \n"
> > +		"       addu    %0, $0                                  \n"
> > +		"       sc      %0, %1                                  \n"
> > +		"       beqz    %0, 1b                                  \n"
> > +		"       .set    mips0                                   \n"
> > +		: "=&r" (temp), "=m" (*virt_addr)
> > +		: "m" (*virt_addr));
> > +
> > +	}
> > +}
> 
> hm, I'd have thought that we could us plain old atomic_add() for this.

This code is used as a primitive to perform software memory scrubbing.

We (many people as I remember) had a discussion a couple of years ago on lkml on this, 
so this is where this implementation pattern came from.

It might be that your thought just could be correct now after some more research.

doug t

