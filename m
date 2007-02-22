Return-Path: <linux-kernel-owner+w=401wt.eu-S1945950AbXBVI7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945950AbXBVI7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945953AbXBVI7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:59:15 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:46439 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945950AbXBVI7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lpvx4i/V1tQRsHy4WfsUJYUFBG000gGEM54/3bESGKzSJ4Onuffgnr+GppMYbmdp2r7Y4HR69SqXRRkOYq0dpYU4XCcT3NwOU691kARqJx0PWAvE9NwM9GmNUM6l6fjcx57abFcXn6c84lR01+2H2BRbCH9Cn9XBKwxVcrZ7PSM=
Message-ID: <f2b55d220702220059t7487a0a4mbe88b91dc033de4b@mail.gmail.com>
Date: Thu, 22 Feb 2007 00:59:10 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070222065125.GA862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221225711.GB32031@elte.hu>
	 <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com>
	 <20070222065125.GA862@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> > [...] As for threadlets, making them kernel threads is not such a good
> > design feature, O(1) scheduler or not.  You take the full hit of
> > kernel task creation, on the spot, for every threadlet that blocks.
> > [...]
>
> this is very much not how they work. Threadlets share the same basic
> infrastructure with syslets and they do /not/ take a 'full hit of kernel
> thread creation' when they block. Please read the announcements, past
> discussions on lkml and the code about how it works.

Sorry, you're right, I jumped to a conclusion here without reading the
implementation.  I read too much into your statement that "threadlets,
when they block, are regular kernel threads".  So tell me, at what
stage is NPTL going to need a new TLS context for errno and all that?
Immediately when the threadlet first blocks, right?  At most you can
delay the bulk page copies with CoW MMU tricks (about which I cannot
begin to match your knowledge).  But you can't let any code run that
might touch errno -- or FPU state or anything else you need to
preserve for when you do carry on with the threadlet -- until you've
at least told the hardware to fault on write.

Yes, I will go back and read the code for myself.  This will take me
some time because I have only a hand-waving level of knowledge about
task_structs and pt_regs, and have largely avoided the dark corners of
the x86 architecture.  But I think my point still stands: allowing
code inside threadlets to use the usual C library wrappers around the
usual synchronous syscalls is going to mean that the threadlet context
is fairly heavyweight, both in memory and CPU/MMU state.  This means
that you can't pull it cheaply over to whatever CPU core happened to
process the device I/O that delivered the data it wanted.

If the cost of threadlet migration isn't negligible, then you can't
just write code that initiates a zillion threadlets in a loop -- not
if you want to be able to exploit NUMA or even SMP efficiently.  You
have to distribute the threadlet initiation among parallel threads on
all the CPUs -- at which point you are back where you started, with
the application explicitly partitioned among CPU-locked dispatch
threads.  Any programming team prepared to cope with that is probably
going to stick to the userspace state machine they probably already
have for managing delayed I/O responses.

> syslets are not meant to be directly exposed to application coders.
> Syslets (like many of my previous mails stated) are meant as building
> blocks to higher-level AIO interfaces such as in glibc or libaio. Then
> user-space can build its state-machine based on syslet-implemented
> glibc/libaio. In that specific role they are a very fast and scalable
> mechanism.

With all due respect -- and I know how successful you have been with
major new kernel features in the past -- I think that's a cop-out.
That's like saying that floating point is not meant to be directly
exposed to application coders.  Sure, the details of the floating
point _pipeline_ are essentially opaque; but I don't have to package
up a string of floating point operations into a "floatlet" and send it
off to the FPU.  From the point of view of the integer unit, I move
things into and out of floating point registers, and in between I
issue instructions to the FPU to do arithmetic on its registers.  If
something goes mildly wrong (say, underflow), and I've told the FPU to
carry on under those circumstances, it does.  If something goes bad
wrong, or if underflow happens and I've told the FPU that my code
won't do the right thing on underflow, I get an exception.  That's it.

If the FPU decides to pipeline things, that's not my problem; when I
get to the operation that wants to pull a result back over to the
integer unit, I stall until it's ready.  And in a cleverer, more
tightly interlocked processor that issues some things in parallel and
speculatively executes others, exceptions may not be deliverable until
long after the arithmetic op that produced them (you might not wind up
taking that branch).  Hence other state may have to be rewound so that
the exception is delivered with everything else in the state it would
have been in if the processor weren't so damn clever.

You don't have to invent all that pipelining and migration and
speculative execution stuff up front for AIO.  But if you don't stick
to what is "reasonable and necessary as well as parsimonious" when
defining what's allowed inside a threadlet, you won't leave
implementations any future flexibility.  And "want speed? use syslets
instead" is no answer, especially if you tell me that syslets wrapped
in glibc are only really useful for short-circuiting chained states in
a state machine.  I. Don't. Want. To. Write. State. Machines. Any.
More.

Cheers,
- Michael

Oh, and while I haven't written a kernel or an RDBMS, I have written
some fairly serious non-blocking I/O code (without resorting to
threads; one socket and thousands of independent userspace state
machines) and rewritten the plumbing of two fairly heavy-duty network
operations frameworks, one of them attached to a horrifically complex
GUI.  And briefly, long ago, I made Transputers dance with Occam and
galaxies spin with PVM.  This gives me exactly zero credentials here,
of course, but may suggest to you that when I say something that seems
naive, it's more likely that I got the Linux-specific lingo wrong.
That, or I'm _actively_ stupid.  :-)
