Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbZJHNOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbZJHNOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZJHNOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:14:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50591 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757917AbZJHNOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:14:35 -0400
Date: Thu, 8 Oct 2009 08:13:56 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: gerald.schaefer@de.ibm.com
Cc: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2][v2] powerpc: Make the CMM memory hotplug aware
Message-ID: <20091008131355.GA22118@austin.ibm.com>
Mail-Followup-To: gerald.schaefer@de.ibm.com, Mel Gorman <mel@csn.ul.ie>,
	Ingo Molnar <mingo@elte.hu>, Badari Pulavarty <pbadari@us.ibm.com>,
	Brian King <brking@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@ozlabs.org
References: <20091002184458.GC4908@austin.ibm.com> <20091002185248.GD4908@austin.ibm.com> <4ACDD71D.30809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACDD71D.30809@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gerald Schaefer (geralds@linux.vnet.ibm.com) wrote:
> Hi,
>
> I am currently working on the s390 port for the cmm + hotplug
> patch, and I'm a little confused about the memory allocation
> policy, see below. Is it correct that the balloon cannot grow
> into ZONE_MOVABLE, while the pages for the balloon page list
> can?
>
> Robert Jennings wrote:
>> @@ -110,6 +125,9 @@ static long cmm_alloc_pages(long nr)
>>  	cmm_dbg("Begin request for %ld pages\n", nr);
>>
>>  	while (nr) {
>> +		if (atomic_read(&hotplug_active))
>> +			break;
>> +
>>  		addr = __get_free_page(GFP_NOIO | __GFP_NOWARN |
>>  				       __GFP_NORETRY | __GFP_NOMEMALLOC);
>>  		if (!addr)
>> @@ -119,8 +137,10 @@ static long cmm_alloc_pages(long nr)
>>  		if (!pa || pa->index >= CMM_NR_PAGES) {
>>  			/* Need a new page for the page list. */
>>  			spin_unlock(&cmm_lock);
>> -			npa = (struct cmm_page_array *)__get_free_page(GFP_NOIO | __GFP_NOWARN |
>> -								       __GFP_NORETRY | __GFP_NOMEMALLOC);
>> +			npa = (struct cmm_page_array *)__get_free_page(
>> +					GFP_NOIO | __GFP_NOWARN |
>> +					__GFP_NORETRY | __GFP_NOMEMALLOC |
>> +					__GFP_MOVABLE);
>>  			if (!npa) {
>>  				pr_info("%s: Can not allocate new page list\n", __func__);
>>  				free_page(addr);
>
> Why is the __GFP_MOVABLE added here, for the page list alloc, and not
> above for the balloon page alloc?

The pages allocated as __GFP_MOVABLE are used to store the list of pages
allocated by the balloon.  They reference virtual addresses and it would
be fine for the kernel to migrate the physical pages for those, the
balloon would not notice this.

The pages loaned by the balloon are not allocated with __GFP_MOVABLE
because we will inform the hypervisor which page has been loaned by
Linux according to the physical address.  Migration of those physical
pages would invalidate the loan, so we do not mark them as movable.

Regards,
Robert Jennings
