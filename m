Return-Path: <linux-kernel-owner+w=401wt.eu-S1765132AbZFOTWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765132AbZFOTWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZFOTV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:21:58 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:35364 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbZFOTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:21:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAKE6NkpMQWQl/2dsb2JhbACBT9UbhA0F
Date: Mon, 15 Jun 2009 15:16:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615191617.GA8230@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu> <20090615182828.GE11248@elte.hu> <alpine.LFD.2.01.0906151135500.6276@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151135500.6276@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:02:04 up 107 days, 15:28,  3 users,  load average: 0.53, 0.45,
	0.69
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 15 Jun 2009, Ingo Molnar wrote:
> > 
> > [ If on the other hand it's a speedup of a few cycles then we have 
> >   the problem of me suddenly liking this patch a whole lot more ;-) ]
> 
> I missed the patch.
> 
> It's quite possible that replacing "iret" with a regular "ret" (for the 
> kernel->kernel transition) is a real speedup. That said, there's a few 
> things to think about:
> 
>  - CPU return stack caches/predictors. I suspect that "iret" and 
>    exceptions don't generally touch them (but who knows - maybe they do), 
>    while a regular "ret" definitely does. I dunno about "retf".
> 

Also, I don't think popf acts as a serializing instruction. (reading the
Intel Architecture Software Developer's Manual, vol 3 System programming
section 7.4 Serializing Instructions). And ret clearly doesn't.
Therefore I'd be worried of iret serialization assumptions which could
be done within the kernel code. Maybe it would be safer to add a cpuid
or mfence instruction in there to ensure correct core serialization.

This would turn the hand-made iret into a :

popf
mfence
ret

Or something like that.

Mathieu


>    This can cause very subtle performance slowdowns, where the slowdown 
>    happens somewhere else. And it could be _very_ uarch-dependent (ie only 
>    happen on some architectures, while having no performance downside on 
>    others)
> 
>  - kernel->kernel exceptions _should_ be rare, with the exception of 
>    actual real external interrupts. So the path to optimize should always 
>    be the user-space exception path. That one will need 'iret', but I'd 
>    also not want to see more testing in that hot-path. I suspect we 
>    already always test for user-mode anyway (due to signal handling etc 
>    work), but if it adds new tests to that path, any kernel->kernel 
>    speedup is likely totally pointless.
> 
> That said, it would be nice to avoid 'iret' if only because of its subtle 
> interactions with the while NMI flag.
> 
> 		Linus

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
