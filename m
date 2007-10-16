Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXJPN7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXJPN7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbXJPN7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:59:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44556 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204AbXJPN7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:59:36 -0400
Subject: Re: 2.6.23-git8: Lock dependency engine debugging failure
From: Peter Zijlstra <peterz@infradead.org>
To: David Hubbard <david.c.hubbard@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4dfa50520710152028i4a976200s88fbbb7f1cc2da9@mail.gmail.com>
References: <4dfa50520710152028i4a976200s88fbbb7f1cc2da9@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 15:59:33 +0200
Message-Id: <1192543173.27435.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 20:28 -0700, David Hubbard wrote:
> I am not subscribed to LKML, so please CC me in replies. I am
> reporting a regression when CONFIG_DEBUG_LOCKDEP is enabled in
> 2.6.23-git8. The error occurs immediately before loading init.
> Complete dmesg and kernel config are attached.
> 
> [   28.528074] VFS: Mounted root (ext3 filesystem) readonly.
> [   28.528090] Freeing unused kernel memory: 212k freed
> [   28.537431] Write protecting the kernel read-only data: 1036k
> [   28.622874] WARNING: at kernel/lockdep.c:2658 check_flags()

Could you try if the below patch works for you?

--
Subject: lockdep: fix fault vs irq tracing

Ensure we fixup the IRQ state before we hit any locking code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/fault_32.c |   10 ++++++++++
 arch/x86/mm/fault_64.c |   10 ++++++++++
 2 files changed, 20 insertions(+)

Index: linux-2.6/arch/x86/mm/fault_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault_32.c
+++ linux-2.6/arch/x86/mm/fault_32.c
@@ -308,6 +308,16 @@ fastcall void __kprobes do_page_fault(st
 	int write, si_code;
 	int fault;
 
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	/*
+	 * We can fault from pretty much anywhere, fix up the IRQ state.
+	 */
+	if (raw_irqs_disabled())
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+#endif
+
 	/* get the address */
         address = read_cr2();
 
Index: linux-2.6/arch/x86/mm/fault_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault_64.c
+++ linux-2.6/arch/x86/mm/fault_64.c
@@ -311,6 +311,16 @@ asmlinkage void __kprobes do_page_fault(
 	unsigned long flags;
 	siginfo_t info;
 
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	/*
+	 * We can fault from pretty much anywhere, fix up the IRQ state.
+	 */
+	if (raw_irqs_disabled())
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+#endif
+
 	tsk = current;
 	mm = tsk->mm;
 	prefetchw(&mm->mmap_sem);


