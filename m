Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZCMDns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZCMDns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZCMDnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:43:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZCMDni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:43:38 -0400
Date: Fri, 13 Mar 2009 04:43:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090313034301.GE11355@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305043801.GC17747@in.ibm.com> <20090310140950.GD3850@elte.hu> <20090312024617.3F392FC3B6@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312024617.3F392FC3B6@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> Perhaps it would help if asm-generic/hw_breakpoint.h had some 
> kerneldoc comments for the arch-specific functions that the 
> arch's asm/hw_breakpoint.h must define (in the style of 
> asm-generic/syscall.h).  I note that Ingo didn't have any 
> comments about asm-generic/hw_breakpoint.h in his review. Its 
> purpose should be to make any arch maintainer understand why 
> the API it specifies for each arch to meet makes sense across 
> the arch's.
> 
> > why this redirection, why dont just use the structure as-is? 
> > If there's any arch weirdness then that arch should have 
> > arch-special accessors - not the generic code.
> 
> The fields of arch_hw_breakpoint are arch-specific.  Another 
> arch's struct will not have .type and .len fields at all.  
> e.g., on powerpc there is just one size supported, so 
> hw_breakpoint_get_len() would be an inline returning a 
> constant.  Its type is encoded in low bits of the address 
> word, and the arch implementation may not want to use 
> bit-field called .type for that (and if it did, it couldn't 
> use a bit-field called .address with the meaning you'd want it 
> to have).
> 
> Having any fields in arch_hw_breakpoint at all be part of the 
> API restricts the arch implementation unreasonably.  So it has 
> accessors to fetch them instead.  (Arguably we could punt 
> those accessors from the API for hw_breakpoint users, but the 
> arch-independent part of the hw_breakpoint implementation 
> might still want them, I'm not sure.) Likewise, they need to 
> be filled in by setters or by explicit type/len arguments to 
> the registration calls.  This appears to be a tenet we worked 
> out the first time around that has gotten lost in the shuffle 
> more recently.
> 
> I think it would be illustrative to have a second arch 
> implementation to compare to the x86 one.  Ingo has a tendency 
> to pretend everything is an x86 until shown the concrete 
> evidence.  The obvious choice is powerpc. Its facility is very 
> simple, so the arch-specific part of the implementation should 
> be trivial--it's the "base case" of simplest available 
> hw_breakpoint arch, really.  Also, it happens that Prasad's 
> employer is interested in having that support.
> 
> For example, a sensible powerpc implementation would clearly 
> demonstrate why you need accessors or at least either 
> pre-registration setters or explicit type/len arguments in 
> registration calls.

That would help. I indeed have a tendency to strike out code 
that's not immediately needed, i also tend to make sure that 
design is sane on the platform that 95%+ of our active 
developers/users use.

The core issue being discussed is the debug register allocation 
and scheduling model though, and you have not directly commented 
on that.

My argument in a nutshell is that a bottom-up for user + 
top-down for kernel use static allocator with no dynamic 
scheduling will get us most of the benefits with a tenth of the 
complexity.

	Ingo
