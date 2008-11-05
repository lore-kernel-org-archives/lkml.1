Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYKEQUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYKEQUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYKEQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:20:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33233 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYKEQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:20:33 -0500
Message-ID: <45571.10.75.179.62.1225902029.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <4911A0FC.9@linux.vnet.ibm.com>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
    <20081101184849.2575.37734.sendpatchset@balbir-laptop>
    <20081102143707.1bf7e2d0.kamezawa.hiroyu@jp.fujitsu.com>
    <490D3E50.9070606@linux.vnet.ibm.com>
    <20081104111751.51ea897b.kamezawa.hiroyu@jp.fujitsu.com>
    <4911A0FC.9@linux.vnet.ibm.com>
Date: Thu, 6 Nov 2008 01:20:29 +0900 (JST)
Subject: Re: [mm] [PATCH 3/4] Memory cgroup hierarchical reclaim
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Paul Menage" <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh said:
>>>>> +	list_for_each_entry_safe_from(cgroup, cg,
>>>>> &cg_current->parent->children,
>>>>> +						 sibling) {
>>>>> +		mem_child = mem_cgroup_from_cont(cgroup);
>>>>> +
>>>>> +		/*
>>>>> +		 * Move beyond last scanned child
>>>>> +		 */
>>>>> +		if (mem_child == mem->last_scanned_child)
>>>>> +			continue;
>>>>> +
>>>>> +		ret = try_to_free_mem_cgroup_pages(mem_child, gfp_mask);
>>>>> +		mem->last_scanned_child = mem_child;
>>>>> +
>>>>> +		if (res_counter_check_under_limit(&mem->res)) {
>>>>> +			ret = 0;
>>>>> +			goto done;
>>>>> +		}
>>>>> +	}
>>>> Is this safe against cgroup create/remove ? cgroup_mutex is held ?
>>> Yes, I thought about it, but with the setup, each parent will be busy
>>> since they
>>> have children and hence cannot be removed. The leaf child itself has
>>> tasks, so
>>> it cannot be removed. IOW, it should be safe against removal.
>>>
>> I'm sorry if I misunderstand something. could you explain folloing ?
>>
>> In following tree,
>>
>>     level-1
>>          -  level-2
>>                 -  level-3
>>                        -  level-4
>> level-1's usage = level-1 + level-2 + level-3 + level-4
>> level-2's usage = level-2 + level-3 + level-4
>> level-3's usage = level-3 + level-4
>> level-4's usage = level-4
>>
>> Assume that a task in level-2 hits its limit. It has to reclaim memory
>> from
>> level-2 and level-3, level-4.
>>
>> How can we guarantee level-4 has a task in this case ?
>
> Good question. If there is no task, the LRU's will be empty and reclaim
> will
> return. We could also add other checks if needed.
>
If needed ?, yes, you need.
The problem is that you are walking a list in usual way without any lock
or guarantee that the list will never be modified.

My quick idea is following.
==
Before start reclaim.
 1. take lock_cgroup()
 2. scan the tree and create "private" list as snapshot of tree to be
    scanned.
 3. unlock_cgroup().
 4. start reclaim.

Adding refcnt to memcg to delay freeing memcg control area is necessary.
(mem+swap controller have function to do this and you may be able to
 reuse it.)

Thanks,
-Kame


