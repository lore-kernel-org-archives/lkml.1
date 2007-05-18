Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXERVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXERVsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbXERVsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:48:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXERVsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:48:10 -0400
Date: Fri, 18 May 2007 14:46:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Misc: phantom, move to unlocked_ioctl
Message-Id: <20070518144654.2ff459c1.akpm@linux-foundation.org>
In-Reply-To: <4af2d03a0705181425o1ba78307uef3deb4970bb954d@mail.gmail.com>
References: <20644182862815412171@wsc.cz>
	<20070518140314.4cabb926.akpm@linux-foundation.org>
	<4af2d03a0705181425o1ba78307uef3deb4970bb954d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 23:25:52 +0200
"Jiri Slaby" <jirislaby@gmail.com> wrote:

> On 5/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 18 May 2007 22:34:53 +0200 (CEST)
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> >
> > > @@ -118,7 +125,9 @@ static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
> > >               if (r.reg > 7)
> > >                       return -EINVAL;
> > >
> > > +             spin_lock(&dev->ioctl_lock);
> > >               r.value = ioread32(dev->iaddr + r.reg);
> > > +             spin_unlock(&dev->ioctl_lock);
> >
> > What is that locking protecting in here?
> 
> Well, what led me to do it is that I didn't know how much atomic are
> ioread and iowrite. If concurrent process writes something to the
> place in that space while the other one is reading it, doesn't matter,
> correct?
> 

I don't think there are any atomicity concerns with the IO operation
itself: it's just a 32-bit read or write against a PCI device.

But there may be issues at a higher level: if some other thread of control
can be writing that register then this read is basically meaningless, as
the value which it returns can become wrong at any time.

But that's just the nature of the ioctl API which is being implemented -
there isn't much we can do about that, apart from perhaps deciding not to
implement it at all.  This is a "read an arbitrary register" interface,
yes?  I dunno what it's there for, but it is obviously racy against the
write-a-register ioctls, so userspace just has to be aware of that.

umm, assuming that this interface is actually valuable to userspace then
I'd say that we can remove the spin_lock() and leave the rest alone.

It _may_ make sense to change the SET_REGS operations to do a dummy read
from the device though: PCI posting could cause the user's register-write
to not actually hit the device for an arbitrarily long period after the
ioctl has returned.
