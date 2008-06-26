Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbYFZBDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbYFZBDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbYFZBBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:42 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbYFZBBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=BAyYJlXrf/d8bAJK/shVzgu456TKZFYfdH8ALjslyjt6DdtLpMTdoKwtfbqtj4QPIp
         a05fpOOzuHDf0pJcB6/RgMUlbJvjXIW3PpkMUOpor+Qt4nryVp1IlCB3ig/XmnDKClin
         Nxn4tVaP2kivyTO0L/TmyzGyGI4OofT2N7ihg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 04/16] x86: put global variable for 32bit all together
Date: Wed, 25 Jun 2008 17:50:06 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251750.06830.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




those variables are not needed by 64 bit.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -100,6 +100,8 @@ static struct resource bss_resource = {
 	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
 };
 
+
+#ifdef CONFIG_X86_32
 static struct resource video_ram_resource = {
 	.name	= "Video RAM area",
 	.start	= 0xa0000,
@@ -108,24 +110,47 @@ static struct resource video_ram_resourc
 };
 
 /* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
+struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 /* common cpu data for all cpus */
-struct cpuinfo_x86 boot_cpu_data __read_mostly = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
+struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 EXPORT_SYMBOL(boot_cpu_data);
+static void set_mca_bus(int x)
+{
+#ifdef CONFIG_MCA
+	MCA_bus = x;
+#endif
+}
 
 unsigned int def_to_bigsmp;
 
-#ifndef CONFIG_X86_PAE
-unsigned long mmu_cr4_features;
-#else
-unsigned long mmu_cr4_features = X86_CR4_PAE;
-#endif
-
 /* for MCA, but anyone else can use it if they want */
 unsigned int machine_id;
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
 
+struct apm_info apm_info;
+EXPORT_SYMBOL(apm_info);
+
+#if defined(CONFIG_X86_SPEEDSTEP_SMI) || \
+	defined(CONFIG_X86_SPEEDSTEP_SMI_MODULE)
+struct ist_info ist_info;
+EXPORT_SYMBOL(ist_info);
+#else
+struct ist_info ist_info;
+#endif
+
+#else
+struct cpuinfo_x86 boot_cpu_data __read_mostly;
+EXPORT_SYMBOL(boot_cpu_data);
+#endif
+
+
+#if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
+unsigned long mmu_cr4_features;
+#else
+unsigned long mmu_cr4_features = X86_CR4_PAE;
+#endif
+
 /* Boot loader ID as an integer, for the benefit of proc_dointvec */
 int bootloader_type;
 
@@ -140,15 +165,8 @@ char dmi_alloc_data[DMI_MAX_DATA];
  */
 struct screen_info screen_info;
 EXPORT_SYMBOL(screen_info);
-struct apm_info apm_info;
-EXPORT_SYMBOL(apm_info);
 struct edid_info edid_info;
 EXPORT_SYMBOL_GPL(edid_info);
-struct ist_info ist_info;
-#if defined(CONFIG_X86_SPEEDSTEP_SMI) || \
-	defined(CONFIG_X86_SPEEDSTEP_SMI_MODULE)
-EXPORT_SYMBOL(ist_info);
-#endif
 
 extern int root_mountflags;
 
@@ -303,15 +321,6 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-#ifdef CONFIG_MCA
-static void set_mca_bus(int x)
-{
-	MCA_bus = x;
-}
-#else
-static void set_mca_bus(int x) { }
-#endif
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures

