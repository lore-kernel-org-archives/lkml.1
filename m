Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbZFKD0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbZFKD0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbZFKD0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:26:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40256 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZFKD0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:26:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/4] Properly account for the number of page cache pages zone_reclaim() can reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090610115944.GB5657@localhost>
References: <20090610103152.GG25943@csn.ul.ie> <20090610115944.GB5657@localhost>
Message-Id: <20090611122206.591B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 12:26:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We are not talking about NR_TMPFS_PAGES, but NR_TMPFS_MAPPED :)
> 
> We only need to account it in page_add_file_rmap() and page_remove_rmap(),
> I don't think they are too hot paths. And the relative cost is low enough.
> 
> It will look like this.
> 
> ---
>  include/linux/mmzone.h |    1 +
>  mm/rmap.c              |    4 ++++
>  2 files changed, 5 insertions(+)
> 
> --- linux.orig/include/linux/mmzone.h
> +++ linux/include/linux/mmzone.h
> @@ -99,6 +99,7 @@ enum zone_stat_item {
>  	NR_VMSCAN_WRITE,
>  	/* Second 128 byte cacheline */
>  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
> +	NR_TMPFS_MAPPED,
>  #ifdef CONFIG_NUMA
>  	NUMA_HIT,		/* allocated in intended node */
>  	NUMA_MISS,		/* allocated in non intended node */
> --- linux.orig/mm/rmap.c
> +++ linux/mm/rmap.c
> @@ -844,6 +844,8 @@ void page_add_file_rmap(struct page *pag
>  {
>  	if (atomic_inc_and_test(&page->_mapcount)) {
>  		__inc_zone_page_state(page, NR_FILE_MAPPED);
> +		if (PageSwapBacked(page))
> +			__inc_zone_page_state(page, NR_TMPFS_MAPPED);
>  		mem_cgroup_update_mapped_file_stat(page, 1);
>  	}
>  }
> @@ -894,6 +896,8 @@ void page_remove_rmap(struct page *page)
>  			mem_cgroup_uncharge_page(page);
>  		__dec_zone_page_state(page,
>  			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
> +		if (!PageAnon(page) && PageSwapBacked(page))
> +			__dec_zone_page_state(page, NR_TMPFS_MAPPED);
>  		mem_cgroup_update_mapped_file_stat(page, -1);
>  		/*
>  		 * It would be tidy to reset the PageAnon mapping here,

I think this patch looks good. thanks :)

but I have one request. 
Could you please rename NR_FILE_MAPPED to NR_SWAP_BACKED_FILE_MAPPED?

I mean, mm/shmem isn't only used for tmpfs, but also be used ipc/shm and
/dev/zero.
NR_TMPFS_MAPPED seems a bit misleading.



