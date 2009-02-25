Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbZBYGhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbZBYGhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZBYGhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:37:04 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49252 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbZBYGhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:37:01 -0500
Date: Wed, 25 Feb 2009 14:36:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
	layer
Message-ID: <20090225063656.GA32635@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235525270.2604.483.camel@ymzhang>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> ﻿Subject: hand off skb list to other cpu to submit to upper layer
> From: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> 
> Recently, I am investigating an ip_forward performance issue with 10G IXGBE NIC.
> I start the testing on 2 machines. Every machine has 2 10G NICs. The 1st one seconds
> packets by pktgen. The 2nd receives the packets from one NIC and forwards them out
> from the 2nd NIC. As NICs supports multi-queue, I bind the queues to different logical
> cpu of different physical cpu while considering cache sharing carefully.
> 
> Comparing with sending speed on the 1st machine, the forward speed is not good, only
> about 60% of sending speed. As a matter of fact, IXGBE driver starts NAPI when interrupt
> arrives. When ip_forward=1, receiver collects a packet and forwards it out immediately.
> So although IXGBE collects packets with NAPI, the forwarding really has much impact on
> collection. As IXGBE runs very fast, it drops packets quickly. The better way for
> receiving cpu is doing nothing than just collecting packets.

This doesn't make sense.  With multiqueue RX, every core should be
working to receive its fraction of the traffic and forwarding them
out.  So you shouldn't have any idle cores to begin with.  The fact
that you do means that multiqueue RX hasn't maximised its utility,
so you should tackle that instead of trying redirect traffic away
from the cores that are receiving.

Of course for NICs that don't support multiqueue RX, or where the
number of RX queues is less than the number of cores, then a scheme
like yours may be useful.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
