Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXFGRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXFGRoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758338AbXFGRo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:44:28 -0400
Received: from wf1.mips-uk.com ([194.74.144.154]:48411 "EHLO
	dl5rb.ham-radio-op.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756772AbXFGRo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:44:27 -0400
X-Greylist: delayed 3714 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 13:44:25 EDT
Date: Thu, 7 Jun 2007 17:37:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
Message-ID: <20070607163731.GB30044@linux-mips.org>
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain> <4667EC18.4080904@yahoo.com.au> <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain> <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com> <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 07:53:08AM -0400, Robert P. J. Day wrote:

> > > > MIPS?
> > >
> > > argh. that would be the *one* definition whose output got chopped
> > > because of line continuation, and it would be only one that actually
> > > uses the argument:
> > >
> > > #define ZERO_PAGE(vaddr) \
> > >         (virt_to_page((void *)(empty_zero_page + (((unsigned long)(vaddr)) &
> > > zero_page_mask))))
> > >
> > >
> > > but it still leaves the question -- if ZERO_PAGE is meant to represent
> > > a single, global shared page that is always zero, why would it *ever*
> > > need to take an argument?  and what's so special about MIPS that it
> > > differs from all the rest?
> >
> > The comment above empty_zero_page and zero_page_mask
> > declarations at arch/mips/mm/init.c:508 sheds light on this ...
> 
> well, it *sort of* does.  at line 64 of that file:
> 
> /*
>  * We have up to 8 empty zeroed pages so we can map one of the right colour
>  * when needed.  This is necessary only on R4000 / R4400 SC and MC versions
>  * where we have to avoid VCED / VECI exceptions for good performance at
>  * any price.  Since page is never written to after the initialization we
>  * don't have to care about aliases on other CPUs.
>  */
> 
> although it's not clear where in the source tree are the invocations
> that would actually make a difference to a MIPS system, which is why
> i've CC'ed ralf on this.  i'm sure he can clear this up. :-)

Cache aliases.  When the same page of physical memory is mapped twice to
user space, let's say at address addr and addr + PAGE_SIZE this is normally
harmless although wasteful on processors with virtually indexed caches as
long as the page is mapped read-only such as in case of ZERO_PAGE.

If the same thing happens with a writable page there is the chance of
severe data corruption.  Some members of the R4000 family are now trying
to be helpful by throwing the kernel a "virtual coherency" exception.  The
bad news about this exception is there might be thousands (the theoretical
worst case would be millions) of it in a single second, so servicing can be
very expensive.  For the ZERO page this can be avoided by using several
pages mapped in a way such that their addresses don't conflict.

  Ralf
