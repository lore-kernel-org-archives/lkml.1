Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbYHLChL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbYHLChL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 22:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYHLCg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 22:36:59 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:32305 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751860AbYHLCg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 22:36:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4G9og85YWSboAvHcV9wvYBSZ6WjQiqeStIWzIs3fJEun2TSwR0JSkNrgneOiY25tevsedtFpxxlBH/4BkZNp8wJ+MaRxR81YgtJT9/rGGrdEjHad444AZjfC9REXdsvCJnZVUuQD6z4TIhl/id+d2R45UTjdRqbLZ92IorNBACg=  ;
X-YMail-OSG: ZQX291IVM1l1GH5jngreDugaWJgEhh01o2duEFn9d0JIQqjQmjVFSDDkgAJo1XPO3eJy.mZhphJ_mPUbdFxXME7SihRrQfPAULERuvt.seIkXQXE7s.Fc4pdllEXO4X1fsk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ryan Hope <rmh3093@gmail.com>
Subject: Re: [PATCH 3/3][reiser4] dont get radix-tree dirty tagging out of sync
Date: Tue, 12 Aug 2008 12:36:51 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Reiserfs mailing list <reiserfs-devel@vger.kernel.org>
References: <48A0BFC9.40502@gmail.com>
In-Reply-To: <48A0BFC9.40502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121236.51599.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 08:40, Ryan Hope wrote:
> This was item #14 on the todo list for reiser4 inclusion in mainline:
>
> diff --git a/fs/reiser4/page_cache.c b/fs/reiser4/page_cache.c
> index fe71368..a662c25 100644
> --- a/fs/reiser4/page_cache.c
> +++ b/fs/reiser4/page_cache.c
> @@ -467,15 +467,14 @@ int reiser4_set_page_dirty_internal(struct page
> *page) BUG_ON(mapping == NULL);
>
>   	if (!TestSetPageDirty(page)) {
> +		spin_lock_irq(&mapping->tree_lock);
>   		if (mapping_cap_account_dirty(mapping))
>   			inc_zone_page_state(page, NR_FILE_DIRTY);
> -
> +		radix_tree_tag_set(&mapping->page_tree,
> +			page_index(page), PAGECACHE_TAG_DIRTY);
>   		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +		spin_unlock_irq(&mapping->tree_lock);
>   	}
> -
> -	/* znode must be dirty ? */
> -	if (mapping->host == reiser4_get_super_fake(mapping->host->i_sb))
> -		assert("", JF_ISSET(jprivate(page), JNODE_DIRTY));
>   	return 0;
>   }

Any reason why this can't use a generic function such as
__set_page_dirty_nobuffers? There are accounting changes gone in
there now which I suspetc may be wrong now in reiser4 (eg. task
io accounting).

Actually every site that does a radix_tree_operation there should
be reviewed to try to use core functoins.
