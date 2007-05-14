Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXENGLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXENGLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbXENGK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:10:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36467 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbXENGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:10:57 -0400
Date: Mon, 14 May 2007 11:48:46 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFD] Freezing of kernel threads
Message-ID: <20070514061846.GA30625@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200705122017.32792.rjw@sisk.pl> <20070512193609.GA31426@in.ibm.com> <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org> <20070513083357.GA12985@in.ibm.com> <alpine.LFD.0.98.0705130925290.6739@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705130925290.6739@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 09:33:41AM -0700, Linus Torvalds wrote:
> On Sun, 13 May 2007, Gautham R Shenoy wrote:
> > RFC #1: Use get_hot_cpus()- put_hot_cpus() , which follow the
> > well known refcounting model.
> 
> Yes. And usign the "preempt count" as a refcount is fairly natural, no? 
> We do already depend on that in many code-paths.
> 
> It also has the advantage since it's not a *blocking* lock, [...]

get/put_hot_cpus() was intended to be similar and not same as
get/put_cpu().

One difference is get_hot_cpus() has to be a blocking lock. It has to block 
when there is a cpu_down/up operation already in progress, otherwise it isn't 
of much help to serialize readers/writers. Note that a cpu_down/up is marked in 
progress *before* the first notifier is sent (CPU_DOWN/UP_PREPARE) and not just
when changing the cpu_online_map bitmap.

Because it can be a blocking call, there needs to be associated
machinery to wake up sleeping readers/writers.

The other complication get/put_hotcpu() had was dealing with
write-followed-by-read lock attempt by the *same* thread (whilst doing
cpu_down/up).  IIRC this was triggered by some callback processing in CPU_DEAD 
or CPU_DOWN_PREPARE.


cpu_down()
 |- take write lock 
 |- CPU_DOWN_PREPARE
 |        |- foo() wants a read_lock 

Stupid as it sounds, it was really found to be happening!  Gautham, do you 
recall who that foo() was? Somebody in cpufreq I guess ..

Tackling that requires some state bit in task_struct to educate
read_lock to be a no-op if write lock is already held by the thread.

In summary, get/put_hot_cpu() will need to be (slightly) more complex than
something like get/put_cpu(). Perhaps this complexity was what put off
Andrew when he suggested the use of freezer (http://lkml.org/lkml/2006/11/1/400)

> For example, since all users of cpu_online_map should be pure *readers* 
> (apart from a couple of cases that actually bring up a CPU), you can do 
> things like
> 
> 	#define cpu_online_map check_cpu_online_map()
> 
> 	static inline cpumask_t check_cpu_online_map(void)
> 	{
> 		WARN_ON(!preempt_safe()); /* or whatever lock we decide on */
> 		return __real_cpu_online_map;
> 	}

I remember Rusty had a similar function to check for unsafe references
to cpu_online_map way back when cpu hotplug was being developed. It will
be a good idea to reintroduce that back.

> and it will nicely catch things like that.

-- 
Regards,
vatsa
