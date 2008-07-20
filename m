Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYGTBDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYGTBDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 21:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYGTBDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 21:03:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:5980 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbYGTBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 21:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=q8yPtAaXTcr19WKdpBmKlz4CnMB9Y42pw7U4OeLASE5m2TR13/0wz6VIpE19bRaf2t
         hmzX84kT3ZNVuqjRwREUON5YBn5ctD87xzI7xvtVpkldSYVkNL7TUE3wsBkA2PRBDA7i
         iPh2qIEOaPNu8rRXnu1lBQBJfThxvemY3VDZ0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: add pre_time_init in x86_ops
Date: Sat, 19 Jul 2008 18:02:26 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807190207.26077.yhlu.kernel@gmail.com>
In-Reply-To: <200807190207.26077.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807191802.26193.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



so numaq could use that to call numaq_pre_time_init

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/numaq_32.c    |    7 +++++++
 arch/x86/kernel/setup.c       |    8 --------
 arch/x86/kernel/time_32.c     |    1 +
 arch/x86/mach-default/setup.c |   10 ++++++++++
 include/asm-x86/arch_hooks.h  |    1 +
 include/asm-x86/setup.h       |    1 +
 6 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -84,6 +84,12 @@ void __init numaq_tsc_disable(void)
 	}
 }
 
+static int __init numaq_pre_time_init(void)
+{
+	numaq_tsc_disable();
+	return 0;
+}
+
 int found_numaq;
 /*
  * Have to match translation table entries to main table entries by counter
@@ -224,6 +230,7 @@ static void __init smp_read_mpc_oem(stru
 }
 
 static struct x86_ops numaq_x86_ops __initdata = {
+	.arch_pre_time_init	= numaq_pre_time_init,
 	.arch_time_init		= NULL,
 	.arch_pre_intr_init	= NULL,
 	.arch_memory_setup	= NULL,
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -858,14 +858,6 @@ void __init setup_arch(char **cmdline_p)
 	init_cpu_to_node();
 #endif
 
-#ifdef CONFIG_X86_NUMAQ
-	/*
-	 * need to check online nodes num, call it
-	 * here before time_init/tsc_init
-	 */
-	numaq_tsc_disable();
-#endif
-
 	init_apic_mappings();
 	ioapic_init_mappings();
 
Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -129,6 +129,7 @@ void __init hpet_time_init(void)
  */
 void __init time_init(void)
 {
+	pre_time_init_hook();
 	tsc_init();
 	late_time_init = choose_time_init();
 }
Index: linux-2.6/arch/x86/mach-default/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-default/setup.c
+++ linux-2.6/arch/x86/mach-default/setup.c
@@ -103,6 +103,16 @@ static struct irqaction irq0  = {
 };
 
 /**
+ * pre_time_init_hook - do any specific initialisations before.
+ *
+ **/
+void __init pre_time_init_hook(void)
+{
+	if (x86_ops->arch_pre_time_init)
+		x86_ops->arch_pre_time_init();
+}
+
+/**
  * time_init_hook - do any specific initialisations for the system timer.
  *
  * Description:
Index: linux-2.6/include/asm-x86/arch_hooks.h
===================================================================
--- linux-2.6.orig/include/asm-x86/arch_hooks.h
+++ linux-2.6/include/asm-x86/arch_hooks.h
@@ -21,6 +21,7 @@ extern void intr_init_hook(void);
 extern void pre_intr_init_hook(void);
 extern void pre_setup_arch_hook(void);
 extern void trap_init_hook(void);
+extern void pre_time_init_hook(void);
 extern void time_init_hook(void);
 extern void mca_nmi_hook(void);
 
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -23,6 +23,7 @@ struct mpc_config_processor;
 struct mpc_config_bus;
 struct mp_config_oemtable;
 struct x86_ops {
+	int (*arch_pre_time_init)(void);
 	int (*arch_time_init)(void);
 	int (*arch_pre_intr_init)(void);
 	int (*arch_intr_init)(void);
