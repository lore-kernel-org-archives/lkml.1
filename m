Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZHXX51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZHXX51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZHXX51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:57:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:40286 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbZHXX50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:57:26 -0400
Message-ID: <4A9328E3.3060106@codemonkey.ws>
Date: Mon, 24 Aug 2009 18:57:23 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: alacrityvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: vbus design points: shm and shm-signals
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws> <4A8AA9BD.2070909@gmail.com> <4A8AB076.6080906@redhat.com> <4A8ACE1F.6020402@gmail.com> <20090818161434.GA15884@elte.hu> <4A8B7F17.6050100@gmail.com> <4A8E7D32.8040209@gmail.com> <4A92E3B1.5080002@codemonkey.ws> <4A92F158.9050003@gmail.com>
In-Reply-To: <4A92F158.9050003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Hi Anthony,
>
>   
>> Fundamentally, how is this different than the virtio->add_buf concept?
>>     
>
> From my POV, they are at different levels.  Calling vbus->shm() is for
> establishing a shared-memory region including routing the memory and
> signal-path contexts.  You do this once at device init time, and then
> run some algorithm on top (such as a virtqueue design).
>   

virtio explicitly avoids having a single setup-memory-region call 
because it was designed to accommodate things like Xen grant tables 
whereas you have a fixed number of sharable
buffers that need to be setup and torn down as you use them.

You can certainly use add_buf() to setup a persistent mapping but it's 
not the common usage.  For KVM, since all memory is accessible by the 
host without special setup, add_buf() never results in an exit (it's 
essentially a nop).

So I think from that perspective, add_buf() is a functional superset of 
vbus->shm().

> virtio->add_buf() OTOH, is a run-time function.  You do this to modify
> the shared-memory region that is already established at init time by
> something like vbus->shm().  You would do this to queue a network
> packet, for instance.
>
> That said, shm-signal's closest analogy to virtio would be vq->kick(),
> vq->callback(), vq->enable_cb(), and vq->disable_cb().  The difference
> is that the notification mechanism isn't associated with a particular
> type of shared-memory construct (such as a virt-queue), but instead can
> be used with any shared-mem algorithm (at least, if I designed it properly).
>   

Obviously, virtio allows multiple ring implements based on how it does 
layering.  The key point is that it doesn't expose that to the consumer 
of the device.

Do you see a compelling reason to have an interface at this layer?

>> virtio provides a mechanism to register scatter/gather lists, associate
>> a handle with them, and provides a mechanism for retrieving notification
>> that the buffer has been processed.
>>     
>
> Yes, and I agree this is very useful for many/most algorithms...but not
> all.  Sometimes you don't want ring-like semantics, but instead want
> something like an idempotent table.  (Think of things like interrupt
> controllers, timers, etc).
>   

We haven't crossed this bridge yet because we haven't implemented one of 
these devices.  One approach would be to use add_buf() to register fixed 
shared memory regions.  Because our rings are fixed sized, this implies 
a fixed number of shared memory mappings.

You could also extend virtio to provide a mechanism to register 
unlimited numbers of shared memory regions.  The problem with this is 
that it doesn't work well for hypervisors with fixed shared-memory 
regions (like Xen).
> However, sometimes you may want to say "time is now X", and later "time
> is now Y".  The update value of 'X' is technically superseded by Y and
> is stale.  But a ring may allow both to exist in-flight within the shm
> simultaneously if the recipient (guest or host) is lagging, and the X
> may be processed even though its data is now irrelevant.  What we really
> want is the transform of X->Y to invalidate anything else in flight so
> that only Y is visible.
>   

We actually do this today but we just don't use virtio.  I'm not sure we 
need a single bus that can serve both of these purposes.  What does this 
abstraction buy us?

> If you think about it, a ring is a superset of this construct...the ring
> meta-data is the "shared-table" (e.g. HEAD ptr, TAIL ptr, COUNT, etc).
> So we start by introducing the basic shm concept, and allow the next
> layer (virtio/virtqueue) in the stack to refine it for its needs.
>   

I think there's a trade off between practicality and theoretical 
abstractions.  Surely, a system can be constructed simply with 
notification and shared memory primitives.   This is what Xen does via 
event channels and grant tables.  In practice, this ends up being 
cumbersome and results in complex drivers.  Compare netfront to 
virtio-net, for instance.

We choose to abstract at the ring level precisely because it simplifies 
driver implementations.  I think we've been very successful here.

virtio does not accommodate devices that don't fit into a ring model 
very well today.  There's certainly room to discuss how to do this.  If 
there is to be a layer below virtio's ring semantics, I don't think that 
vbus is this because it mandates much higher levels of the stack 
(namely, device enumeration).

IOW, I can envision a model that looked like PCI -> virtio-pci -> 
virtio-shm -> virtio-ring -> virtio-net

Whereas generic-shm-mechanism provided a non-ring interface for non-ring 
devices.  That doesn't preclude non virtio-pci transports, it just 
suggests how we would do the layering.

So maybe there's a future for vbus as virtio-shm?  How attached are you 
to your device discovery infrastructure?

If you introduced a virtio-shm layer to the virtio API that looked a bit 
like vbus' device API, and then decoupled the device discovery bits into 
a virtio-vbus transport, I think you'd end up with something that was 
quite agreeable.

As a transport, PCI has significant limitations.  The biggest being the 
maximum number of devices we can support.  It's biggest advantage though 
is portability so it's something I think we would always want to 
support.  However, having a virtio transport optimized for Linux's 
guests is something I would certainly support.

>> vbus provides a mechanism to register a single buffer with an integer
>> handle, priority, and a signaling mechanism.
>>     
>
> Again, I think we are talking about two different layers.  You would
> never put entries into a virtio-ring of different priority.  This
> doesn't make sense, as they would just get linearized by the fifo.
>
> What you *would* do is possibly make multiple virtqueues, each with a
> different priority (for instance, say 8-rx queues for virtio-net).
>   

I think priority is an overloaded concept.  I'm not sure it belongs in a 
generic memory sharing API.

>> What does one do with priority, btw?
>>     
>
> There are, of course, many answers to that question.  One particularly
> trivial example is 802.1p networking.  So, for instance, you can
> classify and prioritize network traffic so that things like
> control/timing packets are higher priority than best-effort HTTP.

Wouldn't you do this at a config-space level though?  I agree you would 
want to have multiple rings with individual priority, but I think 
priority is a ring configuration just as programmable triplet filtering 
would be a per-ring configuration.  I also think how priority gets 
interpreted really depends on the device so it belongs in the device's 
ABI instead of the shared memory or ring ABI.

> HTH,
>   

It does, thanks.

Regards,

Anthony Liguori
