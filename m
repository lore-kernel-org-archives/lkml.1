Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbZAIWqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbZAIWqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZAIWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:45:58 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:54829 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZAIWp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:45:57 -0500
Message-ID: <4967D36E.6020207@cosmosbay.com>
Date: Fri, 09 Jan 2009 23:45:02 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Miller <davem@davemloft.net>, ben@zeus.com, jarkao2@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <20090108173028.GA22531@1wt.eu> <49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu> <20090109220737.GA4111@1wt.eu> <4967CBB9.1060403@cosmosbay.com> <20090109221744.GA4819@1wt.eu>
In-Reply-To: <20090109221744.GA4819@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Jan 2009 23:45:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau a écrit :
> On Fri, Jan 09, 2009 at 11:12:09PM +0100, Eric Dumazet wrote:
>> Willy Tarreau a écrit :
>>> On Fri, Jan 09, 2009 at 10:24:00PM +0100, Willy Tarreau wrote:
>>>> On Fri, Jan 09, 2009 at 09:51:17PM +0100, Eric Dumazet wrote:
>>>> (...)
>>>>>> Also, in your second mail, you're saying that your change
>>>>>> might return more data than requested by the user. I can't
>>>>>> find why, could you please explain to me, as I'm still quite
>>>>>> ignorant in this area ?
>>>>> Well, I just tested various user programs and indeed got this
>>>>> strange result :
>>>>>
>>>>> Here I call splice() with len=1000 (0x3e8), and you can see
>>>>> it gives a result of 1460 at the second call.
>>> OK finally I could reproduce it and found why we have this. It's
>>> expected in fact.
>>>
>>> The problem when we loop in tcp_read_sock() is that tss->len is
>>> not decremented by the amount of bytes read, this one is done
>>> only in tcp_splice_read() which is outer.
>>>
>>> The solution I found was to do just like other callers, which means
>>> use desc->count to keep the remaining number of bytes we want to
>>> read. In fact, tcp_read_sock() is designed to use that one as a stop
>>> condition, which explains why you first had to hide it.
>>>
>>> Now with the attached patch as a replacement for my previous one,
>>> both issues are solved :
>>>   - I splice 1000 bytes if I ask to do so
>>>   - I splice as much as possible if available (typically 23 kB).
>>>
>>> My observed performances are still at the top of earlier results
>>> and IMHO that way of counting bytes makes sense for an actor called
>>> from tcp_read_sock().
>>>
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index 35bcddf..51ff3aa 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -522,8 +522,12 @@ static int tcp_splice_data_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
>>>  				unsigned int offset, size_t len)
>>>  {
>>>  	struct tcp_splice_state *tss = rd_desc->arg.data;
>>> +	int ret;
>>>  
>>> -	return skb_splice_bits(skb, offset, tss->pipe, tss->len, tss->flags);
>>> +	ret = skb_splice_bits(skb, offset, tss->pipe, rd_desc->count, tss->flags);
>>> +	if (ret > 0)
>>> +		rd_desc->count -= ret;
>>> +	return ret;
>>>  }
>>>  
>>>  static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
>>> @@ -531,6 +535,7 @@ static int __tcp_splice_read(struct sock *sk, struct tcp_splice_state *tss)
>>>  	/* Store TCP splice context information in read_descriptor_t. */
>>>  	read_descriptor_t rd_desc = {
>>>  		.arg.data = tss,
>>> +		.count = tss->len,
>>>  	};
>>>  
>>>  	return tcp_read_sock(sk, &rd_desc, tcp_splice_data_recv);
>>>
>> OK, I came to a different patch. Please check other tcp_read_sock() callers in tree :)
> 
> I've seen the other callers, but they all use desc->count for their own
> purpose. That's how I understood what it was used for :-)

Ah yes, I reread your patch and you are right.

> 
> I think it's better not to change the API here and use tcp_read_sock()
> how it's supposed to be used. Also, the less parameters to the function,
> the better.
> 
> However I'm OK for the !timeo before release_sock/lock_sock. I just
> don't know if we can put the rest of the if above or not. I don't
> know what changes we're supposed to collect by doing release_sock/
> lock_sock before the if().

Only the (!timeo) can be above. Other conditions must be checked after
the release/lock.


Thank you


