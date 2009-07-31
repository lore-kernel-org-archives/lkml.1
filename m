Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZGaIN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZGaIN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZGaIN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:13:58 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:44734 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZGaIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:13:57 -0400
Date: Fri, 31 Jul 2009 10:13:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [RFC][patch 09/12] add xtime_shift and ntp_error_shift to
 struct timekeeper
Message-ID: <20090731101349.1adb0e95@skybase>
In-Reply-To: <1248992123.3374.24.camel@localhost>
References: <20090729134125.313191633@de.ibm.com>
	<20090729134231.269077552@de.ibm.com>
	<1248992123.3374.24.camel@localhost>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 15:15:23 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> > plain text document attachment (timekeeper-shift.diff)
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > The xtime_nsec value in the timekeeper structure is shifted by a few
> > bits to improve precision. This happens to be the same value as the
> > clock->shift. To improve readability add xtime_shift to the timekeeper
> > and use it instead of the clock->shift. Likewise add ntp_error_shift
> > and replace all (NTP_SCALE_SHIFT - clock->shift) expressions.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: john stultz <johnstul@us.ibm.com>
> > Cc: Daniel Walker <dwalker@fifo99.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > ---
> >  kernel/time/timekeeping.c |   33 ++++++++++++++++++---------------
> >  1 file changed, 18 insertions(+), 15 deletions(-)
> > 
> > Index: linux-2.6/kernel/time/timekeeping.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/time/timekeeping.c
> > +++ linux-2.6/kernel/time/timekeeping.c
> > @@ -27,6 +27,8 @@ struct timekeeper {
> >  	u32	raw_interval;
> >  	u64	xtime_nsec;
> >  	s64	ntp_error;
> > +	int	xtime_shift;
> > +	int	ntp_error_shift;
> >  };
> 
> I suspect ntp_error_shift is one of the lease intuitive values in the
> timekeeper structure. They all probably need nice comments explaining
> what they store, but especially this one. 
> 
> Something like:
> 
> struct clocksource *clock; /* current clocksource used for timekeeping*/
> cycle_t cycle_interval;	   /* fixed chunk of cycles used in accumulation */
> u64     xtime_interval;    /* number clock shifted nsecs accumulated per cycle_interval */
> u32	raw_interval;      /* raw nsecs accumulated per cycle_interval */
> u64	xtime_nsec;        /* clock shifted nsecs remainder not stored in xtime.tv_nsec */
> s64	ntp_error;         /* Difference between accumulated time and NTP time in ntp shifted nsecs */
> int	xtime_shift;       /* The shift value of the current clocksource */
> int	ntp_error_shift;   /* Shift conversion between clock shifted nsecs and ntp shifted nsecs */

For xtime_shift I would like to use a different comment. As I think
about the value it is the number of bits the xtime_nsec value is
shifted to improve precision. It is the same as clock->shift but the
semantics is different. How about:

        /* Shift conversion between the xtime_nsec remainder and nsecs */
        int     xtime_shift;

The other comments are good, I've added them.


> Other then that this patch looks ok, but will need rigorous testing, as
> its very complicated and difficult to understand code thats being
> changed.

This patch in particular is rather easy to verify, but the overall series
will definitely need some time in linux-next.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

