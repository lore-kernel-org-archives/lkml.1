Return-Path: <linux-kernel-owner+w=401wt.eu-S1760440AbZBYHU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbZBYHU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbZBYHUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:20:45 -0500
Received: from mga05.intel.com ([192.55.52.89]:43362 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767AbZBYHUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:20:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,264,1233561600"; 
   d="scan'208";a="668333577"
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
	layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20090225063656.GA32635@gondor.apana.org.au>
References: <20090225063656.GA32635@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Feb 2009 15:20:23 +0800
Message-Id: <1235546423.2604.556.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 14:36 +0800, Herbert Xu wrote:
> Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > ﻿Subject: hand off skb list to other cpu to submit to upper layer
> > From: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > 
> > Recently, I am investigating an ip_forward performance issue with 10G IXGBE NIC.
> > I start the testing on 2 machines. Every machine has 2 10G NICs. The 1st one seconds
> > packets by pktgen. The 2nd receives the packets from one NIC and forwards them out
> > from the 2nd NIC. As NICs supports multi-queue, I bind the queues to different logical
> > cpu of different physical cpu while considering cache sharing carefully.
> > 
> > Comparing with sending speed on the 1st machine, the forward speed is not good, only
> > about 60% of sending speed. As a matter of fact, IXGBE driver starts NAPI when interrupt
> > arrives. When ip_forward=1, receiver collects a packet and forwards it out immediately.
> > So although IXGBE collects packets with NAPI, the forwarding really has much impact on
> > collection. As IXGBE runs very fast, it drops packets quickly. The better way for
> > receiving cpu is doing nothing than just collecting packets.
> 
Thanks for your comments.

> This doesn't make sense.  With multiqueue RX, every core should be
> working to receive its fraction of the traffic and forwarding them
> out.
I never say the core can't receive and forward packets at the same time.
I mean the performance isn't good.

>   So you shouldn't have any idle cores to begin with.  The fact
> that you do means that multiqueue RX hasn't maximised its utility,
> so you should tackle that instead of trying redirect traffic away
> from the cores that are receiving.
>From Stephen's explanation, ﻿the packets are being sent with different SRC/DST address
pairs by which harware delivers packets to different queues. we couldn't expect
NIC always puts packets into queues evenly.

The behavior is IXGBE is very fast and cpu couldn't collect packets in time if it
collects packets and forwards them at the same time. That causes IXGBE drops packets.

> 
> Of course for NICs that don't support multiqueue RX, or where the
> number of RX queues is less than the number of cores, then a scheme
> like yours may be useful.
IXGBE NIC does support a large number of RX queues. By default, it creates
CPU_NUM queues. But the performance is not good when we bind queues to
cpu evenly. One reason is cache miss/ping-pong. The forwarder machine has
2 physical cpu and every cpu has 8 logical threads. All 8 logical cpu share
the last level cache. With my ip_forward testing by pktgen, binding queues
to 8 logical cpu of a physical cpu could have 40% improvement than binding
queues to 16 logical cpu. So the optimization scenario just needs IXGBE drivers
create 8 queues.

If the machines might have a couple of NICs and every NIC has CPU_NUM queues,
binding them evenly might cause more cache-miss/ping-pong. I didn't test
multiple receiving NICs scenario as I couldn't get enough hardware.

Yanmin


