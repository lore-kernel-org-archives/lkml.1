Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZFPIiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZFPIiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZFPIhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:37:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:55303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbZFPIhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:37:50 -0400
Date: Tue, 16 Jun 2009 08:36:55 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com, jeremy@goop.org,
       npiggin@suse.de, hugh.dickins@tiscali.co.uk, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       npiggin@suse.de, jeremy@goop.org, tglx@linutronix.de,
       hugh.dickins@tiscali.co.uk, mingo@elte.hu
In-Reply-To: <20090616030522.GA22162@Krystal>
References: <20090616030522.GA22162@Krystal>
Subject: [tip:x86/urgent] x86: mm: Read cr2 before prefetching the mmap_lock
Message-ID: <tip-5dfaf90f8052327c92fbe3c470a2e6634be296c0@git.kernel.org>
Git-Commit-ID: 5dfaf90f8052327c92fbe3c470a2e6634be296c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 16 Jun 2009 08:36:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dfaf90f8052327c92fbe3c470a2e6634be296c0
Gitweb:     http://git.kernel.org/tip/5dfaf90f8052327c92fbe3c470a2e6634be296c0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 16 Jun 2009 10:23:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Jun 2009 10:23:32 +0200

x86: mm: Read cr2 before prefetching the mmap_lock

Prefetch instructions can generate spurious faults on certain
models of older CPUs. The faults themselves cannot be stopped
and they can occur pretty much anywhere - so the way we solve
them is that we detect certain patterns and ignore the fault.

There is one small path of code where we must not take faults
though: the #PF handler execution leading up to the reading
of the CR2 (the faulting address). If we take a fault there
then we destroy the CR2 value (with that of the prefetching
instruction's) and possibly mishandle user-space or
kernel-space pagefaults.

It turns out that in current upstream we do exactly that:

	prefetchw(&mm->mmap_sem);

	/* Get the faulting address: */
	address = read_cr2();

This is not good.

So turn around the order: first read the cr2 then prefetch
the lock address. Reading cr2 is plenty fast (2 cycles) so
delaying the prefetch by this amount shouldnt be a big issue
performance-wise.

[ And this might explain a mystery fault.c warning that sometimes
  occurs on one an old AMD/Semptron based test-system i have -
  which does have such prefetch problems. ]

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
LKML-Reference: <20090616030522.GA22162@Krystal>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/fault.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c6acc63..0482fa6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -951,11 +951,11 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	tsk = current;
 	mm = tsk->mm;
 
-	prefetchw(&mm->mmap_sem);
-
 	/* Get the faulting address: */
 	address = read_cr2();
 
+	prefetchw(&mm->mmap_sem);
+
 	if (unlikely(kmmio_fault(regs, address)))
 		return;
 
