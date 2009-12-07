Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZLGKeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZLGKeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZLGKeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:34:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:42195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZLGKeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:34:13 -0500
Message-ID: <4B1CDA1C.3000802@kernel.org>
Date: Mon, 07 Dec 2009 19:34:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
In-Reply-To: <1260174900.8223.1159.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/07/2009 05:35 PM, Peter Zijlstra wrote:
>> * PF_THREAD_BOUND.  This is used to mark tasks which are bound to a
>>   cpu using kthread_bind() to be bound permanently.  However, new
>>   trustee based workqueue hotplugging decouples per-cpu workqueue
>>   flushing with cpu hot plug/unplugging.  This is necessary because
>>   with cmwq, long running works can be served by regular workqueues,
>>   so delaying completion of hot plug/unplugging till certain works are
>>   flushed isn't feasible.  So, what becomes necessary is the ability
>>   to re-bind tasks which has PF_THREAD_BOUND set but unbound from its
>>   now offline cpu which is coming online again.
> 
> I'm not at all sure I like that. I'd be perfectly happy with delaying
> the hot-unplug.
> 
> The whole cpu hotplug mess is tricky enough as it is and I see no
> compelling reason to further complicate it. If people are really going
> to enqueue strict per-cpu worklets (queue_work_on()) that takes seconds
> to complete, then they get to keep the results of that, which includes
> slow hot unplug.
> 
> Having an off-line cpu still process code like it was online is asking
> for trouble, don't go there.

We're already there.  Users of workqueue which require strict CPU
affinity are required to flush respective works from CPU down
notifiers and fire them as necessary on up notifiers; otherwise, works
will continue to run until they're done after the cpu went down
regardless of whether explicit queue_work_on() was used or not.

The only difference is that now the ability to create new workers is
necessary to guarantee forward progress while cpu is going down, so
it's not that different from what we're doing now.

>>   Another related problem is that there's no way to monitor the cpu
>>   activeness change notifications.
> 
> cpu_active() is basically meant for the scheduler to not stick new tasks
> on a dying cpu.
> 
> So on hot-unplug you'd want to splice your worklets to another cpu,
> except maybe those strictly enqueued to the dying cpu, and since there
> was work on the dying cpu, you already had a task processing them, so
> you don't need new tasks, right?

We need to be able to fork to guarantee forward progress at any point
which means that to guarantee flush_work() or flush_workqueue() from
cpu down notification doesn't block indefinitely, we need to be able
to create new workers after cpu_active() is clear.

Thanks.

-- 
tejun
