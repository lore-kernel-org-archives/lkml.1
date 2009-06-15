Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbZFOSw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbZFOSw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbZFOSwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:52:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765700AbZFOSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:52:30 -0400
Date: Mon, 15 Jun 2009 11:51:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <20090615182828.GE11248@elte.hu>
Message-ID: <alpine.LFD.2.01.0906151135500.6276@localhost.localdomain>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal>
 <20090615182348.GC11248@elte.hu> <20090615182828.GE11248@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Ingo Molnar wrote:
> 
> [ If on the other hand it's a speedup of a few cycles then we have 
>   the problem of me suddenly liking this patch a whole lot more ;-) ]

I missed the patch.

It's quite possible that replacing "iret" with a regular "ret" (for the 
kernel->kernel transition) is a real speedup. That said, there's a few 
things to think about:

 - CPU return stack caches/predictors. I suspect that "iret" and 
   exceptions don't generally touch them (but who knows - maybe they do), 
   while a regular "ret" definitely does. I dunno about "retf".

   This can cause very subtle performance slowdowns, where the slowdown 
   happens somewhere else. And it could be _very_ uarch-dependent (ie only 
   happen on some architectures, while having no performance downside on 
   others)

 - kernel->kernel exceptions _should_ be rare, with the exception of 
   actual real external interrupts. So the path to optimize should always 
   be the user-space exception path. That one will need 'iret', but I'd 
   also not want to see more testing in that hot-path. I suspect we 
   already always test for user-mode anyway (due to signal handling etc 
   work), but if it adds new tests to that path, any kernel->kernel 
   speedup is likely totally pointless.

That said, it would be nice to avoid 'iret' if only because of its subtle 
interactions with the while NMI flag.

		Linus
