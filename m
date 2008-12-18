Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752130AbYLRJZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbYLRJZb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYLRJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:25:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:55158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYLRJZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:25:19 -0500
Subject: Re: TSC not updating after resume: Bug or Feature?
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: dsaxena@plexity.net, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <1229536210.30177.21.camel@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
	 <1229536210.30177.21.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2008 10:24:39 +0100
Message-Id: <1229592279.9487.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 12:50 -0500, Steven Rostedt wrote:
> I added Peter Zijlstra too, since he works on the cpu clock as well.

Thanks Steve..

> On Wed, 2008-12-17 at 09:27 -0800, Deepak Saxena wrote:
> > Hi,
> > 
> > I am using ftrace to get a detailed timing analysis of the resume process 
> > on the OLPC XO laptop and am seeing that when we start running again, the
> > system timestamep is not being updated for several (hundreds of) thousands 
> > of cycles (~2000 ftrace entries). From following the ftrace, what is 
> > happening is that the clocksource is not updated until we run the cpu_idle() 
> > thread due to an explicit scheduling operation in the resume path that occurs 
> > via call to msleep from pci_set_power_state().  As I'm still fully groking the 
> > timekeeping code, the question(s) I have is whether this is expected behaviour 
> > and I should not assume valid timestamp data in the initial bits of the suspend path, 
> > whether this is an OLPC-specific bug, or whether I've uncovered a generic bug in 
> > the timekeeping implementation.  This is on 2.6.27.7 as I've not gotten 28-rc 
> > up and running on the XO but can move that up in priority if this behaviour
> > is different in newer kernels.

Right, so cpu_clock() relies on gtod and tsc to generate a timestamp. We
use a tick_raw (tsc) and tick_gtod, we then use tick_raw to compute a
delta in tsc and add that to tick_gtod and clip the stuff to a jiffy
window and filter backward motion.

On resume I imagine the TSC has a totally unrelated value to the TSC
before suspend, this would mean the clock would quickly end up either at
whatever place the backward motion filter saw last (new TSC < old TSC)
or at the jiffy window clip (new TSC > old TSC).

Time will only start running correctly again once the jiffy tick starts.

Then there is the acpi idle code and NOHZ stuff, that call the
sched_clock_tick() by hand in order to re-sync time (because an unknown
quantity of time passed and gtod has all the machinery of figuring that
out).

So yes, this is expected behaviour,.. OTOH I really didn't think much
about code relying on this timesource _that_ early and such.

Rafael, would something like this explain why we had to revert Shaggy's
patch? His patch fixes the backward motion filter and I'm at an utter
loss why that would break suspend.

> > 
> > # dsaxena: Return from firmware
> >  do_suspend_trac-1267  [00]   154.925216: restore_processor_state <-ret_point
> >  do_suspend_trac-1267  [00]   154.925216: enable_sep_cpu <-restore_processor_state
> >  do_suspend_trac-1267  [00]   154.925216: olpc_fixup_wakeup <-olpc_pm_enter
> >  do_suspend_trac-1267  [00]   154.925216: geode_get_dev_base <-olpc_fixup_wakeup
> >  do_suspend_trac-1267  [00]   154.925216: olpc_ec_cmd <-olpc_fixup_wakeup
> >  do_suspend_trac-1267  [00]   154.925216: _spin_lock_irqsave <-olpc_ec_cmd
> >  do_suspend_trac-1267  [00]   154.925216: __wait_on_ibf <-olpc_ec_cmd
> >  do_suspend_trac-1267  [00]   154.925216: printk <-olpc_ec_cmd
> >  do_suspend_trac-1267  [00]   154.925216: vprintk <-printk
> >  do_suspend_trac-1267  [00]   154.925216: _spin_lock <-vprintk
> >  do_suspend_trac-1267  [00]   154.925216: emit_log_char <-vprintk
> >  do_suspend_trac-1267  [00]   154.925216: emit_log_char <-vprintk
> > ....
> > # pci_set_power_state() calls msleep(10) as per PCI spec
> >  do_suspend_trac-1267  [00]   154.925216: msleep <-pci_set_power_state
> >  do_suspend_trac-1267  [00]   154.925216: msecs_to_jiffies <-msleep
> >  do_suspend_trac-1267  [00]   154.925216: schedule_timeout_uninterruptible <-msleep
> >  do_suspend_trac-1267  [00]   154.925216: schedule_timeout <-schedule_timeout_uninterruptible
> >  do_suspend_trac-1267  [00]   154.925216: init_timer_on_stack <-schedule_timeout
> >  do_suspend_trac-1267  [00]   154.925216: __init_timer <-init_timer_on_stack
> >  do_suspend_trac-1267  [00]   154.925216: __mod_timer <-schedule_timeout
> >  do_suspend_trac-1267  [00]   154.925216: __timer_stats_timer_set_start_info <-__mod_timer
> >  do_suspend_trac-1267  [00]   154.925216: lock_timer_base <-__mod_timer
> >  do_suspend_trac-1267  [00]   154.925216: _spin_lock_irqsave <-lock_timer_base
> >  do_suspend_trac-1267  [00]   154.925216: internal_add_timer <-__mod_timer
> >  do_suspend_trac-1267  [00]   154.925216: _spin_unlock_irqrestore <-__mod_timer
> >  do_suspend_trac-1267  [00]   154.925216: _spin_lock <-schedule
> >  do_suspend_trac-1267  [00]   154.925216: marker_probe_cb <-schedule
> >  do_suspend_trac-1267  [00]   154.925216: _spin_unlock <-tracing_record_cmdline
> >  do_suspend_trac-1267  [00]   154.925216: __switch_to <-schedule
> >           <idle>-0     [00]   154.925216: _spin_unlock_irq <-finish_task_switch
> >           <idle>-0     [00]   154.925216: tick_nohz_stop_sched_tick <-cpu_idle
> >           <idle>-0     [00]   154.925216: ktime_get <-tick_nohz_stop_sched_tick
> >           <idle>-0     [00]   154.925216: ktime_get_ts <-ktime_get
> >           <idle>-0     [00]   154.925216: getnstimeofday <-ktime_get_ts
> >           <idle>-0     [00]   154.925216: set_normalized_timespec <-ktime_get_ts
> >           <idle>-0     [00]   154.925216: get_next_timer_interrupt <-tick_nohz_stop_sched_tick
> >           <idle>-0     [00]   154.925216: _spin_lock <-get_next_timer_interrupt
> >           <idle>-0     [00]   154.925216: _spin_unlock <-get_next_timer_interrupt
> >           <idle>-0     [00]   154.925216: hrtimer_get_next_event <-get_next_timer_interrupt
> >           <idle>-0     [00]   154.925216: _spin_lock_irqsave <-hrtimer_get_next_event
> >           <idle>-0     [00]   154.925216: _spin_unlock_irqrestore <-hrtimer_get_next_event
> >           <idle>-0     [00]   154.925216: rcu_needs_cpu <-tick_nohz_stop_sched_tick
> >           <idle>-0     [00]   154.925216: rcu_pending <-rcu_needs_cpu
> >           <idle>-0     [00]   154.925216: __rcu_pending <-rcu_pending
> >           <idle>-0     [00]   154.925216: __rcu_pending <-rcu_pending
> >           <idle>-0     [00]   154.925216: rcu_pending <-cpu_idle
> >           <idle>-0     [00]   154.925216: __rcu_pending <-rcu_pending
> >           <idle>-0     [00]   154.925216: __rcu_pending <-rcu_pending
> >           <idle>-0     [00]   154.925216: default_idle <-cpu_idle
> >           <idle>-0     [00]   154.925216: do_IRQ <-common_interrupt
> >           <idle>-0     [00]   154.925216: irq_enter <-do_IRQ
> >           <idle>-0     [00]   154.925216: tick_nohz_stop_idle <-irq_enter
> >           <idle>-0     [00]   154.925216: ktime_get <-tick_nohz_stop_idle
> >           <idle>-0     [00]   154.925216: ktime_get_ts <-ktime_get
> >           <idle>-0     [00]   154.925216: getnstimeofday <-ktime_get_ts
> >           <idle>-0     [00]   154.925216: set_normalized_timespec <-ktime_get_ts
> >           <idle>-0     [00]   154.925216: ktime_get <-sched_clock_tick
> >           <idle>-0     [00]   154.925216: ktime_get_ts <-ktime_get
> >           <idle>-0     [00]   154.925216: getnstimeofday <-ktime_get_ts
> >           <idle>-0     [00]   154.925216: set_normalized_timespec <-ktime_get_ts
> > # ktime_get_ts() calls getnstimeofday() which ends up calling clocksource_read()
> > # thus updating the kernel timestamp. note that we call getnstimeofday()
> > # twice above but for some reason they do not impact the time stamp...
> > # There is an IRQ in here, possibly an HRT-driven IRQ and I'm wondering
> > # if that is kicking the TSC into ticking?
> >           <idle>-0     [00]   154.929837: touch_softlockup_watchdog <-sched_clock_idle_wakeup_event
> >           <idle>-0     [00]   154.929839: tick_nohz_update_jiffies <-irq_enter

