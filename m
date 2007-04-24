Return-Path: <linux-kernel-owner+w=401wt.eu-S1161529AbXDXKJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161529AbXDXKJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161532AbXDXKJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:09:32 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:43114 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161529AbXDXKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:09:31 -0400
Date: Tue, 24 Apr 2007 11:09:29 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, tony.luck@intel.com,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
In-Reply-To: <20070424183847.FD98.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0704241100440.1067@skynet.skynet.ie>
References: <20070423183246.GA11841@skynet.ie> <20070423183637.GA11982@skynet.ie>
 <20070424183847.FD98.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Yasunori Goto wrote:

>
>
>> Subject: Check zone boundaries when freeing bootmem
>> Zone boundaries do not have to be aligned to MAX_ORDER_NR_PAGES.
>
> Hmm. I don't understand here yet... Could you explain more?
>

Nodes are required to be MAX_ORDER_NR_PAGES aligned for the buddy 
algorithm to work but zones can be at any alignment because the 
page_is_buddy() check checks the zone_id of two buddies when merging. As 
zones are generally aligned anyway, it was never noticed that the bootmem 
allocators assumes zones are at least order-5 aligned on 32 bit and 
order-6 aligned on 64 bit.

> This issue occurs only when ZONE_MOVABLE is specified.

Yes, because it can be sized to any value. At the moment, zones are 
aligned to MAX_ORDER_NR_PAGES so it was not noticed that bootmem makes 
assumptions on zone alignment.

> If its boundary is aligned to MAX_ORDER automatically,
> I guess user will not mind it.
>

Probably not. They will get a different amount of memory usable by the 
kernel than they asked for but it doesn't really matter. Huge pages 
generally need MAX_ORDER_NR_PAGES base pages as well so the alignment 
doesn't hurt there.

> From memory hotplug view, I prefer section size alignment to make
> simple code. :-P
>

That's fair. I'll roll up a patch that aligns to MAX_ORDER_NR_PAGES to 
begin with and then decide if it should align to section size on SPARSEMEM 
or not.

>
>> However,
>> during boot, there is an implicit assumption that they are aligned to a
>> BITS_PER_LONG boundary when freeing pages as quickly as possible. This
>> patch checks the zone boundaries when freeing pages from the bootmem allocator.
>
> Anyway, the patch works well.
>

Right, I'll resend it to linux-mm as a standalone patch later so because 
it fixes a correctness issue albeit one that is easily avoided.

> Bye.
>

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
