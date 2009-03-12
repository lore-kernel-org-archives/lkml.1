Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZCLAMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZCLAMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZCLALy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:11:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbZCLALx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:11:53 -0400
Date: Wed, 11 Mar 2009 17:08:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, Enrik.Berkhan@ge.com,
       dhowells@redhat.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may
 get wrongly discarded
Message-Id: <20090311170840.2f136849.akpm@linux-foundation.org>
In-Reply-To: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 15:30:35 +0000
David Howells <dhowells@redhat.com> wrote:

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

Was there a specific reason for using the low-level SetPageDirty()?

On the write() path, ramfs pages will be dirtied by
simple_commit_write()'s set_page_dirty(), which calls
__set_page_dirty_no_writeback().

It just so happens that __set_page_dirty_no_writeback() is equivalent
to a simple SetPageDirty() - it bypasses all the extra things which we
do for normal permanent-storage-backed pages.

But I'd have thought that it would be cleaner and more maintainable (albeit
a bit slower) to go through the a_ops?

