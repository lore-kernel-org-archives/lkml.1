Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYIXJ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYIXJ6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYIXJ6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:58:35 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3011 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYIXJ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:58:34 -0400
Date: Wed, 24 Sep 2008 04:58:22 -0500 (CDT)
Message-Id: <200809240958.m8O9wM7k010996@sullivan.realtime.net>
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with hardirq preemption
In-Reply-To: <200809231743.23828.ossthema@de.ibm.com>
References: <200809231743.23828.ossthema@de.ibm.com>,
	<20080915100406.342e027a@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd wrote:
> Ben, can you / your team look into the implementation
> of the set_irq_type functionality needed for XICS?

I'm not volunteering to look at or implement any changes for how xics
works with generic irq, but I'm trying to understand what the rt kernel
is trying to accomplish with this statement:

On Mon Sep 15 at 18:04:06 EST in 2008, Sebastien Dugue wrote:
> When entering the low level handler, level sensitive interrupts are
> masked, then eio'd in interrupt context and then unmasked at the
> end of hardirq processing.  That's fine as any interrupt comming
> in-between will still be processed since the kernel replays those
> pending interrupts.

Is this to generate some kind of software managed nesting and priority
of the hardware level interrupts?

The reason I ask is the xics controller can do unlimited nesting
of hardware interrupts.  In fact, the hardware has 255 levels of
priority, of which 16 or so are reserved by the hypervisor, leaving
over 200 for the os to manage.  Higher numbers are lower in priority,
and the hardware will only dispatch an interrupt to a given cpu if
it is currenty at a lower priority.  If it is at a higher priority
and the interrupt is not bound to a specific cpu it will look for
another cpu to dispatch it.  The hardware will not re-present an
irq until the it is EOId (managed by a small state machine per
interrupt at the source, which also handles no cpu available try
again later), but software can return its cpu priority to the
previous level to recieve other interrupt sources at the same level.
The hardware also supports lazy update of the cpu priority register
when an interrupt is presented; as long as the cpu is hard-irq
enabled it can take the irq then write is real priority and let the
hw decide if the irq is still pending or it must defer or try another
cpu in the rejection scenerio.  The only restriction is that the
EOI can not cause an interrupt reject by raising the priority while
sending the EOI command.

The per-interrupt mask and unmask calls have to go through RTAS, a
single-threaded global context, which in addition to increasing
path length will really limit scalability.  The interrupt controller
poll and reject facilities are accessed through hypervisor calls
which are comparable to a fast syscall, and parallel to all cpus.

We used to lower the priority to allow other interrupts in, but we
realized that in addition to the questionable latency in doing so,
it only caused unlimited stack nesting and overflow without per-irq
stacks.  We currently set IPIs above other irqs so we typically
only process them during a hard irq (but we return to base level
after IPI and could take another base irq, a bug).


So, Sebastien, with this information, is does the RT kernel have
a strategy that better matches this hardware?

milton
