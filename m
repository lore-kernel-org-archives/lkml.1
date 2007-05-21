Return-Path: <linux-kernel-owner+w=401wt.eu-S1765853AbXEUTXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765853AbXEUTXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765307AbXEUTVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:20 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46315 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765282AbXEUTVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:18 -0400
Message-Id: <20070521191707.937399000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
       rmk@arm.linux.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 13/69] arm: fix handling of svc mode undefined instructions
Content-Disposition: inline; filename=arm-fix-handling-of-svc-mode-undefined-instructions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dan.j.williams@intel.com>

Now that do_undefinstr handles kernel and user mode undefined
instruction exceptions it must not assume that interrupts are enabled at
entry.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 arch/arm/kernel/traps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.21.1.orig/arch/arm/kernel/traps.c
+++ linux-2.6.21.1/arch/arm/kernel/traps.c
@@ -273,6 +273,7 @@ asmlinkage void do_undefinstr(struct pt_
 	struct undef_hook *hook;
 	siginfo_t info;
 	void __user *pc;
+	unsigned long flags;
 
 	/*
 	 * According to the ARM ARM, PC is 2 or 4 bytes ahead,
@@ -291,7 +292,7 @@ asmlinkage void do_undefinstr(struct pt_
 		get_user(instr, (u32 __user *)pc);
 	}
 
-	spin_lock_irq(&undef_lock);
+	spin_lock_irqsave(&undef_lock, flags);
 	list_for_each_entry(hook, &undef_hook, node) {
 		if ((instr & hook->instr_mask) == hook->instr_val &&
 		    (regs->ARM_cpsr & hook->cpsr_mask) == hook->cpsr_val) {
@@ -301,7 +302,7 @@ asmlinkage void do_undefinstr(struct pt_
 			}
 		}
 	}
-	spin_unlock_irq(&undef_lock);
+	spin_unlock_irqrestore(&undef_lock, flags);
 
 #ifdef CONFIG_DEBUG_USER
 	if (user_debug & UDBG_UNDEFINED) {

-- 
