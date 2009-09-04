Return-Path: <linux-kernel-owner+w=401wt.eu-S934362AbZIDV4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362AbZIDV4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934351AbZIDV4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:56:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934322AbZIDV4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:56:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10 update 2x] PM: Measure suspend and resume times for individual devices
Date: Fri, 4 Sep 2009 23:56:58 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc8-rjw; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908292043500.26533-100000@netrider.rowland.org> <200909041642.03774.rjw@sisk.pl> <20090904191205.GA28408@elte.hu>
In-Reply-To: <20090904191205.GA28408@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909042356.59024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 September 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Friday 04 September 2009, Ingo Molnar wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > 
> > > > On Monday 31 August 2009, Ingo Molnar wrote:
> > > > > 
> > > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > 
> > > > > > On Monday 31 August 2009, Ingo Molnar wrote:
> > > > > > > 
> > > > > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > > > 
> > > > > > > > On Sunday 30 August 2009, Rafael J. Wysocki wrote:
> > > > > > > > > On Sunday 30 August 2009, Alan Stern wrote:
> > > > > > > > > > On Sat, 29 Aug 2009, Rafael J. Wysocki wrote:
> > > > > > > > > > 
> > > > > > > > > > > I only wanted to say that the advantage is not really that "big". :-)
> > > > > > > > > > > 
> > > > > > > > > > > > I must agree, 14 threads isn't a lot.  But at the moment that number is 
> > > > > > > > > > > > random, not under your control.
> > > > > > > > > > > 
> > > > > > > > > > > It's not directly controlled, but there are some interactions between the
> > > > > > > > > > > async threads, the main threads and the async framework that don't allow this
> > > > > > > > > > > number to grow too much.
> > > > > > > > > > > 
> > > > > > > > > > > IMO it sometimes is better to allow things to work themselves out, as long as
> > > > > > > > > > > they don't explode, than to try to keep everything under strict control.  YMMV.
> > > > > > > > > > 
> > > > > > > > > > For testing purposes it would be nice to have a one-line summary for
> > > > > > > > > > each device containing a thread ID, start timestamp, end timestamp, and
> > > > > > > > > > elapsed time.  With that information you could evaluate the amount of
> > > > > > > > > > parallelism and determine where the bottlenecks are.  It would give a
> > > > > > > > > > much more detailed picture of the entire process than the total time of
> > > > > > > > > > your recent patch 9.
> > > > > > > > > 
> > > > > > > > > Of course it would.  I think I'll implement it.
> > > > > > > > 
> > > > > > > > OK, below is a patch for that.  It only prints the time elapsed, because the
> > > > > > > > timestamps themselves can be obtained from the usual kernel timestamping.
> > > > > > > > 
> > > > > > > > It's on top of all the previous patches.
> > > > > > > > 
> > > > > > > > Thanks,
> > > > > > > > Rafael
> > > > > > > > 
> > > > > > > > ---
> > > > > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > > > Subject: PM: Measure suspend and resume times for individual devices
> > > > > > > > 
> > > > > > > > If verbose PM debugging is enabled, measure and print the time of
> > > > > > > > suspending and resuming of individual devices.
> > > > > > > > 
> > > > > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > > > ---
> > > > > > > >  drivers/base/power/main.c |   51 +++++++++++++++++++++++++++++++++++++++++-----
> > > > > > > >  kernel/power/swsusp.c     |    2 -
> > > > > > > >  2 files changed, 47 insertions(+), 6 deletions(-)
> > > > > > > > 
> > > > > > > > Index: linux-2.6/drivers/base/power/main.c
> > > > > > > > ===================================================================
> > > > > > > > --- linux-2.6.orig/drivers/base/power/main.c
> > > > > > > > +++ linux-2.6/drivers/base/power/main.c
> > > > > > > > @@ -442,11 +442,11 @@ static bool pm_op_started(struct device 
> > > > > > > >   */
> > > > > > > >  int pm_time_elapsed(struct timeval *start, struct timeval *stop)
> > > > > > > >  {
> > > > > > > > -	s64 elapsed_centisecs64;
> > > > > > > > +	s64 elapsed_msecs64;
> > > > > > > >  
> > > > > > > > -	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
> > > > > > > > -	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
> > > > > > > > -	return elapsed_centisecs64;
> > > > > > > > +	elapsed_msecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
> > > > > > > > +	do_div(elapsed_msecs64, NSEC_PER_SEC / 1000);
> > > > > > > > +	return elapsed_msecs64;
> > > > > > > >  }
> > > > > > > >  
> > > > > > > >  static char *pm_verb(int event)
> > > > > > > > @@ -476,7 +476,7 @@ static char *pm_verb(int event)
> > > > > > > >  static void dpm_show_time(struct timeval *start, struct timeval *stop,
> > > > > > > >  			  pm_message_t state, const char *info)
> > > > > > > >  {
> > > > > > > > -	int centisecs = pm_time_elapsed(start, stop);
> > > > > > > > +	int centisecs = pm_time_elapsed(start, stop) / 10;
> > > > > > > >  
> > > > > > > >  	printk(KERN_INFO "PM: %s%s%s of devices complete in %d.%02d seconds\n",
> > > > > > > >  		info ? info : "", info ? " " : "", pm_verb(state.event),
> > > > > > > > @@ -497,6 +497,33 @@ static void pm_dev_err(struct device *de
> > > > > > > >  		kobject_name(&dev->kobj), pm_verb(state.event), info, error);
> > > > > > > >  }
> > > > > > > >  
> > > > > > > > +#ifdef DEBUG
> > > > > > > > +static void device_show_time(struct timeval *start, struct device *dev,
> > > > > > > > +			     pm_message_t state, char *info)
> > > > > > > > +{
> > > > > > > > +	struct timeval stop;
> > > > > > > > +	int msecs;
> > > > > > > > +
> > > > > > > > +	do_gettimeofday(&stop);
> > > > > > > > +	msecs = pm_time_elapsed(start, &stop);
> > > > > > > > +	dev_dbg(dev, "PID %d: %s%s%s complete in %d.%03d seconds\n",
> > > > > > > > +		task_pid_nr(current), info ? info : "", info ? " " : "",
> > > > > > > > +		pm_verb(state.event), msecs / 1000, msecs % 1000);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +#define TIMER_DECLARE(timer)	struct timeval timer
> > > > > > > > +#define TIMER_START(timer)	do { \
> > > > > > > > +		do_gettimeofday(&timer); \
> > > > > > > > +	} while (0)
> > > > > > > > +#define TIMER_STOP(timer, dev, state, info)	do { \
> > > > > > > > +		device_show_time(&timer, dev, state, info); \
> > > > > > > > +	} while (0)
> > > > > > > > +#else /* !DEBUG */
> > > > > > > > +#define TIMER_DECLARE(timer)
> > > > > > > > +#define TIMER_START(timer)	do { } while (0)
> > > > > > > > +#define TIMER_STOP(timer, dev, state, info)	do { } while (0)
> > > > > > > > +#endif /* !DEBUG */
> > > > > > > > +
> > > > > > > >  /*------------------------- Resume routines -------------------------*/
> > > > > > > >  
> > > > > > > >  /**
> > > > > > > > @@ -510,7 +537,9 @@ static void pm_dev_err(struct device *de
> > > > > > > >  static int __device_resume_noirq(struct device *dev, pm_message_t state)
> > > > > > > >  {
> > > > > > > >  	int error = 0;
> > > > > > > > +	TIMER_DECLARE(timer);
> > > > > > > >  
> > > > > > > > +	TIMER_START(timer);
> > > > > > > >  	TRACE_DEVICE(dev);
> > > > > > > >  	TRACE_RESUME(0);
> > > > > > > >  
> > > > > > > > @@ -523,6 +552,7 @@ static int __device_resume_noirq(struct 
> > > > > > > >  	wake_up_all(&dev->power.wait_queue);
> > > > > > > >  
> > > > > > > >  	TRACE_RESUME(error);
> > > > > > > > +	TIMER_STOP(timer, dev, state, "EARLY");
> > > > > > > >  	return error;
> > > > > > > 
> > > > > > > Hm, these CPP macros are rather ugly. Why is there a need for 
> > > > > > > the TIMER_DECLARE() wrapper - if a proper inline function is 
> > > > > > > used there's no need for that.
> > > > > > 
> > > > > > I need a variable to be declared so that I can save the "start" 
> > > > > > timestamp in it.  I don't need the variable if DEBUG is unset, 
> > > > > > though.
> > > > > > 
> > > > > > How would you do that without using a macro?  Or #ifdef #endif 
> > > > > > block that would be uglier IMO (which is why I didn't do that)?
> > > > > 
> > > > > Well, why not use an inline function like i suggested? [which does 
> > > > > nothing in the !enabled case] You can keep the local variable always 
> > > > > defined.
> > > > 
> > > > Well, I used the macros _exactly_ because I didn't want to keep 
> > > > the local variable always defined.
> > > > 
> > > > Now, if you think that adding several useless bytes to the stack 
> > > > frame is OK, perhaps it can be always defined.  However, IMnsHO 
> > > > that would be (a) confusing (why define a variable you don't use) 
> > > > and (b) wasteful.
> > > 
> > > Well the compiler will eliminate them, doesnt it?
> > 
> > If the compiler is guaranteed to eliminate them (without 
> > generating a "variable defined but not used" warning for that 
> > matter), then they can be always defined.
> 
> Why should such a warning be generated if what makes use of it is an 
> inline function?
> 
> (it would be generated if it's a macro.)

OK, updated patch is appended.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Measure suspend and resume times for individual devices

If verbose PM debugging is enabled, measure and print the time of
suspending and resuming of individual devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   50 +++++++++++++++++++++++++++++++++++++++++-----
 kernel/power/swsusp.c     |    2 -
 2 files changed, 46 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -442,11 +442,11 @@ static bool pm_op_started(struct device 
  */
 int pm_time_elapsed(struct timeval *start, struct timeval *stop)
 {
-	s64 elapsed_centisecs64;
+	s64 elapsed_msecs64;
 
-	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
-	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
-	return elapsed_centisecs64;
+	elapsed_msecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
+	do_div(elapsed_msecs64, NSEC_PER_SEC / 1000);
+	return elapsed_msecs64;
 }
 
 static char *pm_verb(int event)
@@ -476,7 +476,7 @@ static char *pm_verb(int event)
 static void dpm_show_time(struct timeval *start, struct timeval *stop,
 			  pm_message_t state, const char *info)
 {
-	int centisecs = pm_time_elapsed(start, stop);
+	int centisecs = pm_time_elapsed(start, stop) / 10;
 
 	printk(KERN_INFO "PM: %s%s%s of devices complete in %d.%02d seconds\n",
 		info ? info : "", info ? " " : "", pm_verb(state.event),
@@ -497,6 +497,32 @@ static void pm_dev_err(struct device *de
 		kobject_name(&dev->kobj), pm_verb(state.event), info, error);
 }
 
+#ifdef DEBUG
+static void dbg_get_time(struct timeval *start)
+{
+	do_gettimeofday(start);
+}
+
+static void dbg_show_time(struct timeval *start, struct device *dev,
+			  pm_message_t state, char *info)
+{
+	struct timeval stop;
+	int msecs;
+
+	do_gettimeofday(&stop);
+	msecs = pm_time_elapsed(start, &stop);
+	dev_dbg(dev, "PID %d: %s%s%s complete in %d.%03d seconds\n",
+		task_pid_nr(current), info ? info : "", info ? " " : "",
+		pm_verb(state.event), msecs / 1000, msecs % 1000);
+}
+
+#else /* !DEBUG */
+static void dbg_get_time(struct timeval *start) {}
+static void dbg_show_time(struct timeval *start, struct device *dev,
+			  pm_message_t state, char *info) {}
+
+#endif /* !DEBUG */
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -510,7 +536,9 @@ static void pm_dev_err(struct device *de
 static int __device_resume_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
 
+	dbg_get_time(&start);
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
@@ -523,6 +551,7 @@ static int __device_resume_noirq(struct 
 	wake_up_all(&dev->power.wait_queue);
 
 	TRACE_RESUME(error);
+	dbg_show_time(&start, dev, state, "EARLY");
 	return error;
 }
 
@@ -639,7 +668,9 @@ EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 static int __device_resume(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
 
+	dbg_get_time(&start);
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
@@ -681,6 +712,7 @@ static int __device_resume(struct device
 	wake_up_all(&dev->power.wait_queue);
 
 	TRACE_RESUME(error);
+	dbg_show_time(&start, dev, state, NULL);
 	return error;
 }
 
@@ -923,6 +955,9 @@ static pm_message_t resume_event(pm_mess
 static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
+
+	dbg_get_time(&start);
 
 	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
@@ -932,6 +967,7 @@ static int __device_suspend_noirq(struct
 	dev->power.op_complete = true;
 	wake_up_all(&dev->power.wait_queue);
 
+	dbg_show_time(&start, dev, state, "LATE");
 	return error;
 }
 
@@ -1063,6 +1099,9 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
+	struct timeval start;
+
+	dbg_get_time(&start);
 
 	down(&dev->sem);
 
@@ -1103,6 +1142,7 @@ static int __device_suspend(struct devic
 	dev->power.op_complete = true;
 	wake_up_all(&dev->power.wait_queue);
 
+	dbg_show_time(&start, dev, state, NULL);
 	return error;
 }
 
Index: linux-2.6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.orig/kernel/power/swsusp.c
+++ linux-2.6/kernel/power/swsusp.c
@@ -169,7 +169,7 @@ int swsusp_swap_in_use(void)
 void swsusp_show_speed(struct timeval *start, struct timeval *stop,
 			unsigned nr_pages, char *msg)
 {
-	int centisecs = pm_time_elapsed(start, stop);
+	int centisecs = pm_time_elapsed(start, stop) / 10;
 	int k;
 	int kps;
 
