Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZA2CvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZA2CvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZA2CvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:51:11 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:49316 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZA2CvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:51:09 -0500
MIME-Version: 1.0
In-Reply-To: <20090128234209.A949.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <2f11576a0901160518g52a3e70endc98fe4792a98b9b@mail.gmail.com>
	 <d6200be20901212213x1069762cpd377d04bc5a04a91@mail.gmail.com>
	 <20090128234209.A949.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 18:51:07 -0800
Message-ID: <d6200be20901281851k45f9692em1379140c8951c195@mail.gmail.com>
Subject: Re: lowmemory android driver not needed?
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Brian Swetland <swetland@google.com>,
       arve@google.com, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       =?UTF-8?B?ZXh0IEp1aGEgWXJq7pKU44O7?= <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 5:48 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> To indicate that it is more expensive to restart a killed process than
>> a regular cache page.
>
> I think you already know this answer isn't actual answer.
> anybody know >1 mean expensive. a reviewer want to know why DEFAULT_SEEKS * 16
> is best, not *10 nor *20.

DEFAULT_SEEKS * 16 is probably not best. 10 or 20 probably works just
as well. I don't remember what values I tried, but at some point
lowmem_shrink did not get called often enough to be effective.

>> >> static uint32_t lowmem_debug_level = 2;
>> >> static int lowmem_adj[6] = {
>> >
>> > why do you choice [6]?
>>
>> We use six levels.
>
> if you don't consider other user and other usage case,
> this file can't merge forever.

I never expected it to be merged. I wrote it to allow us to ship a product.

> The top problem is, this file stay on non proper place.
> then, MM folks don't review at all.
>
> I think this patch need to receive MM folks review.

This patch solves two problems for us:
1. It gives us more control over which process gets killed when we run
out of memory. This can easily be fixed in the regular oom killer
instead.
2. It prevents the system from getting unusable due to excessive
demand paging. Before we added the low memory killer, we had devices
stuck for many minutes before the system managed to allocate enough
memory for the oom killer to kick in.
The second problem is the most critical and if it is solved, we will
not need this patch.

>> Another problem we run into is that allocations of contiguous pages
>> can cause kswapd to empty all the caches. This will not trigger this
>> lowmemorykiller or the regular oom killer.
>
> strange usage.
> you shouldn't use high order allocation on embedded machine.

The first level page table on arm needs four contiguous pages. This is
enough to trigger this problem. I suspect the lack of swap makes this
problem much more apparent.

>> How about this:
>> ----
>> diff --git a/drivers/misc/lowmemorykiller.c b/drivers/misc/lowmemorykiller.c
>> index 3715d56..3f4e41a 100644
>> --- a/drivers/misc/lowmemorykiller.c
>> +++ b/drivers/misc/lowmemorykiller.c
>> @@ -71,6 +71,12 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>>         }
>>         if(nr_to_scan > 0)
>>                 lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma
>> %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
>> +       rem = global_page_state(NR_ACTIVE_ANON) +
>> global_page_state(NR_ACTIVE_FILE);
>> +       if (!nr_to_scan || min_adj == OOM_ADJUST_MAX + 1) {
>> +               lowmem_print(5, "lowmem_shrink %d, %x, return %d\n",
>> nr_to_scan, gfp_mask, rem);
>> +               return rem;
>> +       }
>> +
>
> I don't understand your intention.
> if file server machine has tons NR_ACTIVE_FILE, this logic kill many
> process.
>
> Do I misunderstand anything?

It only kills one process at a time, and only if the amount of memory
available is below the selected threshold. The number returned is a
very rough estimate of how much memory can be freed. The old code used
the sum of rss for the killable processes which is not accurate
either.

-- 
Arve Hjønnevåg
