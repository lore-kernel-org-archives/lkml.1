Return-Path: <linux-kernel-owner+w=401wt.eu-S1750987AbXBYWpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987AbXBYWpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 17:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbXBYWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 17:45:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51131 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbXBYWpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 17:45:07 -0500
Date: Sun, 25 Feb 2007 14:44:11 -0800 (PST)
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
In-Reply-To: <20070222113148.GA3781@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Feb 2007, Evgeniy Polyakov wrote:
> 
> My tests show that with 4k connections per second (8k concurrency) more 
> than 20k connections of 80k total block in tcp_sendmsg() over gigabit 
> lan between quite fast machines.

Why do people *keep* taking this up as an issue?

Use select/poll/epoll/kevent/whatever for event mechanisms. STOP CLAIMING 
that you'd use threadlets/syslets/aio for that. It's been pointed out over 
and over and over again, and yet you continue to make the same mistake, 
Evgeniy.

So please read that sentence ten times, and then don't continue to make 
that same mistake. PLEASE.

Event mechanisms are *superior* for events. But they *suck* for things 
that aren't events, but are actual code execution with random places that 
can block. THE TWO THINGS ARE TOTALLY AND UTTERLY INDEPENDENT!

Examples of events:
 - packet arrives
 - timer happens

Examples of things that are *not* "events":
 - filesystem lookup.
 - page faults

So the basic point is: for events, you use an event-based thing. For code 
execution, you use a thread-based thing. It's really that simple.

And yes, the two different things can usually be translated (at a very 
high cost in complexity *and* performance) into each other, so people who 
look at it as purely a theoretical exercise may think that "events" and 
"code execution" are equivalent. That's a very very silly and stupid way 
of looking at things in real life, though.

Yes, you can turn things that are better seen as threaded execution into 
an event-based thing by turning it into a state machine. And usually that 
is a TOTAL DISASTER, and the end result is fragile and impossible to 
maintain.

And yes, you can often (more easily) turn an event-based mechanism into a 
thread-based one, and usually the end result is a TOTAL DISASTER because 
it doesn't scale very well, and while it may actually result in somewhat 
simpler code, the overhead of managing ten thousand outstanding threads is 
just too high, when you compare to managing just a list of ten thousand 
outstanding events.

And yes, people have done both of those mistakes. Java, for example, 
largely did the latter mistake ("we don't need anything like 'select', 
because we'll just use threads for everything" - what a totally moronic 
thing to do!)

So Evgeniy, threadlets/syslets/aio is *not* a replacement for event 
queues. It's a TOTALLY DIFFERENT MECHANISM, and one that is hugely 
superior to event queues for certain kinds of things. Anybody who thinks 
they want to do pathname and inode lookup as a series of events is likely 
a moron. It's really that simple.

In a complex server (say, a database), you'd use both. You'd probably use 
events for doing the things you *already* use events for (whether it be 
select/poll/epoll or whatever): probably things like the client network 
connection handling.

But you'd *in*addition* use threadlets to be able to do the actual 
database IO in a threaded manner, so that you can scale the things that 
are not easily handled as events (usually because they have internal 
kernel state that the user cannot even see, and *must*not* see because of 
security issues).

So please. Stop this "kevents are better". The only thing you show by 
trying to go down that avenue is that you don't understand the 
*difference* between an event model and a thread model. They are both 
perfectly fine models and they ARE NOT THE SAME! They aren't even mutually 
incompatible - quite the reverse.

The thing people want to remove with threadlets is the internal overhead 
of maintaining special-purpose code like aio_read() inside the kernel, 
that doesn't even do all that people want it to do, and that really does 
need a fair amount of internal complexity that we could hopefully do with 
a more generic (and hopefully *simpler*) model.

		Linus
