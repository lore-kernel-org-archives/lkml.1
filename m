Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbZGPDcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbZGPDcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZGPDcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:32:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326AbZGPDcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:32:22 -0400
Message-ID: <4A5E9F3D.1040600@redhat.com>
Date: Wed, 15 Jul 2009 23:32:13 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are isolated
 already
References: <20090715223854.7548740a@bree.surriel.com> <20090716121956.fc50949f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090716121956.fc50949f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 15 Jul 2009 22:38:53 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
>> When way too many processes go into direct reclaim, it is possible
>> for all of the pages to be taken off the LRU.  One result of this
>> is that the next process in the page reclaim code thinks there are
>> no reclaimable pages left and triggers an out of memory kill.
>>
>> One solution to this problem is to never let so many processes into
>> the page reclaim path that the entire LRU is emptied.  Limiting the
>> system to only having half of each inactive list isolated for
>> reclaim should be safe.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> ---
>> This patch goes on top of Kosaki's "Account the number of isolated pages"
>> patch series.
>>
>>  mm/vmscan.c |   25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> Index: mmotm/mm/vmscan.c
>> ===================================================================
>> --- mmotm.orig/mm/vmscan.c	2009-07-08 21:37:01.000000000 -0400
>> +++ mmotm/mm/vmscan.c	2009-07-08 21:39:02.000000000 -0400
>> @@ -1035,6 +1035,27 @@ int isolate_lru_page(struct page *page)
>>  }
>>  
>>  /*
>> + * Are there way too many processes in the direct reclaim path already?
>> + */
>> +static int too_many_isolated(struct zone *zone, int file)
>> +{
>> +	unsigned long inactive, isolated;
>> +
>> +	if (current_is_kswapd())
>> +		return 0;
>> +
>> +	if (file) {
>> +		inactive = zone_page_state(zone, NR_INACTIVE_FILE);
>> +		isolated = zone_page_state(zone, NR_ISOLATED_FILE);
>> +	} else {
>> +		inactive = zone_page_state(zone, NR_INACTIVE_ANON);
>> +		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
>> +	}
>> +
>> +	return isolated > inactive;
>> +}
> 
> Why this means "too much" ?

This triggers when most of the pages in the zone (in the
category we are trying to reclaim) have already been
isolated by other tasks, to be reclaimed.  There is really
no need to reclaim all of the pages in a zone all at once,
plus it can cause false OOM kills.

Setting the threshold at isolated > inactive gives us
enough of a safety margin that we can do this comparison
lockless.

> And, could you put this check under scanning_global_lru(sc) ?

When most of the pages in a zone have been isolated from
the LRU already by page reclaim, chances are that cgroup
reclaim will suffer from the same problem.

Am I overlooking something?

-- 
All rights reversed.
