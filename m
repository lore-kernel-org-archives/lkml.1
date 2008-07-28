Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbYG1RJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbYG1RJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbYG1RJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:09:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:59629 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbYG1RJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:09:18 -0400
Date: Mon, 28 Jul 2008 11:09:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] leds: Support OpenFirmware led bindings
Message-ID: <20080728170914.GA21265@secretlab.ca>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp> <1217019705-24244-2-git-send-email-tpiepho@freescale.com> <20080727022116.GN12191@secretlab.ca> <Pine.LNX.4.64.0807272159500.26456@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807272159500.26456@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 01:31:47AM -0700, Trent Piepho wrote:
> On Sat, 26 Jul 2008, Grant Likely wrote:
> > On Fri, Jul 25, 2008 at 02:01:45PM -0700, Trent Piepho wrote:
> >> Add bindings to support LEDs defined as of_platform devices in addition to
> >> the existing bindings for platform devices.
> >
> >> +- gpios :  Should specify the LED GPIO.
> >
> > Question: it is possible/desirable for a single LED to be assigned
> > multiple GPIO pins?  Say, for a tri-color LED?  (I'm fishing for
> > opinions; I really don't know if it would be a good idea or not)
> 
> Good question.  The Linux LED layer has no concept of multi-color LEDs, so
> it's more difficult that just adding support to the gpio led driver.  I have
> a device with a tri-color red/green/orange LED and this posed some
> difficulty.  It's defined as independent red and greed LEDs, which is mostly
> fine, except I wanted it to flash orange.  I can make both the red LED and
> green LED flash, but there is nothing to insure their flashing remains in
> sync.
> 
> Other OF bindings allow multiple GPIOs to be listed in a gpios property, so
> that's not a problem if someone wants to do that.  There would need to be a
> way to define what the gpios mean.  I don't think it's worthwhile to come up
> with a binding for that until there is a real user.

True.  The binding can be extended at a later date anyway.  It might be
as simple as adding an array of strings that define what each gpio value
means.  ie.  if 2 gpio lines are used for a led, then that maps to
numbers in the range [0, 1, 2, 3].  It could be encoded thus:

        led-states = "off", "green", "red", "orange";

The driver would then need to interpret/adapt these strings to something
useful in the LED driver.  Just a thought.

> >> +- function :  (optional) This parameter, if present, is a string
> >> +  defining the function of the LED.  It can be used to put the LED
> >> +  under software control, e.g. Linux LED triggers like "heartbeat",
> >> +  "ide-disk", and "timer".  Or it could be used to attach a hardware
> >> +  signal to the LED, e.g. a SoC that can configured to put a SATA
> >> +  activity signal on a GPIO line.
> >
> > This makes me nervous.  It exposes Linux internal implementation details
> > into the device tree data.  If you want to have a property that
> > describes the LED usage, then the possible values and meanings should be
> > documented here.
> 
> Should it be a linux specific property then?  I could list all the current
> linux triggers, but enumerating every possible function someone might want
> to assign to an LED seems hopeless.

I don't like adding Linux specific properties to the device tree if at
all possible, and I really don't like encoding Linux internal details
(like trigger names).  They can change between kernel versions and
breaking compatibility with older device trees is strongly avoided.
That's why so much effort goes into getting bindings correct the first
time.

I'd rather see the device tree provide 'hints' toward the expected usage
and if a platform needs something specific, then the platform specific
code should setup the trigger.

Regardless, any hints provided by the binding must be documented.  In
most cases the gpio-leds driver should be able to figure out which trigger
to bind without platform code intervention.

g.
