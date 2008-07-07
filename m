Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYGGK23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYGGK23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYGGK2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:28:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYGGK2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:28:19 -0400
Message-ID: <4871EF49.6000501@cn.fujitsu.com>
Date: Mon, 07 Jul 2008 18:26:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
References: <20080619161949.GA11062@osiris.ibm.com>	 <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com>	 <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>	 <20080630090744.GB6598@osiris.boeblingen.de.ibm.com>	 <20080630091711.GA26637@elte.hu> <4869F770.6050103@cn.fujitsu.com>	 <20080701093124.GC31309@elte.hu> <486B2AB0.1080506@cn.fujitsu.com> <b647ffbd0807020150y650c3172me64b70710a8158d7@mail.gmail.com> <486B490C.3090902@cn.fujitsu.com>
In-Reply-To: <486B490C.3090902@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 3:59 Lai Jiangshan wrote:
> Dmitry Adamushko wrote:
>> 2008/7/2 Lai Jiangshan <laijs@cn.fujitsu.com>:
>>> Ingo Molnar wrote:
>>>> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>>>
>>>>> The following oops still occurred whether this patch is applied or not.
>>>>>  [<ffffffff8059372c>] notifier_call_chain+0x33/0x5b
>>>>>  [<ffffffff802476a9>] __raw_notifier_call_chain+0x9/0xb
>>>>>  [<ffffffff802476ba>] raw_notifier_call_chain+0xf/0x11
>>>>>  [<ffffffff805736d6>] _cpu_down+0x191/0x256
>>>>>  [<ffffffff805737c1>] cpu_down+0x26/0x36
>>>>>  [<ffffffff805749c1>] store_online+0x32/0x75
>>>>>  [<ffffffff803d1982>] sysdev_store+0x24/0x26
>>>>>  [<ffffffff802d2551>] sysfs_write_file+0xe0/0x11c
>>>>>  [<ffffffff80290e6b>] vfs_write+0xae/0x137
>>>>>  [<ffffffff802913d3>] sys_write+0x47/0x70
>>>>>  [<ffffffff8020b1eb>] system_call_after_swapgs+0x7b/0x80
>>>> hm, there were multiple problems in this area and a lot of dormant bugs.
>>>> Do you have this recent upstream commit in your tree:
>>> Hi, Ingo
>>>        I tested it again with the most recent upstreams(including the
>>> following patch) committed, the oops still occurred.
>> [ taken from the oops ]
>>> kernel BUG at kernel/sched.c:6133!
>>>
[snip]
>> We should see then all tasks that have been migrated (or failed to be
>> migrated) during migration_call(CPU_DEAD, ...).
>>
> Thank you. I'll test it again with your debugging patch applied
> and get more info.

I tested it with Dmitry's patch, and found that all the tasks on the offline
cpu were migrated to an online cpu by migrate_live_tasks() in migration_call().
But some tasks(such as klogd and so on)was moved back to the offline cpu
immediately before BUG_ON(rq->nr_running != 0) checking, even before acquiring
rq's lock.

	static int __cpuinit
	migration_call(struct notifier_block *nfb, unsigned long action, void *
	{
		...
		switch (action) {
		...
		case CPU_DEAD:
		case CPU_DEAD_FROZEN:
			cpuset_lock();
			migrate_live_tasks(cpu);
			rq = cpu_rq(cpu);
			...
			spin_lock_irq(&rq->lock);
			...
			migrate_dead_tasks(cpu);
			spin_unlock_irq(&rq->lock);
			cpuset_unlock();
			migrate_nr_uninterruptible(rq);
			BUG_ON(rq->nr_running != 0);
			...
			break;
		}
		...
	}

By debuging, I found this bug was caused by select_task_rq_fair().
After migrating the tasks on the offline cpu to an online cpu, the kernel would
wake up these migrated tasks quickly by try_to_wake_up(). try_to_wake_up() would
invoke select_task_rq_fair() to find a lower-load cpu in sched domains for them.
But the sched domains weren't updated and the offline cpu was still in the sched
domains. So select_task_rq_fair() might return the offline cpu's id, then the
bug occurred.

I fix the bug just by checking the select_task_rq_fair()'s return value in
try_to_wake_up().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 94ead43..15b5ddf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2103,6 +2103,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 		goto out_activate;
 
 	cpu = p->sched_class->select_task_rq(p, sync);
+	if (unlikely(cpu_is_offline(cpu)))
+		cpu = orig_cpu;
+
 	if (cpu != orig_cpu) {
 		set_task_cpu(p, cpu);
 		task_rq_unlock(rq, &flags);
-- 
1.5.4.rc3


