Return-Path: <linux-kernel-owner+w=401wt.eu-S1764356AbZFQX2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764356AbZFQX2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763862AbZFQX12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:27:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38758 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763939AbZFQX10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:27:26 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 17 Jun 2009 16:21:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
In-Reply-To: <4A39649C.4020602@novell.com>
Message-ID: <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com>
 <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com>
 <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com>
 <4A39649C.4020602@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Gregory Haskins wrote:

> I am not clear on what you are asking here.  So in case this was a
> sincere question on how things work, here is a highlight of the typical
> flow of a packet that ingresses on a physical adapter and routes to KVM
> via vbus.
> 
> a) interrupt from eth to host wakes the cpu out of idle, enters
> interrupt-context.
> b) ISR runs, disables interrupts on the eth, schedules softirq-net-rx
> c) ISR completes, kernel checks softirq state before IRET, runs pending
> softirq-net-rx in interrupt context to NAPI-poll the ethernet
> d) packet is pulled out of eth into a layer-2 bridge, and switched to
> the appropriate switch-port (which happens to be a venet-tap (soon to be
> virtio-net based) device.  The packet is queued to the tap as an xmit
> request, and the tap's tx-thread is awoken.
> e) the xmit call returns, the napi-poll completes, and the
> softirq-net-rx terminates.  The kernel does an IRET to exit interrupt
> context.
> f) the scheduler runs and sees the tap's tx-thread is ready to run,
> schedules it in.
> g) the tx-thread awakens, dequeues the posted skb, copies it to the
> virtio-ring, and finally raises an interrupt on irqfd with eventfd_signal().

Heh, Gregory, this isn't a job interview. You didn't have to actually 
detail everything ;)  Glad you did though, so we've something to talk 
later.



> At this point, all of the data has been posted to the virtio-ring in
> shared memory between the host and guest.  All that is left is to inject
> the interrupt so the guest knows to process the ring.  We call the
> eventfd_signal() from kthread context.  However, the callback to inject
> the interrupt is invoked with the wqh spinlock held so we are forced to
> defer the interrupt injection to a workqueue so the kvm->lock can be
> safely acquired.  This adds additional latency (~7us) in a path that is
> only a handful of microseconds to being with.  I can post LTTV
> screenshots, if it would be helpful to visualize this.

So, what you're trying to say, is that the extra wakeup required by your 
schedule_work() processing, makes actually a difference in the time it 
takes to go from a) to g), where there are at least two other kernel 
thread wakeups?
Don't think in terms of microbenchs, think in how much are those 7us (are 
they? really? this is a sync, on-cpu, kernel thread, wake up) are 
impacting the whole path.
Everything looks worthwhile in microbenches.




> Right, understood, and note that this is precisely why I said it would
> oops.  What I was specifically trying to highlight is that its not like
> this change imposes new requirements on the existing callbacks.  I also
> wanted to highlight that its not really eventfd's concern what the
> callback tries to do, per se (if it wants to sleep it can try, it just
> wont work).  Any reasonable wakeup callback in existence would already
> assume it cannot sleep, and they wouldn't even try to begin with.
> 
> On the other hand, what I am introducing here (specifically to eventfd
> callbacks, not wait-queues [*]) is the possibility of removing this
> restriction under the proper circumstances.  It would only be apparent
> of this change iff the callback in question tried to test for this (e.g.
> checking preemptible()) state.  It is thus opt-in, and existing code
> does not break.

The interface is just ugly IMO. You have eventfd_signal() that can sleep, 
or not, depending on the registered ->signal() function implementations.
This is pretty bad, a lot worse than the theoretical us spent in the 
schedule_work() processing.



- Davide


