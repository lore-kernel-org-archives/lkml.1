Return-Path: <linux-kernel-owner+w=401wt.eu-S1764502AbZFORMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764502AbZFORMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763745AbZFORMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:12:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762776AbZFORMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:12:14 -0400
Date: Mon, 15 Jun 2009 10:11:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>
Message-ID: <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>
References: <new-submission> <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, tip-bot for Peter Zijlstra wrote:
> 
> __copy_from_user_inatomic() isn't NMI safe in that it can trigger
> the page fault handler which is another trap and its return path
> invokes IRET which will also close the NMI context.

That's not the only problem.

An even more fundamental problem is that the page fault handler is not 
re-entrant because of simple the value in %cr2. So regardless of any 
'iret' issues, you *CANNOT* take a page fault in an NMI, because the NMI 
might happen while we're in the critical region of having taken another 
page fault, but before we've saved off the value of %cr2 in that old page 
fault.

If the NMI handler causes a page fault, it will corrupt the %cr2 of the 
outer page fault. That's why the page fault is done with an interrupt 
gate, and why we have that conditional local_irq_enable() in it.

So page faults are fundamentally only safe wrt normal interrupts, not NMI.

		Linus
