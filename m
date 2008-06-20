Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbYFTOoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbYFTOoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYFTOoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:44:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:55939 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYFTOoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qD/aVOrLsjIcAEaIgj6iSxTd5qKkqC7wSIw1pzfOziL1YMctmpLgcBbe4FdunlUwDs
         VYmMpR9AUmsQGM2HUNgpiciL1FDzQDEWalrnMil93TqArbmiP55IPp950VJKvYdzfX3p
         Q/RhrUquDk03DNr72pEbYfE4B46juaEb5gMjY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: check command line when CONFIG_X86_MPPARSE is not set
Date: Fri, 20 Jun 2008 07:42:35 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806191213.10312.yhlu.kernel@gmail.com> <200806191215.01538.yhlu.kernel@gmail.com>
In-Reply-To: <200806191215.01538.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806200742.36226.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we can not use acpi=off, acpi=noirq and pci=noacpi when mps support is
not there

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c |   12 ++++++++++++
 arch/x86/kernel/setup_32.c  |    2 ++
 arch/x86/kernel/setup_64.c  |    2 ++
 include/linux/acpi.h        |    5 +++++
 4 files changed, 21 insertions(+)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1740,6 +1740,18 @@ static int __init parse_pci(char *arg)
 }
 early_param("pci", parse_pci);
 
+void __init acpi_mps_check(void)
+{
+#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_X86_MPPARSE)
+/* mptable code is not built-in*/
+	if (acpi_disabled || acpi_noirq) {
+		printk(KERN_ERR "MPS support code is not built-in\n",
+		       "so can not use acpi=off or acpi=noirq or pci=noacpi\n");
+		panic("MPS support is not built-in\n");
+	}
+#endif
+}
+
 #ifdef CONFIG_X86_IO_APIC
 static int __init parse_acpi_skip_timer_override(char *arg)
 {
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -754,6 +754,8 @@ void __init setup_arch(char **cmdline_p)
 		early_dump_pci_devices();
 #endif
 
+	acpi_mps_check();
+
 	finish_e820_parsing();
 
 	probe_roms();
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -359,6 +359,8 @@ void __init setup_arch(char **cmdline_p)
 		early_dump_pci_devices();
 #endif
 
+	acpi_mps_check();
+
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	if (init_ohci1394_dma_early)
 		init_ohci1394_dma_on_all_controllers();
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -82,6 +82,7 @@ char * __acpi_map_table (unsigned long p
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
+void acpi_mps_check (void);
 int acpi_numa_init (void);
 
 int acpi_table_init (void);
@@ -250,6 +251,10 @@ static inline int acpi_boot_table_init(v
 	return 0;
 }
 
+static inline void acpi_mps_check(void)
+{
+}
+
 static inline int acpi_check_resource_conflict(struct resource *res)
 {
 	return 0;
