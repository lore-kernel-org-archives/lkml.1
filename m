Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbXL1LeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbXL1LeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 06:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXL1LeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 06:34:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47600 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXL1Ld7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 06:33:59 -0500
Subject: Re: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shaggy@austin.ibm.com, jfs-discussion@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <E1J8AC5-0002BE-RP@localhost>
References: <E1J8AC5-0002BE-RP@localhost>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 12:33:46 +0100
Message-Id: <1198841626.6821.92.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-28 at 16:03 +0800, Fengguang Wu wrote:
> Andrew,
> 
> This patch fixed the 'pdflush stuck in D state' bug
>         http://bugzilla.kernel.org/show_bug.cgi?id=9291
> and should be pushed to mainline ASAP.
> ---
> 
> When JFS decides to drop a dirty metapage, it simply clears the META_dirty bit
> and leave alone the PG_dirty and PAGECACHE_TAG_DIRTY bits.
> 
> When such no-write page goes to metapage_writepage(), the `relic'
> PAGECACHE_TAG_DIRTY tag should be cleared, to prevent pdflush from
> repeatedly trying to sync them.
> 
> Also, avoid the redirty when a bio submission is planned.
> 
> Tested-by: Markus Rehbach <Markus.Rehbach@gmx.de>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 
> ---

> +++ b/fs/jfs/jfs_metapage.c

> @@ -449,9 +450,15 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
>  			goto dump_bio;
>  
>  		submit_bio(WRITE, bio);
> -	}
> -	if (redirty)
> +	} else if (redirty) {
>  		redirty_page_for_writepage(wbc, page);
> +	} else {
> +		write_lock_irq(&mapping->tree_lock);
> +		radix_tree_tag_clear(&mapping->page_tree,
> +				page_index(page),
> +				PAGECACHE_TAG_DIRTY);
> +		write_unlock_irq(&mapping->tree_lock);
> +	}

I'm not liking this open-coded tag_clear, although I currently fail to
come up with a nice solution.

