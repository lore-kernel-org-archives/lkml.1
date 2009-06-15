Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbZFOSJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbZFOSJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbZFOSJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:09:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZFOSJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:09:07 -0400
Date: Mon, 15 Jun 2009 20:08:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615180829.GA18262@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
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

> Then, the NMI handler would be changed to always write that value 
> to %cr2 after it has done the operation that could fault, and do 
> an atomic increment of the NMI sequence count. Then, we can do 
> something like this in the page fault handler:
> 
> 	if (cr2 == MAGIC_CR2) {
> 		static unsigned long my_seqno = -1;
> 		if (my_seqno != nmi_seqno) {
> 			my_seqno = nmi_seqno;
> 			return;
> 		}
> 	}
> 
> where the whole (and only) point of that "seqno" is to protect against 
> user space doing something like
> 
> 	int i = *(int *)MAGIC_CR2;
> 
> and causing infinite faults.

Heh - this is so tricky that it's disgusting! Lovely.

And, since this appears to be a competition of sick ideas, an even 
more disgusting hack might be to write to the IDT from the NMI 
handler, and install a NULL entry at #PF and rely on the double 
fault handler to detect faults - double faults dont clobber the cr2 
i think ...

( I think to protect the fragile and pure fabric of lkml against
  moral corruption, disgusting patches must remain unsent and
  disgusting ideas like this must absolutely stay unspoken. Hence
  i have removed lkml from the Cc:. [Oops i didnt ... too late, 
  and this mail has already been sent! :-/ ])

> If a real NMI happens, then nmi_seqno will always be different, 
> and we'll just retry the fault (the NMI handler would do something 
> like
> 
> 	write_cr2(MAGIC_CR2);
> 	atomic_inc(&nmi_seqno);
> 
> to set it all up).
> 
> Anyway, I do think that the _correct_ solution is to not do page 
> faults from within NMI's, but the above is an outline of how we 
> could _try_ to handle it if we really really wanted to. IOW, the 
> fact that cr2 gets corrupted is not insurmountable, exactly 
> because we _could_ always just retrigger the page fault, and thus 
> "re-create' the corrupted %cr2 value.
> 
> Hacky, hacky. And I'm not sure how happy CPU's even are to have 
> %cr2 written to, so we could hit CPU issues.

If cr2 cannot be safely written to on a CPU, that could be worked 
around by counting the number of NMIs via a 
percpu_add(this_nmi_count, 1) and retrying faults if any NMI 
happened between the previous fault and this fault.

This has the disadvantage of potentially doubling the number of 
pagefaults though. But it would certainly work as a tricky quirk to 
this quirk which is added to a rather quirky code-path to begin 
with.

	Ingo
