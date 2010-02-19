Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0BSGNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:13:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45566 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0BSGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:13:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Feb 2010 15:10:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: Kernel panic due to page migration accessing memory holes
Message-Id: <20100219151012.d430b7ea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B7E2635.8010700@codeaurora.org>
References: <4B7C8DC2.3060004@codeaurora.org>
	<20100218100324.5e9e8f8c.kamezawa.hiroyu@jp.fujitsu.com>
	<4B7CF8C0.4050105@codeaurora.org>
	<20100218183604.95ee8c77.kamezawa.hiroyu@jp.fujitsu.com>
	<20100218100432.GA32626@csn.ul.ie>
	<4B7DEDB0.8030802@codeaurora.org>
	<20100219110003.dfe58df8.kamezawa.hiroyu@jp.fujitsu.com>
	<4B7E2635.8010700@codeaurora.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 21:48:37 -0800
Michael Bohan <mbohan@codeaurora.org> wrote:

> On 2/18/2010 6:00 PM, KAMEZAWA Hiroyuki wrote:
> > memmap for memory holes should be marked as PG_reserved and never be freed
> > by free_bootmem(). Then, memmap for memory holes will not be in buddy allocator.
> >
> > Again, pfn_valid() just show "there is memmap", not for "there is a valid page"
> >    
> 
> ARM seems to have been freeing the memmap holes for a long time.
Ouch.

> I'm pretty sure there would be a lot of pushback if we tried to change 
> that.  For example, in my memory map running FLATMEM, I would be 
> consuming an extra ~7 MB of memory if these structures were not freed.
> 
> As a compromise, perhaps we could free everything except the first 
> 'pageblock_nr_pages' in a hole?  This would guarantee that 
> move_freepages() doesn't deference any memory that doesn't belong to the 
> memmap -- but still only waste a relatively small amount of memory.  For 
> a 4 MB page block, it should only consume an extra 32 KB per hole in the 
> memory map.
> 
No. You have to implement pfn_valid() to return correct value as
"pfn_valid() returnes true if there is memmap." even if you do that.
Otherwise, many things will go bad.

You have 2 or 3 ways.

1. re-implement pfn_valid() which returns correct value.
   maybe not difficult. but please take care of defining CONFIG_HOLES_IN_....
   etc.

2. use DISCONTIGMEM and treat each bank and NUMA node.
   There will be no waste for memmap. But other complication of CONFIG_NUMA.
   
3. use SPARSEMEM.
   You have even 2 choisce here. 
   a - Set your MAX_ORDER and SECTION_SIZE to be proper value.
   b - waste some amount of memory for memmap on the edge of section.
       (and don't free memmap for the edge.)
      
Thanks,
-Kame

