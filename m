Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYE2LSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYE2LSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYE2LSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:18:13 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61543 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYE2LSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:18:12 -0400
Message-Id: <483E9015.4050700@mxp.nes.nec.co.jp>
Date: Thu, 29 May 2008 20:14:29 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] No Reclaim LRU Infrastructure enhancement for memcgroup
References: <1211903642.7283.16.camel@lts-notebook> <20080528101229.f14e0f09.kamezawa.hiroyu@jp.fujitsu.com> <20080528155809.9CD0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <483E155E.9050300@linux.vnet.ibm.com>
In-Reply-To: <483E155E.9050300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/05/29 11:30 +0900, Balbir Singh wrote:
> KOSAKI Motohiro wrote:
>> Hi
>>
>>> In my understanding, 2 checks we have to do.
>>>
>>> 1. When memcg finds PG_noreclaim page in its LRU, move it to noreclaim list of
>>>    memcg.
>>> 2. When PG_noreclaim page is moved back to generic LRU, memcg should move
>>>    it on its list. (we have to add a hook somewhere.)
>>>
>>> But this may break current 'loose' synchronization between global LRU and
>>> memcg's LRU. When PG_noreclaim page is put back into active/inactive LRU ?
>>>
>>> concerns are
>>> A. how to implement '2'
>> I tried to implement it today.
>> this patch is made against "[PATCH -mm 13/16] No Reclaim LRU Infrastructure"
>>
>>
>>> B. race condtions.
>> don't worry :)
>> it isn't big problem.
>>
>> global lru is reclaimbale and memcg lru is noreclaimable
>> 	-> we can repair at move lru of shrink_[in]active_page().
>>
>> global lru is noreclaimbale and memcg lru is reclaimable
>> 	-> we can repair mem_cgroup_isolate_pages()
>>
>>
> 
> I've tried these patches and I still get OOM killed. I'll investigate a bit more.
> 
> 

Hmm... I cannot reporoduce this problem.
When a process exceeds the limit of the group, swap is used as expected.

I tested 2.6.26-rc2-mm1 + splitlru-v8 + Kosaki-san's 3 patches
+ fix for shrink_active_list(attached).

I'm afraid, have you applied rvr-07.1-kosaki-memcg-shrink_list.patch
which Kosaki-san posted to [07/16] of this thread?


Thanks,
Daisuke Nishimura.

---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d58cb5e..6f9f764 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1153,6 +1153,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *
                __mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
        spin_unlock_irq(&zone->lru_lock);

+       pgmoved = 0;
        while (!list_empty(&l_hold)) {
                cond_resched();
                page = lru_to_page(&l_hold);
