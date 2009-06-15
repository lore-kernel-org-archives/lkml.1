Return-Path: <linux-kernel-owner+w=401wt.eu-S1764665AbZFORjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764665AbZFORjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbZFORjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:39:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182AbZFORjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:39:11 -0400
Date: Mon, 15 Jun 2009 10:37:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <20090615171845.GA7664@elte.hu>
Message-ID: <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Ingo Molnar wrote:
> 
> A simple cr2 corruption would explain all those cc1 SIGSEGVs and 
> other user-space crashes i saw, with sufficiently intense sampling - 
> easily.

Note that we could work around the %cr2 issue, since any corruption is 
always nicely "nested" (ie there are never any SMP issues with async 
writes to the register).

So what we _could_ do is to have a magic value for %cr2, along with a "NMI 
sequence count", and if we see that value, we just return (without doing 
anything) from the page fault handler.

Then, the NMI handler would be changed to always write that value to %cr2 
after it has done the operation that could fault, and do an atomic 
increment of the NMI sequence count. Then, we can do something like this 
in the page fault handler:

	if (cr2 == MAGIC_CR2) {
		static unsigned long my_seqno = -1;
		if (my_seqno != nmi_seqno) {
			my_seqno = nmi_seqno;
			return;
		}
	}

where the whole (and only) point of that "seqno" is to protect against 
user space doing something like

	int i = *(int *)MAGIC_CR2;

and causing infinite faults.

If a real NMI happens, then nmi_seqno will always be different, and we'll 
just retry the fault (the NMI handler would do something like

	write_cr2(MAGIC_CR2);
	atomic_inc(&nmi_seqno);

to set it all up).

Anyway, I do think that the _correct_ solution is to not do page faults 
from within NMI's, but the above is an outline of how we could _try_ to 
handle it if we really really wanted to. IOW, the fact that cr2 gets 
corrupted is not insurmountable, exactly because we _could_ always just 
retrigger the page fault, and thus "re-create' the corrupted %cr2 value.

Hacky, hacky. And I'm not sure how happy CPU's even are to have %cr2 
written to, so we could hit CPU issues.

			Linus
