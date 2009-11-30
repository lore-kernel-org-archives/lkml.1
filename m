Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZK3DGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZK3DGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZK3DGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:06:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61267 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZK3DGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:06:51 -0500
Message-ID: <4B1335D3.7030807@cn.fujitsu.com>
Date: Mon, 30 Nov 2009 11:02:43 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key
 	offset
References: <4B0E1E2F.9080604@cn.fujitsu.com>	 <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>	 <4B0F2E8F.9090105@cn.fujitsu.com> <4e5e476b0911270016o6a6dfb08q7fefa2858a2ae8e6@mail.gmail.com>
In-Reply-To: <4e5e476b0911270016o6a6dfb08q7fefa2858a2ae8e6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo wrote:
> Hi Guy,
> On Fri, Nov 27, 2009 at 2:42 AM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
>> Corrado Zoccolo wrote:
>>> Hi Gui, Jens
>>> On Thu, Nov 26, 2009 at 7:20 AM, Gui Jianfeng
>>> <guijianfeng@cn.fujitsu.com> wrote:
>>>> Hi Jens, Czoccolo
>>>>
>>>> For the moment, different workload cfq queues are put into different
>>>> service trees. But CFQ still uses "busy_queues" to estimate rb_key
>>>> offset when inserting a cfq queue into a service tree. I think this
>>>> isn't appropriate, and it should make use of service tree count to do
>>>> this estimation. This patch is for for-2.6.33 branch.
>>> In cfq_choose_wl, we rely on consistency of rb_keys across service
>>> trees to compute the next workload to be serviced.
>>>         for (i = 0; i < 3; ++i) {
>>>                 /* otherwise, select the one with lowest rb_key */
>>>                 queue = cfq_rb_first(service_tree_for(prio, i, cfqd));
>>>                 if (queue &&
>>>                     (!key_valid || time_before(queue->rb_key, lowest_key))) {
>>>                         lowest_key = queue->rb_key;
>>>                       cur_best = i;
>>>                       key_valid = true;
>>>               }
>>>         }
>>>
>>> If you change how the rb_key is computed (so it is no longer
>>> consistent across service trees) without changing how it is used can
>>> introduce problems.
>>  Ok, I think I was missing this part. This part still behaves like old CFQ regardless
>>  of workload type. I'm wondering why you prefer starting from sync no-idle only when
>>  priorities switched, after that, you do it like old CFQ behavior?
> 
> When switching priorities (e.g. from RT to BE), we may come from a
> long stall. In this case, I think it is better to run no-idle first.
> During normal operation, instead, we want a fair, starvation free way
> to switch between workloads, and I thought it was simpler to mimic old
> CFQ behaviour, instead of cook up a different method.
> The difference between new and old CFQ is that now, when we decide to
> service one no-idle request, we will then service subsequent ones from
> the same workload type.
> This allows processing them optimally on NCQ hardware.
> Moreover, when no more no-idle requests are available, but the
> timeslice for this workload did not expire yet, we will wait for more.
> This guarantees fairness for no-idle workload.
> 
>>  In order to improve
>>  latency for sync no-idle workload, is it possible to take workload type into account,
>>  not only rely on rb_keys across service trees?
> When loading a program into memory, your process will go through
> various phases w.r.t. disk access pattern: some are seeky, some others
> are sequential.
> 
> If you just improve latency for one workload, penalizing the others,
> you won't get an overall improvement of the system.
> The new scheme improves overall system behaviour because grouping
> no-idle requests together gives a better utilization of the disk, and
> fairness allows also processes making seeky requests to progress.
> Penalizing the idle service tree, instead, you will give you lower
> overall throughput (forbidding progress to the processes that make
> sequential requests), while penalizing writeback you will find
> yourself waiting for freeing dirty pages more often, and maybe
> incurring in OOM conditions.
> 
> Regarding the rb_key computation, I have done various experiments, and
> found that the actual formula doesn't matter much on rotational
> hardware, where the slice length has most importance.
> But I think it is essential on NCQ SSDs, to obtain fairness.
> Unfortunately, I don't have an NCQ SSD, so I can't test my improvement ideas.
> 

Corrado, thanks for the detailed explanation.

Jens, I think Corrado is right, we still need consistency of rb_keys across service
to compute next workload type. So would you revert this patch please?

Thanks,
Gui

