Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYDDFfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYDDFfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYDDFfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:35:22 -0400
Received: from gw.goop.org ([64.81.55.164]:47125 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYDDFfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:35:21 -0400
Message-ID: <47F5BDDE.9060604@goop.org>
Date: Thu, 03 Apr 2008 22:34:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1 of 6] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <patchbomb.1207267540@localhost> <5a397e7f3c1aeb7648b9.1207267541@localhost> <20080404104358.C7F5.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20080404104358.C7F5.E1E9C6FF@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
>> +/* Mark a set of pages as online */
>> +unsigned long mark_pages_onlined(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	struct zone *zone = page_zone(pfn_to_page(pfn));
>> +	unsigned long onlined_pages = 0;
>> +	int need_zonelists_rebuild = 0;
>>  
>>  	/*
>>  	 * If this zone is not populated, then it is not in zonelist.
>> @@ -240,10 +246,38 @@
>>  	vm_total_pages = nr_free_pagecache_pages();
>>  	writeback_set_ratelimit();
>>  
>> -	if (onlined_pages)
>> +	if (onlined_pages) {
>> +		struct memory_notify arg;
>> +
>> +		arg.start_pfn = pfn;  /* ? */
>> +		arg.nr_pages = onlined_pages;
>> +		arg.status_change_nid = -1;  /* ? */
>>     
>
> status_change_nid is to prepare data structures which are allocated on
> each NUMA node.
>   

OK.  I didn't really understand the intent this logic in the 
GOING_ONLINE notifier path:

	arg.status_change_nid = -1;

	nid = page_to_nid(pfn_to_page(pfn));
	if (node_present_pages(nid) == 0)
		arg.status_change_nid = nid;

and how that should relate to the ONLINE notifier.

> When memory less node gets new memory, and it changes status
> to normal memory, then status_change_nid must be set.
>
> SLUB uses it now.
>   

Only for GOING_ONLINE. 

    J
