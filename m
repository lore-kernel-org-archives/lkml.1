Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZCKWh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZCKWh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZCKWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:37:42 -0400
Received: from cmpxchg.org ([85.214.51.133]:36891 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbZCKWhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:37:39 -0400
Date: Wed, 11 Mar 2009 23:36:15 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       peterz@infradead.org, Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Message-ID: <20090311223615.GA3284@cmpxchg.org>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk> <20090311150302.0ae76cf1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311150302.0ae76cf1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:03:02PM -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2009 15:30:35 +0000
> David Howells <dhowells@redhat.com> wrote:
> 
> > From: Enrik Berkhan <Enrik.Berkhan@ge.com>
> > 
> > The pages attached to a ramfs inode's pagecache by truncation from nothing - as
> > done by SYSV SHM for example - may get discarded under memory pressure.
> 
> Something has gone wrong in core VM.
> 
> > The problem is that the pages are not marked dirty.  Anything that creates data
> > in an MMU-based ramfs will cause the pages holding that data will cause the
> > set_page_dirty() aop to be called.
> > 
> > For the NOMMU-based mmap, set_page_dirty() may be called by write(), but it
> > won't be called by page-writing faults on writable mmaps, and it isn't called
> > by ramfs_nommu_expand_for_mapping() when a file is being truncated from nothing
> > to allocate a contiguous run.
> > 
> > The solution is to mark the pages dirty at the point of allocation by
> > the truncation code.
> 
> Page reclaim shouldn't be even attempting to reclaim or write back
> ramfs pagecache pages - reclaim can't possibly do anything with these
> pages!
> 
> Arguably those pages shouldn't be on the LRU at all, but we haven't
> done that yet.
> 
> Now, my problem is that I can't 100% be sure that we _ever_ implemented
> this properly.  I _think_ we did, in which case we later broke it.  If
> we've always been (stupidly) trying to pageout these pages then OK, I
> guess your patch is a suitable 2.6.29 stopgap.
> 
> If, however, we broke it then we've probably broken other filesystems
> and we should fix the regression instead.
> 
> Running bdi_cap_writeback_dirty() in may_write_to_queue() might be the
> way to fix all this.

The pages are not dirty, so no pageout() which says PAGE_KEEP.  It
will just go through and reclaim the clean, unmapped pages.
