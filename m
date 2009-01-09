Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZAIR6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZAIR6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZAIR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:58:33 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:38464 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZAIR6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:58:32 -0500
Message-ID: <49679012.3000702@cosmosbay.com>
Date: Fri, 09 Jan 2009 18:57:38 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ben@zeus.com, w@1wt.eu, jarkao2@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <20090108173028.GA22531@1wt.eu>	<49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com>
In-Reply-To: <49677074.5090802@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Jan 2009 18:57:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> David Miller a écrit :
>>> I'm not applying this until someone explains to me why
>>> we should remove this test from the splice receive but
>>> keep it in the tcp_recvmsg() code where it has been
>>> essentially forever.
> 
> Reading again tcp_recvmsg(), I found it already is able to eat several skb
> even in nonblocking mode.
> 
> setsockopt(5, SOL_SOCKET, SO_RCVLOWAT, [61440], 4) = 0
> ioctl(5, FIONBIO, [1])                  = 0
> poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
> recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
> write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536
> poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
> recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
> write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536
> poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
> recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
> write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536
> poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
> recv(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536, MSG_DONTWAIT) = 65536
> write(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 65536) = 65536
> 
> 
> David, if you referred to code at line 1374 of net/ipv4/tcp.c, I believe there is
> no issue with it. We really want to break from this loop if !timeo .
> 
> Willy patch makes splice() behaving like tcp_recvmsg(), but we might call
> tcp_cleanup_rbuf() several times, with copied=1460 (for each frame processed)
> 
> I wonder if the right fix should be done in tcp_read_sock() : this is the
> one who should eat several skbs IMHO, if we want optimal ACK generation.
> 
> We break out of its loop at line 1246
> 
> if (!desc->count) /* this test is always true */
> 	break;
> 
> (__tcp_splice_read() set count to 0, right before calling tcp_read_sock())
> 
> So code at line 1246 (tcp_read_sock()) seems wrong, or pessimistic at least.

I tested following patch and got expected result :

- less ACK, and correct rcvbuf adjustments.
- I can fill the Gb link with one flow only, using less than
  10% of the cpu, instead of 40% without patch.

Setting desc->count to 1 seems to be the current practice.
(Example in drivers/scsi/iscsi_tcp.c : iscsi_sw_tcp_data_ready())

******************************************************************
* Note : this patch is wrong, because splice() can now           *
* return  more bytes than asked for (if SPLICE_F_NONBLOCK asked) *
******************************************************************

[PATCH] tcp: splice as many packets as possible at once

As spotted by Willy Tarreau, current splice() from tcp socket to pipe is not
optimal. It processes at most one segment per call.
This results in low performance and very high overhead due to syscall rate
when splicing from interfaces which do not support LRO.

Willy provided a patch inside tcp_splice_read(), but a better fix
is to let tcp_read_sock() process as many segments as possible, so
that tcp_rcv_space_adjust() and tcp_cleanup_rbuf() are called once
per syscall.

With this change, splice() behaves like tcp_recvmsg(), being able
to consume many skbs in one system call.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bd6ff90..15bd67b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -533,6 +533,9 @@ static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
 		.arg.data = tss,
 	};
 
+	if (tss->flags & SPLICE_F_NONBLOCK)
+		rd_desc.count = 1; /* we want as many segments as possible */
+
 	return tcp_read_sock(sk, &rd_desc, tcp_splice_data_recv);
 }
 

