Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXEULbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXEULbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXEULbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:31:31 -0400
Received: from mail.suse.de ([195.135.220.2]:34041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXEULba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:31:30 -0400
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       len.brown@intel.com, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <200705202350.45145.lenb@kernel.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <200705171517.14087.lenb@kernel.org>
	 <1179604609.16465.83.camel@sublime.suse.de>
	 <200705202350.45145.lenb@kernel.org>
Content-Type: text/plain
Date: Mon, 21 May 2007 06:31:38 -0500
Message-Id: <1179747098.20299.53.camel@sublime.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 23:50 -0400, Len Brown wrote:
> On Saturday 19 May 2007 15:56, Thomas Renninger wrote:
> > On Thu, 2007-05-17 at 15:17 -0400, Len Brown wrote:
> > > On Thursday 17 May 2007 05:23, Pavel Machek wrote:
> > > 
> > > > >     ACPI: thermal trip points are read-only
> > > > 
> > > > What was the rationale? Can we get this one reverted? 
> > > > 
> > > > Some machines (HP omnibook xe3) have broken trip points -- too high --
> > > > so machine will overheat and trigger hw shutdown before starting
> > > > passive cooling.
> > > > 
> > > > That's really broken, and write to trip points is reasonable way to
> > > > 'fix' that. (I'd understand if you only ever let trip points to
> > > > decrease... but otoh root should be able to shoot himself....)
> > > 
> > > No, writing trip-points is neither a fix, nor it is reasonable.
> > > It is a workaround at best, and it is a dangerous and mis-leading hack.
> > Yes it is a workaround for critical ACPI bugs like that or similar:
> > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/22336
> 
> Thanks for pointing that out -- it is a great example
> of how powerful mis-information can be.
> 
> The fact that the trip-points are writable has obscured,
> rather than clarified, the actual causes of the failures.
> No less than 4 people in that bug report declared that
> cleaning the dust out of their fan fixed the root cause.
> A bunch more said that the issues went away when they 
> stopped using ubuntu's user-space power save daemon.
> 
> There are a couple more with broken active fan control --
> which also gets obscured rather than clarified by
> over-riding trip points.
> 
> And finally, there are probably some with clean fans
> that are working properly, but are thermally challenged
> systems.  I'll venture that Windows is NOT modifying or disabling
> the critical trip point to work around this issue.
> I'll venture that their thermal throttling is working
> and ours may not be.
> 
> perhaps it was the recently fixed mod_timer() bug in thermal.c,
> or perhaps it is one that we don't know about yet...
> 
Whatever it was, it's in a final Ubuntu dist and the trip point
interface
could help some people to still be able to use it.

ACPI is very machine specific. 100 machines may work well and QA might
oversee the 100 and first where critical shutdowns or whatever happens.
Such workarounds are really helpful then.

Same for ignore _PPC and thermal polling (the latter is always on in our
distro,
I bet a lot machine would break if disabling it and just ripping out the
ability to set it, is really not a solution).

One big challenge in the ACPI subsystem (kernel or userspace) is to find
out BIOS implemenations that are at the limit of specs or which violate
the
specs and try to workaround them.
We are not in the position of M$ (at least in the desktop/laptop
segment) yet.
BIOS developers won't follow our implementations and IMO we should go
the
other way and provide more workarounds. If nobody needs them, the
better.

> > It's also convenient to e.g. lower passive trip point to avoid fan
> > noise.
> 
> nope, the OS can't reliably override the processor passive trip point.
> That is what _SCP and cooling_mode are for.
> 
> The reason is that the BIOS can send us a trip-point changed event at any time,
> the kernel will evaluate _PSV, and wipe out the modified OS version.
> 
> if you want to change the state of the fans,
> then poke /proc/acpi/fan/ directly.
> This will have effect until the next trip point
> changes its state.

> 
> > Some people are used to it, I already wanted to write a little userspace
> > prog to use them as it is really easy to fake cooling_mode (trip points
> > are modified by BIOS) and eliminate fan noise and other things by e.g.
> > reducing passsive or whatever trip point.
> 
> please save this effort for a non-ACPI system.
> 
> > This is at least a major sysfs interface change, has this been discussed
> > somewhere before or declared deprecated?
> 
> it went out on linux-acpi, but I don't recall any discussion about it.
> 
> > It's there for a long time, why is this "a dangerous and mis-leading
> > hack." now?
> 
> It has been dangerous and misleading since the day it went in.
> If the user doesn't enable polling, then they are effectively
> writing random numbers that have absolutely no effect on
> the operation of the system, and hiding the numbers that
> do control the operation of the system.
> 
> > I'd suggest to revert this and I can come with something like "only
> > allow lower values
> > than BIOS provides" patch if the current implementation is considered
> > dangerous.
> 
> That simply will not address the issue.
> Indeed, all the entries in the ubuntu bug report are about hitting
> the critical temperature and having a critical shutdown when
> it isn't wanted.  These people want to RAISE the critical shutdown
> trip-point.  Their cooling problems must be fixed -- raising critical
> trip points causes them instead to be ignored.
> 
> For folks with the reverse problem -- active cooling where the
> fans kick in early than they'd like, they should just turn off
> the fans via /proc/acpi/fan and not mess with the trip points at all.
> If they make a mistake, they will be forgiven when the system
> reaches the next trip point and turns the fan back on.

Yes, it's not correct and those trip points might get overridden by BIOS
again on some machines. It still could help and doesn't hurt (Ok, one
should
not increase the critical trip point, but that can be implemented...).

Again, pls go for more workarounds.

The most annoying situation for the developer and the user is after
investing
a lot of time, finding and possibly fixing a bug and then you need to
tell the guy:
  - Got it, please wait for the next kernel release coming out in some
weeks/months
  - Thanks for the work, but implementing it in the kernel of this ditro
version
    is too dangerous. Other machines might break (especially with ACPI
bugs). Better
    you wait for the next distro version coming out in half a year.


      Thomas

> 
> > > The OS has no capability to actually change the ACPI trip points
> > > that are used by the BIOS.  Changing the OS copy of them
> > > to make the user think that trip events will actually
> > > happen when the temperature crosses the OS copy is crazy.
> > > 
> > > If there are systems with broken thermals and the
> > > ACPI thermal control needs and over-ride to turn
> > > on the fan, then that is fine -- but using
> > > fake trip-points and giving the user the impression
> > > that they are real is not viable.
> > 
> > 

