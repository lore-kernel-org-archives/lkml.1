Return-Path: <linux-kernel-owner+w=401wt.eu-S1765455AbZFOSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765455AbZFOSnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765100AbZFOSmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:42:55 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:54982 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765242AbZFOSmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:42:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAMsvNkpMQWQl/2dsb2JhbACBT9VwhA0F
Date: Mon, 15 Jun 2009 14:42:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615184250.GB6520@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu> <20090615182828.GE11248@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615182828.GE11248@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:39:22 up 107 days, 15:05,  3 users,  load average: 1.20, 1.27,
	0.97
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > The GUP based method is pretty generic though - and can be used on 
> > other architectures as well. It's not as fast as direct access 
> > though.
> 
> Another question is: your patch switches over all normal exceptions 
> from IRET to hand-unroll+RET.
> 

Nope, it actually only switches the exceptions returning from an
exception handler nested in NMI context to the hand-unroll+RET version.
Given such exception nesting is expected to be very rare, it should not
show any performance difference.

I also organised the code to make sure I did not add any test to the
fast paths in my original patch.

> It would be really nice to benchmark it (via 'perf stat' for example 
> ;-) whether that's a slowdown or a speedup.
> 
> If it's a slowdown then the decision is easy: we dont want this, we 
> want to push the overhead into the sampling code, away from common 
> codepaths.
> 

I did not try to make the "hand unroll + ret" the default. I therefore
don't know if it is faster or slower than iret. But I prefered to stay
on the safe side and only modify the exceptions nested within NMI
handlers.

Mathieu

> [ If on the other hand it's a speedup of a few cycles then we have 
>   the problem of me suddenly liking this patch a whole lot more ;-) ]
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
