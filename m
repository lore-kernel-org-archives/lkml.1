Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbXJHPhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbXJHPhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbXJHPhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:37:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:16783 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXJHPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=DtHebXLDuo+BD9Be6qjYPRX1X7RJkpOf2Gp+rokaFl32o85tAUbycS9yztA+5AE8xCBYkx2glkjgtuhBVUHJzv+/SdOWED/MKGqDso3Pbq8C362OzNxasUfyjdp+qYkYgvj8JdkKt0ZhBCqIU73z1I7bRTwOehtT/s/jZuBIKK8=
Subject: Re: parallel networking (was Re: [PATCH 1/4] [NET_SCHED] explict
	hold dev tx lock)
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, peter.p.waskiewicz.jr@intel.com,
       krkumar2@in.ibm.com, johnpol@2ka.mipt.ru, herbert@gondor.apana.org.au,
       kaber@trash.net, shemminger@linux-foundation.org, jagana@us.ibm.com,
       Robert.Olsson@data.slu.se, rick.jones2@hp.com, xma@us.ibm.com,
       gaagaan@gmail.com, netdev@vger.kernel.org, rdreier@cisco.com,
       Ingo Molnar <mingo@elte.hu>, mchan@broadcom.com,
       general@lists.openfabrics.org, kumarkr@linux.ibm.com, tgraf@suug.ch,
       randy.dunlap@oracle.com, sri@us.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <470A3D24.3050803@garzik.org>
References: <1190674298.4264.24.camel@localhost>
	 <D5C1322C3E673F459512FB59E0DDC32903A51462@orsmsx414.amr.corp.intel.com>
	 <1190677099.4264.37.camel@localhost>
	 <20071007.215124.85709188.davem@davemloft.net>
	 <1191850490.4352.41.camel@localhost>  <470A3D24.3050803@garzik.org>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 11:18:29 -0400
Message-Id: <1191856709.4352.124.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-10 at 10:22 -0400, Jeff Garzik wrote:

> Any chance the NIC hardware could provide that guarantee?

If you can get the scheduling/dequeuing to run on one CPU (as we do
today) it should work; alternatively you can totaly bypass the qdisc
subystem and go direct to the hardware for devices that are capable
and that would work but would require huge changes. 
My fear is there's a mini-scheduler pieces running on multi cpus which
is what i understood as being described.

> 8139cp, for example, has two TX DMA rings, with hardcoded 
> characteristics:  one is a high prio q, and one a low prio q.  The logic 
> is pretty simple:   empty the high prio q first (potentially starving 
> low prio q, in worst case).

sounds like strict prio scheduling to me which says "if low prio starves
so be it"

> In terms of overall parallelization, both for TX as well as RX, my gut 
> feeling is that we want to move towards an MSI-X, multi-core friendly 
> model where packets are LIKELY to be sent and received by the same set 
> of [cpus | cores | packages | nodes] that the [userland] processes 
> dealing with the data.

Does putting things in the same core help? But overall i agree with your
views. 

> There are already some primitive NUMA bits in skbuff allocation, but 
> with modern MSI-X and RX/TX flow hashing we could do a whole lot more, 
> along the lines of better CPU scheduling decisions, directing flows to 
> clusters of cpus, and generally doing a better job of maximizing cache 
> efficiency in a modern multi-thread environment.

I think i see the receive with a lot of clarity, i am still foggy on the
txmit path mostly because of the qos/scheduling issues. 

> IMO the current model where each NIC's TX completion and RX processes 
> are both locked to the same CPU is outmoded in a multi-core world with 
> modern NICs.  :)

Infact even with status quo theres a case that can be made to not bind
to interupts.
In my recent experience with batching, due to the nature of my test app,
if i let the interupts float across multiple cpus i benefit.
My app runs/binds a thread per CPU and so benefits from having more
juice to send more packets per unit of time - something i wouldnt get if
i was always running on one cpu.
But when i do this i found that just because i have bound a thread to
cpu3 doesnt mean that thread will always run on cpu3. If netif_wakeup
happens on cpu1, scheduler will put the thread on cpu1 if it is to be
run. It made sense to do that, it just took me a while to digest.

> But I readily admit general ignorance about the kernel process 
> scheduling stuff, so my only idea about a starting point was to see how 
> far to go with the concept of "skb affinity" -- a mask in sk_buff that 
> is a hint about which cpu(s) on which the NIC should attempt to send and 
> receive packets.  When going through bonding or netfilter, it is trivial 
> to 'or' together affinity masks.  All the various layers of net stack 
> should attempt to honor the skb affinity, where feasible (requires 
> interaction with CFS scheduler?).

There would be cache benefits if you can free the packet on the same cpu
it was allocated; so the idea of skb affinity is useful in the minimal
in that sense if you can pull it. Assuming hardware is capable, even if
you just tagged it on xmit to say which cpu it was sent out on, and made
sure thats where it is freed, that would be a good start. 

Note: The majority of the packet processing overhead is _still_ the
memory subsystem latency; in my tests with batched pktgen improving the 
xmit subsystem meant the overhead on allocing and freeing the packets
went to something > 80%.
So something along the lines of parallelizing based on a split of alloc
free of sksb IMO on more cpus than where xmit/receive run would see
more performance improvements.

> Or maybe skb affinity is a dumb idea.  I wanted to get people thinking 
> on the bigger picture.  Parallelization starts at the user process.


cheers,
jamal

