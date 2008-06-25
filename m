Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYFYNy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYFYNy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYFYNyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:54:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48261 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYFYNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:54:16 -0400
To: jens.axboe@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: generic_file_splice_read() issues
Message-Id: <E1KBVRu-0005y4-1i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Jun 2008 15:54:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| 	error = 0;
| 	while (spd.nr_pages < nr_pages) {
| 		/*
| 		 * Page could be there, find_get_pages_contig() breaks on
| 		 * the first hole.
| 		 */
| 		page = find_get_page(mapping, index);
| 		if (!page) {
| 			/*
| 			 * page didn't exist, allocate one.
| 			 */
| 			page = page_cache_alloc_cold(mapping);
| 			if (!page)

error = -ENOMEM?

| 				break;
| 
| 			error = add_to_page_cache_lru(page, mapping, index,
| 						mapping_gfp_mask(mapping));
| 			if (unlikely(error)) {
| 				page_cache_release(page);
| 				if (error == -EEXIST)

error = 0?  It may not matter, but leaving error as EEXIST is
confusing at best (and coupled with the above missing ENOMEM could
result in really weird errors for splice() ;).

| 					continue;
| 				break;
| 			}
| 			/*
| 			 * add_to_page_cache() locks the page, unlock it
| 			 * to avoid convoluting the logic below even more.
| 			 */
| 			unlock_page(page);
| 		}
| 
| 		pages[spd.nr_pages++] = page;
| 		index++;
| 	}

...

| 
| 			/*
| 			 * need to read in the page
| 			 */
| 			error = mapping->a_ops->readpage(in, page);
| 			if (unlikely(error)) {
| 				/*
| 				 * We really should re-lookup the page here,
| 				 * but it complicates things a lot. Instead
| 				 * lets just do what we already stored, and
| 				 * we'll get it the next time we are called.
| 				 */
| 				if (error == AOP_TRUNCATED_PAGE)
| 					error = 0;

This may also cause similar issues as the invalidatation race.  I'd
think it would be better not to be sloppy here.

| 
| 				break;
| 			}
| 		}
| fill_it:

Miklos
