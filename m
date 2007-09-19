Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbXISWQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbXISWQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXISWQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:16:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbXISWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:16:00 -0400
Date: Wed, 19 Sep 2007 15:15:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [05/17] vunmap: return page array
In-Reply-To: <20070919170559.a0552679.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0709191510470.3402@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.468440734@sgi.com>
 <20070919170559.a0552679.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, KAMEZAWA Hiroyuki wrote:

> Hmm, I don't like returning array which someone allocated in past and forgot.

But that is exactly the point. There is no need to keep track of the 
information that is of no interest until the disposition of the mapping.

> And, area->page[] array under vmalloc() is allocated as following (in -rc6-mm1)
> ==
>        if (array_size > PAGE_SIZE) {
>                 pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
>                                         PAGE_KERNEL, node);
>                 area->flags |= VM_VPAGES;
>         } else {
>                 pages = kmalloc_node(array_size,
>                                 (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
>                                 node);
>         }
> ==
> A bit complicating.

Not at all. You can pass a __vmalloc'ed entity to vmap if you add VM_VPAGES 
to the flags passed to it.

> At least, please add comments "How to free page-array returned by vummap"

But that depends on how the vmap was called. The caller knows what he has 
done to acquire the memory and therefore also knows how to get rid of it.
 
The knowledge of how to displose of things is only important when we use
vfree() to free up a vmap() (we never do that today) and expect the page 
array to go with it.

In that case the user needs to specific VM_VPAGES if the page array was 
vmalloced.

I can add a comment explaining that?

