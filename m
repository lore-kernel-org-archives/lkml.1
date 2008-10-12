Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYJLUQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYJLUQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYJLUQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:16:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756114AbYJLUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:16:41 -0400
Date: Sun, 12 Oct 2008 13:16:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Karel Zak <kzak@redhat.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
In-Reply-To: <20081012200004.GI10429@nb.net.home>
Message-ID: <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org>
 <20081012200004.GI10429@nb.net.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Oct 2008, Karel Zak wrote:
>
>  Any suggestion how to nicely implement "don't schedule me out"?

There's nothing you can do. If you take a page fault, you're done. Forget 
about any "can't schedule" or "don't enable interrupts". The kernel _has_ 
to handle the page fault, and that may involve IO and thus random pauses. 
No ifs, buts or maybe's about it.

This patch may or may not get rid of the warning, at least. It won't fix 
hwclock, but that's apparently unfixable from the kernel - the thing is 
just plain buggy.

[ Ingo added to Cc just because this is obviously a x86 tree thing, and 
  tries to unify some trivial parts of the VM paths at the same time. ]

For hwclock, you may try to:

 - do

	mlockall(MCL_CURRENT)

   before you do the critical region

 - set yourself to some realtime scheduling thing

	struct sched_param param = {
		.sched_priority = 50,
	};

	sched_setscheduler(0, SCHED_FIFO, &param);

   or similar.

and that should mean that you stay on your CPU (by virtue of not being 
scheduled away because you're more important than others) and don't take 
page faults.

But making yourself real-time also means that any bugs can essentially 
kill the system (endless loop).

		Linus

---
 arch/x86/mm/fault.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a742d75..ac2ad78 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -645,24 +645,23 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	}
 
 
-#ifdef CONFIG_X86_32
-	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
-	   fault has been handled. */
-	if (regs->flags & (X86_EFLAGS_IF | X86_VM_MASK))
-		local_irq_enable();
-
 	/*
-	 * If we're in an interrupt, have no user context or are running in an
-	 * atomic region then we must not take the fault.
+	 * It's safe to allow irq's after cr2 has been saved and the
+	 * vmalloc fault has been handled.
+	 *
+	 * User-mode registers count as a user access even for any
+	 * potential system fault or CPU buglet.
 	 */
-	if (in_atomic() || !mm)
-		goto bad_area_nosemaphore;
-#else /* CONFIG_X86_64 */
-	if (likely(regs->flags & X86_EFLAGS_IF))
+	if (user_mode_vm(regs)) {
+		local_irq_enable();
+		error_code |= PF_USER;
+	} else if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 
+#ifdef CONFIG_X86_64
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(address, regs, error_code);
+#endif
 
 	/*
 	 * If we're in an interrupt, have no user context or are running in an
@@ -671,14 +670,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(in_atomic() || !mm))
 		goto bad_area_nosemaphore;
 
-	/*
-	 * User-mode registers count as a user access even for any
-	 * potential system fault or CPU buglet.
-	 */
-	if (user_mode_vm(regs))
-		error_code |= PF_USER;
 again:
-#endif
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an

