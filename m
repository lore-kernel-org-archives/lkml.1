Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYFTLow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYFTLow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYFTLoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:44:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:20507 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYFTLom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SzmWkhsmiaBmfgZhKH6aWvpZ58WK8Kb5djmOnvV0BBxlYtatSfoIzptdvXV+1QlW44
         KVMB48e9s7saMMHY3AE6T1urfSkme7n636mdkDVEPYVbj1+yRT9jNpnpx2jIncVYt5dM
         shSE5QQkXMoKVIu8LJHgbZennkpbROMvO4VzY=
Message-ID: <b647ffbd0806200444r4df33509wf5f8254aec5a91a2@mail.gmail.com>
Date: Fri, 20 Jun 2008 13:44:41 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] CFS vs cpu hotplug
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080619161949.GA11062@osiris.ibm.com>
	 <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/19 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Thu, 2008-06-19 at 18:19 +0200, Heiko Carstens wrote:
>> Hi Ingo, Peter,
>>
>> I'm still seeing kernel crashes on cpu hotplug with Linus' current git tree.
>> All I have to do is to make all cpus busy (make -j4 of the kernel source is
>> sufficient) and then start cpu hotplug stress.
>> It usually takes below a minute to crash the system like this:
>>
>> Unable to handle kernel pointer dereference at virtual kernel address 005a800000031000
>> Oops: 0038 [#1] PREEMPT SMP
>> Modules linked in:
>> CPU: 1 Not tainted 2.6.26-rc6-00232-g9bedbcb #356
>> Process swapper (pid: 0, task: 000000002fe7ccf8, ksp: 000000002fe93d78)
>> Krnl PSW : 0400e00180000000 0000000000032c6c (pick_next_task_fair+0x34/0xb0)
>
> I presume this is:
>
>                se = pick_next_entity(cfs_rq);
>
>>            R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:3 CC:2 PM:0 EA:3
>> Krnl GPRS: 00000000001ff000 0000000000030bd8 000000000075a380 000000002fe7ccf8
>>            0000000000386690 0000000000000008 0000000000000000 000000002fe7cf58
>>            0000000000000001 000000000075a300 0000000000000000 000000002fe93d40
>>            005a800000031201 0000000000386010 000000002fe93d78 000000002fe93d40
>> Krnl Code: 0000000000032c5c: e3e0f0980024       stg     %r14,152(%r15)
>>            0000000000032c62: d507d000c010       clc     0(8,%r13),16(%r12)
>>            0000000000032c68: a784003c           brc     8,32ce0
>>           >0000000000032c6c: d507d000c030       clc     0(8,%r13),48(%r12)
>>            0000000000032c72: b904002c           lgr     %r2,%r12
>>            0000000000032c76: a7a90000           lghi    %r10,0
>>            0000000000032c7a: a7840021           brc     8,32cbc
>>            0000000000032c7e: c0e5ffffefe3       brasl   %r14,30c44
>> Call Trace:
>> ([<000000000075a300>] 0x75a300)
>>  [<000000000037195a>] schedule+0x162/0x7f4
>>  [<000000000001a2be>] cpu_idle+0x1ca/0x25c
>>  [<000000000036f368>] start_secondary+0xac/0xb8
>>  [<0000000000000000>] 0x0
>>  [<0000000000000000>] 0x0
>> Last Breaking-Event-Address:
>>  [<0000000000032cc6>] pick_next_task_fair+0x8e/0xb0
>>  <4>---[ end trace 9bb55df196feedcc ]---
>> Kernel panic - not syncing: Attempted to kill the idle task!
>>
>> Please note that the above call trace is from s390, however Avi reported the
>> same bug on x86_64.
>>
>> I tried to bisect this and ended up somewhere at the beginning of 2.6.23 when
>> the CFS patches got merged. Unfortunately it got harder and harder to reproduce
>> so that I couldn't bisect this down to a single patch.
>>
>> One observation however is that this always happens after cpu_up(), not
>> cpu_down().
>>
>> I modified the kernel sources a bit (actually only added a single "noinline")
>> to get some sensible debug data and dumped a crashed system. These are the
>> contents of the scheduler data structures which cause the crash:
>>
>> >> px *(cfs_rq *) 0x75a380
>> struct cfs_rq {
>>         load = struct load_weight {
>>                 weight = 0x800
>>                 inv_weight = 0x0
>>         }
>>         nr_running = 0x1
>>         exec_clock = 0x0
>>         min_vruntime = 0xbf7e9776
>>         tasks_timeline = struct rb_root {
>>                 rb_node = (nil)
>>         }
>>         rb_leftmost = (nil)          <<<<<<<<<<<< shouldn't be NULL
>>         tasks = struct list_head {
>>                 next = 0x759328
>>                 prev = 0x759328
>>         }
>>         balance_iterator = (nil)
>>         curr = 0x759300
>>         next = (nil)
>>         nr_spread_over = 0x0
>>         rq = 0x75a300
>>         leaf_cfs_rq_list = struct list_head {
>>                 next = (nil)
>>                 prev = (nil)
>>         }
>>         tg = 0x564970
>> }
>
> Right, this cfs_rq is buggered. rb_leftmost may be null when the tree is
> empty (as is the case here).
>
> However cfs_rq->curr != NULL and cfs_rq->nr_running != 0.
>
> So this hints at a missing put_prev_entity() - we keep current out of
> the tree, and put it back in right before we schedule(). The advantage
> is that we don't need to reposition (dequeue/enqueue) curr in the tree
> every time we update its virtual timeline.
>
> So what races so that we can miss put_prev_entity() and how is cpu_up()
> special..
>

hum, I'd rather suppose that something weird happened at the time of
cpu_down() and some per-cpu data is already inconsistent by the time
of cpu_up().

Is it with CONFIG_USER_SCHED?

Maybe we can write a small function that does a 'sanety' check of :

for all sched_groups (task_groups's) : check 'sanity' of
group->cfs_rq[CPU] and group->se[CPU] somewhere early in cpu_up().

So we can verify whether it's legacy of cpu_down() or something
related to cpu_up().

hm?


-- 
Best regards,
Dmitry Adamushko
