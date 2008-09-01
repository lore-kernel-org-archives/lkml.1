Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbYIASqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbYIASqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 14:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYIASqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 14:46:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39727 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYIASqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 14:46:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 1 Sep 2008 11:46:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Noisternig <mnoist@cosy.sbg.ac.at>
cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (more) epoll troubles
In-Reply-To: <48BC346E.1060108@cosy.sbg.ac.at>
Message-ID: <Pine.LNX.4.64.0809011135130.18267@alien.or.mcafeemobile.com>
References: <fa.zt4K08zThcs3bS6QJSiWmdw4amQ@ifi.uio.no> <48BC26D9.1040300@shaw.ca>
 <48BC2746.1090006@shaw.ca> <48BC346E.1060108@cosy.sbg.ac.at>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Michael Noisternig wrote:

> Robert Hancock schrieb:
> > Robert Hancock wrote:
> > > Michael Noisternig wrote:
> > > > Hello,
> > > > 
> > > > and sorry again if this is the wrong place to ask (again, please hint to
> > > > me to an appropriate place to ask in that case).
> > > > 
> > > > After experimenting with epoll edge-triggered mode I am clueless why on
> > > > a few occassions I seem to not get any input notification despite data
> > > > is available.
> > > > 
> > > > In detail: I have set up sockets with epoll events
> > > > EPOLLET|EPOLLRDHUP|EPOLLIN. When I get EPOLLIN for a socket, I read() as
> > > > long as I get what I asked for, i.e. whenever read() returns either
> > > > EAGAIN or less data than I asked for I take this as indication that I
> > > > must wait for another EPOLLIN notification. However, this does not seem
> > > > to work always.
> > > > 
> > > > Here is some log from my program:
> > > > 
> > > > 0x9e6b8a8: read not avail (1460/2048 read)
> > > > i.e. tried to read 2048 bytes, got 1460 -> assume must wait for EPOLLIN
> > > > for more data to read
> > > > (note that the fd is always in the epoll set with
> > > > EPOLLET|EPOLLRDHUP|EPOLLIN)
> > > 
> > > It would likely be better to always continue trying to read until EAGAIN
> > > is returned, even if the read returned less than the requested amount, as
> > > implied here:
> > > 
> > > http://linux.die.net/man/7/epoll
> > > 
> > > "The function do_use_fd() uses the new ready file descriptor until EAGAIN
> > > is returned by either read(2) or write(2). An event driven state machine
> > > application should, after having received EAGAIN, record its current state
> > > so that at the next call to do_use_fd() it will continue to read(2) or
> > > write(2) from where it stopped before. "
> > 
> > Though, this is somewhat contradicted by the FAQ section:
> > 
> > "the condition that the read/write I/O space is exhausted can be detected by
> > checking the amount of data read/write from/to the target file descriptor.
> > For example, if you call read(2) by asking to read a certain amount of data
> > and read(2) returns a lower number of bytes, you can be sure to have
> > exhausted the read I/O space for such file descriptor."
> 
> Yes, exactly. I don't know what is causing the problem I'm experiencing.
> Especially as it happens rather infrequently.

The man page has been recently edited to avoid confusion:


Q9  Do I need to continuously read/write a file descriptor until 
    EAGAIN when using the EPOLLET  flag  (edge-triggered behavior) ?

A9  Receiving  an  event from epoll_wait(2) should suggest to you 
    that such file descriptor is ready for the requested I/O operation.  
    You must consider it ready until the next  (non-blocking)  read/write  
    yields EAGAIN.  When and how you will use the file descriptor is 
    entirely up to you.
    For  packet/token-oriented  files  (e.g.,  datagram socket, terminal 
    in canonical mode), the only way to detect the end of the read/write 
    I/O space is to continue to read/write until EAGAIN.
    For stream-oriented files (e.g., pipe, FIFO, stream socket), the 
    condition that the read/write I/O space is  exhausted can also be 
    detected by checking the amount of data read from / written to the 
    target file descriptor.  For example, if you call read(2) by asking to 
    read a certain amount  of  data  and  read(2) returns  a  lower number  
    of bytes, you can be sure of having exhausted the read I/O space for 
    the file descriptor.  The same is true when writing using write(2).  
    (Avoid this latter technique if  you  cannot guarantee that the 
    monitored file descriptor always refers to a stream-oriented file.)



- Davide


