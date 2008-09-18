Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYIRFp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYIRFp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 01:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYIRFpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 01:45:13 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:42612 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbYIRFpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 01:45:12 -0400
Message-ID: <48D1EA9E.9030309@linux.vnet.ibm.com>
Date: Wed, 17 Sep 2008 22:43:58 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, xemul@openvz.org
Subject: Re: [PATCH -mm] memcg: fix handling of shmem migration(v2)
References: <20080917133149.b012a1c2.nishimura@mxp.nes.nec.co.jp> <20080917144659.2e363edc.kamezawa.hiroyu@jp.fujitsu.com> <20080917145003.fb4d0b95.kamezawa.hiroyu@jp.fujitsu.com> <20080917151951.9a181e7d.nishimura@mxp.nes.nec.co.jp> <20080917153826.8efbdc4b.kamezawa.hiroyu@jp.fujitsu.com> <20080917154511.683691d1.nishimura@mxp.nes.nec.co.jp> <20080917165544.3873bbb2.nishimura@mxp.nes.nec.co.jp> <20080917155112.eefd2f8a.akpm@linux-foundation.org> <20080918113851.16082bb7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080918113851.16082bb7.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 17 Sep 2008 15:51:12 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Wed, 17 Sep 2008 16:55:44 +0900
>> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
>>
>>> Before this patch, if migrating shmem/tmpfs pages, newpage would be
>>> charged with PAGE_CGROUP_FLAG_FILE set, while oldpage has been charged
>>> without the flag.
>>>
>>> The problem here is mem_cgroup_move_lists doesn't clear(or set)
>>> the PAGE_CGROUP_FLAG_FILE flag, so pc->flags of the newpage
>>> remains PAGE_CGROUP_FLAG_FILE set even when the pc is moved to
>>> another lru(anon) by mem_cgroup_move_lists. And this leads to
>>> incorrect MEM_CGROUP_ZSTAT.
>>> (In my test, I see an underflow of MEM_CGROUP_ZSTAT(active_file).
>>> As a result, mem_cgroup_calc_reclaim returns very huge number and
>>> causes soft lockup on page reclaim.)
>>>
>>> I'm not sure if mem_cgroup_move_lists should handle PAGE_CGROUP_FLAG_FILE
>>> or not(I suppose it should be used to move between active <-> inactive,
>>> not anon <-> file), I added MEM_CGROUP_CHARGE_TYPE_SHMEM for precharge
>>> at shmem's page migration.
>>>
>>>
>>> ChangeLog: v1->v2
>>> - instead of modifying migrate.c, modify memcontrol.c only.
>>> - add MEM_CGROUP_CHARGE_TYPE_SHMEM.
>>>
>>>
>>> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>>> ---
>>>  mm/memcontrol.c |   13 ++++++++++---
>>>  1 files changed, 10 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 2979d22..ef8812d 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -179,6 +179,7 @@ enum charge_type {
>>>  	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
>>>  	MEM_CGROUP_CHARGE_TYPE_MAPPED,
>>>  	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
>>> +	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
>>>  };
>>>  
>>>  /*
>>> @@ -579,8 +580,10 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
>>>  			pc->flags |= PAGE_CGROUP_FLAG_FILE;
>>>  		else
>>>  			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
>>> -	} else
>>> +	} else if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
>>>  		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
>>> +	else /* MEM_CGROUP_CHARGE_TYPE_SHMEM */
>>> +		pc->flags = PAGE_CGROUP_FLAG_CACHE | PAGE_CGROUP_FLAG_ACTIVE;
>>>  
>>>  	lock_page_cgroup(page);
>>>  	if (unlikely(page_get_page_cgroup(page))) {
>>> @@ -739,8 +742,12 @@ int mem_cgroup_prepare_migration(struct page *page, struct page *newpage)
>>>  	if (pc) {
>>>  		mem = pc->mem_cgroup;
>>>  		css_get(&mem->css);
>>> -		if (pc->flags & PAGE_CGROUP_FLAG_CACHE)
>>> -			ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
>>> +		if (pc->flags & PAGE_CGROUP_FLAG_CACHE) {
>>> +			if (page_is_file_cache(page))
>>> +				ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
>>> +			else
>>> +				ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
>>> +		}
>>>  	}
>>>  	unlock_page_cgroup(page);
>>>  	if (mem) {
>> I queued this as a fix against
>> vmscan-split-lru-lists-into-anon-file-sets.patch.  Was that appropriate?
>>
>> If the bug you're fixing here is also present in mainline then I'll
>> need to ask for a tested patch against mainline, please.
>>
> I think this bug depends on split-lru patch set.
> Mayne not in mainline yet...?

Yes, that sounds correct to me, this should be a -mm only patch.

-- 
	Balbir
