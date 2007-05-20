Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbXETQKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbXETQKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbXETQKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:10:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:54684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbXETQKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=legh5FFkwx2Ic9ZXe+ikal0Hl9os0+YjLMtBuTIll6BAARgMut+t8etGeMwJ7iBhwtct7ij9XxOXp1rgFK8O7OsfHEOZUZMx/ifxjYKJM08u5HZuR4XFrWOIXf04Wi5bKXe6h9nYwnh7sPO5+RGjnsNxUUix6hKfEFRwP97gq3M=
Message-ID: <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
Date: Sun, 20 May 2007 09:10:12 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Al Viro" <viro@ftp.linux.org.uk>, "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Uwe Bugla" <uwe.bugla@gmx.de>, "Ken Chen" <kenchen@google.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070519191751.E51233A23A2@muan.mtu.ru>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	 <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
X-Google-Sender-Auth: fa06f4b167e561dd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On 5/20/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > On 5/19/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > > On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > > feature for 2.6.22, I'd suggest just reverting it for now until the
> > > > issues are ironed out.
> > >
> > > Hold it.  The real question here is which logics do we want there.
> > > IOW, and how many device nodes do we want to appear and _when_ do
> > > we want them to appear?
> >
> > The when part is what looks to make it racy. I'm guessing that we're
> > relying on udev to create those loop nodes. If so, I think any scheme
> > that creates more on demand would give transient mount errors while
> > it's waiting on udev to create more nodes.
> >
> > Perhaps if we were to start with 8 loop nodes at init (as we have in
> > 2.6.21), and then always maintain a margin of 8 (or 4, or...) when
> > they start being used or detached?
>
> Until the tools can request dynamic loop device allocation from the
> kernel before they want to use the device, you can create as many as
> needed "static" loop* nodes in /lib/udev/devices/, which will be
> copied to /dev/ early on every bootup.

Except that's different than current behavior presented to userspace.
IOW, we broke userspace for anyone using udev. Which is, y'know, a lot
of us.

We're at -rc2 right now. Given that, it looks like we have two
options. First is to revert all this for now and try again when the
patch has had more testing and agreement (as this isn't a major
feature we're talking about here; it's effectively just a cleanup that
happened to have unfortunate side-effects).

The second option is that we could have the loop device start with 8
nodes populated, which would match current behavior.

A third option of requiring new userspace for 2.6.22 is a non-starter.
