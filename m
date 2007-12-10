Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbXLJAeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbXLJAeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 19:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXLJAd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 19:33:57 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:47585 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbXLJAd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 19:33:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAsYXEdMROHU/2dsb2JhbACBWg
Date: Sun, 9 Dec 2007 19:28:51 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch-early-RFC 00/10] LTTng architecture dependent
	instrumentation
Message-ID: <20071210002851.GA21871@Krystal>
References: <20071206025650.451824066@polymtl.ca> <20071206101112.GB17299@elte.hu> <20071208190504.GA30538@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071208190504.GA30538@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:14:19 up 36 days,  5:19,  3 users,  load average: 0.54, 0.39,
	0.31
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > hi Mathieu,
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Hi,
> > > 
> > > Here is the architecture dependent instrumentation for LTTng. [...]
> > 
> > A fundamental observation about markers, and i raised this point many 
> > many months ago already, so it might sound repetitive, but i'm unsure 
> > wether it's addressed. Documentation/markers.txt still says:
> > 
> > | * Purpose of markers
> > |
> > | A marker placed in code provides a hook to call a function (probe) 
> > | that you can provide at runtime. A marker can be "on" (a probe is 
> > | connected to it) or "off" (no probe is attached). When a marker is 
> > | "off" it has no effect, except for adding a tiny time penalty 
> > | (checking a condition for a branch) and space penalty (adding a few 
> > | bytes for the function call at the end of the instrumented function 
> > | and adds a data structure in a separate section).
> > 
> > could you please eliminate the checking of the flag, and insert a pure 
> > NOP sequence by default (no extra branches), which is then patched in 
> > with a function call instruction sequence, when the trace point is 
> > turned on? (on architectures that have code patching infrastructure - 
> > such as x86)
> > 
> 
> Hi Ingo,
> 
[...] 
> * No marker at all
> 
> 240300 cycles total
> 12.02 cycles per loop
> 
[...]
> * With my marker implementation (load immediate 0, branch predicted) :
> 
> between 200355 and 200580 cycles total (avg 200400 cycles)
> 10.02 cycles per loop (yes, adding the marker increases performance)
> 
[...]
> * With NOPs :
> 
> avg around 410000 cycles total
> 20.5 cycles/loop (slowdown of 2)
> 
>
[...]
> Therefore, because of the cost of stack setup, the load immediate and
> conditionnal branch seems to be _much_ faster than the NOP alternative.
> 

I wanted to know what clever things the dtrace guys have done, so I just
dug into the dtrace code today, and it isn't pretty for x86.

For the kernel sdt (static dtrace), the closest match to markers, they :

1 - Use the linker to turn the calls to an undefined symbol into 
"0x90 0x90 0x90 0x90 0x90" (5 nops)
(note that they still suffer from the stack setup cost even when
disabled. Therefore, performance-wise, I think the markers are already
faster)

But let's dig deeper..

2 - When what they call a "provider" is actvated, the first byte of the
"instruction" (actually, it would be the second NOP) is changed for a f0
lock prefix) :

"0x90 0xf0 0x90 0x90 0x90"

3 - When this site is hit, the 0xf0 0x90 instruction will produce an
illegal op fault. In the handler, they emulate a trap by incrementing
EIP of the size of the illegal op. They lookup the faulty EIP in a hash
table to know which site caused it and then they call the dtrace_probe
function to call the consumers from there.

So, if I have not missed anything, they will have the performance cost
of a fault and a hash table lookup on the critical path, which is kind
of dumb. Just the fault adds a few thousand cycles (assuming it will
perform like an int3 breakpoint).

Compared to this, my approach of load immediate + branch when disabled
and the added function call when enabled are _much_ more lighweight.

I guess the dtrace approach is good enough on sparc (except for stack
setup cost when disabled), where they patch the 4 bytes nop into a 4
byte function call and manage to get good performance, but the hack they
are doing on x86 seems to be just too slow.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
