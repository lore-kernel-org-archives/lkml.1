Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZCDJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZCDJ2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZCDJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:28:17 -0500
Received: from mga05.intel.com ([192.55.52.89]:59039 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753644AbZCDJ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:28:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,299,1233561600"; 
   d="scan'208";a="670204935"
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
	layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       shemminger@vyatta.com
In-Reply-To: <20090224.233115.240823417.davem@davemloft.net>
References: <20090225063656.GA32635@gondor.apana.org.au>
	 <1235546423.2604.556.camel@ymzhang>
	 <20090224.233115.240823417.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Mar 2009 17:27:48 +0800
Message-Id: <1236158868.2567.93.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 23:31 -0800, David Miller wrote: 
> From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> Date: Wed, 25 Feb 2009 15:20:23 +0800
> 
> > If the machines might have a couple of NICs and every NIC has CPU_NUM queues,
> > binding them evenly might cause more cache-miss/ping-pong. I didn't test
> > multiple receiving NICs scenario as I couldn't get enough hardware.
> 
> In the net-next-2.6 tree, since we mark incoming packets with
> skb_record_rx_queue() properly, we'll make a more favorable choice of
> TX queue.
Thanks for your pointer. I cloned net-next-2.6 tree. ﻿skb_record_rx_queue is a smart
idea to implement an auto TX selection.

There is no NIC multi-queue standard or RFC available. At least I didn't find it
by google.

Both the new ﻿skb_record_rx_queue and current kernel have an assumption on
multi-queue. The assumption is it's best to send out packets from the TX of the
same number of queue like the one of RX if the receved packets are related to
the out packets. Or more direct speaking is we need send packets on the same cpu on
which we receive them. The start point is that could reduce skb and data cache miss.

With slow NIC, the assumption is right. But with high-speed NIC, especially 10G
NIC, the assumption seems not ok.

Here is a simple calculation with real testing/data with Nehalem machine and Bensley
machine. There are 2 machines with the testing driven by pktgen.

		    	send packets
	Machine A   	==============>		Machine B
		    
		    	forward pkts back
		    	<==============		


With Nehalem machines, I can get 4 million pps (packets per second) and per packet consists
of 60 bytes. So the speed is about 240MBytes/s. Nehalem has 2 sockets and every socket has
4 core and 8 logical cpu. All logical cpu share the last level cache 8Mbytes. That means
every physical cpu receives 120M bytes per second which is 8 times of last level cache
size.

With Bensley machine, I can get 1.2M pps, or 72MBytes. That machine has 2 sockets and every
socket has a qual-core cpu. Every dual-core share the last level cache 6MByte. That means
every dual-core gets 18M bytes per second, which is 3 times of last level cache size.

So with both bensley and Nehalem, the cache is flushed very quickly with 10G NIC testing.

Some other kinds of machines might have bigger cache. For example, my Montvale Itanium has
2 sockets, and every socket has a qual-core cpu plus multi-thread. Every dual-core shares
the last level cache 12M. But the cache is stll flushed at least twice per second.

If checking NIC drivers, we can find drivers touch very limited fields of sk_buff when
collecting packets from NIC.

It is said 20G or 30G NIC are under producing.

So with high-speed 10G NIC, the old assumption seems not working.

In the other hand, which part causes most cache foot print and cache miss? I don't think
drivers do so because﻿ the receiving cpu only touch some fields of sb_buff before sending
to upper layer.

My patch throws packets to specific cpu controlled by configuration, which doesn't
cause much cache ping-pong. ﻿After receving cpu throws packets to 2nd cpu, it doesn't need them
again. The 2nd cpu has cache-miss, but it doesn't cause cache ping-pong.

My patch doesn't always disagree with ﻿﻿skb_record_rx_queue.
1) It can be configured by admin;
2) We can call ﻿skb_record_rx_queue or similiar functions at the 2nd cpu (the real cpu to
process the packets by process_backlog); So later on cache footprint won't be wasted when
forwarding packets out;

> 
> You may want to figure out what that isn't behaving well in your
> case.

I did check kernel, including slab ( I tried slab/slub/slqb and use slub now) tuning, and
instrumented IXGBE driver. Besides careful multi-queue/interrupt binding, another way is
just to use my patch to promote speed for more than 40% on both Nehalem and Bensley.


> 
> I don't think we should do any kind of software spreading for such
> capable hardware,
> it defeats the whole point of supporting the
> multiqueue features.
﻿There is no NIC multi-queue standard or RFC.

Jesse is worried about we might allocate free cores for the packet collection while a
real environment keeps cpu all busy. I added more pressure on sending machine, and got
better performance on forwarding machine and the forwarding machine's cpu are busier
than before. Some logical cpu idle is near to 0. But I only have a couple of 10G NIC,
and couldn't add more pressure to make all cpu busy.


Thanks again, for your comments and patience.

Yanmin


