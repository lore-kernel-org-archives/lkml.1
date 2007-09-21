Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXIULso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXIULso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbXIULsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:48:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38019 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbXIULsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:48:36 -0400
Date: Fri, 21 Sep 2007 13:48:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       ricknu-0@student.ltu.se,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] page->mapping clarification [1/3] base functions
Message-ID: <20070921134828.45ca967e@twins>
In-Reply-To: <20070919164308.281f9960.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070919164308.281f9960.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 16:43:08 +0900 KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:

> A clarification of page <-> fs interface (page cache).
> 
> At first, each FS has to access to struct page->mapping directly.
> But it's not just pointer. (we use special 1bit enconding for anon.)
> 
> Although there is historical consensus that page->mapping points to its inode's
> address space, I think adding some neat helper functon is not bad.
> 
> This patch adds page-cache.h which containes page<->address_space<->inode
> function which is required (used) by subsystems.
> 
> Following functions are added
> 
>  * page_mapping_cache() ... returns address space if a page is page cache
>  * page_mapping_anon()  ... returns anon_vma if a page is anonymous page.
>  * page_is_pagecache()  ... returns true if a page is page-cache.
>  * page_inode()         ... returns inode which a page-cache belongs to.
>  * is_page_consistent() ... returns true if a page is still valid page cache 
> 
> Followings are moved 
>  * page_mapping()       ... returns swapper_space or address_space a page is on.
> 			    (from mm.h)
>  * page_index()         ... returns position of a page in its inode
> 			    (from mm.h)
>  * remove_mapping()     ... a safe routine to remove page->mapping from page.
> 			    (from swap.h)

I have two other functions that might want integration with this scheme:

  page_file_mapping()     ... returns backing address space
  page_file_index()       ... returns the index therein

They are identical to page_mapping_cache() and page_index() for
page cache pages, but they also work on swap cache pages.

That is, for swapcache pages they return:

page_file_mapping:
  page_swap_info(page)->swap_file->f_mapping

page_file_index:
  swp_offset((swp_offset_t)page_private(page))

When a filesystem uses these functions instead of page->mapping and
page->index, it allows passing swap cache pages into the regular
filesystem read/write paths.

This is useful for things like swap over NFS, where swap is backed by a
swapfile on a 'regular' filesystem.

