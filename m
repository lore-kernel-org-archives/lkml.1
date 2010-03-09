Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0CIPm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:42:59 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:41906 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0CIPm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:42:57 -0500
Message-ID: <4B966C7A.5040706@linux.vnet.ibm.com>
Date: Tue, 09 Mar 2010 16:42:50 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>
CC: linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] page-allocator: Under memory pressure, wait on pressure
 to relieve instead of congestion
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <1268048904-19397-2-git-send-email-mel@csn.ul.ie> <20100309133513.GL8653@laptop> <20100309141713.GF4883@csn.ul.ie> <20100309150332.GP8653@laptop>
In-Reply-To: <20100309150332.GP8653@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nick Piggin wrote:
> On Tue, Mar 09, 2010 at 02:17:13PM +0000, Mel Gorman wrote:
>> On Wed, Mar 10, 2010 at 12:35:13AM +1100, Nick Piggin wrote:
>>> On Mon, Mar 08, 2010 at 11:48:21AM +0000, Mel Gorman wrote:
>>>> Under heavy memory pressure, the page allocator may call congestion_wait()
>>>> to wait for IO congestion to clear or a timeout. This is not as sensible
>>>> a choice as it first appears. There is no guarantee that BLK_RW_ASYNC is
>>>> even congested as the pressure could have been due to a large number of
>>>> SYNC reads and the allocator waits for the entire timeout, possibly uselessly.
>>>>
>>>> At the point of congestion_wait(), the allocator is struggling to get the
>>>> pages it needs and it should back off. This patch puts the allocator to sleep
>>>> on a zone->pressure_wq for either a timeout or until a direct reclaimer or
>>>> kswapd brings the zone over the low watermark, whichever happens first.
>>>>
>>>> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>>>> ---
>>>>  include/linux/mmzone.h |    3 ++
>>>>  mm/internal.h          |    4 +++
>>>>  mm/mmzone.c            |   47 +++++++++++++++++++++++++++++++++++++++++++++
>>>>  mm/page_alloc.c        |   50 +++++++++++++++++++++++++++++++++++++++++++----
>>>>  mm/vmscan.c            |    2 +
>>>>  5 files changed, 101 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>>> index 30fe668..72465c1 100644
>>>> --- a/include/linux/mmzone.h
>>>> +++ b/include/linux/mmzone.h
[...]
>>>> +{
>>>> +	/* If no process is waiting, nothing to do */
>>>> +	if (!waitqueue_active(zone->pressure_wq))
>>>> +		return;
>>>> +
>>>> +	/* Check if the high watermark is ok for order 0 */
>>>> +	if (zone_watermark_ok(zone, 0, low_wmark_pages(zone), 0, 0))
>>>> +		wake_up_interruptible(zone->pressure_wq);
>>>> +}
>>> If you were to do this under the zone lock (in your subsequent patch),
>>> then it could avoid races. I would suggest doing it all as a single
>>> patch and not doing the pressure checks in reclaim at all.
>>>
>> That is reasonable. I've already dropped the checks in reclaim because as you
>> say, if the free path check is cheap enough, it's also sufficient. Checking
>> in the reclaim paths as well is redundant.
>>
>> I'll move the call to check_zone_pressure() within the zone lock to avoid
>> races.
>>

Mel, we talked about a thundering herd issue that might come up here in 
very constraint cases.
So wherever you end up putting that wake_up call, how about being extra 
paranoid about a thundering herd flagging them WQ_FLAG_EXCLUSIVE and 
waking them with something like that:

wake_up_interruptible_nr(zone->pressure_wq, #nrofpagesabovewatermark#);

That should be an easy to calculate sane max of waiters to wake up.
On the other hand it might be over-engineered and it implies the need to 
reconsider when it would be best to wake up the rest.

Get me right - I don't really have a hard requirement or need for that, 
I just wanted to mention it early on to hear your opinions about it.

looking forward to test the v2 patch series, adapted to all the good 
stuff already discussed.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
