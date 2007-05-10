Return-Path: <linux-kernel-owner+w=401wt.eu-S1760421AbXEJUDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbXEJUDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbXEJUDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:03:01 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52966 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118AbXEJUDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:03:00 -0400
Subject: Re: [PATCH] Introduce boot based time
From: john stultz <johnstul@us.ibm.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Tomas Janousek <tjanouse@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
In-Reply-To: <200705102149.01714.ioe-lkml@rameria.de>
References: <1178302732.5929.23.camel@localhost.localdomain>
	 <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
	 <200705102149.01714.ioe-lkml@rameria.de>
Content-Type: text/plain
Date: Thu, 10 May 2007 13:02:56 -0700
Message-Id: <1178827376.6011.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 21:48 +0200, Ingo Oeser wrote:
> Hi Tomas,
> 
> On Thursday 10 May 2007, Tomas Janousek wrote:
> > diff --git a/include/linux/time.h b/include/linux/time.h
> > index 8997b61..06f3eaf 100644
> > --- a/include/linux/time.h
> > +++ b/include/linux/time.h
> > @@ -116,6 +116,8 @@ extern int do_setitimer(int which, struct itimerval *value,
> >  extern unsigned int alarm_setitimer(unsigned int seconds);
> >  extern int do_getitimer(int which, struct itimerval *value);
> >  extern void getnstimeofday(struct timespec *tv);
> > +extern void getboottime(struct timespec *ts);
> > +extern void monotonic_to_bootbased(struct timespec *ts);
> >  
> >  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
> >  extern int timekeeping_is_continuous(void);
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index f9217bf..dd9647a 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -36,9 +36,17 @@ EXPORT_SYMBOL(xtime_lock);
> >   * at zero at system boot time, so wall_to_monotonic will be negative,
> >   * however, we will ALWAYS keep the tv_nsec part positive so we can use
> >   * the usual normalization.
> > + *
> > + * wall_to_monotonic is moved after resume from suspend for the monotonic
> > + * time not to jump. We need to add total_sleep_time to wall_to_monotonic
> > + * to get the real boot based time offset.
> > + *
> > + * - wall_to_monotonic is no longer the boot time, getboottime must be
> > + * used instead.
> >   */
> >  struct timespec xtime __attribute__ ((aligned (16)));
> >  struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
> > +static unsigned long total_sleep_time;
> 
> Could you make that a ktime_t (or struct ktime)?
> There are machines, which sleep more than they are awake. 
> Just imagine a surveillance camera triggered by door entrance.
> 
> Yes, these things might run Linux (e.g. on "cris" architecture).
> 
> Or your VCR.
> Yes, these devices might sleep more than they are awake, 
> if you are not a TV junkie :-)

I'm not sure I follow this. 

total_sleep_time stores seconds. So on 32bit systems that's 130some
years, so it shouldn't be an issue.

Is the reason you want it to be a ktime is because you want a way to
keep sub-second sleep granularity?

thanks
-john

