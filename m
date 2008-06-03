Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYFCQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYFCQRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYFCQRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:17:40 -0400
Received: from saeurebad.de ([85.214.36.134]:50614 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbYFCQRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:17:39 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
References: <20080603005017.593345596@saeurebad.de>
	<20080603005304.127252672@saeurebad.de>
	<20080603225700.9780.E1E9C6FF@jp.fujitsu.com>
Date: Tue, 03 Jun 2008 18:16:56 +0200
In-Reply-To: <20080603225700.9780.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Tue, 03 Jun 2008 22:59:16 +0900")
Message-ID: <87zlq2h4sn.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> Hmm, my ia64 (NUMA) box can't boot up with this patch.
> I'll chase its cause deeply tomorrow.

I think I found it.

>> --- a/mm/bootmem.c
>> +++ b/mm/bootmem.c
>> @@ -408,6 +408,7 @@ static void * __init alloc_bootmem_core(
>>  				unsigned long size, unsigned long align,
>>  				unsigned long goal, unsigned long limit)
>>  {
>> +	unsigned long fallback = 0;
>>  	unsigned long min, max, start, step;
>>  
>>  	BUG_ON(!size);
>> @@ -441,10 +442,11 @@ static void * __init alloc_bootmem_core(
>>  
>>  	max -= PFN_DOWN(bdata->node_boot_start);
>>  	start -= PFN_DOWN(bdata->node_boot_start);
>> +	fallback -= PFN_DOWN(bdata->node_boot_start);
>>  
>>  	if (bdata->last_success > start) {
>> -		/* Set goal here to trigger a retry on failure */
>> -		start = goal = ALIGN(bdata->last_success, step);
>> +		fallback = start;
>> +		start = ALIGN(bdata->last_success, step);
>>  	}
>>  
>>  	while (1) {
>> @@ -491,10 +493,39 @@ find_block:
>>  		return region;
>>  	}
>>  
>> +	if (fallback) {
>> +		start = ALIGN(fallback, step);
>> +		fallback = 0;
>> +		goto find_block;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static void * __init ___alloc_bootmem_nopanic(unsigned long size,
>> +					unsigned long align,
>> +					unsigned long goal,
>> +					unsigned long limit)
>> +{
>> +	bootmem_data_t *bdata;
>> +
>> +restart:
>> +	list_for_each_entry(bdata, &bdata_list, list) {
>> +		void *region;
>> +
>> +		if (goal && goal < bdata->node_boot_start)
>> +			continue;

This check is backwards and probably made your boot fail.

>> +		if (limit && limit < bdata->node_boot_start)
>> +			continue;

Changed this to break, because we don't need to search any further if
the current node already starts at/above the limit (remember, we walk a
list sorted by ->node_boot_start here).

I also made the checks more intuitively understandable.

Could you try the following fix on top of this patch?

	Hannes

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -513,10 +513,10 @@ restart:
 	list_for_each_entry(bdata, &bdata_list, list) {
 		void *region;
 
-		if (goal && goal < bdata->node_boot_start)
-			continue;
-		if (limit && limit < bdata->node_boot_start)
+		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
 			continue;
+		if (limit && bdata->node_boot_start >= limit)
+			break;
 
 		region = alloc_bootmem_core(bdata, size, align, goal, limit);
 		if (region)
