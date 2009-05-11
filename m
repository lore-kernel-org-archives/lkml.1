Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZEKNth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZEKNth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZEKNt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:49:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:51789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZEKNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:49:26 -0400
Date: Mon, 11 May 2009 06:49:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs
Message-ID: <20090511064904.3e1d6c34@infradead.org>
In-Reply-To: <ac3eb2510905110628y65c9a2b8s576bfa4f17ef52e1@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
	<20090511060528.31e0f20c@infradead.org>
	<ac3eb2510905110628y65c9a2b8s576bfa4f17ef52e1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 15:28:33 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Mon, May 11, 2009 at 15:05, Arjan van de Ven <arjan@infradead.org>
> wrote:
> > On Mon, 11 May 2009 13:34:52 +0200
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> >>
> >> > - That the other proposals are worse than yours.
> >>
> >> I also did, in exactly this thread.
> >
> > no you have not. But I'd like you to ;)
> 
> I did. It's reliability, the race for new devices coming in when you
> start reading your list and finishing creating the nodes. You will
> miss these device, which we don't want to work around with another
> hack. You will have to bring up the machinery that listens to events
> for new devices, before synthesizing the stuff that is already there.

and this is hard because ?
certainly udev already does the listen machinery as its first step;
after setting that up, quickly racing down a "list" (whatever form you
make that in) and then daemonizing to work through the events shouldn't
be a problem. 

(and you are right, while this is not an issue without initramfs,
because the kernel doesn't return until all probing activity has
finished, it might be a problem for initramfs, because that executes
before all the probing is done. But it's not a hard issue, just a
sequencing issue)

> 
> > You have not commented substantially on my counter proposal to make
> > the single file with the "device list" (eg char/block, major,
> > minor, name) so that userland can make the nodes in 0.01-or-less
> > seconds, but with the permissions/owners it wants and the tmpfs
> > mount options it wants.
> 
> I did. We have all that information in /sys already. I don't see the
> reason for another file other than to provide the information to make
> just another new userspace hack a bit more efficient.

I personally don't think the 0.06 seconds are a problem, but I got the
impression that you were trying to optimize this path with your patch.
(After all, it is pretty much the cost of the thing you're optimizing)

> 
> And the main point is the reliability, let all the weird speed
> arguments and made-up numbers alone. 

I'm sorry, but you're either trying to be obnoxious or telling us your
own numbers are made up. Since I doubt the former, and neither my nor
Erics numbers are made up, I'll assume the later...

> You depend on whatever rather
> complex userspace to bring your box. And people complain about that
> for years, and for good reason.

prior to sysfs people depended on MAKEDEV (and the fact that they chose
to not use tmpfs but a real fs for /dev) for this. It's not that much
different today. Using tmpfs for /dev is a local choice. It's fully
optional in fact.. and that's a good thing.
> 
> On my box we create 12152 files in /sys on bootup, and with devtmps
> the same code creates 218 simple device nodes with the same call, and
> this makes bootup reliable, more self-contained, and as a nice side
> effect makes it faster. Just focus on init=/bin/sh, if you want to see
> the reason behind all this.

init=/bin/sh is an interesting subcase, sure. It means in the "before
your patch" scenario that people get the "real /dev directory", and not
the tmpfs overmount. It's a distro choice what to put there. Fedora puts
nothing there, Moblin puts only all static-allocated device nodes there.
I don't know what openSuSE puts there. 

People who use init=/bin/sh don't expect a full system, yet they expect
a certain amount of system that allows them to do system recovery I
suppose. I don't consider the delta between "static nodes only" and
"devshmfs" to be significant here. In a recovery scenario, if you WANT
something dynamic you start the thing to do dynamic by hand. Otherwise
you want something predictable.


> We focused on the speed here, because we want to solve the initramfs
> problem, a problem you solved by getting rid of it entirely, which is
> what I do on all my own boxes too, but what the distro guys 
> never want to accept.

Now you've lost me. I am missing the link between this and initramfs
entirely. How you do /dev has extremely little to do with initramfs or
not. Sure you need the rootfs device node before you can mount root for
the initramfs case, just like you need the rootfs device node before
you can fsck it in the non-initramfs case. In both cases you want all
the device nodes as fast as you can, but within the system policy of
ownership, permissions, selinux contexts, tmpfs mount options etc.
And Eric showed that that is a 0.06 second thing.. not a big deal in
the grand scheme of things, even if you want to boot the whole system
in 2 seconds like we do.

Also you're rather generalizing with "the distro guys"... the Moblin
distribution already does this for the cases where it is possible. I
wouldn't be surprised if other distros figured out how to detect this
case and ditch the initramfs when it's possible, while keeping it and
doing it cheaply when it's required to have an initramfs.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
