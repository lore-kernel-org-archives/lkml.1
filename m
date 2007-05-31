Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbXEaEvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbXEaEvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXEaEvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:51:33 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759573AbXEaEvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:51:32 -0400
Date: Wed, 30 May 2007 21:51:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Russell King" <rmk@arm.linux.org.uk>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Message-Id: <20070530215116.5e0abd57.akpm@linux-foundation.org>
In-Reply-To: <86802c440705302142n666e6488oa8f1222218d6989@mail.gmail.com>
References: <200705291844.00308.yinghai.lu@sun.com>
	<20070530201335.94f73eb9.akpm@linux-foundation.org>
	<86802c440705302134l637df0fbm9a3b99eff19201@mail.gmail.com>
	<20070530213934.0a55d86f.akpm@linux-foundation.org>
	<86802c440705302142n666e6488oa8f1222218d6989@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 21:42:15 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On 5/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 30 May 2007 21:34:35 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >
> > > they will need
> > > diff --git a/include/asm-x86_64/io.h b/include/asm-x86_64/io.h
> > > index de2cd9a..e2d66de 100644
> > > --- a/include/asm-x86_64/io.h
> > > +++ b/include/asm-x86_64/io.h
> > > @@ -145,6 +145,19 @@ extern void early_iounmap(void *addr, unsigned long size);
> > >  extern void __iomem * ioremap_nocache (unsigned long offset, unsigned
> > > long size);
> > >  extern void iounmap(volatile void __iomem *addr);
> > >
> > > +#include <asm/pgtable.h>
> > > +#include <asm/fixmap.h>
> > > +
> > > +static inline void __iomem * fix_ioremap (unsigned idx, unsigned long phys)
> > > +{
> > > +       void __iomem * vaddr;
> > > +       set_fixmap_nocache(idx, phys & PAGE_MASK);
> > > +       vaddr = (void __iomem *)__fix_to_virt(idx);
> > > +       vaddr += phys & ~PAGE_MASK;
> > > +
> > > +       return vaddr;
> > > +}
> > > +
> >
> > I hope not - I just removed that inlined function.  It's too large and the
> > inclusion of pgtable.h in io.h causes all sorts of problems.
> >
> > This function should go into arch/.../mm/ioremap.c
> >
> agree, but need to keep
> 
> #include <asm/fixmap.h>

No, there's no need for that and it is undesirable.

> and will create dummy fixmap.h for arch that doesn't support fixmap

So's that.  If we avoid the inlined function we will avoid adding more
include requirements.

