Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbXFGL4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbXFGL4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXFGLzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:55:54 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43158 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXFGLzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:55:53 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 7 Jun 2007 07:53:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
In-Reply-To: <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain>
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain> 
 <4667EC18.4080904@yahoo.com.au>  <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain>
 <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Satyam Sharma wrote:

> On 6/7/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > On Thu, 7 Jun 2007, Nick Piggin wrote:
> >
> > > Robert P. J. Day wrote:
> > > >   probably making a fool of myself here, but what is the purpose of
> > > > that single argument to the macro "ZERO_PAGE"?
> > > >
> > > > $ grep -r "define ZERO_PAGE" include
> > > > include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)      ({ BUG(); NULL;
> > })
> > > > include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)
> > > > virt_to_page(empty_zero_page)
> > > > include/asm-v850/pgtable.h:#define ZERO_PAGE(vaddr)     ((void
> > *)0x87654321)
> > > > include/asm-mips/pgtable.h:#define ZERO_PAGE(vaddr) \
> > > > include/asm-blackfin/pgtable.h:#define ZERO_PAGE(vaddr)
> > (virt_to_page(0))
> > > > include/asm-parisc/pgtable.h:#define ZERO_PAGE(vaddr)
> > > > (virt_to_page(empty_zero_page))
> > > > include/asm-alpha/pgtable.h:#define ZERO_PAGE(vaddr)
> > > > (virt_to_page(ZERO_PGE))
> > > > ...
> > > >
> > > >   AFAICT, there are no definitions of that macro that actually use
> > > > that argument.  is that some kind of historical cruft?
> > >
> > > MIPS?
> >
> > argh. that would be the *one* definition whose output got chopped
> > because of line continuation, and it would be only one that actually
> > uses the argument:
> >
> > #define ZERO_PAGE(vaddr) \
> >         (virt_to_page((void *)(empty_zero_page + (((unsigned long)(vaddr)) &
> > zero_page_mask))))
> >
> >
> > but it still leaves the question -- if ZERO_PAGE is meant to represent
> > a single, global shared page that is always zero, why would it *ever*
> > need to take an argument?  and what's so special about MIPS that it
> > differs from all the rest?
>
> The comment above empty_zero_page and zero_page_mask
> declarations at arch/mips/mm/init.c:508 sheds light on this ...

well, it *sort of* does.  at line 64 of that file:

/*
 * We have up to 8 empty zeroed pages so we can map one of the right colour
 * when needed.  This is necessary only on R4000 / R4400 SC and MC versions
 * where we have to avoid VCED / VECI exceptions for good performance at
 * any price.  Since page is never written to after the initialization we
 * don't have to care about aliases on other CPUs.
 */

although it's not clear where in the source tree are the invocations
that would actually make a difference to a MIPS system, which is why
i've CC'ed ralf on this.  i'm sure he can clear this up. :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
