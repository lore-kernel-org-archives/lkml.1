Return-Path: <linux-kernel-owner+w=401wt.eu-S1761728AbXG2JtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761728AbXG2JtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761030AbXG2JtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:49:07 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39713 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760993AbXG2JtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:49:05 -0400
Date: Sun, 29 Jul 2007 11:50:40 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070729095040.GZ9840@enneenne.com>
References: <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS & spinlocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 05:11:17AM +0530, Satyam Sharma wrote:
> 
> Take the race between the time_pps_setparams() syscall and a concurrent
> pps_event() from an interrupt for instance. From sys_time_pps_setparams,
> the parameters for an existing source are not modified / set atomically,
> which means a pps_event() called on the same source in between will see
> invalid parameters ... and bad things will happen.

I are right. I'll add spinlocks. :)

> > [ Also, have you considered making pps_source a list and not an array?
> > It'll help you lose a whole lot of MAX_SOURCES, pps_is_allocated, etc
> > kind of gymnastics in there, and you _can_ return a pointer to the
> > corresponding pps source struct from the register() function to the in-kernel
> > users, so that way you get to retain the O(1) access to the corresponding
> > source when a client calls into pps_event(), similar to how you're using the
> > array index presently. ]
> 
> I think the above would be sane and safe -- your driver has pretty simple
> lifetime rules, and "sources" are only created / destroyed from within kernel,
> as and when clients call pps_register_source() and pps_unregister_source().
> So pps_event() can be called on a given source only between the
> corresponding register() and unregister() -- which means register() can
> return us a reference/pointer on the source after allocating / adding it to
> the list (instead of the fixed array index as it presently is), which remains
> valid for the entire duration of the source, till unregister() is called, after
> which we can't be calling pps_event() on the same source anyway.

Ok. I see. I'll study the problem but I think this is can be done
later, now I think is better having a working code. :)

> Ok, I've looked through (most of) the RFC and code now, and am only
> commenting on a design-level for now. Anyway, I didn't like the way
> you've significantly drifted from the RFC in several ways:
> 
> 1. The RFC mandates no such userspace interface / syscall as the
> time_pps_cmd() that you've implemented -- it looks, smells, and feels
> like an ioctl, in fact that's what it is for practical purposes. I'm confused
> as to why didn't you just go ahead and implement the special-file-and-
> file-descriptor based approach as advocated / mandated there.

This is because is not always true that a PPS source is connected with
a char (or other) device. People whose designed RFC didn't think about
systems where the PPS signal is connected with a CPU's GPIO and the
O.S. doesn't provide any char device to refere with!

In the common desktop PCs the GPS antenna is connected with the serial
line and the PPS source is attached to the serial CD, but in the
embedded systems this is _not_ true. GPS antennae may still be
connected with serial line but the PPS signal is usually connected
with a GPIO pin.

In this scenario you cannot use the serial file descriptor to manage
the PPS signal since it cannot goes to the serial port.

> [ You've implemented the (optional, as per RFC) time_pps_findsource
> operation in the kernel using the above "pseudo-ioctl", but that wasn't
> necessary -- as the RFC itself illustrates, it's something that can easily
> be done (in fact should be done) completely in userspace itself. ]

I used pseudo-ioctl interface since it allows me to easily extend PPS
support with special, and uncommon, commands.

> 2. If you fix the above two issues, you'll notice that you don't need to
> short-circuit the (RFC-mandated) time_pps_create/destroy(handle)
> syscalls in the userspace header/library anymore, as you presently are.

This is just the reason why I added those functions. :)

> Here's how I'd go about desiging/implementing this:
> 
> * At the time of pps_register_source()  -- called by an in-kernel client
> subsystem that creates a PPS source -- allocate a pps source, generate
> an identifier for it, instantiate a special file -- the RFC does not mention
> whether a char or block device, but char device (I noticed an example
> in the RFC where they've used /dev/ppsXX as a possible path) would be
> proper for this. Finally add it to the list of sources. This returns a
> reference/pointer on that source back to the in-kernel client, which then
> passes *that* to pps_event(), similar to how you're presently using the
> array index.

If your GPS antenna is connected with a CPU's GPIO you have _no_
in-kernel client subsystem that creates a PPS source.

> [ The way you've passed the path of the parport/uart device itself
> (/dev/lpXX or [/dev/%s%d, drv->name, port->line]) to register_source()
> in pps_info.path doesn't quite look right to me. Note that the userspace is
> expected to open(2) the special file corresponding to the *PPS* source,
> as instantiated from the above code, and not the /dev/xyz special file of
> the *physical* port through which a pulse-generating device may be
> connected to the PC. ]

As above, if your GPS antenna is connected with a CPU's GPIO you have
_no_ device to open at all, that's why you need at least a function
like pps_findsource().

Note that in this case the pps_info.path is void. Please, see the
special client drivers/pps/clients/ktimer.c, it emulates the case
where you have no /dev/XXX to open(2). If your modifications resolve
the problems to manage the ktimer client you are going in the right
direction.

> * Userspace will open(2) the special file, and get an fd. Then calls the
> time_pps_create(fd, &handle) syscall -- kernel will find the pps source
> that matches that passed fd from the list of sources, and instantiates a
> "handle" associated with that source and returns that back to userspace.

Ditto.

> The rest would happen as usual / as you've currently implemented.
> 
> I /think/ the RFC does envision such an implementation, so it helps us
> comply with that standard, and would also get rid of a lot of kludgy
> "findpath" and "findsource" stuff that we otherwise have to do in-kernel
> and userspace, as we're presently doing in the patch.

Unluckily the RFC does _not_ take into account PPS sources connected
with CPU's GPIO... in this case, in fact, you have _no_ char/block
device to open().

> [ BTW, it would be nice if you submit this stuff as a patchset that brings
> in functionality over a series of multiple patches -- the sysfs interface bits
> can be introduced in a different patch from the syscalls, which can be
> introduced in a different patch from the kernel-side API, etc ... that helps
> a code-level review. ]

Ok, I see, but I think this should be done when everithing is ok. I
think after fixing locking issue I can do it, can't I?

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
