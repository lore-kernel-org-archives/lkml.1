Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZD0Flo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZD0Flo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZD0Flf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:41:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbZD0Flf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:41:35 -0400
Date: Sun, 26 Apr 2009 22:37:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Fix race between callers of read_cache_page_async and
 invalidate_inode_pages.
Message-Id: <20090426223744.72edc7f4.akpm@linux-foundation.org>
In-Reply-To: <18933.16534.862316.787808@notabene.brown>
References: <18933.16534.862316.787808@notabene.brown>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 15:20:22 +1000 Neil Brown <neilb@suse.de> wrote:

> 
> 
> 
> Callers of read_cache_page_async typically wait for the page to become
> unlocked (wait_on_page_locked) and then test PageUptodate to see if
> the read was successful, or if there was an error.
> 
> This is wrong.
> 
> invalidate_inode_pages can cause an unlocked page to lose its
> PageUptodate flag at any time without implying a read error.

ow.

> As any read error will cause PageError to be set, it is much safer,
> and more idiomatic to test "PageError" than to test "!PageUptodate".
> 
> ...
>
> diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> index dd3634e..573d582 100644
> --- a/fs/cramfs/inode.c
> +++ b/fs/cramfs/inode.c
> @@ -180,7 +180,7 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
>  		struct page *page = pages[i];
>  		if (page) {
>  			wait_on_page_locked(page);
> -			if (!PageUptodate(page)) {
> +			if (PageError(page)) {
>  				/* asynchronous error */
>  				page_cache_release(page);
>  				pages[i] = NULL;
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 379ff0b..9ff8093 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1770,7 +1770,7 @@ struct page *read_cache_page(struct address_space *mapping,
>  	if (IS_ERR(page))
>  		goto out;
>  	wait_on_page_locked(page);
> -	if (!PageUptodate(page)) {
> +	if (!PageError(page)) {
>  		page_cache_release(page);
>  		page = ERR_PTR(-EIO);
>  	}

hrm.  And where is it written that PageError() will remain inviolable
after it has been set?

A safer and more formal (albeit somewhat slower) fix would be to lock
the page and check its state under the lock.

y:/usr/src/linux-2.6.30-rc3> grep -r ClearPageError . | wc -l
21

?
