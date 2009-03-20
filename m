Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbZCTKzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbZCTKzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZCTKzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:55:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36385 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbZCTKzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:55:21 -0400
Date: Fri, 20 Mar 2009 10:55:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, daniel.krueger@systec-electronic.com,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320105556.4375176d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090320103545.GQ5367@pengutronix.de>
References: <20090318183232.GA11594@kroah.com>
	<20090320005808.GM5367@pengutronix.de>
	<20090320100146.6599f671@lxorguk.ukuu.org.uk>
	<20090320103545.GQ5367@pengutronix.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - Security
> 
> For industrial I/O? We are talking about transportation of analog and
> digital I/O, relais, ADC input etc. The only part that I'd consider
> security related is tunnel traffic; EPL and EtherCAT have the

Maybe in your case but if that analogue I/O controls parts of a power
plant or weapons system you really really don't want a worm or trojan
getting involved with it.

> > - Sharing the device/interconnect
> 
> Sharing the device works also with userspace, because the device is a
> network card and the interface is raw ethernet frames. What do you mean
> with interconnect?

Load two user space fieldbus stacks on the same network card (remembering
this could be done by accident)

> > - Real time prioritisation
> 
> Would be done by giving the kernel task (with threaded interrupts) or
> userspace task the right POSIX relatime priorities, so I don't see a
> difference here.

There may be multiple user space tasks with differing priorities beyond
the message priority. That in turn means you want them to have different
priorities to the scheduler which means you want them to be different
processes really.

> Don't tell that to the industrial networking people - they are very
> proud of the fact that they use a "standardized application API", so
> even the fanciest and newest industrial ethernet technologies are based
> on that legacy wart objdict, and it is officially considered to be a
> *feature*.

It's a standard yes, but so once was the horse and cart.

> then you can put the whole stack into userspace. If kernel, we would
> need an objdict API to userspace...?

It depends where you split the stack between kernel and user space. There
needs to be enough in the kernel to allow reasonably efficient
multi-process models but that can be a small part of the stack. The
Appletalk stack is a good example. Appletalk has a single address/port
system for all higher level protocols and the higher level protocols
don't interact much with each other. It's actually very elegant in that
way. One result of this is that the AF_APPLETALK kernel stack deals only
with low level packet routing and delivery. It doesn't have to care about
higher stuff to provide the needed separation and sharing. IP by
comparison has all sorts of interactions, multiple port addressing
schemes and ICMP interactions which mean the kernel has to hold the
entire TCP and UDP layers.

> One thing that has to be considered is that messages often have to be
> handled fast and under realtime constraints; for example, it must be
> possible to hook up the userspace to certain changes in the objdict.
> Something like:

One model would be

kernel demux by objdict id -> forwards packet to the right user

a completely and gloriously insane one might be to have the objdict in
mmap space as you suggest but with a futex on each objdict entry.

> Note that what they are doing is to use the objdict as a binary config
> space (think registers) to configure the whole network workflow; so if

I tend to think of it as a rather peculiar shared event space - much like
the device end of SNMP. I guess we should be thankful for small mercies
that it wasn't invented today and using XML ;)

None of which is to say that an entirely userspace stack might not be the
right model, but there are distinct appeals to the kernel doing some of
the demux work and separation of stuff.

I shall be interested to see what turns out best as there are other
busses where the design really expects to set up states and the stack to
do regular repeating.
