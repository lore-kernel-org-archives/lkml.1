Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZDBPve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZDBPve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZDBPvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:51:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41708 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZDBPvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:51:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030225.16372.nickpiggin@yahoo.com.au>
References: <200904030225.16372.nickpiggin@yahoo.com.au> <200904030055.26668.nickpiggin@yahoo.com.au> <20090401230352.28177.65878.stgit@warthog.procyon.org.uk> <5198.1238682972@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Thu, 02 Apr 2009 16:51:02 +0100
Message-ID: <6362.1238687462@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Haven't looked closely at how fscache works.

It's fairly simple.  FS-Cache sets PG_private_2 (PageFsCache) on pages that the
netfs tells it about, if it retains an interest in the page.  This causes
invalidatepage() and suchlike to be invoked on that page when the page is
discarded.

The netfs can check for the page being in use by calling PageFsCache() and then
uncache the page if it is in use:

	#ifdef CONFIG_AFS_FSCACHE
		if (PageFsCache(page)) {
			struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
			wait_on_page_fscache_write(page);
			fscache_uncache_page(vnode->cache, page);
		}
	#endif

which clears the bit.

Furthermore, when FS-Cache is asked to store a page to the cache, it
immediately marks it with PG_owner_priv_2 (PageFsCacheWrite).  This is cleared
when FS-Cache no longer needs the data in the page for writing to the cache.

This allows (1) invalidatepage() to wait until the page is written before it is
returned to the memory allocator, and (2) releasepage() to indicate that the
page is busy if __GFP_WAIT is not given.

> Possibly you can't reuse mappedtodisk....

PG_mappedtodisk has a very specific meaning to fs/buffer.c and fs/mpage.c.  I
can't also easily make it mean that a page is backed by the cache.  A page can
be cached and not mapped to disk.

> > We still need a way of triggering the page invalidation callbacks for in-use
> > pages, however.  PG_private, as I've said, is not currently a viable option.
> 
> Can you say exactly why not?

fs/buffer.c owns PG_private in filesystems that use standard buffering.  It
sets it, clears it and tests it at its own behest without recourse to the
filesystem using it.

ISO9660 uses fs/buffer.c.

I want to get ISO9660 to use FS-Cache.

Also NFS uses PG_private for its own nefarious purposes.  Making PG_private be
the conjunction of both purposes entailed some fairly messy patching.

David
