Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZBYCgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZBYCgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZBYCgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:36:08 -0500
Received: from mga12.intel.com ([143.182.124.36]:15125 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753060AbZBYCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:36:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,262,1233561600"; 
   d="scan'208";a="114088131"
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
	layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
In-Reply-To: <20090224181153.06aa1fbd@nehalam>
References: <1235525270.2604.483.camel@ymzhang>
	 <20090224181153.06aa1fbd@nehalam>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Feb 2009 10:35:43 +0800
Message-Id: <1235529343.2604.499.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 18:11 -0800, Stephen Hemminger wrote:
> On Wed, 25 Feb 2009 09:27:49 +0800
> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> 
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
> > 
> > Currently kernel has backlog to support a similar capability, but process_backlog still
> > runs on the receiving cpu. I enhance backlog by adding a new input_pkt_alien_queue to
> > softnet_data. Receving cpu collects packets and link them into skb list, then delivers
> > the list to the ﻿input_pkt_alien_queue of other cpu. process_backlog picks up the skb list
> > from ﻿input_pkt_alien_queue when ﻿input_pkt_queue is empty.
> > 
> > NIC driver could use this capability like below step in NAPI RX cleanup function.
> > 1) Initiate a local var struct sk_buff_head skb_head;
> > 2) In the packet collection loop, just calls netif_rx_queue or __skb_queue_tail(skb_head, skb)
> > to add skb to the list;
> > 3) Before exiting, calls raise_netif_irq to submit the skb list to specific cpu.
> > 
> > Enlarge /proc/sys/net/core/netdev_max_backlog and netdev_budget before testing.
> > 
> > I tested my patch on top of 2.6.28.5. The improvement is about 43%.
> > 
> > Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > 
> > ---
Thanks for your comments.

> 
> You can't safely put packets on another CPU queue without adding a spinlock.
﻿input_pkt_alien_queue is a struct sk_buff_head which has a spinlock. We use
that lock to protect the queue.

> And if you add the spinlock, you drop the performance back down for your
> device and all the other devices.
My testing shows 43% improvement. As multi-core machines are becoming
popular, we can allocate some core for packet collection only.

I use the spinlock carefully. The deliver cpu locks it only when ﻿input_pkt_queue
is empty, and just merges the list to ﻿input_pkt_queue. Later skb dequeue needn't
hold the spinlock. In the other hand, the original receving cpu dispatches a batch
of skb (64 packets with IXGBE default) when holding the lock once.

>  Also, you will end up reordering
> packets which hurts single stream TCP performance.
Would you like to elaborate the scenario? Does your speaking mean multi-queue
also hurts ﻿single stream TCP performance when we bind multi-queue(interrupt) to
different cpu?

> 
> Is this all because the hardware doesn't do MSI-X
IXGBE supports MSI-X and I enables it when testing. ﻿ The receiver has 16 multi-queue,
so 16 irq numbers. I bind 2 irq numbers per logical cpu of one physical cpu.

>  or are you testing only
> a single flow. 
What does a single flow mean here? One sender? I do start one sender for testing because
I couldn't get enough hardware.

In addition, my patch doesn't change old interface, so there would be no performance
hurt to old drivers.

yanmin


