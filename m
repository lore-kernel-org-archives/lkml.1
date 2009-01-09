Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZAIUw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZAIUw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZAIUwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:52:10 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:55370 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZAIUwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:52:08 -0500
Message-ID: <4967B8C5.10803@cosmosbay.com>
Date: Fri, 09 Jan 2009 21:51:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Miller <davem@davemloft.net>, ben@zeus.com, jarkao2@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <20090108173028.GA22531@1wt.eu> <49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu>
In-Reply-To: <20090109185448.GA1999@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Jan 2009 21:51:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau a écrit :
> Hi Eric,
> 
> On Fri, Jan 09, 2009 at 04:42:44PM +0100, Eric Dumazet wrote:
> (...)
>> Willy patch makes splice() behaving like tcp_recvmsg(), but we might call
>> tcp_cleanup_rbuf() several times, with copied=1460 (for each frame processed)
>>
>> I wonder if the right fix should be done in tcp_read_sock() : this is the
>> one who should eat several skbs IMHO, if we want optimal ACK generation.
>>
>> We break out of its loop at line 1246
>>
>> if (!desc->count) /* this test is always true */
>> 	break;
>>
>> (__tcp_splice_read() set count to 0, right before calling tcp_read_sock())
>>
>> So code at line 1246 (tcp_read_sock()) seems wrong, or pessimistic at least.
> 
> That's a very interesting discovery that you made here. I have made
> mesurements with this line commented out just to get an idea. The
> hardest part was to find a CPU-bound machine. Finally I slowed my
> laptop down to 300 MHz (in fact, 600 with throttle 50%, but let's
> call that 300). That way, I cannot saturate the PCI-based tg3 and
> I can observe the effects of various changes on the data rate.
> 
> - original tcp_splice_read(), with "!timeo"    : 24.1 MB/s
> - modified tcp_splice_read(), without "!timeo" : 32.5 MB/s (+34%)
> - original with line #1246 commented out       : 34.5 MB/s (+43%)
> 
> So you're right, avoiding calling tcp_read_sock() all the time
> gives a nice performance boost.
> 
> Also, I found that tcp_splice_read() behaves like this when breaking
> out of the loop :
> 
>     lock_sock();
>     while () {
>          ...
>          __tcp_splice_read();
>          ...
>          release_sock();
>          lock_sock();
>          if (break condition)
>               break;
>     }
>     release_sock();
> 
> Which means that when breaking out of the loop on (!timeo)
> with ret > 0, we do release_sock/lock_sock/release_sock.
> 
> So I tried a minor modification, consisting in moving the
> test before release_sock(), and leaving !timeo there with
> line #1246 commented out. That's a noticeable winner, as
> the data rate went up to 35.7 MB/s (+48%).
> 
> Also, in your second mail, you're saying that your change
> might return more data than requested by the user. I can't
> find why, could you please explain to me, as I'm still quite
> ignorant in this area ?

Well, I just tested various user programs and indeed got this
strange result :

Here I call splice() with len=1000 (0x3e8), and you can see
it gives a result of 1460 at the second call.

I suspect a bug in splice code, that my patch just exposed.

pipe([3, 4])                            = 0
open("/dev/null", O_RDWR|O_CREAT|O_TRUNC, 0644) = 5
socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 6
bind(6, {sa_family=AF_INET, sin_port=htons(4711), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
listen(6, 5)                            = 0
accept(6, 0, NULL)                      = 7
setsockopt(7, SOL_SOCKET, SO_RCVLOWAT, [1000], 4) = 0
poll([{fd=7, events=POLLIN, revents=POLLIN}], 1, -1) = 1
splice(0x7, 0, 0x4, 0, 0x3e8, 0x3)      = 1000                OK
splice(0x3, 0, 0x5, 0, 0x3e8, 0x5)      = 1000
poll([{fd=7, events=POLLIN, revents=POLLIN}], 1, -1) = 1
splice(0x7, 0, 0x4, 0, 0x3e8, 0x3)      = 1460                Oh well... 1460 > 1000 !!!
splice(0x3, 0, 0x5, 0, 0x5b4, 0x5)      = 1460
poll([{fd=7, events=POLLIN, revents=POLLIN}], 1, -1) = 1
splice(0x7, 0, 0x4, 0, 0x3e8, 0x3)      = 1460
splice(0x3, 0, 0x5, 0, 0x5b4, 0x5)      = 1460



