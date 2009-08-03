Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbZHCQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbZHCQbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZHCQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:31:09 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:12893 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932171AbZHCQbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:31:07 -0400
X-Trace: 240238535/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.91.151/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.91.151
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEACutdkpPRVuX/2dsb2JhbACBUtFMhBgF
X-IronPort-AV: E=Sophos;i="4.43,315,1246834800"; 
   d="scan'208";a="240238535"
Date: Mon, 3 Aug 2009 17:30:58 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Leon Woestenberg <leon.woestenberg@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: get_user_pages() on an mmap()ed file allowed? What to do if 0
 <  get_user_pages(..., nr_pages, ...) < nr_pages?
In-Reply-To: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, Leon Woestenberg wrote:
> 
> I have a PCI device driver performing DMA to a scattered user-space buffer.
> Given a malloc()ed buffer, get_user_pages(..., buffer, nr_pages, ...)
> always returns to requested number of pages and everything works as
> expected.
> So far so good.
> 
> Since that I changed userspace to mmap() a file, instead of
> malloc()ing a buffer.
> The mmap() in userspace works.
> 
> However, in the driver get_user_pages() starts to return less pages
> than I requested, in an undeterministic fashion (most of the times I
> get the expected number,
> sometimes I get only a part of the requested pages).
> 
> Reading the get_user_pages() implementation dazzles me too much,
> still.  I wonder if I am violating the kernel API?
> 
> - is it allowed to have a PCI device DMA-read from memory pages, that
> belong to a file mmap()'d by userspace?

Yes.

> - what are valid reasons for get_user_pages() to fail?

I'd hesitate to give a complete answer to that: but main reasons
would be SIGKILL, or running out of memory (-ENOMEM), or running
off the end of a mapping or mapped object, or no permission to it
(-EFAULT): with a short page count returned instead of error if
some pages were successfully gotten before hitting the error.

> - what should a driver do when get_user_pages() returns less pages
> than requested?

Probably put_page the pages gotten then report the surprise;
perhaps, before putting the pages gotten, try get_user_pages
on the next alone, to see what error code is returned for that.

Unless it's happy to work with fewer pages than requested,
in which case work with them and ignore the surprise.

> 
> 
> A snippet of the code:
> 
> 
> my user space does:
> 
>     int fd = open(filename, O_RDONLY);
>     assert(fd >= 0);
> 
>     /* map the file in memory */
>     char *buffer = mmap(0, buffersize, PROT_READ, MAP_SHARED, fd, 0);
>     assert(buffer != MAP_FAILED);
> 
>     /* advice sequential access */
>     int rc = madvise(buffer, buffersize, MADV_SEQUENTIAL);
>     assert(rc == 0);
> 
> my driver does:
> 
>     const unsigned long first = (boe & PAGE_MASK) >> PAGE_SHIFT;
>     const unsigned long last  = ((boe + count - 1) & PAGE_MASK) >> PAGE_SHIFT;
>     const int nr_pages = last - first + 1;
>     ...
>     down_read(&current->mm->mmap_sem);
>     rc = get_user_pages(current, current->mm, start & PAGE_MASK,
> nr_pages, 0 /* do not write*/, 1 /* do force */, pages, NULL);
>     up_read(&current->mm->mmap_sem);
> 
>     BUG_ON(rc < nr_pages);

When that BUG triggers, is rc a positive number of pages,
or a negative error code - which?  (or even 0, but it shouldn't be).
I assume from your Subject that you've already seen a positive number
of pages.

Code doesn't look wrong to me (except you shouldn't BUG), though I am
having to assume that buffer and boe and start are all the same address,
and count fits within buffersize; or at least that the range to which you
apply get_user_pages really does fit within the area you have mmap'ed.

(I'd advise against using 1 /* do force */, I don't think you need
that: the force is mysterious, and should only be called upon in direst
need.  But it shouldn't actually be causing you any problem here.)

Is the file you have mmap'ed big enough?  If it's not as long as the
last page you're trying to get_user_pages on, or gets truncated, then
indeed that will give -EFAULT or a short count - just as trying to
access the end of the mapping in userspace would give you SIGBUS.

Hugh
