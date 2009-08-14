Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZHNIKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZHNIKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZHNIKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:10:33 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:52534 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZHNIKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:10:31 -0400
Date: Fri, 14 Aug 2009 10:10:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [patch 02/14] remove clocksource inline functions
Message-ID: <20090814101013.43e88657@skybase>
In-Reply-To: <1250201674.7149.3.camel@localhost.localdomain>
References: <20090813154034.613706651@de.ibm.com>
	<20090813154159.634291990@de.ibm.com>
	<1250201674.7149.3.camel@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 15:14:34 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Thu, 2009-08-13 at 17:40 +0200, Martin Schwidefsky wrote:
> > Index: linux-2.6/kernel/time/timekeeping.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/time/timekeeping.c
> > +++ linux-2.6/kernel/time/timekeeping.c
> [snip]
> > @@ -477,8 +492,7 @@ static int timekeeping_resume(struct sys
> >  	}
> >  	update_xtime_cache(0);
> >  	/* re-base the last cycle value */
> > -	clock->cycle_last = 0;
> > -	clock->cycle_last = clocksource_read(clock);
> > +	clock->cycle_last = clock->read(clock);
> 
> Minor bug here, the clearing of cycle_last has a side-effect of making
> sure the TSC doesn't trip over its own cycle_last checking in the read()
> function. This is part of the uglyness of the TSC pulling this internal
> timeekping state to avoid minor inconsistencies, but until we find a
> better way, we have to live with it.
> 
> So you'll need to preserve the cycle_last = 0 line.

Whoa, now that is subtle. Good spotting. I would prefer to reset the 
cycle_last in a resume function though:

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -744,10 +744,16 @@ static cycle_t __vsyscall_fn vread_tsc(v
 }
 #endif

+static void resume_tsc(void)
+{
+       clocksource_tsc.cycle_last = 0;
+}
+
 static struct clocksource clocksource_tsc = {
        .name                   = "tsc",
        .rating                 = 300,
        .read                   = read_tsc,
+       .resume                 = resume_tsc,
        .mask                   = CLOCKSOURCE_MASK(64),
        .shift                  = 22,
        .flags                  = CLOCK_SOURCE_IS_CONTINUOUS |

That puts the subtlety where it belongs.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

