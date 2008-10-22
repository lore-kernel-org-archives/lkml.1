Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYJVKiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYJVKiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYJVKhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:37:48 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:8827 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbYJVKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:37:47 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, hpa@zytor.com,
       akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>, ebiederm@xmission.com,
       tglx@linutronix.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 4/7] x86, dumpstack: always call oops_exit from oops_end
Date: Wed, 22 Oct 2008 12:00:11 +0200
Message-Id: <1224669614-25863-5-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224669614-25863-4-git-send-email-heukelum@fastmail.fm>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-2-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-3-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-4-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 22 Oct 2008 12:36:43 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.5; VDF: 7.0.7.72; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always call oops_exit from oops_end, even if signr==0.

Also, move add_taint(TAINT_DIE) from __die to oops_end
on x86_64 and interchange two lines to make oops_end
more similar to the i386-version.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |    2 +-
 arch/x86/kernel/dumpstack_64.c |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 7c22f99..a29b88f 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -318,6 +318,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	__raw_spin_unlock(&die_lock);
 	raw_local_irq_restore(flags);
 
+	oops_exit();
 	if (!signr)
 		return;
 
@@ -325,7 +326,6 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception");
-	oops_exit();
 	do_exit(signr);
 }
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 57ce11b..dc6162b 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -461,22 +461,22 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
 
-	die_owner = -1;
 	bust_spinlocks(0);
+	die_owner = -1;
+	add_taint(TAINT_DIE);
 	die_nest_count--;
 	if (!die_nest_count)
 		/* Nest count reaches zero, release the lock. */
 		__raw_spin_unlock(&die_lock);
 	raw_local_irq_restore(flags);
-	if (!signr) {
-		oops_exit();
+	oops_exit();
+
+	if (!signr)
 		return;
-	}
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception");
-	oops_exit();
 	do_exit(signr);
 }
 
@@ -499,7 +499,6 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 		return 1;
 
 	show_registers(regs);
-	add_taint(TAINT_DIE);
 	/* Executive summary in case the oops scrolled away */
 	printk(KERN_ALERT "RIP ");
 	printk_address(regs->ip, 1);
-- 
1.5.4.3

