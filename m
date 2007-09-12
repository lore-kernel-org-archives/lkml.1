Return-Path: <linux-kernel-owner+w=401wt.eu-S1765845AbXILVpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765845AbXILVpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbXILVpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:45:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114AbXILVpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:45:08 -0400
Message-ID: <46E85DDA.7010209@redhat.com>
Date: Wed, 12 Sep 2007 17:44:58 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Venkat Subbiah <venkats@cranite.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: irq load balancing
References: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
In-Reply-To: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venkat Subbiah wrote:
> Most of the load in my system is triggered by a single ethernet IRQ.
> Essentially the IRQ schedules a tasklet and most of the work is done in the
> taskelet which is scheduled in the IRQ. From what I read looks like the
> tasklet would be executed on the same CPU on which it was scheduled. So this
> means even in an SMP system it will be one processor which is overloaded.
> 
> So will using the user space IRQ loadbalancer really help?

A little bit.  It'll keep other IRQs on different CPUs, which will prevent other 
interrupts from causing cache and TLB evictions that could slow down the 
interrupt handler for the NIC.

> What I am doubtful
> about is that the user space load balance comes along and changes the
> affinity once in a while. But really what I need is every interrupt to go to
> a different CPU in a round robin fashion.

Doing it in a round-robin fashion will be disastrous for performance.  Your 
cache miss rate will go through the roof and you'll hit the slow paths in the 
network stack most of the time.

> Looks like the APIC  can distribute IRQ's dynamically? Is this supported in
> the kernel and any config or proc interface to turn this on/off.

/proc/irq/$FOO/smp_affinity is a bitmask.  You can mask an irq to multiple 
processors.  Of course, this will absolutely kill your performance.  That's why 
irqbalance never does this.

	-- Chris
