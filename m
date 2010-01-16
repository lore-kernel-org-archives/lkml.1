Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980Ab0APWdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0APWdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839Ab0APWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:33:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53349 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0APWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:33:13 -0500
Date: Sat, 16 Jan 2010 22:32:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Andy Walls <awalls@radix.net>,
       Eric Miao <eric.y.miao@gmail.com>, omegamoon@gmail.com,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       linux-kernel@vger.kernel.org, Dirk@opfer-online.de,
       Stanislav Brabec <utx@penguin.cz>, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Bart?omiej Zimo? <uzi18@o2.pl>, zaurus-devel@www.linuxtogo.org,
       Daniel Borkmann <danborkmann@googlemail.com>, thommycheck@gmail.com
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100116223230.GB23092@n2100.arm.linux.org.uk>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <1263661258.6596.10.camel@utx.utx.cz> <20100116181253.GC1603@ucw.cz> <201001162305.56972.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001162305.56972.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 11:05:56PM +0100, Rafael J. Wysocki wrote:
> On Saturday 16 January 2010, Pavel Machek wrote:
> > On Sat 2010-01-16 18:00:58, Stanislav Brabec wrote:
> > > Eric Miao wrote:
> > > 
> > > > And the other way we may need to look into what API the current userland
> > > > apps on zaurus is depending on this 2.4 compatibility and make changes
> > > > slowly to those apps.
> > > 
> > > I guess that 2.4 compatibility is not an issue. Most modern Zaurus
> > > distributions are even unable to run Sharp ROM compatible binaries.
> > > 
> > > Distributions either stay on 2.4 kernel or use modern systems based on
> > > modern kernel 2.6 API.
> > > 
> > > Distributions that decided to migrate to kernel 2.6 are far from
> > > finished state. Any change that allows to use modern applications using
> > > standard kernel API is welcome.
> > 
> > There is no API involved. It is just ... if you leave zaurus in
> >  init=/bin/bash mode, it must not kill the battery. Smart and
> >  currently implemented way to do that is to suspend.
> 
> IMHO it should just plain shutdown in that case.  Suspending doesn't really
> solve the problem, because the battery is going to drain still.  Unless you
> mean suspend=hibernate, but I guess you don't.

FYI, most handheld/palm-based devices don't have a "power off" mode,
short of opening them up and disconnecting the battery.  The "on/off"
button is really just a "suspend/resume" button.

So, when the battery gets critically low, your only option is to suspend.
If the battery continues to be drained, and it's a properly manufacturered
li-ion battery, it will have a discharge protection circuit inside the
battery which will effectively disconnect the battery until it's recharged.
There is no warning of this event.

The whole idea here is in a low battery sitution, is to place the system
into as low power state as possible to try to retain the users data.

(Some protection circuits monitor each li-ion cell, which means if you
have a single weak cell, it can trip before you get the critical suspend
notification.)

There are also some SoCs which have a battery fault input, which forces a
transition to suspend mode with no software intervention what so ever,
placing the SDRAM into self-refresh (data retention) mode.  Wakeup from
such a mode can only be done by total SoC reset once the fault input has
been removed.

Either way, the issue here is that when you get a critical low battery
notification, there may be seconds of power left if the system is fully
operational, and you must suspend as quickly as possible before the
hardware does something more destructive to your state.

Probably the best way of thinking about this is a layered set of
notifications:

- monitor battery level, cleanly suspend when down to N%
- if ignored, you get a critical low battery notification which forces
  an unclean suspend transition, retaining most device, CPU and RAM state.
- if ignored, a hardware initiated suspend transition occurs, retaining
  just RAM state.
- if that doesn't work, the battery itself cuts power and all state is
  lost.
