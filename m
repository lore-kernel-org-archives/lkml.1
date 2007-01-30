Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbXA3Crs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbXA3Crs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 21:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXA3Crr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 21:47:47 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58210 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbXA3Crr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 21:47:47 -0500
Date: Mon, 29 Jan 2007 18:45:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070130024549.GL1923@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070124210645.GA19650@in.ibm.com> <20070126191113.GA14770@in.ibm.com> <20070126112837.059502fc.akpm@osdl.org> <20070126194622.GA17134@in.ibm.com> <20070126121739.be3e072a.akpm@osdl.org> <20070126204406.GB17134@in.ibm.com> <20070126132949.50544e90.akpm@osdl.org> <20070128224756.GA7672@linux.vnet.ibm.com> <20070128153005.f320b834.akpm@osdl.org> <20070129191241.GB14353@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129191241.GB14353@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 08:12:41PM +0100, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@osdl.org> wrote:
> 
> > > The idea being to essentially suspend the system to RAM, remove the 
> > > CPU and then unsuspend it?  Seems like quite high overhead -- or am 
> > > I misunderstanding the proposal?
> > 
> > The process freezer basically wakes up all threads in the machine and 
> > makes them go to sleep in a specific place, so they're all in a known 
> > state. kernel threads are also captured, via their open-coded polling 
> > call to try_to_freeze().
> > 
> > The machine suspend code uses the process freezer, as does kprobes.  
> > The freezer isn't tied to suspend or to power management.
> > 
> > The freezer does have potential to be expensive if used frequently and 
> > if there are many threads.  But I don't think anyone has looked at 
> > optimising it. [...]
> 
> i've measured it and it takes a few milliseconds typically - certainly 
> not noticeable even for hypothetical highly scripted CPU-hotplug 
> environments. (i doubt they really exist in practice)
> 
> in fact (new) kprobes uses the freezer, and it's far more performance 
> sensitive than the handling of CPU hotplug events.

Outside of realtime workloads, I agree that performance should not be
a problem.  And I don't know of any reason why realtime systems need to
be able to do hotplug CPU.  Yet, anyway.  ;-)

> And there was almost no effort put into making the freezer fast, i'm 
> sure if it ever becomes a problem we could improve it quite drastically. 
> And that effort would improve suspend performance and kprobes 
> performance as well - while the cpu-hotplug locking hell is just an 
> unneeded distraction nobody really can deal with properly. So i say lets 
> ditch CPU hotplug locking completely and lets go for the dead-simple 
> freezer based design ...

I never have seen anyone try a freezer-based approach, so why not?

However, it seems to me that the notifiers are still needed in some form
or another -- for example, RCU needs to manipulate its masks.  My guess
is that you are proposing doing the CPU-down and CPU-up notifications
between the freeze_processes() and the thaw_processes().

Going through the list:

o	migration_call() needs to create a kthread, which can fail,
	so there still needs to be the dual phase bring-up, with
	CPU_ONLINE and CPU_UP_CANCELED.

o	comp_pool_callback() can also fail during CPU_UP_PREPARE,
	as can kernel/softirq.c:cpu_callback(),
	kernel/softlockup.c:cpu_callback(), timer_cpu_notify(),
	ratelimit_handler() [which returns 0 rather than NOTIFY_DONE,
	patch in separate email], pageset_cpuup_callback(), and
	cpuup_callback().

o	The following are unconditional: vmstat_cpuup_callback(),
	sysfs_cpu_notify(), cpu_numa_callback(), hrtimer_cpu_notify(),
	and rcu_cpu_notify().

o	None of the notifier handlers currently say "no" to a CPU
	going down, which is reassuring -- at least given that
	move_task_off_dead_cpu() is willing to forcibly migrate
	if needed.

OK, I indeed do not see any obvious dependencies amoung current CPU
notifier handlers, though the same-order up/down traversal still seems to
me to be an accident waiting to happen.  However, this is independent of
the method to be used to bring CPUs up and down.

And yes, I did in fact suffer severe trauma due to same-order up/down
traversal in a previous life, involving (among other things) CPUs
attempting to do useful work with out-of-date TLBs and attempting to
execute RCU read-side critical sections on CPUs that were no longer
participating in grace-period processing.  Not pretty.  :-/  But I don't
immediately see similar issues in Linux at the moment (with the caveat
that I can't claim to be expert in every area using CPU notifiers), and
if such problems do arise, it is pretty easy to provide reverse-order
down traversal.  The fact that RCU doesn't stop grace-period processing
until CPU_DEAD is at least somewhat comforting to me.  ;-)

So the thought is to make _cpu_down() and _cpu_up() do something like
the following (untested, probably does not even compile), perhaps with
suitable adjustments elsewhere as well?

	static int _cpu_down(unsigned int cpu)
	{
		int err;
		struct task_struct *p;
		cpumask_t old_allowed, tmp;

		if (num_online_cpus() == 1)
			return -EBUSY;

		if (!cpu_online(cpu))
			return -EINVAL;

		if (freeze_processes()) {
			err = -EBUSY;
			goto out_freeze_notify_failed;
		}
		err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
							(void *)(long)cpu);
		if (err == NOTIFY_BAD) {
			printk("%s: attempt to take down CPU %u failed\n",
					__FUNCTION__, cpu);
			err = -EINVAL;
			goto out_freeze_notify_failed;
		}

		/* Ensure that we are not runnable on dying cpu */
		old_allowed = current->cpus_allowed;
		tmp = CPU_MASK_ALL;
		cpu_clear(cpu, tmp);
		set_cpus_allowed(current, tmp);

		mutex_lock(&cpu_bitmask_lock);
		p = __stop_machine_run(take_cpu_down, NULL, cpu);
		mutex_unlock(&cpu_bitmask_lock);

		if (IS_ERR(p) || cpu_online(cpu)) {
			/* CPU didn't die: tell everyone.  Can't complain. */
			if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED,
					(void *)(long)cpu) == NOTIFY_BAD)
				BUG();

			if (IS_ERR(p)) {
				err = PTR_ERR(p);
				goto out_allowed;
			}
			goto out_thread;
		}

		/* Wait for it to sleep (leaving idle task). */
		while (!idle_cpu(cpu))
			yield();

		/* This actually kills the CPU. */
		__cpu_die(cpu);

		/* Move it here so it can run. */
		kthread_bind(p, get_cpu());
		put_cpu();

		/* CPU is completely dead: tell everyone.  Too late to complain. */
		if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD,
				(void *)(long)cpu) == NOTIFY_BAD)
			BUG();

		check_for_tasks(cpu);

	out_thread:
		err = kthread_stop(p);
	out_allowed:
		set_cpus_allowed(current, old_allowed);
	out_freeze_notify_failed:
		thaw_processes();
		return err;
	}

	static int __devinit _cpu_up(unsigned int cpu)
	{
		int ret;
		void *hcpu = (void *)(long)cpu;

		if (cpu_online(cpu) || !cpu_present(cpu))
			return -EINVAL;

		if (freeze_processes()) {
			ret = -EBUSY;
			goto out_freeze_failed;
		}
		ret = raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu);
		if (ret == NOTIFY_BAD) {
			printk("%s: attempt to bring up CPU %u failed\n",
					__FUNCTION__, cpu);
			ret = -EINVAL;
			goto out_notify;
		}

		/* Arch-specific enabling code. */
		mutex_lock(&cpu_bitmask_lock);
		ret = __cpu_up(cpu);
		mutex_unlock(&cpu_bitmask_lock);
		if (ret != 0)
			goto out_notify;
		BUG_ON(!cpu_online(cpu));

		/* Now call notifier in preparation. */
		raw_notifier_call_chain(&cpu_chain, CPU_ONLINE, hcpu);

	out_notify:
		if (ret != 0)
			raw_notifier_call_chain(&cpu_chain,
					CPU_UP_CANCELED, hcpu);

	out_freeze_failed:
		thaw_processes();
		return ret;
	}


							Thanx, Paul
