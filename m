Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbZIROoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbZIROoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZIROoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:44:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:33988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZIROoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:44:01 -0400
Date: Fri, 18 Sep 2009 16:43:31 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
  maintenance disaster
Message-ID: <20090918164331.24403a5d@infradead.org>
In-Reply-To: <ac3eb2510909180732s6efc97b0o7b25d8da222088ca@mail.gmail.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<m1d45oxsrk.fsf@fess.ebiederm.org>
	<20090918160944.58e5c1f5@infradead.org>
	<ac3eb2510909180711k223aeb6ena2de3645317d03bd@mail.gmail.com>
	<20090918162503.6735cc1b@infradead.org>
	<ac3eb2510909180732s6efc97b0o7b25d8da222088ca@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 16:32:18 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, Sep 18, 2009 at 16:25, Arjan van de Ven <arjan@infradead.org>
> wrote:
> > On Fri, 18 Sep 2009 16:11:16 +0200
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> >> On Fri, Sep 18, 2009 at 16:09, Arjan van de Ven
> >> <arjan@infradead.org> wrote:
> >>
> >> > frankly, modprobe should call the settle.
> >>
> >> We call modprobe from udev, and will have fun with such a solution.
> >>
> >
> > too bad you cut my next sentence which said that there needed to be
> > a way to opt out of that.
> 
> Too bad, bad we don't have control over all the udev rules out there
> doing that, which will dead-lock then. And too bad that when udev
> calls modprobe we still don't solve the races. Too bad that calling
> "settle" waits for all events and you can never know when loading a
> module what to wait for and what not. It's just not a close to a
> solution that is doing any good. What's the point of all these weird
> workarounds you are proposing? I think it's properly solved already.

please chill out. your attitude is exactly why several folks are giving
an allergic reaction. every other sentence for you is either extreme
defensive or attacking, rather than constructive discussion.

Lets be clear:
1) modprobe already does some serialization (right now on the kernel
   side, but ideally we move that to modprobe binary so that we can skip
   that when we can)
2) udev today has a small design issue that is relatively easy to fix.
Right now, the rules call modprobe manually, each and every one of
them. What is needed is a MODPROBE += directive for these instead of
the RUN += that is done today. This is not (just) for this issue here,
but is essential to reduce the cost of udev. A big chunk of udev cost
is in doing dozens and dozens of useless modprobe execs; the only way
to solve this is by having a MODPROBE +=.
(useless because the thing they modprobe doesn't exist)
3) if we move synchronization for other things to modprobe, it might
make sense to move the device node synchronization to it as well.
Exactly for the scenario you described, to get a good, generic
solution, that also makes sure that the permissions/ownership/etc of
the device node is also the right one. 

(to answer your "we are perfect" dream:
you solved the "modprobe loop; losetup" example.
you did not solve the "modprobe i915 ; startx" example.
)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
