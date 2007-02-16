Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbXBPDM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbXBPDM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 22:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbXBPDM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 22:12:26 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48415 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932570AbXBPDMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 22:12:25 -0500
X-Sasl-enc: CzkvZACPyiCimUZpNlw9zesuFVTHmCUSjEGkgDIbl/Es 1171595553
Date: Fri, 16 Feb 2007 01:12:19 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] input: extend EV_LED
Message-ID: <20070216031219.GA2397@khazad-dum.debian.net>
References: <freemail.20070115234756.58787@fm13.freemail.hu> <1171580944.5839.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171580944.5839.38.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Richard Purdie wrote:
> This has been discussed in several places several times. The problem
> with hardware accelerated flashing is that you're are often limited to
> certain constraints (this case being no exception) and indicating what
> these are to userspace in a generic fashion is difficult.

The hability to blinking at one rate is *very* common on laptops.  Blinking
at a few discrete rates is also common enough.  They should be supported in
a generic way.

I want to convert ibm-acpi to the led interface, but if it means I have to
provide custom attributes on top of the led class, it sort of defeats most
of the purpose of using the led class to begin with -- it will NOT be
generic.

If I have to provide those attributes elsewhere in the sysfs tree other than
somewhere in the led class, then it defeats the purpose of using the led
class completely:  I will just scrap the idea.  I am not going to remove
functionality.  And I am not going to emulate in software something the
hardware can do, especially when that means bothering the EC with a slow
ACPI-subsystem-gated LPC bus IO port access for no good reason.

Here's a suggestion for a simple, non-overengineered interface: a "blink"
attribute (on/off) for leds which can hardware-blink.  Only one blink
frequency is common enough that this attribute by itself is very useful
(e.g. it is all a ThinkPad and most WiFi/network card leds need).

For hardware-blink leds with various frequencies, there is the typical way
to provide such things: give us a RO blink_available_frequencies attribute
which says which discrete frequencies are allowed (space separated), and a
RW blink_frequency attribute to set the frequency.  If instead of
blink_available_frequencies, the driver provides RO blink_frequency_min and
_max attributes, then it means it can blink on that range of freqs.

That is simple enough to implement and use, and generic enough.  You just
need to set in stone if you want the freq in Hz, or a submultiple.  You can
even implement an optional "blink" software emulation that drivers can hook
into for systems where the driver *knows* that led access is fast, but there
is no hardware blinking emulation.

> One way I've come up with is adds capability to the class to have LED
> specific triggers and you can then expose these hardware capabilities as
> an extra trigger specific to the LED.

How would that look like?  It doesn't sound too bad.  Could you give us an
example of what the tree would look like, and what the attributes would be
(and do)?

> Another proposal more specific to this use case was to have some
> information behind the scenes which the software timer based trigger
> could use to turn on the "hardware acceleration" if present and capable
> of the requested mode. This might just need a function pointer in the
> core so could be quite neat.

This looks like a severely overengineered way to deal with the problem at
first glance.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
