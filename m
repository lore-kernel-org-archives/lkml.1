Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZEMAn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZEMAn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZEMAnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:43:47 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:49144 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZEMAnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:43:46 -0400
MIME-Version: 1.0
In-Reply-To: <20090512090912.GA25923@csn.ul.ie>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <20090512090912.GA25923@csn.ul.ie>
Date: Tue, 12 May 2009 17:43:46 -0700
Message-ID: <d6200be20905121743n4d4f61c2r110d61b5f849e1da@mail.gmail.com>
Subject: Re: [patch 01/11 -mmotm] lowmemorykiller: Only iterate over process 
	list when needed.
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

On Tue, May 12, 2009 at 2:09 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Sun, May 10, 2009 at 03:07:05PM -0700, David Rientjes wrote:
>> From: Arve Hjønnevåg <arve@android.com>
>>
>> Use NR_ACTIVE plus NR_INACTIVE as a size estimate for our fake cache
>> instead the sum of rss. Neither method is accurate.
>>
>
> If neither estimate is accurate (and I agree), then explain why this is
> better and why better decisions are made as a result.
>
It should make similar decisions without iterating over the process
list as often.

> I would assume it's because pages can be double accounted when using RSS
> due to shared pages and you might over-estimate the amount of memory
> really in use. If that reasoning is correct, say that.
>
>> Also skip the process scan, if the amount of memory available is above
>> the largest threshold set.
>>
>
> Patches should do one thing, please split if possible. This patch aspect
> seems to be the if check early on so the splitting should not be
> difficult.
>

This is the whole point of the patch.

> In that statement, you check nr_to_scan <= 0, how can you scan a
> negative number of things? Say in the description that the process scan
> is set if min_adj is such a high value that it cannot be used to
> discriminate between processes for suitability to kill.
>
>> Signed-off-by: Arve Hjønnevåg <arve@android.com>
>> ---
>>  drivers/staging/android/lowmemorykiller.c |   35 +++++++++++++++++-----------
>>  1 files changed, 21 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
>> --- a/drivers/staging/android/lowmemorykiller.c
>> +++ b/drivers/staging/android/lowmemorykiller.c
>> @@ -71,23 +71,30 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>>       }
>>       if(nr_to_scan > 0)
>>               lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
>> +     rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
>> +     if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
>> +             lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
>> +             return rem;
>> +     }
>> +
>>       read_lock(&tasklist_lock);
>>       for_each_process(p) {
>> -             if(p->oomkilladj >= 0 && p->mm) {
>> -                     tasksize = get_mm_rss(p->mm);
>> -                     if(nr_to_scan > 0 && tasksize > 0 && p->oomkilladj >= min_adj) {
>> -                             if(selected == NULL ||
>> -                                p->oomkilladj > selected->oomkilladj ||
>> -                                (p->oomkilladj == selected->oomkilladj &&
>> -                                 tasksize > selected_tasksize)) {
>> -                                     selected = p;
>> -                                     selected_tasksize = tasksize;
>> -                                     lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
>> -                                                  p->pid, p->comm, p->oomkilladj, tasksize);
>> -                             }
>> -                     }
>> -                     rem += tasksize;
>> +             if (p->oomkilladj < min_adj || !p->mm)
>> +                     continue;
>> +             tasksize = get_mm_rss(p->mm);
>> +             if (tasksize <= 0)
>> +                     continue;
>
> It's also odd to consider the possibility of a negative tasksize.

Yes, using an unsigned tasksize would be better, but this patch did
not change any of this.

>
> That aside, RSS is the sum of two longs (or atomic_long_t depending) and
> tasksize here is a signed integer. Are you not at the risk of
> overflowing and this check being unable to do anything useful if all the
> processes of interest are using large amounts of memory?

Yes (The systems we use this on do not have enough memory for this to
be possible though).

>
>> +             if (selected) {
>> +                     if (p->oomkilladj < selected->oomkilladj)
>> +                             continue;
>> +                     if (p->oomkilladj == selected->oomkilladj &&
>> +                         tasksize <= selected_tasksize)
>> +                             continue;
>>               }
>> +             selected = p;
>> +             selected_tasksize = tasksize;
>> +             lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
>> +                          p->pid, p->comm, p->oomkilladj, tasksize);
>>       }
>>       if(selected != NULL) {
>>               lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
>
> I'm hoping it has been discussed elsewhere why the normal OOM killer is not
> being used instead of this driver thing.
>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>



-- 
Arve Hjønnevåg
