Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYLMOuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYLMOuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbYLMOuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:50:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49270 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbYLMOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:50:03 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Dec 2008 09:49:47 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PM1FhTm0qfCp38+u2F3Jj0ZD8mCTutAOBhN9iY99kA2cEYZJSC9o/wP3XsrWWEkBzM
         /b+23EZrh4DNZeS9atDbgq0dTL2BDVQSwdy/NH2rfzFPN2Y7C5J/XJqqqO0Pd9Lb1HPp
         ahI2xviwScjvh7FVFFgePmI+4IOS4oEI2mhyE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] nohz: add missing handling of clocksource watchdog
Date: Sat, 13 Dec 2008 15:41:31 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>,
       Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>,
       linux-kernel@vger.kernel.org
References: <200812080015.22793.bzolnier@gmail.com> <200812080124.37944.bzolnier@gmail.com> <alpine.LFD.2.00.0812080308140.3325@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812080308140.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812131541.31990.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008, Thomas Gleixner wrote:
> On Mon, 8 Dec 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> > On Monday 08 December 2008, Sergei Shtylyov wrote:
> > > Hello.
> > > 
> > > R. J. Wysocki wrote:
> > > > On Monday, 8 of December 2008, Bartlomiej Zolnierkiewicz wrote:
> > > >   
> > > >> Fixes "Clocksource tsc unstable (delta = -974982308 ns)" problem.
> > > >>     
> > > >
> > > > Where can I find the description of the problem?
> > > >   
> > > 
> > >    Kernel.org bug #10216 (it's not about this issue though).
> > 
> > Looking back at bug #10216 the patch is unlikely to help Lars' system
> > since it doesn't use nohz and there are also warnings about unsynced
> > TSCs (I just don't know why not for 2.6.27-rc kernels)...
> >  
> > > > Rafael
> > > >
> > > >   
> > > >> [ IDE was unlucky to be initialized at the same time that
> > > >>   clocksource watchdog triggers and was blamed for the issue. ]
> > > >>     
> > > 
> > >    I think it might well have been blamed correctly -- the clocksource 
> > > watchdog timer gets run every half second.
> > 
> > AFAICS this is a special one for measuring stability of the clocksource
> > only -- by comparing the value returned by a given clocksource with the
> > reference clocksource.  Normal drivers have no bussiness there...
> > 
> > Anyway I forgot to add that it fixes the issue for me under QEMU (on my
> > laptop TSC is unstable due to halts in idle) and it could be as well QEMU's
> > oddity (although it looks like a legit kernel problem).  v2 of the patch
> > below (updated patch description).
> > 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH v2] nohz: add missing handling of clocksource watchdog
> > 
> > Fixes "Clocksource tsc unstable (delta = -974982308 ns)" problem
> > under QEMU.
> > 
> > Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > Cc: Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  kernel/time/tick-sched.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: b/kernel/time/tick-sched.c
> > ===================================================================
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/tick.h>
> >  #include <linux/module.h>
> > +#include <linux/clocksource.h>
> >  
> >  #include <asm/irq_regs.h>
> >  
> > @@ -153,6 +154,7 @@ void tick_nohz_update_jiffies(void)
> >  	local_irq_restore(flags);
> >  
> >  	touch_softlockup_watchdog();
> > +	clocksource_touch_watchdog();
> 
> NAK. 
> 
> If this happens then the watchdog logic did not manage to schedule the
> watchdog timer in time. This patch just papers over the real problem.
> 
> We do not fix QEMU problems in the kernel, as we would miss real
> hardware wreckage that way.

I know that and I'm not proposing it.  However sometimes things that look
like QEMU specific problems indicate the real deficiencies of the kernel.

I did more debugging and the reason for marking tsc clocksource as an
unstable is that the reference clocksource (acpi_pm) itself is bad.
The similar problems seem to also happen with the real hardware, i.e.
please see:

http://lkml.indiana.edu/hypermail/linux/kernel/0802.3/0589.html

I cooked up a debug patch which uses timer interval as a reference for
checking stability of the watchdog clocksource (I think it could be useful
for debugging similar issues, it is not a generic solution since it doesn't
handle the situation when both watchdog and watched clocksources are bad).

I'm also wondering whether it would be a good idea to modify our clocksource
watchdog code to just always use timer interval as reference for checking
clocksource stability.  It will allow us to check all clocksources (including
watchdog one) and should simplify the code a bit.  I can make a patch for it
if you think that this is good idea...

---
 kernel/time/clocksource.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

Index: b/kernel/time/clocksource.c
===================================================================
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -79,8 +79,9 @@ static unsigned long watchdog_resumed;
 /*
  * Interval: 0.5sec Threshold: 0.0625s
  */
-#define WATCHDOG_INTERVAL (HZ >> 1)
-#define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
+#define WATCHDOG_INTERVAL	(HZ >> 1)
+#define WATCHDOG_INTERVAL_NSEC	500000000
+#define WATCHDOG_THRESHOLD	(NSEC_PER_SEC >> 4)
 
 static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 {
@@ -94,6 +95,34 @@ static void clocksource_ratewd(struct cl
 	list_del(&cs->wd_list);
 }
 
+static int watchdog_check(struct clocksource *wd,
+			  int64_t wd_nsec, int64_t cs_nsec)
+{
+	int64_t delta;
+
+	/* check if watchdog seems good */
+	delta = wd_nsec - WATCHDOG_INTERVAL_NSEC;
+	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
+		return 0;
+
+	/* check if clocksource seems bad */
+	delta = cs_nsec - WATCHDOG_INTERVAL_NSEC;
+	if (delta < -WATCHDOG_THRESHOLD || delta > WATCHDOG_THRESHOLD)
+		return 0;
+
+	printk(KERN_WARNING "Watchdog clocksource %s unstable (delta = "
+		"%lld ns)\n", wd->name, wd_nsec - WATCHDOG_INTERVAL_NSEC);
+
+	wd->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
+	clocksource_change_rating(wd, 0);
+
+	/* disable watchdog */
+	watchdog = NULL;
+
+	/* don't add next timer */
+	return 1;
+}
+
 static void clocksource_watchdog(unsigned long data)
 {
 	struct clocksource *cs, *tmp;
@@ -135,6 +164,11 @@ static void clocksource_watchdog(unsigne
 		} else {
 			cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
 			cs->wd_last = csnow;
+
+			/* Check reference clock stability first. */
+			if (watchdog_check(watchdog, wd_nsec, cs_nsec))
+				goto out_unlock;
+
 			/* Check the delta. Might remove from the list ! */
 			clocksource_ratewd(cs, cs_nsec - wd_nsec);
 		}
@@ -152,6 +186,7 @@ static void clocksource_watchdog(unsigne
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
 		add_timer_on(&watchdog_timer, next_cpu);
 	}
+out_unlock:
 	spin_unlock(&watchdog_lock);
 }
 static void clocksource_resume_watchdog(void)
