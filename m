Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZCMGoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZCMGoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 02:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZCMGny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 02:43:54 -0400
Received: from mga10.intel.com ([192.55.52.92]:64507 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbZCMGnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 02:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,355,1233561600"; 
   d="scan'208";a="438594979"
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to
	submit to upper layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>
In-Reply-To: <1236866906.3221.11.camel@achroite>
References: <1236761624.2567.442.camel@ymzhang>
	 <877i2wfh1l.fsf@basil.nowhere.org>  <1236845792.2567.484.camel@ymzhang>
	 <1236866906.3221.11.camel@achroite>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Mar 2009 14:43:22 +0800
Message-Id: <1236926602.2567.528.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 14:08 +0000, Ben Hutchings wrote:
> On Thu, 2009-03-12 at 16:16 +0800, Zhang, Yanmin wrote:
> > On Wed, 2009-03-11 at 12:13 +0100, Andi Kleen wrote:
> [...]
> > >  and just use the hash function on the
> > > NIC.
> > Sorry. I can't understand what the hash function of NIC is. Perhaps NIC hardware has something
> > like hash function to decide the RX queue number based on SRC/DST?
> 
> Yes, that's exactly what they do.  This feature is sometimes called
> Receive-Side Scaling (RSS) which is Microsoft's name for it.  Microsoft
> requires Windows drivers performing RSS to provide the hash value to the
> networking stack, so Linux drivers for the same hardware should be able
> to do so too.
Oh, I didn't know the background. I need study more about network.
Thanks for explain it.

> 
> > >  Have you considered this for forwarding too?
> > Yes. originally, I plan to add a tx_num under the same sysfs directory, so admin could
> > define that all packets received from a RX queue should be sent out from a specific TX queue.
> 
> The choice of TX queue can be based on the RX hash so that configuration
> is usually unnecessary.
I agree. I double checked the latest codes of tree ﻿net-next-2.6 and function skb_tx_hash
is enough. 

> 
> > So struct sk_buff->queue_mapping would be a union of 2 sub-members, rx_num and tx_num. But
> > ﻿sk_buff->queue_mapping is just a u16 which is a small type. We might use the most-significant
> > bit of ﻿sk_buff->queue_mapping as a flag as rx_num and tx_num wouldn't exist at the
> > same time.
> > 
> > >  The trick here would
> > > be to try to avoid reordering inside streams as far as possible,
> > It's not to solve reorder issue. The start point is 10G NIC is very fast. We need some cpu
> > work on packet receiving dedicately. If they work on other things, NIC might drop packets
> > quickly.
> 

> Aggressive power-saving causes far greater latency than context-
> switching under Linux.
Yes when NIC is free mostly. When NIC is busy, it wouldn't enter power-saving mode.
Performance testing is used to turn off all power-saving modes. :)

>   I believe most 10G NICs have large RX FIFOs to
> mitigate against this.  Ethernet flow control also helps to prevent
> packet loss.
I guess NIC might allocate resources evenly for all queues, at least by default. If considering
packet sending burst with the same SRC/DST, a specific queue might be full quickly. I
instrumented driver and kernel to print out packet receiving and forwarding. As The latest IXGBE
driver gets a packet and forwards it immediately, I think most packets are dropped by hardware
because cpu doesn't collects packets quickly when the specific receiving queue is full. By
comparing the sending speed and forwarding speed, we could get the dropping rate easily.

My experiment shows receving cpu idle is more than 50% and cpu does often collect all packets
till the specific queue is empty. I think that's because pktgen switches to a new SRC/DST to
produce another burst to fill other queues quickly.

It's hard to say cpu is slower than NIC because they work on different parts of the full
receiving/processing procedures. But we need cpu collect packets ASAP.


> > The sysfs interface is just to facilitate NIC drivers. If there is no the sysfs interface,
> > driver developers need implement it with parameters which are painful.
> [...]
> 
> Or through the ethtool API, which already has some multiqueue control
> operations.
That's an alternative approach to configure it. If checking the sample patch on driver,
we can find the change is very small.

Thanks for your kind comments.

Yanmin


