Return-Path: <linux-kernel-owner+w=401wt.eu-S1030404AbXBZTXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030404AbXBZTXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030408AbXBZTXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:23:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58343 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030404AbXBZTXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:23:47 -0500
Date: Mon, 26 Feb 2007 11:22:46 -0800 (PST)
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
In-Reply-To: <20070226183227.GE22454@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702261112020.12485@woody.linux-foundation.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
 <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
 <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
 <20070226183227.GE22454@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Evgeniy Polyakov wrote:
> 
> I want to say, that read() consists of tons of events, but programmer
> needs only one - data is ready in requested buffer. Programmer might
> not even know what is the object behind provided file descriptor.
> One only wans data in the buffer.

You're not following the discussion.

First off, I already *told* you that "read()" is the absolute simplest 
case, and yes, we could make it an event if you also passed in the "which 
range of the file do we care about" information (we could consider it 
"f_pos", which the kernel already knows about, but that doesn't handle 
pread()/pwrite(), so it's not very good for many cases).

But that's not THE ISSUE.

The issue is that it's a horrible interface from a users standpoint.  
It's a lot better to program certain things as a thread. Why do you argue 
against that, when that is just obviously true.

There's a reason that people write code that is functional, rather than 
write code as a state machine.

We simply don't write code like

	for (;;) {
	switch (state) {
	case Open:
		fd = open();
		if (fd < 0)
			break;
		state = Stat;
	case Stat:
		if (fstat(fd, &stat) < 0)
			break;
		state = Read;
	case Read:
		count = read(fd, buf + pos, size - pos));
		if (count < 0)
			break;
		pos += count;
		if (!count || pos == size)
			state = Close;
		continue;
	case Close;
		if (close(fd) < 0)
			break;
		state = Done;
		return 0;
	}
	}
	/* Returning 1 means wait in the event loop .. */
	if (errno == EAGAIN || errno == EINTR)
		return 1;
	/* Else we had a real error */
	state = Error;
	return -1;

and instead we write it as

	fd = open(..)
	if (fd < 0)
		return -1;
	if (fstat(fd, &st)) < 0) {
		close(fd);
		return -1;
	}
	.. 

and if you cannot see the *reason* why people don't use event-based 
programming for everything, I don't see the point of continuing this 
discussion.

See? Stop blathering about how everything is an event. THAT'S NOT 
RELEVANT. I've told you a hundred times - they may be "logically 
equivalent", but that doesn't change ANYTHING. Event-based programming 
simply isn't suitable for 99% of all stuff, and for the 1% where it *is* 
suitable, it actually tends to be a very specific subset of the code that 
you actually use events for (ie accept and read/write on pure streams).

		Linus
