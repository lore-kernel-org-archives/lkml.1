Return-Path: <linux-kernel-owner+w=401wt.eu-S1030521AbXBOSrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521AbXBOSrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030522AbXBOSrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:47:00 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:49775 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030521AbXBOSq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:46:59 -0500
Date: Thu, 15 Feb 2007 19:46:56 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070215184656.GA12897@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 09:42:32AM -0800, Linus Torvalds wrote:

> We know one interface: the current aio_read() one. Nobody really _likes_ 
[...]

> Others? We don't know yet. And exposing complex interfaces that may not be 
> the right ones is much *worse* than exposing simple interfaces (that 
> _also_ may not be the right ones, of course - but simple and 

>From humble userland, here's two things I'd hope to be able to do, although
I admit my needs are rather specialist.

1) batch, and wait for, with proper error reporting:
	socket();
	[ setsockopt(); ]
	bind();
	connect();
	gettimeofday();  // doesn't *always* happen
	send();
	recv();
	gettimeofday(); // doesn't *always* happen

	I go through this sequence for each outgoing powerdns UDP query
	because I need a new random source port for each query, and I
	connect because I care about errrors. Linux does not give me random
	source ports for UDP sockets.

	When async, I can probably just drop the setsockopt (for
	nonblocking). I already batch the gettimeofday to 'once per epoll
	return', but quite often this is once per packet.

2) 	On the client facing side (port 53), I'd very much hope for a way to
	do 'recvv' on datagram sockets, so I can retrieve a whole bunch of
	UDP datagrams with only one kernel transition.

	This would mean that I batch up either 10 calls to recv(), or one
	'atom' of 10 recv's.

Both 1 and 2 are currently limiting factors when I enter the 100kqps domain
of name serving. This doesn't mean the rest of my code is as tight as it
could be, but I spend a significant portion of time in the kernel even at
moderate (10kqps effective) loads, even though I already use epoll. A busy
PowerDNS recursor typically spends 25% to 50% of its time on 'sy' load.

This might be due to my use of get/set/swap/makecontext though.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
