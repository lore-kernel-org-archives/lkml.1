Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYF2HFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYF2HFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYF2HFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:05:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:65215 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYF2HFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=yDYiuahfVlGaIp997Krtx2YylZI+FmaadgMHM5X61Zk1+4o2T8UjeFAXPZfWcKTWSU
         wuUHQKUvVGCuRkzcbowuhRWsIFR6111fGIqSbpusxPINm1RfsQpcniImersLci6X7DAS
         oF+TwCjbsMjor04w1KKsskcROvlNmoPf9zwH4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: use disable_apic in 32bit
Date: Sun, 29 Jun 2008 00:06:37 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806290006.37474.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


change the enable_local_apic to static force_enable_local_apic for 32bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/apic_32.c |   15 ++++++++-------
 arch/x86/kernel/setup.c   |    4 ----
 include/asm-x86/apic.h    |    4 ----
 3 files changed, 8 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -55,9 +55,10 @@ unsigned long mp_lapic_addr;
 /*
  * Knob to control our willingness to enable the local APIC.
  *
- * -1=force-disable, +1=force-enable
+ * +1=force-enable
  */
-int enable_local_apic;
+static int force_enable_local_apic;
+int disable_apic;
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
@@ -1099,7 +1100,7 @@ static int __init detect_init_APIC(void)
 	u32 h, l, features;
 
 	/* Disabled by kernel option? */
-	if (enable_local_apic < 0)
+	if (disable_apic)
 		return -1;
 
 	switch (boot_cpu_data.x86_vendor) {
@@ -1122,7 +1123,7 @@ static int __init detect_init_APIC(void)
 		 * Over-ride BIOS and try to enable the local APIC only if
 		 * "lapic" specified.
 		 */
-		if (enable_local_apic <= 0) {
+		if (!force_enable_local_apic) {
 			printk(KERN_INFO "Local APIC disabled by BIOS -- "
 			       "you can enable it with \"lapic\"\n");
 			return -1;
@@ -1208,7 +1209,7 @@ int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
-	if (enable_local_apic < 0)
+	if (disable_apic)
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 
 	if (!smp_found_config && !cpu_has_apic)
@@ -1682,14 +1683,14 @@ static void apic_pm_activate(void) { }
  */
 static int __init parse_lapic(char *arg)
 {
-	enable_local_apic = 1;
+	force_enable_local_apic = 1;
 	return 0;
 }
 early_param("lapic", parse_lapic);
 
 static int __init parse_nolapic(char *arg)
 {
-	enable_local_apic = -1;
+	disable_apic = 1;
 	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 	return 0;
 }
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -598,12 +598,8 @@ void __init setup_arch(char **cmdline_p)
 
 	if (acpi_mps_check()) {
 #ifdef CONFIG_X86_LOCAL_APIC
-#ifdef CONFIG_X86_32
-		enable_local_apic = -1;
-#else
 		disable_apic = 1;
 #endif
-#endif
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 	}
 
Index: linux-2.6/include/asm-x86/apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic.h
+++ linux-2.6/include/asm-x86/apic.h
@@ -40,11 +40,7 @@ extern int local_apic_timer_c2_ok;
 
 extern int ioapic_force;
 
-#ifdef CONFIG_X86_64
 extern int disable_apic;
-#else
-extern int enable_local_apic;
-#endif
 /*
  * Basic functions accessing APICs.
  */
