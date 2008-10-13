Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYJMP1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYJMP1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYJMP0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:26:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbYJMP0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:26:51 -0400
Date: Mon, 13 Oct 2008 17:26:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Karel Zak <kzak@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
	"hwclock" program
Message-ID: <20081013152633.GA6523@elte.hu>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org> <20081012200004.GI10429@nb.net.home> <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [ Ingo added to Cc just because this is obviously a x86 tree thing, and 
>   tries to unify some trivial parts of the VM paths at the same time. ]

applied to tip/x86/urgent, thanks Linus!

do you agree with the changelog and can i add your Signed-off-by ?

	Ingo

--------------------->
>From bdbe15671f9b3ad1264ed174f62563774f0abef9 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 12 Oct 2008 13:16:12 -0700
Subject: [PATCH] x86/mm: do not trigger a kernel warning if user-space disables interrupts and generates a page fault

Arjan reported a spike in the following bug pattern in v2.6.27:

   http://www.kerneloops.org/searchweek.php?search=lock_page

which happens because hwclock started triggering warnings due to
a (correct) might_sleep() check in the MM code.

The warning occurs because hwclock uses this dubious sequence of
code to run "atomic" code:

  static unsigned long
  atomic(const char *name, unsigned long (*op)(unsigned long),
         unsigned long arg)
  {
    unsigned long v;
    __asm__ volatile ("cli");
    v = (*op)(arg);
    __asm__ volatile ("sti");
    return v;
  }

Then it pagefaults in that "atomic" section, triggering the warning.

There is no way the kernel could provide "atomicity" in this path,
a page fault is a cannot-continue machine event so the kernel has to
wait for the page to be filled in.

Even if it was just a minor fault we'd have to take locks and might have
to spend quite a bit of time with interrupts disabled - not nice to irq
latencies in general.

So instead just enable interrupts in the pagefault path unconditionally
if we come from user-space, and handle the fault.

Also, while touching this code, unify some trivial parts of the x86
VM paths at the same time.

Reported-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
