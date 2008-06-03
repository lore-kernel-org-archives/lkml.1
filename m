Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYFCR0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYFCR0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYFCR0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:26:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:4132 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYFCR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Lbv7WQ5jGCDhUIN544mCNSVRm0EmwO7SKJYc9kNQjAdCEKoobw8Rv8jnbZ4whV3tx9nhk0rY6UnaFd3rxTF2Hci0+ciLLT4rmgSRAghF/rJrwLXEmabKRSV/I2ygU4vZHiFVemlwRa2M47/KdsPqMp4YZlwdKIgoJ+tq845OR3c=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: early check if one system is numaq v2
Date: Tue, 3 Jun 2008 10:25:54 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031025.55026.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so could fallback one node numa
v2: using found_numaq with MP_processor_info and MP_bus_info

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -70,7 +70,10 @@ static void __cpuinit MP_processor_info(
 		return;
 	}
 #ifdef CONFIG_X86_NUMAQ
-	apicid = mpc_apic_id(m, translation_table[mpc_record]);
+	if (found_numaq)
+		apicid = mpc_apic_id(m, translation_table[mpc_record]);
+	else
+		apicid = m->mpc_apicid;
 #else
 	apicid = m->mpc_apicid;
 #endif
@@ -91,7 +94,8 @@ static void __init MP_bus_info(struct mp
 	str[6] = 0;
 
 #ifdef CONFIG_X86_NUMAQ
-	mpc_oem_bus_info(m, str, translation_table[mpc_record]);
+	if (found_numaq)
+		mpc_oem_bus_info(m, str, translation_table[mpc_record]);
 #else
 	printk(KERN_INFO "Bus #%d is %s\n", m->mpc_busid, str);
 #endif
@@ -112,7 +116,8 @@ static void __init MP_bus_info(struct mp
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
 #ifdef CONFIG_X86_NUMAQ
-		mpc_oem_pci_bus(m, translation_table[mpc_record]);
+		if (found_numaq)
+			mpc_oem_pci_bus(m, translation_table[mpc_record]);
 #endif
 		clear_bit(m->mpc_busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined (CONFIG_MCA)
@@ -321,6 +326,9 @@ static inline void mps_oem_check(struct 
 {
 	if (strncmp(oem, "IBM NUMA", 8))
 		printk("Warning!  May not be a NUMA-Q system!\n");
+	else
+		found_numaq = 1;
+
 	if (mpc->mpc_oemptr)
 		smp_read_mpc_oem((struct mp_config_oemtable *)mpc->mpc_oemptr,
 				 mpc->mpc_oemsize);
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -31,9 +31,12 @@
 #include <asm/numaq.h>
 #include <asm/topology.h>
 #include <asm/processor.h>
+#include <asm/mpspec.h>
 
 #define	MB_TO_PAGES(addr) ((addr) << (20 - PAGE_SHIFT))
 
+int found_numaq;
+
 /*
  * Function: smp_dump_qct()
  *
@@ -67,13 +70,24 @@ static void __init smp_dump_qct(void)
 	}
 }
 
-/*
- * Unlike Summit, we don't really care to let the NUMA-Q
- * fall back to flat mode.  Don't compile for NUMA-Q
- * unless you really need it!
- */
+static __init void early_check_numaq(void)
+{
+	/*
+	 * Find possible boot-time SMP configuration:
+	 */
+	early_find_smp_config();
+	/*
+	 * get boot-time SMP configuration:
+	 */
+	if (smp_found_config)
+		early_get_smp_config();
+}
+
 int __init get_memcfg_numaq(void)
 {
+	early_check_numaq();
+	if (!found_numaq)
+		return 0;
 	smp_dump_qct();
 	return 1;
 }
Index: linux-2.6/include/asm-x86/numaq.h
===================================================================
--- linux-2.6.orig/include/asm-x86/numaq.h
+++ linux-2.6/include/asm-x86/numaq.h
@@ -28,6 +28,7 @@
 
 #ifdef CONFIG_X86_NUMAQ
 
+extern int found_numaq;
 extern int get_memcfg_numaq(void);
 
 /*
Index: linux-2.6/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mpspec.h
+++ linux-2.6/include/asm-x86/mpspec.h
@@ -21,11 +21,11 @@ extern int pic_mode;
 /* Each PCI slot may be a combo card with its own bus.  4 IRQ pins per slot. */
 #define MAX_IRQ_SOURCES (MAX_MP_BUSSES * 4)
 
+#endif
+
 extern void early_find_smp_config(void);
 extern void early_get_smp_config(void);
 
-#endif
-
 #if defined(CONFIG_MCA) || defined(CONFIG_EISA)
 extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
