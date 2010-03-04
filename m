Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0CDW2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:28:08 -0500
Received: from ozlabs.org ([203.10.76.45]:43256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0CDW2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:28:05 -0500
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com, Christopher Yeoh <cyeoh@samba.org>
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <1267541076.25158.60.camel@laptop>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop> <1264721088.10385.1.camel@jschopp-laptop> <1265403478.6089.41.camel@jschopp-laptop> <1266142340.5273.418.camel@laptop> <25851.1266445258@neuling.org> <1266499023.26719.597.camel@laptop> <14639.1266559532@neuling.org> <1266573672.1806.70.camel@laptop> <24165.1266577276@neuling.org> <23662.1266905307@neuling.org> <1266942281.11845.521.camel@laptop> <4886.1266991633@neuling.org> <11927.1267010024@neuling.org> <12599.1267266087@neuling.org> <1267541076.25158.60.camel@laptop>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Tue, 02 Mar 2010 15:44:36 +0100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 05 Mar 2010 09:28:03 +1100
Message-ID: <4994.1267741683@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1267541076.25158.60.camel@laptop> you wrote:
> On Sat, 2010-02-27 at 21:21 +1100, Michael Neuling wrote:
> > In message <11927.1267010024@neuling.org> you wrote:
> > > > > If there's less the group will normally be balanced and we fall out a
nd
> > > > > end up in check_asym_packing().
> > > > > 
> > > > > So what I tried doing with that loop is detect if there's a hole in t
he
> > > > > packing before busiest. Now that I think about it, what we need to ch
eck
> > > > > is if this_cpu (the removed cpu argument) is idle and less than busie
st.
> > > > > 
> > > > > So something like:
> > > > > 
> > > > > static int check_asym_pacing(struct sched_domain *sd,
> > > > >                              struct sd_lb_stats *sds,
> > > > >                              int this_cpu, unsigned long *imbalance)
> > > > > {
> > > > > 	int busiest_cpu;
> > > > > 
> > > > > 	if (!(sd->flags & SD_ASYM_PACKING))
> > > > > 		return 0;
> > > > > 
> > > > > 	if (!sds->busiest)
> > > > > 		return 0;
> > > > > 
> > > > > 	busiest_cpu = group_first_cpu(sds->busiest);
> > > > > 	if (cpu_rq(this_cpu)->nr_running || this_cpu > busiest_cpu)
> > > > > 		return 0;
> > > > > 
> > > > > 	*imbalance = (sds->max_load * sds->busiest->cpu_power) /
> > > > > 			SCHED_LOAD_SCALE;
> > > > > 	return 1;
> > > > > }
> > > > > 
> > > > > Does that make sense?
> > > > 
> > > > I think so.
> > > > 
> > > > I'm seeing check_asym_packing do the right thing with the simple SMT2
> > > > with 1 process case.  It marks cpu0 as imbalanced when cpu0 is idle and
> > > > cpu1 is busy.
> > > > 
> > > > Unfortunately the process doesn't seem to be get migrated down though.
> > > > Do we need to give *imbalance a higher value? 
> > > 
> > > So with ego help, I traced this down a bit more.  
> > > 
> > > In my simple test case (SMT2, t0 idle, t1 active) if f_b_g() hits our
> > > new case in check_asym_packing(), load_balance then runs f_b_q().
> > > f_b_q() has this:
> > > 
> > >   		if (capacity && rq->nr_running == 1 && wl > imbalance)
> > > 			continue;
> > > 
> > > when check_asym_packing() hits, wl = 1783 and imbalance = 1024, so we
> > > continue and busiest remains NULL. 
> > > 
> > > load_balance then does "goto out_balanced" and it doesn't attempt to
> > > move the task.
> > > 
> > > Based on this and on egos suggestion I pulled in Suresh Siddha patch
> > > from: http://lkml.org/lkml/2010/2/12/352.  This fixes the problem.  The
> > > process is moved down to t0.  
> > > 
> > > I've only tested SMT2 so far.  
> > 
> > I'm finding this SMT2 result to be unreliable. Sometimes it doesn't work
> > for the simple 1 process case.  It seems to change boot to boot.
> > Sometimes it works as expected with t0 busy and t1 idle, but other times
> > it's the other way around.
> > 
> > When it doesn't work, check_asym_packing() is still marking processes to
> > be pulled down but only gets run about 1 in every 4 calls to
> > load_balance().
> > 
> > For 2 of the other calls to load_balance, idle is CPU_NEWLY_IDLE and
> > hence check_asym_packing() doesn't get called.  This results in
> > sd->nr_balance_failed being reset.  When load_balance is next called and
> > check_asym_packing() hits, need_active_balance() returns 0 as
> > sd->nr_balance_failed is too small.  This means the migration thread on
> > t1 is not woken and the process remains there.  
> > 
> > So why does thread0 change from NEWLY_IDLE to IDLE and visa versa, when
> > there is nothing running on it?  Is this expected? 
> 
> Ah, yes, you should probably allow both those.
> 
> NEWLY_IDLE is when we are about to schedule the idle thread, IDLE is
> when a tick hits the idle thread.
> 
> I'm thinking that NEWLY_IDLE should also solve the NO_HZ case, since
> we'll have passed through that before we enter tickless state, just make
> sure SD_BALANCE_NEWIDLE is set on the relevant levels (should already be
> so).

OK, thanks.

There seems to be a regression in Linus' latest tree (also -next) where
new processes usually end up on the thread 1 rather than 0 (when in SMT2
mode).

This only seems to happen with newly created processes.  If you pin a
process to t0 and then unpin it, it stays on t0.  Also if a process is
migrated to another core, it can end up on t0.

This happens with a vanilla linus or -next tree on ppc64
pseries_defconfig - NO_HZ.  I've not tried with NO_HZ.

Anyway, this regression seems to be causing problems when we apply our
patch.  We are trying to pull down to T0 which works, but we immediately
get pulled back upto t1 due to the above regression.  This happens over
and over, causing process to ping-pong every few sched ticks.  

We've not tried to bisect this problem but that's the next step unless
someone has some insights to the problem.

Also, we had to change the following to get the pull down to work
correctly in the original patch:

@@ -2618,8 +2618,8 @@ static int check_asym_packing(struct sch
        if (this_cpu > busiest_cpu)
                return 0;
 
-       *imbalance = (sds->max_load * sds->busiest->cpu_power) /
-                       SCHED_LOAD_SCALE;
+       *imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power, 
+                                      SCHED_LOAD_SCALE);
        return 1;

We found that imbalance = 1023.8 which got rounded down to 1023 which
ended up being compared to a wl of 1024 in find_busiest_queue and
failing.  The closest round fixes this.

Mikey
