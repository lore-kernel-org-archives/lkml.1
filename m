Return-Path: <linux-kernel-owner+w=401wt.eu-S1030422AbXBZSib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030422AbXBZSib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030424AbXBZSib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:38:31 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49109 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030420AbXBZSia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:38:30 -0500
Date: Mon, 26 Feb 2007 21:32:27 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226183227.GE22454@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 21:33:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 09:57:00AM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> Similarly, even for a simple "read()" on a filesystem, there is no way to 
> just say "block until data is available" like there is for a socket, 
> because on a filesystem, the data may be available, BUT AT THE WRONG 
> OFFSET. So while a socket or a pipe are both simple "streaming interfaces" 
> as far as a "read()" is concerned, a file access is *not* a simple 
> streaming interface.
> 
> Notice? For a read()/recvmsg() call on a socket or a pipe, there is no 
> "position" involved. The "event" is clear: it's always the head of the 
> streaming interface that is relevant, and the event is "is there room" or 
> "is there data". It's an event-based thing.
> 
> But for a read() on a file, it's no longer a streaming interface, and 
> there is no longer a simple "is there data" event. You'd have to make the 
> event be a much more complex "is there data at position X through Y" kind 
> of thing.
> 
> And "read()" on a filesystem is the _simple_ case. Sure, we could add 
> support for those kinds of ranges, and have an event interface for that. 
> But the "open a filename" is much more complicated, and doesn't even have 
> a file descriptor available to it (since we're trying to _create_ one), so 
> you'd have to do something even more complex to have the event "that 
> filename can now be opened without blocking".
> 
> See? Even if you could make those kinds of events, it would be absolutely 
> HORRIBLE to code for. And it would suck horribly performance-wise for most 
> code too.

I see our main discussion trouble I think.

I never ever tried to say, that every bit in read() should be
non-blocking, it would be even more stupid than you expect it to be.
But you and Ingo do not want to see, what I'm trying to say, because it
is too cozy to read own right ideas than others.

I want to say, that read() consists of tons of events, but programmer
needs only one - data is ready in requested buffer. Programmer might
not even know what is the object behind provided file descriptor.
One only wans data in the buffer.

That is an event.

It is also possible to have other events inside complex read() machinery
- for example waiting for page obtained via ->readpages().

> THAT is what I'm saying. There's a *difference* between event-based and 
> thread-based programming. It makes no sense to try to turn one into the 
> other. But it often makes sense to *combine* the two approaches.

Thread is simple just because there is an interface.
Change interface, and no one will ever want to do it.

Provide nice aio_read() (forget about posix) and everyone will use it.

I always said that combining of such models is a must, I fully agree,
but it seems that we still do not agree where the bound should be drawn.

> > Userspace wants to open a file, so it needs some file-related (inode,
> > direntry and others) structures in the mem, they should be read from
> > disk. Eventually it will be reading some blocks from the disk 
> > (for example ext3_lookup->ext3_find_entry->ext3_getblk/ll_rw_block) and
> > we will wait for them (wait_on_bit()) - we will wait for event.
> > 
> > But I agree, it was a brainfscking example, but nevertheless, it can be
> > easily done using event driven model.
> > 
> > Reading from the disk is _exactly_ the same - the same waiting for
> > buffer_heads/pages, and (since it is bigger) it can be easily
> > transferred to event driven model.
> > Ugh, wait, it not only _can_ be transferred, it is already done in
> > kevent AIO, and it shows faster speeds (though I only tested sending
> > them over the net).
> 
> It would be absolutely horrible to program for. Try anything more complex 
> than read/write (which is the simplest case, but even that is nasty).
> 
> Try imagining yourself in the shoes of a database server (or just about 
> anything else). Imagine what kind of code you want to write. You probably 
> do *not* want to have everything be one big event loop, and having to make 
> different "states" for "I'm trying to open the file", "I opened the file, 
> am now doing 'fstat()' to figure out how big it is", "I'm now reading the 
> file and have read X bytes of the total Y bytes I want to read", "I took a 
> page fault in the middle" etc etc.
> 
> I pretty much can *guarantee* you that you'll never see anybody do that. 
> Page faults in user space are particularly hard to handle in a state 
> machine, since they basically require saving the whole thread state, as 
> they can happen on any random access. So yeah, you could do them as a 
> state machine, but in reality it would just become a "user-level thread 
> library" in the end, just to handle those.
>
> In contrast, if you start using thread-like programming to begin with, you 
> have none of those issues. Sure, some thread may block because you got a 
> page fault, or because an inode needed to be brought into memory, but from 
> a user-level programming interface standpoint, the thread library just 
> takes care of the "state machine" on its own, so it's much simpler, and in 
> the end more efficient.
> 
> And *THAT* is what I'm trying to say. Some simple obvious events are 
> better handled and seen as "events" in user space. But other things are so 
> intertwined, and have basically random state associated with them, that 
> they are better seen as threads.

In threading you still need to do exactly the same, since stat() can
not be done before open(). So you will maintain some state (actually
order of things which will not be changed).
Have the same in the function.

Then start execution - it can be perfectly done using threads.

Just because it is unconvenient to program using state machines and
there is no appropriate interface.

But there are another operations.
Consider database or whatever you like, which wants to read thousands of
blocks from disk, each access potentially blocks, and blocking on the
mutex is nothing compared to blocking on waiting for storage to be ready
to provide data (network, disk, whatever). If storage is not optimized
(or small cache, or something else) we end up with blocked contexts,
which sleep - thousands of contexts.
And this number will not decrease.

So we ended with enourmous overhead just because we do not have simple
enough aio_read() and aio_wait().

> Yes, from a "turing machine" kind of viewpoint, the two are 100% logically 
> equivalent. But "logical equivalence" does NOT translate into "can 
> practically speaking be implemented".

You have said that finally!
"can practically speaking be implemented".

I see your and Ingo point - kevent is a 'merde' (pardon my french, but I
even somehow glad Ingo said (almost) that - I now have plenty of time for other
interesting projects), we want threads. 
Ok, you have threads, but you need to wait on (some of) them.
So you will invent the wheel again - some subsystem which will wait for
threads (likely waiting on futexes), then other events (probably).
Eventually it will be the same from different point of view :)

Anyway, I _do_ hope we understood each other that both events and
threads can co-exist, although board was not drawn.

My point is that many things can be done using event just because they
are faster and smaller - and IO (any IO without limit) is one of the
areas where it is unbeatable.
Threading in turn can be done a higher-layer abstraction model - thread
can wrap around the whole transaction with all related data flows, but
not thread per IO.

> 			Linus

-- 
	Evgeniy Polyakov
