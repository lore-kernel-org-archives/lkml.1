Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZJ3Nx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZJ3Nx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbZJ3Nxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:53:55 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:53553 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbZJ3Nxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:53:54 -0400
Message-ID: <f7b4caf3a5b5c906cb8d508239455322.squirrel@webmail.uio.no>
Date: Fri, 30 Oct 2009 14:53:58 +0100
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
From: apetlund@simula.no
To: "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>
Cc: "Andreas Petlund" <apetlund@simula.no>,
       "William Allen Simpson" <william.allen.simpson@gmail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "ilpo.jarvinen@helsinki.fi" <ilpo.jarvinen@helsinki.fi>,
       "davem@davemloft.net" <davem@davemloft.net>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 10 sum msgs/h 1 total rcpts 461 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 15D9E94CD2A2FC690C33984C7B647F1E3A1350AB
X-UiO-SPAM-Test: remote_host: 129.240.4.214 spam_score: -49 maxlevel 80 minaction 1 bait 0 mail/h: 436 total 1924971 max/h 678 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andreas Petlund schrieb:
>> Den 28. okt. 2009 kl. 04.09 skrev William Allen Simpson:
>>> Andreas Petlund wrote:
>>>> +/* Determines whether this is a thin stream (which may suffer from +
* increased latency). Used to trigger latency-reducing mechanisms. + */
>>>> +static inline unsigned int tcp_stream_is_thin(const struct
>>>> tcp_sock *tp)
>>>> +{
>>>> +	return tp->packets_out < 4;
>>>> +}
>>>> +
>>> This bothers me a bit.  Having just looked at your Linux presentation,
and not (yet) read your papers, it seems much of your justification was
>>> with 1 packet per RTT.  Here, you seem to be concentrating on 4,
probably
>>> because many implementations quickly ramp up to 4.
>> The limit of 4 packets in flight is based on the fact that less than 4
packets in flight makes fast retransmissions impossible, thus limiting the
retransmit options to timeout-retransmissions. The criterion is
>
> There is Limited Transmit! So this is generally not true.
>> therefore as conservative as possible while still serving its purpose.
If further losses occur, the exponential backoff will increase latency
further. The concept of using this limit is also discussed in the
Internet draft for Early Retransmit by Allman et al.:
>> http://www.icir.org/mallman/papers/draft-ietf-tcpm-early-rexmt-01.txt
>
> This ID is covering exactly the cases which Limited Transmit does not
cover and works "automagically" without help of application. So why not
just implement this ID?

As Ilpo writes, the mechanism we propose is simpler than the ID, and
slightly more aggressive. The reason why we chose this is as follows: 1)
The ID and Limited Transmit tries to prevent retransmission timeouts by
retransmitting more aggressively, thus keeping the congestion window open
even though congestion may be the limiting factor. If their limiting
conditions change, they still have higher sending rates available. The
thin-stream applications are not limited by congestion control. There is
therefore no motivation to prevent retransmission timeouts in order to
keep the congestion window open because in the thin-stream scenario, a
larger window is not needed, but we retransmit early only to reduce
application-layer latencies. 2) Our suggested implementation is simpler.
3) I believe that the reason why the ID has not been implemented in Linux
is that the motivation did not justify the achieved result. We have
analysed a wide range of time-dependent applications and found that they
very often produce thin streams due to transmissions being triggered by
human interaction. This changes the motivational picture since a thin
stream is an indicator of time-dependency.

Regards,
Andreas







