Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYIZMmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYIZMmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYIZMmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:42:14 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:10627 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYIZMmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:42:14 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 6/7] traps: x86: remove trace_hardirqs_fixup from pagefault handler
Date: Fri, 26 Sep 2008 14:03:07 +0200
Message-Id: <1222430588-29072-7-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222430588-29072-6-git-send-email-heukelum@fastmail.fm>
References: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-2-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-3-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-4-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-5-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-6-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 26 Sep 2008 14:41:53 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.215; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last use of trace_hardirqs_fixup is unnecessary, because the
trap is taken with interrupt off on i386 as well as x86_64, and
the irq-tracer is notified of this from the assembly code.

trace_hardirqs_fixup and trace_hardirqs_fixup_flags are removed
from include/asm-x86/irqflags.h as they are no longer used.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/mm/fault.c        |    5 -----
 include/asm-x86/irqflags.h |   21 ---------------------
 2 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 455f3fe..c5bafc9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -593,11 +593,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	unsigned long flags;
 #endif
 
-	/*
-	 * We can fault from pretty much anywhere, with unknown IRQ state.
-	 */
-	trace_hardirqs_fixup();
-
 	tsk = current;
 	mm = tsk->mm;
 	prefetchw(&mm->mmap_sem);
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
index 424acb4..2bdab21 100644
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -166,27 +166,6 @@ static inline int raw_irqs_disabled(void)
 	return raw_irqs_disabled_flags(flags);
 }
 
-/*
- * makes the traced hardirq state match with the machine state
- *
- * should be a rarely used function, only in places where its
- * otherwise impossible to know the irq state, like in traps.
- */
-static inline void trace_hardirqs_fixup_flags(unsigned long flags)
-{
-	if (raw_irqs_disabled_flags(flags))
-		trace_hardirqs_off();
-	else
-		trace_hardirqs_on();
-}
-
-static inline void trace_hardirqs_fixup(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	trace_hardirqs_fixup_flags(flags);
-}
-
 #else
 
 #ifdef CONFIG_X86_64
-- 
1.5.4.3

