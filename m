Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYJWOhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYJWOhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYJWOgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:36:52 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:38686 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYJWOgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:36:51 -0400
Date: Thu, 23 Oct 2008 20:06:05 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081023143605.GN5255@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023094036.GA7593@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 11:40:36AM +0200, Oleg Nesterov wrote:
> On 10/23, Rusty Russell wrote:
> >
> > +long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> > +{
> > +	struct work_for_cpu wfc;
> > +
> > +	INIT_WORK(&wfc.work, do_work_for_cpu);
> > +	init_completion(&wfc.done);
> > +	wfc.fn = fn;
> > +	wfc.arg = arg;
> > +	get_online_cpus();
> > +	if (unlikely(!cpu_online(cpu))) {
> > +		wfc.ret = -EINVAL;
> > +		complete(&wfc.done);
> > +	} else
> > +		schedule_work_on(cpu, &wfc.work);
> 
> I do not claim this is wrong, but imho the code is a bit lisleading and
> needs a comment (or the "fix", please see below).
> 
> Once we drop cpu_hotplug lock, CPU can go away and this work can migrate
> to another cpu.

True.

> 
> > +	put_online_cpus();
> > +	wait_for_completion(&wfc.done);
> 
> Actually you don't need work_for_cpu->done, you can use flush_work().
> 
> IOW, I'd suggest
> 
> 	long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> 	{
> 		struct work_for_cpu wfc;
> 
> 		INIT_WORK(&wfc.work, do_work_for_cpu);
> 		wfc.fn = fn;
> 		wfc.arg = arg;
> 		wfc.ret = -EINVAL;
> 
> 		get_online_cpus();
> 		if (likely(cpu_online(cpu))) {
> 			schedule_work_on(cpu, &wfc.work);
> 			flush_work(&wfc.work);
> 		}

OK, how about doing the following? That will solve the problem
of deadlock you pointed out in patch 6.

		get_online_cpus();
		if (likely(per_cpu(cpu_state, cpuid) == CPU_ONLINE)) {
			schedule_work_on(cpu, &wfc.work);
			flush_work(&wfc.work);
		} else if (per_cpu(cpu_state, cpuid) != CPU_DEAD)) {
			/*
			 * We're the CPU-Hotplug thread. Call the
			 * function synchronously so that we don't
			 * deadlock with any pending work-item blocked
			 * on get_online_cpus()
			 */
			 cpumask_t  orignal_mask = current->cpus_allowed;
			 set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu);
			 wfc.ret = fn(arg);
			 set_cpus_allowed_ptr(current, &original_mask);

		}
> 		put_online_cpus();
> 
> 		return wfc.ret;
> 	}
> 
> Oleg.
> 

-- 
Thanks and Regards
gautham
