Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXDTBOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXDTBOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXDTBOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:14:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51653 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752228AbXDTBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:14:13 -0400
Date: Thu, 19 Apr 2007 18:14:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Chinner <dgc@sgi.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
In-Reply-To: <20070419224225.GJ32602149@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0704191810590.14874@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419224225.GJ32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, David Chinner wrote:

> So looking at this the main thing for converting a filesystem is some extra
> bits in the mount process and replacing PAGE_CACHE_* macros with
> page_cache_*() wrapper functions.

Right.

> We can probably set all this up trivially with XFS by allowing block size > page
> size filesystems to be mounted and modifying the way we feed pages to a bio
> to be aware of compound pages.

That would be great! Anyone volunterering for the block layer?

> > What is currently not supported:
> > - Buffer heads for higher order pages (possible with the compound pages in mm
> >   that do not use page->private requires upgrade of the buffer cache layers).
> 
> Does this mean that the -mm code will currently support bufferheads on compound
> pages? We need that before we can get XFS to work with compound pages.

There needs to be some work done on that level. But page->private can be 
used for compound pages now which should make this simple to do.

> > - Higher order pages in the block layer etc.
> 
> It's more drivers that we have to worry about, I think.  We don't need to
> modify bios to explicitly support compound pages. From bio.h:
> 
> /*
>  * was unsigned short, but we might as well be ready for > 64kB I/O pages
>  */
> struct bio_vec {
>         struct page     *bv_page;
>         unsigned int    bv_len;
>         unsigned int    bv_offset;
> };
> 
> So compound pages should be transparent to anything that doesn't
> look at the contents of bio_vecs....

Great!

> > - Mmapping higher order pages
> 
> *nod*
> 
> hmmm - what about the way we do copyin and copyout from the page cache? ie
> we kmap_atomic() them before we access them. Does this need to change?

kmap_atomic does not do anything if we do not use highmem. If we want to 
support highmem with higher order pages then kmap_atomic needs to support 
arbitrary page orders.

>> > The ramfs driver can be used to test higher order page cache functionality
> > (and may help troubleshoot the VM support until we get some real filesystem
> > and real devices supporting higher order pages).
> 
> I don't think it will take much to get XFS to work with a high order
> page cache and we can probably insulate the block layer initially with some
> kind of bio_add_compound_page() wrapper and some similar
> wrapper on the io completion side.

I'd be happy if we could make this work soon.

> So far it's much less intrusive than I expected ;)

I was surprised too. Seems that multiple people have been preparing for 
the great day when we finally support higher order pages in the page 
cache.

