Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0BIQnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:43:32 -0500
Received: from mail-forward2.uio.no ([129.240.10.71]:48924 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0BIQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:43:31 -0500
Message-ID: <4B718FF4.6040906@simula.no>
Date: Tue, 09 Feb 2010 17:40:20 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: Damian Lukowski <damian@tvk.rwth-aachen.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
Subject: Re: [net-next PATCH v2 2/3] net: TCP thin linear timeouts
References: <4B701EE2.1000006@simula.no> <4B707901.50905@tvk.rwth-aachen.de>
In-Reply-To: <4B707901.50905@tvk.rwth-aachen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 1 sum rcpts/h 11 sum msgs/h 1 total rcpts 762 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 678C6A9C1A5F98CCADA7CE9E19FA11DE1FDFACB6
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 12 total 18984 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2010 09:50 PM, Damian Lukowski wrote:
>>  out_reset_timer:
>> -	icsk->icsk_rto = min(icsk->icsk_rto << 1, TCP_RTO_MAX);
>> +	/* If stream is thin, use linear timeouts. Since 'icsk_backoff' is
>> +	 * used to reset timer, set to 0. Recalculate 'icsk_rto' as this
>> +	 * might be increased if the stream oscillates between thin and thick,
>> +	 * thus the old value might already be too high compared to the value
>> +	 * set by 'tcp_set_rto' in tcp_input.c which resets the rto without
>> +	 * backoff. Limit to TCP_THIN_LT_RETRIES before initiating exponential
>> +	 * backoff behaviour to avoid continue hammering linear-timeout 
>> +	 * retransmissions into a black hole*/
>> +	if ((tp->thin_lt || sysctl_tcp_force_thin_linear_timeouts) &&
>> +	    tcp_stream_is_thin(sk) && sk->sk_state == TCP_ESTABLISHED &&
>> +	    icsk->icsk_retransmits <= TCP_THIN_LT_RETRIES) {
>> +		icsk->icsk_backoff = 0;
> 
> Hi,
> I think, this value should be at least 1, as icsk_backoff
> might be decreased to -1 and used for bit-shifting in tcp_v4_err().
> A lower boundary check might be even better.

Hi

Thanks for the feedback.

As far as I can see, the check a couple of lines above the decrementation
stops the icsk->icsk_backoff from being decremented if already zero.
Beyond that I cannot find any more places where this situation may arise.
Please correct me if I'm wrong and a boundary check is indeed warranted.


Excerpt from tcp_ipv4.c
------------------
                if (seq != tp->snd_una  || !icsk->icsk_retransmits ||
                    !icsk->icsk_backoff)
                        break;

                icsk->icsk_backoff--;
                inet_csk(sk)->icsk_rto = __tcp_set_rto(tp) <<
                                         icsk->icsk_backoff;
------------------

Best regards,
Andreas
