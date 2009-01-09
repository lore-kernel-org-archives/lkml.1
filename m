Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbZAIWDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbZAIWDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZAIWDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:03:01 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:41156 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758934AbZAIWC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:02:59 -0500
Message-ID: <4967C95E.3070602@cosmosbay.com>
Date: Fri, 09 Jan 2009 23:02:06 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Miller <davem@davemloft.net>, ben@zeus.com, jarkao2@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <20090108173028.GA22531@1wt.eu> <49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu>
In-Reply-To: <20090109212400.GA3727@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Jan 2009 23:02:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau a écrit :
> On Fri, Jan 09, 2009 at 09:51:17PM +0100, Eric Dumazet wrote:
> (...)
>>> Also, in your second mail, you're saying that your change
>>> might return more data than requested by the user. I can't
>>> find why, could you please explain to me, as I'm still quite
>>> ignorant in this area ?
>> Well, I just tested various user programs and indeed got this
>> strange result :
>>
>> Here I call splice() with len=1000 (0x3e8), and you can see
>> it gives a result of 1460 at the second call.
> 
> huh, not nice indeed!
> 
> While looking at the code to see how this could be possible, I
> came across this minor thing (unrelated IMHO) :
> 
> 	if (__skb_splice_bits(skb, &offset, &tlen, &spd))
> 		goto done;
>>>>>>> 	else if (!tlen)    <<<<<<
> 		goto done;
> 
> 	/*
> 	 * now see if we have a frag_list to map
> 	 */
> 	if (skb_shinfo(skb)->frag_list) {
> 		struct sk_buff *list = skb_shinfo(skb)->frag_list;
> 
> 		for (; list && tlen; list = list->next) {
> 			if (__skb_splice_bits(list, &offset, &tlen, &spd))
> 				break;
> 		}
> 	}
> 
>     done:
> 
> Above on the enlighted line, we'd better remove the else and leave a plain
> "if (!tlen)". Otherwise, when the first call to __skb_splice_bits() zeroes
> tlen, we still enter the if and evaluate the for condition for nothing. But
> let's leave that for later.
> 
>> I suspect a bug in splice code, that my patch just exposed.
> 
> I've checked in skb_splice_bits() and below and can't see how we can move
> more than the requested len.
> 
> However, with your change, I don't clearly see how we break out of
> the loop in tcp_read_sock(). Maybe we first read 1000 then loop again
> and read remaining data ? I suspect that we should at least exit when
> ((struct tcp_splice_state *)desc->arg.data)->len = 0.
> 
> At least that's something easy to add just before or after !desc->count
> for a test.
> 

I believe the bug is in tcp_splice_data_recv()

I am going to test a new patch, but here is the thing I found:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bd6ff90..fbbddf4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -523,7 +523,7 @@ static int tcp_splice_data_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 {
        struct tcp_splice_state *tss = rd_desc->arg.data;

-       return skb_splice_bits(skb, offset, tss->pipe, tss->len, tss->flags);
+       return skb_splice_bits(skb, offset, tss->pipe, len, tss->flags);
 }

 static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)


