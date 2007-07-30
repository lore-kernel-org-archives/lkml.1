Return-Path: <linux-kernel-owner+w=401wt.eu-S938028AbXG3JI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938028AbXG3JI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937380AbXG3JIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:08:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47977 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631AbXG3JIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:08:44 -0400
Date: Mon, 30 Jul 2007 14:50:56 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070730085157.GE9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707301438190.13448@enigma.security.iitk.ac.in>
References: <1185288769.14697.339.camel@pmac.infradead.org>
 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
 <20070729095040.GZ9840@enneenne.com> <alpine.LFD.0.999.0707301033180.10861@enigma.security.iitk.ac.in>
 <20070730085157.GE9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Rodolfo Giometti wrote:

> On Mon, Jul 30, 2007 at 10:33:35AM +0530, Satyam Sharma wrote:
> > 
> > Fair enough, but I think the code could become a trifle simpler/easier
> > after the conversion, so probably greater chances of getting merged :-)
> 
> I see. I'll start thinging about it.
> 
> > But that's alright -- see, as I said, you're confusing between the
> > "special device" that represents the *PPS source* itself, with the port
> > or device that it uses to *physically* connect to the PC.
> > 
> > In the RFC, when they say that the userspace app must open(2) the PPS
> > source (as they have illustrated in the example too), they mean that
> > it open(2)'s the special device/file associated with the PPS source,
> > and *not* the /dev/lpXXX or /dev/ttySXXX that it might be connected
> > through physically.
> > 
> > So they mean something like /dev/pps0, /dev/pps1 etc instead. Of course,
> > no such special device exists on a Linux box already, but that's fine
> > and obvious! *You* are supposed to create / instantiate that when a
> > pps_register_source() is done from some in-kernel subsystem.
> 
> So your are proposing to create a char device interface then using
> syscalls one? In this case how do you manage the case where your GPS
> antenna and PPS source are both connected with the serial port
> (i.e. /dev/ttyS0)?

That's *precisely* what I just explained above!

You create that special device at the time of pps_register_source()!


> Currently the RFC says to you that you should open the serial port:
> 
> 	fd = open("/dev/ttyS0", ...);

No, it does *NOT*. All it says is:

    The time_pps_create() is used to convert an already-open UNIX file
    descriptor, for an appropriate special file, into a PPS handle.

See? What I said is precisely the implementation the RFC envisages
(and the only sane way to implement it too).

And later, where it gives an example, it shows:

    fd = open(PPSfilename, O_RDWR, 0);

What I'm saying is that the "PPSfilename", as is obvious from the name
itself, is *not* a port such as lpXXX or ttySXXX, but an "appropriate
special file" corresponding to a ... PPS source! Really, the RFC is
quite clear and easy to read, I have no idea how to explain that more
clearly ...


> and the passing its filedes to pps_time_create() in order to get the
> corresponding PPS source handler:
> 
> 	pps_time_create(fd, &handler);

Yes.


> As you propose you need _two_ open() and not just one...

No, why?


> and even if
> you decide to open the /dev/ppsX inside the pps_time_create(), how do
> you recognise _which_ /dev/ppsX is connected with filedse "fd"?

That's trivial to implement in the kernel code for the time_pps_create()
syscall.


> I quite sure that RFC is broken since it doesn't take in account that
> a PPS source maybe not connected with any cahr device at all. I tried
> to explain this problem to RFC's gurus but they never answered to me,
> so I decided to resolve the problem by myself. ;)

Nopes, the RFC is not broken at all. All this physical-connection-port
device vs PPS-source-device confusion is just in your mind :-)


> > As I said, it's not the char device for the physical interface itself
> > being discussed there. That could be parport, uart, some arbit GPIO pin
> > whatever. But whenever the corresponding kernel subsystem does a
> > register_source(), you could create the /dev/ppsXXX device ...
> 
> Ok, but in this case you still are _not_ RFC compliant (as showed
> above). You need that users give to you _two_ devices (the serial line
> and the PPS source), meanwhile, for the RFC, you just need one. So no
> differences from my solution from this point of view.

Yeah, so how am I not RFC compliant? Userspace will *only* open(2) the
special char device of the *PPS source*, and have *nothing* to do with
the device corresponding to the physical device/port it is connected
through!


> > Hmm, but that's a non-standard, not-mandated-by-RFC syscall. I don't see
> > how you can get this merged, really :-)
> 
> They are not-mandated-by-RFC since simply RFC _is broken_! :)

It is not ...

> I need them (or just one of them) in order to find a PPS source into
> the system. Just as you need the second device name in your solution
> with char devices.

No, I don't need any "second device". I *only* need the "appropriate
special file" as mentioned in the RFC. I don't give a *damn* for
what *physical device/port* the source is actually connected through.
I suggest you should read the RFC again ...


Satyam
