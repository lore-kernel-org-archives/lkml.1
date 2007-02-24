Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbXBXQTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbXBXQTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933521AbXBXQTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:19:12 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:50174 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932844AbXBXQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:19:10 -0500
Date: Sat, 24 Feb 2007 11:19:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: mbligh@google.com, Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070224161906.GA9497@Krystal>
References: <20061124215904.GI25048@Krystal> <1164475747.5196.5.camel@localhost.localdomain> <20061126170542.GA30771@Krystal> <1164561427.16871.14.camel@localhost.localdomain> <20061126231833.GA22241@Krystal> <1164585589.16871.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1164585589.16871.52.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 11:10:20 up 22 days,  6:18,  2 users,  load average: 1.90, 1.48, 1.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to improve the Linux kernel time source so it can be read
without seqlock from NMI handlers. I have also seen some interest for
such an accurate monotonic clock readable from user space. It mainly
implies an atomic update of the time value. I am also trying to figure a
way to support architectures with multiple CPUs with non-synchronized
TSCs.

I would like to have your comments on the following idea.

Thanks in advance,

Mathieu


Monotonic accurate time

The goal of this design is to provide a monotonic time :

Readable from userspace without a system call
Readable from NMI handler
Readable without disabling interrupts
Readable without disabling preemption
Only one clock source (most precise available : tsc)
Support architectures with variable TSC frequency.

Main difference with wall time currently implemented in the Linux kernel : the
time update is done atomically instead of using a write seqlock. It permits
reading time from NMI handler and from userspace.

struct time_info {
	u64 tsc;
	u64 freq;
	u64 walltime;
}

static struct time_struct {
	struct time_info time_sel[2];
	long update_count;
}

DECLARE_PERCPU(struct time_struct, cpu_time);

/* Number of times the scheduler is called on each CPU */
DECLARE_PERCPU(unsigned long, sched_nr);

/* On frequency change event */
/* In irq context */
void freq_change_cb(unsigned int new_freq)
{
	struct time_struct this_cpu_time = 
		per_cpu(cpu_time, smp_processor_id());
	struct time_info *write_time, *current_time;
	write_time =
		this_cpu_time->time_sel[(this_cpu_time->update_count+1)&1];
	current_time =
		this_cpu_time->time_sel[(this_cpu_time->update_count)&1];
	write_time->tsc = get_cycles();
	write_time->freq = new_freq;
	/* We cumulate the division imprecision. This is the downside of using
	 * the TSC with variable frequency as a time base. */
	write_time->walltime = 
		current_time->walltime + 
			(write_time->tsc - current_time->tsc) /
			current_time->freq;
	wmb();
	this_cpu_time->update_count++;
}


/* Init cpu freq */
init_cpu_freq()
{
	struct time_struct this_cpu_time = 
		per_cpu(cpu_time, smp_processor_id());
	struct time_info *current_time;
	memset(this_cpu_time, 0, sizeof(this_cpu_time));
	current_time = this_cpu_time->time_sel[this_cpu_time->update_count&1];
	/* Init current time */
	/* Get frequency */
	/* Reset cpus to 0 ns, 0 tsc, start their tsc. */
}


/* After a CPU comes back from hlt */
/* The trick is to sync all the other CPUs on the first CPU up when they come
 * up. If all CPUs are down, then there is no need to increment the walltime :
 * let's simply define the useful walltime on a machine as the time elapsed
 * while there is a CPU running. If we want, when no cpu is active, we can use
 * a lower resolution clock to somehow keep track of walltime. */

wake_from_hlt()
{
	/* TODO */
}



/* Read time from anywhere in the kernel. Return time in walltime. (ns) */
/* If the update_count changes while we read the context, it may be invalid.
 * This would happen if we are scheduled out for a period of time long enough to
 * permit 2 frequency changes. We simply start the loop again if it happens.
 * We detect it by comparing the update_count running counter.
 * We detect preemption by incrementing a counter sched_nr within schedule(). 
 * This counter is readable by user space through the vsyscall page. */
 */
u64 read_time(void)
{
	u64 walltime;
	long update_count;
	struct time_struct this_cpu_time;
	struct time_info *current_time;
	unsigned int cpu;
	long prev_sched_nr;
	do {
		cpu = _smp_processor_id();
		prev_sched_nr = per_cpu(sched_nr, cpu);
		if(cpu != _smp_processor_id())
			continue;	/* changed CPU between CPUID and getting
					   sched_nr */
		this_cpu_time = per_cpu(cpu_time, cpu);
		update_count = this_cpu_time->update_count;
		current_time = this_cpu_time->time_sel[update_count&1];
		walltime = current_time->walltime + 
				(get_cycles() - current_time->tsc) /
				current_time->freq;
		if(per_cpu(sched_nr, cpu) != prev_sched_nr)
			continue;	/* been preempted */
	} while(this_cpu_time->update_count != update_count);
	return walltime;
}

/* Userspace */
/* Export all this data to user space through the vsyscall page. Use a function
 * like read_time to read the walltime. This function can be implemented as-is
 * because it doesn't need to disable preemption. */




-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
