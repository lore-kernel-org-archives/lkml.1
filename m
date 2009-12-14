Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZLNJ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZLNJ73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZLNJ72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:59:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64552 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbZLNJ71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:59:27 -0500
Message-ID: <4B260B72.9020204@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 17:54:58 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account when
 	choosing service tree
References: <4B21D252.1060902@cn.fujitsu.com>	 <20091211150727.GB2756@redhat.com>	 <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com>	 <20091211184630.GA7066@redhat.com> <4B25A4F0.60407@cn.fujitsu.com> <4e5e476b0912140039s2f802786t84f53ee62b87c04e@mail.gmail.com>
In-Reply-To: <4e5e476b0912140039s2f802786t84f53ee62b87c04e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo wrote:
> Hi,
> On Mon, Dec 14, 2009 at 3:37 AM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
>> Vivek Goyal wrote:
>>> On Fri, Dec 11, 2009 at 07:01:14PM +0100, Corrado Zoccolo wrote:
>>>> Hi guys,
>>>> On Fri, Dec 11, 2009 at 4:07 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>>>> On Fri, Dec 11, 2009 at 01:02:10PM +0800, Gui Jianfeng wrote:
>>>>>> Currently, with IO Controller introduced, CFQ chooses cfq group
>>>>>> at the top, and then choose service tree. So we need to take
>>>>>> whether cfq group is changed into account to decide whether we
>>>>>> should choose service tree start from scratch.
>>>>>>
>>>>> I am not able to understand the need/purpose of this patch. Once we
>>>>> switched the group during scheduling, why should we reset the order
>>>>> of workload with-in group.
>>>> I understand it, and in fact I was thinking about this.
>>>> The idea is the same as with priorities. If we have not serviced a group
>>>> for a while, we want to start with the no-idle workload to reduce its latency.
>>>>
>>>> Unfortunately, a group may have a too small share, that could cause some
>>>> workloads to be starved, as Vivek correctly points out, and we should
>>>> avoid this.
>>>> It should be easily reproducible testing a "many groups with mixed workloads"
>>>> scenario with group_isolation=1.
>>>>
>>>> Moreover, even if the approach is groups on top, when group isolation
>>>> is not set (i.e. the default), in the non-root groups you will only
>>>> have the sync-idle
>>>> queues, so it is much more similar (logically) to a workload on top
>>>> than it appears
>>>> from the code.
>>>>
>>>> I think the net result of this patch is, when group isolation is not
>>>> set, to select no-idle
>>>> workload first only when entering the root group, thus a slight
>>>> penalization of the
>>>> async workload.
>>> Also penalization of sync-idle workload in root group.
>>>
>>> The higher latencies for sync-noidle workload with-in a group will be
>>> observed only if group_isolation=1 and if group has low weight. I think
>>> in general this problem should be solved by bumping up the weight of the
>>> group, otherwise just live with it to ensure fairness for sync-idle
>>> workload in the group.
>>>
>>> With group_isolation=0, the problem should be less visible as root group
>>> runs with max weight in the system (1000). In general I will assume that
>>> one will choose system weights in such a manner so that root group does
>>> not starve.
>>>
>>>
>>>> Gui, if you observed improvements with this patch, probably you can obtain them
>>>> without the starvation drawback by making it conditional to !group_isolation.
>>>>
>>>> BTW, since you always use cfqg_changed and prio_changed OR-ed together, you
>>>> can have just one argument, called e.g. boost_no_idle, and you pass
>>>> (!group_isolation && cfqg_changed) || prio_changed.
>>>>
>>> Because it will impact the share of sync-idle workload in root group and
>>> asyn workload systemwide, I am not too keen on doing this change. I would
>>> rather rely on root group being higher weight.
>>>
>>> So far this reset of workload order happens only if we decide to higher
>>> prio class task. So if there is some RT activity happening in system, we
>>> will constantly be resetting the workload order for BE class and keep on
>>> servicing sync-noidle workload while starving sync-idle and async
>>> workload.
>>>
>>> So it is probably still ok for priority class switching, but I am not too keen
>>> on doing this at group switching event. This event will be too frequent if
>>> there are significant number of groups in the system and we don't want to
>>> starve root group sync-idle and system wide async workload.
>>>
>>> If somebody is not happy with latecies of sync-noidle workload, then
>>> easier way to solve that issue is readjust weights of groups.
>>>
>>> Thanks
>>> Vivek
>> Hi Vivek, Corrado
>>
>> Thanks for Corrado's explanation, i have the same concern.
>>
>> Consider the following code,
>>
>> prio_changed = (cfqd->serving_prio != previous_prio);
>> st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
>>                        cfqd);
>> count = st->count;
>> /*
>>  * If priority didn't change, check workload expiration,
>>  * and that we still have other queues ready
>>  */
>> if (!prio_changed && count &&
>>      !time_after(jiffies, cfqd->workload_expires))
>>      return;
>>
>> One more thing i do this change is that currently if serving_prio isn't changed,
>> we'll start from where we left. But with io group introduced, cfqd->serving_prio and
>> previous_prio might come from different groups. So i don't think "prio_changed" still
>> makes sense in the case of group changing.
> Probably it is better to just remove the priority change concept. The
> code will be simpler, and the impact should be very small.
>> cfqd->workload_expires also might come from
>> the workload from another group when deciding whether starting from "cfqd->serving_type".
> This shouldn't happen, since Vivek is saving&restoring the workload
> parameters at each group change. So it is likely that the workload
> will be expired here, and we compute the new workload when entering
> the new group.

Currently, IIUC, only the workload that didn't use up its slice will be saved, and only 
such workloads are restoring when a group is resumed. So sometimes, we'll still get the
previous serving_type and workload_expires. Am i missing something?


> 
> I have one more concern, though.
> RT priority has now changed meaning. Before, an RT task would always
> have priority access to the disk. Now, a BE task in a different group,
> with lower weight, can steal the disk from the RT task.
> A way to preserve the old meaning is to consider wheter a group has RT
> tasks inside when sorting groups tree, and putting those groups at the
> front.
> Usually, RT tasks will be put in the root group, and this (if
> group_isolation=0) will automatically make sure that also the noidle
> workload gets serviced quickly after RT tasks release the disk. We
> could even enforce that, with group_isolation=0, all RT tasks are put
> in the root group.
> 
> The rationale behind this suggestion is that groups are for user
> processes, while RT is system wide, since it is only root that can
> grant it.

  I agree, and one more thing, currently we can't see fairness between different
  idle tasks in different groups. Because we only allow idle cfqq dispatch one request
  for its dispatch round even if it's the only task in the cgroup, group always loose it
  share. So whether we can rely on group_isolation, when group_isolation == 1 we provide
  isolation for idle tasks.

Thanks
Gui


