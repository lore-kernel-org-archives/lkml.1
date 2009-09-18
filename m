Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZIRPNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZIRPNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZIRPNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:13:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:53306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZIRPNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:13:36 -0400
Date: Fri, 18 Sep 2009 17:13:28 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
  maintenance disaster
Message-ID: <20090918171328.7a102223@infradead.org>
In-Reply-To: <ac3eb2510909180758u2131ae0eo9030a97cdde75bc6@mail.gmail.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<m1d45oxsrk.fsf@fess.ebiederm.org>
	<20090918160944.58e5c1f5@infradead.org>
	<ac3eb2510909180711k223aeb6ena2de3645317d03bd@mail.gmail.com>
	<20090918162503.6735cc1b@infradead.org>
	<ac3eb2510909180732s6efc97b0o7b25d8da222088ca@mail.gmail.com>
	<20090918164331.24403a5d@infradead.org>
	<ac3eb2510909180758u2131ae0eo9030a97cdde75bc6@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 16:58:28 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:
> > Lets be clear:
> > 1) modprobe already does some serialization (right now on the kernel
> >   side, but ideally we move that to modprobe binary so that we can
> > skip that when we can)
> 
> We only serialize symbol linking I guess, and that window got pretty
> small in recent kernels.

more than that; there's also an async_synchronize_full() function call.
I'd love to be able to move that down into modprobe.

> 
> > 2) udev today has a small design issue that is relatively easy to
> > fix. Right now, the rules call modprobe manually, each and every
> > one of them. What is needed is a MODPROBE += directive for these
> > instead of the RUN += that is done today. This is not (just) for
> > this issue here, but is essential to reduce the cost of udev. A big
> > chunk of udev cost is in doing dozens and dozens of useless
> > modprobe execs; the only way to solve this is by having a MODPROBE
> > +=. (useless because the thing they modprobe doesn't exist)
> 
> That would help in which case? Which single event does do more than a
> single modprobe call? What do you want to collect?

DRIVER!="?*", ENV{MODALIAS}=="?*", RUN{ignore_error}+="/sbin/modprobe
$env{MODALIAS}"

I don't want to "collect". What I want is to have udev check the module
alias database directly for existence, rather than exec()ing modprobe
100 times, which then reads in that same table, etc 100 times.

if you measure things, these 100 aliases (of which maybe 5 cause a real
module to load) causing 100 execs is a rather significant chunk of
where the udev cost during boot goes.... from where I sit that makes it
worth optimizing ;)

> 
> > 3) if we move synchronization for other things to modprobe, it might
> > make sense to move the device node synchronization to it as well.
> > Exactly for the scenario you described, to get a good, generic
> > solution, that also makes sure that the permissions/ownership/etc of
> > the device node is also the right one.
> 
> How do you know what to sync against, what to wait for? I'm pretty
> sure the sync creation is much simpler and solves most of the problems
> in the right way.

it's only sync creation if the device init/registration is also sync.

for performance I suspect we need to end with an *option* to just load
all modules based on the device in the system, without waiting, and
then at the end of loading all, say, 60 modules, wait before udev
continues.

that is different than later on loading, say, the loop module by hand,
where the user expects "full synchronization". The device node is a
small part of that, and clearly a relevant part, but it all goes
together. The moment modprobe synchronizes explicitly (albeit by
default) for the device init, it can and likely could also sync the
full device creation (so including owner/acl/selinux context etc),
providing a solution to the problem you want, but including the
owner/acl bits.

I suspect you're now going "lalalala" ;-)

but I'm not saying all of this to diss your devfs code. I'm saying that
*regardless of* your code, modprobe likely needs to start doing
these synchronization steps over time.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
