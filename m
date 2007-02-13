Return-Path: <linux-kernel-owner+w=401wt.eu-S1751092AbXBMVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbXBMVgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXBMVgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:36:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41213 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbXBMVgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:36:44 -0500
Date: Tue, 13 Feb 2007 22:34:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Message-ID: <20070213213422.GA22104@elte.hu>
References: <20070213142042.GG638@elte.hu> <Pine.LNX.4.64.0702131117120.32055@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702131117120.32055@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > +The Syslet Atom:
> > +----------------
> > +
> > +The syslet atom is a small, fixed-size (44 bytes on 32-bit) piece of
> > +user-space memory, which is the basic unit of execution within the syslet
> > +framework. A syslet represents a single system-call and its arguments.
> > +In addition it also has condition flags attached to it that allows the
> > +construction of larger programs (syslets) from these atoms.
> > +
> > +Arguments to the system call are implemented via pointers to arguments.
> > +This not only increases the flexibility of syslet atoms (multiple syslets
> > +can share the same variable for example), but is also an optimization:
> > +copy_uatom() will only fetch syscall parameters up until the point it
> > +meets the first NULL pointer. 50% of all syscalls have 2 or less
> > +parameters (and 90% of all syscalls have 4 or less parameters).
> 
> Why do you need to have an extra memory indirection per parameter in 
> copy_uatom()? [...]

yes. Try to use them in real programs, and you'll see that most of the 
time the variable an atom wants to access should also be accessed by 
other atoms. For example a socket file descriptor - one atom opens it, 
another one reads from it, a third one closes it. By having the 
parameters in the atoms we'd have to copy the fd to two other places.

but i see your point: i actually had it like that in my earlier 
versions, only changed it to an indirect method later on, when writing 
more complex syslets. And, surprisingly, performance of atom handling 
/improved/ on both Intel and AMD CPUs when i added indirection, because 
the indirection enables the 'tail NULL' optimization. (which wasnt the 
goal of indirection, it was just a side-effect)

> [...] It also forces you to have parameters pointed-to, to be "long" 
> (or pointers), instead of their natural POSIX type (like fd being 
> "int" for example). [...]

this wasnt a big problem while coding syslets. I'd also not expect 
application writers having to do these things on the syscall level - 
this is a system interface after all. But you do have a point.

> I can understand that chaining syscalls requires variable sharing, but 
> the majority of the parameters passed to syscalls are just direct 
> ones. Maybe a smart method that allows you to know if a parameter is a 
> direct one or a pointer to one? An "unsigned int pmap" where bit N is 
> 1 if param N is an indirection? Hmm?

adding such things tends to slow down atom parsing.

there's another reason as well: i wanted syslets to be like 
'instructions' - i.e. not self-modifying. If the fd parameter is 
embedded in the syslet then every syslet has to be replicated

note that chaining does not necessarily require variable sharing: a 
sys_umem_add() atom could be used to modify the next syslet's ->fd 
parameter. So for example

	sys_open() -> returns 'fd'
        sys_umem_add(&atom1->fd) <= atom1->fd is 0 initially
        sys_umem_add(&atom2->fd) <= the first umem_add returns the value
        atom1 [uses fd]
        atom2 [uses fd]

but i didnt like this approach: this means 1 more atom per indirect 
parameter, and quite some trickery to put the right information into the 
right place. Furthermore, this makes syslets very much tied to the 
'register contents' - instead of them being 'pure instructions/code'.

> > +Completion of asynchronous syslets:
> > +-----------------------------------
> > +
> > +Completion of asynchronous syslets is done via the 'completion ring',
> > +which is a ringbuffer of syslet atom pointers user user-space memory,
> > +provided by user-space in the sys_async_register() syscall. The
> > +kernel fills in the ringbuffer starting at index 0, and user-space
> > +must clear out these pointers. Once the kernel reaches the end of
> > +the ring it wraps back to index 0. The kernel will not overwrite
> > +non-NULL pointers (but will return an error), user-space has to
> > +make sure it completes all events it asked for.
> 
> Sigh, I really dislike shared userspace/kernel stuff, when we're 
> transfering pointers to userspace. Did you actually bench it against 
> a:
> 
> int async_wait(struct syslet_uatom **r, int n);
> 
> I can fully understand sharing userspace buffers with the kernel, if 
> we're talking about KB transferd during a block or net I/O DMA 
> operation, but for transfering a pointer? Behind each pointer 
> transfer(4/8 bytes) there is a whole syscall execution, [...]

there are three main reasons for this choice:

- firstly, by putting completion events into the user-space ringbuffer
  the asynchronous contexts are not held up at all, and the threads are
  available for further syslet use.

- secondly, it was the most obvious and simplest solution to me - it 
  just fits well into the syslet model - which is an execution concept 
  centered around pure user-space memory and system calls, not some 
  kernel resource. Kernel fills in the ringbuffer, user-space clears it. 
  If we had to worry about a handshake between user-space and 
  kernel-space for the completion information to be passed along, that 
  would either mean extra buffering or extra overhead. Extra buffering 
  (in the kernel) would be for no good reason: why not buffer it in the 
  place where the information is destined for in the first place. The 
  ringbuffer of /pointers/ is what makes this really powerful. I never 
  really liked the AIO/etc. method /event buffer/ rings. With syslets 
  the 'cookie' is the pointer to the syslet atom itself. It doesnt get 
  any more straightforward than that i believe.

- making 'is there more stuff for me to work on' a simple instruction in
  user-space makes it a no-brainer for user-space to promptly and
  without thinking complete events. It's also the right thing to do on 
  SMP: if one core is solely dedicated to the asynchronous workload,
  only running on kernel mode, and the other code is only running
  user-space, why ever switch between protection domains? [except if any
  of them is idle] The fastest completion signalling method is the
  /memory bus/, not an interrupt. User-space could in theory even use
  MWAIT (in user-space!) to wait for the other core to complete stuff. 
  That makes for a hell of a fast wakeup.

	Ingo
