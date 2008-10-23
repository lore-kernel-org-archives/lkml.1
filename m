Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYJWQew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYJWQew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYJWQel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:34:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54045 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbYJWQek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:34:40 -0400
Date: Thu, 23 Oct 2008 18:35:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081023163517.GB21008@redhat.com>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023143605.GN5255@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Gautham R Shenoy wrote:
>
> On Thu, Oct 23, 2008 at 11:40:36AM +0200, Oleg Nesterov wrote:
> >
> > IOW, I'd suggest
> >
> > 	long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> > 	{
> > 		struct work_for_cpu wfc;
> >
> > 		INIT_WORK(&wfc.work, do_work_for_cpu);
> > 		wfc.fn = fn;
> > 		wfc.arg = arg;
> > 		wfc.ret = -EINVAL;
> >
> > 		get_online_cpus();
> > 		if (likely(cpu_online(cpu))) {
> > 			schedule_work_on(cpu, &wfc.work);
> > 			flush_work(&wfc.work);
> > 		}
>
> OK, how about doing the following? That will solve the problem
> of deadlock you pointed out in patch 6.
>
> 		get_online_cpus();
> 		if (likely(per_cpu(cpu_state, cpuid) == CPU_ONLINE)) {
> 			schedule_work_on(cpu, &wfc.work);
> 			flush_work(&wfc.work);
> 		} else if (per_cpu(cpu_state, cpuid) != CPU_DEAD)) {
> 			/*
> 			 * We're the CPU-Hotplug thread. Call the
> 			 * function synchronously so that we don't
> 			 * deadlock with any pending work-item blocked
> 			 * on get_online_cpus()
> 			 */
> 			 cpumask_t  orignal_mask = current->cpus_allowed;
> 			 set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu);
> 			 wfc.ret = fn(arg);
> 			 set_cpus_allowed_ptr(current, &original_mask);

Not sure I understand...

_cpu_up() does raw_notifier_call_chain(CPU_ONLINE) after __cpu_up(),
at this point per_cpu(cpu_state) == CPU_ONLINE.

(OK, this is not exactly true, start_secondary() updates cpu_online_map
 and only then cpu_state = CPU_ONLINE, but __cpu_up() waits for
 cpu_online(cpu) == T).


Anyway, personally I dislike this special case. We must not use work_on_cpu()
if we hold the lock which can be used by some work_struct, cpu_hotplug is not
special at all.

Oleg.

