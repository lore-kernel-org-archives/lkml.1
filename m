Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZG2QvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZG2QvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbZG2QvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:51:19 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:51612 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbZG2QvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:51:19 -0400
Date: Wed, 29 Jul 2009 18:50:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
Message-ID: <20090729185009.540465f6@skybase>
In-Reply-To: <200907291510.n6TFAV8k000647@d06av06.portsmouth.uk.ibm.com>
References: <200907291510.n6TFAV8k000647@d06av06.portsmouth.uk.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 09:10:31 -0600
dwalker@fifo99.com wrote:

> On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> > There is still more room for improvement. Some sore points are:
> > 
> > 1) The cycle_last value still is in the struct clocksource. It should
> >    be in the struct timekeeper but the check against cycles_last in
> > the
> >    read function of the TSC clock source makes it hard.
> > 2) read_persistent_clock returns seconds. With a really good initial
> >    time source this is not very precise. read_persistent_clock should
> >    return a struct timespec.
> > 3) xtime, raw_time, total_sleep_time, timekeeping_suspended, jiffies,
> >    the ntp state and probably a few other values may be better located
> >    in the struct timekeeper as well.
> 
> 
> You could also consolidate the clocksource_unregister() path and the
> clocksource_change_rating(0) path  , both are basically doing the same
> thing.. Neither one is heavily used..

I'm not quite sure I got this. If I look at the code:

/**
 * clocksource_change_rating - Change the rating of a registered clocksource
 */
void clocksource_change_rating(struct clocksource *cs, int rating)
{
        mutex_lock(&clocksource_mutex);
        cs->rating = rating;
        clocksource_select();
        mutex_unlock(&clocksource_mutex);
}
EXPORT_SYMBOL(clocksource_change_rating);

/**
 * clocksource_unregister - remove a registered clocksource
 */
void clocksource_unregister(struct clocksource *cs)
{
        mutex_lock(&clocksource_mutex);
        clocksource_dequeue_watchdog(cs);
        list_del(&cs->list);
        clocksource_select();
        mutex_unlock(&clocksource_mutex);
}
EXPORT_SYMBOL(clocksource_unregister);

the two functions do different things. What exactly is the idea you've
got in mind?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

