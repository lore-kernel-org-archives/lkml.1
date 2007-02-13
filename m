Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXBMXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXBMXVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXBMXVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:21:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4604 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXBMXVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:21:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 13 Feb 2007 15:21:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
In-Reply-To: <20070213213422.GA22104@elte.hu>
Message-ID: <Pine.LNX.4.64.0702131457060.32055@alien.or.mcafeemobile.com>
References: <20070213142042.GG638@elte.hu> <Pine.LNX.4.64.0702131117120.32055@alien.or.mcafeemobile.com>
 <20070213213422.GA22104@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Ingo Molnar wrote:

> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > > +The Syslet Atom:
> > > +----------------
> > > +
> > > +The syslet atom is a small, fixed-size (44 bytes on 32-bit) piece of
> > > +user-space memory, which is the basic unit of execution within the syslet
> > > +framework. A syslet represents a single system-call and its arguments.
> > > +In addition it also has condition flags attached to it that allows the
> > > +construction of larger programs (syslets) from these atoms.
> > > +
> > > +Arguments to the system call are implemented via pointers to arguments.
> > > +This not only increases the flexibility of syslet atoms (multiple syslets
> > > +can share the same variable for example), but is also an optimization:
> > > +copy_uatom() will only fetch syscall parameters up until the point it
> > > +meets the first NULL pointer. 50% of all syscalls have 2 or less
> > > +parameters (and 90% of all syscalls have 4 or less parameters).
> > 
> > Why do you need to have an extra memory indirection per parameter in 
> > copy_uatom()? [...]
> 
> yes. Try to use them in real programs, and you'll see that most of the 
> time the variable an atom wants to access should also be accessed by 
> other atoms. For example a socket file descriptor - one atom opens it, 
> another one reads from it, a third one closes it. By having the 
> parameters in the atoms we'd have to copy the fd to two other places.

Yes, of course we have to support the indirection, otherwise chaining 
won't work. But ...



> > I can understand that chaining syscalls requires variable sharing, but 
> > the majority of the parameters passed to syscalls are just direct 
> > ones. Maybe a smart method that allows you to know if a parameter is a 
> > direct one or a pointer to one? An "unsigned int pmap" where bit N is 
> > 1 if param N is an indirection? Hmm?
> 
> adding such things tends to slow down atom parsing.

I really think it simplifies it. You simply *copy* the parameter (I'd say 
that 70+% of cases falls inside here), and if the current "pmap" bit is 
set, then you do all the indirection copy-from-userspace stuff.
It also simplify userspace a lot, since you can now pass arrays and 
structure pointers directly, w/out saving them in a temporary variable.




> > Sigh, I really dislike shared userspace/kernel stuff, when we're 
> > transfering pointers to userspace. Did you actually bench it against 
> > a:
> > 
> > int async_wait(struct syslet_uatom **r, int n);
> > 
> > I can fully understand sharing userspace buffers with the kernel, if 
> > we're talking about KB transferd during a block or net I/O DMA 
> > operation, but for transfering a pointer? Behind each pointer 
> > transfer(4/8 bytes) there is a whole syscall execution, [...]
> 
> there are three main reasons for this choice:
> 
> - firstly, by putting completion events into the user-space ringbuffer
>   the asynchronous contexts are not held up at all, and the threads are
>   available for further syslet use.
> 
> - secondly, it was the most obvious and simplest solution to me - it 
>   just fits well into the syslet model - which is an execution concept 
>   centered around pure user-space memory and system calls, not some 
>   kernel resource. Kernel fills in the ringbuffer, user-space clears it. 
>   If we had to worry about a handshake between user-space and 
>   kernel-space for the completion information to be passed along, that 
>   would either mean extra buffering or extra overhead. Extra buffering 
>   (in the kernel) would be for no good reason: why not buffer it in the 
>   place where the information is destined for in the first place. The 
>   ringbuffer of /pointers/ is what makes this really powerful. I never 
>   really liked the AIO/etc. method /event buffer/ rings. With syslets 
>   the 'cookie' is the pointer to the syslet atom itself. It doesnt get 
>   any more straightforward than that i believe.
> 
> - making 'is there more stuff for me to work on' a simple instruction in
>   user-space makes it a no-brainer for user-space to promptly and
>   without thinking complete events. It's also the right thing to do on 
>   SMP: if one core is solely dedicated to the asynchronous workload,
>   only running on kernel mode, and the other code is only running
>   user-space, why ever switch between protection domains? [except if any
>   of them is idle] The fastest completion signalling method is the
>   /memory bus/, not an interrupt. User-space could in theory even use
>   MWAIT (in user-space!) to wait for the other core to complete stuff. 
>   That makes for a hell of a fast wakeup.

That makes also for a hell ugly retrieval API IMO ;)
If it'd be backed up but considerable performance gains, then it might be OK.
But I believe it won't be the case, and that leave us with an ugly API.
OTOH, if noone else object this, it means that I'm the only wierdo :) and 
the API is just fine.




- Davide


