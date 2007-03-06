Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbXCFLUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbXCFLUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934085AbXCFLUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:20:23 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:59178 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934084AbXCFLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:20:18 -0500
Message-ID: <45ED4E40.3010404@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2007 16:49:28 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Kari Hurtta <hurtta+gmane@siilo.fmi.fi>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3][RFC] Containers: Pagecache controller reclaim
References: <45ED251C.2010400@linux.vnet.ibm.com> <45ED266E.7040107@linux.vnet.ibm.com> <5d4poyvfdq.fsf@Hurtta06k.keh.iki.fi>
In-Reply-To: <5d4poyvfdq.fsf@Hurtta06k.keh.iki.fi>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Kari Hurtta wrote:
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> writes
> in gmane.linux.kernel,gmane.linux.kernel.mm:
> 
>> --- linux-2.6.20.orig/mm/pagecache_acct.c
>> +++ linux-2.6.20/mm/pagecache_acct.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/uaccess.h>
>>  #include <asm/div64.h>
>>  #include <linux/pagecache_acct.h>
>> +#include <linux/memcontrol.h>
>>
>>  /*
>>   * Convert unit from pages to kilobytes
>> @@ -337,12 +338,20 @@ int pagecache_acct_cont_overlimit(struct
>>  		return 0;
>>  }
>>
>> -extern unsigned long shrink_all_pagecache_memory(unsigned long nr_pages);
>> +extern unsigned long shrink_container_memory(unsigned int memory_type,
>> +				unsigned long nr_pages, void *container);
>>
>>  int pagecache_acct_shrink_used(unsigned long nr_pages)
>>  {
>>  	unsigned long ret = 0;
>>  	atomic_inc(&reclaim_count);
>> +
>> +	/* Don't call reclaim for each page above limit */
>> +	if (nr_pages > NR_PAGES_RECLAIM_THRESHOLD) {
>> +		ret += shrink_container_memory(
>> +				RECLAIM_PAGECACHE_MEMORY, nr_pages, NULL);
>> +	}
>> +
>>  	return 0;
>>  }
>>
> 
> 'ret' is not used ?

I have been setting watch points and tracing the value of ret.
Basically that is used while debugging.  I have not removed it since
this is an RFC post and we would go through many cleanups cycles.

I will remember to remove it in the next version or verify that the
compiler does remove 'ret' :)

--Vaidy

> / Kari Hurtta
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
