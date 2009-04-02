Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbZDBFch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbZDBFch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZDBFcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:32:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZDBFcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:32:07 -0400
Date: Thu, 2 Apr 2009 01:32:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: Ftrace code in the 2.6.29 kernel
In-Reply-To: <20090402045104.GA21896@Krystal>
Message-ID: <alpine.DEB.2.00.0904020121220.30963@gandalf.stny.rr.com>
References: <20090402045104.GA21896@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Apr 2009, Mathieu Desnoyers wrote:

> Hi Steven,
> 
> I am giving a look at the ftrace code, and I am a bit confused by the
> way you handle reentrancy in ring_buffer.c. (this is the code in 2.6.29)
> Please tell me if I missed important details :
> 
> 1) you seem to have removed any sort of "nesting" check to allow NMI
> handlers to run. Previously, I remember that you simply discarded the
> event if a NMI handler appeared to run over the ring buffer code.

I did not remove anything. The code you refer to is queued up for 2.6.30.
When that code gets into mainline, we may be able to get it to stable if 
needed.

> 
> 2) Assuming 1) is true, then __rb_reserve_next() called from
> ring_buffer_lock_reserve() is protected by :
> 
>                local_irq_save(flags);
>                 __raw_spin_lock(&cpu_buffer->lock);
> 
> Which I think is the last thing you want to see in a NMI handler. It
> sounds like this code is begging for a deadlock to occur if run in NMI
> context. Or maybe you don't claim that this code supports NMI, but then
> you should remove the following comment from ring_buffer.c :
> 
> rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
> {
>         /*
>          * We only race with interrupts and NMIs on this CPU.
> 
> So basically, if an NMI nests over that code, or if an instrumented
> fault happens within the ring_buffer code, this would generate an
> infinite recursive call chain of trap/tracing/trap/tracing...
> 
> So this is why I think I might have missed a sanity check somewhere.

Nope, you just saw patches that I sent to fix this issue, but those were 
not accepted into mainline. Luckily, 29 does not have many NMI users 
(function tracer is one, but that has its own nested protections).

2.6.30 will have the NMI protection.

2.6.31 will have a completely writer lockless ring buffer solution.

-- Steve

