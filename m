Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXDXKfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXDXKfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbXDXKfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:35:12 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18051 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbXDXKfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:35:10 -0400
Message-ID: <462DDD1E.8080306@sw.ru>
Date: Tue, 24 Apr 2007 14:34:06 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
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
References: <461A3010.90403@sw.ru> <461A397A.8080609@sw.ru> <462DD22D.3030401@linux.vnet.ibm.com>
In-Reply-To: <462DD22D.3030401@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Pavel Emelianov wrote:
>> Implement try_to_free_pages_in_container() to free the
>> pages in container that has run out of memory.
>>
>> The scan_control->isolate_pages() function isolates the
>> container pages only.
>>
> 
> Pavel,
> 
> I've just started playing around with these patches, I preferred
> the approach of v1. Please see below
> 
>> +static unsigned long isolate_container_pages(unsigned long nr_to_scan,
>> +        struct list_head *src, struct list_head *dst,
>> +        unsigned long *scanned, struct zone *zone)
>> +{
>> +    unsigned long nr_taken = 0;
>> +    struct page *page;
>> +    struct page_container *pc;
>> +    unsigned long scan;
>> +    LIST_HEAD(pc_list);
>> +
>> +    for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
>> +        pc = list_entry(src->prev, struct page_container, list);
>> +        page = pc->page;
>> +        if (page_zone(page) != zone)
>> +            continue;
> 
> shrink_zone() will walk all pages looking for pages belonging to this

No. shrink_zone() will walk container pages looking for pages in the desired zone.
Scann through the full zone is done on global memory shortage.

> container and this slows down the reclaim quite a bit. Although we've
> reused code, we've ended up walking the entire list of the zone to
> find pages belonging to a particular container, this was the same
> problem I had with my RSS controller patches.
> 
>> +
>> +        list_move(&pc->list, &pc_list);
>> +
> 
> 

