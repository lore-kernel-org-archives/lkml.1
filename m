Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZCKR1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZCKR1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZCKR1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:27:34 -0400
Received: from cmpxchg.org ([85.214.51.133]:48617 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZCKR1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:27:34 -0400
Date: Wed, 11 Mar 2009 18:26:00 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Message-ID: <20090311172600.GA1580@cmpxchg.org>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:30:35PM +0000, David Howells wrote:
> From: Enrik Berkhan <Enrik.Berkhan@ge.com>
> 
> The pages attached to a ramfs inode's pagecache by truncation from nothing - as
> done by SYSV SHM for example - may get discarded under memory pressure.
> 
> The problem is that the pages are not marked dirty.  Anything that creates data
> in an MMU-based ramfs will cause the pages holding that data will cause the
> set_page_dirty() aop to be called.
> 
> For the NOMMU-based mmap, set_page_dirty() may be called by write(), but it
> won't be called by page-writing faults on writable mmaps, and it isn't called
> by ramfs_nommu_expand_for_mapping() when a file is being truncated from nothing
> to allocate a contiguous run.
> 
> The solution is to mark the pages dirty at the point of allocation by
> the truncation code.
> 
> Signed-off-by: Enrik Berkhan <Enrik.Berkhan@ge.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/ramfs/file-nommu.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
> index b9b567a..90d72be 100644
> --- a/fs/ramfs/file-nommu.c
> +++ b/fs/ramfs/file-nommu.c
> @@ -114,6 +114,9 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
>  		if (!pagevec_add(&lru_pvec, page))
>  			__pagevec_lru_add_file(&lru_pvec);
>  
> +		/* prevent the page from being discarded on memory pressure */
> +		SetPageDirty(page);
> +
>  		unlock_page(page);
>  	}

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

I think the attached patch is also needed, though unrelated to the
above.

	Hannes

---
>From bfa7bc5f884bbc01c5e10faba7ca17160befd61e Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 11 Mar 2009 18:13:34 +0100
Subject: [PATCH] ramfs: don't leak pages when adding to page cache fails

When a ramfs nommu mapping is expanded, contiguous pages are allocated
and added to the pagecache.  The caller's reference is then passed on
by moving whole pagevecs to the file lru list.

If the page cache adding fails, make sure that the error path also
moves the pagevec contents which might still contain up to
PAGEVEC_SIZE successfully added pages, of which we would leak
references otherwise.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 fs/ramfs/file-nommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index b9b567a..6d1624e 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -126,6 +126,7 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 	return -EFBIG;
 
  add_error:
+	pagevec_lru_add_file(&lru_pvec);
 	page_cache_release(pages + loop);
 	for (loop++; loop < npages; loop++)
 		__free_page(pages + loop);
-- 
1.6.1.3

