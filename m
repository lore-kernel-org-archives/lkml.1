Return-Path: <linux-kernel-owner+w=401wt.eu-S965816AbXD1LgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965816AbXD1LgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965818AbXD1LgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:36:08 -0400
Received: from www.osadl.org ([213.239.205.134]:40611 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965816AbXD1LgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:36:05 -0400
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
In-Reply-To: <20070427231105.GA19156@suse.de>
References: <20070427224957.GA17967@kroah.com>
	 <20070427160425.710c0230.akpm@linux-foundation.org>
	 <20070427231105.GA19156@suse.de>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 13:38:06 +0200
Message-Id: <1177760287.7646.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 16:11 -0700, Greg KH wrote:
> > I'm a bit uncertain about the whole UIO idea, really.  I have this vague
> > feeling that we'd prefer to encourage people to move device drivers into
> > GPL'ed kernel rather than encouraging them to do closed-source userspace
> > implementations which will probably end up being slower, less reliable and
> > unavailable on various architectures, distros, etc.
> 
> It's not a closed vs. open issue, it just turns out that a lot of people
> keep trying to write PCI drivers in userspace (how many different papers
> were published on this topic alone in the past year...).  This framework
> is to allow this to happen in a sane and correct way.

Right, we don't need another dozen of attempts to get it wrong.

Interestingly enough some talks at ELC were using UIO already for
testing and prototyping and the feedback from these guys was positive on
the technical side and not at all focussed on the ability to do closed
source hackery.

> Lots of different types of odd devices do not fit into the "kernelspace
> driver" framework very well for a variety of reasons:
> 	- zillions of different controls in the card
> 	- floating point is needed to compute the next step of an
> 	  operation in moving a physical object

It's not necessarily slower. We were able to optimize an application by
using UIO and we got >20% performance gain, due to the fact that we can
operate on the device directly instead of copying data back and forth
between kernel and userspace for no good reason.

Removing the insane amount of 68 ioctls of the original in kernel
driver, which are just there to flip some bit in the chip registers is
definitely a win.

Having a sane user space driver instead of an eye-cancer causing kernel
driver and a user space library, which needs to hide the ioctl madness
away from the application programmer reduced the overall code size from

5264 lines of kernel code + 3275 lines of user space code

to 

 156 lines of kernel code + 2970 lines of user space code.

> With this framework, we provide a solid and simple way to provide for
> these kinds of devices.  The Linutronix guys have had a lot of
> experience in supporting this kind of hardware in the past and can
> provide better examples if you need.

UIO is not targeted on devices which are part of a kernel subsystem, it
is targeted for self contained special devices, which have currently
tons of out of tree drivers with an average quality of 0. Those devices
do not fit in the in kernel driver landscape at all and we really should
give those folks something sane to work from.

> But yes, it does allow you to write a PCI driver in userspace, being
> closed source, if you really want to.  But if you do that, then you get
> _no_ advantages of being in the kernel (caching, common userspace
> interface, resource management, etc.) and need to handle that all
> yourself.  Heck, that's pretty much what X does today for lots of old
> video cards :)

Right, you can do closed source drivers and I prefer when people use
this interface instead of fiddling with faked licenses and creating
legal bordercases. 

All drivers we did so far have LGPL user space counterparts and that's
the preferred way to go.

Also we have the user space driver support for USB already and I have
not seen negative impact from this one yet.

> > >  drivers/uio/uio_cif.c                 |  156 ++++++++
> > 
> > eh?  How come a particular device requires 156 lines of kernel code to
> > support a userspace driver?  Doesn't that kind of defeat the point?
> 
> No, you still need kernel code to handle the interrupt properly, we do
> not want userspace to do this as it would slow the system down and do
> all sorts of other bad things.  That's the main problem with all of
> those other proposals that people have for trying to do this kind of
> work in the past (can't share irqs, can't block on userspace in an
> interrupt handler, etc.)

Ack.

	tglx


