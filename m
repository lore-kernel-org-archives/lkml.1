Return-Path: <linux-kernel-owner+w=401wt.eu-S1030360AbXBZRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360AbXBZRei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030364AbXBZRei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:34:38 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35137 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030360AbXBZReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:34:37 -0500
Date: Mon, 26 Feb 2007 20:28:13 +0300
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
Message-ID: <20070226172812.GC22454@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 20:29:12 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 02:44:11PM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Thu, 22 Feb 2007, Evgeniy Polyakov wrote:
> > 
> > My tests show that with 4k connections per second (8k concurrency) more 
> > than 20k connections of 80k total block in tcp_sendmsg() over gigabit 
> > lan between quite fast machines.
> 
> Why do people *keep* taking this up as an issue?

Let's warm our brains a little in this pseudo-technical word throwings :)

> Use select/poll/epoll/kevent/whatever for event mechanisms. STOP CLAIMING 
> that you'd use threadlets/syslets/aio for that. It's been pointed out over 
> and over and over again, and yet you continue to make the same mistake, 
> Evgeniy.
>
> So please read that sentence ten times, and then don't continue to make 
> that same mistake. PLEASE.
> 
> Event mechanisms are *superior* for events. But they *suck* for things 
> that aren't events, but are actual code execution with random places that 
> can block. THE TWO THINGS ARE TOTALLY AND UTTERLY INDEPENDENT!
> 
> Examples of events:
>  - packet arrives
>  - timer happens
> 
> Examples of things that are *not* "events":
>  - filesystem lookup.
>  - page faults
> 
> So the basic point is: for events, you use an event-based thing. For code 
> execution, you use a thread-based thing. It's really that simple.

Linus, you made your point clearly - generic AIO should not be used for
the cases, when it is supposed to block 90% of the time - only when it
almost never blocks, like in case of buffered IO.
Otherwise, when load nature requires almost always to block, we would
see that each block is eventually removed - by something, which calls
wake_up(), that something is an event, which we were supposed to wait,
but instead we we resceduled and waited there, so we just added
additional layer of dereferencing - we were scehduled away, did some
work, then awakened, instead of doing some work and get event.

I do not even discuss, that micro-threading model is way tooo simpler to
programm, but from above example is clear that it adds additional
overhead, which in turn can be high or noticeble.

> And yes, the two different things can usually be translated (at a very 
> high cost in complexity *and* performance) into each other, so people who 
> look at it as purely a theoretical exercise may think that "events" and 
> "code execution" are equivalent. That's a very very silly and stupid way 
> of looking at things in real life, though.
> 
> Yes, you can turn things that are better seen as threaded execution into 
> an event-based thing by turning it into a state machine. And usually that 
> is a TOTAL DISASTER, and the end result is fragile and impossible to 
> maintain.
> 
> And yes, you can often (more easily) turn an event-based mechanism into a 
> thread-based one, and usually the end result is a TOTAL DISASTER because 
> it doesn't scale very well, and while it may actually result in somewhat 
> simpler code, the overhead of managing ten thousand outstanding threads is 
> just too high, when you compare to managing just a list of ten thousand 
> outstanding events.
>
> And yes, people have done both of those mistakes. Java, for example, 
> largely did the latter mistake ("we don't need anything like 'select', 
> because we'll just use threads for everything" - what a totally moronic 
> thing to do!)

I can only say that I'm fully agree. Absolutely. No jokes.

> So Evgeniy, threadlets/syslets/aio is *not* a replacement for event 
> queues. It's a TOTALLY DIFFERENT MECHANISM, and one that is hugely 
> superior to event queues for certain kinds of things. Anybody who thinks 
> they want to do pathname and inode lookup as a series of events is likely 
> a moron. It's really that simple.

Hmmm... let me describe that process a bit:

Userspace wants to open a file, so it needs some file-related (inode,
direntry and others) structures in the mem, they should be read from
disk. Eventually it will be reading some blocks from the disk 
(for example ext3_lookup->ext3_find_entry->ext3_getblk/ll_rw_block) and
we will wait for them (wait_on_bit()) - we will wait for event.

But I agree, it was a brainfscking example, but nevertheless, it can be
easily done using event driven model.

Reading from the disk is _exactly_ the same - the same waiting for
buffer_heads/pages, and (since it is bigger) it can be easily
transferred to event driven model.
Ugh, wait, it not only _can_ be transferred, it is already done in
kevent AIO, and it shows faster speeds (though I only tested sending
them over the net).

> In a complex server (say, a database), you'd use both. You'd probably use 
> events for doing the things you *already* use events for (whether it be 
> select/poll/epoll or whatever): probably things like the client network 
> connection handling.
> 
> But you'd *in*addition* use threadlets to be able to do the actual 
> database IO in a threaded manner, so that you can scale the things that 
> are not easily handled as events (usually because they have internal 
> kernel state that the user cannot even see, and *must*not* see because of 
> security issues).

Event is data readiness - no more, no less.
It has nothing with internal kernel structures - you just wait until
data is ready in requested buffer (disk, net, whatever).
Internal mechanism of moving data to the destination point can use event
driven model too, but it is another question.

Eventually threads wait for the same events - but there is an additional
overhead created to manage that objects called threads.
Ingo says that it is fast to manage them, but it can not be faster than
properly created event driven abstraction, because, as you noticed
himself, mutual transformations are complex.

Threadlets are simpler to program, but they do not add a gain compared
to properly created singlethreaded model (or number of CPU-threadede
model) with the right event processing mechanims.

Waiting for any IO is a waiting for event, other tasks can be made an
event too, but I agree, it is simpler to use different models just
because they already exist.

> So please. Stop this "kevents are better". The only thing you show by 
> trying to go down that avenue is that you don't understand the 
> *difference* between an event model and a thread model. They are both 
> perfectly fine models and they ARE NOT THE SAME! They aren't even mutually 
> incompatible - quite the reverse.
> 
> The thing people want to remove with threadlets is the internal overhead 
> of maintaining special-purpose code like aio_read() inside the kernel, 
> that doesn't even do all that people want it to do, and that really does 
> need a fair amount of internal complexity that we could hopefully do with 
> a more generic (and hopefully *simpler*) model.

Let me rephrase that stuff:

the thing people want to remove with linked lists is the internal
overhead of maintaing special-purpose code like RB trees.

It sounds with similar part of idiocity in it.

If additional code provides faster processing, it must be used instead of
fear of 'the internal overhead of maintaining special-purpose code'.

> 		Linus

-- 
	Evgeniy Polyakov
