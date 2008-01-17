Return-Path: <linux-kernel-owner+w=401wt.eu-S1763207AbYAQW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763207AbYAQW5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbYAQWz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:55:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:14728 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762571AbYAQWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:55:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lFN/lrseKsvNc3nl9ECJAXFUDrNMhn6uzRToE+PzTxvpjsFAj4SOC3UAIlfG9LBGiI55N2ArDo5vi9cD1c5owHzZMfzn6AyQpAuVgeI4MVv5OKCYLYXEUbSSxZAd6ohqd4yV3KPeS/ULDgJ5l2H+r24H3eHwA7rUZN+1uEBht9I=
Subject: [PATCH 2/2] x86: add is_errata100 helper to fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 14:55:22 -0800
Message-Id: <1200610522.5724.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further towards unifying these files, add another helper
in same spirit as is_errata93.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   19 +++++++++++++++++++
 arch/x86/mm/fault_64.c |   25 +++++++++++++++++--------
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index dae4f69..77915ac 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -286,6 +286,22 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+/*
+ * Work around K8 erratum #100 K8 in compat mode occasionally jumps to illegal
+ * addresses >4GB.  We catch this in the page fault handler because these
+ * addresses are not reachable. Just detect this case and return.  Any code
+ * segment in LDT is compatibility mode.
+ */
+static int is_errata100(struct pt_regs *regs, unsigned long address)
+{
+#ifdef CONFIG_X86_64
+	if ((regs->cs == __USER32_CS || (regs->cs & (1<<2))) &&
+	    (address >> 32))
+		return 1;
+#endif
+	return 0;
+}
+
 void do_invalid_op(struct pt_regs *, unsigned long);
 
 static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
@@ -568,6 +584,9 @@ bad_area_nosemaphore:
 		if (is_prefetch(regs, address, error_code))
 			return;
 
+		if (is_errata100(regs, address))
+			return;
+
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 		    printk_ratelimit()) {
 			printk(
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index ce1a870..84531d8 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -256,6 +256,22 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+/*
+ * Work around K8 erratum #100 K8 in compat mode occasionally jumps to illegal
+ * addresses >4GB.  We catch this in the page fault handler because these
+ * addresses are not reachable. Just detect this case and return.  Any code
+ * segment in LDT is compatibility mode.
+ */
+static int is_errata100(struct pt_regs *regs, unsigned long address)
+{
+#ifdef CONFIG_X86_64
+	if ((regs->cs == __USER32_CS || (regs->cs & (1<<2))) &&
+	    (address >> 32))
+		return 1;
+#endif
+	return 0;
+}
+
 void do_invalid_op(struct pt_regs *, unsigned long);
 
 static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
@@ -561,14 +577,7 @@ bad_area_nosemaphore:
 		if (is_prefetch(regs, address, error_code))
 			return;
 
-		/* Work around K8 erratum #100 K8 in compat mode
-		   occasionally jumps to illegal addresses >4GB.  We
-		   catch this here in the page fault handler because
-		   these addresses are not reachable. Just detect this
-		   case and return.  Any code segment in LDT is
-		   compatibility mode. */
-		if ((regs->cs == __USER32_CS || (regs->cs & (1<<2))) &&
-		    (address >> 32))
+		if (is_errata100(regs, address))
 			return;
 
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-- 
1.5.4.rc2.1164.g6451

