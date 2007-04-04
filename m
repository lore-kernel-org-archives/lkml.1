Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXDDXUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXDDXUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXDDXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:20:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:37500 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXDDXUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:20:44 -0400
Subject: Re: [PATCH 0/14] Pass MAP_FIXED down to get_unmapped_area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <23370.1175682715@redhat.com>
References: <1175659331.690672.592289266160.qpush@grosgo>
	 <23370.1175682715@redhat.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 09:20:33 +1000
Message-Id: <1175728833.30879.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 11:31 +0100, David Howells wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > This serie of patches moves the logic to handle MAP_FIXED down to the
> > various arch/driver get_unmapped_area() implementations, and then changes
> > the generic code to always call them. The hugetlbfs hacks then disappear
> > from the generic code.
> 
> This sounds like get_unmapped_area() is now doing more than it says on the
> tin.  As I understand it, it's to be called to locate an unmapped area when
> one wasn't specified by MAP_FIXED, and so shouldn't be called if MAP_FIXED is
> set.

Well... that was the initial implementation. But that doesn't quite deal
well with various issues like page size constraints like the segment
constraints on powerpc or other hugetlbfs realted issues, and the
aliasing problems on architectures with virtually caches...

Just look at how many architectures already have special case for
MAP_FIXED in their arch_get_unmapped_area ! It was never called so far
though, my patch makes it being called.

I agree it's probably not the best interface, but I'm still trying to
figure out something that would be nicer as a "second step", as I don't
want to do too much in one set of patches. This serie allows me to hook
in my SPE 64K page thingy, to cleanup & improve a bit my hugetlb
handling, and possibly fixes some of those aliasing issues on
architectures with virtual caches...

> Admittedly, on NOMMU, it's also used to find the location of quasi-memory
> devices such as framebuffers and ramfs files, but that's not a great deviation
> from the original intent.
> 
> Perhaps a change of name is in order for the function?

I'm not sure. "get" can mean "obtain" :-) The way it's currently
implemented for me on powerpc works fine that way, I don't need an
"unget".

> > Since I need to do some special 64K pages mappings for SPEs on cell, I need
> > to work around the first problem at least. I have further patches thus
> > implementing a "slices" layer that handles multiple page sizes through
> > slices of the address space for use by hugetlbfs, the SPE code, and possibly
> > others, but it requires that serie of patches first/
> 
> That makes it sound like there should be an "unget" too for when an error
> occurs between ->get_unmapped_area() being called and ->mmap() returning
> successfully.

I don't need it because I can flip the page size of the segment back if
it has no VMA in it on the next get_unmapped_area(). Again, I'd like to
come up with a better interface, and I might post something in that
direction next week, but I beleive those patches (+/- bug fixes) are a
good first step in the right direction. I also need to find a proper way
to solve the mremap problem as it's bogus as it is already with things
like hugetlbfs on powerpc at least. 

Ben.


