Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbXCCIsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbXCCIsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 03:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXCCIsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 03:48:42 -0500
Received: from www.osadl.org ([213.239.205.134]:50920 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751263AbXCCIsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 03:48:41 -0500
Subject: Re: Is the clockevent resolution fine-grained enough?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Marko Rauhamaa <marko@pacujo.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m3k5xzy2w3.fsf@elektro.pacujo.net>
References: <m3649kweyj.fsf@elektro.pacujo.net>
	 <1172851546.24738.62.camel@localhost.localdomain>
	 <m3k5xzy2w3.fsf@elektro.pacujo.net>
Content-Type: text/plain; charset=utf-8
Date: Sat, 03 Mar 2007 09:54:30 +0100
Message-Id: <1172912070.24738.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 09:24 -0800, Marko Rauhamaa wrote:
> > That's an academic exercise, or are you talking about some real world
> > hardware which runs Linux ?
> 
> Real hardware running linux.

quantum computer ?

> > > In our application, we need periodic clock interrupts at about 100
> > > kHz.
> > 
> > With a stock kernel ?
> 
> Well, with a "clockevent" patch of our own. We'd like to use a stock
> kernel, though.

100khz on a stock kernel with real world hardware:

ROTFL, You made my day. 

> > > If the (programmable) frequency must be rounded to the nearest
> > > nanosecond, we have a cumulative error of
> > > 
> > >    100,000 * 0.5 ns/s = 50 µs/s
> > 
> > clockevents is based on the monotonic system clock and depends on the
> > accuracy of that and the device which deliveres the interrupts.
> > [...]
> > There is nothing to nugde. The clockevent subsystem operates on
> > absolute time, so there is no cummulative error, except you setup your
> > timers relative per event.
> 
> I'm afraid you didn't quite understand what I was getting at. Say the
> user programs the frequency to be 109,000 Hz. That means a nominal clock
> interval of ~9174.3119 ns. Now the clockevent interface forces me to
> round it down to 9174 ns. That means the clock interrupts fall behind
> with respect to the other parts in the system that implement 109,000 Hz
> much more to the letter. The error grows by 34 µs every second so that
> after 8 hours, we are lagging by a whole second.

Sorry man. Did you actually read what I wrote ? 

> The clockevent subsystem operates on absolute time, so there is no
> cummulative error

Again: clockevents operate on absolute time, so it is simply the fault
of the user, when he decides to do something stupid like:

femto_seconds_t interval;

timer_function()
{
	do_whatever_you_need_to_do();
	set_next_event(interval, RELATIVE);
}

instead of 

yokto_seconds_t interval;
yokto_seconds_t next_event;

timer_function()
{
	do_whatever_you_need_to_do();

	next_event += interval;
	set_next_event(yokto_seconds_to_nsec(next_event), ABSOLUTE);
}

Please read _AND_ understand the clockevents code. Your uber_clockevents
patch is solving PEBKAC.

	tglx


