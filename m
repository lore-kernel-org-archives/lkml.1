Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbYAUW60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbYAUW60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYAUW55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:57:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:20454 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbYAUW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:57:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WEtNqjYFXyCH1PGQaHwK/ffKLlMJmC/M5pPFlHq0q1DBlGMXxpwu4DrHuLVcl8zZyflECAPRQdjfYWpQaJBDpFEa3VQDKdqGL/413LWOjcfG8T6YRkoA9vU9LRRlaDySmZoY32DsX8RRiUGcrkxiJd7bBB4SmvP2rFhFlqiBlx0=
Subject: [PATCH 2/3] x86: Introduce show_fault_oops helper to fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 14:58:01 -0800
Message-Id: <1200956281.16972.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help when unifying the oops dumping code on 32/64
bit.  No functional changes.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   54 ++++++++++++++++++++++++++---------------------
 arch/x86/mm/fault_64.c |   21 ++++++++++++------
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 0bd2417..fda3997 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -323,6 +323,35 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
+			    unsigned long address)
+{
+	if (!oops_may_print())
+		return;
+
+#ifdef CONFIG_X86_PAE
+	if (error_code & PF_INSTR) {
+		int level;
+		pte_t *pte = lookup_address(address, &level);
+
+		if (pte && pte_present(*pte) && !pte_exec(*pte))
+			printk(KERN_CRIT "kernel tried to execute "
+				"NX-protected page - exploit attempt? "
+				"(uid: %d)\n", current->uid);
+	}
+#endif
+	if (address < PAGE_SIZE)
+		printk(KERN_ALERT "BUG: unable to handle kernel NULL "
+				"pointer dereference");
+	else
+		printk(KERN_ALERT "BUG: unable to handle kernel paging"
+				" request");
+	printk(" at virtual address %08lx\n", address);
+	printk(KERN_ALERT "printing ip: %08lx ", regs->ip);
+
+	dump_pagetable(address);
+}
+
 /*
  * Handle a fault on the vmalloc or module mapping area
  *
@@ -633,30 +662,7 @@ no_context:
 
 	bust_spinlocks(1);
 
-	if (oops_may_print()) {
-
-#ifdef CONFIG_X86_PAE
-		if (error_code & PF_INSTR) {
-			int level;
-			pte_t *pte = lookup_address(address, &level);
-
-			if (pte && pte_present(*pte) && !pte_exec(*pte))
-				printk(KERN_CRIT "kernel tried to execute "
-					"NX-protected page - exploit attempt? "
-					"(uid: %d)\n", current->uid);
-		}
-#endif
-		if (address < PAGE_SIZE)
-			printk(KERN_ALERT "BUG: unable to handle kernel NULL "
-					"pointer dereference");
-		else
-			printk(KERN_ALERT "BUG: unable to handle kernel paging"
-					" request");
-		printk(" at virtual address %08lx\n", address);
-		printk(KERN_ALERT "printing ip: %08lx ", regs->ip);
-
-		dump_pagetable(address);
-	}
+	show_fault_oops(regs, error_code, address);
 
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index ccbb8e3..1897704 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -293,6 +293,18 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
+			    unsigned long address)
+{
+	if (address < PAGE_SIZE)
+		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
+	else
+		printk(KERN_ALERT "Unable to handle kernel paging request");
+	printk(" at %016lx RIP: \n" KERN_ALERT, address);
+	printk_address(regs->ip, 1);
+	dump_pagetable(address);
+}
+
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
 {
@@ -636,13 +648,8 @@ no_context:
 
 	flags = oops_begin();
 
-	if (address < PAGE_SIZE)
-		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
-	else
-		printk(KERN_ALERT "Unable to handle kernel paging request");
-	printk(" at %016lx RIP: \n" KERN_ALERT, address);
-	printk_address(regs->ip, 1);
-	dump_pagetable(address);
+	show_fault_oops(regs, error_code, address);
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
-- 
1.5.4.rc3.1118.gf6754c


