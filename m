Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXDXLEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXDXLEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXDXLEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:04:06 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:48325 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbXDXLED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:04:03 -0400
Message-ID: <462DE373.2060707@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2007 16:31:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
References: <461A3010.90403@sw.ru> <461A397A.8080609@sw.ru> <462DD22D.3030401@linux.vnet.ibm.com> <462DDD1E.8080306@sw.ru>
In-Reply-To: <462DDD1E.8080306@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> Balbir Singh wrote:
>> Pavel Emelianov wrote:
>>> Implement try_to_free_pages_in_container() to free the
>>> pages in container that has run out of memory.
>>>
>>> The scan_control->isolate_pages() function isolates the
>>> container pages only.
>>>
>> Pavel,
>>
>> I've just started playing around with these patches, I preferred
>> the approach of v1. Please see below
>>
>>> +static unsigned long isolate_container_pages(unsigned long nr_to_scan,
>>> +        struct list_head *src, struct list_head *dst,
>>> +        unsigned long *scanned, struct zone *zone)
>>> +{
>>> +    unsigned long nr_taken = 0;
>>> +    struct page *page;
>>> +    struct page_container *pc;
>>> +    unsigned long scan;
>>> +    LIST_HEAD(pc_list);
>>> +
>>> +    for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
>>> +        pc = list_entry(src->prev, struct page_container, list);
>>> +        page = pc->page;
>>> +        if (page_zone(page) != zone)
>>> +            continue;
>> shrink_zone() will walk all pages looking for pages belonging to this
> 
> No. shrink_zone() will walk container pages looking for pages in the desired zone.
> Scann through the full zone is done on global memory shortage.
> 

Yes, I see that now. But for each zone in the system, we walk through the
containers list - right?

I have some more fixes, improvements that I want to send across.
I'll start sending them out to you as I test and verify them.


>> container and this slows down the reclaim quite a bit. Although we've
>> reused code, we've ended up walking the entire list of the zone to
>> find pages belonging to a particular container, this was the same
>> problem I had with my RSS controller patches.
>>
>>> +
>>> +        list_move(&pc->list, &pc_list);
>>> +
>>
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
