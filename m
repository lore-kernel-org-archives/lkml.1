Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYG1SC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYG1SC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbYG1SCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:02:08 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:13775 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757814AbYG1SCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:02:07 -0400
Date: Mon, 28 Jul 2008 22:02:04 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Trent Piepho <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] leds: Support OpenFirmware led bindings
Message-ID: <20080728180204.GA13190@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp> <1217019705-24244-2-git-send-email-tpiepho@freescale.com> <20080727022116.GN12191@secretlab.ca> <Pine.LNX.4.64.0807272159500.26456@t2.domain.actdsltmp> <20080728170914.GA21265@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080728170914.GA21265@secretlab.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:09:14AM -0600, Grant Likely wrote:
[...]
> > >> +- function :  (optional) This parameter, if present, is a string
> > >> +  defining the function of the LED.  It can be used to put the LED
> > >> +  under software control, e.g. Linux LED triggers like "heartbeat",
> > >> +  "ide-disk", and "timer".  Or it could be used to attach a hardware
> > >> +  signal to the LED, e.g. a SoC that can configured to put a SATA
> > >> +  activity signal on a GPIO line.
> > >
> > > This makes me nervous.  It exposes Linux internal implementation details
> > > into the device tree data.  If you want to have a property that
> > > describes the LED usage, then the possible values and meanings should be
> > > documented here.
> > 
> > Should it be a linux specific property then?  I could list all the current
> > linux triggers, but enumerating every possible function someone might want
> > to assign to an LED seems hopeless.
> 
> I don't like adding Linux specific properties to the device tree if at
> all possible, and I really don't like encoding Linux internal details
> (like trigger names).  They can change between kernel versions and
> breaking compatibility with older device trees is strongly avoided.
> That's why so much effort goes into getting bindings correct the first
> time.
> 
> I'd rather see the device tree provide 'hints' toward the expected usage
> and if a platform needs something specific, then the platform specific
> code should setup the trigger.
> 
> Regardless, any hints provided by the binding must be documented.  In
> most cases the gpio-leds driver should be able to figure out which trigger
> to bind without platform code intervention.

Maybe we can encode leds into devices themselves, via phandles?

E.g.

sata@101 {
	compatible = "fsl,sata";
	leds = <&red_led>;
};

And then the OF GPIO LEDs driver could do something like:

char *ide_disk_trigger_compatibles[] = {
	"fsl,sata",
	"ide-generic",
	...
};

for_each_node_with_leds_property(node, led_phandle) {
	if (if_ide_disk_compatible(node)) {
		struct gpio_led *led = phandle_to_led(led_phandle);

		led->default_trigger = "ide-disk";
	}
}

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
