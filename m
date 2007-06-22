Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXFVBxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXFVBxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXFVBxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:53:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:60784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbXFVBxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:53:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,449,1175497200"; 
   d="scan'208";a="99025565"
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
	control
From: "Huang, Ying" <ying.huang@intel.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg K-H <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, david@lang.hm,
       David Miller <davem@davemloft.net>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <467AA596.5030509@s5r6.in-berlin.de>
References: <9D7649D18729DE4BB2BD7B494F7FEDC218022B@pdsmsx415.ccr.corp.intel.com>
	 <467AA596.5030509@s5r6.in-berlin.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Jun 2007 09:52:38 +0000
Message-Id: <1182505958.12161.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 22 Jun 2007 01:53:31.0158 (UTC) FILETIME=[22813B60:01C7B470]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 18:21 +0200, Stefan Richter wrote:
> Parallelism between subsystems may be interesting during boot ==
> "coldplug", /if/ the machine has time-consuming devices to probe on
> /different/ types of buses.  Of course some machines do the really
> time-consuming stuff on only one type of bus.  Granted, parallelism
> betwen subsystems is not very interesting anymore later after boot ==
> "hotplug".

Yes. So I think there are two possible solution.

1. Creating one set of probing queues for each subsystem (maybe just the
subsystems need it), so the probing queue IDs are local to each
subsystem.
2. There is only one set of probing queues in whole system. The probing
queue IDs are shared between subsystems. The subsystem can select a
random starting queue ID (maybe named as start_queue_id), and allocate
the queue IDs from that point on (start_queue_id + private_queue_id). So
the probability of queue ID sharing will be reduced.

> (The old FireWire stack will re-enter the main loop of the bus scanning
> thread sometime after a bus reset event signaled that nodes or units may
> have appeared or disappeared.  The new FireWire stack will schedule
> respective scanning workqueue jobs after such an event.)

I think the workqueue is better than kernel thread here. With kernel
thread, the nodes and units may be needed to be scanned again and again
for each unit/node if many units/nodes are appeared at almost the same
time, while with workqueue, just schedule the jobs needed.

And a workqueue like the probing queue whose thread can be
created/destroyed on demand will save more resources than ordinary
workqueue. :)

Best Regards,
Huang Ying
