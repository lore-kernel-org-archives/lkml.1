Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXIMUbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXIMUbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbXIMUbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:31:41 -0400
Received: from 0006b10c8258.cranite.com ([63.81.170.2]:45069 "EHLO
	mailnode1.cranite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755757AbXIMUbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:31:40 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: irq load balancing
Date: Thu, 13 Sep 2007 13:31:39 -0700
Message-ID: <3641F7C576757E49AE23AD0D820D72C434DCB3@mailnode1.cranite.com>
In-Reply-To: <46E85DDA.7010209@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: irq load balancing
Thread-Index: Acf1hi+TjAdZc9OeToO+nybCr9QWpAAvUVcg
From: "Venkat Subbiah" <venkats@cranite.com>
To: "Chris Snook" <csnook@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Doing it in a round-robin fashion will be disastrous for performance.
Your cache miss rate will go through the roof and you'll hit the slow
paths in the network stack most of the time.
> Most of the work in my system is spent in enrypt/decrypting traffic.
Right now all this is done in a tasklet within the softirqd and hence
all landing up on the same CPU.
On the receive side it'a packet handler that handles the traffic. On the
tx side it's done within the transmit path of the packet. So would
re-architecting this to move the rx packet handler to a different kernel
thread(with smp affinity to one CPU) and tx to a different kernel
thread(with SMP affinity to a different CPU) be advisable. 
What's the impact on cache miss and slowpath/fastpath in network stack.

Thx,
-Venkat

-----Original Message-----
From: Chris Snook [mailto:csnook@redhat.com] 
Sent: Wednesday, September 12, 2007 2:45 PM
To: Venkat Subbiah
Cc: linux-kernel@vger.kernel.org
Subject: Re: irq load balancing

Venkat Subbiah wrote:
> Most of the load in my system is triggered by a single ethernet IRQ.
> Essentially the IRQ schedules a tasklet and most of the work is done
in the
> taskelet which is scheduled in the IRQ. From what I read looks like
the
> tasklet would be executed on the same CPU on which it was scheduled.
So this
> means even in an SMP system it will be one processor which is
overloaded.
> 
> So will using the user space IRQ loadbalancer really help?

A little bit.  It'll keep other IRQs on different CPUs, which will
prevent other 
interrupts from causing cache and TLB evictions that could slow down the

interrupt handler for the NIC.

> What I am doubtful
> about is that the user space load balance comes along and changes the
> affinity once in a while. But really what I need is every interrupt to
go to
> a different CPU in a round robin fashion.

Doing it in a round-robin fashion will be disastrous for performance.
Your 
cache miss rate will go through the roof and you'll hit the slow paths
in the 
network stack most of the time.

> Looks like the APIC  can distribute IRQ's dynamically? Is this
supported in
> the kernel and any config or proc interface to turn this on/off.

/proc/irq/$FOO/smp_affinity is a bitmask.  You can mask an irq to
multiple 
processors.  Of course, this will absolutely kill your performance.
That's why 
irqbalance never does this.

	-- Chris
