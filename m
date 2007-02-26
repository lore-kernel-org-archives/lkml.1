Return-Path: <linux-kernel-owner+w=401wt.eu-S933757AbXBZENy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbXBZENy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 23:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbXBZENy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 23:13:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757AbXBZENx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 23:13:53 -0500
Date: Sun, 25 Feb 2007 20:13:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, john stultz <johnstul@us.ibm.com>
Subject: Re: Make sure we populate the initroot filesystem late enough
In-Reply-To: <1172462466.3971.46.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0702252009110.12485@woody.linux-foundation.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> 
 <1172448057.3971.9.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org> 
 <1172452660.3971.33.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0702251940500.12485@woody.linux-foundation.org>
 <1172462466.3971.46.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Feb 2007, David Woodhouse wrote:
>
> > Can you try adding something like
> > 
> >         memset(start, 0xf0, end - start);
> 
> Yeah, I did that before giving up on it for the day and going in search
> of dinner. It changes the failure mode to a BUG() in
> cache_free_debugcheck(), at line 2876 of mm/slab.c

Ok, that's just strange. 

One obvious thing to do would be to remove all the "__initdata" entries in 
mm/slab.c.. But I'd also like to see the full backtrace for the  BUG_ON(), 
in case that gives any clues at all.

> It smells like the pages weren't actually reserved in the first place
> and we were blithely allocating them. The only problem with that theory
> is that the initrd doesn't seem to be getting corrupted -- and if we
> were handing out its pages like that then surely _something_ would have
> scribbled on it before we tried to read it.

Yeah, I don't think it's necessarily initrd itself, I'd be more inclined 
to think that the reason you see this change with the initrd unpacking is 
simply that it does a lot of allocations for the initrd files, so I think 
it is only indirectly involved - just because it ends up being a slab 
user.

> When I head back in tomorrow morning I'll instrument free_initrd_mem()
> to check that the PageReserved bit was actually set on each page, before
> clearing it. And I'll make the page allocation routines check whether
> they're giving out pages between initrd_start and initrd_end, etc.

Sounds like a sane plan.

			Linus
