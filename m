Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbZCTKgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbZCTKgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZCTKf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:35:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38828 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZCTKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:35:55 -0400
Date: Fri, 20 Mar 2009 11:35:45 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, daniel.krueger@systec-electronic.com,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320103545.GQ5367@pengutronix.de>
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320100146.6599f671@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090320100146.6599f671@lxorguk.ukuu.org.uk>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 11:06:41 up 30 days,  2:00, 58 users,  load average: 21.52,
	23.12, 13.92
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thanks for your feedback! :-)

On Fri, Mar 20, 2009 at 10:01:46AM +0000, Alan Cox wrote:
> > However, I'm still not convinced that this is the right way to go. What
> > you want to do for the main APIs is provide some nice userspace library
> > API for your applications. Why not put the whole "stack" into userspace
> > then and connect it to the kernel only via raw socket.
>
> - Security

For industrial I/O? We are talking about transportation of analog and
digital I/O, relais, ADC input etc. The only part that I'd consider
security related is tunnel traffic; EPL and EtherCAT have the
possibiltiy to do ethernet-over-$TECHNOLOGY. In the userspace variant,
tunnel trafic would be pushed back into the stack via tun/tap.

> - Compartmentalisation

Yes, that's a good and valid point, IMHO. Also, from a political point
of view, it would be very good to have *the one and only* kernel way to
do these things, instead of myriards of incompatible userspace hacks.

> - Sharing the device/interconnect

Sharing the device works also with userspace, because the device is a
network card and the interface is raw ethernet frames. What do you mean
with interconnect?

> - Real time prioritisation

Would be done by giving the kernel task (with threaded interrupts) or
userspace task the right POSIX relatime priorities, so I don't see a
difference here.

> > What do others think? Is it worth the effort to invent a proper objdict
> > API for linux?
>
> Objdict appears to be a legacy wart

Don't tell that to the industrial networking people - they are very
proud of the fact that they use a "standardized application API", so
even the fanciest and newest industrial ethernet technologies are based
on that legacy wart objdict, and it is officially considered to be a
*feature*.

> and can stay where it belongs I suspect -

So where does it belong, kernel or userspace? I'd say userspace, but
then you can put the whole stack into userspace. If kernel, we would
need an objdict API to userspace...?

One thing that has to be considered is that messages often have to be
handled fast and under realtime constraints; for example, it must be
possible to hook up the userspace to certain changes in the objdict.
Something like:

  -------   ---------     --------------
    eth      objdict       process data
    can                        layer
  -------   ---------     --------------
     |          |                |
     | rx()     |                |
     |--------->|                |
     |          # write pdo into |
     |          # position in    |
     |          # objdict        |
     |          |                |
     |          |  pdo_changed() |
     |          |--------------->|
     |          |                # pull process data out of certain
     |          |                # position in the objdict and make
     |          |                # proper process variable objects
     |          |                #
     |          |                |

Note that what they are doing is to use the objdict as a binary config
space (think registers) to configure the whole network workflow; so if
for example somebody wants to send out a temperature every delta-t
seconds, he configures that by setting bits in the objdict, pushing the
process data (temperature) into other bits in the objdict and the stack
sends out can/eth frames with that data. It's a complete mixture of
ISO/OSI layers, because they have things like "what is to be sent when"
in the same binary blob space as "payload".

> you might need to have a objdict -> 21st century conversion library
> for the afflicted.

That's what we are working on in the OSADL Fieldbus Framework, in
userspace. The basic idea is to bring the fieldbusses together with the
mathematics developed in the Ptolemy II project [1], in a way that you
can do classic soft-PLC [2] / IEC61131 stuff as well as modern
heterogenous model based design (thing LabVIEW, Matlab/Simulink,
Rhapsody, ...).

> We don't put specialised COBOL support in the kernel either we let
> user space figure out how to cope with the funnies.

Industrial communication people are in some strange time loop that
started looping in the 80es, but didn't notice yet :-)

rsc

[1] http://ptolemy.berkeley.edu/ptolemyII/
[2] http://en.wikipedia.org/wiki/Programmable_logic_controller
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
