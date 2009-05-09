Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZEIIok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZEIIok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZEIIoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:44:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZEIIo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:44:29 -0400
Date: Sat, 9 May 2009 10:43:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/18] xen: hook io_apic read/write operations
Message-ID: <20090509084324.GA5158@elte.hu>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org> <1241730883-4917-3-git-send-email-jeremy@goop.org> <20090509084201.GF3656@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509084201.GF3656@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -62,8 +62,10 @@
> >  #include <asm/uv/uv_hub.h>
> >  #include <asm/uv/uv_irq.h>
> >  
> > +#include <asm/xen/hypervisor.h>
> >  #include <asm/apic.h>
> >  
> > +
> >  #define __apicdebuginit(type) static type __init
> >  
> >  /*
> > @@ -407,14 +409,26 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
> >  
> >  static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
> >  {
> > -	struct io_apic __iomem *io_apic = io_apic_base(apic);
> > +	struct io_apic __iomem *io_apic;
> > +
> > +	if (xen_initial_domain())
> > +		return xen_io_apic_read(apic, reg);
> 
> hm, any reason why we dont want to create a 'struct io_apic' 
> driver abstraction instead of spreading xen_initial_domain() 
> checks all around the code?

And on a higher level, i still dont see why you dont do the whole 
Xen thing under an irqchip. There should be no extra crappy checks 
in native code.

	Ingo
