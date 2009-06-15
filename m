Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbZFOSK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbZFOSK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763674AbZFOSKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:10:49 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:50552 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758950AbZFOSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:10:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAIAlNkpMQWQl/2dsb2JhbACBT9VZhA0F
Date: Mon, 15 Jun 2009 14:05:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615180527.GB4201@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:01:29 up 107 days, 14:27,  3 users,  load average: 0.89, 0.48,
	0.40
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 15 Jun 2009, Ingo Molnar wrote:
> > 
> > A simple cr2 corruption would explain all those cc1 SIGSEGVs and 
> > other user-space crashes i saw, with sufficiently intense sampling - 
> > easily.
> 
> Note that we could work around the %cr2 issue, since any corruption is 
> always nicely "nested" (ie there are never any SMP issues with async 
> writes to the register).
> 
> So what we _could_ do is to have a magic value for %cr2, along with a "NMI 
> sequence count", and if we see that value, we just return (without doing 
> anything) from the page fault handler.
> 
> Then, the NMI handler would be changed to always write that value to %cr2 
> after it has done the operation that could fault, and do an atomic 
> increment of the NMI sequence count. Then, we can do something like this 
> in the page fault handler:
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
> 
> If a real NMI happens, then nmi_seqno will always be different, and we'll 
> just retry the fault (the NMI handler would do something like
> 
> 	write_cr2(MAGIC_CR2);
> 	atomic_inc(&nmi_seqno);
> 
> to set it all up).
> 
> Anyway, I do think that the _correct_ solution is to not do page faults 
> from within NMI's, but the above is an outline of how we could _try_ to 
> handle it if we really really wanted to. IOW, the fact that cr2 gets 
> corrupted is not insurmountable, exactly because we _could_ always just 
> retrigger the page fault, and thus "re-create' the corrupted %cr2 value.
> 
> Hacky, hacky. And I'm not sure how happy CPU's even are to have %cr2 
> written to, so we could hit CPU issues.
> 

Hrm, would it be possible to save the c2 register upon nmi handler entry
and restore it before iret instead ? This would ensure a
nmi-interrupted page fault handler would continue what it was doing with
a non-corrupted cr2 register after returning from nmi.

Plus, this involves no modification to the page fault handler fast path.

But I fear I might be missing something totally obvious.

Mathieu


> 			Linus

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
