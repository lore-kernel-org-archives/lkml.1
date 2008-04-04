Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbYDDBVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbYDDBVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYDDBVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:21:00 -0400
Received: from gw.goop.org ([64.81.55.164]:43936 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYDDBVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:21:00 -0400
Message-ID: <47F58242.1030209@goop.org>
Date: Thu, 03 Apr 2008 18:20:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1 of 6] hotplug-memory: refactor online_pages to	separate
 zone growth from page onlining
References: <5a397e7f3c1aeb7648b9.1207267541@localhost> <1207271207.943.38.camel@nimitz.home.sr71.net>
In-Reply-To: <1207271207.943.38.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
>   
>> +static void grow_zone_span(unsigned long start_pfn, unsigned long
>> end_pfn)
>> +{
>>         unsigned long old_zone_end_pfn;
>> +       struct zone *zone;
>> +       unsigned long flags;
>> +
>> +       /*
>> +        * This doesn't need a lock to do pfn_to_page().
>> +        * The section can't be removed here because of the
>> +        * memory_block->state_sem.
>> +        */
>> +       zone = page_zone(pfn_to_page(start_pfn));
>> +       pgdat_resize_lock(zone->zone_pgdat, &flags);
>>
>>         zone_span_writelock(zone);
>>
>> @@ -149,19 +171,9 @@
>>                                 zone->zone_start_pfn;
>>
>>         zone_span_writeunlock(zone);
>> -}
>>
>> -static void grow_pgdat_span(struct pglist_data *pgdat,
>> -               unsigned long start_pfn, unsigned long end_pfn)
>> -{
>> -       unsigned long old_pgdat_end_pfn =
>> -               pgdat->node_start_pfn + pgdat->node_spanned_pages;
>> -
>> -       if (start_pfn < pgdat->node_start_pfn)
>> -               pgdat->node_start_pfn = start_pfn;
>> -
>> -       pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
>> -                                       pgdat->node_start_pfn;
>> +       grow_pgdat_span(zone->zone_pgdat, start_pfn, end_pfn);
>> +       pgdat_resize_unlock(zone->zone_pgdat, &flags);
>>  }
>>
>>  static int online_pages_range(unsigned long start_pfn, unsigned long
>> nr_pages,
>> @@ -180,16 +192,12 @@
>>         return 0;
>>  }
>>     
>
> I don't particularly like this change to have grow_pgdat_span() called
> *from* grow_zone_span().  Seems backwards to me.  But, this diff look
> funny (not your fault) so I may just be seeing things. :)
>   

Last time I posted this patch you complained about my name 
"online_pages_zone", suggesting "grow_zone_span".  Since that already 
existed, I took that as a hint to fold the two functions together.  Is 
that not what you meant?

    J
