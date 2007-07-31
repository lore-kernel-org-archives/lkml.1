Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXGaITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXGaITf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXGaITY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:19:24 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:50676 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXGaITV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:19:21 -0400
Date: Tue, 31 Jul 2007 10:20:58 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070731082057.GM9840@enneenne.com>
References: <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in> <20070730083259.GD9840@enneenne.com> <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in> <20070730145542.GG9840@enneenne.com> <alpine.LFD.0.999.0707310153110.17287@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707310153110.17287@enigma.security.iitk.ac.in>
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

On Tue, Jul 31, 2007 at 03:31:22AM +0530, Satyam Sharma wrote:
> Hi Rodolfo,

Hi :)

> Yup, this would avoid races, but then we will lose events. Why is that
> acceptable, when better alternative (above) exists?

Because is better lossign events then recording them delayed. In the
past we (LinuxPPS users) noticed that just postponing of one
instruction the timestamp recording degrade the timesetting of about
50%!

> Seriously, your aversion to implement good, safe locking is amazing! :-)

I averse not by default. :) But I just wish understand _why_ a
solution is better then other.

I'm sure my solution is not the best at all, but before changing it I
wish understand if the new proposal is better.

> The proper way to do this is to use a kernel buffer to do all kernel-side
> work (you acquire/release lock during that work) and then copy_to_user()
> later, at the end. [ And something opposite for the set_xxx syscall, i.e.
> first off copy_from_user() to a kernel buffer up front, before doing
> anything else itself, and then do all the work in the kernel on that. ]

Mmm... I think this is not easy at all for sys_time_pps_fetch(). I
suppose you have to complicate its code a lot!

I don't undestand why we must complicate, and made unreadable, a code
in order to follow the rule use-only-one-lock-mechanism. If by using
mutex and spinlocks the code is more readable, where is the fault?

> BTW your syscall implementations totally lack any kind of security checks
> whatsoever ...

Ok, we can correct them. :)

> Amazing. On the one hand, you want to use spin_trylock() in the hard irq
> handler and spin_lock() (not irq safe) in the process context, because
> you "don't care about losing some events". And now you want to avoid
> "disabling irqs in user context to minimize possibility to delay events
> recording"?

Just for not delaying the IRQ handler. As already said, I prefere
loosing events that delaying their timestamps recording.

> Anyway, any such requirement you're talking about is just bogus, IMHO.
> You're just disabling interrupts to access a data structure, for Gods'
> sakes, how many nanoseconds do you imagine would you be "delaying"?

As already said we noticed that just delaying of one instruction the
timestamp recording the time setting degrades of about 50%.

We have to take care of this point. It's _very_ important that _each_
event had its timestamp recorded with delay as small as possible.

> > Please, take alook at NTPD code. Common usage is:
> > 
> >    fd = open("/dev/ttyS0", ...);
> > 
> >    pps_time_create(fd, &handler);
> > 
> > since RFC supposes that at filedes "fd" is mapped both GPS data _and_
> > PPS source.
> 
> Umm, I don't think the RFC supposes/assumes this anywhere.

I think so. If not, why they pretend an _already opened_ filedes then
just a filename to be used as parameter for the open(2) syscall? :)

Again, it was simpler, and more logic, define the time_pps_create as
follow:

   time_pps_create(char *ppsdev, pps_handle_t *handle);

this definition resolves very well all possibile cases.

> Of course. BTW time_pps_findpath/findsource do not have to be kernel
> implemented syscalls in the first place. The best, simplest and most
> straightforward place to implement them is in userspace -- the RFC
> mentions this as well.

Ok, I'll wait for your modification to see how you can do it.

> A solution I can think of is to create a mapping at the time of
> pps_register_source() between the PPS source (physically) and the special
> char device. Userspace open(2)'s the special char device corresponding to
> the PPS source, and then issues the time_pps_create() syscall. Here, we
> lookup the mapping previously created and return handle to the PPS source
> based on the special device's fd that's passed to us in time_pps_create().

Ok, just what pps_findpath&C. does... however if you now how to
implement it I'll be very to see the code. :)

But, as you can see, this is due the bogus RFC specification. It was
more easier define the time_pps_create() as suggested above and you
didn't need no mapping at all.

> Ok, I'll take a look, thanks :-)
> 
> [ what's the URL for these sources? ]

Oh, yes... sorry, here the NTP main site:

   http://www.ntp.org

> open(PPSfilename, O_RDWR) doesn't sound like that at all. If the device
> for the serial port / parport was intended, it wouldn't be called
> "PPSfilename", would it?

No, I meant that if they require an already opened file descriptor is
beacuse they simply don't suppose that a PPS source may be totally
uncollerated to any device. If not they had two possibilities:

1) just using an open(2) to access a PPS source and using the returned
   filedes as PPS handler,

2) or, just to be more general, define the time_pps_create() as above,
   with the "char *ppsdevice" as parameter (then on UNIX systems we
   implement it with open(2)).

> The physical port/device through which a PPS source is connected is
> immaterial. Anyway, I'll take a look at the NTPD/userspace code you are
> mentioning as well. [ again, could you point me to URL of source code? ]

   http://www.ntp.org/downloads.html

> Sure, I'll get to implementing what I have in mind here -- will be glad
> to be of any help, thanks.

If you wish proving patches to LinuxPPS I just created a "develop"
branch into my GIT repository:

   http://gitweb.enneenne.com/?p=linuxpps;a=shortlog;h=develop

Please, provide patch against that branch.

Thanks a lot, 

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
