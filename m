Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbYDXPUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbYDXPUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759568AbYDXPO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:56 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56112 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759491AbYDXPOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:49 -0400
Message-Id: <20080424151352.660545603@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [patch 02/37] x86_64 page fault NMI-safe
Content-Disposition: inline; filename=x86_64-page-fault-nmi-safe.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you're vastly overestimating what is sane to do from an NMI
> context.  It is utterly and totally insane to assume vmalloc is available
> in NMI.
>
>       -hpa
>

Ok, please tell me where I am wrong then.. by looking into
arch/x86/mm/fault.c, I see that vmalloc_sync_all() touches pgd_list
entries while the pgd_lock spinlock is taken, with interrupts disabled.
So it's protected against concurrent pgd_list modification from

a - vmalloc_sync_all() on other CPUs
b - local interrupts

However, a completely normal interrupt can come on a remote CPU, run
vmalloc_fault() and issue a set_pgd concurrently. Therefore I conclude
this interrupt disable is not there to insure any kind of protection
against concurrent updates.

Also, we see that vmalloc_fault has comments such as :

(for x86_32)
         * Do _not_ use "current" here. We might be inside
         * an interrupt in the middle of a task switch..

So it takes the pgd_addr from cr3, not from current. Using only the
stack/registers makes this NMI-safe even if "current" is invalid when
the NMI comes. This is caused by the fact that __switch_to will update
the registers before updating current_task without disabling interrupts.

You are right in that x86_64 does not seems to play as safely as x86_32
on this matter; it uses current->mm. Probably it shouldn't assume
"current" is valid. Actually, I don't see where x86_64 disables
interrupts around __switch_to, so this would seem to be a race
condition. Or have I missed something ?

(Ingo)
> > the scheduler disables interrupts around __switch_to(). (x86 does 
> > not set __ARCH_WANT_INTERRUPTS_ON_CTXSW)
>
(Mathieu)
> Ok, so I guess it's only useful to NMIs then. However, it makes me
> wonder why this comment was there in the first place on x86_32
> vmalloc_fault() and why it uses read_cr3() :
>
>         * Do _not_ use "current" here. We might be inside
>         * an interrupt in the middle of a task switch..
(Ingo)
hm, i guess it's still useful to keep the
__ARCH_WANT_INTERRUPTS_ON_CTXSW case working too. On -rt we used to
enable it to squeeze a tiny bit more latency out of the system.


Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@osdl.org
CC: mingo@elte.hu
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 arch/x86/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-sched-devel/arch/x86/mm/fault.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/mm/fault.c	2008-04-22 20:04:02.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/mm/fault.c	2008-04-22 20:09:50.000000000 -0400
@@ -535,6 +535,7 @@ static int vmalloc_fault(struct pt_regs 
 	}
 	return 0;
 #else
+	unsigned long pgd_paddr;
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
 	pmd_t *pmd, *pmd_ref;
@@ -548,7 +549,8 @@ static int vmalloc_fault(struct pt_regs 
 	   happen within a race in page table update. In the later
 	   case just flush. */
 
-	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd_paddr = read_cr3();
+	pgd = __va(pgd_paddr) + pgd_index(address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
