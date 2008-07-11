Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbYGKUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbYGKUHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYGKUHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:07:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27718 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYGKUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:07:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5337"; a="4646453"
Message-ID: <4877BD66.30802@qualcomm.com>
Date: Fri, 11 Jul 2008 13:07:02 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>	 <6599ad830807111236t2bc9aa02ned59dcc58f14b1bf@mail.gmail.com> <19f34abd0807111243s549b0facvbd0a650358463231@mail.gmail.com>
In-Reply-To: <19f34abd0807111243s549b0facvbd0a650358463231@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, Jul 11, 2008 at 9:36 PM, Paul Menage <menage@google.com> wrote:
>> On Fri, Jul 11, 2008 at 12:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> The result of having CPUSETS enabled as above is a 100% reproducible
>>> BUG on the very first cpu hot-unplug:
>>>
>>> ------------[ cut here ]------------
>>> kernel BUG at xxx/linux-2.6/kernel/sched.c:5859!
>> That doesn't quite match up with any BUG in 2.6.26-rc9 - what tree is
>> this last crash based on?
> 
> latest mainline. Commit e5a5816f7875207cb0a0a7032e39a4686c5e10a4.
> 
> Is this one:
> 
> /* called under rq->lock with disabled interrupts */
> static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
> {
>         struct rq *rq = cpu_rq(dead_cpu);
> 
>         /* Must be exiting, otherwise would be on tasklist. */
>         BUG_ON(!p->exit_state);
> 
>>> Also, this is on the latest linux-2.6.git! Since we're so close to
>>> release, maybe cpusets should simply be marked BROKEN for now? (Unless
>>> we can fix it, of course. The alternative is to apply Miao Xie's
>>> workaround patch temporarily.)
>> If we were going to mark anything as broken, wouldn't cpu-hotplug be
>> the more appropriate victim? I suspect that there are more systems
>> using cpusets in production environments than using cpu hotplug. But
>> as you say, fixing it sounds better.
> 
> I'm sorry for the harsh characterization and suggestion; please accept
> my apology. It was purely a result of my excitement at having made
> some progress in this case.
> 
> But I have more good news; reverting this:
> 
> commit f18f982abf183e91f435990d337164c7a43d1e6d
> Author: Max Krasnyansky <maxk@qualcomm.com>
> Date:   Thu May 29 11:17:01 2008 -0700
> 
>     sched: CPU hotplug events must not destroy scheduler domains created by the
> cpusets
> 
>     First issue is not related to the cpusets. We're simply leaking doms_cur.
>     It's allocated in arch_init_sched_domains() which is called for every
>     hotplug event. So we just keep reallocation doms_cur without freeing it.
>     I introduced free_sched_domains() function that cleans things up.
> 
>     Second issue is that sched domains created by the cpusets are
>     completely destroyed by the CPU hotplug events. For all CPU hotplug
>     events scheduler attaches all CPUs to the NULL domain and then puts
>     them all into the single domain thereby destroying domains created
>     by the cpusets (partition_sched_domains).
>     The solution is simple, when cpusets are enabled scheduler should not
>     create default domain and instead let cpusets do that. Which is
>     exactly what the patch does.
> 
>     Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
>     Cc: pj@sgi.com
>     Cc: menage@google.com
>     Cc: rostedt@goodmis.org
>     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> gets rid of the BUG! (Added people to Ccs.)
Really ? Just by looking at the backtraces in your first email it seems 
unrelated.

> Might I instead suggest a revert of this? (Again, unless somebody else
> can spot the real error and fix it before 2.6.26 is out :-))
I'd actually be ok with reverting it. Paul and I were looking into some 
circular locking issues triggered by the very same patch. Since we do 
not have a solution yet we could revert it for now and work on a fix 
during .27-rc series.

Max


