Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZAIPnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZAIPnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZAIPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:43:40 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:37896 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZAIPnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:43:39 -0500
Message-ID: <49677074.5090802@cosmosbay.com>
Date: Fri, 09 Jan 2009 16:42:44 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ben@zeus.com, w@1wt.eu, jarkao2@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <20090108173028.GA22531@1wt.eu>	<49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com>
In-Reply-To: <4966F2F4.9080901@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Jan 2009 16:42:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> David Miller a écrit :
>> I'm not applying this until someone explains to me why
>> we should remove this test from the splice receive but
>> keep it in the tcp_recvmsg() code where it has been
>> essentially forever.

Reading again tcp_recvmsg(), I found it already is able to eat several skb
even in nonblocking mode.

setsockopt(5, SOL_SOCKET, SO_RCVLOWAT, [61440], 4) = 0
ioctl(5, FIONBIO, [1])                  = 0
poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536
poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536
poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536
poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536


David, if you referred to code at line 1374 of net/ipv4/tcp.c, I believe there is
no issue with it. We really want to break from this loop if !timeo .

Willy patch makes splice() behaving like tcp_recvmsg(), but we might call
tcp_cleanup_rbuf() several times, with copied=1460 (for each frame processed)

I wonder if the right fix should be done in tcp_read_sock() : this is the
one who should eat several skbs IMHO, if we want optimal ACK generation.

We break out of its loop at line 1246

if (!desc->count) /* this test is always true */
	break;

(__tcp_splice_read() set count to 0, right before calling tcp_read_sock())

So code at line 1246 (tcp_read_sock()) seems wrong, or pessimistic at least.



