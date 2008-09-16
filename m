Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYIPS2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYIPS2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYIPS14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:27:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:36810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbYIPS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:27:56 -0400
Date: Tue, 16 Sep 2008 11:27:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@tglx.de
Subject: [PATCH] x86: print DMI information in the oops trace
Message-ID: <20080916112730.0b57689d@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] x86: print DMI information in the oops trace

in order to diagnose hard system specific issues, it's useful to
have the system name in the oops (as provided by DMI)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/process_32.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4eb2159..d9f34cf 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -37,6 +37,7 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
+#include <linux/dmi.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -127,6 +128,7 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned long sp;
 	unsigned short ss, gs;
+	const char *board;
 
 	if (user_mode_vm(regs)) {
 		sp = regs->sp;
@@ -139,11 +141,15 @@ void __show_regs(struct pt_regs *regs, int all)
 	}
 
 	printk("\n");
-	printk("Pid: %d, comm: %s %s (%s %.*s)\n",
+
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!board)
+		board = "";
+	printk("Pid: %d, comm: %s %s (%s %.*s) %s\n",
 			task_pid_nr(current), current->comm,
 			print_tainted(), init_utsname()->release,
 			(int)strcspn(init_utsname()->version, " "),
-			init_utsname()->version);
+			init_utsname()->version, board);
 
 	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
