Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYJVKJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYJVKJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbYJVKJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:09:08 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:14912 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYJVKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:09:06 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, hpa@zytor.com,
       akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>, ebiederm@xmission.com,
       tglx@linutronix.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 3/7] x86_64, dumpstack: move kexec_crash from __die to oops_end
Date: Wed, 22 Oct 2008 12:00:10 +0200
Message-Id: <1224669614-25863-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224669614-25863-3-git-send-email-heukelum@fastmail.fm>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-2-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-3-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 22 Oct 2008 12:06:43 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.5; VDF: 7.0.7.72; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops_end is preceded by either a call to __die, or a conditional
call to crash_kexec. Move the conditional call to crash_kexec
from the end of __die to the start of oops_end and remove
the superfluous call to crash_kexec in die_nmi.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_64.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index ffefea6..57ce11b 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -458,6 +458,9 @@ unsigned __kprobes long oops_begin(void)
 
 void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
+	if (regs && kexec_should_crash(current))
+		crash_kexec(regs);
+
 	die_owner = -1;
 	bust_spinlocks(0);
 	die_nest_count--;
@@ -501,8 +504,6 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	printk(KERN_ALERT "RIP ");
 	printk_address(regs->ip, 1);
 	printk(" RSP <%016lx>\n", regs->sp);
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
 	return 0;
 }
 
@@ -536,11 +537,9 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 	printk(" on CPU%d, ip %08lx, registers:\n",
 		smp_processor_id(), regs->ip);
 	show_registers(regs);
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
+	oops_end(flags, regs, 0);
 	if (do_panic || panic_on_oops)
 		panic("Non maskable interrupt");
-	oops_end(flags, regs, 0);
 	nmi_exit();
 	local_irq_enable();
 	do_exit(SIGBUS);
-- 
1.5.4.3

