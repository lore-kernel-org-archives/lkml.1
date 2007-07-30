Return-Path: <linux-kernel-owner+w=401wt.eu-S965048AbXG3Iud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048AbXG3Iud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbXG3IuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:50:24 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:44463 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbXG3IuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:50:22 -0400
Date: Mon, 30 Jul 2007 10:51:57 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070730085157.GE9840@enneenne.com>
References: <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com> <20070729095040.GZ9840@enneenne.com> <alpine.LFD.0.999.0707301033180.10861@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707301033180.10861@enigma.security.iitk.ac.in>
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

On Mon, Jul 30, 2007 at 10:33:35AM +0530, Satyam Sharma wrote:
> 
> Fair enough, but I think the code could become a trifle simpler/easier
> after the conversion, so probably greater chances of getting merged :-)

I see. I'll start thinging about it.

> But that's alright -- see, as I said, you're confusing between the
> "special device" that represents the *PPS source* itself, with the port
> or device that it uses to *physically* connect to the PC.
> 
> In the RFC, when they say that the userspace app must open(2) the PPS
> source (as they have illustrated in the example too), they mean that
> it open(2)'s the special device/file associated with the PPS source,
> and *not* the /dev/lpXXX or /dev/ttySXXX that it might be connected
> through physically.
> 
> So they mean something like /dev/pps0, /dev/pps1 etc instead. Of course,
> no such special device exists on a Linux box already, but that's fine
> and obvious! *You* are supposed to create / instantiate that when a
> pps_register_source() is done from some in-kernel subsystem.

So your are proposing to create a char device interface then using
syscalls one? In this case how do you manage the case where your GPS
antenna and PPS source are both connected with the serial port
(i.e. /dev/ttyS0)?

Currently the RFC says to you that you should open the serial port:

	fd = open("/dev/ttyS0", ...);

and the passing its filedes to pps_time_create() in order to get the
corresponding PPS source handler:

	pps_time_create(fd, &handler);

As you propose you need _two_ open() and not just one... and even if
you decide to open the /dev/ppsX inside the pps_time_create(), how do
you recognise _which_ /dev/ppsX is connected with filedse "fd"?

I quite sure that RFC is broken since it doesn't take in account that
a PPS source maybe not connected with any cahr device at all. I tried
to explain this problem to RFC's gurus but they never answered to me,
so I decided to resolve the problem by myself. ;)

> As I said, it's not the char device for the physical interface itself
> being discussed there. That could be parport, uart, some arbit GPIO pin
> whatever. But whenever the corresponding kernel subsystem does a
> register_source(), you could create the /dev/ppsXXX device ...

Ok, but in this case you still are _not_ RFC compliant (as showed
above). You need that users give to you _two_ devices (the serial line
and the PPS source), meanwhile, for the RFC, you just need one. So no
differences from my solution from this point of view.

> Hmm, but that's a non-standard, not-mandated-by-RFC syscall. I don't see
> how you can get this merged, really :-)

They are not-mandated-by-RFC since simply RFC _is broken_! :)

I need them (or just one of them) in order to find a PPS source into
the system. Just as you need the second device name in your solution
with char devices.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
