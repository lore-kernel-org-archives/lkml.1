Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYDRDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYDRDu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYDRDuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:50:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57283 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYDRDuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:50:21 -0400
Message-ID: <48081A52.8040802@cn.fujitsu.com>
Date: Fri, 18 Apr 2008 11:49:38 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hugh@veritas.com
Subject: Re: [PATCH] memcgroup: check and initialize page->cgroup in memmap_init_zone
References: <48080706.50305@cn.fujitsu.com> <48080930.5090905@cn.fujitsu.com> <48080B86.7040200@cn.fujitsu.com> <20080417201432.36b1c326.akpm@linux-foundation.org> <4808177F.3090208@linux.vnet.ibm.com>
In-Reply-To: <4808177F.3090208@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote::
> Andrew Morton wrote:
>> On Fri, 18 Apr 2008 10:46:30 +0800 Shi Weihua <shiwh@cn.fujitsu.com> wrote:
>>
>>> When we test memory controller in Fujitsu PrimeQuest(arch: ia64),
>>> the compiled kernel boots failed, the following message occured on
>>> the telnet terminal.
>>> -------------------------------------
>>> ..........
>>> ELILO boot: Uncompressing Linux... done
>>> Loading file initrd-2.6.25-rc9-00067-gb87e81e.img...done
>>> _ (system freezed)
>>> -------------------------------------
>>>
>>> We found commit 9442ec9df40d952b0de185ae5638a74970388e01
>>> causes this boot failure by git-bisect.
>>> And, we found the following change caused the boot failure.
>>> -------------------------------------
>>> @@ -2528,7 +2535,6 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zon
>>>                 set_page_links(page, zone, nid, pfn);
>>>                 init_page_count(page);
>>>                 reset_page_mapcount(page);
>>> -               page_assign_page_cgroup(page, NULL);
>>>                 SetPageReserved(page);
>>>
>>>                 /*
>>> -------------------------------------
>>> In this patch, the Author Hugh Dickins said 
>>> "...memmap_init_zone doesn't need it either, ...
>>> Linux assumes pointers in zeroed structures are NULL pointers."
> 
> 
> 
>>> But it seems it's not always the case, so we should check and initialize
>>> page->cgroup anyways.
>>>
> 
> The comment from Hugh is correct, which implies that in this case page->cgroup
> is not zeroed.
> 
>>> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
>>> ---
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 402a504..506d4cf 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -2518,6 +2518,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>>>  	struct page *page;
>>>  	unsigned long end_pfn = start_pfn + size;
>>>  	unsigned long pfn;
>>> +	void *pc;
>>>  
>>>  	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>>>  		/*
>>> @@ -2535,6 +2536,9 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>>>  		set_page_links(page, zone, nid, pfn);
>>>  		init_page_count(page);
>>>  		reset_page_mapcount(page);
>>> +		pc = page_get_page_cgroup(page);
>>> +		if (pc) 
>>> +			page_reset_bad_cgroup(page);
>>>  		SetPageReserved(page);
>>>  
>> hm, fishy.  Perhaps the architecture isn't zeroing the memmap arrays?
>>
> 
> The mem_map array should be cleared. I need to see the code to check where the
> clearing takes place.
> 
>> Or perhaps that page was used and then later freed before we got to
>> memmap_init_zone() and was freed with a non-zero ->page_cgroup.  Which is
>> unlikely given that page.page_cgroup was only just added and is only
>> present if CONFIG_CGROUP_MEM_RES_CTLR.
> 
> Please share your .config? Is this a kexec/kdump reboot by any chance?
> 

.config is shared in previous mails.
kexec/kdump has not been used.

Thanks
-Shi

