Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbZE0EGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbZE0EGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZE0EGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:06:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55677 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZE0EGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:06:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
In-Reply-To: <20090527035505.GA16916@localhost>
References: <20090526193601.b825af5f.akpm@linux-foundation.org> <20090527035505.GA16916@localhost>
Message-Id: <20090527130358.689C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 27 May 2009 13:06:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ah.  So it's likely to be some strange interaction with the RAID setup.
> 
> The normal case is, if page N become uptodate at time T(N), then
> T(N) <= T(N+1) holds. But for RAID, the data arrival time depends on
> runtime status of individual disks, which breaks that formula. So
> in do_generic_file_read(), just after submitting the async readahead IO
> request, the current page may well be uptodate, so the page won't be locked,
> and the block device won't be implicitly unplugged:

Hifumi-san, Can you get blktrace data and confirm Wu's assumption?


> 
>                if (PageReadahead(page))
>                         page_cache_async_readahead()
>                 if (!PageUptodate(page))
>                                 goto page_not_up_to_date;
>                 //...
> page_not_up_to_date:
>                 lock_page_killable(page);
> 
> 
> Therefore explicit unplugging can help, so
> 
>         Acked-by: Wu Fengguang <fengguang.wu@intel.com> 
> 
> The only question is, shall we avoid the double unplug by doing this?
> 
> ---
>  mm/readahead.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- linux.orig/mm/readahead.c
> +++ linux/mm/readahead.c
> @@ -490,5 +490,15 @@ page_cache_async_readahead(struct addres
>  
>  	/* do read-ahead */
>  	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
> +
> +	/*
> +	 * Normally the current page is !uptodate and lock_page() will be
> +	 * immediately called to implicitly unplug the device. However this
> +	 * is not always true for RAID conifgurations, where data arrives
> +	 * not strictly in their submission order. In this case we need to
> +	 * explicitly kick off the IO.
> +	 */
> +	if (PageUptodate(page))
> +		blk_run_backing_dev(mapping->backing_dev_info, NULL);
>  }
>  EXPORT_SYMBOL_GPL(page_cache_async_readahead);



