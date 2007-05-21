Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbXEUDxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbXEUDxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 23:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXEUDxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 23:53:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:56050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbXEUDxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 23:53:32 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Date: Sun, 20 May 2007 23:50:44 -0400
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       len.brown@intel.com, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171517.14087.lenb@kernel.org> <1179604609.16465.83.camel@sublime.suse.de>
In-Reply-To: <1179604609.16465.83.camel@sublime.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705202350.45145.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2007 15:56, Thomas Renninger wrote:
> On Thu, 2007-05-17 at 15:17 -0400, Len Brown wrote:
> > On Thursday 17 May 2007 05:23, Pavel Machek wrote:
> > 
> > > >     ACPI: thermal trip points are read-only
> > > 
> > > What was the rationale? Can we get this one reverted? 
> > > 
> > > Some machines (HP omnibook xe3) have broken trip points -- too high --
> > > so machine will overheat and trigger hw shutdown before starting
> > > passive cooling.
> > > 
> > > That's really broken, and write to trip points is reasonable way to
> > > 'fix' that. (I'd understand if you only ever let trip points to
> > > decrease... but otoh root should be able to shoot himself....)
> > 
> > No, writing trip-points is neither a fix, nor it is reasonable.
> > It is a workaround at best, and it is a dangerous and mis-leading hack.
> Yes it is a workaround for critical ACPI bugs like that or similar:
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/22336

Thanks for pointing that out -- it is a great example
of how powerful mis-information can be.

The fact that the trip-points are writable has obscured,
rather than clarified, the actual causes of the failures.
No less than 4 people in that bug report declared that
cleaning the dust out of their fan fixed the root cause.
A bunch more said that the issues went away when they 
stopped using ubuntu's user-space power save daemon.

There are a couple more with broken active fan control --
which also gets obscured rather than clarified by
over-riding trip points.

And finally, there are probably some with clean fans
that are working properly, but are thermally challenged
systems.  I'll venture that Windows is NOT modifying or disabling
the critical trip point to work around this issue.
I'll venture that their thermal throttling is working
and ours may not be.

perhaps it was the recently fixed mod_timer() bug in thermal.c,
or perhaps it is one that we don't know about yet...

> It's also convenient to e.g. lower passive trip point to avoid fan
> noise.

nope, the OS can't reliably override the processor passive trip point.
That is what _SCP and cooling_mode are for.

The reason is that the BIOS can send us a trip-point changed event at any time,
the kernel will evaluate _PSV, and wipe out the modified OS version.

if you want to change the state of the fans,
then poke /proc/acpi/fan/ directly.
This will have effect until the next trip point
changes its state.

> Some people are used to it, I already wanted to write a little userspace
> prog to use them as it is really easy to fake cooling_mode (trip points
> are modified by BIOS) and eliminate fan noise and other things by e.g.
> reducing passsive or whatever trip point.

please save this effort for a non-ACPI system.

> This is at least a major sysfs interface change, has this been discussed
> somewhere before or declared deprecated?

it went out on linux-acpi, but I don't recall any discussion about it.

> It's there for a long time, why is this "a dangerous and mis-leading
> hack." now?

It has been dangerous and misleading since the day it went in.
If the user doesn't enable polling, then they are effectively
writing random numbers that have absolutely no effect on
the operation of the system, and hiding the numbers that
do control the operation of the system.

> I'd suggest to revert this and I can come with something like "only
> allow lower values
> than BIOS provides" patch if the current implementation is considered
> dangerous.

That simply will not address the issue.
Indeed, all the entries in the ubuntu bug report are about hitting
the critical temperature and having a critical shutdown when
it isn't wanted.  These people want to RAISE the critical shutdown
trip-point.  Their cooling problems must be fixed -- raising critical
trip points causes them instead to be ignored.

For folks with the reverse problem -- active cooling where the
fans kick in early than they'd like, they should just turn off
the fans via /proc/acpi/fan and not mess with the trip points at all.
If they make a mistake, they will be forgiven when the system
reaches the next trip point and turns the fan back on.

thanks,
-Len


> > The OS has no capability to actually change the ACPI trip points
> > that are used by the BIOS.  Changing the OS copy of them
> > to make the user think that trip events will actually
> > happen when the temperature crosses the OS copy is crazy.
> > 
> > If there are systems with broken thermals and the
> > ACPI thermal control needs and over-ride to turn
> > on the fan, then that is fine -- but using
> > fake trip-points and giving the user the impression
> > that they are real is not viable.
> 
> 
