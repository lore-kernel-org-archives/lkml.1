Return-Path: <linux-kernel-owner+w=401wt.eu-S1030624AbXDNPCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624AbXDNPCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 11:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXDNPCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 11:02:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50463 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030624AbXDNPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 11:02:54 -0400
Date: Sat, 14 Apr 2007 17:03:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] the scheduled -EINVAL for invalid timevals in setitimer
Message-ID: <20070414150302.GF3691@stusta.de>
References: <20070406102036.GF29169@stusta.de> <1175855360.28263.439.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1175855360.28263.439.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 12:29:19PM +0200, Thomas Gleixner wrote:
> On Fri, 2007-04-06 at 12:20 +0200, Adrian Bunk wrote:
> > As scheduled, do_setitimer() now returns -EINVAL for invalid timeval.
> >
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Ha, you beat me by a minute :)
> 
> > -	check_itimerval(value);
> > +	if (unlikely(!timeval_valid(&value->it_value) || !timeval_valid(&value->it_interval)))
> > +		return -EINVAL;
> >  
> 
> Please make this:
> 
> +       if (!timeval_valid(&value->it_value) ||
> +           !timeval_valid(&value->it_interval))
> +               return -EINVAL;

Updated patch below.

> 	tglx

cu
Adrian


<--  snip  -->


As scheduled, do_setitimer() now returns -EINVAL for invalid timeval.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 Documentation/feature-removal-schedule.txt |   12 ----
 kernel/itimer.c                            |   59 +--------------------
 2 files changed, 3 insertions(+), 68 deletions(-)

As scheduled, do_setitimer() now returns -EINVAL for invalid timeval.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 Documentation/feature-removal-schedule.txt |   12 ----
 kernel/itimer.c                            |   58 ---------------------
 2 files changed, 2 insertions(+), 68 deletions(-)

--- linux-2.6.21-rc5-mm4/Documentation/feature-removal-schedule.txt.old	2007-04-05 21:02:30.000000000 +0200
+++ linux-2.6.21-rc5-mm4/Documentation/feature-removal-schedule.txt	2007-04-05 21:02:42.000000000 +0200
@@ -104,18 +104,6 @@ Who:    Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
-What:	Usage of invalid timevals in setitimer
-When:	March 2007
-Why:	POSIX requires to validate timevals in the setitimer call. This
-	was never done by Linux. The invalid (e.g. negative timevals) were
-	silently converted to more or less random timeouts and intervals.
-	Until the removal a per boot limited number of warnings is printed
-	and the timevals are sanitized.
-
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
 	(temporary transition config option provided until then)
 	The transition config option will also be removed at the same time.
--- linux-2.6.21-rc5-mm4/kernel/itimer.c.old	2007-04-05 21:02:50.000000000 +0200
+++ linux-2.6.21-rc5-mm4/kernel/itimer.c	2007-04-05 21:06:05.000000000 +0200
@@ -138,59 +138,11 @@ enum hrtimer_restart it_real_fn(struct h
 }
 
 /*
- * We do not care about correctness. We just sanitize the values so
- * the ktime_t operations which expect normalized values do not
- * break. This converts negative values to long timeouts similar to
- * the code in kernel versions < 2.6.16
- *
- * Print a limited number of warning messages when an invalid timeval
- * is detected.
- */
-static void fixup_timeval(struct timeval *tv, int interval)
-{
-	static int warnlimit = 10;
-	unsigned long tmp;
-
-	if (warnlimit > 0) {
-		warnlimit--;
-		printk(KERN_WARNING
-		       "setitimer: %s (pid = %d) provided "
-		       "invalid timeval %s: tv_sec = %ld tv_usec = %ld\n",
-		       current->comm, current->pid,
-		       interval ? "it_interval" : "it_value",
-		       tv->tv_sec, (long) tv->tv_usec);
-	}
-
-	tmp = tv->tv_usec;
-	if (tmp >= USEC_PER_SEC) {
-		tv->tv_usec = tmp % USEC_PER_SEC;
-		tv->tv_sec += tmp / USEC_PER_SEC;
-	}
-
-	tmp = tv->tv_sec;
-	if (tmp > LONG_MAX)
-		tv->tv_sec = LONG_MAX;
-}
-
-/*
  * Returns true if the timeval is in canonical form
  */
 #define timeval_valid(t) \
 	(((t)->tv_sec >= 0) && (((unsigned long) (t)->tv_usec) < USEC_PER_SEC))
 
-/*
- * Check for invalid timevals, sanitize them and print a limited
- * number of warnings.
- */
-static void check_itimerval(struct itimerval *value) {
-
-	if (unlikely(!timeval_valid(&value->it_value)))
-		fixup_timeval(&value->it_value, 0);
-
-	if (unlikely(!timeval_valid(&value->it_interval)))
-		fixup_timeval(&value->it_interval, 1);
-}
-
 int do_setitimer(int which, struct itimerval *value, struct itimerval *ovalue)
 {
 	struct task_struct *tsk = current;
@@ -200,15 +152,10 @@ int do_setitimer(int which, struct itime
 
 	/*
 	 * Validate the timevals in value.
-	 *
-	 * Note: Although the spec requires that invalid values shall
-	 * return -EINVAL, we just fixup the value and print a limited
-	 * number of warnings in order not to break users of this
-	 * historical misfeature.
-	 *
-	 * Scheduled for replacement in March 2007
 	 */
-	check_itimerval(value);
+	if (!timeval_valid(&value->it_value) ||
+	    !timeval_valid(&value->it_interval))
+		return -EINVAL;
 
 	switch (which) {
 	case ITIMER_REAL:


