Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYAPDmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYAPDmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYAPDmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:42:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:5828 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYAPDl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=veEcz6FRs+xA+Jfr92RtIxCCHLMqens18gTPxYUEZfcgUcKwrKsZV1N1MWmLXKNsYZNQB7SrsVgPv5AClU4sY2s8fNmPchTltlxn50VW2RUMeaf8cOa8rXU0+uy0kBfwz1bxj5JJq1tr2gekTlhrkpGVeDIk+zF9WwHwoEg/WuQ=
Subject: [PATCHv2] x86: add is_f00f_bug helper to fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <478D786F.2040505@zytor.com>
References: <1200451715.16794.71.camel@brick>
	 <20080116031149.GA14210@phobos.i.cabal.ca>  <478D786F.2040505@zytor.com>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 19:42:02 -0800
Message-Id: <1200454922.16794.75.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-15 at 22:22 -0500, H. Peter Anvin wrote:
> Kyle McMartin wrote:
> > On Tue, Jan 15, 2008 at 06:48:35PM -0800, Harvey Harrison wrote:
> >> +#ifdef CONFIG_X86_F00F_BUG
> >> +void do_invalid_op(struct pt_regs *, unsigned long);
> >> +#endif
> >> +
> >> +static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
> >> +{
> >> +#ifdef CONFIG_X86_F00F_BUG
> >> +	unsigned long nr;
> > 
> > You can just put the prototype inside the function, you know...
> 
> You can also make the prototype unconditional, even if the function 
> doesn't necessarily exist.

I'll go with the unconditional prototype, the function will always
exist, it's a bit hard to find as it's done with a macro in
traps_32|64.c.

Harvey


From: Harvey Harrison <harvey.harrison@gmail.com>

Further towards unifying these files, add another helper
in same spirit as is_errata93.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   39 ++++++++++++++++++++++-----------------
 arch/x86/mm/fault_64.c |   24 ++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 936bb0c..dae4f69 100644
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
@@ -288,6 +286,26 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+void do_invalid_op(struct pt_regs *, unsigned long);
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
@@ -570,21 +588,8 @@ bad_area_nosemaphore:
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
index cde110c..ce1a870 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -256,6 +256,27 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+void do_invalid_op(struct pt_regs *, unsigned long);
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
@@ -572,6 +593,9 @@ bad_area_nosemaphore:
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



