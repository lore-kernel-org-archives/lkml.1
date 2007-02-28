Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbXB1DDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbXB1DDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 22:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXB1DDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 22:03:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:25748 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXB1DDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 22:03:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E8apLA30/MZUiaad178CB4q4qgrICa5luFt5IRXUT91lH7V5H8dYeSdJr942GQHPtF+4X9s9olz6gpr5jDqc8GFdMVjJNSVMrT7smHp4tO7WBL6mit8wjp8R1WNpR0KLz7vINRwuhjXnuXwxUXFB64JOc29p+bWLEB6MFxkVWDo=
Message-ID: <f2b55d220702271903o6bc418efu7d72a564a7ade365@mail.gmail.com>
Date: Tue, 27 Feb 2007 19:03:21 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070227115221.GJ8154@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu>
	 <20070222113148.GA3781@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
	 <20070226172812.GC22454@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
	 <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru>
	 <20070227115221.GJ8154@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Theodore Tso <tytso@mit.edu> wrote:
> I think what you are not hearing, and what everyone else is saying
> (INCLUDING Linus), is that for most programmers, state machines are
> much, much harder to program, understand, and debug compared to
> multi-threaded code.  You may disagree (were you a MacOS 9 programmer
> in another life?), and it may not even be true for you if you happen
> to be one of those folks more at home with Scheme continuations, for
> example.  But it is true that for most kernel programmers, threaded
> programming is much easier to understand, and we need to engineer the
> kernel for what will be maintainable for the majority of the kernel
> development community.

State machines are much harder to write without going through a real
on-paper design phase first.  But multi-threaded code is much harder
for a team of average working coders to write correctly, judging from
the numerous train wrecks that I've been called in to salvage over the
last ten years or so.

The typical 50-250KLoC multi-threaded C/C++/Java application, even if
it's been shipping to customers for several years, is littered with
locking constructs yet routinely corrupts shared data structures.
Change the number of threads in a pool, adjust the thread priorities,
or move a couple of lines of code around, and you're very likely to
get an unexplained deadlock.  God help you if you try to use a
debugger on it -- hundreds of latent race conditions will crop up that
didn't happen to trigger before because the thread didn't get
preempted there.

The only programming languages that I have seen widely used in US
industry (so Lisps and self-consciously functional languages are out)
in which mere mortals write passable multi-threaded applications are
Visual Basic and Python.  That's partly because programmers in these
languages are not in the habit of throwing pointers around; but if
that were all there was to it, Java programmers would be a lot more
successful than they are at actually writing threaded programs rather
than nibbling cautiously around the edges with EJB.  It also helps a
lot that strings are immutable; but again, Java shares this property.
No, the big difference is that VB and Python dicts and arrays are
thread-safed by the language runtime, and Java collections are not.
So while there may be all sorts of pointless and dangerous
mis-locking, it's "protecting" somewhat higher-level data structures.

What does this have to do with the kernel?  Well, if you're going to
create Yet Another Micro^WLightweight-Threading Construct for AIO, it
would be mighty nice not to be slinging bare pointers around until the
IO is actually complete and the kernel isn't going to be touching the
data buffer any more.  It would also be mighty nice to have a
thread-safe "request pool" data structure on which actions like bulk
cancellation and iteration over a subset can operate.  (The iterator
returned by, say, a three-sided query on a RCU priority queue may
contain _stale_ information, but never _inconsistent_ information.)

I recognize that this is more object-oriented snake oil than kernel
programmers usually tolerate, but it would really help AIO-threaded
programs suck less.  It is also very much in the Unix tradition --
what are file descriptors and fd_sets if not object-oriented design?
And if following the socket model was good enough for epoll and
netlink, why not for threadlet pools?

In the best of all possible worlds, AIO would look just like the good
old socket-bind-listen-accept model, except that I/O is transacted on
the "listen" socket as long as it can be serviced from cache, and
accept() only gets a new connection when a delayed I/O arrives.  The
object hiding inside the fd returned by socket() would be the
"threadlet pool", and the object hiding inside each fd returned by
accept() would be a threadlet.  Only this time you do it right and
make errno(fd) be a vsyscall that returns a threadlet-local error
state, and you assign reasonable semantics to operations on an fd that
has already encountered an exception.  Much like IEEE 754, actually.

Anyway, like I said, good threaded code is quite rare.  On the other
hand, I have seen plenty of reasonably successful event-loop
programming in C and C++, mostly in MacOS and Windows and PalmOS GUIs
where the OS deals with event queues and event handler registration.
It's not the world's most CPU-efficient strategy because of all those
function pointers and virtual methods, but those costs are dwarfed by
the GUI bounding boxes and repaints and things anyway.  More to the
point, writing an event-loop framework for other people to use
involves extensive APIs that are stable in the tiniest details and
extensively documented.  Not, perhaps, Plan A for the Linux kernel
community.  :-)

Happily, a largely event-driven userspace framework can easily be
stacked on top of a threaded kernel -- as long as they're the right
kind of threads.  The right kind of threads do not proliferate malloc
arenas by allowing preemption in mid-malloc.  (They may need to
malloc(), and that may be a preemption point relative to _real_
threads, but you shouldn't switch or cancel threadlets there.)  The
right kind of threads do not leak locking primitives when cancelled,
because they don't have to take a lock in order to update the right
kind of data structure.  The right kind of threads can use floating
point safely as long as they don't expect FPU state to be preserved
across a syscall.

The right kind of threads, in short, work like coroutines or
MacOS/PalmOS "event handlers", with the added convenience of being
able to write them as if they were normal sequential code, with normal
access to a persistent stack frame and to process globals.  And if you
do them right, they're cheap to migrate, easy and harmless to throttle
and cancel in bulk, and easy to punt out to an "I/O coprocessor" in
the future.  The key is to move data into and out of the "I/O
registers" at well-defined points and not to break the encapsulation
in between.  Delay the extraction of results from the "I/O registers"
as long as possible, and the hypothetical AIO coprocessor can go chew
on them in parallel with the main "integer" code flow, which only
stalls when it can't go any further without the I/O result.

If you've got some time to kill, you can even analyze an existing,
well-documented flavor of I/O strings (I like James Antill's Vstr
library myself) and define a set of "AIO opcodes" that manipulate AIO
fds and AIO strings as primitive types, just like the FPU manipulates
floating-point numbers as primitive types.  Pick a CPU architecture
with a good range of unused trap opcodes (PPC, for instance) and
actually move the I/O strings into kernel space, mapping the AIO
operations and the I/O string API onto the free trap opcodes (really
no different from syscalls, except it's easier to inspect the assembly
that the compiler produces and see what's going on).  For extra
credit, implement most of the AIO opcodes in Verilog, bolt them onto
the PPC core inside a Virtex4 FX FPGA, refine the semantics to permit
efficient pipelining, and collect your Turing award.  :-)

Cheers,
- Michael
