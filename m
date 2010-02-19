Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab0BSFsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 00:48:40 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37361 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0BSFsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 00:48:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5896"; a="34490181"
Message-ID: <4B7E2635.8010700@codeaurora.org>
Date: Thu, 18 Feb 2010 21:48:37 -0800
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: Kernel panic due to page migration accessing memory holes
References: <4B7C8DC2.3060004@codeaurora.org>	<20100218100324.5e9e8f8c.kamezawa.hiroyu@jp.fujitsu.com>	<4B7CF8C0.4050105@codeaurora.org>	<20100218183604.95ee8c77.kamezawa.hiroyu@jp.fujitsu.com>	<20100218100432.GA32626@csn.ul.ie>	<4B7DEDB0.8030802@codeaurora.org> <20100219110003.dfe58df8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100219110003.dfe58df8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/2010 6:00 PM, KAMEZAWA Hiroyuki wrote:
> memmap for memory holes should be marked as PG_reserved and never be freed
> by free_bootmem(). Then, memmap for memory holes will not be in buddy allocator.
>
> Again, pfn_valid() just show "there is memmap", not for "there is a valid page"
>    

ARM seems to have been freeing the memmap holes for a long time.  I'm 
pretty sure there would be a lot of pushback if we tried to change 
that.  For example, in my memory map running FLATMEM, I would be 
consuming an extra ~7 MB of memory if these structures were not freed.

As a compromise, perhaps we could free everything except the first 
'pageblock_nr_pages' in a hole?  This would guarantee that 
move_freepages() doesn't deference any memory that doesn't belong to the 
memmap -- but still only waste a relatively small amount of memory.  For 
a 4 MB page block, it should only consume an extra 32 KB per hole in the 
memory map.

Thanks,
Michael
