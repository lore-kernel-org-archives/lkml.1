Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZEYPRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZEYPRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZEYPRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:17:33 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:40931 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZEYPRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:17:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQHANdOGkpMQW1W/2dsb2JhbACBT5ZttHiECwU
Date: Mon, 25 May 2009 11:17:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jamie Lokier <jamie@shareable.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090525151724.GA14321@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090525132027.GA946@shareable.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:08:43 up 86 days, 11:34,  5 users,  load average: 0.34, 0.16,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jamie Lokier (jamie@shareable.org) wrote:
> Mathieu Desnoyers wrote:
> > I use a local cmpxchg in the LTTng tree as key instruction to manage the
> > ring buffer in a irq, softirq and NMI-safe way (due to the atomic nature
> > of this instruction), but without the overhead of synchronizing across
> > CPUs.
> > 
> > On ARM, the semantic looks a bit like PowerPC with linked load/linked
> > store, and you don't seem to need memory barriers. I guess that's either
> > because
> > 
> > a) they are implicit in the ll/ls or
> > b) ARM does not perform out-of-order memory read/writes or
> > c) they've simply been forgotten, and it's a bug.
> > 
> > the cmpxchg local instruction maps currently to cmpxchg, as a fallback,
> > since there is no difference between the SMP-aware and UP-only
> > instructions.
> > 
> > But if I look at arch/arm/include/asm/spinlock.h, the answer I get seems
> > to be c) : ARM needs memory barriers.
> 
> Memory barriers only affect the observed access order with respect to
> other processors (and perhaps other devices).
> 
> So a CPU-local operation would not need barriers.  CPU-local code,
> including local IRQs, see all memory accesses in the same order as
> executed instructions.
> 
> Of course you need barriers at some point, when using the local data
> to update global data seen by other CPUs at a later time.  But that is
> hopefully done elsewhere.
> 
> After considering this, do you think it's still missing barriers?
> 

I realize I have not made myself clear, I apologise :

- as you say, cmpxchg_local, xchg_local, local atomic add return do not
  need any memory barrier whatsoever, given they are cpu-local.

- cmpxchg, xchg and atomic add return need memory barriers on
  architectures which can reorder the relative order in which memory
  read/writes can be seen between CPUs, which seems to include recent
  ARM architectures. Those barriers are currently missing on ARM.

Therefore, the standard ARM atomic operations would need to be fixed so
they provide the memory barriers semantic implied in
Documentation/atomic_ops.txt. The current ARM atomic ops, which lack the
proper memory barriers (and are thus only correct on UP) can then be
used as optimized local ops.

Hopefully this is a bit clearer,

Thanks,

Mathieu

> -- Jamie

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
