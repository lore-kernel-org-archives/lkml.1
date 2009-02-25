Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZBYFwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZBYFwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 00:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZBYFvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 00:51:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:23702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbZBYFvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 00:51:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,263,1233561600"; 
   d="scan'208";a="389563059"
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
	layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
In-Reply-To: <20090224211859.0ee8c632@nehalam>
References: <1235525270.2604.483.camel@ymzhang>
	 <20090224181153.06aa1fbd@nehalam> <1235529343.2604.499.camel@ymzhang>
	 <20090224211859.0ee8c632@nehalam>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Feb 2009 13:51:26 +0800
Message-Id: <1235541086.2604.524.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 21:18 -0800, Stephen Hemminger wrote:
> On Wed, 25 Feb 2009 10:35:43 +0800
> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> 
> > On Tue, 2009-02-24 at 18:11 -0800, Stephen Hemminger wrote:
> > > On Wed, 25 Feb 2009 09:27:49 +0800
> > > "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > > ﻿Subject: hand off skb list to other cpu to submit to upper layer
> > > > From: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > > > 
> > > > Recently, I am investigating an ip_forward performance issue with 10G IXGBE NIC.
> > > > I start the testing on 2 machines. Every machine has 2 10G NICs. The 1st one seconds
> > > > packets by pktgen. The 2nd receives the packets from one NIC and forwards them out
> > > > from the 2nd NIC. As NICs supports multi-queue, I bind the queues to different logical
> > > > cpu of different physical cpu while considering cache sharing carefully.
> > > > 
> > > > Comparing with sending speed on the 1st machine, the forward speed is not good, only
> > > > about 60% of sending speed. As a matter of fact, IXGBE driver starts NAPI when interrupt
> > > > arrives. When ip_forward=1, receiver collects a packet and forwards it out immediately.
> > > > So although IXGBE collects packets with NAPI, the forwarding really has much impact on
> > > > collection. As IXGBE runs very fast, it drops packets quickly. The better way for
> > > > receiving cpu is doing nothing than just collecting packets.
> > > > 
> > > > Currently kernel has backlog to support a similar capability, but process_backlog still
> > > > runs on the receiving cpu. I enhance backlog by adding a new input_pkt_alien_queue to
> > > > softnet_data. Receving cpu collects packets and link them into skb list, then delivers
> > > > the list to the ﻿input_pkt_alien_queue of other cpu. process_backlog picks up the skb list
> > > > from ﻿input_pkt_alien_queue when ﻿input_pkt_queue is empty.
> > > > 
> > > > NIC driver could use this capability like below step in NAPI RX cleanup function.
> > > > 1) Initiate a local var struct sk_buff_head skb_head;
> > > > 2) In the packet collection loop, just calls netif_rx_queue or __skb_queue_tail(skb_head, skb)
> > > > to add skb to the list;
> > > > 3) Before exiting, calls raise_netif_irq to submit the skb list to specific cpu.
> > > > 
> > > > Enlarge /proc/sys/net/core/netdev_max_backlog and netdev_budget before testing.
> > > > 
> > > > I tested my patch on top of 2.6.28.5. The improvement is about 43%.
> > > > 
> > > > Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > > > 
> > > You can't safely put packets on another CPU queue without adding a spinlock.
> > ﻿input_pkt_alien_queue is a struct sk_buff_head which has a spinlock. We use
> > that lock to protect the queue.
> 
> I was reading netif_rx_queue() and you have it using __skb_queue_tail() which
> has no locking. 
Sorry, I need add some comments to function netif_rx_queue.

Parameter skb_queue is point to a local var, or NULL. If it points to a local var,
just like ﻿function ixgbe_clean_rx_irq of IXGBE, so we needn't protect it when
﻿using __skb_queue_tail to add new skb. If ﻿skb_queue is point to NULL, below

skb_queue = &queue->input_pkt_queue;

make it points to the local input_pkt_queue which is protected by local_irq_save.

> > > And if you add the spinlock, you drop the performance back down for your
> > > device and all the other devices.
> > My testing shows 43% improvement. As multi-core machines are becoming
> > popular, we can allocate some core for packet collection only.
> > 
> > I use the spinlock carefully. The deliver cpu locks it only when ﻿input_pkt_queue
> > is empty, and just merges the list to ﻿input_pkt_queue. Later skb dequeue needn't
> > hold the spinlock. In the other hand, the original receving cpu dispatches a batch
> > of skb (64 packets with IXGBE default) when holding the lock once.
> > 
> > >  Also, you will end up reordering
> > > packets which hurts single stream TCP performance.
> > Would you like to elaborate the scenario? Does your speaking mean multi-queue
> > also hurts ﻿single stream TCP performance when we bind multi-queue(interrupt) to
> > different cpu?
> > 
> > > 
> > > Is this all because the hardware doesn't do MSI-X
> > IXGBE supports MSI-X and I enables it when testing. ﻿ The receiver has 16 multi-queue,
> > so 16 irq numbers. I bind 2 irq numbers per logical cpu of one physical cpu.
> > 
> > >  or are you testing only
> > > a single flow. 
> > What does a single flow mean here? One sender? I do start one sender for testing because
> > I couldn't get enough hardware.
> 
> Multiple receive queues only have an performance gain if the packets are being
> sent with different SRC/DST address pairs. That is how the hardware is supposed
> to break them into queues.
Thanks for your explanation.

> 
> Reordering is what happens when packts that are sent as [ 0, 1, 2, 3, 4 ]
> get received as [ 0, 1, 4, 3, 2 ] because your receive processing happened on different
> CPU's. You really need to test this with some program like 'iperf' to see the effect
> it has on TCP. Older Juniper routers used to have hardware that did this and it
> caused it caused performance loss. Do some google searches and you will see
> it is a active research topic about whether reordering is okay or not. Existing
> multiqueue is safe because it doesn't reorder inside a single flow; it only
> changes order between flows:  [ A1, A2, B1, B2] => [ A1, B1, A2, B2 ]
Thanks. Your explanation is very clear. My patch might cause reorder, but very rarely,
because reorder only happens when there is a failover in function raise_netif_irq. perhaps
I need replace the failover with just packet dropping?

I will try iperf.

> 
> Isn't this a problem:
> > +int netif_rx_queue(struct sk_buff *skb, struct sk_buff_head *skb_queue)
> >  {
> >  	struct softnet_data *queue;
> >  	unsigned long flags;
> > +	int this_cpu;
> >  
> >  	/* if netpoll wants it, pretend we never saw it */
> >  	if (netpoll_rx(skb))
> > @@ -1943,24 +1946,31 @@ int netif_rx(struct sk_buff *skb)
> >  	if (!skb->tstamp.tv64)
> >  		net_timestamp(skb);
> >  
> > +	if (skb_queue)
> > +		this_cpu = 0;
> > +	else
> > +		this_cpu = 1;
> 
> Why bother with a special boolean? and instead just test for skb_queue != NULL
Var this_cpu is used for ﻿napi_schedule late. Although the logical has no problem,
this_cpu seems confused. Let me check if there is a better way for late napi_schedule.

> 
> > +
> >  	/*
> >  	 * The code is rearranged so that the path is the most
> >  	 * short when CPU is congested, but is still operating.
> >  	 */
> >  	local_irq_save(flags);
> > +
> >  	queue = &__get_cpu_var(softnet_data);
> > +	if (!skb_queue)
> > +		skb_queue = &queue->input_pkt_queue;
﻿When ﻿skb_queue is NULL, we redirect it to ﻿queue->input_pkt_queue.

> 
> >  
> >  	__get_cpu_var(netdev_rx_stat).total++;
> > -	if (queue->input_pkt_queue.qlen <= netdev_max_backlog) {
> > -		if (queue->input_pkt_queue.qlen) {
> > -enqueue:
> > -			__skb_queue_tail(&queue->input_pkt_queue, skb);
> > -			local_irq_restore(flags);
> > -			return NET_RX_SUCCESS;
> > +
> > +	if (skb_queue->qlen <= netdev_max_backlog) {
> > +		if (!skb_queue->qlen && this_cpu) {
> > +			napi_schedule(&queue->backlog);
> >  		}
> 
> Won't this break if skb_queue is NULL (non NAPI case)?
So skb_queue isn't NULL here.

Another idea is just to delete function ﻿netif_rx_queue. Drivers could use
﻿__skb_queue_tail directly. The difference ﻿netif_rx_queue has a queue length
checking while ﻿﻿__skb_queue_tail hasn't. But mostly ﻿skb_queue is far smaller than
﻿queue->input_pkt_queue.qlen and ﻿queue->input_pkt_alien_queue.qlen.

Yanmin


