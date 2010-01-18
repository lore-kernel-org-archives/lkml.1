Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129Ab0ARViL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0ARViL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060Ab0ARViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:38:08 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:57639 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119Ab0ARVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:37:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkFAEJdVEuuWOiG/2dsb2JhbACBRtNJhDME
Date: Mon, 18 Jan 2010 16:32:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100118213254.GA26355@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com> <20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com> <4B548B09.7040309@zytor.com> <20100118165231.GA29764@Krystal> <4B54AD7C.9000505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B54AD7C.9000505@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:02:27 up 33 days,  5:20,  7 users,  load average: 0.04, 0.07,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 01/18/2010 08:52 AM, Mathieu Desnoyers wrote:
> >>
> >> This really doesn't make much sense to me.  The whole basis for the int3
> >> scheme itself is that single-byte updates are atomic, so if single-byte
> >> updates can't work -- and as I stated, we at Intel OTC currently believe
> >> it safe -- then int3 can't work either.
> > 
> > The additional characteristic of the int3 instruction (compared to the
> > general case of a single-byte instruction) is that, when executed, it
> > will trigger a trap, run a trap handler and return to the original code,
> > typically with iret. This therefore implies that a serializing
> > instruction is executed before returning to the instructions following
> > the modification site when the breakpoint is hit.
> > 
> > So I hand out to Intel's expertise the question of whether single-byte
> > instruction modification is safe or not in the general case. I'm just
> > pointing out that I can very well imagine an aggressive superscalar
> > architecture for which pipeline structure would support single-byte int3
> > patching without any problem due to the implied serialization, but would
> > not support the general-case single-byte modification due to its lack of
> > serialization.
> > 
> 
> This is utter and complete nonsense.   You seem to think that everything
> is guaranteed to hit the breakpoint, which is obviously false.

What I discuss above is: what actually happens when the breakpoint is
hit.

I'm doing no assumption about whether it is hit or not. In the int3+IPI
broadcast scheme, every cpu receive an IPI between seeing the old and
new instructions. Only *some* cpus *may* hit the breakpoint that is put
there temporarily.

> Furthermore, until you have done the serialization, you're not
> guaranteed the *breakpoint* is seen,

Agreed,

> so you have the same condition.

Hrm ? Same as what exactly ? We have either the old instruction in place
or the breakpoint (before the serialization). After the serialization,
we have either the breakpoint or the new instruction.

What I am pointing out is that specifically turning a 1-byte instruction
into a breakpoint can be safer than turning it into another 1-byte
instruction directly, because *if* cpus hit the breakpoint, they *will*
issue a synchronizing instruction at that point (implied by the
breakpoint). This is not the case if you just modify the 1-byte
instruction in place.

> 
> > As we might have to port this algorithm to Itanium in a near future, I
> > prefer to stay on the safe side. Intel's "by the book" recommendation is
> > more or less that a serializing instruction must be executed on all CPUs
> > before new code is executed, without mention of single-vs-multi byte
> > instructions. The int3-based bypass follows this requirement, but the
> > single-byte code patching does not.
> > 
> > Unless there is a visible performance gain to special-case the
> > single-byte instruction, I would recommend to stick to the safest
> > solution, which follows Intel "official" guide-lines too.
> 
> No, it doesn't.  The only thing that follows the "official" guidelines
> is stop_machine.
> 
> As far as other architectures are concerned, other architectures can
> have very different and much stricter rules for I/D coherence.  Trying
> to extrapolate from the x86 rules is aggravated insanity.

I agree that official Intel guidelines for XMC only discuss the
stop_machine() scheme. OK then, let's see how patching single-byte
instructions deals with the official _uniprocessor_ self-modifying code
guidelines.

(ref. http://www.intel.com/Assets/PDF/specupdate/318586.pdf
7.1.3 Handling Self- and Cross-Modifying Code)

(* OPTION 1 *)
Store modified code (as data) into code segment;
Jump to new code or an intermediate location;
Execute new code;

(* OPTION 2 *)
Store modified code (as data) into code segment;
Execute a serializing instruction; (* For example, CPUID instruction *)
Execute new code;

As you can see, if we self-modify the code on a single cpu machine with
text_poke directly, even for a single-byte instruction, we _have_ to
guarantee that either a jump or a serializing instruction is issued
before the new code is executed.

What I discussed above was that int3 is a special-case, because it
generates a trap, and therefore jumps to a different location.

So, back to the case where we could "simply patch-in any single-byte
instruction in a SMP system", I argue that this is against the
uniprocessor part of the errata, which clearly also applies to SMP.

By the way, I've looked at the Itanium documents a few years ago, and
I have not seen any reason at that time why the breakpoint+IPI scheme
would not work if we additionally perform the appropriate I and D cache
flushes. The rest of the requirements are _very_ similar.

Thanks,

Mathieu


> 
> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
