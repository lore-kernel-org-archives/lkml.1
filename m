Return-Path: <linux-kernel-owner+w=401wt.eu-S934919AbYD1Oft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934919AbYD1Oft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934514AbYD1OfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:35:23 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:49755 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451AbYD1OfW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:35:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FAPt8FUhMROPA/2dsb2JhbACBU6hb
Date: Mon, 28 Apr 2008 10:35:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080428143519.GC4821@Krystal>
References: <20080428033415.303000651@polymtl.ca> <20080428124833.GE27997@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080428124833.GE27997@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:38:57 up 59 days,  9:49,  5 users,  load average: 0.47, 0.65,
	0.61
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Ingo,
> > 
> > Here is the update to the jump patching optimization taking care of 
> > Peter's comments about register liveliness and instruction re-use by 
> > gcc optimizations. A good thing : it actually simplifies the code. 
> > Unfortunately, it adds 3 bytes to the instructions in i-cache because 
> > I now have to use a 5-bytes mov instruction so I can replace it with a 
> > 5-bytes jump. Therefore, 9 bytes are added to rather small functions 
> > (5-bytes mov + 2-bytes test + 2 bytes conditional branch) and 13 bytes 
> > are added to larger functions which needs a 6 bytes conditional branch 
> > at the branch site.
> > 
> > Instead of having to execute a sequence of nop, nop and jump, we now 
> > only have to execute the near jump, which jumps either at the address 
> > following the conditional branch or at the target address of the 
> > conditional branch, depending on the immediate value variable state.
> > 
> > Thanks to Peter for the review.
> 
> thanks Mathieu, i've queued them up for more testing. Your previous 
> queue already looked good here so i pushed it out into sched-devel.git 
> as you probably noticed.
> 

Yes, thanks,

> Sidenote, without trying to bikeshed paint this issue too much: are we 
> absolutely sure that (on modern CPU architectures) such a short jump is 
> better than just 2-3 NOPs in a sequence? It's a minor (sub-cycle) detail 
> in any case.
> 
> 	Ingo

Let's see :

Paraphrasing the
"Intel® 64 and IA-32 Architectures Optimization Reference Manual" :
http://www.intel.com/design/processor/manuals/248966.pdf

3.5.1.8 Using NOPs

The 1-byte nop, xchg %eax,%eax, is treated specially by the cpu. It
takes only one µop and does not have register dependencies. However,
what we would need here is likely a 5-bytes nop.

The generic 5-bytes nop found in asm-x86/nops.h is :

#define GENERIC_NOP1 ".byte 0x90\n"
#define GENERIC_NOP4 ".byte 0x8d,0x74,0x26,0x00\n"
#define GENERIC_NOP5 GENERIC_NOP1 GENERIC_NOP4

In Intel's guide, they propose a single instruction :
NOP DWORD PTR [EAX + EAX*1 + 0] (8-bit displacement)

(0F 1F 44 00 00H)

Which would be required for correct code patching, since we cannot
safely turn a 1+4 bytes sequence of instruction into a single 5-bytes
call without suffering from possible preempted threads returning in the
middle of the instruction. Since the 5-bytes nop does not seem to be
available on architectures below P6, I think this would be a backward
compatibility problem.

K8 NOP 5 also uses a combination of K8_NOP3 K8_NOP2, so this is not only
backward compatibility, but also a concern for current AMD
compatibility. (same issue for K7 5-bytes nop).

However, if we forget about this issue and take for granted that we can
use a single nop instruction that would only take a single µop and have
no external effect (that would be the ideal P6 and + world), the
closest comparison with the jmp instruction I found is the jcc
(conditional branch) instruction in the same manual, Appendix C, where
they list jcc as having 0 latency when not taken and to have a bandwidth
of 0.5, compared to a latency of 1 and bandwidth of 0.33 to 0.5 for nop.

So, just there, a single jmp instruction would seem to have a lower
latency than the nop. (0 cycle vs 1 cycle)

Another interested reading in this document is about conditional
branches :

3.4.1 Optimizing the Front End

Some interesting guide lines :
- Eliminate branches whenever possible
- Separate branches so that they occur no more frequently than every 3 µops
  where possible

3.4.1.1 Eliminating branches improve performance because :
- It eliminates the number of BTB (branch target buffer) entries.
  However, cond. branches which are never taken do not consume BTB
  resources (that's interesting).

3.4.1.3 Static Prediction

Basically, if there is no BTB entry for a branch, if the target address
is forward, static prediction goes forward, and if it goes backward
(loop), static pred. is to go backward. (no surprise here)

Given that the unlikely code is normally at the bottom of functions, the
static prediction would correctly predict the not taken case. So,
disabled markers would not consume any BTB entry, but each enabled
marker would consume a BTB entry.

So, in the end, it looks like the non-taken jcc vs jmp instructions have
the same impact on the system, except that the non-taken jcc must be
preceded by movb (latency 1, bw 0.5 to 1) and test instructions (latency
1, bw 0.33 to 0.5), for a total of 2 latency cycles for the
movb+test+jcc vs 0 latency cycles for the jmp.

Therefore, jmp wins over jcc in the disabled case (latency 0 vs 2) and
in the enabled case even more, since it won't consume any BTB entry.

Oh, and for NOPs vs jmp/jcc, I think not having a single instruction
5-byte nop on every architectures (below P6 and AMD) just disqualifies
it. Even if it would qualify, jmp wins the latency game 0 to 1.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
