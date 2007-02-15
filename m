Return-Path: <linux-kernel-owner+w=401wt.eu-S1030381AbXBOTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030381AbXBOTMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030699AbXBOTMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:12:41 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33615 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030381AbXBOTMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:12:40 -0500
Date: Thu, 15 Feb 2007 22:10:59 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070215191059.GB23953@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215184656.GA12897@outpost.ds9a.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070215184656.GA12897@outpost.ds9a.nl>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 22:11:02 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 07:46:56PM +0100, bert hubert (bert.hubert@netherlabs.nl) wrote:
> 1) batch, and wait for, with proper error reporting:
> 	socket();
> 	[ setsockopt(); ]
> 	bind();
> 	connect();
> 	gettimeofday();  // doesn't *always* happen
> 	send();
> 	recv();
> 	gettimeofday(); // doesn't *always* happen
> 
> 	I go through this sequence for each outgoing powerdns UDP query
> 	because I need a new random source port for each query, and I
> 	connect because I care about errrors. Linux does not give me random
> 	source ports for UDP sockets.

What about a setsockopt or just random port selection patch? :)

> 	When async, I can probably just drop the setsockopt (for
> 	nonblocking). I already batch the gettimeofday to 'once per epoll
> 	return', but quite often this is once per packet.
> 
> 2) 	On the client facing side (port 53), I'd very much hope for a way to
> 	do 'recvv' on datagram sockets, so I can retrieve a whole bunch of
> 	UDP datagrams with only one kernel transition.
> 
> 	This would mean that I batch up either 10 calls to recv(), or one
> 	'atom' of 10 recv's.
> 
> Both 1 and 2 are currently limiting factors when I enter the 100kqps domain
> of name serving. This doesn't mean the rest of my code is as tight as it
> could be, but I spend a significant portion of time in the kernel even at
> moderate (10kqps effective) loads, even though I already use epoll. A busy
> PowerDNS recursor typically spends 25% to 50% of its time on 'sy' load.
> 
> This might be due to my use of get/set/swap/makecontext though.

It is only about one syscall in get and set/swap context, btw, so it
should not be a main factor, doesn't it?

As an advertisement note, but if you have a lot of network events per epoll 
read try to use kevent - its socket notifications do not require
additional traverse of the list of ready events as in poll usage.

> 	Bert
> 
> -- 
> http://www.PowerDNS.com      Open source, database driven DNS Software 
> http://netherlabs.nl              Open and Closed source services

-- 
	Evgeniy Polyakov
