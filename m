Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYAPCst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYAPCst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbYAPCsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:48:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:48538 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbYAPCsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:48:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ow+AX+0F82LuGo7n7sTLaeOwNNO5pS0ejgdCuMZmd+WmB3X76K/e0OT3UvRs88xBZX8xdPmyKIDUIqo9IOptu7IlaL9JcxraOxZM7ctnwA8Rl+clX3c8euFg7QYCbsll4SwY8vnnA1rIIiXE0/dpuU3xSL7Z+MfrW70K6ETShjM=
Subject: [PATCH] x86: add is_f00f_bug helper to fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 18:48:35 -0800
Message-Id: <1200451715.16794.71.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further towards unifying these files, add another helper
in same spirit as is_errata93.  Add an #ifdef around the
forward declaration of do_invalid_op to make it clear it
is only needed in the one place.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   41 ++++++++++++++++++++++++-----------------
 arch/x86/mm/fault_64.c |   26 ++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 936bb0c..f50df86 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -211,8 +211,6 @@ void dump_pagetable(unsigned long address)
 	printk("\n");
 }
 
-void do_invalid_op(struct pt_regs *, unsigned long);
-
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 {
 	unsigned index = pgd_index(address);
@@ -288,6 +286,28 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+#ifdef CONFIG_X86_F00F_BUG
+void do_invalid_op(struct pt_regs *, unsigned long);
+#endif
+
+static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
+{
+#ifdef CONFIG_X86_F00F_BUG
+	unsigned long nr;
+	/*
+	 * Pentium F0 0F C7 C8 bug workaround.
+	 */
+	if (boot_cpu_data.f00f_bug) {
+		nr = (address - idt_descr.address) >> 3;
+
+		if (nr == 6) {
+			do_invalid_op(regs, 0);
+			return 1;
+		}
+	}
+#endif
+	return 0;
+}
 
 /*
  * Handle a fault on the vmalloc or module mapping area
@@ -570,21 +590,8 @@ bad_area_nosemaphore:
 		return;
 	}
 
-#ifdef CONFIG_X86_F00F_BUG
-	/*
-	 * Pentium F0 0F C7 C8 bug workaround.
-	 */
-	if (boot_cpu_data.f00f_bug) {
-		unsigned long nr;
-
-		nr = (address - idt_descr.address) >> 3;
-
-		if (nr == 6) {
-			do_invalid_op(regs, 0);
-			return;
-		}
-	}
-#endif
+	if (is_f00f_bug(regs, address))
+		return;
 
 no_context:
 	/* Are we prepared to handle this kernel fault?  */
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index cde110c..17cafe8 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -256,6 +256,29 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+#ifdef CONFIG_X86_F00F_BUG
+void do_invalid_op(struct pt_regs *, unsigned long);
+#endif
+
+static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
+{
+#ifdef CONFIG_X86_F00F_BUG
+	unsigned long nr;
+	/*
+	 * Pentium F0 0F C7 C8 bug workaround.
+	 */
+	if (boot_cpu_data.f00f_bug) {
+		nr = (address - idt_descr.address) >> 3;
+
+		if (nr == 6) {
+			do_invalid_op(regs, 0);
+			return 1;
+		}
+	}
+#endif
+	return 0;
+}
+
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
 {
@@ -572,6 +595,9 @@ bad_area_nosemaphore:
 		return;
 	}
 
+	if (is_f00f_bug(regs, address))
+		return;
+
 no_context:
 	/* Are we prepared to handle this kernel fault?  */
 	if (fixup_exception(regs))
-- 
1.5.4.rc2.1164.g6451

