Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZK0SOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZK0SOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZK0SOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:14:36 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:35181 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZK0SOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:14:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l9XgEliRfXF8noryJcFrr50zH1MxyNeKX9oJKjNXjqXCHwdGCXkJOjkmhnQ7nrFFcO
         n2uZKAmxH6slrOFM4/Vxb70HFSV4Pxlj8wF/8gSfVAotDkC21tO8NxOeCraHjAPvwFv7
         e4C/Wog3/nlHgIK9YGPSGcMKry6+KIBWIJybE=
MIME-Version: 1.0
In-Reply-To: <20091127155841.GM13095@csn.ul.ie>
References: <20091126121945.GB13095@csn.ul.ie>
	 <4e5e476b0911260547r33424098v456ed23203a61dd@mail.gmail.com>
	 <20091126141738.GE13095@csn.ul.ie>
	 <4e5e476b0911260718h35fab3b1hc63587b23c02d43f@mail.gmail.com>
	 <20091127114450.GK13095@csn.ul.ie>
	 <4e5e476b0911270403n1387dcdco6a36e5923b8e04bc@mail.gmail.com>
	 <20091127155841.GM13095@csn.ul.ie>
Date: Fri, 27 Nov 2009 19:14:41 +0100
Message-ID: <4e5e476b0911271014k1d507a02o60c11723948dcfa@mail.gmail.com>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 4:58 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Fri, Nov 27, 2009 at 01:03:29PM +0100, Corrado Zoccolo wrote:
>> On Fri, Nov 27, 2009 at 12:44 PM, Mel Gorman <mel@csn.ul.ie> wrote:

> How would one go about selecting the proper ratio at which to disable
> the low_latency logic?
Can we measure the dirty ratio when the allocation failures start to happen?

>> >
>> > I haven't tested the high-order allocation scenario yet but the results
>> > as thing stands are below. There are four kernels being compared
>> >
>> > 1. with-low-latency               is 2.6.32-rc8 vanilla
>> > 2. with-low-latency-block-2.6.33  is with the for-2.6.33 from linux-block applied
>> > 3. with-low-latency-async-rampup  is with "[RFC,PATCH] cfq-iosched: improve async queue ramp up formula"
>> > 4. without-low-latency            is with low_latency disabled
>> >
>> > desktop-net-gitk
>> >                     gitk-with       low-latency       low-latency      gitk-without
>> >                   low-latency      block-2.6.33      async-rampup       low-latency
>> > min            954.46 ( 0.00%)   570.06 (40.27%)   796.22 (16.58%)   640.65 (32.88%)
>> > mean           964.79 ( 0.00%)   573.96 (40.51%)   798.01 (17.29%)   655.57 (32.05%)
>> > stddev          10.01 ( 0.00%)     2.65 (73.55%)     1.91 (80.95%)    13.33 (-33.18%)
>> > max            981.23 ( 0.00%)   577.21 (41.17%)   800.91 (18.38%)   675.65 (31.14%)
>> >
>> > The changes for block in 2.6.33 make a massive difference here, notably
>> > beating the disabling of low_latency.
>>
> I did a quick test for when high-order-atomic-allocations-for-network
> are happening but the results are not great. By quick test, I mean I
> only did the gitk tests as there wasn't time to do the sysbench and
> iozone tests as well before I'd go offline.
>
> desktop-net-gitk
>                     high-with       low-latency       low-latency      high-without
>                   low-latency      block-2.6.33      async-rampup       low-latency
> min            861.03 ( 0.00%)   467.83 (45.67%)  1185.51 (-37.69%)   303.43 (64.76%)
> mean           866.60 ( 0.00%)   616.28 (28.89%)  1201.82 (-38.68%)   459.69 (46.96%)
> stddev           4.39 ( 0.00%)    86.90 (-1877.46%)    23.63 (-437.75%)    92.75 (-2010.76%)
> max            872.56 ( 0.00%)   679.36 (22.14%)  1242.63 (-42.41%)   537.31 (38.42%)
> pgalloc-fail       25 ( 0.00%)       10 (50.00%)       39 (-95.00%)       20 ( 0.00%)
>
> The patches for 2.6.33 help a little all right but the async-rampup
> patches both make the performance worse and causes more page allocation
> failures to occur. In other words, on most machines it'll appear fine
> but people with wireless cards doing high-order allocations may run into
> trouble.
>
> Disabling low_latency again helps performance significantly in this
> scenario. There were still page allocation failures because not all the
> patches related to that problem made it to mainline.
I'm puzzled how almost all kernels, excluding the async rampup,
perform better when high order allocations are enabled, than in
previous test.

> I was somewhat aggrevated by the page allocation failures until I remembered
> that there are three patches in -mm that I failed to convince either Jens or
> Andrew of them being suitable for mainline. When they are added to the mix,
> the results are as follows;
>
> desktop-net-gitk
>                  atomics-with       low-latency       low-latency   atomics-without
>                   low-latency      block-2.6.33      async-rampup       low-latency
> min            641.12 ( 0.00%)   627.91 ( 2.06%)  1254.75 (-95.71%)   375.05 (41.50%)
> mean           743.61 ( 0.00%)   631.20 (15.12%)  1272.70 (-71.15%)   389.71 (47.59%)
> stddev          60.30 ( 0.00%)     2.53 (95.80%)    10.64 (82.35%)    22.38 (62.89%)
> max            793.85 ( 0.00%)   633.76 (20.17%)  1281.65 (-61.45%)   428.41 (46.03%)
> pgalloc-fail        3 ( 0.00%)        2 ( 0.00%)       23 ( 0.00%)        0 ( 0.00%)
>
Those patches penalize block-2.6.33, that was the one with lowest
number of failures in previous test.
I think the heuristics were tailored to 2.6.32. They need to be
re-tuned for 2.6.33.

> Again, plain old disabling low_latency both performs the best and fails page
> allocations the least. The three patches for page allocation failures are
> in -mm but not mainline are;
>
> [PATCH 3/5] page allocator: Wait on both sync and async congestion after direct reclaim
> [PATCH 4/5] vmscan: Have kswapd sleep for a short interval and double check it should be asleep
> [PATCH 5/5] vmscan: Take order into consideration when deciding if kswapd is in trouble
>
> It still seems to be that the route of least damage is to disable low_latency
> by default for 2.6.32. It's very unfortunate that I wasn't able to fully
> justify the 3 patches for page allocation failures in time but all that
> can be done there is consider them for -stable I suppose.

Just disabling low_latency will not solve the allocation issues (20
instead of 25).
Moreover, it will improve some workloads, but penalize others.

Your 3 patches, though, seem to improve the situation also for
low_latency enabled, both for performance and allocation failures (25
to 3). Having those 3 patches with low_latency enabled seems better,
since it won't penalize the workloads that are benefited by
low_latency (if you add a sequential read to your test, you should see
a big difference).

Thanks,
Corrado
