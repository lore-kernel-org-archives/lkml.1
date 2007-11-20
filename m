Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXKTCFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXKTCFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXKTBvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:51:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54426
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756822AbXKTBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:51:17 -0500
Date: Mon, 19 Nov 2007 17:51:16 -0800 (PST)
Message-Id: <20071119.175116.55102316.davem@davemloft.net>
To: clameter@sgi.com
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data
 handling on x86_64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120011132.143632442@sgi.com>
References: <20071120011132.143632442@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: clameter@sgi.com
Date: Mon, 19 Nov 2007 17:11:32 -0800

> Before:
> 
> mov    %gs:0x8,%rdx		Get smp_processor_id
> mov    tableoffset,%rax		Get table base
> incq   varoffset(%rax,%rdx,1)	Perform the operation with a complex lookup
> 				adding the var offset
> 
> An interrupt or a reschedule action can move the execution thread to another
> processor if interrupt or preempt is not disabled. Then the variable of
> the wrong processor may be updated in a racy way.
> 
> After:
> 
> incq   %gs:varoffset(%rip)
> 
> Single instruction that is safe from interrupts or moving of the execution
> thread. It will reliably operate on the current processors data area.
> 
> Other platforms can also perform address relocation plus atomic ops on
> a memory location. Exploiting of the atomicity of instructions vs interrupts
> is therefore possible and will reduce the cpu op processing overhead.
> 
> F.e on IA64 we have per cpu virtual mapping of the per cpu area. If
> we add an offset to the per cpu area variable address then we can guarantee
> that we always hit the per cpu areas local to a processor.
> 
> Other platforms (SPARC?) have registers that can be used to form addresses.
> If the cpu area address is in one of those then atomic per cpu modifications
> can be generated for those platforms in the same way.

Although we have a per-cpu area base in a fixed global register
for addressing, the above isn't beneficial on sparc64 because
the atomic is much slower than doing a:

	local_irq_disable();
	nonatomic_percpu_memory_op();
	local_irq_enable();

local_irq_{disable,enable}() together is about 18 cycles.
Just the cmpxchg() part of the atomic sequence is at least
32 cycles and requires a loop:

	while (1) {
		x = ld();
		if (cmpxchg(x, op(x)))
			break;
	}

which bloats up the atomic version even more.
