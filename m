Return-Path: <linux-kernel-owner+w=401wt.eu-S1763193AbZD3ORh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763193AbZD3ORh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZD3OR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:17:27 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:39406 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762603AbZD3OR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:17:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsFABJP+UlMQW1W/2dsb2JhbACBUM41g38F
Date: Thu, 30 Apr 2009 10:12:11 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, Tejun Heo <tj@kernel.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Andrew Morton <akpm@linux-foundation.org>, thomas.pi@arcor.dea,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430141211.GB5922@Krystal>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904300926530.22262@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:54:36 up 61 days, 10:20,  1 user,  load average: 0.99, 0.87,
	0.70
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> > > I see however that it's only guaranteed to be atomic wrt preemption.
> >
> > That's really only true for the non-x86 fallback defines. If we so
> > decide, we could make the fallbacks in asm-generic/percpu.h irq-safe
> 
> The fallbacks have different semantics and therefore we cannot rely on
> irq safeness in the core code when using the x86 cpu ops.
> 
> > nmi-safe isnt a big issue (we have no NMI code that interacts with
> > MM counters) - and we could make them irq-safe by fixing the
> > wrapper. (and on x86 they are NMI-safe too.)
> 
> There are also context in which you alrady are preempt safe and where the
> per cpu ops do not need to go through the prremption hoops.
> 
> This means it would be best to have 3 variants for 3 different contexts in
> the core code:
> 
> 1. Need irq safety
> 2. Need preempt safety
> 3. We know the operation is safe due to preemption already having been
> disabled or irqs are not enabled.
> 
> The 3 variants on x86 generate the same instructions. On other platforms
> they would need to be able to fallback in various way depending on the
> availability of instructions that are atomic vs. preempt or irqs.
> 

The problem here, as we did figure out a while ago with the atomic
slub we worked on a while ago, is that if we have the following code :

local_irq_save
var++
var++
local_irq_restore

that we would like to turn into irq-safe percpu variant with this
semantic :

percpu_add_irqsafe(var)
percpu_add_irqsafe(var)

We are generating two irq save/restore in the fallback, which will be
slow.

However, we could do the following trick :

percpu_irqsave(flags);
percpu_add_irq(var);
percpu_add_irq(var);
percpu_irqrestore(flags);

And we could require that percpu_*_irq operations are put within a
irq safe section. The fallback would disable interrupts, but
arch-specific irq-safe atomic implementations would replace this by
nops.

And if interrupts are already disabled, percpu_add_irq could be used
directly. There is no need to duplicate the primitives (no
_percpu_add_irq() needed). Same could apply to preempt-safety :

percpu_preempt_disable();
percpu_add(var);
percpu_add(var);
percpu_preempt_enable();

Where requirements on percpu_add would be to be called within a
percpu_preempt_disable/percpu_preempt_enable section or to be sure that
preemption is already disabled around.

Same thing could apply to bh. But I don't see any difference between
percpu_add_bh and percpu_add_irq, except maybe on architectures which
would use tri-values :

percpu_bh_disable();
percpu_add_bh(var);
percpu_add_bh(var);
percpu_bh_enable();

Thoughts ?

Mathieu

> http://thread.gmane.org/gmane.linux.kernel.cross-arch/1124
> http://lwn.net/Articles/284526/
> 
> 
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
