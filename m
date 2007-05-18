Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbXERJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbXERJXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXERJXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:23:09 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:51491 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXERJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:23:08 -0400
Date: Fri, 18 May 2007 10:23:05 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] Mark page cache pages as __GFP_PAGECACHE instead of
 __GFP_MOVABLE
In-Reply-To: <20070517123854.6cea6338.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705181012090.17783@skynet.skynet.ie>
References: <20070517101022.3113.15456.sendpatchset@skynet.skynet.ie>
 <20070517101203.3113.81852.sendpatchset@skynet.skynet.ie>
 <20070517123854.6cea6338.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Andrew Morton wrote:

> On Thu, 17 May 2007 11:12:03 +0100 (IST)
> Mel Gorman <mel@csn.ul.ie> wrote:
>
>> --- linux-2.6.22-rc1-mm1-025_gfphighuser/fs/buffer.c	2007-05-16 22:55:50.000000000 +0100
>> +++ linux-2.6.22-rc1-mm1-030_pagecache_mark/fs/buffer.c	2007-05-16 23:07:30.000000000 +0100
>> @@ -1009,7 +1009,7 @@ grow_dev_page(struct block_device *bdev,
>>  	struct buffer_head *bh;
>>
>>  	page = find_or_create_page(inode->i_mapping, index,
>> -					GFP_NOFS|__GFP_RECLAIMABLE);
>> +					GFP_NOFS_PAGECACHE);
>>  	if (!page)
>>  		return NULL;
>>
>
> I ended up with
>
>        page = find_or_create_page(inode->i_mapping, index,
>                (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
>
> here.
>

That looks like it'll work fine with respects to grouping by mobility but 
there is a slight functional difference worth noting. Specifically, the 
old code did not obey cpuset limits because __GFP_HARDWALL was not set. 
This change gets it's GFP mask from bdget() calling mapping_set_gfp_mask() 
which is GFP_USER and so will obey CPUSET limits. This new version looks 
more correct.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
