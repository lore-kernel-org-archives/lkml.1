Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200AbZHRU70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbZHRU70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZHRU7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:59:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbZHRU7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:59:21 -0400
Date: Tue, 18 Aug 2009 23:57:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, Avi Kivity <avi@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [Alacrityvm-devel] [PATCH v3 3/6] vbus: add a "vbus-proxy" bus
	model for vbus_driver objects
Message-ID: <20090818205748.GC20393@redhat.com>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <20090817174142.GA11140@redhat.com> <4A89BAC5.9040400@gmail.com> <20090818084606.GA13878@redhat.com> <20090818155329.GD31060@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818155329.GD31060@ovro.caltech.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 08:53:29AM -0700, Ira W. Snyder wrote:
> I think Greg is referring to something like my virtio-over-PCI patch.
> I'm pretty sure that vhost is completely useless for my situation. I'd
> like to see vhost work for my use, so I'll try to explain what I'm
> doing.
> 
> I've got a system where I have about 20 computers connected via PCI. The
> PCI master is a normal x86 system, and the PCI agents are PowerPC
> systems. The PCI agents act just like any other PCI card, except they
> are running Linux, and have their own RAM and peripherals.
> 
> I wrote a custom driver which imitated a network interface and a serial
> port. I tried to push it towards mainline, and DavidM rejected it, with
> the argument, "use virtio, don't add another virtualization layer to the
> kernel." I think he has a decent argument, so I wrote virtio-over-PCI.
> 
> Now, there are some things about virtio that don't work over PCI.
> Mainly, memory is not truly shared. It is extremely slow to access
> memory that is "far away", meaning "across the PCI bus." This can be
> worked around by using a DMA controller to transfer all data, along with
> an intelligent scheme to perform only writes across the bus. If you're
> careful, reads are never needed.
> 
> So, in my system, copy_(to|from)_user() is completely wrong.
> There is no userspace, only a physical system.

Can guests do DMA to random host memory? Or is there some kind of IOMMU
and DMA API involved? If the later, then note that you'll still need
some kind of driver for your device. The question we need to ask
ourselves then is whether this driver can reuse bits from vhost.

> In fact, because normal x86 computers
> do not have DMA controllers, the host system doesn't actually handle any
> data transfer!

Is it true that PPC has to initiate all DMA then? How do you
manage not to do DMA reads then?

> I used virtio-net in both the guest and host systems in my example
> virtio-over-PCI patch, and succeeded in getting them to communicate.
> However, the lack of any setup interface means that the devices must be
> hardcoded into both drivers, when the decision could be up to userspace.
> I think this is a problem that vbus could solve.

What you describe (passing setup from host to guest) seems like
a feature that guest devices need to support. It seems unlikely that
vbus, being a transport layer, can address this.

> 
> For my own selfish reasons (I don't want to maintain an out-of-tree
> driver) I'd like to see *something* useful in mainline Linux. I'm happy
> to answer questions about my setup, just ask.
> 
> Ira

Thanks Ira, I'll think about it.
A couple of questions:
- Could you please describe what kind of communication needs to happen?
- I'm not familiar with DMA engine in question. I'm guessing it's the
  usual thing: in/out buffers need to be kernel memory, interface is
  asynchronous, small limited number of outstanding requests? Is there a
  userspace interface for it and if yes how does it work?



-- 
MST

