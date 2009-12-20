Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZLTXSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZLTXSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 18:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZLTXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 18:18:19 -0500
Received: from mx39.mail.ru ([94.100.176.53]:50302 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbZLTXSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 18:18:18 -0500
Date: Mon, 21 Dec 2009 02:26:19 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <11246924033.20091221022619@mail.ru>
To: Willy Tarreau <w@1wt.eu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re[2]: epoll'ing tcp sockets for reading
In-reply-To: <20091220161422.GH32739@1wt.eu>
References: <1257480306.20091219150206@mail.ru>
 <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com>
 <203216314.20091220013854@mail.ru>
 <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com>
 <1059651918.20091220032610@mail.ru>
 <alpine.DEB.2.00.0912200750280.9679@makko.or.mcafeemobile.com>
 <20091220161422.GH32739@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Willy,
Sunday, December 20, 2009, 7:14:22 PM, Willy Tarreau wrote:
>> > The same thing can approximately be "emulated" by requesting FIOREAD for
>> > all EPOLLIN-ready sockets just after epoll returns, before any other work.
>> > It just would look not very elegant IMHO.
>> 
>> No such a thing of "atomic matter", since by the time you read the event, 
>> more data might have come. It's just flawed, you see that?
Well, a carefull application should choose to not read such newly appeared
data at this point yet, because this data actually belongs to the next
turn, see below. In other words, the read limit is known at the time of
epoll return and this value need not be changed till the next epoll,
no matter more data arrives meanwhile. (And that is why FIONREAD is not
perfectly good for that - it always reports all data at the moment)

> I think that what Nikolai meant was the ability to wake up as soon as
> there are *at least* XXX bytes ready. But while I can understand why
> it would in theory save some code, in practice he would still have to

Uhhh, no. What I want is to ensure that incoming blocks of network data
(possibly belonging to different connections) are pulled in and processed
by application approximately in the same order as they arrive from the
network. As long as no real queue exists for that, an application must
at least care to _limit_ the amount of data it reads from any socket per
one epoll call. (Otherwise, some very active connection with lots of
incoming data might cause other connections starve badly).
So, the application will need to find the value for the above limit.
Most reasonable value, imho, would be simply the amount of data that
actually arrived on this socket between two successive epoll calls (the
latest one and the previous one). My point was that it would be handy
if epoll offered some way to get this value automatically (filled in
epoll_event maybe?).
(Though, probably FIONREAD can do the job reasonably well in most cases)

Thank you!

Nikolai ZHUBR

> properly handle corner cases, which would defeat the original purpose
> of his modification :

>   - if he waits for larger data than the socket buffer can handle, he
>     will never wake up ;

>   - if my memory serves me right, the copy_and_cksum() code only knows
>     whether a segment is correct during its transfer to userland, which
>     means that epoll() could very well wake up with XXX apparent bytes
>     ready, but the read would fail before XXX due to an invalid checksum
>     on an intermediate segment. So the code would still have to take
>     care of that situation anyway.

> The last point implies the complete implementation of the code he wants
> to avoid anyway, and the first one implies it will be hard to know when
> this would work and when this would not. This means that while at first
> glance this behaviour could be useful, it would in practice be useless.

> Regards,
> Willy


