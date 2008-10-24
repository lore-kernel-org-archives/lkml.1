Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYJXXHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYJXXHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYJXXGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:06:54 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:43476 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYJXXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:06:53 -0400
Date: Fri, 24 Oct 2008 16:04:57 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: linux-kernel@vger.kernel.org
cc: linuxppc-dev@ozlabs.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: OpenFirmware GPIO LED driver
Message-ID: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds support for OpenFirmware bindings for GPIO based
LEDs.

I last posted a version of this in July but discussion of the OF binding
details didn't seem to be going anywhere.

I've since been contacted by some people who are actually using the previous
patches and have been motivated to try again.

All the users of this code are satisfied with the current version and it does
everything they need it to do.

The first patch extends the of_get_gpio() function to provide the gpio flags.

The way this already works (i.e., this is not something I'm adding, it's
what's already there) is that the OF gpio specifier is an opaque sequence of
words.  The GPIO controller driver (of which only one currently exists)
provides an ->xlate() method that turns this into a Linux gpiolib gpio number. 
All current gpio controllers have flags in their gpio specifier, but there is
no way to get them.  So I extend the xlate method to also produce the flags in
a Linux format, the same way it produces a Linux gpio number.

The second patch adds OF bindings to the gpio-leds driver.  The existing code
is refactored so that almost all of the common code is shared between the two
binding methods.  Either or both bindings can be selected via Kconfig.  The
bindings do have one "linux," property, but no one has been able to come up
with something close to workable that avoids this and still satisfies the
*requirement* that the default trigger be settable from the OF bindings.

The second and third patches add some additional capabilities for gpio leds
that some users need.

One is to have a LED start in the on state when it's made known to Linux. 
There is already a "default-on" trigger that does this, but it produces a
glitch where an LED that is already on will turn off then back on.  My (tiny)
patch avoids this problem.

The next lets an LED stay, without glitches, in whatever state it was already
in when it's made known to Linux.  It may have been put into this state by the
BIOS, firmware, bootloader, or the hardware itself.
