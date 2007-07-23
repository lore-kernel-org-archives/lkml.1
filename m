Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbXGWH6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbXGWH6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbXGWH6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:58:09 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32420 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755380AbXGWH6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:58:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=tqE/x44VkujQQ/rfC/xBSxsRELvQjVvIcyccCLbMRAue3Efh6hFlLswU6mQXTs3tl4lIF1Ij0YQwZwH3U1hHawZD+PGAq/+nRnqOrIoZTDAeRWGv4Vs6v2koOmNE7bOzAMNY5qszrMleokzqNvtIkNRPckAravuw6ugc+nWvaGA=  ;
X-YMail-OSG: b45_wSkVM1nESOSOSOirfGQipsp8EiUCzW6N2uY5dycArqJaJqVtEiL7FduwnieWHN7UqF7g1A--
Message-ID: <46A45F8A.5060600@yahoo.com.au>
Date: Mon, 23 Jul 2007 17:58:02 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] radixtree: introduce radix_tree_scan_hole()
References: <20070721044300.909424569@mail.ustc.edu.cn> <384993020.08966@ustc.edu.cn>
In-Reply-To: <384993020.08966@ustc.edu.cn>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu wrote:
> Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree
> for the first hole. It will be used in interleaved readahead.
> 
> The implementation is dumb and obviously correct.
> It can help debug(and document) the possible smart one in future.

Reasonable function to want. Is radix_tree_scan_hole the best name?
What about radix_tree_next_hole or _find_next_hole? (Andrew, any
suggestions?)

> 
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
> 
>  include/linux/radix-tree.h |    2 ++
>  lib/radix-tree.c           |   34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> --- linux-2.6.22-rc6-mm1.orig/include/linux/radix-tree.h
> +++ linux-2.6.22-rc6-mm1/include/linux/radix-tree.h
> @@ -155,6 +155,8 @@ void *radix_tree_delete(struct radix_tre
>  unsigned int
>  radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
>  			unsigned long first_index, unsigned int max_items);
> +unsigned long radix_tree_scan_hole(struct radix_tree_root *root,
> +				unsigned long index, unsigned long max_scan);
>  int radix_tree_preload(gfp_t gfp_mask);
>  void radix_tree_init(void);
>  void *radix_tree_tag_set(struct radix_tree_root *root,
> --- linux-2.6.22-rc6-mm1.orig/lib/radix-tree.c
> +++ linux-2.6.22-rc6-mm1/lib/radix-tree.c
> @@ -601,6 +601,40 @@ int radix_tree_tag_get(struct radix_tree
>  EXPORT_SYMBOL(radix_tree_tag_get);
>  #endif
>  
> +static unsigned long
> +radix_tree_scan_hole_dumb(struct radix_tree_root *root,
> +				unsigned long index, unsigned long max_scan)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < max_scan; i++) {
> +		if (!radix_tree_lookup(root, index))
> +			break;
> +		if (++index == 0)
> +			break;

Minor nit: I think it is preferred to have index++; on its own line.

> +	}
> +
> +	return index;
> +}
> +
> +/**
> + *	radix_tree_scan_hole    -    scan for hole
> + *	@root:		radix tree root
> + *	@index:		index key
> + *	@max_scan:      advice on max items to scan (it may scan a little more)
> + *
> + *      Scan forward from @index for a hole/empty item, stop when
> + *      - hit hole
> + *      - wrap-around to index 0
> + *      - @max_scan or more items scanned
> + */

Some suggestions on the comment:

/**
  *	radix_tree_next_hole    -    find the next hole (not-present entry)
  *	@root:		radix tree root
  *	@index:		index key
  *	@max_scan:      maximum range to search
  *
  *      Search the set [index,  min(index+max_scan-1, MAX_INDEX)] for the lowest
  *      indexed hole.
  *
  *      Returns: the index of the hole if found, otherwise returns an index
  *      outside of the set specified (in which case 'return - index >= max_scan'
  *      will be true).
  *
  *      radix_tree_next_hole may be called under rcu_read_lock. However, like
  *      radix_tree_gang_lookup, this will not atomically search a snapshot of the
  *      tree at a single point in time. For example, if a hole is created at index
  *      5, then subsequently a hole is created at index 10, radix_tree_next_hole
  *      covering both indexes may return 10 if called under rcu_read_lock.
  */


> +unsigned long radix_tree_scan_hole(struct radix_tree_root *root,
> +				unsigned long index, unsigned long max_scan)
> +{
> +	return radix_tree_scan_hole_dumb(root, index, max_scan);
> +}
> +EXPORT_SYMBOL(radix_tree_scan_hole);

Don't do this scan_hole_dumb thing. Just implement it in place.

-- 
SUSE Labs, Novell Inc.
