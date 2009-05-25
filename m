Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZEYV6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZEYV6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZEYV61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:58:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42853 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZEYV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:58:26 -0400
Date: Mon, 25 May 2009 22:57:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Broken ARM (and powerpc ?) futex wrt memory barriers
Message-ID: <20090525215754.GF3667@n2100.arm.linux.org.uk>
References: <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090525172955.GA17665@Krystal> <20090525195656.GC3667@n2100.arm.linux.org.uk> <20090525202210.GD22651@Krystal> <20090525214533.GA26419@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525214533.GA26419@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 05:45:33PM -0400, Mathieu Desnoyers wrote:
> I think we also have to deal with futexes. See
> arch/arm/include/asm/futex.h :
> 
> 1 - 
> 
> #ifdef CONFIG_SMP
> 
> #include <asm-generic/futex.h>
> 
> #else /* !SMP, we can work around lack of atomic ops by disabling
> preemption */
> 
> (arm-specific code here, seems to deal with futexes)
> 
> #endif
> 
> -> is it just me or this ifdef condition is the exact opposite of what
> it should be ? I thought those generic futexes were for UP-only
> systems...

No, it is correct.  Look deeper - the generic stuff implements a whole
load of futex stuff as returning -ENOSYS - it's not implemented.

What you see in ARM is the UP code implementing the set/add/or/andn/xor
cmpxchg operations.  However, this code is most certainly not SMP safe
(and I couldn't persuade the folk writing it to come up with a SMP
version.)  So, on ARM futex is supported on UP systems, but not SMP
systems until someone gets around to fixing this.
