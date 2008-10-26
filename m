Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYJZWHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYJZWHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 18:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYJZWH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 18:07:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41013 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYJZWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 18:07:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 26 Oct 2008 15:07:24 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul P <ppak_98@yahoo.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: unexpected extra pollout events from epoll
In-Reply-To: <401776.11819.qm@web56305.mail.re3.yahoo.com>
Message-ID: <Pine.LNX.4.64.0810261452221.19212@alien.or.mcafeemobile.com>
References: <401776.11819.qm@web56305.mail.re3.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Paul P wrote:

> I am programming a server using the epoll interface and have the receive portion of the server working fine, but for some reason as I implement the send portion, I noticed a few things that seem like strange behaviors in the implementation of epoll in the kernel.
> 
> I'm running Opensuse 11 and it has a 2.6.25 kernel.
> 
> The behavior that I can seeing is when I do a full read on an edge 
> triggered fd, for some reason, it seems to be triggering an epollout 
> event after each loop of the read events on a socket. (before I've done 
> any writes at all to the socket)
> 
> This is very strange behavior as I would expect that the epollout event 
> would only be triggered if I did a write and the socket recieved an ack 
> which cleared out the send buffer.
> 
> The documentation on epollout is really sparse, so any help at all from 
> the list would be very much appreciated.  Do I need to manually arm the 
> epollout flag after a write?  I thought this was only necessary for 
> level triggered epoll.

The way epoll works, is by hooking into the existing kernel poll 
subsystem. It hooks into the poll wakeups, via callback, and it that way 
it knows that "something" is changed. Then it reads the status of a file 
via f_op->poll() to know the status.
What happens is that, if you listen for EPOLLIN|EPOLLOUT, when a packet 
arrives the callback hook is hit, and the file is put into a maybe-ready 
list. Maybe-ready because at the time of the callback, epoll has no clue 
of what happened.
After that, via epoll_wait(), f_op->poll() is called to get the status of 
the file, and since POLLIN|POLLOUT is returned (and since you're listening 
for EPOLLIN|EPOLLOUT), that gets reported back to you.
The POLLOUT event, by meaning a buffer-full->buffer-avail transition, did 
not really happen, but since POLLOUT is true, that gets reported back too.
This, again, since epoll has no clue of what happened at callback hit time.
I'm working on changes that will make epoll aware (by using the existing 
support for the "key" parameter of wakeups) of events at callback time, 
but this is something that is still up for discussion and definitely won't 
be in .28.
The best way to do it ATM, is to wait for POLLOUT only when really needed.




- Davide


