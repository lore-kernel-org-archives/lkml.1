Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbXB0K3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbXB0K3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXB0K3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:29:53 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45044 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXB0K3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:29:52 -0500
Date: Tue, 27 Feb 2007 13:28:32 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070227102832.GC23170@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226195416.GA11188@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 13:28:57 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 08:54:16PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > Reading from the disk is _exactly_ the same - the same waiting for 
> > > buffer_heads/pages, and (since it is bigger) it can be easily 
> > > transferred to event driven model. Ugh, wait, it not only _can_ be 
> > > transferred, it is already done in kevent AIO, and it shows faster 
> > > speeds (though I only tested sending them over the net).
> > 
> > It would be absolutely horrible to program for. Try anything more 
> > complex than read/write (which is the simplest case, but even that is 
> > nasty).
> 
> note that even for something as 'simple and straightforward' as TCP 
> sockets, the 25-50 lines of evserver code i worked on today had 3 
> separate bugs, is known to be fundamentally incorrect and one of the 
> bugs (the lost event problem) showed up as a subtle epoll performance 
> problem and it took me more than an hour to track down. And that matches 
> my Tux experience as well: event based models are horribly hard to debug 
> BECAUSE there is /no procedural state associated with requests/. Hence 
> there is no real /proof of progress/. Not much to use for debugging - 
> except huge logs of execution, which, if one is unlucky (which i often 
> was with Tux) would just make the problem go away.

I'm glad you found a bug in my epoll processing code (which does not exist
in kevent part though) - it took me more than a year after kevent
introduction to make someone to look into.

Obviously there are bugs, it is simply how things work.
And debugging state machine code has exactly the same complexity as
debugging multi-threading code - if not less...

> Furthermore, with a 'retry' model, who guarantees that the retry wont be 
> an infinite retry where none of the retries ever progresses the state of 
> the system enough to return the data we are interested in? The moment we 
> have to /retry/, depending on the 'depth' of how deep the retry kicked 
> in, we've got to reach that 'depth' of code again and execute it.
> 
> plus, 'there is not much state' is not even completely true to begin 
> with, even in the most simple, TCP socket case! There /is/ quite a bit 
> of state constructed on the kernel stack: user parameters have been 
> evaluated/converted, the socket has been looked up, its state has been 
> validated, etc. With a 'retry' model - but even with a pure 'event 
> queueing' model we redo all those things /both/ at request submission 
> and at event generation time, again and again - while with a synchronous 
> syscall you do it just once and upon event completion a piece of that 
> data is already on the kernel stack. I'd much rather spend time and 
> effort on simplifying the scheduler and reducing the cache footprint of 
> the kernel thread context switch path, etc., to make it more useful even 
> in more extreme, highly prallel '100% context-switching' case, because i 
> have first-hand experience about how fragile and inflexible event based 
> servers are. I do think that event interfaces for raw, external physical 
> events make sense in some circumstances, but for any more complex 
> 'derived' event type it's less and less clear whether we want a direct 
> interface to it. For something like the VFS it's outright horrible to 
> even think about.

Ingo, you draw too much black into the picture.
No one will crate purely event based model for socket or VFS processing
- event is completion of the request - data in the buffer, data was sent
and so one - it is also possible to add events into middle of the
processing especially if operation can be logically separated - like
sendfile.

> 	Ingo

-- 
	Evgeniy Polyakov
