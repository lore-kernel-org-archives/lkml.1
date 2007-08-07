Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbXHGSab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbXHGSab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXHGSaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:30:23 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35252 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXHGSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:30:21 -0400
Message-ID: <46B8BA33.7020800@linux.vnet.ibm.com>
Date: Wed, 08 Aug 2007 00:00:11 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, xemul@openvz.org, menage@google.com,
       balbir@linux.vnet.ibm.com
Subject: Re: [-mm PATCH 6/9] Memory controller add per container LRU and reclaim
 (v4)
References: <20070727201041.31565.14803.sendpatchset@balbir-laptop> <20070731051459.E827E1BF77B@siro.lan> <46AF314C.7030404@linux.vnet.ibm.com>
In-Reply-To: <46AF314C.7030404@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Vaidyanathan Srinivasan wrote:
> 
> YAMAMOTO Takashi wrote:
>>> +unsigned long mem_container_isolate_pages(unsigned long nr_to_scan,
>>> +					struct list_head *dst,
>>> +					unsigned long *scanned, int order,
>>> +					int mode, struct zone *z,
>>> +					struct mem_container *mem_cont,
>>> +					int active)
>>> +{
>>> +	unsigned long nr_taken = 0;
>>> +	struct page *page;
>>> +	unsigned long scan;
>>> +	LIST_HEAD(mp_list);
>>> +	struct list_head *src;
>>> +	struct meta_page *mp;
>>> +
>>> +	if (active)
>>> +		src = &mem_cont->active_list;
>>> +	else
>>> +		src = &mem_cont->inactive_list;
>>> +
>>> +	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
>>> +		mp = list_entry(src->prev, struct meta_page, lru);
>> what prevents another thread from freeing mp here?
> 
> mem_cont->lru_lock protects the list and validity of mp.  If we hold
> mem_cont->lru_lock for this entire loop, then we preserve the validity
> of mp.  However that will be holding up container charge and uncharge.
> 
> This entire routing is called with zone->lru_lock held by the caller.
>  So within a zone, this routine is serialized.
> 
> However page uncharge may race with isolate page.  But will that lead
> to any corruption of the list?  We may be holding the lock for too
> much time just to be on the safe side.
> 
> Please allow us some time to verify whether this is indeed inadequate
> locking that will lead to corruption of the list.

I did few runs and checked for ref_cnt on meta_page and there seems to
be a race between isolate pages and uncharge.  We will probably have
to increase the ref_cnt on meta_page while we are isolating it.  I am
trying to see if we can solve the problem by manipulating the ref_cnt
on the meta_page.

--Vaidy

> Thanks for pointing out this situation.
> --Vaidy
> 
>>> +		spin_lock(&mem_cont->lru_lock);
>>> +		if (mp)
>>> +			page = mp->page;
>>> +		spin_unlock(&mem_cont->lru_lock);
>>> +		if (!mp)
>>> +			continue;
>> YAMAMOTO Takashi
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/containers
>>
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
