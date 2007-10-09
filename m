Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbXJIByL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbXJIByL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 21:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXJIBx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 21:53:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52772 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbXJIBxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 21:53:55 -0400
Message-ID: <470ADF15.2090100@garzik.org>
Date: Mon, 08 Oct 2007 21:53:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hadi@cyberus.ca, peter.p.waskiewicz.jr@intel.com, krkumar2@in.ibm.com,
       johnpol@2ka.mipt.ru, herbert@gondor.apana.org.au, kaber@trash.net,
       shemminger@linux-foundation.org, jagana@us.ibm.com,
       Robert.Olsson@data.slu.se, rick.jones2@hp.com, xma@us.ibm.com,
       gaagaan@gmail.com, netdev@vger.kernel.org, rdreier@cisco.com,
       mingo@elte.hu, mchan@broadcom.com, general@lists.openfabrics.org,
       kumarkr@linux.ibm.com, tgraf@suug.ch, randy.dunlap@oracle.com,
       sri@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: parallel networking
References: <20071007.215124.85709188.davem@davemloft.net>	<1191850490.4352.41.camel@localhost>	<470A3D24.3050803@garzik.org> <20071008.141154.107706003.davem@davemloft.net>
In-Reply-To: <20071008.141154.107706003.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Mon, 08 Oct 2007 10:22:28 -0400
> 
>> In terms of overall parallelization, both for TX as well as RX, my gut 
>> feeling is that we want to move towards an MSI-X, multi-core friendly 
>> model where packets are LIKELY to be sent and received by the same set 
>> of [cpus | cores | packages | nodes] that the [userland] processes 
>> dealing with the data.
> 
> The problem is that the packet schedulers want global guarantees
> on packet ordering, not flow centric ones.
> 
> That is the issue Jamal is concerned about.

Oh, absolutely.

I think, fundamentally, any amount of cross-flow resource management 
done in software is an obstacle to concurrency.

That's not a value judgement, just a statement of fact.

"traffic cops" are intentional bottlenecks we add to the process, to 
enable features like priority flows, filtering, or even simple socket 
fairness guarantees.  Each of those bottlenecks serves a valid purpose, 
but at the end of the day, it's still a bottleneck.

So, improving concurrency may require turning off useful features that 
nonetheless hurt concurrency.


> The more I think about it, the more inevitable it seems that we really
> might need multiple qdiscs, one for each TX queue, to pull this full
> parallelization off.
> 
> But the semantics of that don't smell so nice either.  If the user
> attaches a new qdisc to "ethN", does it go to all the TX queues, or
> what?
> 
> All of the traffic shaping technology deals with the device as a unary
> object.  It doesn't fit to multi-queue at all.

Well the easy solutions to networking concurrency are

* use virtualization to carve up the machine into chunks

* use multiple net devices

Since new NIC hardware is actively trying to be friendly to 
multi-channel/virt scenarios, either of these is reasonably 
straightforward given the current state of the Linux net stack.  Using 
multiple net devices is especially attractive because it works very well 
with the existing packet scheduling.

Both unfortunately impose a burden on the developer and admin, to force 
their apps to distribute flows across multiple [VMs | net devs].


The third alternative is to use a single net device, with SMP-friendly 
packet scheduling.  Here you run into the problems you described "device 
as a unary object" etc. with the current infrastructure.

With multiple TX rings, consider that we are pushing the packet 
scheduling from software to hardware...  which implies
* hardware-specific packet scheduling
* some TC/shaping features not available, because hardware doesn't 
support it

	Jeff




