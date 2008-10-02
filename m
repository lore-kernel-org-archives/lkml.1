Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYJBWz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYJBWz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYJBWzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:55:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33397 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYJBWzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:55:47 -0400
Date: Thu, 2 Oct 2008 15:55:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, laijs@cn.fujitsu.com,
       manfred@colorfullife.com, dipankar@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, josht@linux.vnet.ibm.com,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH,RFC] RCU-based detection of stalled CPUs for Classic
	RCU (LTTng support)
Message-ID: <20081002225537.GA6706@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081002003628.GA7877@linux.vnet.ibm.com> <20081002080726.GB17695@elte.hu> <20081002140507.GB6729@linux.vnet.ibm.com> <20081002151046.GB2473@Krystal> <20081002174318.GB7324@linux.vnet.ibm.com> <20081002185115.GA11047@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002185115.GA11047@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 02:51:15PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Oct 02, 2008 at 11:10:46AM -0400, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Thu, Oct 02, 2008 at 10:07:26AM +0200, Ingo Molnar wrote:
> > > > > 
> > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > Hello!
> > > > > > 
> > > > > > This patch adds stalled-CPU detection to Classic RCU.  This capability 
> > > > > > is enabled by a new config variable CONFIG_RCU_CPU_STALL_DETECTOR, 
> > > > > > which defaults disabled.  This is a debugging feature, not something 
> > > > > > that non-kernel-hackers would be expected to care about.  This feature 
> > > > > > can detect looping CPUs in !PREEMPT builds and looping CPUs with 
> > > > > > preemption disabled in PREEMPT builds.  This is essentially a port of 
> > > > > > this functionality from the treercu patch.
> > > > > > 
> > > > > > One current shortcoming: on some systems, stalls are detected during 
> > > > > > early boot, when we normally would not care about them.  My thought is 
> > > > > > to add a call from late initialization to suppress stall detection 
> > > > > > until the system is well along its way to being booted, but thought I 
> > > > > > should check to see if there might already be something for this 
> > > > > > purpose.
> > > > > 
> > > > > could you be a bit more specific, why do those warnings show up and why 
> > > > > dont we care about them? There are things like networking that 
> > > > > occasionally do an rcu_sync() and a stall could mean a bootup hang.
> > > > 
> > > > Hmmm...
> > > > 
> > > > Good point, I was just falling back on my old "we don't care about RCU
> > > > stalls in boot-time code" rule from long ago.  It is entirely possible
> > > > (in fact reasonably likely) that this rule no longer applies to Linux as
> > > > it exists today.  So please see below for the console output.  Not all
> > > > systems report this stall.  I have recently been running only on Power
> > > > systems, will fire off on some x86s.  My kneejerk reaction was that the
> > > > "stall" was really due to the clock-setting operation -- RCU stalls are
> > > > based on get_seconds().
> > > > 
> > > > So maybe I need to change the stall-detection code to use jiffies
> > > > instead.
> > > > 
> > > > Thoughts?
> > > > 
> > > 
> > > You could possibly use get monotonic time, which should hopefully be a
> > > bit better than its NTP-corrected alternatives.
> > 
> > OK.  I thought jiffies were monotonic (though not perfectly correlated
> > to the passage of time).  This is a warning timeout, so does not need
> > better than a few percent accuracy, as long as time never jumps too far.
> > 
> 
> Well, jiffies should also be monotonic, but I don't know their exact
> status wrt dyntick systems.

There will be at least one non-dyntick CPU if there are RCU callbacks
pending.  If there are no RCU callbacks pending, then RCU won't be
doing anything, hence will not be detecting stalls.

> > But what API did you have in mind?
> > 
> 
> Something like do_posix_clock_monotonic_gettime() in linux/time.h. I
> think it should be ok after early boot.

I like jiffies for this non-super-exacting purpose.  ;-)

> > > Also, do you have all the tools you need to poinpoint the precise source
> > > of RCU stalls ? I haven't looked at RCU trace, but I should say adding a
> > > new tracepoint to instrument RCU callback execution at boot time and to
> > > trace it with LTTng is close to trivial. (actually, very early kernel
> > > boot is not so trivial as we would have to create a small kernel module
> > > to activate lttng tracing, but tracing the early phases of userspace
> > > bootup is trivial given we can use the userspace API).
> > 
> > I just dump stack, which historically worked pretty well.
> > 
> > Could you please tell me more about what you think should be added?
> > 
> 
> I just created two patches which instrument RCU callbacks and call_rcu
> in classic and preempt RCU to the -lttng tree to show how simple it is
> once the LTTng infrastructure is in place.

OK, I think I see the disconnection here...

When RCU detects a stall, that often indicates that some CPU is spinning
in the kernel (for !CONFIG_PREEMPT) or that some CPU is spinning in the
kernel with preemption disabled (for CONFIG_PREEMPT).  The stack trace
will normally show what is spinning.

Tracing the RCU activity in this case will not help -- it is not RCU that
is spinning, but rather that RCU is stalled waiting for some other part
of the kernel that is spinning.  (In a past life, RCU once complained
about a specific CPU that had managed to fail in a way that left the
system running!  Except that RCU grace periods never ended...)

FWIW, what I normally use for debugging RCU itself is counters rather
than log messages.  The reason I avoid log messages is that the race
conditions I often find myself chasing are reasonably narrow, so that
I would have a very large number of log messages to pile through.
Nevertheless, I will keep track of these patches in case I come across
some situation that is more friendly to log-based debugging -- and thank
you for putting them together!!!

							Thanx, Paul

> Basically, all you need to do is to pull this tree (branch
> 2.6.27-rc8-lttng-0.31) :
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git
> 
> And follow :
> http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART
> 
> Which will basically tell you to enable markers/tracepoints and leave
> most ltt-related options to default (all in general setup menu).
> 
> wget http://ltt.polymtl.ca/lttng/ltt-control-0.53-02102008.tar.gz
> extract, ./configure, make, make install
> 
> wget http://ltt.polymtl.ca/packages/lttv-0.10.0-pre15-12082008.tar.gz
> extract, ./configure, make, make install
> (see QUICKSTART for package dependencies. Will be automatically checked
> by configure)
> 
> You may have to add a mount point for debugfs and load some kernel
> modules (as explained in the QUICKSTART). Don't forget rcu-trace.ko.
> 
> To take a trace, once you are booted in the kernel :
> 
> ltt-armall
> (check that the rcu_* markers are enabled by looking at the "state"
> field of cat /proc/ltt | grep rcu)
> lttctl -n trace -d -l /mnt/debugfs/ltt -t /tmp/trace
> [Reproduce behavior to trace]
> lttctl -n trace -R
> # Produce a text dump
> lttv -m textDump -t /tmp/trace
> 
> # Produce a text dump filtering only rcu events :
> lttv -m textDump -t /tmp/trace \
>   -e "event.name=rcu_classic_callback|event.name=rcu_classic_call_rcu|\
> event.name=rcu_classic_call_rcu_bh|event.name=rcu_preempt_callback|\
> event.name=rcu_preempt_call_rcu_sched|event.name=rcu_preempt_call_rcu"
> 
> Then some scripting could be required to turn the function pointers into
> symbols. Keep you kernel vmlinux around to perform symbol resolution.
> A quick trick is to use objdump -S --start-address=0x.... vmlinux|less
> but I am certain there are much much better ways to do it. ;)
> 
> There is also the gui you can use to dig into the trace :
> lttv-gui -t /tmp/trace
> 
> That should help you pinpoint which are the functions that took so much
> time and which is their associated call_rcu caller IP.
> 
> If you run a trace with preempt rcu, the textdump should give you an
> output like this :
> 
> [...]
> rcu_preempt_call_rcu: 130.773191675 (/tmp/trace/cpu_5), 3977, 3977, lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AE105 }
> rcu_preempt_call_rcu: 130.773194003 (/tmp/trace/cpu_5), 3977, 3977, lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AE105 }
> rcu_preempt_call_rcu: 130.773195929 (/tmp/trace/cpu_5), 3977, 3977, lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AE105 }
> rcu_preempt_call_rcu: 130.773197399 (/tmp/trace/cpu_5), 3977, 3977, lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AE105 }
> rcu_preempt_call_rcu: 130.773200429 (/tmp/trace/cpu_5), 3977, 3977, lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802c6670, ip = 0xFFFFFFFF8023A45B }
> rcu_preempt_call_rcu: 130.773213907 (/tmp/trace/cpu_5), 3961, 3961, bash, , 3960, 0x0, SYSCALL { func = 0xffffffff8024a980, ip = 0xFFFFFFFF8023937D }
> rcu_preempt_call_rcu: 130.773215527 (/tmp/trace/cpu_5), 3961, 3961, bash, , 3960, 0x0, SYSCALL { func = 0xffffffff80238550, ip = 0xFFFFFFFF80239985 }
> rcu_preempt_callback: 130.789025735 (/tmp/trace/cpu_2), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 130.789026731 (/tmp/trace/cpu_2), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 130.789050610 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 130.789051096 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802c6670 }
> rcu_preempt_callback: 130.789052083 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff8024a980 }
> rcu_preempt_callback: 130.789052713 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff80238550 }
> rcu_preempt_callback: 130.805051097 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 130.805052318 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 130.805052822 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 130.805053434 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 130.805054226 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802c6670 }
> rcu_preempt_callback: 130.805055339 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff8024a980 }
> rcu_preempt_callback: 130.805056014 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff80238550 }
> rcu_preempt_call_rcu: 131.442990122 (/tmp/trace/cpu_7), 3685, 3685, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_call_rcu: 131.443615323 (/tmp/trace/cpu_6), 3687, 3687, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_call_rcu: 131.446861604 (/tmp/trace/cpu_7), 3683, 3683, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_call_rcu: 131.447487425 (/tmp/trace/cpu_5), 3681, 3681, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_callback: 131.473052317 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 131.473078626 (/tmp/trace/cpu_6), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 131.477001607 (/tmp/trace/cpu_7), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 131.477002435 (/tmp/trace/cpu_7), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_call_rcu: 133.443017217 (/tmp/trace/cpu_5), 3681, 3681, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_call_rcu: 133.443636900 (/tmp/trace/cpu_6), 3687, 3687, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_call_rcu: 133.446887423 (/tmp/trace/cpu_7), 3683, 3683, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_call_rcu: 133.447509515 (/tmp/trace/cpu_7), 3685, 3685, hald-addon-stor, , 3634, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AA8D9 }
> rcu_preempt_callback: 133.473044696 (/tmp/trace/cpu_5), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 133.473070649 (/tmp/trace/cpu_6), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 133.476994292 (/tmp/trace/cpu_7), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_callback: 133.476994961 (/tmp/trace/cpu_7), 0, 0, swapper, , 0, 0x0, SOFTIRQ { func = 0xffffffff802addc0 }
> rcu_preempt_call_rcu: 134.085511140 (/tmp/trace/cpu_5), 3961, 3961, bash, , 3960, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AE105 }
> rcu_preempt_call_rcu: 134.085545237 (/tmp/trace/cpu_5), 3981, 3981, bash, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AE105 }
> rcu_preempt_call_rcu: 134.086124869 (/tmp/trace/cpu_2), 3981, 3981, ./lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802B8E2D }
> rcu_preempt_call_rcu: 134.086135078 (/tmp/trace/cpu_2), 3981, 3981, ./lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802B8E2D }
> rcu_preempt_call_rcu: 134.086143519 (/tmp/trace/cpu_2), 3981, 3981, ./lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802B8E2D }
> rcu_preempt_call_rcu: 134.086206323 (/tmp/trace/cpu_2), 3981, 3981, ./lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802B8E2D }
> rcu_preempt_call_rcu: 134.086526166 (/tmp/trace/cpu_2), 3981, 3981, ./lttctl, , 3961, 0x0, SYSCALL { func = 0xffffffff802addc0, ip = 0xFFFFFFFF802AE105 }
> [...]
> 
> Basically, once you have the LTTng infrastructure in place, all that
> needs to be added to RCU to do that is this (which is already in the
> -lttng tree), plus a small LTTng "probe" module. If you want, you could
> add a tracepoint in your stalled CPU detector and send the data through
> LTTng so you have a starting point to dig from in large traces. From
> that point, finding the root cause of long RCU-based CPU stalls becomes
> trivial.
> 
> 
> RCU : tracepoint instrumentation
> 
> Instrument RCU classic and RCU preempt callback execution and call_rcu.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> ---
>  include/trace/rcu.h |   31 +++++++++++++++++++++++++++++++
>  kernel/rcuclassic.c |    4 ++++
>  kernel/rcupreempt.c |    4 ++++
>  3 files changed, 39 insertions(+)
> 
> Index: linux-2.6-lttng/include/trace/rcu.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/trace/rcu.h	2008-10-02 14:18:05.000000000 -0400
> @@ -0,0 +1,31 @@
> +#ifndef _TRACE_RCU_H
> +#define _TRACE_RCU_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/rcupdate.h>
> +
> +DEFINE_TRACE(rcu_classic_callback,
> +	TPPROTO(struct rcu_head *head),
> +	TPARGS(head));
> +
> +DEFINE_TRACE(rcu_classic_call_rcu,
> +	TPPROTO(struct rcu_head *head, unsigned long ip),
> +	TPARGS(head, ip));
> +
> +DEFINE_TRACE(rcu_classic_call_rcu_bh,
> +	TPPROTO(struct rcu_head *head, unsigned long ip),
> +	TPARGS(head, ip));
> +
> +DEFINE_TRACE(rcu_preempt_callback,
> +	TPPROTO(struct rcu_head *head),
> +	TPARGS(head));
> +
> +DEFINE_TRACE(rcu_preempt_call_rcu,
> +	TPPROTO(struct rcu_head *head, unsigned long ip),
> +	TPARGS(head, ip));
> +
> +DEFINE_TRACE(rcu_preempt_call_rcu_sched,
> +	TPPROTO(struct rcu_head *head, unsigned long ip),
> +	TPARGS(head, ip));
> +
> +#endif
> Index: linux-2.6-lttng/kernel/rcuclassic.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/rcuclassic.c	2008-10-02 13:44:35.000000000 -0400
> +++ linux-2.6-lttng/kernel/rcuclassic.c	2008-10-02 14:16:45.000000000 -0400
> @@ -47,6 +47,7 @@
>  #include <linux/notifier.h>
>  #include <linux/cpu.h>
>  #include <linux/mutex.h>
> +#include <trace/rcu.h>
> 
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  static struct lock_class_key rcu_lock_key;
> @@ -138,6 +139,7 @@ void call_rcu(struct rcu_head *head,
>  	head->func = func;
>  	head->next = NULL;
>  	local_irq_save(flags);
> +	trace_rcu_classic_call_rcu(head, _RET_IP_);
>  	rdp = &__get_cpu_var(rcu_data);
>  	*rdp->nxttail = head;
>  	rdp->nxttail = &head->next;
> @@ -174,6 +176,7 @@ void call_rcu_bh(struct rcu_head *head,
>  	head->func = func;
>  	head->next = NULL;
>  	local_irq_save(flags);
> +	trace_rcu_classic_call_rcu_bh(head, _RET_IP_);
>  	rdp = &__get_cpu_var(rcu_bh_data);
>  	*rdp->nxttail = head;
>  	rdp->nxttail = &head->next;
> @@ -232,6 +235,7 @@ static void rcu_do_batch(struct rcu_data
>  	while (list) {
>  		next = list->next;
>  		prefetch(next);
> +		trace_rcu_classic_callback(list);
>  		list->func(list);
>  		list = next;
>  		if (++count >= rdp->blimit)
> Index: linux-2.6-lttng/kernel/rcupreempt.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/rcupreempt.c	2008-10-02 13:53:41.000000000 -0400
> +++ linux-2.6-lttng/kernel/rcupreempt.c	2008-10-02 14:15:47.000000000 -0400
> @@ -57,6 +57,7 @@
>  #include <linux/byteorder/swabb.h>
>  #include <linux/cpumask.h>
>  #include <linux/rcupreempt_trace.h>
> +#include <trace/rcu.h>
> 
>  /*
>   * Macro that prevents the compiler from reordering accesses, but does
> @@ -1108,6 +1109,7 @@ static void rcu_process_callbacks(struct
>  	spin_unlock_irqrestore(&rdp->lock, flags);
>  	while (list) {
>  		next = list->next;
> +		trace_rcu_preempt_callback(list);
>  		list->func(list);
>  		list = next;
>  		RCU_TRACE_ME(rcupreempt_trace_invoke);
> @@ -1122,6 +1124,7 @@ void call_rcu(struct rcu_head *head, voi
>  	head->func = func;
>  	head->next = NULL;
>  	local_irq_save(flags);
> +	trace_rcu_preempt_call_rcu(head, _RET_IP_);
>  	rdp = RCU_DATA_ME();
>  	spin_lock(&rdp->lock);
>  	__rcu_advance_callbacks(rdp);
> @@ -1141,6 +1144,7 @@ void call_rcu_sched(struct rcu_head *hea
>  	head->func = func;
>  	head->next = NULL;
>  	local_irq_save(flags);
> +	trace_rcu_preempt_call_rcu_sched(head, _RET_IP_);
>  	rdp = RCU_DATA_ME();
>  	spin_lock(&rdp->lock);
>  	*rdp->nextschedtail = head;
> 
> The LTTng probe module looks like this :
> 
> 
> LTTng trace RCU probe
> 
> RCU callback/call_rcu LTTng probe.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> ---
>  ltt/probes/Makefile    |    2 -
>  ltt/probes/rcu-trace.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/ltt/probes/rcu-trace.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/ltt/probes/rcu-trace.c	2008-10-02 14:23:17.000000000 -0400
> @@ -0,0 +1,54 @@
> +/*
> + * ltt/probes/rcu-trace.c
> + *
> + * RCU tracepoint probes.
> + */
> +
> +#include <linux/module.h>
> +#include <trace/rcu.h>
> +
> +#ifdef CONFIG_CLASSIC_RCU
> +void probe_rcu_classic_callback(struct rcu_head *head)
> +{
> +	trace_mark_tp(rcu_classic_callback, rcu_classic_callback,
> +		probe_rcu_classic_callback, "func %p", head->func);
> +}
> +
> +void probe_rcu_classic_call_rcu(struct rcu_head *head, unsigned long ip)
> +{
> +	trace_mark_tp(rcu_classic_call_rcu, rcu_classic_call_rcu,
> +		probe_rcu_classic_call_rcu, "func %p ip 0x%lX", head->func, ip);
> +}
> +
> +void probe_rcu_classic_call_rcu_bh(struct rcu_head *head, unsigned long ip)
> +{
> +	trace_mark_tp(rcu_classic_call_rcu_bh, rcu_classic_call_rcu_bh,
> +		probe_rcu_classic_call_rcu_bh, "func %p ip 0x%lX",
> +		head->func, ip);
> +}
> +#endif
> +
> +#ifdef CONFIG_PREEMPT_RCU
> +void probe_rcu_preempt_callback(struct rcu_head *head)
> +{
> +	trace_mark_tp(rcu_preempt_callback, rcu_preempt_callback,
> +		probe_rcu_preempt_callback, "func %p", head->func);
> +}
> +
> +void probe_rcu_preempt_call_rcu(struct rcu_head *head, unsigned long ip)
> +{
> +	trace_mark_tp(rcu_preempt_call_rcu, rcu_preempt_call_rcu,
> +		probe_rcu_preempt_call_rcu, "func %p ip 0x%lX", head->func, ip);
> +}
> +
> +void probe_rcu_preempt_call_rcu_sched(struct rcu_head *head, unsigned long ip)
> +{
> +	trace_mark_tp(rcu_preempt_call_rcu_sched, rcu_preempt_call_rcu_sched,
> +		probe_rcu_preempt_call_rcu_sched, "func %p ip 0x%lX",
> +		head->func, ip);
> +}
> +#endif
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mathieu Desnoyers");
> +MODULE_DESCRIPTION("RCU Tracepoint Probes");
> Index: linux-2.6-lttng/ltt/probes/Makefile
> ===================================================================
> --- linux-2.6-lttng.orig/ltt/probes/Makefile	2008-10-02 14:11:20.000000000 -0400
> +++ linux-2.6-lttng/ltt/probes/Makefile	2008-10-02 14:18:16.000000000 -0400
> @@ -9,7 +9,7 @@ CFLAGS_REMOVE_lockdep-trace.o = -pg
>  endif
> 
>  obj-$(CONFIG_LTT_TRACEPROBES)	+= kernel-trace.o mm-trace.o fs-trace.o \
> -				ipc-trace.o lockdep-trace.o
> +				ipc-trace.o lockdep-trace.o rcu-trace.o
>  ifeq ($(CONFIG_NET),y)
>  CFLAGS_REMOVE_net-trace.o = -pg
>  obj-$(CONFIG_TRACEPROBES)	+= net-trace.o
> 
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
