Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYFYOLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYFYOLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYFYOK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:10:57 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6638 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYFYOK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:10:57 -0400
Date: Wed, 25 Jun 2008 16:10:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: generic_file_splice_read() issues
Message-ID: <20080625141054.GB20851@kernel.dk>
References: <E1KBVRu-0005y4-1i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KBVRu-0005y4-1i@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25 2008, Miklos Szeredi wrote:
> | 	error = 0;
> | 	while (spd.nr_pages < nr_pages) {
> | 		/*
> | 		 * Page could be there, find_get_pages_contig() breaks on
> | 		 * the first hole.
> | 		 */
> | 		page = find_get_page(mapping, index);
> | 		if (!page) {
> | 			/*
> | 			 * page didn't exist, allocate one.
> | 			 */
> | 			page = page_cache_alloc_cold(mapping);
> | 			if (!page)
> 
> error = -ENOMEM?

Looks like it, indeed.

> | 				break;
> | 
> | 			error = add_to_page_cache_lru(page, mapping, index,
> | 						mapping_gfp_mask(mapping));
> | 			if (unlikely(error)) {
> | 				page_cache_release(page);
> | 				if (error == -EEXIST)
> 
> error = 0?  It may not matter, but leaving error as EEXIST is
> confusing at best (and coupled with the above missing ENOMEM could
> result in really weird errors for splice() ;).

Lets move the error assignment inside that loop, ala

-       error = 0;
        while (spd.nr_pages < nr_pages) {
+               error = 0;

But yes, that also looks like a bug. Good spotting!

> | 
> | 			/*
> | 			 * need to read in the page
> | 			 */
> | 			error = mapping->a_ops->readpage(in, page);
> | 			if (unlikely(error)) {
> | 				/*
> | 				 * We really should re-lookup the page here,
> | 				 * but it complicates things a lot. Instead
> | 				 * lets just do what we already stored, and
> | 				 * we'll get it the next time we are called.
> | 				 */
> | 				if (error == AOP_TRUNCATED_PAGE)
> | 					error = 0;
> 
> This may also cause similar issues as the invalidatation race.  I'd
> think it would be better not to be sloppy here.

Perhaps we can abstract that bit out into a small helper function, tied
in with your previous patch.

-- 
Jens Axboe

