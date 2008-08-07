Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbYHGX3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbYHGX3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbYHGX2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:28:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbYHGX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:28:46 -0400
Date: Thu, 7 Aug 2008 16:27:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: ehabkost@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make PFN_PHYS return a properly-formed physical address
Message-Id: <20080807162741.8dfcd336.akpm@linux-foundation.org>
In-Reply-To: <489B72C3.30603@goop.org>
References: <489B6B40.5050705@goop.org>
	<20080807145648.ab3dfa90.akpm@linux-foundation.org>
	<489B72C3.30603@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2008 15:10:11 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > On Thu, 07 Aug 2008 14:38:08 -0700
> > Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> PFN_PHYS, as its name suggests, turns a pfn into a physical address.
> >> However, it is a macro which just operates on its argument without
> >> modifying its type.  pfns are typed unsigned long, but an unsigned
> >> long may not be long enough to hold a physical address (32-bit systems
> >> with more than 32 bits of physcial address).  This means that the
> >> resulting address could be truncated if it doesn't fit within an
> >> unsigned long.  This isn't generally a problem because most users end
> >> up using it for "low" memory, but there's no reason why PFN_PHYS
> >> couldn't be used for any possible pfn.
> >>     
> >
> > Please copy a mailing list on patches.  So you can get your titties
> > toasted off ;)
> >   
> 
> Oops.  Forgot.
> 
> >> Fortunately, resource_size_t is the right size, and has approximately
> >> the right meaning.  It's 64-bits on platforms where that's
> >> appropriate, but 32-bits where the extra bits are not needed.
> >>     
> >
> > aww maaan.  Hack or what?
> >   
> 
> I don't know.  Is it?  It's what linux/ioport.h:struct resource uses to 
> hold "start" and "end", which presumably means its intended to hold 
> arbitrary physical addresses.

Yes, but resource_size_t is for IO addressing, not for memory addressing.

Lots of X86_32 machines can happily support 32-bit physical addresses
for IO while needing >32 bit addresses for physical memory.


> >>  #define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
> >>  #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
> >>  #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
> >> -#define PFN_PHYS(x)	((x) << PAGE_SHIFT)
> >> +#define PFN_PHYS(x)	((resource_size_t)(x) << PAGE_SHIFT)
> >>     
> >
> > Busted on PAE with CONFIG_RESOURCES_64BIT=n, surely?
> >   
> 
> Not an option:
> 
> config X86_PAE
> 	def_bool n
> 	prompt "PAE (Physical Address Extension) Support"
> 	depends on X86_32 && !HIGHMEM4G
> 	select RESOURCES_64BIT
> 

err, OK, that was a bit arbitrary of us.

Oh well, scrub the above assertion.

Then again, do all architectures disallow 32-bit resource_size_t on
64-bit?  And there's ppc32's CONFIG_HIGHMEM option to think about.

> And if you don't enable RESOURCES_64BIT, then I guess it's reasonable 
> for PFN_PHYS to discount the possibility of high pages?
> 
> > Can we please do this properly, whatever that is?  Even a dumb
> > always-return-u64 would be better?
> >   
> 
> I had that originally, but someone (hpa?) suggested resource_size_t.  
> The sad thing is that most users don't really care;  they're either 
> 64-bit anyway, or immediately truncate the result to 32-bit.
> 
> "Properly" would be to define a phys_addr_t which can always represent a 
> physical address.  We have one in x86-land, but I hesitate to add it for 
> everyone else.

hm.  It is a distinct and singular concept - it makes sense to have a
specific type to represet "a physical address for memory".


> >> 			printk("initrd extends beyond end of memory "
> >> -				"(0x%08lx > 0x%08lx)\ndisabling initrd\n",
> >> +				"(0x%08lx > 0x%08llx)\ndisabling initrd\n",
> >> 				INITRD_START + INITRD_SIZE,
> >> 				PFN_PHYS(max_low_pfn));
> >>     
> >
> > that'll generate a compile warning if m32r can set CONFIG_RESOURCES_64BIT=n.
> >   
> 
> (u64) cast, I guess.
> 

nope ;) We don't know what type u64 has - some architectures use
`unsigned long' (we might fix this soon).

For now, a full cast to `unsigned long long' is needed.


