Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZJ2Nvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZJ2Nvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZJ2Nvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:51:36 -0400
Received: from mail-forward1.uio.no ([129.240.10.70]:48416 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZJ2Nvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:51:35 -0400
References: <4AE72075.4070702@simula.no> <4AE7B5D6.8070001@gmail.com>
In-Reply-To: <4AE7B5D6.8070001@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Message-Id: <38EB8C31-A96A-4C5C-88D8-8F6BF0E9225F@simula.no>
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi, davem@davemloft.net
From: Andreas Petlund <apetlund@simula.no>
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
Date: Thu, 29 Oct 2009 14:51:07 +0100
To: William Allen Simpson <william.allen.simpson@gmail.com>
X-Mailer: Apple Mail (2.1076)
X-UiO-Ratelimit-Test: rcpts/h 30 msgs/h 6 sum rcpts/h 32 sum msgs/h 6 total rcpts 392 max rcpts/h 30 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-4.5, required=5.0, autolearn=disabled, TVD_RCVD_IP=0.502,UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 7B3AFF4188FDCDCE939481D62678A3689ADCCF01
X-UiO-SPAM-Test: remote_host: 213.23.10.108 spam_score: -44 maxlevel 80 minaction 2 bait 0 mail/h: 6 total 6 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Den 28. okt. 2009 kl. 04.09 skrev William Allen Simpson:

> Andreas Petlund wrote:
>> +/* Determines whether this is a thin stream (which may suffer from
>> + * increased latency). Used to trigger latency-reducing mechanisms.
>> + */
>> +static inline unsigned int tcp_stream_is_thin(const struct  
>> tcp_sock *tp)
>> +{
>> +	return tp->packets_out < 4;
>> +}
>> +
> This bothers me a bit.  Having just looked at your Linux presentation,
> and not (yet) read your papers, it seems much of your justification  
> was
> with 1 packet per RTT.  Here, you seem to be concentrating on 4,  
> probably
> because many implementations quickly ramp up to 4.
>

The limit of 4 packets in flight is based on the fact that less than 4  
packets in flight makes fast retransmissions impossible, thus limiting  
the retransmit options to timeout-retransmissions. The criterion is  
therefore as conservative as possible while still serving its purpose.  
If further losses occur, the exponential backoff will increase latency  
further. The concept of using this limit is also discussed in the  
Internet draft for Early Retransmit by Allman et al.:
http://www.icir.org/mallman/papers/draft-ietf-tcpm-early-rexmt-01.txt

> But there's a fair amount of experience showing that ramping to 4 is
> problematic on congested paths, especially wireless networks.  Fast
> retransmit in that case would be disastrous.

First, the modifications implemented in the patch is explicitly  
enabled only for applications where the developer knows that streams  
will be thin, thus only a small subset of the streams will apply the  
modifications. Second, experiments we have performed to try to map the  
effect on a congested bottleneck both with and without the  
modifications show that no measurable effect is recorded.

Graphs presenting results from experiments performed to analyse  
latency and fairness issues can be found here:
http://folk.uio.no/apetlund/lktmp/

> Once upon a time, I worked on a fair number of interactive games a  
> decade
> or so ago.  And agree that this can be a problem, although I've never
> been a fan of turning off the Nagle algorithm.  My solution has always
> been a heartbeat, rather than trying to shoehorn this into TCP.
>

The beginning of this patch was an analysis of game traffic from the  
Norwegian game company Funcom. They use TCP for all their MMOGs as  
does, for example, Blizzard for WoW. Our analysis showed that many  
players experienced extreme latencies, and the source of this was  
tracked to the effects that we discuss here. As long as a wide range  
of time-dependent applications choose to use TCP, and we can improve  
conditions for their needs without jeopardising other functionality,  
we think that this will add value to the TCP stack.

> Also, I've not seen any discussion on the end-to-end interest list.

It will be enlightening to have a discussion on end-to-end about this  
topic.
