Return-Path: <linux-kernel-owner+w=401wt.eu-S1763913AbYA3Xae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763913AbYA3Xae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYA3Xa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:30:26 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:24859 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYA3XaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:30:24 -0500
Message-ID: <47A10886.5050707@msgid.tls.msk.ru>
Date: Thu, 31 Jan 2008 02:30:14 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
References: <47A0CD90.5080208@msgid.tls.msk.ru> <200801302211.10622.rjw@sisk.pl>
In-Reply-To: <200801302211.10622.rjw@sisk.pl>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 30 of January 2008, Michael Tokarev wrote:
>> I'm trying to "glue" hibernation and UPS control
>> together, and have a question.
[]
> If your box hibernates and resumes correctly in the shutdown mode (ie.

Ohh-well.. :)

I was thinking about more or less general solution to this.
Yes, my boxes counts as primary targets, because we've seen
so many various failures due to power loss and because I want
to finally stop it somehow.  The thing basically works with
plain shutdown (no suspend is involved), but it turned out
that many esp. cheap UPSes (the ones used by "masses") don't
check the status of their batteries up until they lose AC
power, when it's too late...  The result is that when you
lose AC power, you discover that you've only a few secs to
perform shutdown, and hence hibernate is the only option,
as it usually is much faster than to try to shut down stuff
(esp. when things like squid or a big database are on the
way, with their looong time to shutdown cleanly).

> basically without ACPI assistance), you can use s2disk for hibernation and
> modify it to switch off the UPS instead of powering off the box.

Heh.  First, I didn't know about s2disk up until now.  I've
seen uswsusp utils some years before, but I thought it's
about some patch for vanilla kernel (some time ago it was
indeed the case) and that the utils aren't needed for current
kernels (I always used "echo disk > /sys/power/state" to
suspend).

Now, and I hate to say that, I found that this my test
box is totally unsuitable for testing this all.  Because
it all just Does Not Work.  Because:

 o 2.6.24 kernel fails to suspend properly.  It "saves pages",
   prints "Suspending console", when prints "Sl" and nothing
   more happens.  At this time, I can manually poweroff the
   machine, and resume works.  The same happens when running
   32bits or 64bits kernel (it's an amd x2-64 system).

 o uswsusp is unaware of 64bits kernel and 32bits userland.
   Looking at the source, that's probably (and for sure in
   certain places) more than just missing compat_ioctl wrappers
   for those:

  ioctl32(s2disk:3574): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ffa4578c) on /dev/snapshot
  ioctl32(s2disk:3574): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot

   "probably" is where it reads the swap space - it's just
   my guess that s2disk (and resume) will do some wrong here.
   "for sure" is vbe code - since 32bits vbetools package
   fails badly with 64bit kernel, it seems that it is looking
   at the wrong place in /dev/mem.

 o when running 32bits 2.6.24 kernel, s2disk fails the same
   way as pure in-kernel solution fails, above.  And it
   fails to resume, too, -- unlike pure in-kernel solution.

I know kernel-only way worked with 2.6.23 (both 32 and 64
bits) - compiling that now...

It's sad when while working on something you discover that
"underlying" tools you use also don't work, and start fixing
those, when discover that something else fails, and so on,
until you finally gave up and abandom the whole initial
idea...  Oh well, but c'est la vie...

Back to the original question and a proposed solution.

I'm looking at the uswsusp source (while the kernel compiles),
and have a question here.  Is it possible to call some external
application (typically a shell script) to do the final work after
when the image has been written?  I mean in principle - I
understand there are some limitations here, but I don't know
which exactly.

For the given task (send some command to the damn UPS),
it typically involves writing/reading something to/from
a given serial port (/dev/ttySxx), or to an USB device,
or to a network -- depending on the UPS in use.  There
are so many different UPSes out there, with so many different
and stupid so-called "protocols", that it's impossible to
teach s2disk about them all.

If such a thing is possible, the next question is obvious --
where exactly it belongs in suspend.c, and again, under
which conditions it can be called (for example, how about
different methods - shutdown/platform/etc?).

Also, if I need the system to stay on while the UPS cuts
the power (in order for it to start up automatically,
provided "restore to previous state on AC power resume"
BIOS option is enabled), should such a script (which is
called from s2disk) just sleep letting the UPS to do the
work, or should it pass information back to s2disk to NOT
to poweroff the machine?  I mean, just like in case of
"regular" shutdown when we're running off battery, between
when the UPS control script gets called and when it's
really safe to cut the power off, some more things has to
be done - like stopping disks, "remointing" sw raid arrays
read-only (to mark them as "clean") etc - this is done by
calling reboot(RB_HALT) or reboot(RB_POWEROFF), which, in
turn, is done by halt(8).  So when s2disk calls this script,
is it Okay to assume that it's safe to cut the power, or
something more has to be done by s2disk when the script
finishes?

I *hope* it's easy to see where my questions comes from,
and what exactly I'm trying to do... ;)

(kernel compile finished, rebooting to see if s2disk works
with 2.6.23 - 32bits for now, as it definitely will not
work with 64bits kernel...)

/mjt
