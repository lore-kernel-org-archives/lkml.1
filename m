Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYIARbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYIARbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYIARbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:31:05 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42694 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYIARbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:31:03 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=JMnnF-g5AAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=3YE8Yc1KGtzTT4tSDNkA:9 a=VbHjgn2ir3Bbr8DRQWkA:7 a=Oy_5lFgLuOLKAzkFCdxy-REMcIcA:4
Message-ID: <48BC26D9.1040300@shaw.ca>
Date: Mon, 01 Sep 2008 11:31:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Michael Noisternig <mnoist@cosy.sbg.ac.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: (more) epoll troubles
References: <fa.zt4K08zThcs3bS6QJSiWmdw4amQ@ifi.uio.no>
In-Reply-To: <fa.zt4K08zThcs3bS6QJSiWmdw4amQ@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Noisternig wrote:
> Hello,
> 
> and sorry again if this is the wrong place to ask (again, please hint to 
> me to an appropriate place to ask in that case).
> 
> After experimenting with epoll edge-triggered mode I am clueless why on 
> a few occassions I seem to not get any input notification despite data 
> is available.
> 
> In detail: I have set up sockets with epoll events 
> EPOLLET|EPOLLRDHUP|EPOLLIN. When I get EPOLLIN for a socket, I read() as 
> long as I get what I asked for, i.e. whenever read() returns either 
> EAGAIN or less data than I asked for I take this as indication that I 
> must wait for another EPOLLIN notification. However, this does not seem 
> to work always.
> 
> Here is some log from my program:
> 
> 0x9e6b8a8: read not avail (1460/2048 read)
> i.e. tried to read 2048 bytes, got 1460 -> assume must wait for EPOLLIN 
> for more data to read
> (note that the fd is always in the epoll set with 
> EPOLLET|EPOLLRDHUP|EPOLLIN)

It would likely be better to always continue trying to read until EAGAIN 
is returned, even if the read returned less than the requested amount, 
as implied here:

http://linux.die.net/man/7/epoll

"The function do_use_fd() uses the new ready file descriptor until 
EAGAIN is returned by either read(2) or write(2). An event driven state 
machine application should, after having received EAGAIN, record its 
current state so that at the next call to do_use_fd() it will continue 
to read(2) or write(2) from where it stopped before. "

> 
> 0x9e6b8a8: read not avail (1460/2048 read)
> got EPOLLIN notification, read 1460 bytes again -> wait for another 
> notification
> 
> ..after a few minutes without any notification...
> 
> 0x9e6b8a8: GOT RDHUP (2001:0/80002001:0)
> i.e. got notification for EPOLLRDHUP|EPOLLIN (2001), was waiting for 
> EPOLLET|EPOLLRDHUP|EPOLLIN (80002001)
> 
> 0x9e6b8a8: read not avail (342/2048 read)
> then on trying to read we find data in the buffer (???)
> 
> 0x9e6b8a8: stored 16384 bytes
> this is the amount of data we expected to get /immediately/, i.e. 
> without a minutes delay and rdhup
> 
> Of course you might think that the other side sent the data only just 
> before closing its side, but it is unlikely since we expected to get the 
> 16384 bytes in one go (this is how that L7 protocol works), and I see 
> this odd behaviour of missing input notifications now and then.
> 
> Does anybody know/have an idea why I am missing EPOLLIN notifications?
> 
> Any help is appreciated!!! Thanks in advance,
> Michael
> (please CC me when replying)
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

