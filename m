Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0BJRdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:33:36 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:39415 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028Ab0BJRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:33:33 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
X-IronPort-AV: E=Sophos;i="4.49,445,1262559600";   d="scan'208";a="44556714"
To: Andreas Petlund <apetlund@simula.no>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       =?utf-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
Subject: Re: [net-next PATCH v2 2/3] net: TCP thin linear timeouts
References: <4B701EE2.1000006@simula.no> <4B707901.50905@tvk.rwth-aachen.de>
 <4B718FF4.6040906@simula.no>
Date: Wed, 10 Feb 2010 18:33:28 +0100
From: Damian Lukowski <damian@tvk.rwth-aachen.de>
Message-id: <op.u7w9p2qdp498uc@nexus>
In-reply-to: <4B718FF4.6040906@simula.no>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2010, 17:40 Uhr, schrieb Andreas Petlund <apetlund@simula.no>:

> On 02/08/2010 09:50 PM, Damian Lukowski wrote:
>>>  out_reset_timer:
>>> -	icsk->icsk_rto = min(icsk->icsk_rto << 1, TCP_RTO_MAX);
>>> +	/* If stream is thin, use linear timeouts. Since 'icsk_backoff' is
>>> +	 * used to reset timer, set to 0. Recalculate 'icsk_rto' as this
>>> +	 * might be increased if the stream oscillates between thin and  
>>> thick,
>>> +	 * thus the old value might already be too high compared to the value
>>> +	 * set by 'tcp_set_rto' in tcp_input.c which resets the rto without
>>> +	 * backoff. Limit to TCP_THIN_LT_RETRIES before initiating  
>>> exponential
>>> +	 * backoff behaviour to avoid continue hammering linear-timeout
>>> +	 * retransmissions into a black hole*/
>>> +	if ((tp->thin_lt || sysctl_tcp_force_thin_linear_timeouts) &&
>>> +	    tcp_stream_is_thin(sk) && sk->sk_state == TCP_ESTABLISHED &&
>>> +	    icsk->icsk_retransmits <= TCP_THIN_LT_RETRIES) {
>>> +		icsk->icsk_backoff = 0;
>>
>> Hi,
>> I think, this value should be at least 1, as icsk_backoff
>> might be decreased to -1 and used for bit-shifting in tcp_v4_err().
>> A lower boundary check might be even better.
>
> Hi
>
> Thanks for the feedback.
>
> As far as I can see, the check a couple of lines above the decrementation
> stops the icsk->icsk_backoff from being decremented if already zero.
> Beyond that I cannot find any more places where this situation may arise.
> Please correct me if I'm wrong and a boundary check is indeed warranted.

Oops, you are right, of course ...
I just had in mind, that a thin stream might also be a candidate for
backoff reversion when connectivity breaks down, that's why I said
"at least 1". And I really have forgotten the already existing check,  
sorry.
So, setting icsk_backoff = 0 will prevent a backoff reversion, but that's
ok, as the RTO is not doubled in the first place.

It might have been an issue, if you had not used __tcp_set_rto() but left
the value unchanged *and* a non-thin stream became thin at some point in
the RTO retransmission phase (if that is even possible).

Damian
