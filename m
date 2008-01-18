Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYARPY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYARPY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbYARPYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:24:19 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:32853 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbYARPYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:24:18 -0500
X-Greylist: delayed 23743 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 10:24:18 EST
From: Ian Campbell <ijc@hellion.org.uk>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com>
References: <1200375906.3505.30.camel@caritas-dev.intel.com>
	 <1200646105.17230.28.camel@cthulhu.hellion.org.uk>
	 <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 15:23:57 +0000
Message-Id: <1200669837.9891.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - enhance bt_ioremap
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 22:54 +0800, huang ying wrote:
> On Jan 18, 2008 4:48 PM, Ian Campbell <ijc@hellion.org.uk> wrote:
> > On Tue, 2008-01-15 at 13:45 +0800, Huang, Ying wrote:
> > > +void __init bt_ioremap_init(void)
> > > +{
> > > [...]
> > > +     *pgd = __pa(bm_pte) | _PAGE_TABLE;
> > > +}
> > > [...]
> > > +static void __init __bt_set_fixmap(enum fixed_addresses idx,
> > > +                                unsigned long phys, pgprot_t flags)
> > > +{
> > > [...]
> > > +     if (pgprot_val(flags))
> > > +             *pte = (phys & PAGE_MASK) | pgprot_val(flags);
> > > +     else
> > > +             *pte = 0;
> > [...]
> >
> > Shouldn't these, and the rest of the file, be using the PTE accessor
> > macros set_pte,clear_pte etc? The boot_ioremap it replaces seems to have
> > done. Otherwise these patches don't appear to be paravirt_ops clean. I
> 
> If CONFIG_X86_PAE is defined, the set_pte, clear_pte etc will operate
> 3-level page tables, while on i386, the early page table is always
> 2-level, so set_pte, clear_pte etc functions can not be used here. The
> boot_ioremap use a trick to deal with this problem. The CONFIG_X86_PAE
> is undefined in arch/x86/mm/boot_ioremap_32.c unconditionally, so the
> 2-level page table handling function is always used.

Ah, when booting a Xen guest you get 3 level page tables right from the
start.

I'm hacking on a patch right now but I hadn't appreciated/noticed that
this was a two level page table even on a PAE kernel which would explain
why it isn't exactly working as planned...

> Is the method used by boot_ioremap better for Xen?

Well, it worked ;-) I haven't looked closely enough at the two ways of
doing things to comment further but I'm sure the new way can be made to
work for Xen too somehow.

> [snip]

> This crash has nothing to do with this patch. Because this patch is
> for i386 only, x86_64 has its own early_ioremap implementation.

It's a 64 bit hypervisor but the guest in question is a 32 bit (PAE)
guest.

Ian
-- 
Ian Campbell
Current Noise: Mistress - Cheyne Stoking

You can't kiss a girl unexpectedly -- only sooner than she thought you would.

