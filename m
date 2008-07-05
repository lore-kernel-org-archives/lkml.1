Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYGEGt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYGEGt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYGEGtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:49:20 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:33464 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYGEGtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:49:20 -0400
Message-ID: <486F1967.1030207@linux.vnet.ibm.com>
Date: Sat, 05 Jul 2008 12:19:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "hugh@veritas.com" <hugh@veritas.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH] memcg: handle shmem's swap cache (Was 2.6.26-rc8-mm1
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <20080704180913.bb1a3fc6.kamezawa.hiroyu@jp.fujitsu.com> <486F0976.7010104@linux.vnet.ibm.com> <20080705151146.206071a4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080705151146.206071a4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sat, 05 Jul 2008 11:11:10 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> My swapcache accounting under memcg patch failed to catch tmpfs(shmem)'s one.
>>> Can I test this under -mm tree ?
>>> (If -mm is busy, I'm not in hurry.)
>>> This patch works well in my box.
>>> =
>>> SwapCache handling fix.
>>>
>>> shmem's swapcache behavior is a little different from anonymous's one and
>>> memcg failed to handle it. This patch tries to fix it.
>>>
>>> After this:
>>>
>>> Any page marked as SwapCache is not uncharged. (delelte_from_swap_cache()
>>> delete the SwapCache flag.)
>>>
>>> To check a shmem-page-cache is alive or not we use
>>>  page->mapping && !PageAnon(page) instead of
>>>  pc->flags & PAGE_CGROUP_FLAG_CACHE.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Though I am not opposed to this, I do sit up and think if keeping the reference
>> count around could avoid this complexity and from my point, the maintenance
>> overhead of this logic/code (I fear there might be more special cases :( )
> 
> yes, to me. but we have to fix..
> 
> But I don't like old code's refcnt handling which does
>    - increment
>      - does this increment was really neccesary ?
>        No? ok, decrement it again.
> 
> This was much more complex to me than current code.
> 

That can be redone -- the moment a page is used by a path, refcnt (increment)
it. Undo the same when the page is no longer in use.

I expect

rmap path to increment/decrement it on mapping
radix-tree (cache's) to do the same


Using a kref we should be able to get this logic right - no?

> And old ones will needs the check at treating swap-cache. (it couldn't but if we want)
> 
>> The trade-off is complexity versus the overhead of reference counting.
>>
> refcnt was also very complex ;)

I think that is easier to simply, instead of adding the complex checks we have
right now. refcnt is easier to prove as working correct than the checks.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
