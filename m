Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXDMIml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXDMIml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXDMIml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:42:41 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:32615 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752980AbXDMImj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:42:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lLe+qW1+cu+NORszR5JfChGSsRqybfYpZ8KEcICayGCOlr+/dSVDbASnZC0lSgHmxv4whCveA82f9qKn0VGymn23GLRrhrroHvFmkff1x6qNaCJgyCFwHBNuamiEcnupftOkry2x+yJT5Q20J1gmcxvGbvbh7rXpPGqSLsIKz0o=  ;
X-YMail-OSG: xyWpXK0VM1ku93dUHI9Ga_ESoO.RSO2Yq3jpopqX1GMHTOgIR7IyQbFqaHH5zxYj5jDk3hHM_P_OTd.A5FaK76by.jtNyVaVO82eeD5xFHscNYCUk3s-
From: David Brownell <david-b@pacbell.net>
To: cbou@mail.ru
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Date: Fri, 13 Apr 2007 01:42:36 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704122306.46518.david-b@pacbell.net> <20070413073650.GA3763@zarina>
In-Reply-To: <20070413073650.GA3763@zarina>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704130142.37081.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 12:36 am, Anton Vorontsov wrote:
> Hello David,
> > 
> >  - The API needs to say *how much power* can be drawn...
> > 
> >  - Sensing VBUS power is not the same thing as being allowed to consume
> >    it.  Again, USB OTG devices are different:  OTG hosts **SUPPLY** the
> >    current, ...
> 
> I see. Current devices I have just consumes power from USB host. I.e.
> they able to boot using only USB and discharged battery. :-/ Even
> more, HP iPaq hx4700 able to charge battery from USB (using that driver).
> We just setting USB charging GPIO, and it starts consume power from
> the host.

Sounds like it could be more power than the host expects it to consume;
or in some cases, not as much as it could ... ISTR only the Ethernet
gadget defaults to 100mA (in non-OTG configs), the others are set for
only 2 mA (expecting self-powered configs).


> But I got the point, and yes I can't explain why it works correctly.

It probably doesn't work correctly.  But it's not broken enough to
fail badly.

 
> (1) Anyway, you're hinting that you'd want to see some
> "usb_vbus_start_consume_power(how much)" callback, which will be
> handled by gadget driver? 

The gadget API includes usb_gadget_vbus_draw(gadget, mA) which the
gadget drivers (e.g. network, storage, tty) issue.  How a given board
implements that is best wrapped in a transceiver abstraction, which
would also issue the usb_gadget_vbus_{connect,disconnect}(gadget)
notifications back to the controller.

That is, in the pure-peripheral case there are at three entities involved
outside the battery/power framework:  the gadget driver (what protocol is
used over USB), the peripheral controller driver (talking to USB hardware),
and the transceiver (sensing VBUS and managing power state transitions of
that controller).

In dumb cases (most reference boards!) the transceiver is stubbed
out, and there's no power management either to put the USB stuff
into lowpower mode when it's inactive, or to make use of VBUS power
to help manage the battery (what battery?).  In less dumb cases,
VBUS is only used to sense whether the host is there.  In vaguely
smart cases VBUS will be used to power the USB hardware (saving
maybe 40 mA of battery power in one case).  Recharging the battery
is for some reason not always supported even in product boards.


> Or it should just start using some gadget api? 
> Or even pda_battery must become an "usb power supplicant" gadget itself
> to consume power by law?

I don't know about this "supplicant" thing.  That's actually below
what the gadget API exposes -- implementation detail, but you're
thinking about how to implement such board-specific details.  I
guess I'd think that's a board-specific detail in the same way
that the transceiver is; you'll observe isp1301_omap is where
such things hook up in that example implementation.

- Dave



> I'm stuck in null-modem century, so don't wonder my USB-dumbness.
> Will read http://www.linux-usb.org/gadget/h2-otg.html, of course.
> 
> Though I'd appreciate answers for (1), thus I can think in right
> direction from the start.
> 
> Much thanks for your comments.
> 
> -- 
> Anton Vorontsov
> email: cbou@mail.ru
> backup email: ya-cbou@yandex.ru
> irc://irc.freenode.org/bd2
> 
