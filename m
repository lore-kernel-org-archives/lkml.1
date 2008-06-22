Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYFVEBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYFVEBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 00:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYFVEBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 00:01:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:27427 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYFVEBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 00:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gesreXcL1ern+c9YjDTenjGKyyop0pNPnUAS/Grx7xVgTqNUKB7VwJku7KEjM48axe
         Px+Tf+02WC3Sx+l3BL5/yWwK4WKMfdePEuyQcfN3S0zpIGj25RxAFw390z7/gTyFGw/J
         xH1tQLGefkSK+qZoaflPQRp2eMbaNMZk6wX/k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: move elfcorehdr parsing to setup.c
Date: Sat, 21 Jun 2008 21:02:20 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806211916.52949.yhlu.kernel@gmail.com> <200806212022.10077.yhlu.kernel@gmail.com>
In-Reply-To: <200806212022.10077.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212102.20941.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c    |   19 +++++++++++++++++++
 arch/x86/kernel/setup_32.c |   16 ----------------
 arch/x86/kernel/setup_64.c |   17 -----------------
 3 files changed, 19 insertions(+), 33 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -26,7 +26,6 @@
 #include <asm/processor.h>
 #include <linux/console.h>
 #include <linux/seq_file.h>
-#include <linux/crash_dump.h>
 #include <linux/root_dev.h>
 #include <linux/pci.h>
 #include <asm/pci-direct.h>
@@ -131,22 +130,6 @@ static struct resource bss_resource = {
 	.flags = IORESOURCE_RAM,
 };
 
-#ifdef CONFIG_PROC_VMCORE
-/* elfcorehdr= specifies the location of elf core header
- * stored by the crashed kernel. This option will be passed
- * by kexec loader to the capture kernel.
- */
-static int __init setup_elfcorehdr(char *arg)
-{
-	char *end;
-	if (!arg)
-		return -EINVAL;
-	elfcorehdr_addr = memparse(arg, &end);
-	return end > arg ? 0 : -EINVAL;
-}
-early_param("elfcorehdr", setup_elfcorehdr);
-#endif
-
 #ifndef CONFIG_NUMA
 static void __init
 contig_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -42,7 +42,6 @@
 #include <linux/iscsi_ibft.h>
 #include <linux/nodemask.h>
 #include <linux/kexec.h>
-#include <linux/crash_dump.h>
 #include <linux/dmi.h>
 #include <linux/pfn.h>
 #include <linux/pci.h>
@@ -195,21 +194,6 @@ static inline void copy_edd(void)
 }
 #endif
 
-#ifdef CONFIG_PROC_VMCORE
-/* elfcorehdr= specifies the location of elf core header
- * stored by the crashed kernel.
- */
-static int __init parse_elfcorehdr(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	elfcorehdr_addr = memparse(arg, &arg);
-	return 0;
-}
-early_param("elfcorehdr", parse_elfcorehdr);
-#endif /* CONFIG_PROC_VMCORE */
-
 /*
  * highmem=size forces highmem to be exactly 'size' bytes.
  * This works even on boxes that have no highmem otherwise.
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -4,6 +4,7 @@
 #include <linux/bootmem.h>
 #include <linux/percpu.h>
 #include <linux/kexec.h>
+#include <linux/crash_dump.h>
 #include <asm/smp.h>
 #include <asm/percpu.h>
 #include <asm/sections.h>
@@ -500,3 +501,21 @@ void __init reserve_standard_io_resource
 		request_resource(&ioport_resource, &standard_io_resources[i]);
 
 }
+
+#ifdef CONFIG_PROC_VMCORE
+/* elfcorehdr= specifies the location of elf core header
+ * stored by the crashed kernel. This option will be passed
+ * by kexec loader to the capture kernel.
+ */
+static int __init setup_elfcorehdr(char *arg)
+{
+	char *end;
+	if (!arg)
+		return -EINVAL;
+	elfcorehdr_addr = memparse(arg, &end);
+	return end > arg ? 0 : -EINVAL;
+}
+early_param("elfcorehdr", setup_elfcorehdr);
+#endif
+
+
