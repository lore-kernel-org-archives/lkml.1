Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668Ab0AZNfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0AZNfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431Ab0AZNfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:35:24 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:32364 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752235Ab0AZNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:35:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LzvPhg6YkBC3Oj1FArRCLkW8N51KmFeyUur39MjWgE6DjfOCWhLBwljGN+IwhbWH4g2HZLy5QJ3hUaccfos/v3+/lypqdPbn5jUwCYI+We1Ko0PX4hBuJt/V2kd44rVH5hcF9nh9z7/ITg4rj1ONodAf1WIkTiZh8kOfhVu97Bw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: wiIFiMUVM1nORR_l8O6ezsCVq_meg.wWql6ubPQ_mv6LIvYmFvJe3kD7P3wO1oyhULBb27KJazOfgqWtWgo8.vxGm4WwMyIVRxeJbLuQFwRC.xy4ZMrk_n69cCjQooWjaIYP14KeApU_lGOzMZAt12_vAGFBoCjj3j3GhZ4reKTTDcCnGukN0fC0PZqHsVQtox.k8xHXY8qYozZ8JWb2cxFc6YiTujKTHLwr.aUEw1UIn097c3PjqaogEc3nXb8u
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 05:35:21 -0800
User-Agent: KMail/1.9.10
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <201001260316.20529.david-b@pacbell.net> <20100126131146.GC32291@sirena.org.uk>
In-Reply-To: <20100126131146.GC32291@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001260535.21689.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Mark Brown wrote:
> On Tue, Jan 26, 2010 at 03:16:20AM -0800, David Brownell wrote:
> 
> > I'd vote to convert all the USB-to-charger interfaces so
> > they use notifiers.  After fixing the events ... see
> > comments below.  :)
> 
> Yes please - it's not just chargers either, this can also be used by
> PMICs which do power path management that includes USB.

Color me confused ... what do you mean by "power path"?

Do you mean something like "the board as a whole can take N mA of
current from USB", rather than specifically addressing a charger?

It's not uncommon to do things like use VBUS current to power the
USB circuitry, too.  That can leave less for other purposes.  All
of that being rather board-specific.


> > Those seem like the wrong events.  The right events for a charger
> > would be more along the lines of:
> 
> >  - For peripheral:  "you may use N milliAmperes now".
> >  - General:  "Don't Charge" (a.k.a. "use 0 mA").
> 
> > I don't see how "N" would be passed with those events ...
> 
> These are good for the peripheral side.  You do get to pass a void *
> along with the notifier value, that could be used to pass data like the
> current limit.

I don't think I saw that being done ... either in code, comments,
or documentation.  Passing N is fundamental.


> > A host *might* want to be able to say things like "supply
> > up to N milliAmperes now", e.g. to let a regulator choose
> > the most efficient mode.
> 
> Yes, they definitely want this - not just for efficiency but also to
> allow current limiting to protect the system from excessive current
> drain.

There are load bursting issues too.  All part of the USB spec;
a load that's OK for 1 millisecond might not be OK for 1 second.
ISTR the "supply N mA" refers to an average.  And there are some
limits to the capacitance that can practically be stuck on VBUS
output lines (which includes the cable).  Solvable problems, but
not always pretty if software has to think it through.

Thing is, supplying current is a bit more involved.  If the
board can't supply 300 mA, the USB configuration selection
mechanism has to know that, so it never selects peripheral
configurations which require that much current.

Or maybe these two ports can serve 500 mA, but not those two;
or their total can't exceed N (function of componentry and power
budgeting).

Ergo my desire to start with a straightforward problem whose
solution has real value (how much VBUS current may be consumed?),
and leave some of those other messes for later!

- Dave

