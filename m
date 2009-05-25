Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZEYVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZEYVpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZEYVpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:45:44 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:34211 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbZEYVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:45:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At8EAMCqGkpMQW1W/2dsb2JhbACBT8ovhAsF
Date: Mon, 25 May 2009 17:45:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Broken ARM (and powerpc ?) futex wrt memory barriers
Message-ID: <20090525214533.GA26419@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090525172955.GA17665@Krystal> <20090525195656.GC3667@n2100.arm.linux.org.uk> <20090525202210.GD22651@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090525202210.GD22651@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:30:02 up 86 days, 17:56,  7 users,  load average: 0.19, 0.19,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> > Hmm, the mutex is undocumented in the atomic ops document.  Does it
> > require ordering both before and after, or do some of those ops just
> > need it before acquire and after release?
> > 
> 
> I guess the mutex fast path should probably be added to atomic_ops.txt.
> If I look at PowerPC mutex.h, mutex lock provides acquire semantic (like
> spinlock) and mutex unlock provides release semantic (like spin unlock).
> 
> acquire :
> 
> take lock
> smp_mb()
> (critical section memory accesses)
> 
> release :
> 
> (critical section memory accesses)
> smp_mb()
> release lock

* ARM

I think we also have to deal with futexes. See
arch/arm/include/asm/futex.h :

1 - 

#ifdef CONFIG_SMP

#include <asm-generic/futex.h>

#else /* !SMP, we can work around lack of atomic ops by disabling
preemption */

(arm-specific code here, seems to deal with futexes)

#endif

-> is it just me or this ifdef condition is the exact opposite of what
it should be ? I thought those generic futexes were for UP-only
systems...

Given futexes are used as key element of userspace mutex slow path
implementation, I think we should consider adding memory barriers there
too.


* PowerPC

Powerpc futex.h seems to have a LWSYNC_ON_SMP/ISYNC_ON_SMP before/after
the futex atomic operation, which act as memory barriers.

Interestingly enough, powerpc futex.h:futex_atomic_cmpxchg_inatomic()
has both LWSYNC_ON_SMP (before atomic op) and ISYNC_ON_SMP (after); this
is typical for all powerpc atomic ops. However, __futex_atomic_op() only
has the LWSYNC_ON_SMP. Is there a reason for not having a ISYNC_ON_SMP
there ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
