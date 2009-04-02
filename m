Return-Path: <linux-kernel-owner+w=401wt.eu-S1763116AbZDBBYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763116AbZDBBYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZDBBYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:24:19 -0400
Received: from ozlabs.org ([203.10.76.45]:35149 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZDBBYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:24:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC PATCH 00/17] virtual-bus
Date: Thu, 2 Apr 2009 11:54:13 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, netdev@vger.kernel.org,
       kvm@vger.kernel.org
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <200904011638.45135.rusty@rustcorp.com.au> <49D3518B.1030403@novell.com>
In-Reply-To: <49D3518B.1030403@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904021154.14082.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009 22:05:39 Gregory Haskins wrote:
> Rusty Russell wrote:
> > I could dig through the code, but I'll ask directly: what heuristic do
> > you use for notification prevention in your venet_tap driver?
> 
> I am not 100% sure I know what you mean with "notification prevention",
> but let me take a stab at it.

Good stab :)

> I only signal back to the guest to reclaim its skbs every 10
> packets, or if I drain the queue, whichever comes first (note to self:
> make this # configurable).

Good stab, though I was referring to guest->host signals (I'll assume
you use a similar scheme there).

You use a number of packets, qemu uses a timer (150usec), lguest uses a
variable timer (starting at 500usec, dropping by 1 every time but increasing
by 10 every time we get fewer packets than last time).

So, if the guest sends two packets and stops, you'll hang indefinitely?
That's why we use a timer, otherwise any mitigation scheme has this issue.

Thanks,
Rusty.


> 
> The nice part about this scheme is it significantly reduces the amount
> of guest/host transitions, while still providing the lowest latency
> response for single packets possible.  e.g. Send one packet, and you get
> one hypercall, and one tx-complete interrupt as soon as it queues on the
> hardware.  Send 100 packets, and you get one hypercall and 10
> tx-complete interrupts as frequently as every tenth packet queues on the
> hardware.  There is no timer governing the flow, etc.
> 
> Is that what you were asking?
> 
> > As you point out, 350-450 is possible, which is still bad, and it's at least
> > partially caused by the exit to userspace and two system calls.  If virtio_net
> > had a backend in the kernel, we'd be able to compare numbers properly.
> >   
> :)
> 
> But that is the whole point, isnt it?  I created vbus specifically as a
> framework for putting things in the kernel, and that *is* one of the
> major reasons it is faster than virtio-net...its not the difference in,
> say, IOQs vs virtio-ring (though note I also think some of the
> innovations we have added such as bi-dir napi are helping too, but these
> are not "in-kernel" specific kinds of features and could probably help
> the userspace version too).
> 
> I would be entirely happy if you guys accepted the general concept and
> framework of vbus, and then worked with me to actually convert what I
> have as "venet-tap" into essentially an in-kernel virtio-net.  I am not
> specifically interested in creating a competing pv-net driver...I just
> needed something to showcase the concepts and I didnt want to hack the
> virtio-net infrastructure to do it until I had everyone's blessing. 
> Note to maintainers: I *am* perfectly willing to maintain the venet
> drivers if, for some reason, we decide that we want to keep them as
> is.   Its just an ideal for me to collapse virtio-net and venet-tap
> together, and I suspect our community would prefer this as well.
> 
> -Greg
> 
> 
