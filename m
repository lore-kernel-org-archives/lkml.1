Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbXG3Evd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbXG3Evd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXG3EvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:51:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60309 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXG3EvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:51:22 -0400
Date: Mon, 30 Jul 2007 10:33:35 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070729095040.GZ9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707301033180.10861@enigma.security.iitk.ac.in>
References: <1185284942.14697.319.camel@pmac.infradead.org>
 <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org>
 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
 <20070729095040.GZ9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Sun, 29 Jul 2007, Rodolfo Giometti wrote:

> On Sat, Jul 28, 2007 at 05:11:17AM +0530, Satyam Sharma wrote:
> 
> > > [ Also, have you considered making pps_source a list and not an array?
> > > It'll help you lose a whole lot of MAX_SOURCES, pps_is_allocated, etc
> > > kind of gymnastics in there, and you _can_ return a pointer to the
> > > corresponding pps source struct from the register() function to the in-kernel
> > > users, so that way you get to retain the O(1) access to the corresponding
> > > source when a client calls into pps_event(), similar to how you're using the
> > > array index presently. ]
> > 
> > I think the above would be sane and safe -- your driver has pretty simple
> > lifetime rules, and "sources" are only created / destroyed from within kernel,
> > as and when clients call pps_register_source() and pps_unregister_source().
> > So pps_event() can be called on a given source only between the
> > corresponding register() and unregister() -- which means register() can
> > return us a reference/pointer on the source after allocating / adding it to
> > the list (instead of the fixed array index as it presently is), which remains
> > valid for the entire duration of the source, till unregister() is called, after
> > which we can't be calling pps_event() on the same source anyway.
> 
> Ok. I see. I'll study the problem but I think this is can be done
> later, now I think is better having a working code. :)

Fair enough, but I think the code could become a trifle simpler/easier
after the conversion, so probably greater chances of getting merged :-)


> > Ok, I've looked through (most of) the RFC and code now, and am only
> > commenting on a design-level for now. Anyway, I didn't like the way
> > you've significantly drifted from the RFC in several ways:
> > 
> > 1. The RFC mandates no such userspace interface / syscall as the
> > time_pps_cmd() that you've implemented -- it looks, smells, and feels
> > like an ioctl, in fact that's what it is for practical purposes. I'm confused
> > as to why didn't you just go ahead and implement the special-file-and-
> > file-descriptor based approach as advocated / mandated there.
> 
> This is because is not always true that a PPS source is connected with
> a char (or other) device.

But that's alright -- see, as I said, you're confusing between the
"special device" that represents the *PPS source* itself, with the port
or device that it uses to *physically* connect to the PC.

In the RFC, when they say that the userspace app must open(2) the PPS
source (as they have illustrated in the example too), they mean that
it open(2)'s the special device/file associated with the PPS source,
and *not* the /dev/lpXXX or /dev/ttySXXX that it might be connected
through physically.

So they mean something like /dev/pps0, /dev/pps1 etc instead. Of course,
no such special device exists on a Linux box already, but that's fine
and obvious! *You* are supposed to create / instantiate that when a
pps_register_source() is done from some in-kernel subsystem.


> People whose designed RFC didn't think about
> systems where the PPS signal is connected with a CPU's GPIO and the
> O.S. doesn't provide any char device to refere with!

As I said, it's not the char device for the physical interface itself
being discussed there. That could be parport, uart, some arbit GPIO pin
whatever. But whenever the corresponding kernel subsystem does a
register_source(), you could create the /dev/ppsXXX device ...

> In the common desktop PCs the GPS antenna is connected with the serial
> line and the PPS source is attached to the serial CD, but in the
> embedded systems this is _not_ true. GPS antennae may still be
> connected with serial line but the PPS signal is usually connected
> with a GPIO pin.
> 
> In this scenario you cannot use the serial file descriptor to manage
> the PPS signal since it cannot goes to the serial port.

See above.

> > [ You've implemented the (optional, as per RFC) time_pps_findsource
> > operation in the kernel using the above "pseudo-ioctl", but that wasn't
> > necessary -- as the RFC itself illustrates, it's something that can easily
> > be done (in fact should be done) completely in userspace itself. ]
> 
> I used pseudo-ioctl interface since it allows me to easily extend PPS
> support with special, and uncommon, commands.

Hmm, but that's a non-standard, not-mandated-by-RFC syscall. I don't see
how you can get this merged, really :-)

> > * At the time of pps_register_source()  -- called by an in-kernel client
> > subsystem that creates a PPS source -- allocate a pps source, generate
> > an identifier for it, instantiate a special file -- the RFC does not mention
> > whether a char or block device, but char device (I noticed an example
> > in the RFC where they've used /dev/ppsXX as a possible path) would be
> > proper for this. Finally add it to the list of sources. This returns a
> > reference/pointer on that source back to the in-kernel client, which then
> > passes *that* to pps_event(), similar to how you're presently using the
> > array index.
> 
> If your GPS antenna is connected with a CPU's GPIO you have _no_
> in-kernel client subsystem that creates a PPS source.

See above.

> > [ The way you've passed the path of the parport/uart device itself
> > (/dev/lpXX or [/dev/%s%d, drv->name, port->line]) to register_source()
> > in pps_info.path doesn't quite look right to me. Note that the userspace is
> > expected to open(2) the special file corresponding to the *PPS* source,
> > as instantiated from the above code, and not the /dev/xyz special file of
> > the *physical* port through which a pulse-generating device may be
> > connected to the PC. ]
> 
> As above, if your GPS antenna is connected with a CPU's GPIO you have
> _no_ device to open at all, that's why you need at least a function
> like pps_findsource().
> 
> Note that in this case the pps_info.path is void. Please, see the
> special client drivers/pps/clients/ktimer.c, it emulates the case
> where you have no /dev/XXX to open(2). If your modifications resolve
> the problems to manage the ktimer client you are going in the right
> direction.

Again, see above.

> > I /think/ the RFC does envision such an implementation, so it helps us
> > comply with that standard, and would also get rid of a lot of kludgy
> > "findpath" and "findsource" stuff that we otherwise have to do in-kernel
> > and userspace, as we're presently doing in the patch.
> 
> Unluckily the RFC does _not_ take into account PPS sources connected
> with CPU's GPIO... in this case, in fact, you have _no_ char/block
> device to open().

And again, see above.


Satyam
