Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0BUWba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:31:30 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48007 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0BUWb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:31:29 -0500
Date: Mon, 22 Feb 2010 00:31:27 +0200 (EET)
From: "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@melkinpaasi.cs.helsinki.fi
To: Pavel Machek <pavel@ucw.cz>
cc: Andreas Petlund <apetlund@simula.no>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
In-Reply-To: <20100221102102.GB1311@ucw.cz>
Message-ID: <alpine.DEB.2.00.1002220019590.23201@melkinpaasi.cs.helsinki.fi>
References: <4B7AAE60.3070305@simula.no> <20100221102102.GB1311@ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Pavel Machek wrote:

> Hi!
> 
> > +After analysing a large number of time-dependent interactive
> > +applications, we have seen that they often produce thin streams
> > +and also stay with this traffic pattern throughout its entire
> > +lifespan. The combination of time-dependency and the fact that the
> > +streams provoke high latencies when using TCP is unfortunate.
> > +
> > +In order to reduce application-layer latency when packets are lost,
> > +a set of mechanisms has been made, which address these latency issues
> > +for thin streams. In short, if the kernel detects a thin stream,
> > +the retransmission mechanisms are modified in the following manner:
> > +
> > +1) If the stream is thin, fast retransmit on the first dupACK.
> > +2) If the stream is thin, do not apply exponential backoff.
> 
> 2) seems very dangerous/unfair. If network  congestion is caused just
> by thin streams, will the network just fall apart?

...Network will not fall apart. Two possible cases:

a) cwnd > 1 segment, on RTO the window is reduced, thus the sender backs 
off regardless of exponential backoff.
b) All flows have window of 1 already... Well, what do you suggest? I'd 
say that obviously the network is seriously underprovisioned for the 
workload and since the bottleneck can only serve some of them anyway 
dropping the rest, no useless work gets done at the bottleneck. RTT 
estimator then gets a new samples whenever a flow belongs into the lucky 
group. In case any unnecessary retransmission happened (if there was 
very dramatic and sudden increase transient in the workload) they won't 
happen thereafter (unless we increase the workload toward infinity).

...Thus no problem of "falling apart".

-- 
 i.
