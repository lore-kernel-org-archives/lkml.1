Return-Path: <linux-kernel-owner+w=401wt.eu-S1422799AbXCBDXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799AbXCBDXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 22:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422798AbXCBDXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 22:23:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39078 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422799AbXCBDXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 22:23:03 -0500
Date: Thu, 1 Mar 2007 19:22:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: support@coraid.com, "Ed L. Cashin" <ecashin@coraid.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-Id: <20070301192245.bf034385.akpm@linux-foundation.org>
In-Reply-To: <20070302022919.GA26285@infradead.org>
References: <20070301231510.GC8524@coraid.com>
	<20070301174204.a550dd3a.akpm@linux-foundation.org>
	<20070302022919.GA26285@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 02:29:19 +0000 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Mar 01, 2007 at 05:42:04PM -0800, Andrew Morton wrote:
> > Something funny is going on here.
> 
> Not so funny for those who've tried to sort out the issue over
> the past years and just got ignored..
> 
> > Generally, one should increment the refcount of a page when it is put into
> > some container.  That means that the page should get +1 when it is added to
> > a bio.  (direct-io does this, but the mpage.c pagecache code cheats, and
> > relies upon PG_locked and PG-writeback protecting the page).
> 
> It's a slab page, and slab pages aren't refcounted (which is a good thing
> as you don't own the whole page)

ah, I see.

> > Similarly, the network code (or its caller) should be incrementing the
> > page's refcount as the page goes into a container (ie: the skb) and
> > decrementing it as the page is removed.
> > 
> > But someone somewhere is breaking those rules.  Who?
> 
> slab code.  

Well I spose slab _could_ take a ref on these pages.

> > So.  Who is breaking refcounting protocol here?  Perhaps it is AOE, failing
> > to increment the refcount on pages as they are added to an skb?
> > 
> > (Do we know which callsite in XFS is adding zero-ref pages to a BIO, btw?)
> 
> For example all log I/O is done from kmalloce pages.
> 
> Anyway, to rehash what I've been trying to get clarified for ages:
> 
> 
>  (1) should we allow to pass slab pages into bios
> 
> and
> 
>  (2) if yes what's the way lower layers are supposed to handle them
>      for any possible refcounting operations like networking or rdma.
> 
> There's also a pontial caller in ext3 that can send down kmalloc'ed
> buffers: journal_write_metadata_buffer() in need_copy_out && !done_copy_out
> case.  But apparently that's an almost dead code path as I've never
> seen anyone tripping this one, it's always XFS that people report.

OK.  Let's go through it.

Networking internally maintains caller memory lifetimes, and it assumes
that the caller allocated memory via __alloc_pages() - because it uses
get_page() and put_page().

BIO, however, does not internally manage caller memory lifetime.  This is
because the caller's ->bi_end_io is always called, so the caller can do it.

So where we've come unstuck is in a module which has gone and fed BIO
memory into networking.  The differing design philosophies are clashing.

I'm surprised this doesn't happen in other places - aren't there any other
drivers which take a BIO and stuff it down the network?

Anyway, where's the bug?

Really, I'd say it's XFS (and ext3).  Even though BIO doesn't presently
manage page lifetimes, it _could_.  After all, the function is called
bio_add_page(), not bio_add_virtual_address().  It's a bit hacky to kmalloc
some memory, run virt_to_page() and to then present that page to BIO even
though the caller (thanks to the slab optimisation) doesn't actually have
control of that page's lifetime.

So we have a few options to look at:

a) kludge things in AOE.  Unpleasing, and might cause memory leaks
   (although it won't, because the caller hasn't run bi_end_io yet).

b) Take a ref on slab pages in slab.  A bit costly, perhaps.

c) teach ext3 and XFS to take a ref on these pages as they are added to
   the BIOs, undo that ref in bi_end_io.

I think c)?

