Return-Path: <linux-kernel-owner+w=401wt.eu-S1030375AbXBZR6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375AbXBZR6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030382AbXBZR6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:58:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55237 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030375AbXBZR6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:58:30 -0500
Date: Mon, 26 Feb 2007 09:57:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070226172812.GC22454@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
 <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
 <20070226172812.GC22454@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Evgeniy Polyakov wrote:
> 
> Linus, you made your point clearly - generic AIO should not be used for
> the cases, when it is supposed to block 90% of the time - only when it
> almost never blocks, like in case of buffered IO.

I don't think it's quite that simple.

EVEN *IF* it were to block 100% of the time, it depends on other things 
than just "blockingness".

For example, let's look at something like

	fd = open(filename, O_RDONLY);
	if (fd < 0)
		return -1;
	if (fstat(fd, &st) < 0) {
		close(fd);
		return -1;
	}
	.. do something ..

and please realize that EVEN IF YOU KNOW WITH 100% CERTAINTY that the 
above open (or fstat()) is going to block, because you know that your 
working set is bigger than the available memory for caching, YOU SIMPLY 
CANNOT SANELY WRITE THAT AS AN EVENT-BASED STATE MACHINE!

It's really that simple. Some things block "in the middle". The reason 
UNIX made non-blocking reads available for networking, but not for 
filesystem accesses is not because one blocks and the other doesn't. No, 
it's really much more fundamental than that!

When you do a "recvmsg()", there is a clear event-based model: you can 
return -EAGAIN if the data simply isn't there, because a network 
connection is a simple stream of data, and there is a clear event on "ok, 
data arrived" without any state what-so-ever.

The same is simply not true for "open a file descriptor". There is no sane 
way to turn the "filename lookup blocked" into an event model with a 
select- or kevent-based interface.

Similarly, even for a simple "read()" on a filesystem, there is no way to 
just say "block until data is available" like there is for a socket, 
because on a filesystem, the data may be available, BUT AT THE WRONG 
OFFSET. So while a socket or a pipe are both simple "streaming interfaces" 
as far as a "read()" is concerned, a file access is *not* a simple 
streaming interface.

Notice? For a read()/recvmsg() call on a socket or a pipe, there is no 
"position" involved. The "event" is clear: it's always the head of the 
streaming interface that is relevant, and the event is "is there room" or 
"is there data". It's an event-based thing.

But for a read() on a file, it's no longer a streaming interface, and 
there is no longer a simple "is there data" event. You'd have to make the 
event be a much more complex "is there data at position X through Y" kind 
of thing.

And "read()" on a filesystem is the _simple_ case. Sure, we could add 
support for those kinds of ranges, and have an event interface for that. 
But the "open a filename" is much more complicated, and doesn't even have 
a file descriptor available to it (since we're trying to _create_ one), so 
you'd have to do something even more complex to have the event "that 
filename can now be opened without blocking".

See? Even if you could make those kinds of events, it would be absolutely 
HORRIBLE to code for. And it would suck horribly performance-wise for most 
code too.

THAT is what I'm saying. There's a *difference* between event-based and 
thread-based programming. It makes no sense to try to turn one into the 
other. But it often makes sense to *combine* the two approaches.

> Userspace wants to open a file, so it needs some file-related (inode,
> direntry and others) structures in the mem, they should be read from
> disk. Eventually it will be reading some blocks from the disk 
> (for example ext3_lookup->ext3_find_entry->ext3_getblk/ll_rw_block) and
> we will wait for them (wait_on_bit()) - we will wait for event.
> 
> But I agree, it was a brainfscking example, but nevertheless, it can be
> easily done using event driven model.
> 
> Reading from the disk is _exactly_ the same - the same waiting for
> buffer_heads/pages, and (since it is bigger) it can be easily
> transferred to event driven model.
> Ugh, wait, it not only _can_ be transferred, it is already done in
> kevent AIO, and it shows faster speeds (though I only tested sending
> them over the net).

It would be absolutely horrible to program for. Try anything more complex 
than read/write (which is the simplest case, but even that is nasty).

Try imagining yourself in the shoes of a database server (or just about 
anything else). Imagine what kind of code you want to write. You probably 
do *not* want to have everything be one big event loop, and having to make 
different "states" for "I'm trying to open the file", "I opened the file, 
am now doing 'fstat()' to figure out how big it is", "I'm now reading the 
file and have read X bytes of the total Y bytes I want to read", "I took a 
page fault in the middle" etc etc.

I pretty much can *guarantee* you that you'll never see anybody do that. 
Page faults in user space are particularly hard to handle in a state 
machine, since they basically require saving the whole thread state, as 
they can happen on any random access. So yeah, you could do them as a 
state machine, but in reality it would just become a "user-level thread 
library" in the end, just to handle those.

In contrast, if you start using thread-like programming to begin with, you 
have none of those issues. Sure, some thread may block because you got a 
page fault, or because an inode needed to be brought into memory, but from 
a user-level programming interface standpoint, the thread library just 
takes care of the "state machine" on its own, so it's much simpler, and in 
the end more efficient.

And *THAT* is what I'm trying to say. Some simple obvious events are 
better handled and seen as "events" in user space. But other things are so 
intertwined, and have basically random state associated with them, that 
they are better seen as threads.

Yes, from a "turing machine" kind of viewpoint, the two are 100% logically 
equivalent. But "logical equivalence" does NOT translate into "can 
practically speaking be implemented".

			Linus
