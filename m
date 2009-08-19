Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZHSDoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZHSDoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZHSDob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:44:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:7545 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZHSDob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:44:31 -0400
Message-ID: <4A8B7508.4040001@vflare.org>
Date: Wed, 19 Aug 2009 09:14:08 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: =?UTF-8?B?7Jqw7Lap6riw?= <chungki.woo@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>
Subject: Re: abnormal OOM killer message
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com> <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
In-Reply-To: <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2009 08:14 AM, Minchan Kim wrote:
> On Wed, 19 Aug 2009 10:41:51 +0900
> 우충기<chungki.woo@gmail.com>  wrote:
>
>> Hi all~
>> I have got a log message with OOM below. I don't know why this
>> phenomenon was happened.
>> When direct reclaim routine(try_to_free_pages) in __alloc_pages which
>> allocates kernel memory was failed,
>> one last chance is given to allocate memory before OOM routine is executed.
>> And that time, allocator uses ALLOC_WMARK_HIGH to limit watermark.
>> Then, zone_watermark_ok function test this value with current memory
>> state and decide 'can allocate' or 'cannot allocate'.
>>
>> Here is some kernel source code in __alloc_pages function to understand easily.
>> Kernel version is 2.6.18 for arm11. Memory size is 32Mbyte. And I use
>> compcache(0.5.2).

<snip>

>>
>> In my case, you can see free pages(6804KB) is much more higher than
>> high watermark value(1084KB) in OOM message.
>> And order of allocating is also zero.(order=0)
>> In buddy system, the number of 4kbyte page is 867.
>> So, I think OOM can't be happend.
>>
>
> Yes. I think so.
>
> In that case, even we can also avoid zone defensive algorithm.
>
>> How do you think about this?
>> Is this side effect of compcache?
>

compcache can be storing lot of stale data and this memory space cannot be
reclaimed (unless overwritten by some other swap data). This is because
compcache does not know when a swap slot has been freed and hence does not know 
when its safe to free corresponding memory. You can check current memory usage 
with /proc/ramzswap (see MemUsedTotal).

BTW, with compcache-0.6 there is an experimental kernel patch that gets rid of 
all this stale data:
http://patchwork.kernel.org/patch/41083/

However, this compcache version needs at least kernel 2.6.28. This version also 
fixes all known problems on ARM. compcache-0.5.3 or earlier is known to crash on 
ARM (see: http://code.google.com/p/compcache/issues/detail?id=33).

Thanks,
Nitin
