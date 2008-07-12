Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYGLTTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYGLTTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 15:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYGLTTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 15:19:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58948 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYGLTTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 15:19:21 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5337"; a="4492401"
Message-ID: <487903BA.9050103@qualcomm.com>
Date: Sat, 12 Jul 2008 12:19:22 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <20080712031736.GA3040@damson.getinternet.no>	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
In-Reply-To: <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2008/7/12 Linus Torvalds <torvalds@linux-foundation.org>:
>>
>> On Sat, 12 Jul 2008, Vegard Nossum wrote:
>>> Can somebody else please test/ack/review it too? This should eventually
>>> go into 2.6.26 if it doesn't break anything else.
>> And Dmitry, _please_ also explain what was going on. Why did things break
>> from calling common_cpu_mem_hotplug_unplug() too much? That function is
>> called pretty randomly anyway (for just about any random CPU event), so
>> why did it fail in some circumstances?
> 
> Upon CPU_DOWN_PREPARE, update_sched_domains() ->
> detach_destroy_domains(&cpu_online_map) ;
> does the following:
> 
> /*
>  * Force a reinitialization of the sched domains hierarchy. The domains
>  * and groups cannot be updated in place without racing with the balancing
>  * code, so we temporarily attach all running cpus to the NULL domain
>  * which will prevent rebalancing while the sched domains are recalculated.
>  */
> 
> The sched-domains should be rebuilt when a CPU_DOWN ops. is completed,
> effectivelly either upon CPU_DEAD{_FROZEN} (upon success) or
> CPU_DOWN_FAILED{_FROZEN} (upon failure -- restore the things to their
> initial state). That's what update_sched_domains() also does but only
> for !CPUSETS case.
> 
> With Max's patch, sched-domains' reinitialization is delegated to CPUSETS code:
> 
> cpuset_handle_cpuhp() -> common_cpu_mem_hotplug_unplug() ->
> rebuild_sched_domains()
> 
> which as you've said "called pretty randomly anyway", e.g. for CPU_UP_PREPARE.
> 
> [ ah, then rebuild_sched_domains() should not be there. It should be
> nop for MEMPLUG events I presume - should make another patch. ]
> 
> Being called for CPU_UP_PREPARE (and if its callback is called after
> update_sched_domains()), it just negates all the work done by
> update_sched_domains() -- i.e. a soon-to-be-offline cpu is included in
> the sched-domains and that makes it visible for the load-balancer
> while the CPU_DOWN ops. is in progress.
> 
> __migrate_live_tasks() moves the tasks off a 'dead' cpu (it's already
> "offline" when this function is called).
> 
> try_to_wake_up() is called for one of these tasks from another CPU ->
> the load-balancer (wake_idle()) picks up a "dead" CPU and places the
> task on it. Then e.g. BUG_ON(rq->nr_running) detects this a bit later
> -> oops.
Ah, makes sense. Thanx for the explanation.

> Now another funny thing is that we probably have a memory leak with
> common_cpu_mem_hotplug_unplug() "randomly" calling
> rebuild_sched_domains() and sometimes re-allocating domains when they
> already exist.
I beleive that part is ok. We used to have a leak in the scheduler code where
arch_init_sched_domains() just allocated new masks without freeing the old
ones. I fixed that. rebuild_sched_domains() -> partition_sched_domains() is
clean (I think). partition_sched_domains() first does the cleanup and then
takes ownership of the domain masks.

btw It's perfectly ok (or at least it has be ok) to call
rebuild_sched_domains() randomly because it's need to run every time
sched_load_balance flags in the cpuset change, and on any other even that
affects domains. As Paul J explained currently that's the only sane way to
reconstruct the domains based on the cpuset settings.

Max
