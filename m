Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYASKRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYASKRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 05:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYASKRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 05:17:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:31398 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYASKRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 05:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wBbUuAM9qAn3moCLRD51z8pH72J/ym1pYu3cZy9pdfCSfcNqJcPDuWILR08MjntANiltQS2WKEtITWYrZfD09ipCN9quN16wBramnJuzu+W99/ajXHqhQ3EvMH8tSiCs3kv5tRpaX6NyNGXfGs7SjWEEzGDXThLVrnIbVH8mwI8=
Subject: [RFC PATCH] x86: Pull out oops printing helper from do_page_fault
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080119081331.GB12995@elte.hu>
References: <1200716549.5724.150.camel@brick>
	 <20080119081331.GB12995@elte.hu>
Content-Type: text/plain
Date: Sat, 19 Jan 2008 02:17:14 -0800
Message-Id: <1200737834.5724.173.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull out an show_fault_oops() helper out from the oops printing
code in do_page_fault.

Try to make 32/64 bit oops traces have more similar format.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, for discussion about how the oops traces should look,
pull out a helper function.  This changes the existing format.

 arch/x86/mm/fault_32.c |   53 ++++++++++++++++++++++++++---------------------
 arch/x86/mm/fault_64.c |   24 +++++++++++++++------
 2 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 0bd2417..e15b80b 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -396,6 +396,34 @@ static inline int vmalloc_fault(unsigned long address)
 #endif
 }
 
+static void show_fault_oops(struct pt_regs *regs, unsigned long error_code
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
+	printk(KERN_ALERT "BUG: unable to handle kernel ");
+	if (address < PAGE_SIZE)
+		printk(KERN_CONT "NULL pointer dereference");
+	else
+		printk(KERN_CONT "paging request");
+
+	printk(KERN_CONT " at: %08lx IP: %08lx\n", address, regs->ip);
+
+	dump_pagetable(address);
+}
+
 int show_unhandled_signals = 1;
 
 /*
@@ -633,30 +661,7 @@ no_context:
 
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
index ccbb8e3..dce2893 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -384,6 +384,21 @@ static int vmalloc_fault(unsigned long address)
 #endif
 }
 
+static void show_fault_oops(struct pt_regs *regs, unsigned long error_code
+			    unsigned long address)
+{
+	printk(KERN_ALERT "BUG: unable to handle kernel ");
+	if (address < PAGE_SIZE)
+		printk(KERN_CONT "NULL pointer dereference");
+	else
+		printk(KERN_CONT "paging request");
+
+	printk(KERN_CONT " at %016lx IP: \n", address);
+	printk_address(regs->ip, 1);
+
+	dump_pagetable(address);
+}
+
 int show_unhandled_signals = 1;
 
 /*
@@ -636,13 +651,8 @@ no_context:
 
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



