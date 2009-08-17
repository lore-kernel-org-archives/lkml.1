Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZHQVpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZHQVpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZHQVpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:45:52 -0400
Received: from mail.vyatta.com ([76.74.103.46]:51303 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZHQVpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:45:51 -0400
Date: Mon, 17 Aug 2009 14:45:46 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
Message-ID: <20090817144546.7f1d6572@nehalam>
In-Reply-To: <1250545077.7212.49.camel@localhost.localdomain>
References: <20090817090319.20979986@nehalam>
	<1250531337.26171.12.camel@work-vm>
	<20090817110127.40ee5c29@nehalam>
	<1250532954.26171.35.camel@work-vm>
	<20090817112704.2b4b2987@nehalam>
	<1250543459.7212.41.camel@localhost.localdomain>
	<1250545077.7212.49.camel@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 14:37:57 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Mon, 2009-08-17 at 14:11 -0700, john stultz wrote:
> > On Mon, 2009-08-17 at 11:27 -0700, Stephen Hemminger wrote:
> > > On Mon, 17 Aug 2009 11:15:54 -0700
> > > john stultz <johnstul@us.ibm.com> wrote:
> > > 
> > > > On Mon, 2009-08-17 at 11:01 -0700, Stephen Hemminger wrote:
> > > > > On Mon, 17 Aug 2009 10:48:57 -0700
> > > > > john stultz <johnstul@us.ibm.com> wrote:
> > > > > 
> > > > > > On Mon, 2009-08-17 at 09:03 -0700, Stephen Hemminger wrote:
> > > > > > > The following commit causes a change for kernels built with HRT but
> > > > > > > not actually using HRT.  I typically use the generic kernel we ship
> > > > > > > on test machines, and that kernel has NOHZ and HRT (for power savings/virt
> > > > > > > and HRT for QoS), but I want to be able to enable TSC as a clock source
> > > > > > > when doing performance tests with pktgen.
> > > > > > > 
> > > > > > > The machine in question is a several year old Opteron box, that
> > > > > > > normally reports clocksources: acpi_pm jiffies tsc
> > > > > > > but now with 2.6.31-rc6, it only has acpi_pm.
> > > > > > 
> > > > > > I might need to review the patch again, but I believe we just don't
> > > > > > allow you to switch to non HRT compatible clocksources (like jiffies) if
> > > > > > we're already in HRT mode (and thus would hang when switched). 
> > > > > > 
> > > > > > 
> > > > > > The behavior you describe where you can't switch to the TSC, may be due
> > > > > > to the TSC disqualification code marking it as non HRT compatible
> > > > > > (again, I need to double check). While I'm not sure that's really
> > > > > > correct, as the TSC is fine for HRT, in this case on your box, the TSC
> > > > > > has been marked as unstable (likely due to being unsynced on old AMD SMP
> > > > > > systems). There is a real chance that the timekeeping code on your
> > > > > > system could see the TSC go backwards, calculate a negative time
> > > > > > interval, and then end up hanging. 
> > > > > > 
> > > > > 
> > > > > TSC was alway stable on this box, and worked fine.  There was no
> > > > > message in log about TSC instability. The change was bisected
> > > > > down to that one commit.
> > > > 
> > > > But just to clarify, the TSC was never selected as the default
> > > > clocksource on the box either, right?
> > > 
> > > correct.
> > > 
> > > I am okay with turning it off on boot command line for my tests,
> > > but it might be an issue for other users.
> > 
> > 
> > So looking at the code in question:
> > 		/*
> > 		 * Don't show non-HRES clocksource if the tick code is
> > 		 * in one shot mode (highres=on or nohz=on)
> > 		 */
> > 		if (!tick_oneshot_mode_active() ||
> > 		    (src->flags & CLOCK_SOURCE_VALID_FOR_HRES))
> > 
> > So we require the clock to be valid for hres if we're in hres mode.
> > 
> > Then looking at where that flag is manipulated:
> > $ git grep -n CLOCK_SOURCE_VALID_FOR_HRES
> > include/linux/clocksource.h:214:#define CLOCK_SOURCE_VALID_FOR_HRES             
> > kernel/time/clocksource.c:168:  cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLO
> > kernel/time/clocksource.c:200:                          cs->flags |= CLOCK_SOURC
> > kernel/time/clocksource.c:257:                  cs->flags |= CLOCK_SOURCE_VALID_
> > kernel/time/clocksource.c:285:          cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES
> > kernel/time/clocksource.c:517:      !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES))
> > kernel/time/clocksource.c:557:              (src->flags & CLOCK_SOURCE_VALID_FOR
> > kernel/time/timekeeping.c:273:          ret = clock->flags & CLOCK_SOURCE_VALID_
> > 
> > 
> > We can see clocksource.c:168 is the only line that disables the flag and
> > that's in clocksource_ratewd() after we've found an actual inconsistency
> > from the watchdog. 
> > 
> > So unless I'm missing a more subtle bug in the watchdog assignment of
> > the CLOCK_SOURCE_VALID_FOR_HRES bit,  I'm a little hesitant that its
> > really as stable as you feel it is.
> > 
> > Mind running with the following patch and sending me the dmesg?
> 
> Actually, don't.. I found the issue.
> 
> in init_tsc_clocksource():
> 	/* lower the rating if we already know its unstable: */
> 	if (check_tsc_unstable()) {
> 		clocksource_tsc.rating = 0;
> 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
> 	}
> 
> We already disqualify the TSC as not continuous, so its not valid for
> HRT. So I think the patch in question is still correct.
> 
> However, I think its fair, that as your TSC is being disqualified for
> being an old AMD SMP box, and there is a *possibility* that if you don't
> run with cpufreq and the SUMA-ness of the box didn't get in the way of
> TSC synchronization, you might have an argument for overriding the
> unsynchronized_tsc() heuristics.
> 
> Luckily the option is already there. :)
> 
> So try booting with "tsc=reliable" to override those checks, and I think
> you'll be able to do what you want to do.
> 

Good idea, doesn't work.

vyatta@amd1:~$ cat /proc/cmdline 
BOOT_IMAGE=/boot/vmlinuz-2.6.31-rc6 root=/dev/sda1 ro tsc=reliable
vyatta@amd1:~$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
acpi_pm 

-- 
