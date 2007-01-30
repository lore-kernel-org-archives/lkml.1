Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXA3QrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXA3QrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965612AbXA3QrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:47:24 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:32820 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965606AbXA3QrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:47:23 -0500
Date: Tue, 30 Jan 2007 08:47:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       dipankar@in.ibm.com, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070130164707.GC2092@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070126112837.059502fc.akpm@osdl.org> <20070126194622.GA17134@in.ibm.com> <20070126121739.be3e072a.akpm@osdl.org> <20070126204406.GB17134@in.ibm.com> <20070126132949.50544e90.akpm@osdl.org> <20070128224756.GA7672@linux.vnet.ibm.com> <20070128153005.f320b834.akpm@osdl.org> <20070129191241.GB14353@elte.hu> <20070130024549.GL1923@linux.vnet.ibm.com> <20070130140227.GB7113@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130140227.GB7113@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 07:32:27PM +0530, Gautham R Shenoy wrote:
> On Mon, Jan 29, 2007 at 06:45:49PM -0800, Paul E. McKenney wrote:
> > 
> > 	static int _cpu_down(unsigned int cpu)
> > 	{
> > 		int err;
> > 		struct task_struct *p;
> > 		cpumask_t old_allowed, tmp;
> > 
> > 		if (num_online_cpus() == 1)
> > 			return -EBUSY;
> > 
> > 		if (!cpu_online(cpu))
> > 			return -EINVAL;
> > 
> > 		if (freeze_processes()) {
> > 			err = -EBUSY;
> > 			goto out_freeze_notify_failed;
> > 		}
> > 		err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
> > 							(void *)(long)cpu);
> > 		if (err == NOTIFY_BAD) {
> > 			printk("%s: attempt to take down CPU %u failed\n",
> > 					__FUNCTION__, cpu);
> > 			err = -EINVAL;
> > 			goto out_freeze_notify_failed;
> > 		}
> > 
> > 		/* Ensure that we are not runnable on dying cpu */
> > 		old_allowed = current->cpus_allowed;
> > 		tmp = CPU_MASK_ALL;
> > 		cpu_clear(cpu, tmp);
> > 		set_cpus_allowed(current, tmp);
> > 
> > 		mutex_lock(&cpu_bitmask_lock);
>  
> We won't be needing this lock either, since it forms the core of
> the unpopular lock_cpu_hotplug :-)

;-)

> > 		p = __stop_machine_run(take_cpu_down, NULL, cpu);
> > 		mutex_unlock(&cpu_bitmask_lock);
>  
> Looks good. 
>  
> I'm wondering if we'll need to try_to_freeze in the fork and exit code 
> as well :?

Quite possibly -- if you check into that, I will look at PF_NOFREEZE.

Fair enough?

							Thanx, Paul
