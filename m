Return-Path: <linux-kernel-owner+w=401wt.eu-S939309AbXG3VtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939309AbXG3VtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967981AbXG3VtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:49:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55222 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967869AbXG3VtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:49:06 -0400
Date: Tue, 31 Jul 2007 03:31:22 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070730145542.GG9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707310153110.17287@enigma.security.iitk.ac.in>
References: <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in>
 <20070730083259.GD9840@enneenne.com> <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in>
 <20070730145542.GG9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,


On Mon, 30 Jul 2007, Rodolfo Giometti wrote:

> On Mon, Jul 30, 2007 at 02:37:26PM +0530, Satyam Sharma wrote:
> 
> > > Maybe you meant I should using spin_lock_irqsave/restore() in user
> > > context, but doing like this I will disable interrupts
> > 
> > Yup, but the goal is to avoid races. Otherwise why bother doing any
> > locking at all?
> 
> I meant that if you have to lock between user context and interrupt
> context you have two choises:
> 
> 1) using spin_lock_irqsave/restore() in user context and spin_lock/unlock()
> in the interrupt context (as Rusty says),

Yes, but we need to use spin_lock_irqsave() from interrupt context to
synchronize between two hard irq contexts themselves.


> 2) or using spin_lock/unlock() in user context and
> spin_trylock/unlock() in the interrupt context in order to avoid dead
> locks.

Yup, this would avoid races, but then we will lose events. Why is that
acceptable, when better alternative (above) exists?

Seriously, your aversion to implement good, safe locking is amazing! :-)


> > > Of course, I meant "protecting data". In fact to protect pps_source[]
> > > I need spin_lock() to protect user context from interrupt context and
> > > mutex to protect user context from itself.
> > 
> > But that's nonsensical! That's not how you implement locking!
> > 
> > First, spin_lock() is *not* enough to protect access from process context
> > from access from interrupt context.
> > 
> > Second, if you *already* have a lock to protect any data, introducing
> > *another* lock to protect the same data is ... utterly crazy!
> 
> I see what you mean. But my question is about using spin_locks where
> we can sleep. Let me explain, consider sys_time_pps_getparams():
> [...]
> The copy_to_user() may sleep and if I change
> mutex_lock_interruptible() with a spin_lock I may hold it and then
> going to sleep... using mutex we can use the CPU for other
> computations.

The proper way to do this is to use a kernel buffer to do all kernel-side
work (you acquire/release lock during that work) and then copy_to_user()
later, at the end. [ And something opposite for the set_xxx syscall, i.e.
first off copy_from_user() to a kernel buffer up front, before doing
anything else itself, and then do all the work in the kernel on that. ]

BTW your syscall implementations totally lack any kind of security checks
whatsoever ...


> > > Why you wish using one lock per sources? Just one lock for the
> > > list/array is not enought? :-o
> > 
> > No, I am *not* wishing / advocating that at all. Just that you appear so
> > _reluctant_ to use spinlocks and are unnecessarily worrying about
> > contention, disabling interrupts, etc etc.
> > 
> > Just use the spin_lock_irqsave/restore() variants, and you'll be fine.
> 
> What I wish is just to avoid disabling IRQs in user context in order
> to minimize the possibility to delay events recording.

Amazing. On the one hand, you want to use spin_trylock() in the hard irq
handler and spin_lock() (not irq safe) in the process context, because
you "don't care about losing some events". And now you want to avoid
"disabling irqs in user context to minimize possibility to delay events
recording"?

Anyway, any such requirement you're talking about is just bogus, IMHO.
You're just disabling interrupts to access a data structure, for Gods'
sakes, how many nanoseconds do you imagine would you be "delaying"?


> > > As you propose you need _two_ open() and not just one...
> > 
> > No, why?
> 
> Please, take alook at NTPD code. Common usage is:
> 
>    fd = open("/dev/ttyS0", ...);
> 
>    pps_time_create(fd, &handler);
> 
> since RFC supposes that at filedes "fd" is mapped both GPS data _and_
> PPS source.

Umm, I don't think the RFC supposes/assumes this anywhere.


> Furthermore with my pps_findpath() I can do:
> 
>    fd = open("/dev/ttyS0", ...);
> 
>    handler = pps_findpath("/dev/ttyS0", ...);
> 
> which in most cases its more easy to manage for both user and kernel
> land.
> 
> Can do the same with char devices?

Of course. BTW time_pps_findpath/findsource do not have to be kernel
implemented syscalls in the first place. The best, simplest and most
straightforward place to implement them is in userspace -- the RFC
mentions this as well.


> Maybe you can easily create
> /dev/pps0 but how can you relate it with the /dev/ttyS0 if your GPS
> antenna and PPS source share the same serial port?

A solution I can think of is to create a mapping at the time of
pps_register_source() between the PPS source (physically) and the special
char device. Userspace open(2)'s the special char device corresponding to
the PPS source, and then issues the time_pps_create() syscall. Here, we
lookup the mapping previously created and return handle to the PPS source
based on the special device's fd that's passed to us in time_pps_create().


> > > I quite sure that RFC is broken since it doesn't take in account that
> > > a PPS source maybe not connected with any cahr device at all. I tried
> > > to explain this problem to RFC's gurus but they never answered to me,
> > > so I decided to resolve the problem by myself. ;)
> > 
> > Nopes, the RFC is not broken at all. All this physical-connection-port
> > device vs PPS-source-device confusion is just in your mind :-)
> 
> Ok, if you don't think so try looking at NTPD code (written by RFC's
> gurus) and try to resolve the problem where both GPS antenna and PPS
> source are connected with a serial port, and the problem where only
> the GPS antenna is connected with the serial port but the PPS source
> is connected with a CPU's GPIO.
> 
> If you solve both them all PPS users will thank you a lot forever! :)

Ok, I'll take a look, thanks :-)

[ what's the URL for these sources? ]


> No, they require an _already_ opened file descriptor because they
> supposed you can use serial line file descriptor!

open(PPSfilename, O_RDWR) doesn't sound like that at all. If the device
for the serial port / parport was intended, it wouldn't be called
"PPSfilename", would it?


> Again, RFC was sane if it said that you can get a PPS hadler by simply
> doing:
> 
>    time_pps_create("/dev/pps0", &handle);
> 
> this could be easily implemented with just an open()...
> 
> They didn't like this because they __never__ considered the case where
> the PPS source is not connected at all with any serial/parallel
> decices.

The physical port/device through which a PPS source is connected is
immaterial. Anyway, I'll take a look at the NTPD/userspace code you are
mentioning as well. [ again, could you point me to URL of source code? ]


> > If you want, I can try and implement the other bits that I had suggested
> > for the other things as well :-)
> 
> Great! Thanks a lot, so we can discuss on them and maybe we can prive
> Linux of this PPS support! :)

Sure, I'll get to implementing what I have in mind here -- will be glad
to be of any help, thanks.


Satyam
