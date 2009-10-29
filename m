Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZJ2Pne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZJ2Pne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZJ2Pnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:43:33 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:33085 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbZJ2Pnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:43:31 -0400
Message-ID: <69812160e5682c9fb4acba05bc082664.squirrel@webmail.uio.no>
Date: Thu, 29 Oct 2009 16:43:34 +0100
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
From: apetlund@simula.no
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Andreas Petlund" <apetlund@simula.no>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>,
       "Netdev" <netdev@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       "David Miller" <davem@davemloft.net>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-UiO-Ratelimit-Test: rcpts/h 28 msgs/h 4 sum rcpts/h 39 sum msgs/h 6 total rcpts 432 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: BFD689FD37BEFA961EAC0C6720DAD2FD645123AC
X-UiO-SPAM-Test: remote_host: 129.240.4.214 spam_score: -49 maxlevel 80 minaction 1 bait 0 mail/h: 314 total 1919991 max/h 678 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andreas Petlund a écrit :
>
>> The removal of exponential backoff on a general basis has been
>> investigated and discussed already, for instance here:
>> http://ccr.sigcomm.org/online/?q=node/416
>> Such steps are, however considered drastic, and I agree that caution
must be made to thoroughly investigate the effects of such changes. The
changes introduced by the proposed patches, however, are not
default
>> behaviour, but an option for applications that suffer from the
>> thin-stream TCP increased retransmission latencies. They will, as such,
not affect all streams. In addition, the changes will only be active
for
>> streams which are perpetually thin or in the early phase of expanding
their cwnd. Also, experiments performed on congested bottlenecks with
tail-drop queues show very little (if any at all) effect on goodput for
the modified scenario compared to a scenario with unmodified TCP
streams.
>> Graphs both for latency-results and fairness tests can be found here:
http://folk.uio.no/apetlund/lktmp/
>
> There should be a limit to linear timeouts, to say ... no more than 6
retransmits
> (eventually tunable), then switch to exponential backoff. Maybe your
patch
> already implement such heuristic ?
>

The limitation you suggest to the linear timeouts makes very good sense.
Our experiments performed on the Internet indicate that it is extremely
rare that more than 6 retransmissions are needed to recover. It is not
included in the current patch, so I will include this in the next
iteration.

> True link collapses do happen, it would be good if not all streams
wakeup
> in the same
> second and make recovery very slow.
>

Each stream will have its own schedule for wakeup, so such events will
still be subject to coincidence. The timer granularity of the TCP wakeup
timer will also influence how many streams will wake at the same time. The
experiments we have performed on severely congested bottlenecks (link
above) indicate that the modifications will not create a large negative
effect. In fact, when goodput is drastically reduced due to severe
overload, regular TCP and the LT and dupACK modifications seem to perform
nearly identically. Other scenarios may exist where different effects can
be observed, and I am open to suggestions for further testing.

> Thats too easy to accept possibly dangerous features with the excuse of
saying
> "It wont be used very much", because you cannot predict the future.

I agree that it is no argument to say that it won't be used much; indeed,
my hope is that it will be used much. However, our experiments indicate no
negative effects while showing a large improvement on retransmission
latency for the scenario in question. I therefore think that the option
for such an improvement should be made available for time-dependent
thin-stream applications.

-AP





