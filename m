Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYBYSj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYBYSj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbYBYSjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:39:17 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38296 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbYBYSjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:39:16 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Dave Hansen <haveblue@us.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>
In-Reply-To: <20080225120951.GA5963@escobedo.amd.com>
References: <20080220135743.GA10127@escobedo.amd.com>
	 <1203733096.14838.154.camel@cinder.waste.org>
	 <1203791461.11305.135.camel@nimitz.home.sr71.net>
	 <20080225120951.GA5963@escobedo.amd.com>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 10:39:10 -0800
Message-Id: <1203964750.28196.7.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 13:09 +0100, Hans Rosenfeld wrote:
> On Sat, Feb 23, 2008 at 10:31:01AM -0800, Dave Hansen wrote:
> > > > - 4 bits for the page size, with 0 meaning native page size (4k on x86,
> > > >   8k on alpha, ...) and values 1-15 being specific to the architecture
> > > >   (I used 1 for 2M, 2 for 4M and 3 for 1G for x86)
> > 
> > "Native page size" probably a bad idea.  ppc64 can use 64k or 4k for its
> > "native" page size and has 16MB large pages (as well as some others).
> > To make it even more confusing, you can have a 64k kernel page size with
> > 4k mmu mappings!
> > 
> > That said, this is a decent idea as long as we know that nobody will
> > ever have more than 16 page sizes.  
> 
> Then a better way to encode the page size would be returning the page
> shift. This would need 6 bits instead of 4, but it would probably be
> enough for any 64 bit architecture.

That's a good point.

> > > This is ok-ish, but I can't say I like it much. Especially the page size
> > > field.
> > > 
> > > But I don't really have many ideas here. Perhaps having a bit saying
> > > "this entry is really a continuation of the previous one". Then any page
> > > size can be trivially represented. This might also make the code on both
> > > sides simpler?
> 
> I don't like the idea of parsing thousands of entries just to find out
> that I'm using a huge page. It would be much better to just get the page
> size one way or the other in the first entry one reads.

Did you read my suggestion?  We use one bit in the pte to specify that
its a large page mapping, then specify a mask to apply to the address to
get the *first* mapping of the large page, where you're find the actual
physical address.  That keeps us from having to worry about specifying
*both* the page size and the pfn in the same pte.

> > > > +#ifdef CONFIG_X86
> > > > +	if (pmd_huge(*pmd)) {
> > > > +		struct ppte ppte = { 
> > > > +			.paddr = pmd_pfn(*pmd) << PAGE_SHIFT,
> > > > +			.psize = (HPAGE_SHIFT == 22 ?
> > > > +				  PM_PSIZE_4M : PM_PSIZE_2M),
> > > > +			.swap  = 0,
> > > > +			.present = 1,
> > > > +		};
> > > > +
> > > > +		for(; addr != end; addr += PAGE_SIZE) {
> > > > +			err = add_to_pagemap(addr, ppte, pm);
> > > > +			if (err)
> > > > +				return err;
> > > > +		}
> > > > +	} else
> > > > +#endif
> > 
> > It's great to make this support huge pages, but things like this
> > probably need their own function.  Putting an #ifdef in the middle of
> > here makes it a lot harder to read.  Just think of when powerpc, ia64
> > and x86_64 get their grubby mitts in here. ;)
> 
> AFAIK the way huge pages are used on x86 differs much from other
> architectures. While on x86 the address translation stops at some upper
> table for a huge page, other architectures encode the page size in the
> pte (at least the ones I looked at did). So pmd_huge() (and soon
> pud_huge()) are very x86-specific and return just 0 on other archs,

I'm just asking that you please put this in a nice helper function to
hide it from the poor powerpc/ia64/mips... guys that don't want to see
x86 code cluttering up otherwise generic functions.  Yes, the compiler
optimizes it away, but it still has a cost to my eyeballs. :)

I eagerly await your next patch!

-- Dave

