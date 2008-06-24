Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYFXXhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYFXXhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYFXXhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:37:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47877
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYFXXhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:37:42 -0400
Date: Tue, 24 Jun 2008 16:37:42 -0700 (PDT)
Message-Id: <20080624.163742.224488012.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: jeff@garzik.org, peter.p.waskiewicz.jr@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: Add the CPU id to skb->queue_mapping's upper
 8 bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080624232545.11654.65805.stgit@localhost.localdomain>
References: <20080624232545.11654.65805.stgit@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 24 Jun 2008 16:27:12 -0700

> From: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> 
> This patch adds the CPU index to the upper 8 bits of the queue_mapping in
> the skb.  This will support 256 CPUs and 256 Tx queues.  The reason for
> this is the qdisc layer can obscure which CPU is generating a certain flow
> of packets, so network drivers don't have any insight which CPU generated a
> particular packet.  If the driver knows which CPU generated the packet,
> then it could adjust Rx filtering in the hardware to redirect the packet
> back to the CPU who owns the process that generated this packet.
> Preventing the cache miss and reschedule of a process to a different CPU is
> a big win in network performance, especially at 10 gigabit speeds.
> 
> Signed-off-by: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Well:

1) All of this multiqueue stuff is going away with my changes in
   net-tx-2.6

2) This CPU number is going to be wrong half of the time.

For #2, when TCP is processing ACKs, it sends packets out from
whichever CPU the ACK landed on.

So you could end up retargetting the RX flow back and forth between
cpus.  The cpu that sends the packet into the device layer is far
from the cpu that should be used to target the RX flow at.

So this idea is pretty seriously flawed and the infrastructure it's
using is going away anyways.

It also adds all sorts of arbitray limitations (256 queues and cpus? I
already have systems coming to me with more than 256 cpus)
