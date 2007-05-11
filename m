Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXEKSz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXEKSz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbXEKSzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:55:17 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:57006 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173AbXEKSzP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:55:15 -0400
Date: Fri, 11 May 2007 14:55:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <ak@muc.de>,
       systemtap@sources.redhat.com, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       richardj_moore@uk.ibm.com, suparna@in.ibm.com
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070511185514.GA29945@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca> <20070510090656.GA57297@muc.de> <20070510155501.GI22424@Krystal> <20070510172843.7aa72237@the-village.bc.nu> <20070510165918.GK22424@Krystal> <20070511045729.GA8143@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070511045729.GA8143@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 14:48:27 up 98 days,  8:55,  6 users,  load average: 2.17, 2.23, 2.28
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> On Thu, May 10, 2007 at 12:59:18PM -0400, Mathieu Desnoyers wrote:
> > * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> 
> ...
> > > > * Third issue : Scalability. Changing code will stop every CPU on the
> > > >   system for a while. Compared to this, the int3-based approach will run
> > > >   through the breakpoint handler "if" one of the CPU happens to execute
> > > >   this code at the wrong time. The standard case is just an IPI (to
> > > 
> > > If I read the errata right then patching in an int3 will itself trigger
> > > the errata so anything could happen.
> > > 
> > > I believe there are other safe sequences for doing code patching - perhaps
> > > one of the Intel folk can advise ?
> 
> IIRC, when the first implementation of what exists now as kprobes was
> done (as part of the dprobes framework), this question did come up. I
> think the conclusion was that the errata applies only to multi-byte
> modifications and single-byte changes are guaranteed to be atomic.
> Given int3 on Intel is just 1-byte, we are safe.
> 
> > I'll let the Intel guys confirm this, I don't have the reference nearby
> > (I got this information by talking with the kprobe team members, and
> > they got this information directly from Intel developers) but the
> > int3 is the one special case to which the errata does not apply.
> > Otherwise, kprobes and gdb would have a big, big issue.
> 
> Perhaps Richard/Suparna can confirm.
> 

Ha-ha! I found the reference. It's worth quoting in full :
http://sourceware.org/ml/systemtap/2005-q3/msg00208.html
------
From: Richard J Moore <richardj_moore at uk dot ibm dot com>

There is another issue to consider when looking into using probes other
then int3:

Intel erratum 54 - Unsynchronized Cross-modifying code - refers to the
practice of modifying code on one processor where another has prefetched
the unmodified version of the code. Intel states that unpredictable
general protection faults may result if a synchronizing instruction
(iret, int, int3, cpuid, etc ) is not executed on the second processor
before it executes the pre-fetched out-of-date copy of the instruction.

When we became aware of this I had a long discussion with Intel's
microarchitecture guys. It turns out that the reason for this erratum
(which incidentally Intel does not intend to fix) is because the trace
cache - the stream of micorops resulting from instruction interpretation
- cannot guaranteed to be valid. Reading between the lines I assume this
issue arises because of optimization done in the trace cache, where it
is no longer possible to identify the original instruction boundaries.
If the CPU discoverers that the trace cache has been invalidated because
of unsynchronized cross-modification then instruction execution will be
aborted with a GPF. Further discussion with Intel revealed that
replacing the first opcode byte with an int3 would not be subject to
this erratum.

So, is cmpxchg reliable? One has to guarantee more than mere atomicity.

-----

Therefore, it is exactly what my implementation is doing : I make sure
that no CPU sees an out-of-date copy of a pre-fetched instruction by 1 -
using a breakpoint, which skips the instruction that is going to be
modified, 2 - issuing an IPI to every CPU to execute a sync_core(), to
make sure that even when the breakpoint is removed, no cpu could
possibly still have the out-of-date copy of the instruction, modify the
now unused 2nd byte of the instruction, and then put back the original
1st byte of the instruction.

It has exactly the same intent as the algorithm proposed by Intel, but
it has less side-effects, scales better and supports NMI, SMI and MCE.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
