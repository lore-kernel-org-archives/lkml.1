Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbZE0SlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbZE0SlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbZE0Sk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:40:57 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:44530 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932083AbZE0Sk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:40:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcLAIcjHUpMQW1W/2dsb2JhbACBT5cMtmyEDAU
Date: Wed, 27 May 2009 14:40:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090527184041.GA22545@Krystal>
References: <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090526155906.GC26713@n2100.arm.linux.org.uk> <20090526172322.GB19443@Krystal> <20090526182310.GG26713@n2100.arm.linux.org.uk> <20090527012243.GB29692@Krystal> <1243415686.1947.24.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1243415686.1947.24.camel@pc1117.cambridge.arm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:36:44 up 88 days, 15:02,  4 users,  load average: 0.11, 0.15,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas (catalin.marinas@arm.com) wrote:
> On Tue, 2009-05-26 at 21:22 -0400, Mathieu Desnoyers wrote:
> > So, my questions is : is ARMv7 weak memory ordering model as weak as
> > Alpha ?
> 
> I'm not familiar with Alpha but ARM allows a weakly ordered memory
> system (starting with ARMv6), it's up to the processor implementer to
> decide how weak but within the ARM ARM restrictions (section A3.8.2).
> 
> I think the main difference with Alpha is that ARM doesn't do
> speculative writes, only speculative reads. The write cannot become
> visible to other observers in the same shareability domain before the
> instruction occurs in program order. But because of the write buffer,
> there is no guarantee on the order of two writes becoming visible to
> other observers in the same shareability domain. The reads from normal
> memory can happen speculatively (with a few restrictions)
> 
> Summarising from the ARM ARM, there are two terms used:
> 
>         Address dependency - an address dependency exists when the value
>         returned by a read access is used to compute the virtual address
>         of a subsequent read or write access.
>         
>         Control dependency - a control dependency exists when the data
>         value returned by a read access is used to determine the
>         condition code flags, and the values of the flags are used for
>         condition code checking to determine the address of a subsequent
>         read access.
>         
> The (simplified) memory ordering restrictions of two explicit accesses
> (where multiple observers are present and in the same shareability
> domain):
> 
>       * If there is an address dependency then the two memory accesses
>         are observed in program order by any observer
>       * If the value returned by a read access is used as data written
>         by a subsequent write access, then the two memory accesses are
>         observed in program order
>       * It is impossible for an observer of a memory location to observe
>         a write access to that memory location if that location would
>         not be written to in a sequential execution of a program
> 
> Outside of these restrictions, the processor implementer can do whatever
> it makes the CPU faster. To ensure the relative ordering between memory
> accesses (either read or write), the software should have DMB
> instructions.
> 

Just to make sure :

for the read seqlock, a smp_rmb() is present. I assume that given there
is no address nor control dependency (as stated above) between the
seqlock value reads and the data access, these barriers cannot be
downgraded to a smp read barrier depend. It's a shame to have to do two
full dmb for every sequence lock. Are there any plans on the ARM side to
eventually add faster read barriers ?

Basically, on arm, a seqlock fast path takes 11 cycles on UP. If we add
the two dmb, it now takes 73 cycles.

Mathieu

> -- 
> Catalin
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
