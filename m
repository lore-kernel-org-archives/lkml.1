Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbXLFOYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbXLFOYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 09:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXLFOYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 09:24:17 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:35145 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXLFOYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 09:24:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFeUV0dMROHU/2dsb2JhbACBWg
Date: Thu, 6 Dec 2007 09:19:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch-early-RFC 00/10] LTTng architecture dependent
	instrumentation
Message-ID: <20071206141911.GB10542@Krystal>
References: <20071206025650.451824066@polymtl.ca> <20071206101112.GB17299@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071206101112.GB17299@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:08:18 up 32 days, 19:13,  4 users,  load average: 1.83, 1.20,
	0.68
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> hi Mathieu,
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi,
> > 
> > Here is the architecture dependent instrumentation for LTTng. [...]
> 
> A fundamental observation about markers, and i raised this point many 
> many months ago already, so it might sound repetitive, but i'm unsure 
> wether it's addressed. Documentation/markers.txt still says:
> 
> | * Purpose of markers
> |
> | A marker placed in code provides a hook to call a function (probe) 
> | that you can provide at runtime. A marker can be "on" (a probe is 
> | connected to it) or "off" (no probe is attached). When a marker is 
> | "off" it has no effect, except for adding a tiny time penalty 
> | (checking a condition for a branch) and space penalty (adding a few 
> | bytes for the function call at the end of the instrumented function 
> | and adds a data structure in a separate section).
> 
> could you please eliminate the checking of the flag, and insert a pure 
> NOP sequence by default (no extra branches), which is then patched in 
> with a function call instruction sequence, when the trace point is 
> turned on? (on architectures that have code patching infrastructure - 
> such as x86)
> 
> 	Ingo

Hi Ingo,

Do you propose that we NOP out the entire function call stack setup and
other related inline functions and pointer dereferences that would be
needed by the call ?

I don't see how we can do this on optimized code without having
side-effects. So there, I think markers could have even less side-effect
than the dtrace NOPs, because I can jump over all the function call
preparation, which they can't. And branch prediction logic is cheap
nowadays, especially since this is a likely branch. However,
benchmarking the "real" impact of this becomes kind of crazy, because it
may depend on workloads, memory pressure, .... so it leaves us mostly
with microbenchmarks.

I also tried to use an unconditional jump to skip the function call, but
the problem here, as has been discussed about a year ago, is gcc : it
does not allow to jump getween two different inline assembly. And since
I don't want to create the a number of macros equivalent to the powerset
of the number of arguments/types we want to support (this is why I use
var args), and I don't see how we could declare var args in inline
assembly portably, I guess the best solution left was what I have done :
loading an immediate value and let gcc handle the conditional jump.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
