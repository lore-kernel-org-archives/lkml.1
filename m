Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZCTLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZCTLQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZCTLP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:15:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48435 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZCTLP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:15:58 -0400
Date: Fri, 20 Mar 2009 12:15:53 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, daniel.krueger@systec-electronic.com,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320111552.GS5367@pengutronix.de>
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320100146.6599f671@lxorguk.ukuu.org.uk> <20090320103545.GQ5367@pengutronix.de> <20090320105556.4375176d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090320105556.4375176d@lxorguk.ukuu.org.uk>
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
X-Uptime: 11:58:23 up 30 days,  2:51, 59 users,  load average: 12.04,
	15.06, 16.86
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 10:55:56AM +0000, Alan Cox wrote:
> > > - Security
> >
> > For industrial I/O? We are talking about transportation of analog and
> > digital I/O, relais, ADC input etc. The only part that I'd consider
> > security related is tunnel traffic; EPL and EtherCAT have the
>
> Maybe in your case but if that analogue I/O controls parts of a power
> plant or weapons system you really really don't want a worm or trojan
> getting involved with it.

right :) But is there any difference between the stack and the
application here? Applications must be able to set process variables, so
if you compromize them and write the wrong ones to the stack, your power
plant goes baaaang as well.

> > > - Sharing the device/interconnect
> >
> > Sharing the device works also with userspace, because the device is a
> > network card and the interface is raw ethernet frames. What do you mean
> > with interconnect?
>
> Load two user space fieldbus stacks on the same network card (remembering
> this could be done by accident)

ok

> > > - Real time prioritisation
> >
> > Would be done by giving the kernel task (with threaded interrupts) or
> > userspace task the right POSIX relatime priorities, so I don't see a
> > difference here.
>
> There may be multiple user space tasks with differing priorities beyond
> the message priority. That in turn means you want them to have different
> priorities to the scheduler which means you want them to be different
> processes really.

right, but that's the same, no matter if it runs in kernel or user
space.

> > Don't tell that to the industrial networking people - they are very
> > proud of the fact that they use a "standardized application API", so
> > even the fanciest and newest industrial ethernet technologies are based
> > on that legacy wart objdict, and it is officially considered to be a
> > *feature*.
>
> It's a standard yes, but so once was the horse and cart.

/me puts this into his cites file :)

> > then you can put the whole stack into userspace. If kernel, we would
> > need an objdict API to userspace...?
>
> It depends where you split the stack between kernel and user space. There
> needs to be enough in the kernel to allow reasonably efficient
> multi-process models but that can be a small part of the stack. The
> Appletalk stack is a good example. Appletalk has a single address/port
> system for all higher level protocols and the higher level protocols
> don't interact much with each other. It's actually very elegant in that
> way. One result of this is that the AF_APPLETALK kernel stack deals only
> with low level packet routing and delivery. It doesn't have to care about
> higher stuff to provide the needed separation and sharing. IP by
> comparison has all sorts of interactions, multiple port addressing
> schemes and ICMP interactions which mean the kernel has to hold the
> entire TCP and UDP layers.

So what "layers" do we have for CANopen, EtherCAT and PowerLink?

- the lower api is getting ethernet frames
- the stack itself is a state machine that pushes things to objdict
- objdict needs to notify applications on certain changes
- userspace needs to trigger state machine on certain objcict changes by
  the application

We can either put the state machine into the kernel or into userspace;
if userspace, the kernel API is already there (socket), if kernel we
would need an objdict API.

> One model would be
>
> kernel demux by objdict id -> forwards packet to the right user

How would a user attach to the "right" thing? Sounds like some
publish/subscribe pattern.

> a completely and gloriously insane one might be to have the objdict in
> mmap space as you suggest but with a futex on each objdict entry.

uuuuh :)

The problem with mmap is that the objdict is not "rectangular", so you
would need an mmapped blob + description of the variable length content,
plus access serialization. Sounds indeed gloriously insane :)

> > Note that what they are doing is to use the objdict as a binary
> > config space (think registers) to configure the whole network
> > workflow; so if
>
> I tend to think of it as a rather peculiar shared event space - much
> like the device end of SNMP. I guess we should be thankful for small
> mercies that it wasn't invented today and using XML ;)
>
> None of which is to say that an entirely userspace stack might not be
> the right model, but there are distinct appeals to the kernel doing
> some of the demux work and separation of stuff.

seconded, we'll put some brain into that idea ...

> I shall be interested to see what turns out best as there are other
> busses where the design really expects to set up states and the stack
> to do regular repeating.

That's not different here.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
