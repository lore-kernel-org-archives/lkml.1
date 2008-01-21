Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYAUV3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYAUV3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYAUV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:28:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:60672 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbYAUV25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r0en/AKgSllX1rATHs0f6Z2xuiBqrrMTNoqKVVGmUfezJxFV7IXBZxYZTk+tCPKH3ZuP5ry529i6QRc/PHxuS/sEIl7OLnci/ooo80kWU4NoTZxLS2GX5NreoogGEZ7dq1YwtTj1/Pf6zt/fVgbCsqA52nPPVNTO0aNu5phcz1Y=
Subject: [PATCH 1/2] x86: Introduce show_fault_oops helper to fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 13:29:00 -0800
Message-Id: <1200950940.16972.26.camel@brick>
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


