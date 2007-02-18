Return-Path: <linux-kernel-owner+w=401wt.eu-S1030402AbXBRHpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030402AbXBRHpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 02:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030410AbXBRHpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 02:45:06 -0500
Received: from fmx13.freemail.hu ([195.228.245.63]:38663 "HELO
	fmx13.freemail.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030402AbXBRHpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 02:45:04 -0500
Date: Sun, 18 Feb 2007 08:45:00 +0100 (CET)
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] input: extend EV_LED
To: Richard Purdie <rpurdie@rpsys.net>
cc: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <1171580944.5839.38.camel@localhost.localdomain>
Message-ID: <freemail.20070118084500.15225@fm07.freemail.hu>
X-Originating-IP: [80.98.105.91]
X-HTTP-User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.7.12) Gecko/20050920
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-Freemail: message scanned
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Feb 2007, Henrique de Moraes Holschuh wrote:
> On Thu, 15 Feb 2007, Richard Purdie wrote:
> > This has been discussed in several places several times.
The problem
> > with hardware accelerated flashing is that you're are
often limited to
> > certain constraints (this case being no exception) and
indicating what
> > these are to userspace in a generic fashion is difficult.
> 
> The hability to blinking at one rate is *very* common on
laptops.  Blinking
> at a few discrete rates is also common enough.  They
should be supported in
> a generic way.
> [...]
> Here's a suggestion for a simple, non-overengineered
interface: a "blink"
> attribute (on/off) for leds which can hardware-blink. 
Only one blink
> frequency is common enough that this attribute by itself
is very useful
> (e.g. it is all a ThinkPad and most WiFi/network card leds
need).
> 
> For hardware-blink leds with various frequencies, there is
the typical way
> to provide such things: give us a RO
blink_available_frequencies attribute
> which says which discrete frequencies are allowed (space
separated), and a
> RW blink_frequency attribute to set the frequency.  If
instead of
> blink_available_frequencies, the driver provides RO
blink_frequency_min and
> _max attributes, then it means it can blink on that range
of freqs.
> 
> That is simple enough to implement and use, and generic
enough.  You just
> need to set in stone if you want the freq in Hz, or a
submultiple.  You can
> even implement an optional "blink" software emulation that
drivers can hook
> into for systems where the driver *knows* that led access
is fast, but there
> is no hardware blinking emulation.
> 

A blinking led is basically a PWM (Pulse Width Modulation)
signal. A PWM signal has three different attribute. The
first one is the amplitude, this attribute is already
provided by the led subsystem as "brightness". There are two
more attributes, which are the frequency [Hz] and the duty
cycle [%], or the on-time [ms] and off-time [ms].

The frequency [Hz] and duty cycle [%] parameters has the
problem, that if we are limited to integers, it is not
possible to express slower blinks than 1Hz. We could also
use [mHz] (milli-Hertz), but it is not very common unit.

The on-time [ms] and off-time [ms] seems to be easier to
handle (and this is also easier to simulate from software if
ever needed). An RO attribute could be introduced:
'pwm_available', which can contain parameter pairs separated
by space, and the new parameter pair is in new line. An RW
attribute 'pwm' could accept a parameter pair separated by
space.

A range could be also given in 'pwm_available', like this:
'500-1000 500-1000'. This has the limitation that if there
is a hardware which can blink a LED in differet freqencies,
but only with fixed 50% duty cycle, the on-time off-time
pair cannot express this range easily.

My real-world example would be my Clevo D4J (D410J)
notebook's mail led. It has three known state: off, PWM at
1Hz (50%), PWM at 0.5Hz (50%). In case the on-time [ms]
off-time [ms] parameter pairs are used:

$ cat pwm_available
500 500
1000 1000

What is your opinion?
Is there more real-world hardware accelerated blinking LED
parameter examples?

        NMarci



__________________________________________________________________________
Kedvezõ tandíjak, különleges kedvezmények és magas szintû szolgáltatások. 
Ez az Educomm online nyelviskola és az egyedülálló EDUCATOR. Kattints ide!
http://ad.adverticum.net/b/cl,1,6022,131839,203066/click.prm


