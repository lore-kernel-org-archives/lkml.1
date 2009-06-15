Return-Path: <linux-kernel-owner+w=401wt.eu-S1763041AbZFORTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041AbZFORTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZFORTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:19:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762283AbZFORTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:19:08 -0400
Date: Mon, 15 Jun 2009 19:18:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615171845.GA7664@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 15 Jun 2009, tip-bot for Peter Zijlstra wrote:
> > 
> > __copy_from_user_inatomic() isn't NMI safe in that it can trigger
> > the page fault handler which is another trap and its return path
> > invokes IRET which will also close the NMI context.
> 
> That's not the only problem.
> 
> An even more fundamental problem is that the page fault handler is 
> not re-entrant because of simple the value in %cr2. So regardless 
> of any 'iret' issues, you *CANNOT* take a page fault in an NMI, 
> because the NMI might happen while we're in the critical region of 
> having taken another page fault, but before we've saved off the 
> value of %cr2 in that old page fault.
>
> If the NMI handler causes a page fault, it will corrupt the %cr2 
> of the outer page fault. That's why the page fault is done with an 
> interrupt gate, and why we have that conditional 
> local_irq_enable() in it.
> 
> So page faults are fundamentally only safe wrt normal interrupts, 
> not NMI.

ahhh ... a light goes up. Indeed.

I was suspecting something much more complex: like the CPU somehow 
having shadow state for attempted-fault which gets confused by 
NMI->fault.

A simple cr2 corruption would explain all those cc1 SIGSEGVs and 
other user-space crashes i saw, with sufficiently intense sampling - 
easily.

The thing is, that __copy_user_inatomic() has been in 
arch/x86/oprofile/backtrace.c for years, i didnt even suspect some 
simple, fundamental flaw like this. Apparently nobody uses it.

This is really good news in a sense: i really hate that additional 
entry*.S mucking in the exception path in the dont-IRET patch. We 
want less entry*.S magic, not more.

	Ingo
