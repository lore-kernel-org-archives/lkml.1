Return-Path: <linux-kernel-owner+w=401wt.eu-S1764577AbYDVPe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764577AbYDVPe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbYDVPee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:34:34 -0400
Received: from smtp.enter.net ([216.193.128.24]:4450 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761883AbYDVPed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:34:33 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: x86: 4kstacks default
Date: Tue, 22 Apr 2008 11:34:29 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <ak6tq-32p-7@gated-at.bofh.it> <200804201659.52902.dhazelton@enter.net> <alpine.LSU.0.999.0804212152310.4235@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0804212152310.4235@be1.lrz>
Cc: 7eggert@gmx.de, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221134.30631.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 16:05:38 you wrote:
> On Sun, 20 Apr 2008, Daniel Hazelton wrote:
> > On Sunday 20 April 2008 16:23:45 Bodo Eggert wrote:
> > > Daniel Hazelton <dhazelton@enter.net> wrote:
> > > > On Sunday 20 April 2008 08:27:14 Andi Kleen wrote:
> > > >> Adrian Bunk <bunk@kernel.org> writes:
> > > >> > 6k is known to work, and there aren't many problems known with 4k.
> > > >> >
> > > >> > And from a QA point of view the only way of getting 4k thoroughly
> > > >> > tested
> > > >>
> > > >> But you have to first ask why do you want 4k tested? Does it serve
> > > >> any useful purpose in itself? I don't think so. Or you're saying
> > > >> it's important to support 50k kernel threads on 32bit kernels?
> > > >
> > > > Andi, you're the only one I've seen seriously pounding the "50k
> > > > threads" thing - I don't think anyone is really fooled by the
> > > > straw-man, so I'd suggest you drop it.
> > > >
> > > > The real issue is that you think (and are correct in thinking) that
> > > > people are idiots. Yes, there will be breakages if the default is
> > > > changed to 4k stacks - but if people are running new kernels on boxes
> > > > that'll hit stack use problems (that *AREN'T* related to ndiswrapper)
> > > > and haven't made sure that they've configured the kernel properly,
> > > > then they deserve the outcome. It isn't the job of the Linux Kernel
> > > > to protect the incompetent - nor is it the job of linux kernel
> > > > developers to do such.
> > >
> > > It's the job of the kernel developers to mark experimental and broken
> > > options, and to put a warning:
> > >
> > > "This will break stacking of drivers, especially if disk manager, xfs,
> > > RAID and nfs are used. Yes, linux is broken by default, but only if you
> > > intend to set up a reliable system, so this will be OK!"
> > >
> > > into the help text, instead of expecting each admin to read lkml.
> >
> > Note that I've yet to meet a competent admin that creates brand new
> > configurations each time they build a new kernel for a machine.
>
> Once is enough, and if you build a costom kernel, you'll certainly not
> want to start from the distribution's allmodconfig.

No, you wouldn't. But, at least at the companies I've worked for, there was 
already a custom kernel running and it had a default configuration file that 
was updated and carried over to each new kernel, with a "make oldconfig" done 
to update it.

> > Usually they
> > have a "default configuration" for each machine that gets updated each
> > time a new kernel is built. Usually they don't change working options.
> > And since changing things to 4K stacks default would cause a new option -
> > the "8K stacks" option to show up in a "make oldconfig" run - the admin
> > would see it and, hopefully, check the help text and see that it his
> > system, with a deeply stacked driver system (nfs+xfs+raid, for example)
> > and set the 8K stacks option to "Y".
>
> The help text does not yet say anything about crashing.

It should be updated to note that there are configurations that will overrun 
the stack and cause crashes. (However, it shouldn't be the default - I'll 
agree to that)

> > As I said, it isn't the job of the kernel or kernel developers to protect
> > the incompetent (or the lazy).
>
> It's only incompetent if it's reasonable to expect a crashing kernel to
> result from chosing the default values.

Agreed. I've been arguing about it without being clear that my arguments for 
it (including making it the default) are from the perspective of a desktop 
user who had run the "stack depth check" on an 8K stacks kernel for a long 
time and found that the only times he ever had problems was during boot - 
with "sed" and "grep" being the culprits.

Booting a 4K stacks kernel wouldn't work if I hadn't also modified the 
initscripts here, and that wasn't easy - I've got a report of grep using 
enough stack that only about 3900 bytes were left on the 8K stack.  However, 
I think this does show that there are problems left in a number of places 
that make moving to a default of 4K stacks dangerous.

(I've recently checked this by undoing my changes and setting up an 8K kernel 
on this laptop - I don't know if the next version of the distro will ship 
with 4K stacks, but I'm pretty certain it won't)

In light of this I'm going to pull out of this discussion, because I can no 
longer support a move to 4K stacks default. This doesn't mean I don't still 
support having them around, or even a move to them as a default at a later 
date, but right now there are still many places where there are problems that 
would cause "mysterious" failures and corruption with 4K stacks.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
