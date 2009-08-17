Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbZHQVMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbZHQVMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbZHQVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:12:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40638 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbZHQVME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:12:04 -0400
Subject: Re: clocksource changes in 2.6.31 - possible regression
From: john stultz <johnstul@us.ibm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20090817112704.2b4b2987@nehalam>
References: <20090817090319.20979986@nehalam>
	 <1250531337.26171.12.camel@work-vm>	<20090817110127.40ee5c29@nehalam>
	 <1250532954.26171.35.camel@work-vm>  <20090817112704.2b4b2987@nehalam>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 14:10:58 -0700
Message-Id: <1250543459.7212.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 11:27 -0700, Stephen Hemminger wrote:
> On Mon, 17 Aug 2009 11:15:54 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Mon, 2009-08-17 at 11:01 -0700, Stephen Hemminger wrote:
> > > On Mon, 17 Aug 2009 10:48:57 -0700
> > > john stultz <johnstul@us.ibm.com> wrote:
> > > 
> > > > On Mon, 2009-08-17 at 09:03 -0700, Stephen Hemminger wrote:
> > > > > The following commit causes a change for kernels built with HRT but
> > > > > not actually using HRT.  I typically use the generic kernel we ship
> > > > > on test machines, and that kernel has NOHZ and HRT (for power savings/virt
> > > > > and HRT for QoS), but I want to be able to enable TSC as a clock source
> > > > > when doing performance tests with pktgen.
> > > > > 
> > > > > The machine in question is a several year old Opteron box, that
> > > > > normally reports clocksources: acpi_pm jiffies tsc
> > > > > but now with 2.6.31-rc6, it only has acpi_pm.
> > > > 
> > > > I might need to review the patch again, but I believe we just don't
> > > > allow you to switch to non HRT compatible clocksources (like jiffies) if
> > > > we're already in HRT mode (and thus would hang when switched). 
> > > > 
> > > > 
> > > > The behavior you describe where you can't switch to the TSC, may be due
> > > > to the TSC disqualification code marking it as non HRT compatible
> > > > (again, I need to double check). While I'm not sure that's really
> > > > correct, as the TSC is fine for HRT, in this case on your box, the TSC
> > > > has been marked as unstable (likely due to being unsynced on old AMD SMP
> > > > systems). There is a real chance that the timekeeping code on your
> > > > system could see the TSC go backwards, calculate a negative time
> > > > interval, and then end up hanging. 
> > > > 
> > > 
> > > TSC was alway stable on this box, and worked fine.  There was no
> > > message in log about TSC instability. The change was bisected
> > > down to that one commit.
> > 
> > But just to clarify, the TSC was never selected as the default
> > clocksource on the box either, right?
> 
> correct.
> 
> I am okay with turning it off on boot command line for my tests,
> but it might be an issue for other users.


So looking at the code in question:
		/*
		 * Don't show non-HRES clocksource if the tick code is
		 * in one shot mode (highres=on or nohz=on)
		 */
		if (!tick_oneshot_mode_active() ||
		    (src->flags & CLOCK_SOURCE_VALID_FOR_HRES))

So we require the clock to be valid for hres if we're in hres mode.

Then looking at where that flag is manipulated:
$ git grep -n CLOCK_SOURCE_VALID_FOR_HRES
include/linux/clocksource.h:214:#define CLOCK_SOURCE_VALID_FOR_HRES             
kernel/time/clocksource.c:168:  cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLO
kernel/time/clocksource.c:200:                          cs->flags |= CLOCK_SOURC
kernel/time/clocksource.c:257:                  cs->flags |= CLOCK_SOURCE_VALID_
kernel/time/clocksource.c:285:          cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES
kernel/time/clocksource.c:517:      !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES))
kernel/time/clocksource.c:557:              (src->flags & CLOCK_SOURCE_VALID_FOR
kernel/time/timekeeping.c:273:          ret = clock->flags & CLOCK_SOURCE_VALID_


We can see clocksource.c:168 is the only line that disables the flag and
that's in clocksource_ratewd() after we've found an actual inconsistency
from the watchdog. 

So unless I'm missing a more subtle bug in the watchdog assignment of
the CLOCK_SOURCE_VALID_FOR_HRES bit,  I'm a little hesitant that its
really as stable as you feel it is.

Mind running with the following patch and sending me the dmesg?

thanks
-john

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7466cb8..08ff940 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -198,6 +198,7 @@ static void clocksource_watchdog(unsigned long data)
 			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
 			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
 				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+				printk("Marked %s valid for HRT\n", cs->name);
 				/*
 				 * We just marked the clocksource as
 				 * highres-capable, notify the rest of the
@@ -253,9 +254,10 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 				     cpumask_first(cpu_online_mask));
 		}
 	} else {
-		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
+		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) {
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-
+			printk("Marked %s valid for HRT\n", cs->name);
+		}
 		if (!watchdog || cs->rating > watchdog->rating) {
 			if (watchdog)
 				del_timer(&watchdog_timer);
@@ -281,8 +283,10 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 #else
 static void clocksource_check_watchdog(struct clocksource *cs)
 {
-	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
+	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS){
 		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+		printk("Marked %s valid for HRT\n", cs->name);
+	}
 }
 
 static inline void clocksource_resume_watchdog(void) { }


