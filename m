Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYHXJGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYHXJGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYHXJDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbYHXJDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JmLh54WHVUaMKU2zl717F0LcPKlJM8wbkMZ01Zv+rBXa1GwbEIGr3dmMuVaTtZxaHy
         XxT6Qj8zbMb5bdQoISSh45tsrn+ZD3KI6tGAhDaaXw0qa9IxqJ1ej6jjAQSAncfDjASp
         BfqDRfNYeuvtWcggZMKK9j6dMFlE8GLi6dPgg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 09/18] x86: use HAVE_X2APIC in apic_64.c
Date: Sun, 24 Aug 2008 02:01:47 -0700
Message-Id: <1219568516-681-10-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_64.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index c40a900..d3ec746 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -82,10 +82,23 @@ static __init int setup_apicpmtimer(char *s)
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
-int disable_x2apic;
+#ifdef CONFIG_X86_64
+#define HAVE_X2APIC
+#endif
+
+#ifdef HAVE_X2APIC
 int x2apic;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
+int disable_x2apic;
+static __init int setup_nox2apic(char *str)
+{
+	disable_x2apic = 1;
+	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+	return 0;
+}
+early_param("nox2apic", setup_nox2apic);
+#endif
 
 unsigned long mp_lapic_addr;
 int disable_apic;
@@ -228,6 +241,7 @@ static struct apic_ops xapic_ops = {
 struct apic_ops __read_mostly *apic_ops = &xapic_ops;
 EXPORT_SYMBOL_GPL(apic_ops);
 
+#ifdef HAVE_X2APIC
 static void x2apic_wait_icr_idle(void)
 {
 	/* no need to wait for icr idle in x2apic */
@@ -261,6 +275,7 @@ static struct apic_ops x2apic_ops = {
 	.wait_icr_idle = x2apic_wait_icr_idle,
 	.safe_wait_icr_idle = safe_x2apic_wait_icr_idle,
 };
+#endif
 
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
@@ -1125,6 +1140,7 @@ void __cpuinit end_local_APIC_setup(void)
 	apic_pm_activate();
 }
 
+#ifdef HAVE_X2APIC
 void check_x2apic(void)
 {
 	int msr, msr2;
@@ -1243,6 +1259,7 @@ end:
 
 	return;
 }
+#endif /* HAVE_X2APIC */
 
 /*
  * Detect and enable local APICs on non-SMP boards.
@@ -1291,10 +1308,12 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
+#ifdef HAVE_X2APIC
 	if (x2apic) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
 	}
+#endif
 
 	/*
 	 * If no local APIC can be found then set up a fake all
@@ -1335,8 +1354,9 @@ int __init APIC_init_uniprocessor(void)
 		printk(KERN_INFO "Apic disabled by BIOS\n");
 		return -1;
 	}
-
+#ifdef HAVE_X2APIC
 	enable_IR_x2apic();
+#endif
 	setup_apic_routing();
 
 	verify_local_APIC();
@@ -1672,7 +1692,7 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_save(flags);
 
-#ifdef CONFIG_X86_64
+#ifdef HAVE_X2APIC
 	if (x2apic)
 		enable_x2apic();
 	else
@@ -1836,15 +1856,6 @@ __cpuinit int apic_is_clustered_box(void)
 	return (clusters > 2);
 }
 
-static __init int setup_nox2apic(char *str)
-{
-	disable_x2apic = 1;
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_X2APIC);
-	return 0;
-}
-early_param("nox2apic", setup_nox2apic);
-
-
 /*
  * APIC command line parameters
  */
-- 
1.5.4.5

