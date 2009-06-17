Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZFQUxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZFQUxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZFQUx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:53:28 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57182 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZFQUx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:53:28 -0400
Message-ID: <4A3957A1.5030407@gmail.com>
Date: Wed, 17 Jun 2009 22:52:49 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <alpine.DEB.2.00.0906171227040.1089@chino.kir.corp.google.com> <4A394F27.8060308@gmail.com> <alpine.DEB.2.00.0906171326120.4786@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906171326120.4786@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 17 Jun 2009 22:52:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes a écrit :
> On Wed, 17 Jun 2009, Eric Dumazet wrote:
> 
>>> ipv4: don't warn about skb ack allocation failures
>>>
>>> tcp_send_ack() will recover from alloc_skb() allocation failures, so avoid 
>>> emitting warnings.
>>>
>>> Signed-off-by: David Rientjes <rientjes@google.com>
>>> ---
>>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>>> --- a/net/ipv4/tcp_output.c
>>> +++ b/net/ipv4/tcp_output.c
>>> @@ -2442,7 +2442,7 @@ void tcp_send_ack(struct sock *sk)
>>>  	 * tcp_transmit_skb() will set the ownership to this
>>>  	 * sock.
>>>  	 */
>>> -	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
>>> +	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC | __GFP_NOWARN);
>>>  	if (buff == NULL) {
>>>  		inet_csk_schedule_ack(sk);
>>>  		inet_csk(sk)->icsk_ack.ato = TCP_ATO_MIN;
>> I count more than 800 GFP_ATOMIC allocations in net/ tree.
>>
>> Most (if not all) of them can recover in case of failures.
>>
>> Should we add __GFP_NOWARN to all of them ?
>>
> 
> Yes, if they are recoverable without any side effects.  Otherwise, they 
> will continue to emit page allocation failure messages which cause users 
> to waste their time when they recognize a problem of an unknown 
> seriousness level in both reporting the issue and looking for resulting 
> corruption.  The __GFP_NOWARN annotation suppresses such warnings for 
> those very reasons.

Then why emit the warning at first place ?

Once we patch all call sites to use GFP_ATOMIC | __GFP_NOWARN, I bet 99% 
GFP_ATOMIC allocations in kernel will use it, so we go back to silent mode.

If a GFP_ATOMIC call site *cannot* use __GFP_NOWARN, it will either :

- call panic()
- crash with a nice stack trace because caller was not aware NULL could be
returned by kmalloc()


Maybe GFP_ATOMIC should include __GFP_NOWARN

#define GFP_ATOMIC  (__GFP_HIGH)
->
#define GFP_ATOMIC  (__GFP_HIGH | __GFP_NOWARN)

