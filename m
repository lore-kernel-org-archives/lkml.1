Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbYJXJyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbYJXJyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJXJyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:54:13 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:55018 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYJXJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:54:12 -0400
Date: Fri, 24 Oct 2008 15:23:36 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: do_boot_cpu can deadlock?
Message-ID: <20081024095336.GA17679@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <20081023163517.GB21008@redhat.com> <20081023170212.GA22599@redhat.com> <20081023182119.GA1480@in.ibm.com> <20081023184906.GA2612@localhost> <20081024093342.GA4583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024093342.GA4583@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 11:33:42AM +0200, Oleg Nesterov wrote:
> On 10/23, Cyrill Gorcunov wrote:
> >
> > [Gautham R Shenoy - Thu, Oct 23, 2008 at 11:51:19PM +0530]
> > | On Thu, Oct 23, 2008 at 07:02:12PM +0200, Oleg Nesterov wrote:
> > | > Hmm. arch/x86/kernel/smpboot.c:do_boot_cpu() can deadlock ?
> > | > 
> > | > It is called from _cpu_up() under cpu_hotplug_begin(), and it
> > | > waits for c_idle.work. Again, if we have the pending work which
> > | > needs get_online_cpus() we seem to have problems.
> > | 
> > | Good point. Though this code gets triggered mostly during boot time when
> > | the CPUs are being brought online for the first time. If we have some
> > | work-item pending at that time, which needs get_online_cpus(), we could
> > | possibly see this deadlock.
> > | 
> > | > 
> > | > Oleg.
> > | 
> > | -- 
> > | Thanks and Regards
> > | gautham
> > | 
> > 
> > May I ask? If I understand right we do use this part of do_boot_cpu
> > 
> > 	if (!keventd_up() || current_is_keventd())
> > 		c_idle.work.func(&c_idle.work);
> > 	else {
> > 		schedule_work(&c_idle.work);
> > 		wait_for_completion(&c_idle.done);
> > 	}
> > 
> > if only we've been called the first time after power on. And all
> > subsequent call of this do_boot_cpu would lead to
> > 
> > 	if (c_idle.idle) {
> > 		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
> > 			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
> > 		init_idle(c_idle.idle, cpu);
> > 		goto do_rest;
> > 	}
> > 
> > ie go to do_rest and no wait_for_completion/schedule_work at all.
> > Did I miss something? *Sorry* in advance if the question is quite
> > not related. This work-pending situation is in 'possible' scenario
> > only (ie we don't have such a callers for now... yet)?
> 
> There are no problems during boot time, afaics.
> 
> kernel_init() calls smp_init() before do_basic_setup()->init_workqueues().
> This means that do_boot_cpu() won't use workqueues due to !keventd_up().
> 
> But let's suppose we boot with maxcpus=1, and then bring up another CPU.
> Or we really add the new physical CPU (I don't really know if this is
> possible on x86).

Even I am not sure if physical hotplug is possible.

But think about the virtualization case when we want to add
additional CPU to a KVM guest at runtime? This
is not such a rare use-case. It could dead-lock that time, No?

> 
> Oleg.

-- 
Thanks and Regards
gautham
