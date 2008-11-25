Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYKYSCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYKYSCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYKYSCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:02:46 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54677 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbYKYSCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:02:45 -0500
X-Sasl-enc: iIZRNC9k/6XilDtNXBdMtTmZgmn7w1tR+MAqJisq+xqt 1227636164
Date: Tue, 25 Nov 2008 16:02:41 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LEDs: allow led-drivers to use a wider than 0...255
	range of brightness values
Message-ID: <20081125180241.GA4783@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0811251751480.6290@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811251751480.6290@axis700.grange>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Guennadi Liakhovetski wrote:
> This patch allows drivers to override the default maximum brightness value of
> 255. We take care to preserve backwards-compatibility, so that user-space
> ABI doesn't change for existing drivers. All existing drivers have been verified
> to use a zero-initialised memory for their struct led_classdev objects, so that
> they will get the default maximum value of 255. New user-space software 
> can use a new read-only sysfs file /sys/class/leds/*/max_brightness to 
> retrieve maximum supported brightness of a specific LED.

I am not speaking AGAINST this change, I actually like the idea, especially
if we can set max_brightness to 1 and support binary (on/off) leds in a much
easier way :p

However, you must be aware that it IS still an ABI and API change.  Generic
LED drivers and triggers expect the [0, 255] scale, and expect 0 and 255 to
have special meanings (LED_OFF and LED_FULL).

I'd suggest that you set the new max_brightness field PROPERLY for all LEDs
(i.e. set it to 255), and fix all of the LED trigger code to use
max_brightness when it wants LED_FULL.

In fact, LED_FULL probably will need to become a function (inlineable), so
that triggers can just call led_set_to_max_brightness(theled), or
whatever...

That would still leave us with non-updated userspace not doing the right
thing when faced with a led with a range different from [0, 255], but there is
probably not a big set of userland doing generic LED control (and specific
LEDs have no reason to change their range from the default [0, 255]).

Either that, or maybe you could use an alternative way, like adding a
fractional component to the scale (which has its own problems, but it
probably can be done cleanly).  In that case, it is best to also add an
attribute to disclose the granularity supported by the LED driver.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
