Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbYBWPZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbYBWPZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYBWPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:25:30 -0500
Received: from waste.org ([66.93.16.53]:51512 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbYBWPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:25:29 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080223000626.9df16d25.akpm@linux-foundation.org>
References: <20080220135743.GA10127@escobedo.amd.com>
	 <20080223000626.9df16d25.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 23:25:13 +0800
Message-Id: <1203780313.14838.176.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 00:06 -0800, Andrew Morton wrote:
> On Wed, 20 Feb 2008 14:57:43 +0100 "Hans Rosenfeld" <hans.rosenfeld@amd.com> wrote:
> 
> > The current code for /proc/pid/pagemap does not work with huge pages (on
> > x86). The code will make no difference between a normal pmd and a huge
> > page pmd, trying to parse the contents of the huge page as ptes. Another
> > problem is that there is no way to get information about the page size a
> > specific mapping uses.
> > 
> > Also, the current way the "not present" and "swap" bits are encoded in
> > the returned pfn isn't very clean, especially not if this interface is
> > going to be extended.
> > 
> > I propose to change /proc/pid/pagemap to return a pseudo-pte instead of
> > just a raw pfn. The pseudo-pte will contain:
> > 
> > - 58 bits for the physical address of the first byte in the page, even
> >   less bits would probably be sufficient for quite a while
> > 
> > - 4 bits for the page size, with 0 meaning native page size (4k on x86,
> >   8k on alpha, ...) and values 1-15 being specific to the architecture
> >   (I used 1 for 2M, 2 for 4M and 3 for 1G for x86)
> > 
> > - a "swap" bit indicating that a not present page is paged out, with the
> >   physical address field containing page file number and block number
> >   just like before
> > 
> > - a "present" bit just like in a real pte
> >   
> > By shortening the field for the physical address, some more interesting
> > information could be included, like read/write permissions and the like.
> > The page size could also be returned directly, 6 bits could be used to
> > express any page shift in a 64 bit system, but I found the encoded page
> > size more useful for my specific use case.
> > 
> > 
> > The attached patch changes the /proc/pid/pagemap code to use such a
> > pseudo-pte. The huge page handling is currently limited to 2M/4M pages
> > on x86, 1G pages will need some more work. To keep the simple mapping of
> > virtual addresses to file index intact, any huge page pseudo-pte is
> > replicated in the user buffer to map the equivalent range of small
> > pages. 
> > 
> > Note that I had to move the pmd_pfn() macro from asm-x86/pgtable_64.h to
> > asm-x86/pgtable.h, it applies to both 32 bit and 64 bit x86.
> > 
> > Other architectures will probably need other changes to support huge
> > pages and return the page size.
> > 
> > I think that the definition of the pseudo-pte structure and the page
> > size codes should be made available through a header file, but I didn't
> > do this for now.
> > 
> 
> If we're going to do this, we need to do it *fast*.  Once 2.6.25 goes out
> our hands are tied.
> 
> That means talking with the maintainers of other hugepage-capable
> architectures.
> 
> > +struct ppte {
> > +	uint64_t paddr:58;
> > +	uint64_t psize:4;
> > +	uint64_t swap:1;
> > +	uint64_t present:1;
> > +};
> 
> This is part of the exported kernel interface and hence should be in a
> header somewhere, shouldn't it?  The old stuff should have been too.

I think we're better off not using bitfields here.

> u64 is a bit more conventional than uint64_t, and if we move this to a
> userspace-visible header then __u64 is the type to use, I think.  Although
> one would expect uint64_t to be OK as well.
> 
> > +#ifdef CONFIG_X86
> > +#define PM_PSIZE_1G      3
> > +#define PM_PSIZE_4M      2
> > +#define PM_PSIZE_2M      1
> > +#endif
> 
> No, we should factor this correctly and get the CONFIG_X86 stuff out of here.

Perhaps my "continuation bit" idea.

> Matt?  Help?

Did my previous message make it out? This is probably my last message
for 24+ hours.

-- 
Mathematics is the supreme nostalgia of our time.

