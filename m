Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYLVUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYLVUh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYLVUhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:37:15 -0500
Received: from www.tglx.de ([62.245.132.106]:42615 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYLVUhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:37:13 -0500
Date: Mon, 22 Dec 2008 21:36:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Fabio Comolli <fabio.comolli@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu> <200812182319.57235.rjw@sisk.pl> <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain> <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
 <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com> <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain> <20081222150021.GA13839@elte.hu> <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Thomas Gleixner wrote:
> On Mon, 22 Dec 2008, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > > By the way, I don't know if it matters but the problema happened with 
> > > > in-kernel hibernation and also in out-of-tree TuxOnIce hibernation. 
> > > > Maybe this can help debugging the issue, I don't know.
> > > 
> > > Hmm, does not ring a bell here. Can you please apply the patch below to 
> > > mainline and retest ?
> > 
> > ... and he should send a dmesg after a suspend cycle, right?
> 
> Yes :)
> 
> I digged more in the bugzillas. Toralf added some debug to
> __update_sched_clock():
> 
> -       max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
> +       max_clock = scd->tick_gtod + TICK_NSEC;
> +       if (scd->clock > max_clock)
> +               printk(KERN_INFO "%d %d\n", scd->clock, max_clock);
> 
> The interesting output is:
> 
> Dec 14 21:55:55 n22 Back to C!
> Dec 14 21:55:55 n22 Extended CMOS year: 2000
> Dec 14 21:55:55 n22 Force enabled HPET at resume
> Dec 14 21:55:55 n22 212611283 77
> 
> The 77 is totaly bogus and it's likely not just a truncation of the
> 64bit value because (scd->clock > max_clock) evaluates to true. This
> output is _AFTER_ timekeeping resume because the HPET force enable
> message comes from timekeeping resume.

Seems I'm talking to myself, but I think I finally decoded the
mystery:

resume()
  cpufreq_resume()
    tsc:time_cpufreq_notifier()
      set_cyc2ns_scale()
        sched_clock_idle_sleep_event()
          sched_clock_tick()
            ktime_get()
              hpet_read()

This happens _BEFORE_ timekeeping has resumed, so hpet_read() returns
nonsense and the timekeeping code uses the stale pre suspend
xtime/clocksource reference values to calculate the time. So the gtod
reference in sched_clock can result in total crap depending on the
time when the suspend happened.

Shaggys patch clamps sched_clock to the stale scd->clock value which
might explain the further wreckage.

The above sequence happens only for CPUs with a CPU frequency coupled
TSC, so on newer machines with CPU frequency invariant TSC this does
not happen.

/me stomps off to find a box to confirm that.

Thanks,

	tglx
