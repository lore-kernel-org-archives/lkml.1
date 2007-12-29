Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbXL2CVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbXL2CVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbXL2CVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:21:10 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37830 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753633AbXL2CVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:21:08 -0500
Message-ID: <398894876.20324@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 29 Dec 2007 10:21:04 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
References: <E1J8AC5-0002BE-RP@localhost> <1198841626.6821.92.camel@twins> <1198859101.13075.10.camel@norville.austin.ibm.com> <1198860794.13075.15.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198860794.13075.15.camel@norville.austin.ibm.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J8RJw-0001ge-DP@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 10:53:14AM -0600, Dave Kleikamp wrote:


> ---
> 
> diff -Nurp linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c linux/fs/jfs/jfs_metapage.c
> --- linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c	2007-12-28 10:28:33.000000000 -0600
> +++ linux/fs/jfs/jfs_metapage.c	2007-12-28 10:37:30.000000000 -0600
> @@ -360,6 +360,7 @@ static int metapage_writepage(struct pag
>  	struct metapage *mp;
>  	int redirty = 0;
>  	sector_t lblock;
> +	int nr_underway = 0;
>  	sector_t pblock;
>  	sector_t next_block = 0;
>  	sector_t page_start;
> @@ -371,6 +372,7 @@ static int metapage_writepage(struct pag
>  		     (PAGE_CACHE_SHIFT - inode->i_blkbits);
>  	BUG_ON(!PageLocked(page));
>  	BUG_ON(PageWriteback(page));

This line should be moved below:
> +	set_page_writeback(page);

>  
>  	for (offset = 0; offset < PAGE_CACHE_SIZE; offset += PSIZE) {
>  		mp = page_to_mp(page, offset);
> @@ -413,11 +415,10 @@ static int metapage_writepage(struct pag
>  			if (!bio->bi_size)
>  				goto dump_bio;
>  			submit_bio(WRITE, bio);
> +			nr_underway++;
>  			bio = NULL;
> -		} else {
> -			set_page_writeback(page);
> +		} else
>  			inc_io(page);
> -		}
>  		xlen = (PAGE_CACHE_SIZE - offset) >> inode->i_blkbits;
>  		pblock = metapage_get_blocks(inode, lblock, &xlen);
>  		if (!pblock) {
> @@ -449,12 +450,16 @@ static int metapage_writepage(struct pag
>  			goto dump_bio;
>  
>  		submit_bio(WRITE, bio);
> +		nr_underway++;
>  	}
>  	if (redirty)
>  		redirty_page_for_writepage(wbc, page);
+       else
+               set_page_writeback(page);
>  
>  	unlock_page(page);
>  
> +	if (nr_underway == 0)
  +     if (nr_underway == 0 && redirty == 0)

> +		end_page_writeback(page);
> +
>  	return 0;
>  add_failed:
>  	/* We should never reach here, since we're only adding one vec */

Otherwise looks pretty good.

Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

