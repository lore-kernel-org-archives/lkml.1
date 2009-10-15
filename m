Return-Path: <linux-kernel-owner+w=401wt.eu-S934968AbZJOSWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968AbZJOSWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZJOSWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:22:09 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:42436 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554AbZJOSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:22:08 -0400
Message-ID: <4AD7681C.7060800@linux.vnet.ibm.com>
Date: Thu, 15 Oct 2009 20:21:16 +0200
From: Gerald Schaefer <geralds@linux.vnet.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
       Robert Jennings <rcj@linux.vnet.ibm.com>
CC: gerald.schaefer@de.ibm.com, Mel Gorman <mel@csn.ul.ie>,
       Ingo Molnar <mingo@elte.hu>, Badari Pulavarty <pbadari@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2][v2] powerpc: Make the CMM memory hotplug aware
References: <20091002184458.GC4908@austin.ibm.com> <20091002185248.GD4908@austin.ibm.com> <4ACDD71D.30809@linux.vnet.ibm.com> <20091008131355.GA22118@austin.ibm.com>
In-Reply-To: <20091008131355.GA22118@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jennings wrote:
>>> @@ -110,6 +125,9 @@ static long cmm_alloc_pages(long nr)
>>>  	cmm_dbg("Begin request for %ld pages\n", nr);
>>>
>>>  	while (nr) {
>>> +		if (atomic_read(&hotplug_active))
>>> +			break;
>>> +
>>>  		addr = __get_free_page(GFP_NOIO | __GFP_NOWARN |
>>>  				       __GFP_NORETRY | __GFP_NOMEMALLOC);
>>>  		if (!addr)
>>> @@ -119,8 +137,10 @@ static long cmm_alloc_pages(long nr)
>>>  		if (!pa || pa->index >= CMM_NR_PAGES) {
>>>  			/* Need a new page for the page list. */
>>>  			spin_unlock(&cmm_lock);
>>> -			npa = (struct cmm_page_array *)__get_free_page(GFP_NOIO | __GFP_NOWARN |
>>> -								       __GFP_NORETRY | __GFP_NOMEMALLOC);
>>> +			npa = (struct cmm_page_array *)__get_free_page(
>>> +					GFP_NOIO | __GFP_NOWARN |
>>> +					__GFP_NORETRY | __GFP_NOMEMALLOC |
>>> +					__GFP_MOVABLE);
>>>  			if (!npa) {
>>>  				pr_info("%s: Can not allocate new page list\n", __func__);
>>>  				free_page(addr);
>> Why is the __GFP_MOVABLE added here, for the page list alloc, and not
>> above for the balloon page alloc?
> 
> The pages allocated as __GFP_MOVABLE are used to store the list of pages
> allocated by the balloon.  They reference virtual addresses and it would
> be fine for the kernel to migrate the physical pages for those, the
> balloon would not notice this.

Does page migration really work for kernel pages that were allocated
with __get_free_page()? I was wondering if we can do this on s390, where
we have a 1:1 mapping of kernel virtual to physical addresses, but
looking at migrate_pages() and friends, it seems that kernel pages
w/o mapping and rmap should not be migrateable at all. Any thoughts from
the memory migration experts?

BTW, since we have real memory hotplug support on s390, allowing us
to add and remove memory chunks to/from ZONE_MOVABLE, this basically
makes cmm ballooning in ZONE_NORMAL obsolete, so we decided not to
support memory hotplug aware cmm on s390.

Regards,
Gerald

