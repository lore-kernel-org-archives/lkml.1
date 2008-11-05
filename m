Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYKERyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYKERyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYKERyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:54:06 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51810 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYKERyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:54:04 -0500
Message-ID: <4911DD64.7010508@linux.vnet.ibm.com>
Date: Wed, 05 Nov 2008 23:22:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm][PATCH 0/4] Memory cgroup hierarchy introduction
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop> <20081104091510.01cf3a1e.kamezawa.hiroyu@jp.fujitsu.com> <4911A4D8.4010402@linux.vnet.ibm.com> <50093.10.75.179.62.1225902786.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <50093.10.75.179.62.1225902786.squirrel@webmail-b.css.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Balbir Singh said:
>> KAMEZAWA Hiroyuki wrote:
>>> On Sun, 02 Nov 2008 00:18:12 +0530
>>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>> As first impression, I think hierarchical LRU management is not
>>> good...means
>>> not fair from viewpoint of memory management.
>> Could you elaborate on this further? Is scanning of children during
>> reclaim the
>> issue? Do you want weighted reclaim for each of the children?
>>
> No. Consider follwing case
>    /root/group_root/group_A
>                    /group_B
>                    /group_C
> 
>   sum of group A, B, C is limited by group_root's limit.
> 
>   Now,
>         /group_root limit=1G, usage=990M
>                     /group_A  usage=600M , no limit, no tasks for a while
>                     /group_B  usage=10M  , no limit, no tasks
>                     /group_C  usage=380M , no limit, 2 tasks
> 
>   A user run a new task in group_B.
>   In your algorithm, group_A and B and C's memory are reclaimed
>   to the same extent becasue there is no information to show
>   "group A's memory are not accessed recently rather than B or C".
> 
>   This information is what we want for managing memory.
> 

For that sort of implementation, we'll need a common LRU. I actually thought of
implementing it by sharing a common LRU, but then we would end up with just one
common LRU at the root :)

The reclaim algorithm is smart in that it knows what pages are commonly
accessed. group A will get reclaimed more since those pages are not actively
referenced. reclaim on group_C will be harder. Simple experiments seem to show that.


>>> I'd like to show some other possible implementation of
>>> try_to_free_mem_cgroup_pages() if I can.
>>>
>> Elaborate please!
>>
> ok. but, at least, please add
>   - per-subtree hierarchy flag.
>   - cgroup_lock to walk list of cgroups somewhere.
> 
> I already sent my version "shared LRU" just as a hint for you.
> It is something extreme but contains something good, I think.
> 
>>> Anyway, I have to merge this with mem+swap controller.
>> Cool! I'll send you an updated version.
>>
> 
> Synchronized LRU patch may help you.

Let me get a good working version against current -mm and then we'll integrate
our patches.

-- 
	Balbir
