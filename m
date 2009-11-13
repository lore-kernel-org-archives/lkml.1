Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZKMOs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZKMOs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZKMOsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:48:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39459 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZKMOsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:48:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CujZ2yMw6/3OCFxU2XQ1F8/REUHvXdV15VClaKYGpES1M6t0n8zkwjHCE2LKmqtmsP
         4iiiIC0k7k+dfVvZfuk9AXKPMa4pKEXaBWRcY8xghJjkZWNmIHIw72TuWr5Cw+jFTHYU
         5P6pmAEYnFvsBFOaFFEKTXc8z1QcBLdpzUgPM=
MIME-Version: 1.0
In-Reply-To: <20091113135443.GF29804@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
	 <1258054235-3208-6-git-send-email-mel@csn.ul.ie>
	 <20091113142608.33B9.A69D9226@jp.fujitsu.com>
	 <20091113135443.GF29804@csn.ul.ie>
Date: Fri, 13 Nov 2009 23:48:57 +0900
Message-ID: <28c262360911130648q7b615ad4if75b902ed25d5fbd@mail.gmail.com>
Subject: Re: [PATCH 5/5] vmscan: Take order into consideration when deciding 
	if kswapd is in trouble
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 10:54 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Fri, Nov 13, 2009 at 06:54:29PM +0900, KOSAKI Motohiro wrote:
>> > If reclaim fails to make sufficient progress, the priority is raised.
>> > Once the priority is higher, kswapd starts waiting on congestion.
>> > However, on systems with large numbers of high-order atomics due to
>> > crappy network cards, it's important that kswapd keep working in
>> > parallel to save their sorry ass.
>> >
>> > This patch takes into account the order kswapd is reclaiming at before
>> > waiting on congestion. The higher the order, the longer it is before
>> > kswapd considers itself to be in trouble. The impact is that kswapd
>> > works harder in parallel rather than depending on direct reclaimers or
>> > atomic allocations to fail.
>> >
>> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> > ---
>> >  mm/vmscan.c |   14 ++++++++++++--
>> >  1 files changed, 12 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index ffa1766..5e200f1 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -1946,7 +1946,7 @@ static int sleeping_prematurely(int order, long remaining)
>> >  static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
>> >  {
>> >     int all_zones_ok;
>> > -   int priority;
>> > +   int priority, congestion_priority;
>> >     int i;
>> >     unsigned long total_scanned;
>> >     struct reclaim_state *reclaim_state = current->reclaim_state;
>> > @@ -1967,6 +1967,16 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
>> >      */
>> >     int temp_priority[MAX_NR_ZONES];
>> >
>> > +   /*
>> > +    * When priority reaches congestion_priority, kswapd will sleep
>> > +    * for a short time while congestion clears. The higher the
>> > +    * order being reclaimed, the less likely kswapd will go to
>> > +    * sleep as high-order allocations are harder to reclaim and
>> > +    * stall direct reclaimers longer
>> > +    */
>> > +   congestion_priority = DEF_PRIORITY - 2;
>> > +   congestion_priority -= min(congestion_priority, sc.order);
>>
>> This calculation mean
>>
>>       sc.order        congestion_priority     scan-pages
>>       ---------------------------------------------------------
>>       0               10                      1/1024 * zone-mem
>>       1               9                       1/512  * zone-mem
>>       2               8                       1/256  * zone-mem
>>       3               7                       1/128  * zone-mem
>>       4               6                       1/64   * zone-mem
>>       5               5                       1/32   * zone-mem
>>       6               4                       1/16   * zone-mem
>>       7               3                       1/8    * zone-mem
>>       8               2                       1/4    * zone-mem
>>       9               1                       1/2    * zone-mem
>>       10              0                       1      * zone-mem
>>       11+             0                       1      * zone-mem
>>
>> I feel this is too agressive. The intention of this congestion_wait()
>> is to prevent kswapd use 100% cpu time.

As I said in reply of kosaki's patch, I can't understand point.

> Ok, I thought the intention might be to avoid dumping too many pages on
> the queue but it was already waiting on congestion elsewhere.
>
>> but the above promotion seems
>> break it.
>>
>> example,
>> ia64 have 256MB hugepage (i.e. order=14). it mean kswapd never sleep.
>> example2,

But, This is a true problem missed in my review.
Thanks, Kosaki.

>> order-3 (i.e. PAGE_ALLOC_COSTLY_ORDER) makes one of most inefficent
>> reclaim, because it doesn't use lumpy recliam.
>> I've seen 128GB size zone, it mean 1/128 = 1GB. oh well, kswapd definitely
>> waste cpu time 100%.
>>
>>
>> > +
>> >  loop_again:
>> >     total_scanned = 0;
>> >     sc.nr_reclaimed = 0;
>> > @@ -2092,7 +2102,7 @@ loop_again:
>> >              * OK, kswapd is getting into trouble.  Take a nap, then take
>> >              * another pass across the zones.
>> >              */
>> > -           if (total_scanned && priority < DEF_PRIORITY - 2)
>> > +           if (total_scanned && priority < congestion_priority)
>> >                     congestion_wait(BLK_RW_ASYNC, HZ/10);
>>
>> Instead, How about this?
>>
>
> This makes a lot of sense. Tests look good and I added stats to make sure
> the logic was triggering. On X86, kswapd avoided a congestion_wait 11723
> times and X86-64 avoided it 5084 times. I think we should hold onto the
> stats temporarily until all these bugs are ironed out.
>
> Would you like to sign off the following?
>
> If you are ok to sign off, this patch should replace my patch 5 in
> the series.

I agree Kosaki's patch is more strightforward.

You can add my review sign, too.
Thanks for good patch, Kosaki. :)

-- 
Kind regards,
Minchan Kim
