Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbYEXPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbYEXPmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbYEXPly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:10483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbYEXPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=tWE/ZLrtPPA0T5wKaWvJ20so38fJqShyj+CyUdJ+JqwOy5ngDIjqg1Q8q3SFvq1FB+5664xkkdoB+PsDlTrAisLpcNCUHfe7X7PGmLuzd5lGnY3B05+FQ5YgDFtXt36Q7caOvcb08BDoDunoZ3Xo+vgfn1oQtkb5jFvEwvdSWzE=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 03/11] x86: nmi_64.c - move do_nmi(), stop_nmi() and restart_nmi() implementation to traps_64.c
Content-Disposition: inline; filename=nmi-64-move-spec-func-to-traps
Message-ID: <4838373e.1438560a.6987.3a12@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

traps_32.c already holds these functions so do the same for traps_64.c

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_64.c	2008-05-24 12:25:57.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_64.c	2008-05-24 12:38:09.000000000 +0400
@@ -30,7 +30,6 @@
 
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
-int panic_on_unrecovered_nmi;
 
 static cpumask_t backtrace_mask = CPU_MASK_NONE;
 
@@ -383,30 +382,6 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 	return rc;
 }
 
-static unsigned ignore_nmis;
-
-asmlinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	nmi_enter();
-	add_pda(__nmi_count,1);
-	if (!ignore_nmis)
-		default_do_nmi(regs);
-	nmi_exit();
-}
-
-void stop_nmi(void)
-{
-	acpi_nmi_disable();
-	ignore_nmis++;
-}
-
-void restart_nmi(void)
-{
-	ignore_nmis--;
-	acpi_nmi_enable();
-}
-
 #ifdef CONFIG_SYSCTL
 
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
Index: linux-2.6.git/arch/x86/kernel/traps_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_64.c	2008-05-24 12:25:11.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/traps_64.c	2008-05-24 12:39:18.000000000 +0400
@@ -76,7 +76,9 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);
 
+int panic_on_unrecovered_nmi;
 static unsigned int code_bytes = 64;
+static unsigned ignore_nmis;
 
 static inline void conditional_sti(struct pt_regs *regs)
 {
@@ -867,6 +869,28 @@ asmlinkage notrace  __kprobes void defau
 		io_check_error(reason, regs);
 }
 
+asmlinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_enter();
+	add_pda(__nmi_count, 1);
+	if (!ignore_nmis)
+		default_do_nmi(regs);
+	nmi_exit();
+}
+
+void stop_nmi(void)
+{
+	acpi_nmi_disable();
+	ignore_nmis++;
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+	acpi_nmi_enable();
+}
+
 /* runs on IST stack. */
 asmlinkage void __kprobes do_int3(struct pt_regs * regs, long error_code)
 {

-- 
