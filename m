Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZLUFqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZLUFqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 00:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZLUFqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 00:46:21 -0500
Received: from 1wt.eu ([62.212.114.60]:52855 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbZLUFqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 00:46:20 -0500
Date: Mon, 21 Dec 2009 06:46:15 +0100
From: Willy Tarreau <w@1wt.eu>
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll'ing tcp sockets for reading
Message-ID: <20091221054615.GH9719@1wt.eu>
References: <1257480306.20091219150206@mail.ru> <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com> <203216314.20091220013854@mail.ru> <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com> <1059651918.20091220032610@mail.ru> <alpine.DEB.2.00.0912200750280.9679@makko.or.mcafeemobile.com> <20091220161422.GH32739@1wt.eu> <11246924033.20091221022619@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11246924033.20091221022619@mail.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 02:26:19AM +0300, Nikolai ZHUBR wrote:
> Hello Willy,
> Sunday, December 20, 2009, 7:14:22 PM, Willy Tarreau wrote:
> >> > The same thing can approximately be "emulated" by requesting FIOREAD for
> >> > all EPOLLIN-ready sockets just after epoll returns, before any other work.
> >> > It just would look not very elegant IMHO.
> >> 
> >> No such a thing of "atomic matter", since by the time you read the event, 
> >> more data might have come. It's just flawed, you see that?
> Well, a carefull application should choose to not read such newly appeared
> data at this point yet, because this data actually belongs to the next
> turn, see below. In other words, the read limit is known at the time of
> epoll return and this value need not be changed till the next epoll,
> no matter more data arrives meanwhile. (And that is why FIONREAD is not
> perfectly good for that - it always reports all data at the moment)
> 
> > I think that what Nikolai meant was the ability to wake up as soon as
> > there are *at least* XXX bytes ready. But while I can understand why
> > it would in theory save some code, in practice he would still have to
> 
> Uhhh, no. What I want is to ensure that incoming blocks of network data
> (possibly belonging to different connections) are pulled in and processed
> by application approximately in the same order as they arrive from the
> network.

Then I don't even see any remote possibility, because pollers will generally
return a limited number of file descriptors on which activity was detected,
so it is very possible that the one who talked first will be reported last.

> As long as no real queue exists for that, an application must
> at least care to _limit_ the amount of data it reads from any socket per
> one epoll call. (Otherwise, some very active connection with lots of
> incoming data might cause other connections starve badly).

Then it's up to the application to limit the amount of data it reads from
an FD. But in general, you'd prefer to read everything and only make that
data available to the readers at a lower pace.

> So, the application will need to find the value for the above limit.
> Most reasonable value, imho, would be simply the amount of data that
> actually arrived on this socket between two successive epoll calls (the
> latest one and the previous one). My point was that it would be handy
> if epoll offered some way to get this value automatically (filled in
> epoll_event maybe?).

it will not change anything, as Davide explained it, because that amount
will increase by the time you proceed with read() and you will get more
data. So it is the read() you have to limit, not epoll.

Also, you should be conscious that the time you'd waste doing this is
probably greater than the delta time between two reads on two distinct
sockets, which means that in practice you will not necessarily report
data in the network order, but you'll just be approximately fair
between all FDs, at the expense of a high syscall overhead caused by
small reads.

> (Though, probably FIONREAD can do the job reasonably well in most cases)

FIONREAD will just tell you how many bytes are pending for a read. Its
only use is for allocating memory before performing the read. If you
already have a buffer available, just read into it, you'll get the
info too.

Willy

