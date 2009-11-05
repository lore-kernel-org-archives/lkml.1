Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZKENe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZKENe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZKENez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:34:55 -0500
Received: from mail-forward2.uio.no ([129.240.10.71]:33664 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbZKENey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:34:54 -0500
Message-ID: <4AF2D47F.4030701@simula.no>
Date: Thu, 05 Nov 2009 14:34:55 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
CC: William Allen Simpson <william.allen.simpson@gmail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "ilpo.jarvinen@helsinki.fi" <ilpo.jarvinen@helsinki.fi>,
       "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
References: <f7b4caf3a5b5c906cb8d508239455322.squirrel@webmail.uio.no> <4AEB0512.4010804@nets.rwth-aachen.de>
In-Reply-To: <4AEB0512.4010804@nets.rwth-aachen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 1 sum rcpts/h 8 sum msgs/h 2 total rcpts 502 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: FBB48B2E7C22E9CA32F4ADE1CA0937098A40F49F
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 23 total 5508 max/h 49 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Hannemann wrote:
> Both mechanism prevent retransmission timeouts, thereby reducing latency.
> Who cares, that they were motivated by performance?

The essence of motivation is that there exist an incentive for performing an 
action. If the motivation for fast retransmitting earlier is to keep the cwnd 
open for a greedy application with small time-dependency, the question may be 
posed whether it is worth the effort of the proposed changes. With the 
thin-stream applications, we have confirmed that this is very often an 
indication of time-dependent/interactive applications (like SSH-text sessions, 
RDP, sensor networks, stock trading systems, interactive games etc). We have 
further shown that such applications are prone to lag upon retransmissions due 
to the inadequacies of TCP to deal with thin streams. We have also shown that 
by performing the proposed adjustments, we can drastically improve the 
situation. 

Since we now know that the modifications can drastically improve the user 
experience, the motivation/incentive for implementing the modifications is 
increased. 

> I agree, that you are more aggressive, and that your scheme may have
> latency advantages, at least for the Limited Transmit case. And there are
> probably good reasons for your proposal. But I really think you should
> bring your proposal up in IETF TCPM WG. I have the feeling that there are
> a lot of corner cases we didn't think of.
> 
> One example: Consider standard NewReno non-SACK enabled flow:
> For some reasons two data packets get reordered.
> The TCP sender will produce a dupACK and an ACK.
> The dupACK will trigger (because of your logic) a spurious retransmit.
> The spurious retransmit will trigger a dupACK.
> This dupACK will again trigger a spurious retransmit.
> And this game will continue, unless a packet is dropped by coincidence.

Such an effect will be extremely rare. It will depend on the application 
producing an extremely even flow of packets with just the right 
interarrival time, and also on reordering of data (which also will 
happen very seldom when the number of packets in flight are so low). 
Even though it can happen, the data flow will progress (with spurious 
retransmissions). The effect will stop as soon as the application sends 
more than 4 segments in an RTT (which will disable the thin-stream 
modifications) or less than 1 (which will cause all segments to be 
successfully ACKed), or if, as you say, a packet is dropped.

I will be thankful for more input on eventual corner cases and also on 
test cases that we may perform to evaluate the modifications for 
scenarios that are of concern.

Best regards,
Andreas




