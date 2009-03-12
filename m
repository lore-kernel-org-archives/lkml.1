Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZCLTrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZCLTrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZCLTrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:47:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbZCLTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:47:11 -0400
Date: Thu, 12 Mar 2009 12:43:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may
 get wrongly discarded
Message-Id: <20090312124323.ad0dbd68.akpm@linux-foundation.org>
In-Reply-To: <24030.1236860724@redhat.com>
References: <20090311170840.2f136849.akpm@linux-foundation.org>
	<20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
	<24030.1236860724@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 12:25:24 +0000
David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Was there a specific reason for using the low-level SetPageDirty()?
> > 
> > On the write() path, ramfs pages will be dirtied by
> > simple_commit_write()'s set_page_dirty(), which calls
> > __set_page_dirty_no_writeback().
> >
> > It just so happens that __set_page_dirty_no_writeback() is equivalent
> > to a simple SetPageDirty() - it bypasses all the extra things which we
> > do for normal permanent-storage-backed pages.
> > 
> > But I'd have thought that it would be cleaner and more maintainable (albeit
> > a bit slower) to go through the a_ops?
> 
> It basically boils down to SetPageDirty() with extra overhead, which you
> pointed out.  We're manually manipulating the pagecache for this inode anyway,
> so does it matter?

Not much.  It just seems a bit more consistent.

> The main thing I think I'd rather get rid of is:
> 
> 		if (!pagevec_add(&lru_pvec, page))
> 			__pagevec_lru_add_file(&lru_pvec);
> 	...
> 	pagevec_lru_add_file(&lru_pvec);
> 
> Which as Peter points out:
> 
> 	The ramfs stuff is rather icky in that it adds the pages to the aging
> 	list, marks them dirty, but does not provide a writeout method. 
> 
> 	This will make the paging code scan over them (continuously) trying to
> 	clean them, failing that (lack of writeout method) and putting them back
> 	on the list.
> 
> Not requiring the pages to be added to the LRU would be a really good idea.
> They are not discardable, be it in MMU or NOMMU mode, except when the inode
> itself is discarded.

Yep, these pages shouldn't be on the LRU at all.  I guess that will
require some tweaks to core filemap.c code.

> Furthermore, does it really make sense for ramfs to use do_sync_read/write()
> and generic_file_aio_read/write(), at least for NOMMU-mode?  These add a lot
> of overhead, and ramfs doesn't really do either direct I/O or AIO.
> 
> The main point in favour of using these routines is commonality; but they do
> add a lot of layers of overhead.

Yes, that code is very general hence always has overhead for each
specific client.

>  Does ramfs read/write performance matter
> than much, I wonder.

I doubt it.
