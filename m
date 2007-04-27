Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbXD0XNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbXD0XNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbXD0XNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:13:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:38717 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbXD0XNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:13:31 -0400
Date: Fri, 27 Apr 2007 16:11:05 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070427231105.GA19156@suse.de>
References: <20070427224957.GA17967@kroah.com> <20070427160425.710c0230.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427160425.710c0230.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:04:25PM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 15:49:57 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > Here are the updated UIO (Userspace I/O driver framework) patches for
> > 2.6.21.
> 
> I'm a bit uncertain about the whole UIO idea, really.  I have this vague
> feeling that we'd prefer to encourage people to move device drivers into
> GPL'ed kernel rather than encouraging them to do closed-source userspace
> implementations which will probably end up being slower, less reliable and
> unavailable on various architectures, distros, etc.

It's not a closed vs. open issue, it just turns out that a lot of people
keep trying to write PCI drivers in userspace (how many different papers
were published on this topic alone in the past year...).  This framework
is to allow this to happen in a sane and correct way.

Lots of different types of odd devices do not fit into the "kernelspace
driver" framework very well for a variety of reasons:
	- zillions of different controls in the card
	- floating point is needed to compute the next step of an
	  operation in moving a physical object

With this framework, we provide a solid and simple way to provide for
these kinds of devices.  The Linutronix guys have had a lot of
experience in supporting this kind of hardware in the past and can
provide better examples if you need.

But yes, it does allow you to write a PCI driver in userspace, being
closed source, if you really want to.  But if you do that, then you get
_no_ advantages of being in the kernel (caching, common userspace
interface, resource management, etc.) and need to handle that all
yourself.  Heck, that's pretty much what X does today for lots of old
video cards :)

> > They have been revamped from the last time you have seen them, and they
> > include a real driver, the Hilscher CIF DeviceNet and Profibus card
> > controller, which is being used in production systems with this driver
> > framework right now.  The kernel driver they replaced was a total mess,
> > with over 60+ ioctls to try to control the different aspects of the
> > device.  See the last patch in this series for more details on this
> > driver.
> > 
> > These patches include full documentation, are self-contained from the
> > rest of the kernel, and have been in the -mm tree for the past few
> > months with no complaints.
> > 
> > Please pull from:
> > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/uio-2.6.git/
> > 
> > Patches will be sent as a follow-on to this message to lkml for people
> > to see.
> > 
> >  drivers/uio/uio_cif.c                 |  156 ++++++++
> 
> eh?  How come a particular device requires 156 lines of kernel code to
> support a userspace driver?  Doesn't that kind of defeat the point?

No, you still need kernel code to handle the interrupt properly, we do
not want userspace to do this as it would slow the system down and do
all sorts of other bad things.  That's the main problem with all of
those other proposals that people have for trying to do this kind of
work in the past (can't share irqs, can't block on userspace in an
interrupt handler, etc.)

thanks,

greg k-h
