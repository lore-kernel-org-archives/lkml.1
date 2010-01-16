Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0APKdx (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 05:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729Ab0APKdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 05:33:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0APKdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 05:33:51 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263603503.5007.134.camel@localhost.localdomain>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546175.4244.342.camel@laptop>
	 <1263589634.5007.34.camel@localhost.localdomain>
	 <1263592192.4244.488.camel@laptop>
	 <1263603503.5007.134.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 11:33:17 +0100
Message-ID: <1263637997.4244.555.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 16:58 -0800, Jim Keniston wrote:
> But here are some things to keep in mind about the
> various approaches:
> 
> 1. Single-stepping inline is easiest: you need to know very little about
> the instruction set you're probing.  But it's inadequate for
> multithreaded apps.
> 2. Single-stepping out of line solves the multithreading issue (as do #3
> and #4), but requires more knowledge of the instruction set.  (In
> particular, calls, jumps, and returns need special care; as do
> rip-relative instructions in x86_64.)  I count 9 architectures that
> support kprobes.  I think most of these do SSOL.
> 3. "Boosted" probes (where an appended jump instruction removes the need
> for the single-step trap on many instructions) require even more
> knowledge of the instruction set, and like SSOL, require XOL slots.
> Right now, as far as I know, x86 is the only architecture with boosted
> kprobes.
> 4. Emulation removes the need for the XOL area, but requires pretty much
> total knowledge of the instruction set.  It's also a performance win for
> architectures that can't do #3.  I see kvm implemented on 4
> architectures (ia64, powerpc, s390, x86).  Coincidentally, those are the
> architectures to which uprobes (old uprobes, with ubp and xol bundled
> in) has already been ported (though Intel hasn't been maintaining their
> ia64 port). 

Right, so I was thinking a combination of 4 and execute from kernel
space would be feasible. I would think most regular instructions are
runnable from kernel space given that we provide the proper pt_regs
environment.

Although I just realize we need to fully emulate the address computation
step for all memory writes, otherwise a wild userspace pointer might end
up writing in your kernel image.

Also, don't we already need full knowledge of the instruction set in
order to decode the instruction stream and find instruction boundaries.

> So it sort of comes down to how objectionable the XOL vma (or page)
> really is.

Well, I really hate touching the address space, and the fact that it
permutates the probed application in very obvious ways.

FWIW, I think the VDSO is ugly too and would have objected to it were it
proposed now -- there's much better solutions for that
(/sys/lib/libkernel.so comes to mind).

> Regarding your suggestion about executing the probed instruction in the
> kernel, how widely do you think that can be applied: which
> architectures?  how much of the instruction set?

I only know some of x86, I really couldn't tell for any other arch.

