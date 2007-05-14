Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbXENH1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbXENH1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXENH1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:27:43 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44316 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbXENH1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:27:42 -0400
Date: Mon, 14 May 2007 12:56:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFD] Freezing of kernel threads
Message-ID: <20070514072659.GA16236@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705122017.32792.rjw@sisk.pl> <20070512193609.GA31426@in.ibm.com> <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org> <20070513083357.GA12985@in.ibm.com> <alpine.LFD.0.98.0705130925290.6739@woody.linux-foundation.org> <20070514061846.GA30625@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514061846.GA30625@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 11:48:46AM +0530, Srivatsa Vaddagiri wrote:
> 
> The other complication get/put_hotcpu() had was dealing with
> write-followed-by-read lock attempt by the *same* thread (whilst doing
> cpu_down/up).  IIRC this was triggered by some callback processing in CPU_DEAD 
> or CPU_DOWN_PREPARE.
> 
> 
> cpu_down()
>  |- take write lock 
>  |- CPU_DOWN_PREPARE
>  |        |- foo() wants a read_lock 
> 
> Stupid as it sounds, it was really found to be happening!  Gautham, do you 
> recall who that foo() was? Somebody in cpufreq I guess ..

IIRC, it was a problem with ondemand. while handling CPU_DEAD, ondemand code
would call destroy_workqueue, which tried flushing the workqueue, which
once upon a time did lock_cpu_hotplug, before Oleg and Andrew cleaned 
that up. 

Ofcourse, cpufreq works fine now after Venki's patches which
just nullifies the reference to the policy structure of the cpu to be
removed during the CPU_DOWN_PREPARE by calling __cpufreq_remove_dev
instead of handling it in CPU_DEAD.

However, as we have discovered, without freezing all the threads, it
is inadvisable to call flush_workqueue from a cpu-hotplug callback 
path. 

> 
> Tackling that requires some state bit in task_struct to educate
> read_lock to be a no-op if write lock is already held by the thread.
> 

That should not be difficult right?
Since we have only one writer at a time, the task_struct in say
active_writer, and in  the reader slowpath, allow if 
current == active. 

> In summary, get/put_hot_cpu() will need to be (slightly) more complex than
> something like get/put_cpu(). Perhaps this complexity was what put off
> Andrew when he suggested the use of freezer (http://lkml.org/lkml/2006/11/1/400)
> 
> > For example, since all users of cpu_online_map should be pure *readers* 
> > (apart from a couple of cases that actually bring up a CPU), you can do 
> > things like
> > 
> > 	#define cpu_online_map check_cpu_online_map()
> > 
> > 	static inline cpumask_t check_cpu_online_map(void)
> > 	{
> > 		WARN_ON(!preempt_safe()); /* or whatever lock we decide on */
> > 		return __real_cpu_online_map;
> > 	}
> 
> I remember Rusty had a similar function to check for unsafe references
> to cpu_online_map way back when cpu hotplug was being developed. It will
> be a good idea to reintroduce that back.
> 

Yes. However, there are places where people keep a local copy of
the cpu_online_map. So any access to this local copy is also not 
cpu-hotplug safe. No ? 

> > and it will nicely catch things like that.
> 
> -- 
> Regards,
> vatsa

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
