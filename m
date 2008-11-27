Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYK0ObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYK0ObS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYK0ObD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:31:03 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48008 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYK0ObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:31:00 -0500
X-Sasl-enc: TN9UFS4hk/DE5nGIqKaNj04mzqbaouUJ8UyKRDEIMhKn 1227796259
Date: Thu, 27 Nov 2008 12:30:55 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] LEDs: allow led-drivers to use a wider than 0...255
	range of brightness values
Message-ID: <20081127143055.GA4678@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0811251751480.6290@axis700.grange> <20081125180241.GA4783@khazad-dum.debian.net> <Pine.LNX.4.64.0811261535590.4749@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811261535590.4749@axis700.grange>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Guennadi Liakhovetski wrote:
> This patch allows drivers to override the default maximum brightness value 
> of 255. We take care to preserve backwards-compatibility as much as 
> possible, so that user-space ABI doesn't change for existing drivers. All 
> existing drivers have been modified to explicitly set their maximum 
> brightness to LED_FULL. LED trigger code has also been updated to use the 
> per-LED maximum.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
> 
> On Tue, 25 Nov 2008, 
> Henrique de Moraes Holschuh wrote:
> 
> > On Tue, 25 Nov 2008, Guennadi Liakhovetski wrote:
> > > This patch allows drivers to override the default maximum brightness value of
> > > 255. We take care to preserve backwards-compatibility, so that user-space
> > > ABI doesn't change for existing drivers. All existing drivers have been verified
> > > to use a zero-initialised memory for their struct led_classdev objects, so that
> > > they will get the default maximum value of 255. New user-space software 
> > > can use a new read-only sysfs file /sys/class/leds/*/max_brightness to 
> > > retrieve maximum supported brightness of a specific LED.
> > 
> > I am not speaking AGAINST this change, I actually like the idea, especially
> > if we can set max_brightness to 1 and support binary (on/off) leds in a much
> > easier way :p
> > 
> > However, you must be aware that it IS still an ABI and API change.  Generic
> > LED drivers and triggers expect the [0, 255] scale, and expect 0 and 255 to
> > have special meanings (LED_OFF and LED_FULL).
> > 
> > I'd suggest that you set the new max_brightness field PROPERLY for all LEDs
> 
> Done.
> 
> > (i.e. set it to 255), and fix all of the LED trigger code to use
> > max_brightness when it wants LED_FULL.
> 
> Done.
> 
> > In fact, LED_FULL probably will need to become a function (inlineable), so
> > that triggers can just call led_set_to_max_brightness(theled), or
> > whatever...
> 
> Triggers do this in different ways, two of them first calculate the new 
> brightness in a variable, then use it to update brightness, one of them 
> (default-on) just sets it permanently to FULL / max, yet another one 
> (ide-disk) calls led_trigger_event(). So, it looks like such a function 
> wouldn't being much.

Yeah, but one thing I learned from messing with rfkill is that little helper
functions can go a LONG way into making an API easier to use right.

> > That would still leave us with non-updated userspace not doing the right
> > thing when faced with a led with a range different from [0, 255], but there is
> > probably not a big set of userland doing generic LED control (and specific
> > LEDs have no reason to change their range from the default [0, 255]).
> 
> I also don't think there are too many applications out there that will be 
> endangered by this patch.
> 
> > Either that, or maybe you could use an alternative way, like adding a
> > fractional component to the scale (which has its own problems, but it
> > probably can be done cleanly).  In that case, it is best to also add an
> > attribute to disclose the granularity supported by the LED driver.
> 
> Would you then have to do "echo 100.5 > brightness"?...

Or add an integer attribute for the fractional part (which takes some
thought to do correctly), since fp is frowned upon in sysfs...

> A second version of the patch below.

Frankly, I don't like the fact that LED_FULL survived.  That's a trap
waiting to be sprung on any unsuspecting maintainers adding or messing with
LED support everywhere in the kernel...

IMO, it'd be best to have an DEFAULT_LED_FULL_VALUE define you can use to
set max_brightness where needed, and use the gcc facilities to deprecate any
use of LED_FULL.

Richard?  What is your take on this?  I am not the right person to be
reviewing LED code...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
