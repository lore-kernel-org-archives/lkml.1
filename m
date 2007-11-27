Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXK0CPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXK0CPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXK0CPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:15:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbXK0CPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:15:43 -0500
Date: Mon, 26 Nov 2007 18:14:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
In-Reply-To: <474B1C6D.6080405@zytor.com>
Message-ID: <alpine.LFD.0.9999.0711261801390.5869@woody.linux-foundation.org>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org>
 <474B1C6D.6080405@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Nov 2007, H. Peter Anvin wrote:
> 
> I'm presuming you're not talking about some sort of syslets/fibrils/threadlets
> here (executing an interpreted thread of execution in kernel space).  That's a
> whole separate ball of wax.

Indeed. 

I'm hoping that just dies. It's too complex. But the "do this single 
system call asynchronously" isn't, and has lots of historical 
implementations, ranging from VMS to the braindead POSIX "aio" setup.

I do think that more complex threadlets could be useful in theory, I just 
doubt they'd be used in practice..

> > So the choice is basically one of:
> > 
> >  - come up with a totally new interface to system calls, and effectively
> > duplicating the whole system call table.
> > 
> >    I'd hate to do this. We already have duplicated system call tables due
> > to compat stuff, it's painful.
> 
> This would be the right thing to do if we were to redesign the system call
> interface from the ground up, which it doesn't exactly sound like we are
> intending.

Yeah. I'm also not sure it's the right thing even if we did redesign from 
scratch.

The current system call interface may look less than regular, but it has 
some very solid foundation: it's fast. Passing arguments in registers is 
by definition a lot faster *and*safer* than passing them any other way. 
There are no subtle security issues with people playing games with the 
argument base pointer (ie usually the stack pointer) and trying to fool 
the kernel into accessing kernel memory etc.

Immediately when you do anything but registers, it is much *much* more 
costly. The "get_user()" and "copy_from_user()" stuff is not exactly slow, 
but it's quite noticeable overhead for simple system calls. It gets worse 
if this all is described by some indirect table setup.

In the system call path, right now, for some system calls, the biggest two 
overheads are

 - the CPU system call overhead itself. We can't do much about this, but 
   the CPU designers do seem to be slowly getting it fixed (ie it's slower 
   than it should need to be, but it's a hell of a lot faster than a P4 
   used to be ;)

 - the cost of just the single indirect - and unpredictable - call.

(The second cost is actually often totally hidden in the trivial system 
call benchmarks people run: if the benchmark just does "getppid()" a 
million times in a tight loop, the indirect call on the system call number 
seems really quite fast, but outside of benchmarks it is generally totally 
unpredictable indeed, and a real cost for real-life system call usage).

Everything else in the system call path is generally as fast as we can 
make it. Doing more indirection and conditionals would be really quite 
nasty.

Of course, for *most* of system calls, the work the kernel actually does 
ends up being so big that it doesn't much matter, but I was literally 
chasing down why a page fault had slowed down by ~70 cycles two weeks ago. 
And it doesn't take more than a couple of unpredictable jumps to do things 
like that!

> The 6-word limit is a red herring.  There is at least two ways to deal with it
> (and this doesn't mean wiping the legacy stuff we already have):
> 
> - Let each architecture pick a calling convention and redefine the
> architecture-independent bits to take an arbitrary number of arguments.  This
> is a one-time panarchitectural change.

Not applicable on x86-32.

The six-word limit is effectively a hardware limit there. Once it goes 
past that limit, one of the words needs to be a pointer to extended 
information that is fundamentally slower to access. Happily, only very 
rare system calls do that (and none of them are of the simple variety 
where we see a few cycles easily).

On other architectures, we could more easily just use more registers. But 
x86-32 is still a big part (bulk) of what matters for most people.

			Linus
