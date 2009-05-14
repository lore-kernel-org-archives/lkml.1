Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZENXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZENXZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZENXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:25:05 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:30615 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbZENXZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <20090513094256.GA12905@csn.ul.ie>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101459370.18804@chino.kir.corp.google.com>
	 <20090512092347.GB25923@csn.ul.ie>
	 <d6200be20905121727t22e59458ha5d7ec3617173b1a@mail.gmail.com>
	 <20090513094256.GA12905@csn.ul.ie>
Date: Thu, 14 May 2009 16:25:04 -0700
Message-ID: <d6200be20905141625s3216c800rdadbc04e005a485e@mail.gmail.com>
Subject: Re: [patch 02/11 -mmotm] lowmemorykiller: Don't count free space 
	unless it meets the specified limit by itself
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 2:42 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Tue, May 12, 2009 at 05:27:18PM -0700, Arve Hj?nnev?g wrote:
>> On Tue, May 12, 2009 at 2:23 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > On Sun, May 10, 2009 at 03:07:10PM -0700, David Rientjes wrote:
>> >> From: Arve Hjønnevåg <arve@android.com>
>> >>
>> >> This allows processes to be killed when the kernel evict cache pages in
>> >> an attempt to get more contiguous free memory.
>> >>
>> >
>> > I'm not seeing what this patch has to do with contiguous free memory. I
>> > see what the patch is doing - lowering the threshold allowing a
>> > particular min_adj value to be used, but not why.
>> >
>>
>> If the memory is fragmented, contiguous allocations can cause all
>> caches to be freed. The low memory killer would not trigger in this
>> case.
>>
>
> That still doesn't explain why this patch allows processes to be killed
> in an effort to get contiguous free memory other than freeing pages in
> general may free up contiguous pages. It seems this patch makes the
> killer more agressive but I think I know why.

Without this patch, the lowmemorykiller would never trigger when the
kernel freed cache memory (since the lowmemorykiller looked at the sum
of cache plus free). For normal allocations this is not a problem
since the kernel stops freeing cache memory when the required amount
of free memory is met. For contiguous allocations, there is no limit
to how much cache memory the kernel will try to free.

>
> How about the following as a changelog? It might help me understand the
> use case better and how this patch changes it if the changelog was better.
> Of course, as this is this driver is isolated to the Android platform and
> I'm not developing or own one, you're also welcome to tell me to "shut up,
> you don't know what you're talking about" :)
>
> =====
> The Android low memory killer is responsible for ensuring there is enough
> free memory at configured watermarks stored in a lowmem_minfree[] array. At
> each watermark, there is an associated oom_adj score. When the watermark is
> not met, processes with a higher oom_adj are considered for OOM killing
> so that lower-priority processes are killed before the situation becomes
> unmanageable.

This is describing the lowmemorykiller with or without this patch and
does not belong in this patch description. Have you looked at
drivers/staging/android/lowmemorykiller.txt?

>
> The problem is that the driver currently sums NR_FREE_PAGES+NR_FILE_PAGES
> as an estimate of how much memory is potentially free. This can lead to
> a situation where no memory is really free because it's all in the page
> cache and corrective action is taken too late with too many processes being
> considered. This patch changes the semantics such that both NR_FREE_PAGES
> and NR_FILE_PAGES must be above the lowmem_minfree threshold.
> ====

I don't think this is correct. To start with, we want memory to be
used for the cache.

>
> ?
>
> If this is accurate, it also wouldn't hurt to put the first paragraph into a
> comment earlier in the driver so the next poor fool like me isn't scratching
> his head wondering what this is for.
>
>> >
>> >> Signed-off-by: Arve Hjønnevåg <arve@android.com>
>> >> ---
>> >>  drivers/staging/android/lowmemorykiller.c |   13 +++++++++----
>> >>  1 files changed, 9 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
>> >> --- a/drivers/staging/android/lowmemorykiller.c
>> >> +++ b/drivers/staging/android/lowmemorykiller.c
>> >> @@ -58,20 +58,25 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>> >>       int min_adj = OOM_ADJUST_MAX + 1;
>> >>       int selected_tasksize = 0;
>> >>       int array_size = ARRAY_SIZE(lowmem_adj);
>> >> -     int other_free = global_page_state(NR_FREE_PAGES) + global_page_state(NR_FILE_PAGES);
>> >> +     int other_free = global_page_state(NR_FREE_PAGES);
>> >> +     int other_file = global_page_state(NR_FILE_PAGES);
>> >>       if(lowmem_adj_size < array_size)
>> >>               array_size = lowmem_adj_size;
>> >>       if(lowmem_minfree_size < array_size)
>> >>               array_size = lowmem_minfree_size;
>> >>       for(i = 0; i < array_size; i++) {
>> >
>> > It would appear that lowmem_adj_size is making assumptions on
>> > the number of zones that exist in the system. It's not clear why
>> > sysctl_lowmem_reserve_ratio[] is not being used or how they differ.
>>
>> lowmem_adj_size is the number of elements in the array. Why would the
>> number of zones in the system affect it?
>
> I misread what the purpose of lowmem_adj[] was. I thought it was
> thresholds on a per-zone basis because it looks similar to
> lowmem_reserve_ratio[] but that's not what it is at all.
>
> Looking at it closer, this is more about introducing more watermarks to
> a zone for the control of the size of the cache - maybe because the OOM
> killer takes action too late for you.
>
> Lack of familiarity with the driver and how it's expected to be used is
> catching me.
>
>> The goal of the
>> lowmemorykiller is to make more memory available for caches. I would
>> expect increasing sysctl_lowmem_reserve_ratio to have the opposite
>> effect, but on our system with only one zone it has no effect.
>>
>
> Ok.
>
>> >
>> >> -             if(other_free < lowmem_minfree[i]) {
>> >> +             if (other_free < lowmem_minfree[i] &&
>> >> +                 other_file < lowmem_minfree[i]) {
>> >>                       min_adj = lowmem_adj[i];
>> >>                       break;
>> >>               }
>> >>       }
>> >>       if(nr_to_scan > 0)
>> >> -             lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
>> >> -     rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
>> >> +             lowmem_print(3, "lowmem_shrink %d, %x, ofree %d %d, ma %d\n", nr_to_scan, gfp_mask, other_free, other_file, min_adj);
>> >> +     rem = global_page_state(NR_ACTIVE_ANON) +
>> >> +             global_page_state(NR_ACTIVE_FILE) +
>> >> +             global_page_state(NR_INACTIVE_ANON) +
>> >> +             global_page_state(NR_INACTIVE_FILE);
>> >
>> > This looks like it's a compile fix since changes made to 4f98a2fe. This
>> > should have been in a separate patch and prioritised.
>>
>> You are right. These patches were originally on 2.6.27 and I did not
>> notice that the first patch was also broken when I fixed this patch
>> for 2.6.29.
>>
>
> Ok
>
>> >
>> >>       if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
>> >>               lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
>> >>               return rem;
>> >
>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>



-- 
Arve Hjønnevåg
