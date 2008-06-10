Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYFJPhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYFJPhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFJPho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:37:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53272 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYFJPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:37:42 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5313"; a="3811046"
Message-ID: <484E9FE8.9040504@qualcomm.com>
Date: Tue, 10 Jun 2008 08:38:16 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       mingo@elte.hu, menage@google.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch] sched: prevent bound kthreads from changing	cpus_allowed
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>	 <20080605152953.dcfefa47.pj@sgi.com>	 <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>	 <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins>
In-Reply-To: <1213080240.31518.5.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Mon, 2008-06-09 at 13:59 -0700, Max Krasnyanskiy wrote:
>> David Rientjes wrote:
>>>>  2) Sometimes calls to kthread_bind are binding to any online cpu, such as in:
>>>>
>>>> 	drivers/infiniband/hw/ehca/ehca_irq.c:	kthread_bind(cct->task, any_online_cpu(cpu_online_map));
>>>>
>>>>     In such cases, the PF_THREAD_BOUND seems inappropriate.  The caller of
>>>>     kthread_bind() really doesn't seem to care where that thread is bound;
>>>>     they just want it on a CPU that is still online.
>>>>
>>> This particular case is simply moving the thread to any online cpu so that 
>>> it survives long enough for the subsequent kthread_stop() in 
>>> destroy_comp_task().  So I don't see a problem with this instance.
>>>
>>> A caller to kthread_bind() can always remove PF_THREAD_BOUND itself upon 
>>> return, but I haven't found any cases in the tree where that is currently 
>>> necessary.  And doing that would defeat the semantics of kthread_bind() 
>>> where these threads are supposed to be bound to a specific cpu and not 
>>> allowed to run on others.
>> Actually I have another use case here. Above example in particular may be ok 
>> but it does demonstrate the issue nicely. Which is that in some cases kthreads 
>> are bound to a CPU but do not have a strict "must run here" requirement and 
>> could be moved if needed.
>> For example I need an ability to move workqueue threads. Workqueue threads do 
>> kthread_bind().
> 
> Per cpu workqueues should stay on their cpu.
> 
> What you're really looking for is a more fine grained alternative to
> flush_workqueue().
Actually I had a discussion on that with Oleg Nesterov. If you remember my
original solution (ie centralized cpu_isolate_map) was to completely redirect
work onto other cpus. Then you pointed out that it's the flush_() that really
makes the box stuck. So I started thinking about redoing the flush. While
looking at the code I realized that if I only change the flush_() then queued
work can get stale so to speak. ie Machine does not get stuck but some work
submitted on the isolated cpus will sit there for a long time. Oleg pointed
out exact same thing. So the simplest solution that does not require any
surgery to the workqueue is to just move the threads to other cpus. I did not
want to get into too much detail on the workqueue stuff here. I'll start a
separate thread on this.
As I pointed out, there are a bunch of other kthreads like: kswapd, kacpid,
pdflush, khubd, etc, etc, that clearly do not need any pinning but still
violate cpuset constraints they inherit from kthreadd.

Max



