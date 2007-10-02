Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbXJBDEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbXJBDEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 23:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXJBDE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 23:04:27 -0400
Received: from owa.c2.net ([207.235.78.2]:58305 "EHLO email.c2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbXJBDE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 23:04:26 -0400
Subject: Re: [PATCH] Inconsistent mmap()/mremap() flags
From: Thayne Harbaugh <thayne@c2.net>
Reply-To: thayne@c2.net
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, discuss@x86-64.org
In-Reply-To: <200710011313.30171.andi@firstfloor.org>
References: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
	 <200710011313.30171.andi@firstfloor.org>
Content-Type: text/plain
Organization: C2
Date: Mon, 01 Oct 2007 20:57:10 -0600
Message-Id: <1191293830.5200.22.camel@phantasm.home.enterpriseandprosperity.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2007 03:04:25.0332 (UTC) FILETIME=[F0532B40:01C804A0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 13:13 +0200, Andi Kleen wrote:
> > @@ -388,6 +392,9 @@
> >  			if (vma->vm_flags & VM_MAYSHARE)
> >  				map_flags |= MAP_SHARED;
> >  
> > +			if (flags & MAP_32BIT)
> > +				map_flags |= MAP_32BIT;
> > +
> >  			new_addr = get_unmapped_area(vma->vm_file, 0, new_len,
> >  						vma->vm_pgoff, map_flags);
> >  			ret = new_addr;
> 
> That's not enough -- you would also need to fail the mremap when the result
> is > 2GB (MAP_32BIT is actually a MAP_31BIT) 

Yeah, after I sent the email I realized that it was a bit more involved.
As far as the 32/31 bit, it just depends on the perspective.  I can see
that 32 bits are needed to represent all possible return values from
mmap() - possible address and error value of -1.  From that perspective
I think that MAP_32BIT is appropriate.

> But that would be ugly to implement without a new architecture wrapper
> or better changing arch_get_unmapped_area()
> 
> It might be better to just not bother. MAP_32BIT is a kind of hack anyways
> that at least for mmap can be easily emulated in user space anyways.

Care to give me some hints as to how that would be easily emulated in
user space?  That might be a better solution for the case I want to
solve.

> Given for mremap() it is not that easy because there is no "hint" argument
> without MREMAP_FIXED; but unless someone really needs it i would prefer
> to not propagate the hack. If it's really needed it's probably better
> to implement a start search hint for mremap()

It came up for user-mode Qemu for the case of emulating 32bit archs on
x86_64 using mmap.  At the moment it calls mmap with MAP_32BIT and then
uses the returned address directly in the emulator.  Without MAP_32BIT
there's the possibility of having an address that would be too large to
pass to what a 32bit arch would expect.  Since the MAP_32BIT flag solves
the problem for mmap() I was expecting something similar for mremap() -
unfortunately the MAP_32BIT feature is consistent throughout.

Thoughts?


