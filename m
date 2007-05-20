Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXETQeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXETQeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758353AbXETQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:34:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:39125 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758279AbXETQeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:34:02 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1/5FI0ct3T5SGf4DOw9/88aYxmqKv5yo7ULgvqlBj
	10nmnwwL1b5UtE
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Sun, 20 May 2007 18:29:19 +0200
User-Agent: KMail/1.9.5
References: <464F42F3.1080300@madrabbit.org> <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com> <1179677799.3311.5.camel@lov.localdomain>
In-Reply-To: <1179677799.3311.5.camel@lov.localdomain>
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Ken Chen" <kenchen@google.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       Andreas Schwab <schwab@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201829.19838.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 20. Mai 2007 18:16 schrieben Sie:
> On Sun, 2007-05-20 at 09:10 -0700, Ray Lee wrote:
> > On 5/20/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > On 5/20/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > > > On 5/19/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > > > > On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > > > > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > > > > feature for 2.6.22, I'd suggest just reverting it for now until
> > > > > > the issues are ironed out.
> > > > >
> > > > > Hold it.  The real question here is which logics do we want there.
> > > > > IOW, and how many device nodes do we want to appear and _when_ do
> > > > > we want them to appear?
> > > >
> > > > The when part is what looks to make it racy. I'm guessing that we're
> > > > relying on udev to create those loop nodes. If so, I think any scheme
> > > > that creates more on demand would give transient mount errors while
> > > > it's waiting on udev to create more nodes.
> > > >
> > > > Perhaps if we were to start with 8 loop nodes at init (as we have in
> > > > 2.6.21), and then always maintain a margin of 8 (or 4, or...) when
> > > > they start being used or detached?
> > >
> > > Until the tools can request dynamic loop device allocation from the
> > > kernel before they want to use the device, you can create as many as
> > > needed "static" loop* nodes in /lib/udev/devices/, which will be
> > > copied to /dev/ early on every bootup.
> >
> > Except that's different than current behavior presented to userspace.
> > IOW, we broke userspace for anyone using udev. Which is, y'know, a lot
> > of us.
> >
> > We're at -rc2 right now. Given that, it looks like we have two
> > options. First is to revert all this for now and try again when the
> > patch has had more testing and agreement (as this isn't a major
> > feature we're talking about here; it's effectively just a cleanup that
> > happened to have unfortunate side-effects).
> >
> > The second option is that we could have the loop device start with 8
> > nodes populated, which would match current behavior.
> >
> > A third option of requiring new userspace for 2.6.22 is a non-starter.
>
> Right, providing "preallocated" devices, 8 or the number given in
> max_loop, sounds like the best option until the tools can handle that.
>
> Thanks,
> Kay

OK people, this is what I did just to resolve the issue for now:

1. copied loop.c from 2.6.21 into the 2.6.22-rc2 tree
2. changed exactly two entries from "invalidate_bdev(bdev, 0)"

to "invalidate_bdev(bdev)"

Output is:
a. a compilable kernel
b. all four iso images are mounted as expected

Andrey's path however (i. e. copying his attached version of loop.c into the 
2.6.22-rc2 kernel tree) led to:

a. an incompilable kernel
b. endless messages trying to compile loop.c going like this (just a part of 
them - not complete anyway!):

drivers/block/loop.c:1350: error: stray '\240' in program
drivers/block/loop.c:1350: error: stray '\240' in program
drivers/block/loop.c:1350: error: stray '\240' in program
drivers/block/loop.c:1350: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c:1351: error: stray '\240' in program
drivers/block/loop.c: In function 'loop_register_transfer':
drivers/block/loop.c:1367: error: stray '\240' in program
drivers/block/loop.c:1367: error: stray '\240' in program
drivers/block/loop.c:1367: error: stray '\240' in program
drivers/block/loop.c:1367: error: stray '\240' in program
drivers/block/loop.c:1367: error: stray '\240' in program
drivers/block/loop.c:1367: error: stray '\240' in program
drivers/block/loop.c:1367: error: stray '\240' in program
drivers/block/loop.c:1367: error: stray '\240' in program

Thanks to Ray! Well done!

Best regards

Uwe

