Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbYFZBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbYFZBFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYFZBBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:49 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYFZBBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kuXRdngu2WMBMz53g+DskUcHiJBUbIHrwjFfHJK9F9nAyiugt/DTZ9z35HaPLIkrMc
         p/VUHGX7mACgKGQ1uAme59CuE35EkLIldYNPAnMs9/1wBJY+XBRkGtMuW8YDt6K+Bz5v
         XUthrSDFCbvDa4U4eTZmLBHO82/IgGJ4DrZcw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 11/16] x86: move back crashkernel back to setup.c
Date: Wed, 25 Jun 2008 17:57:13 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251757.13333.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c        |   58 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_percpu.c |   57 ----------------------------------------
 2 files changed, 58 insertions(+), 57 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -397,6 +397,64 @@ void __init parse_setup_data(void)
 }
 
 /*
+ * --------- Crashkernel reservation ------------------------------
+ */
+
+#ifdef CONFIG_KEXEC
+static inline unsigned long long get_total_mem(void)
+{
+	unsigned long long total;
+
+	total = max_low_pfn - min_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	total += highend_pfn - highstart_pfn;
+#endif
+
+	return total << PAGE_SHIFT;
+}
+
+void __init reserve_crashkernel(void)
+{
+	unsigned long long total_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
+
+	total_mem = get_total_mem();
+
+	ret = parse_crashkernel(boot_command_line, total_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0) {
+		if (crash_base <= 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem_generic(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
+		insert_resource(&iomem_resource, &crashk_res);
+	}
+}
+#else
+void __init reserve_crashkernel(void)
+{
+}
+#endif
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -387,63 +387,6 @@ EXPORT_SYMBOL(node_to_cpumask);
 
 #endif /* X86_64_NUMA */
 
-/*
- * --------- Crashkernel reservation ------------------------------
- */
-
-static inline unsigned long long get_total_mem(void)
-{
-	unsigned long long total;
-
-	total = max_low_pfn - min_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	total += highend_pfn - highstart_pfn;
-#endif
-
-	return total << PAGE_SHIFT;
-}
-
-#ifdef CONFIG_KEXEC
-void __init reserve_crashkernel(void)
-{
-	unsigned long long total_mem;
-	unsigned long long crash_size, crash_base;
-	int ret;
-
-	total_mem = get_total_mem();
-
-	ret = parse_crashkernel(boot_command_line, total_mem,
-			&crash_size, &crash_base);
-	if (ret == 0 && crash_size > 0) {
-		if (crash_base <= 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"you have to specify a base address\n");
-			return;
-		}
-
-		if (reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE) < 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"memory is in use\n");
-			return;
-		}
-
-		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-				"for crashkernel (System RAM: %ldMB)\n",
-				(unsigned long)(crash_size >> 20),
-				(unsigned long)(crash_base >> 20),
-				(unsigned long)(total_mem >> 20));
-
-		crashk_res.start = crash_base;
-		crashk_res.end   = crash_base + crash_size - 1;
-		insert_resource(&iomem_resource, &crashk_res);
-	}
-}
-#else
-void __init reserve_crashkernel(void)
-{}
-#endif
-
 static struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f,
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
