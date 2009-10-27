Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZJ0PQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZJ0PQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZJ0PQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:16:27 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:59477 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZJ0PQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F6ixfVuICqhkWBgVBVY3cS6WryLiB1vDtm4kKiqvqlc1CRiPapHdKpcz4CjW/YupcP
         cdUsgroAvQNsCr0jDm6BmVDvp3QjaVWsCxXc+maUtVU9EbykgdkMF22rbfCUbcRM1TMS
         xQp53Mp3s7rLwOfPoueN1Q7axL1VvknVptLE8=
MIME-Version: 1.0
In-Reply-To: <20091027145435.GG8900@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <20091019161815.GA11487@think>
	 <20091020104839.GC11778@csn.ul.ie>
	 <200910262206.13146.elendil@planet.nl>
	 <20091027145435.GG8900@csn.ul.ie>
Date: Wed, 28 Oct 2009 00:16:30 +0900
X-Google-Sender-Auth: fb2a65478906a9d4
Message-ID: <2f11576a0910270816s3e1b268ah91b5f2d0cc0d562e@mail.gmail.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Chris Mason <chris.mason@oracle.com>,
       David Rientjes <rientjes@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/27 Mel Gorman <mel@csn.ul.ie>:
> On Mon, Oct 26, 2009 at 10:06:09PM +0100, Frans Pop wrote:
>> On Tuesday 20 October 2009, Mel Gorman wrote:
>> > I've attached a patch below that should allow us to cheat. When it's
>> > applied, it outputs who called congestion_wait(), how long the timeout
>> > was and how long it waited for. By comparing before and after sleep
>> > times, we should be able to see which of the callers has significantly
>> > changed and if it's something easily addressable.
>>
>> The results from this look fairly interesting (although I may be a bad
>> judge as I don't really know what I'm looking at ;-).
>>
>> I've tested with two kernels:
>> 1) 2.6.31.1: 1 test run
>> 2) 2.6.31.1 + congestion_wait() reverts: 2 test runs
>>
>> The 1st kernel had the expected "freeze" while reading commits in gitk;
>> reading commits with the 2nd kernel was more fluent.
>> I did 2 runs with the 2nd kernel as the first run had a fairly long music
>> skip and more SKB errors than expected. The second run was fairly normal
>> with no music skips at all even though it had a few SKB errors.
>>
>> Data for the tests:
>>                               1st kernel      2nd kernel 1    2nd kernel 2
>> end reading commits           1:15            1:00            0:55
>>   "freeze"                    yes             no              no
>> branch data shown             1:55            1:15            1:10
>> system quiet                  2:25            1:50            1:45
>> # SKB allocation errors               10              53              5
>>
>> Note that the test is substantially faster with the 2nd kernel and that the
>> SKB errors don't really affect the duration of the test.
>>
>
> Ok. I think that despite expectations, the writeback changes have
> changed the timing significantly enough to be worth examining closer.
>
>>
>> - without the revert 'background_writeout' is called a lot less frequently,
>>   but when it's called it gets long delays
>> - without the revert you have 'wb_kupdate', which is relatively expensive
>> - with the revert 'shrink_list' is relatively expensive, although not
>>   really in absolute terms
>>
>
> Lets look at the callers that waited in congestion_wait() for at least
> 25 jiffies.
>
> 2.6.31.1-async-sync-congestion-wait i.e. vanilla kernel
> generated with: cat kern.log_1_test | awk -F ] '{print $2}' | sort -k 5 -n | uniq -c
>     24  background_writeout  congestion_wait sync=0 delay 25 timeout 25
>    203  kswapd               congestion_wait sync=0 delay 25 timeout 25
>      5  shrink_list          congestion_wait sync=0 delay 25 timeout 25
>    155  try_to_free_pages    congestion_wait sync=0 delay 25 timeout 25
>    145  wb_kupdate           congestion_wait sync=0 delay 25 timeout 25
>      2  kswapd               congestion_wait sync=0 delay 26 timeout 25
>      8  wb_kupdate           congestion_wait sync=0 delay 26 timeout 25
>      1  try_to_free_pages    congestion_wait sync=0 delay 54 timeout 25
>
> 2.6.31.1-write-congestion-wait i.e. kernel with patch reverted
> generated with: cat kern.log_2.1_test | awk -F ] '{print $2}' | sort -k 5 -n | uniq -c
>      2  background_writeout  congestion_wait rw=1 delay 25 timeout 25
>    188  kswapd               congestion_wait rw=1 delay 25 timeout 25
>     14  shrink_list          congestion_wait rw=1 delay 25 timeout 25
>    181  try_to_free_pages    congestion_wait rw=1 delay 25 timeout 25
>      5  kswapd               congestion_wait rw=1 delay 26 timeout 25
>     10  try_to_free_pages    congestion_wait rw=1 delay 26 timeout 25
>      3  try_to_free_pages    congestion_wait rw=1 delay 27 timeout 25
>      1  kswapd               congestion_wait rw=1 delay 29 timeout 25
>      1  __alloc_pages_nodemask congestion_wait rw=1 delay 30 timeout 5
>      1  try_to_free_pages    congestion_wait rw=1 delay 31 timeout 25
>      1  try_to_free_pages    congestion_wait rw=1 delay 35 timeout 25
>      1  kswapd               congestion_wait rw=1 delay 51 timeout 25
>      1  try_to_free_pages    congestion_wait rw=1 delay 56 timeout 25
>
> So, wb_kupdate and background_writeout are the big movers in terms of waiting,
> not the direct reclaimers which is what we were expecting. Of those big
> movers, wb_kupdate is the most interested because compare the following
>
> $ cat kern.log_2.1_test | awk -F ] '{print $2}' | sort -k 5 -n | uniq -c | grep wb_kup
> [ no output ]
> $ $ cat kern.log_1_test | awk -F ] '{print $2}' | sort -k 5 -n | uniq -c | grep wb_kup
>      1  wb_kupdate           congestion_wait sync=0 delay 15 timeout 25
>      1  wb_kupdate           congestion_wait sync=0 delay 23 timeout 25
>    145  wb_kupdate           congestion_wait sync=0 delay 25 timeout 25
>      8  wb_kupdate           congestion_wait sync=0 delay 26 timeout 25
>
> The vanilla kernel is not waiting in wb_kupdate at all.
>
> Jens, before the congestion_wait() changes, wb_kupdate was waiting on
> congestion and afterwards it's not. Furthermore, look at the number of pages
> that are queued for writeback in the two page allocation failure reports.
>
> without-revert: writeback:65653
> with-revert:    writeback:21713
>
> So, after the move to async/sync, a lot more pages are getting queued
> for writeback - more than three times the number of pages are queued for
> writeback with the vanilla kernel. This amount of congestion might be why
> direct reclaimers and kswapd's timings have changed so much.
>
> Chris Mason hinted at this but I didn't quite "get it" at the time but is it
> possible that writeback_inodes() is converting what is expected to be async
> IO into sync IO? One way of checking this is if Frans could test the patch
> below that makes wb_kupdate wait on sync instead of async.
>
> If this makes a difference, I think the three main areas of trouble we
> are now seeing are
>
>        1. page allocator regressions - mostly fixed hopefully
>        2. page writeback change in timing - theory yet to be confirmed
>        3. drivers using more atomics - iwlagn specific, being dealt with
>
> Of course, the big problem is if the changes are due to major timing
> differences in page writeback, then mainline is a totally different
> shape of problem as pdflush has been replaced there.
>
> ====
> Have wb_kupdate wait on sync IO congestion instead of async
>
> wb_kupdate is expected to only have queued up pages for async IO.
> However, something screwy is happening because it never appears to go to
> sleep. Frans, can you test with this patch instead of the revert please?
> Preferably, keep the verbose-congestion_wait patch applied so we can
> still get an idea who is going to sleep and for how long when calling
> congestion_wait. thanks
>
> Not-signed-off-hacket-job: Mel Gorman <mel@csn.ul.ie>
> ---
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 81627eb..cb646dd 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -787,7 +787,7 @@ static void wb_kupdate(unsigned long arg)
>                writeback_inodes(&wbc);
>                if (wbc.nr_to_write > 0) {
>                        if (wbc.encountered_congestion || wbc.more_io)
> -                               congestion_wait(BLK_RW_ASYNC, HZ/10);
> +                               congestion_wait(BLK_RW_SYNC, HZ/10);
>                        else
>                                break;  /* All the old data is written */
>                }

Hmm, This doesn't looks correct to me.

BLK_RW_ASYNC mean async write.
BLK_RW_SYNC  mean read and sync-write.

wb_kupdate use WB_SYNC_NONE. it's async write.
