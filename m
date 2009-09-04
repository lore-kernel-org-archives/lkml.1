Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbZIDTNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbZIDTNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbZIDTNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:13:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166AbZIDTNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:13:13 -0400
Date: Fri, 4 Sep 2009 21:12:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10] PM: Measure suspend and resume times for individual
	devices (was: Re: [PATCH 2/6] PM: Asynchronous resume of devices)
Message-ID: <20090904191205.GA28408@elte.hu>
References: <Pine.LNX.4.44L0.0908292043500.26533-100000@netrider.rowland.org> <200908311756.54624.rjw@sisk.pl> <20090904075117.GF20598@elte.hu> <200909041642.03774.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909041642.03774.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Friday 04 September 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Monday 31 August 2009, Ingo Molnar wrote:
> > > > 
> > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > 
> > > > > On Monday 31 August 2009, Ingo Molnar wrote:
> > > > > > 
> > > > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > > 
> > > > > > > On Sunday 30 August 2009, Rafael J. Wysocki wrote:
> > > > > > > > On Sunday 30 August 2009, Alan Stern wrote:
> > > > > > > > > On Sat, 29 Aug 2009, Rafael J. Wysocki wrote:
> > > > > > > > > 
> > > > > > > > > > I only wanted to say that the advantage is not really that "big". :-)
> > > > > > > > > > 
> > > > > > > > > > > I must agree, 14 threads isn't a lot.  But at the moment that number is 
> > > > > > > > > > > random, not under your control.
> > > > > > > > > > 
> > > > > > > > > > It's not directly controlled, but there are some interactions between the
> > > > > > > > > > async threads, the main threads and the async framework that don't allow this
> > > > > > > > > > number to grow too much.
> > > > > > > > > > 
> > > > > > > > > > IMO it sometimes is better to allow things to work themselves out, as long as
> > > > > > > > > > they don't explode, than to try to keep everything under strict control.  YMMV.
> > > > > > > > > 
> > > > > > > > > For testing purposes it would be nice to have a one-line summary for
> > > > > > > > > each device containing a thread ID, start timestamp, end timestamp, and
> > > > > > > > > elapsed time.  With that information you could evaluate the amount of
> > > > > > > > > parallelism and determine where the bottlenecks are.  It would give a
> > > > > > > > > much more detailed picture of the entire process than the total time of
> > > > > > > > > your recent patch 9.
> > > > > > > > 
> > > > > > > > Of course it would.  I think I'll implement it.
> > > > > > > 
> > > > > > > OK, below is a patch for that.  It only prints the time elapsed, because the
> > > > > > > timestamps themselves can be obtained from the usual kernel timestamping.
> > > > > > > 
> > > > > > > It's on top of all the previous patches.
> > > > > > > 
> > > > > > > Thanks,
> > > > > > > Rafael
> > > > > > > 
> > > > > > > ---
> > > > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > > Subject: PM: Measure suspend and resume times for individual devices
> > > > > > > 
> > > > > > > If verbose PM debugging is enabled, measure and print the time of
> > > > > > > suspending and resuming of individual devices.
> > > > > > > 
> > > > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > > ---
> > > > > > >  drivers/base/power/main.c |   51 +++++++++++++++++++++++++++++++++++++++++-----
> > > > > > >  kernel/power/swsusp.c     |    2 -
> > > > > > >  2 files changed, 47 insertions(+), 6 deletions(-)
> > > > > > > 
> > > > > > > Index: linux-2.6/drivers/base/power/main.c
> > > > > > > ===================================================================
> > > > > > > --- linux-2.6.orig/drivers/base/power/main.c
> > > > > > > +++ linux-2.6/drivers/base/power/main.c
> > > > > > > @@ -442,11 +442,11 @@ static bool pm_op_started(struct device 
> > > > > > >   */
> > > > > > >  int pm_time_elapsed(struct timeval *start, struct timeval *stop)
> > > > > > >  {
> > > > > > > -	s64 elapsed_centisecs64;
> > > > > > > +	s64 elapsed_msecs64;
> > > > > > >  
> > > > > > > -	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
> > > > > > > -	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
> > > > > > > -	return elapsed_centisecs64;
> > > > > > > +	elapsed_msecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
> > > > > > > +	do_div(elapsed_msecs64, NSEC_PER_SEC / 1000);
> > > > > > > +	return elapsed_msecs64;
> > > > > > >  }
> > > > > > >  
> > > > > > >  static char *pm_verb(int event)
> > > > > > > @@ -476,7 +476,7 @@ static char *pm_verb(int event)
> > > > > > >  static void dpm_show_time(struct timeval *start, struct timeval *stop,
> > > > > > >  			  pm_message_t state, const char *info)
> > > > > > >  {
> > > > > > > -	int centisecs = pm_time_elapsed(start, stop);
> > > > > > > +	int centisecs = pm_time_elapsed(start, stop) / 10;
> > > > > > >  
> > > > > > >  	printk(KERN_INFO "PM: %s%s%s of devices complete in %d.%02d seconds\n",
> > > > > > >  		info ? info : "", info ? " " : "", pm_verb(state.event),
> > > > > > > @@ -497,6 +497,33 @@ static void pm_dev_err(struct device *de
> > > > > > >  		kobject_name(&dev->kobj), pm_verb(state.event), info, error);
> > > > > > >  }
> > > > > > >  
> > > > > > > +#ifdef DEBUG
> > > > > > > +static void device_show_time(struct timeval *start, struct device *dev,
> > > > > > > +			     pm_message_t state, char *info)
> > > > > > > +{
> > > > > > > +	struct timeval stop;
> > > > > > > +	int msecs;
> > > > > > > +
> > > > > > > +	do_gettimeofday(&stop);
> > > > > > > +	msecs = pm_time_elapsed(start, &stop);
> > > > > > > +	dev_dbg(dev, "PID %d: %s%s%s complete in %d.%03d seconds\n",
> > > > > > > +		task_pid_nr(current), info ? info : "", info ? " " : "",
> > > > > > > +		pm_verb(state.event), msecs / 1000, msecs % 1000);
> > > > > > > +}
> > > > > > > +
> > > > > > > +#define TIMER_DECLARE(timer)	struct timeval timer
> > > > > > > +#define TIMER_START(timer)	do { \
> > > > > > > +		do_gettimeofday(&timer); \
> > > > > > > +	} while (0)
> > > > > > > +#define TIMER_STOP(timer, dev, state, info)	do { \
> > > > > > > +		device_show_time(&timer, dev, state, info); \
> > > > > > > +	} while (0)
> > > > > > > +#else /* !DEBUG */
> > > > > > > +#define TIMER_DECLARE(timer)
> > > > > > > +#define TIMER_START(timer)	do { } while (0)
> > > > > > > +#define TIMER_STOP(timer, dev, state, info)	do { } while (0)
> > > > > > > +#endif /* !DEBUG */
> > > > > > > +
> > > > > > >  /*------------------------- Resume routines -------------------------*/
> > > > > > >  
> > > > > > >  /**
> > > > > > > @@ -510,7 +537,9 @@ static void pm_dev_err(struct device *de
> > > > > > >  static int __device_resume_noirq(struct device *dev, pm_message_t state)
> > > > > > >  {
> > > > > > >  	int error = 0;
> > > > > > > +	TIMER_DECLARE(timer);
> > > > > > >  
> > > > > > > +	TIMER_START(timer);
> > > > > > >  	TRACE_DEVICE(dev);
> > > > > > >  	TRACE_RESUME(0);
> > > > > > >  
> > > > > > > @@ -523,6 +552,7 @@ static int __device_resume_noirq(struct 
> > > > > > >  	wake_up_all(&dev->power.wait_queue);
> > > > > > >  
> > > > > > >  	TRACE_RESUME(error);
> > > > > > > +	TIMER_STOP(timer, dev, state, "EARLY");
> > > > > > >  	return error;
> > > > > > 
> > > > > > Hm, these CPP macros are rather ugly. Why is there a need for 
> > > > > > the TIMER_DECLARE() wrapper - if a proper inline function is 
> > > > > > used there's no need for that.
> > > > > 
> > > > > I need a variable to be declared so that I can save the "start" 
> > > > > timestamp in it.  I don't need the variable if DEBUG is unset, 
> > > > > though.
> > > > > 
> > > > > How would you do that without using a macro?  Or #ifdef #endif 
> > > > > block that would be uglier IMO (which is why I didn't do that)?
> > > > 
> > > > Well, why not use an inline function like i suggested? [which does 
> > > > nothing in the !enabled case] You can keep the local variable always 
> > > > defined.
> > > 
> > > Well, I used the macros _exactly_ because I didn't want to keep 
> > > the local variable always defined.
> > > 
> > > Now, if you think that adding several useless bytes to the stack 
> > > frame is OK, perhaps it can be always defined.  However, IMnsHO 
> > > that would be (a) confusing (why define a variable you don't use) 
> > > and (b) wasteful.
> > 
> > Well the compiler will eliminate them, doesnt it?
> 
> If the compiler is guaranteed to eliminate them (without 
> generating a "variable defined but not used" warning for that 
> matter), then they can be always defined.

Why should such a warning be generated if what makes use of it is an 
inline function?

(it would be generated if it's a macro.)

	Ingo
