Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYHaNis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYHaNis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbYHaNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:38:39 -0400
Received: from puma.cosy.sbg.ac.at ([141.201.2.23]:52919 "EHLO
	puma.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYHaNij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:38:39 -0400
Message-ID: <48BA9EB9.3040701@cosy.sbg.ac.at>
Date: Sun, 31 Aug 2008 15:38:01 +0200
From: Michael Noisternig <mnoist@cosy.sbg.ac.at>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: (more) epoll troubles
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

and sorry again if this is the wrong place to ask (again, please hint to 
me to an appropriate place to ask in that case).

After experimenting with epoll edge-triggered mode I am clueless why on 
a few occassions I seem to not get any input notification despite data 
is available.

In detail: I have set up sockets with epoll events 
EPOLLET|EPOLLRDHUP|EPOLLIN. When I get EPOLLIN for a socket, I read() as 
long as I get what I asked for, i.e. whenever read() returns either 
EAGAIN or less data than I asked for I take this as indication that I 
must wait for another EPOLLIN notification. However, this does not seem 
to work always.

Here is some log from my program:

0x9e6b8a8: read not avail (1460/2048 read)
i.e. tried to read 2048 bytes, got 1460 -> assume must wait for EPOLLIN 
for more data to read
(note that the fd is always in the epoll set with 
EPOLLET|EPOLLRDHUP|EPOLLIN)

0x9e6b8a8: read not avail (1460/2048 read)
got EPOLLIN notification, read 1460 bytes again -> wait for another 
notification

...after a few minutes without any notification...

0x9e6b8a8: GOT RDHUP (2001:0/80002001:0)
i.e. got notification for EPOLLRDHUP|EPOLLIN (2001), was waiting for 
EPOLLET|EPOLLRDHUP|EPOLLIN (80002001)

0x9e6b8a8: read not avail (342/2048 read)
then on trying to read we find data in the buffer (???)

0x9e6b8a8: stored 16384 bytes
this is the amount of data we expected to get /immediately/, i.e. 
without a minutes delay and rdhup

Of course you might think that the other side sent the data only just 
before closing its side, but it is unlikely since we expected to get the 
16384 bytes in one go (this is how that L7 protocol works), and I see 
this odd behaviour of missing input notifications now and then.

Does anybody know/have an idea why I am missing EPOLLIN notifications?

Any help is appreciated!!! Thanks in advance,
Michael
(please CC me when replying)
