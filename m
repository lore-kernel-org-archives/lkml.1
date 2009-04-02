Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZDBOga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZDBOga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbZDBOgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:36:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43916 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbZDBOgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:36:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030055.26668.nickpiggin@yahoo.com.au>
References: <200904030055.26668.nickpiggin@yahoo.com.au> <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230352.28177.65878.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Thu, 02 Apr 2009 15:36:12 +0100
Message-ID: <5198.1238682972@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> 1) PG_mappedtodisk is basically PG_owner_priv_2. Please alias that and
> use it? Then at least we're down to 1 extra flag.
> 2) Why do you need another PG_private?  PG_private for pagecache means
> that it should call into the filesystem when it needs to handle fs data
> attached to the page, right? So PG_private_2 doesn't really make sense
> in that respect.

Won't that either break fs/buffer.c and fs/mpage.c or preclude the use of
FS-Cache with block-based filesystems that use the standard buffer wangling
routines?

As I've previously stated, I want to be able to make ISO9660 use FS-Cache.
That rules out use of PG_mappedtodisk and PG_private for anything FS-Cache
related.

We can actually reclaim PG_private, I think.  There are patches to do that.
At the very least, we can probably reclaim the std buffering code's use of it.

If anything, avoiding the need for PG_fscache_write is probably easier - just
more memory intensive and slower.  I could build a second radix tree for each
inode that kept track of which pages from that inode FS-Cache knows about, and
use the status bits in that node to keep track of what pages are being written
out to the cache.

We still need a way of triggering the page invalidation callbacks for in-use
pages, however.  PG_private, as I've said, is not currently a viable option.

David
