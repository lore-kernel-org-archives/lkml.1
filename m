Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZGYOkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZGYOkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZGYOkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:40:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34751 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZGYOkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:40:19 -0400
Message-ID: <f39a7fd56408054bebd11e40b7dd4db6.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <2f11576a0907250621w3696fdc0pe61638c8c935c981@mail.gmail.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
    <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
    <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
    <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
    <20090724160936.a3b8ad29.akpm@linux-foundation.org>
    <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com>
    <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
    <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
    <2f11576a0907250621w3696fdc0pe61638c8c935c981@mail.gmail.com>
Date: Sat, 25 Jul 2009 23:40:16 +0900 (JST)
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Rientjes" <rientjes@google.com>, lee.schermerhorn@hp.com,
       miaox@cn.fujitsu.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org, menage@google.com, nickpiggin@yahoo.com.au,
       y-goto@jp.fujitsu.com, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> 2009/07/25 12:15 に KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> さんは
> 書きました:
>> KAMEZAWA Hiroyuki wrote:
>>> KAMEZAWA Hiroyuki wrote:
>>> Then, here is a much easier fix. for trusting cpuset more.
>>>
>> just a memo about memory hotplug
>>
>> _Direct_ use of task->mems_allowed is only in cpuset and mempolicy.
>> If no policy is used, it's not checked.
>> (See alloc_pages_current())
>>
>> memory hotplug's notifier just updates top_cpuset's mems_allowed.
>> But it doesn't update each task's ones.
>> Then, task's bahavior is
>>
>>  - tasks which don't use mempolicy will use all nodes, N_HIGH_MEMORY.
>>  - tasks under cpuset will be controlled under their own cpuset.
>>  - tasks under mempolicy will use their own policy.
>>   but no new policy is re-calculated and, then, no new mask.
>>
>> Now, even if all memory on nodes a removed, pgdat just remains.
>> Then, cpuset/mempolicy will never access NODE_DATA(nid) which is NULL.
>
> Umm..
> I don't think this is optimal behavior. but if hotplug guys agree
> this, I agree this too.
>
This behavior itself is not very bad.
And all hotplug thing is just a side story of this bugfix.


To update nodemask,  user's mask should be saved in the policy
even when the mask is not relative and v.node should be calculated
again, at event. IIUC, rather than per-policy update by notifer,
some new implemenation for policy will be necessary.

If you mention about the fact that NODE_DATA(nid) is not removed
at node removal. I have no idea, now. copied zonelist is a problem.


Thanks,
-Kame



