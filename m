Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZHSMGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZHSMGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZHSMGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:06:41 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:34885 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZHSMGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nI904NROC9IiHFvMEzShK4alYi29AMotTwbM8CQAznYyqtvGK2qwASJmQeI41bTHAN
         sodw+gUjGlzy0GGDpSLtlOop6rE04H2W5Y6QlZdzA6X+zJTJzewZPHRW9Cc0MjdkJAtQ
         uT7rQwlGlmGC8KlOXBYpRUTpSjxzDMHg6BrFA=
MIME-Version: 1.0
In-Reply-To: <20090819105829.GH24809@csn.ul.ie>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	 <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
	 <4A8B7508.4040001@vflare.org>
	 <20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
	 <18eba5a10908182324x45261d06y83e0f042e9ee6b20@mail.gmail.com>
	 <20090819154958.18a34aa5.minchan.kim@barrios-desktop>
	 <20090819103611.GG24809@csn.ul.ie>
	 <20090819195242.4454a35f.minchan.kim@barrios-desktop>
	 <20090819105829.GH24809@csn.ul.ie>
Date: Wed, 19 Aug 2009 21:06:41 +0900
Message-ID: <18eba5a10908190506y4dfd08auf29a7919dd88be4f@mail.gmail.com>
Subject: Re: abnormal OOM killer message
From: Chungki woo <chungki.woo@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>, ngupta@vflare.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 7:58 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> On Wed, Aug 19, 2009 at 07:52:42PM +0900, Minchan Kim wrote:
>> Thanks for good comment, Mel.
>>
>> On Wed, 19 Aug 2009 11:36:11 +0100
>> Mel Gorman <mel@csn.ul.ie> wrote:
>>
>> > On Wed, Aug 19, 2009 at 03:49:58PM +0900, Minchan Kim wrote:
>> > > On Wed, 19 Aug 2009 15:24:54 +0900
>> > > ????????? <chungki.woo@gmail.com> wrote:
>> > >
>> > > > Thank you very much for replys.
>> > > >
>> > > > But I think it seems not to relate with stale data problem in compcache.
>> > > > My question was why last chance to allocate memory was failed.
>> > > > When OOM killer is executed, memory state is not a condition to
>> > > > execute OOM killer.
>> > > > Specially, there are so many pages of order 0. And allocating order is zero.
>> > > > I think that last allocating memory should have succeeded.
>> > > > That's my worry.
>> > >
>> > > Yes. I agree with you.
>> > > Mel. Could you give some comment in this situation ?
>> > > Is it possible that order 0 allocation is failed
>> > > even there are many pages in buddy ?
>> > >
>> >
>> > Not ordinarily. If it happens, I tend to suspect that the free list data
>> > is corrupted and would put a check in __rmqueue() that looked like
>> >
>> >     BUG_ON(list_empty(&area->free_list) && area->nr_free);
>>
>> If memory is corrupt, it would be not satisfied with both condition.
>> It would be better to ORed condition.
>>
>> BUG_ON(list_empty(&area->free_list) || area->nr_free);
>>
>
> But it's perfectly reasonable to have nr_free a positive value. The
> point of the check is ensure the counters make sense. If nr_free > 0 and
> the list is empty, it means accounting is all messed up and the values
> reported for "free" in the OOM message are fiction.
>
>> > The second question is, why are we in direct reclaim this far above the
>> > watermark? It should only be kswapd that is doing any reclaim at that
>> > point. That makes me wonder again are the free lists corrupted.
>>
>> It does make sense!
>

'Corrupted free list' makes sense. Thank you very much.
Inserting BUG_ON code is also good idea to check corruption of free list.

I have one more question.
As you know, before and after executing direct reclaim
routine(try_to_free_pages)
cond_resched() routine is also executed.
In other words, it can be scheduled at that time.
Is there no possibility executing kswapd or try_to_free_pages at other
context at that time?
I think this fact maybe can explain that gap(between watermark and
free memory) also.
How do you think about this?
But I know this can't explain why last chance to allocate memory was failed.
I think your idea makes sense.

Anyway, I will try to test again with following BUG_ON code.

BUG_ON(list_empty(&area->free_list) && area->nr_free);

Thanks
Mel, Minchan

>> > The other possibility is that the zonelist used for allocation in the
>> > troubled path contains no populated zones. I would put a BUG_ON check in
>> > get_page_from_freelist() to check if the first zone in the zonelist has no
>> > pages. If that bug triggers, it might explain why OOMs are triggering for
>> > no good reason.
>>
>> Yes. Chungki. Could you put the both BUG_ON in each function and
>> try to reproduce the problem ?
>>
>> > I consider both of those possibilities abnormal though.
>> >
>> > > >
>> > > > -----------------------------------------------------------------------------------------------------------------------------------------------
>> > > >       page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
>> > > > <== this is last chance
>> > > >                            zonelist, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
>> > > > <== uses ALLOC_WMARK_HIGH
>> > > >       if (page)
>> > > >       goto got_pg;
>> > > >
>> > > >       out_of_memory(zonelist, gfp_mask, order);
>> > > >       goto restart;
>> > > > -----------------------------------------------------------------------------------------------------------------------------------------------
>> > > >
>> > > > > Let me have a question.
>> > > > > Now the system has 79M as total swap.
>> > > > > It's bigger than system memory size.
>> > > > > Is it possible in compcache?
>> > > > > Can we believe the number?
>> > > >
>> > > > Yeah, It's possible. 79Mbyte is data size can be swap.
>> > > > It's not compressed data size. It's just original data size.
>> > >
>> > > You means your pages with 79M are swap out in compcache's reserved
>> > > memory?
>> > >
>> >
>> > --
>> > Mel Gorman
>> > Part-time Phd Student                          Linux Technology Center
>> > University of Limerick                         IBM Dublin Software Lab
>>
>>
>> --
>> Kind regards,
>> Minchan Kim
>>
>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>
