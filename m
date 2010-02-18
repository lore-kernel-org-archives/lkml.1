Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0BRBHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:07:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57200 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab0BRBHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:07:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Feb 2010 10:03:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Kernel panic due to page migration accessing memory holes
Message-Id: <20100218100324.5e9e8f8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B7C8DC2.3060004@codeaurora.org>
References: <4B7C8DC2.3060004@codeaurora.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 16:45:54 -0800
Michael Bohan <mbohan@codeaurora.org> wrote:

> Hi,
> 
> I have encountered a kernel panic on the ARM/msm platform in the mm 
> migration code on 2.6.29.  My memory configuration has two discontiguous 
> banks per our ATAG definition.   These banks end up on addresses that 
> are 1 MB aligned.  I am using FLATMEM (not SPARSEMEM), but my 
> understanding is that SPARSEMEM should not be necessary to support this 
> configuration.  Please correct me if I'm wrong.
> 
> The crash occurs in mm/page_alloc.c:move_freepages() when being passed a 
> start_page that corresponds to the last several megabytes of our first 
> memory bank.  The code in move_freepages_block() aligns the passed in 
> page number to pageblock_nr_pages, which corresponds to 4 MB.  It then 
> passes that aligned pfn as the beginning of a 4 MB range to 
> move_freepages().  The problem is that since our bank's end address is 
> not 4 MB aligned, the range passed to move_freepages() exceeds the end 
> of our memory bank.  The code later blows up when trying to access 
> uninitialized page structures.
> 
That should be aligned, I think.

> As a temporary fix, I added some code to move_freepages_block() that 
> inspects whether the range exceeds our first memory bank -- returning 0 
> if it does.  This is not a clean solution, since it requires exporting 
> the ARM specific meminfo structure to extract the bank information.
> 
Hmm, my first impression is...

- Using FLATMEM, memmap is created for the number of pages and memmap should
  not have aligned size.
- Using SPARSEMEM, memmap is created for aligned number of pages.

Then, the range [zone->start_pfn ... zone->start_pfn + zone->spanned_pages]
should be checked always.


 803 static int move_freepages_block(struct zone *zone, struct page *page,
 804                                 int migratetype)
 805 {
 816         if (start_pfn < zone->zone_start_pfn)
 817                 start_page = page;
 818         if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
 819                 return 0;
 820 
 821         return move_freepages(zone, start_page, end_page, migratetype);
 822 }

"(end_pfn >= zone->zone_start_pfn + zone->spanned_pages)" is checked. 
What zone->spanned_pages is set ? The zone's range is
[zone->start_pfn ... zone->start_pfn+zone->spanned_pages], so this
area should have initialized memmap. I wonder zone->spanned_pages is too big.

Could you check ? (maybe /proc/zoneinfo can show it.)
Dump of /proc/zoneinfo or dmesg will be helpful.

Thanks,
-Kame

