Return-Path: <linux-kernel-owner+w=401wt.eu-S1763984AbYDYQfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763984AbYDYQfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbYDYQfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:35:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478AbYDYQfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:35:03 -0400
Date: Fri, 25 Apr 2008 18:33:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080425163309.GA17792@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <alpine.LFD.1.10.0804250915340.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250915340.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Not sure how the fixmap is better. It's pretty much equivalent, 
> > isn't it? Perhaps a little cheaper, but the code shouldn't be 
> > performance critical.
> 
> I have no really strong opinions. However, we do have a *lot* of lock 
> prefixes in the kernel, and fixmaps are a lot cheaper than vmap(). It 
> may not be performance-critical, but for me the "locks" section for 
> the kernel is 0x8060 bytes long, which would seem to say that this is 
> called four thousand times for each suspend and resume.
> 
> With each invocation being thousands of instructions and a cross-CPU 
> IPI for the tlb flush, that kind of stuff adds up. We're likely 
> talking real fractions of a second, rather than milliseconds.

the other thing is atomicity - your new version of text_poke() is 
evidently atomic - while vmap() does a kmalloc which might sleep. 
Atomicity for something as fragile as code-patching never hurts, so i 
definitely like your version more.

it's also the more familar API - set_fixmap() is used more frequently 
than vmap() - hence less danger of doing something wrong.

in fact i'd do the extra sanity check below as well on top of your patch 
- all core kernel text pages are PageReserved so the one below would 
have caught the memory corruption right at its source.

	Ingo

---------------->
Subject: x86: harden kernel code patching
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 17:07:03 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86/kernel/alternative.c
===================================================================
--- linux.orig/arch/x86/kernel/alternative.c
+++ linux/arch/x86/kernel/alternative.c
@@ -522,6 +522,8 @@ void *__kprobes text_poke(void *addr, co
 		unsigned long virt = fix_to_virt(FIX_POKE);
 		phys &= PAGE_MASK;
 
+		WARN_ON(!PageReserved(virt_to_page(addr)));
+
 		spin_lock_irqsave(&poke_lock, flags);
 		set_fixmap(FIX_POKE, phys);
 		memcpy((void *)(virt + offset), opcode, len);
