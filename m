Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbXGaShx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbXGaShx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933833AbXGaShh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:37:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43056 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814AbXGaShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:37:35 -0400
Date: Wed, 1 Aug 2007 00:19:48 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070731082057.GM9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707312351020.28746@enigma.security.iitk.ac.in>
References: <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in>
 <20070730083259.GD9840@enneenne.com> <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in>
 <20070730145542.GG9840@enneenne.com> <alpine.LFD.0.999.0707310153110.17287@enigma.security.iitk.ac.in>
 <20070731082057.GM9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Rodolfo Giometti wrote:

> On Tue, Jul 31, 2007 at 03:31:22AM +0530, Satyam Sharma wrote:

> > Yup, this would avoid races, but then we will lose events. Why is that
> > acceptable, when better alternative (above) exists?
> 
> Because is better lossign events then recording them delayed. In the
> past we (LinuxPPS users) noticed that just postponing of one
> instruction the timestamp recording degrade the timesetting of about
> 50%!

> > Amazing. On the one hand, you want to use spin_trylock() in the hard irq
> > handler and spin_lock() (not irq safe) in the process context, because
> > you "don't care about losing some events". And now you want to avoid
> > "disabling irqs in user context to minimize possibility to delay events
> > recording"?
> 
> Just for not delaying the IRQ handler. As already said, I prefere
> loosing events that delaying their timestamps recording.

> > Anyway, any such requirement you're talking about is just bogus, IMHO.
> > You're just disabling interrupts to access a data structure, for Gods'
> > sakes, how many nanoseconds do you imagine would you be "delaying"?
> 
> As already said we noticed that just delaying of one instruction the
> timestamp recording the time setting degrades of about 50%.
> 
> We have to take care of this point. It's _very_ important that _each_
> event had its timestamp recorded with delay as small as possible.


That's just absolute bullshit.

I'm sorry to say this, Rodolfo, but _all_ your arguments above are
*totally* nonsensical and factually incorrect -- and I have had enough of
trying to talk sense to you, it's been ~15 mails in this thread already,
and I've been WASTING my time trying to teach / explain to you, but it's
just *shocking* that you prefer to stick to a wholly incorrect (which I
suspect you've already understood by now anyway) position rather than
just accepting that the present patch is wrong and go about correcting
it instead.


> > The proper way to do this is to use a kernel buffer to do all kernel-side
> > work (you acquire/release lock during that work) and then copy_to_user()
> > later, at the end. [ And something opposite for the set_xxx syscall, i.e.
> > first off copy_from_user() to a kernel buffer up front, before doing
> > anything else itself, and then do all the work in the kernel on that. ]
> 
> Mmm... I think this is not easy at all for sys_time_pps_fetch(). I
> suppose you have to complicate its code a lot!
> 
> I don't undestand why we must complicate, and made unreadable, a code
> in order to follow the rule use-only-one-lock-mechanism. If by using
> mutex and spinlocks the code is more readable, where is the fault?


More nonsense. Utter nonsense. I really don't want to reply anymore ...


> > BTW your syscall implementations totally lack any kind of security checks
> > whatsoever ...
> 
> Ok, we can correct them. :)
> 
> > > Please, take alook at NTPD code. Common usage is:
> > > 
> > >    fd = open("/dev/ttyS0", ...);
> > > 
> > >    pps_time_create(fd, &handler);
> > > 
> > > since RFC supposes that at filedes "fd" is mapped both GPS data _and_
> > > PPS source.
> > 
> > Umm, I don't think the RFC supposes/assumes this anywhere.
> 
> I think so. If not, why they pretend an _already opened_ filedes then
> just a filename to be used as parameter for the open(2) syscall? :)


Try reading the RFC again, please. And *think*.


Anyway, considering:

1. broken/nonsensical locking,
2. wrong (completely RFC non-compliant) implementation,
3. a syscall (time_pps_cmd) that has no semantics defined anywhere,
   not even mandated by the RFC, is (as you yourself admitted)
   a pseudo-ioctl for all practical purposes,
4. abject lack of security in the syscall implementations,

But MOST importantly:

5. your _sticking_ to the broken implementation and being so
   (shockingly!) unwilling to correct these,

I really cannot see how I can support this stuff in getting merged
at all, sorry.


Satyam
