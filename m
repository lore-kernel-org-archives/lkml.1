Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbZCBTwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbZCBTwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZCBTwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:52:39 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:57916 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754267AbZCBTwi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:52:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFANPBq0lMQW1W/2dsb2JhbACBWdRAhBoG
Date: Mon, 2 Mar 2009 14:47:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
Message-ID: <20090302194730.GA26879@Krystal>
References: <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302102841.7e099670@infradead.org> <20090302183617.GA25105@Krystal> <20090302105500.569e1270@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090302105500.569e1270@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:14:38 up 2 days, 15:40,  3 users,  load average: 0.13, 0.35,
	0.40
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 2 Mar 2009 13:36:17 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Arjan van de Ven (arjan@infradead.org) wrote:
> > > > 
> > > > Use map_vm_area() instead of vmap() in text_poke() for avoiding
> > > > page allocation and delayed unmapping, and call
> > > > vunmap_page_range() and local_flush_tlb() directly because this
> > > > mapping is temporary and local.
> > > > 
> > > > At the result of above change, text_poke() becomes atomic and can
> > > > be called from stop_machine() etc.
> > > 
> > > .... but text_poke() realistically needs to call stop_machine()
> > > since you can't poke live code.... so that makes me wonder how
> > > useful this is...
> > 
> > Hi Arjan,
> > 
> > Stop machine is not required when inserting a breakpoint. 
> 
> that is your assumption; when I spoke with CPU architects they
> cringed ;(
> 

Given you are not citing any technical material, I guess you are
refering to :

Intel® Core™2 Duo Processor E8000Δ and E7000Δ Series
http://download.intel.com/design/processor/specupdt/318733.pdf (page 46)

AW75. Unsynchronized Cross-Modifying Code Operations Can Cause
Unexpected Instruction Execution Results

Am I correct ? This errata has been around since the Pentium III and is
still valid today. Other current CPUs with this errata :

Intel® Atom™ Processor Z5xxΔ Series
http://download.intel.com/design/processor/specupdt/319536.pdf (page 22)
AAE18 Unsynchronized Cross-Modifying Code Operations Can Cause
Unexpected Instruction Execution Results


First point : given your statement, kprobes would be buggy on x86 _and_
ia64. If this is true, then it should be addressed. If not, then we
should not worry about it.


The algorithm they propose to work around the architectural limitations
is stated here :
http://download.intel.com/design/PentiumII/manuals/24319202.pdf
7.1.3 Handling Self- and Cross-Modifying Code

Basically implies using something like stop-machine. However, if we read
carefully the few amount of information available in this errata :

"The act of a processor writing data into a currently executing code
segment with the intent of executing that data as code is called
self-modifying code. Intel Architecture processors exhibit
model-specific behavior when executing self-modified code, depending
upon how far ahead of the current execution pointer the code has been
modified. As processor architectures become more complex and start to
speculatively execute code ahead of the retirement point (as in the P6
family processors), the rules regarding which code should execute, pre-
or post-modification, become blurred."

Basically, this points to the speculative code execution as being the
core of the problems encountered with code modification. But given int3
*IS* a _serializing_ instruction, it is not affected by this errata.
Quoting Richard J Moore from IBM from a discussion we had a few years
ago :

 * "There is another issue to consider when looking into using probes other
 * then int3:
 *
 * Intel erratum 54 - Unsynchronized Cross-modifying code - refers to the
 * practice of modifying code on one processor where another has prefetched
 * the unmodified version of the code. Intel states that unpredictable general
 * protection faults may result if a synchronizing instruction (iret, int,
 * int3, cpuid, etc ) is not executed on the second processor before it
 * executes the pre-fetched out-of-date copy of the instruction.
 *
 * When we became aware of this I had a long discussion with Intel's
 * microarchitecture guys. It turns out that the reason for this erratum
 * (which incidentally Intel does not intend to fix) is because the trace
 * cache - the stream of micro-ops resulting from instruction interpretation -
 * cannot be guaranteed to be valid. Reading between the lines I assume this
 * issue arises because of optimization done in the trace cache, where it is
 * no longer possible to identify the original instruction boundaries. If the
 * CPU discoverers that the trace cache has been invalidated because of
 * unsynchronized cross-modification then instruction execution will be
 * aborted with a GPF. Further discussion with Intel revealed that replacing
 * the first opcode byte with an int3 would not be subject to this erratum.
 *
 * So, is cmpxchg reliable? One has to guarantee more than mere atomicity."

Therefore, I think assuming int3 as safe for _synchronized_ XMC is ok.
The multi-step algorithm I use to perform code modification in my
immediate values patch based on int3 basically writes the int3, sends an
IPI to _each_ CPU to make sure they issue a synchronizing instruction
(cpuid) and then I can safely proceed to change the instruction,
including the first byte, because I know that all CPUs which could have
potentially seen the old instruction have had the seen the new version
(breakpoint) and have issued a synchronizing instruction (in that order).
Note that I put a smp_wmb() after the int3 write, and a smp_rmb() in the
IPI handler before the cpuid instruction.

Note that extra care will have to be taken to handle synchronization of
instruction and data caches on the Itanium, but this is a different
architecture and topic, which is not the primary focus of our discussion
here :
Cache Coherency in Itanium® Processor Software
http://cache-www.intel.com/cd/00/00/21/57/215792_215792.pdf

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
