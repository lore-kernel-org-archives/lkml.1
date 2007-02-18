Return-Path: <linux-kernel-owner+w=401wt.eu-S1030400AbXBRIHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400AbXBRIHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 03:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030413AbXBRIHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 03:07:39 -0500
Received: from 1wt.eu ([62.212.114.60]:2474 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030400AbXBRIHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 03:07:38 -0500
Date: Sun, 18 Feb 2007 09:07:15 +0100
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Richard Purdie <rpurdie@rpsys.net>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: extend EV_LED
Message-ID: <20070218080715.GD943@1wt.eu>
References: <1171580944.5839.38.camel@localhost.localdomain> <freemail.20070118084500.15225@fm07.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <freemail.20070118084500.15225@fm07.freemail.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 08:45:00AM +0100, Németh Márton wrote:
> 
> On Fri, 16 Feb 2007, Henrique de Moraes Holschuh wrote:
> > On Thu, 15 Feb 2007, Richard Purdie wrote:
> > > This has been discussed in several places several times.
> The problem
> > > with hardware accelerated flashing is that you're are
> often limited to
> > > certain constraints (this case being no exception) and
> indicating what
> > > these are to userspace in a generic fashion is difficult.
> > 
> > The hability to blinking at one rate is *very* common on
> laptops.  Blinking
> > at a few discrete rates is also common enough.  They
> should be supported in
> > a generic way.
> > [...]
> > Here's a suggestion for a simple, non-overengineered
> interface: a "blink"
> > attribute (on/off) for leds which can hardware-blink. 
> Only one blink
> > frequency is common enough that this attribute by itself
> is very useful
> > (e.g. it is all a ThinkPad and most WiFi/network card leds
> need).
> > 
> > For hardware-blink leds with various frequencies, there is
> the typical way
> > to provide such things: give us a RO
> blink_available_frequencies attribute
> > which says which discrete frequencies are allowed (space
> separated), and a
> > RW blink_frequency attribute to set the frequency.  If
> instead of
> > blink_available_frequencies, the driver provides RO
> blink_frequency_min and
> > _max attributes, then it means it can blink on that range
> of freqs.
> > 
> > That is simple enough to implement and use, and generic
> enough.  You just
> > need to set in stone if you want the freq in Hz, or a
> submultiple.  You can
> > even implement an optional "blink" software emulation that
> drivers can hook
> > into for systems where the driver *knows* that led access
> is fast, but there
> > is no hardware blinking emulation.
> > 
> 
> A blinking led is basically a PWM (Pulse Width Modulation)
> signal. A PWM signal has three different attribute. The
> first one is the amplitude, this attribute is already
> provided by the led subsystem as "brightness". There are two
> more attributes, which are the frequency [Hz] and the duty
> cycle [%], or the on-time [ms] and off-time [ms].
> 
> The frequency [Hz] and duty cycle [%] parameters has the
> problem, that if we are limited to integers, it is not
> possible to express slower blinks than 1Hz. We could also
> use [mHz] (milli-Hertz), but it is not very common unit.
> 
> The on-time [ms] and off-time [ms] seems to be easier to
> handle (and this is also easier to simulate from software if
> ever needed). An RO attribute could be introduced:
> 'pwm_available', which can contain parameter pairs separated
> by space, and the new parameter pair is in new line. An RW
> attribute 'pwm' could accept a parameter pair separated by
> space.
> 
> A range could be also given in 'pwm_available', like this:
> '500-1000 500-1000'. This has the limitation that if there
> is a hardware which can blink a LED in differet freqencies,
> but only with fixed 50% duty cycle, the on-time off-time
> pair cannot express this range easily.
> 
> My real-world example would be my Clevo D4J (D410J)
> notebook's mail led. It has three known state: off, PWM at
> 1Hz (50%), PWM at 0.5Hz (50%). In case the on-time [ms]
> off-time [ms] parameter pairs are used:
> 
> $ cat pwm_available
> 500 500
> 1000 1000
> 
> What is your opinion?

Maybe you should consider that if there's only one parameter,
it implies both on- and off- times, leading to a duty cycle
of 50% ?

It would also make it easier to get and set the frequency
when the duty cycle is assumed to be 50%.

Also, I'm not sure that a resolution of 1ms really is
appropriate, in case you encounter hardware with better
resolution. With ms, at high blink rates (>=100 Hz),
you're bound to 500,333,250,200,166,142,125,111,100 Hz,
which does not give you much control over the duty cycle
for devices with a high frequency.

Maybe you should express the on- and off- times in microseconds ?

Just my two cents anyway since I'm not directly concerned
by such devices.

Regards,
Willy

