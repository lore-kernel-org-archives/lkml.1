Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZEZT46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZEZT46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbZEZT4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:56:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51323 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZEZT4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:56:50 -0400
Date: Tue, 26 May 2009 20:56:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090526195614.GJ26713@n2100.arm.linux.org.uk>
References: <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090526155906.GC26713@n2100.arm.linux.org.uk> <20090526172322.GB19443@Krystal> <20090526182310.GG26713@n2100.arm.linux.org.uk> <20090526191729.GA12144@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526191729.GA12144@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 08:17:29PM +0100, Jamie Lokier wrote:
> That looks mistaken.  The middle asm can move if it does not contain
> any memory accesses.  As you say, the first and third asm are compiler
> *memory* barriers, and the middle asm doesn't access memory as far as
> GCC is concerned.

Yes, you're strictly right.

> Looking at the constraints for __xchg:
> 
>      : "=&r" (ret), "=&r" (tmp)
>      : "r" (x), "r" (ptr)
>      : "cc"
> 
> *We* know the asm accesses memory, but GCC doesn't - it just sees
> four numbers going in and coming out in registers.
> 
> So GCC can move it past the barriers before and after.
> 
> You might be able to rewrite it as "m" (*ptr) for the 4th argument and
> a different way of expanding that in the asm itself.  You'd have to
> make it an input-output argument, so "=&m" (*ptr) in the outputs.  It
> used to be thought that GCC could theoretically fetch the value into a
> temporary register, and store it again after the asm, but nowadays I'm
> pretty sure you're allowed to depend on memory constraints.

However, I think we do need to bother with this in some way (and "memory"
doesn't quite do the job):

   If your assembler instructions access memory in an unpredictable
  fashion, add `memory' to the list of clobbered registers.  This will
  cause GCC to not keep memory values cached in registers across the
  assembler instruction and not optimize stores or loads to that memory.
  You will also want to add the `volatile' keyword if the memory affected
  is not listed in the inputs or outputs of the `asm', as the `memory'
  clobber does not count as a side-effect of the `asm'.

See that last sentence - not only do we need "memory" but seemingly also
"volatile" as well.

I don't know if "m" does the job - because there's several different
ways to access memory (eg pre-indexed offsets, single register) and
only one is supported for swp/ldrex/strex.  It's unclear from the GCC
documentation what assembly patterns "m" maps to so I've steared clear
of it and explicitly told the compiler what we want (a register
containing the address, thank you very much).
