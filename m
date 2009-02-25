Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbZBYCMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbZBYCMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbZBYCL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:11:58 -0500
Received: from mail.vyatta.com ([76.74.103.46]:34225 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZBYCL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:11:57 -0500
Date: Tue, 24 Feb 2009 18:11:53 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
 layer
Message-ID: <20090224181153.06aa1fbd@nehalam>
In-Reply-To: <1235525270.2604.483.camel@ymzhang>
References: <1235525270.2604.483.camel@ymzhang>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.15.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 09:27:49 +0800
"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

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
> 
> Currently kernel has backlog to support a similar capability, but process_backlog still
> runs on the receiving cpu. I enhance backlog by adding a new input_pkt_alien_queue to
> softnet_data. Receving cpu collects packets and link them into skb list, then delivers
> the list to the ﻿input_pkt_alien_queue of other cpu. process_backlog picks up the skb list
> from ﻿input_pkt_alien_queue when ﻿input_pkt_queue is empty.
> 
> NIC driver could use this capability like below step in NAPI RX cleanup function.
> 1) Initiate a local var struct sk_buff_head skb_head;
> 2) In the packet collection loop, just calls netif_rx_queue or __skb_queue_tail(skb_head, skb)
> to add skb to the list;
> 3) Before exiting, calls raise_netif_irq to submit the skb list to specific cpu.
> 
> Enlarge /proc/sys/net/core/netdev_max_backlog and netdev_budget before testing.
> 
> I tested my patch on top of 2.6.28.5. The improvement is about 43%.
> 
> Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> 
> ---

You can't safely put packets on another CPU queue without adding a spinlock.
And if you add the spinlock, you drop the performance back down for your
device and all the other devices. Also, you will end up reordering
packets which hurts single stream TCP performance.

Is this all because the hardware doesn't do MSI-X or are you testing only
a single flow. 
