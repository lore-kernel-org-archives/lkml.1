Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYFSHSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYFSHSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 03:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYFSHRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 03:17:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:48403 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYFSHRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 03:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=c/YnfueFfbcwQwpRPz2Q67SFWmEk5gf+x56uf9BRBo/Uw8l5gGtGa4Jbg4YajYA3GA
         /52ejoVfCxvIGE0PYMKSldQgNTz6Mvtij12Gx5UXvZL6S6UJlk09Spi1xnmZQQTd4iLU
         w5elmipZFoFJWhGZL8dKxAwchTLlukbOeRW7c=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: let MPS support selectable
Date: Thu, 19 Jun 2008 00:18:44 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806181432.57204.yhlu.kernel@gmail.com> <200806181729.31464.yhlu.kernel@gmail.com>
In-Reply-To: <200806181729.31464.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806190018.45944.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/Kconfig            |   15 ++++++++++++++-
 arch/x86/Kconfig.debug      |    9 ---------
 arch/x86/mm/k8topology_64.c |    4 ++++
 3 files changed, 18 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -233,6 +233,19 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config X86_FIND_SMP_CONFIG
+	def_bool y
+	depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
+	depends on X86_32
+
+config X86_MPPARSE
+	def_bool y
+	bool "Enable MPS table"
+	depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
+	help
+	  For old smp systems that do not have proper acpi support. Newer systems
+	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC
@@ -289,7 +302,7 @@ if X86_GENERICARCH
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
-	depends on SMP && X86_32 && PCI
+	depends on SMP && X86_32 && PCI && X86_MPPARSE
 	select NUMA
 	help
 	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
Index: linux-2.6/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.debug
+++ linux-2.6/arch/x86/Kconfig.debug
@@ -130,15 +130,6 @@ config 4KSTACKS
 	  on the VM subsystem for higher order allocations. This option
 	  will also use IRQ stacks to compensate for the reduced stackspace.
 
-config X86_FIND_SMP_CONFIG
-	def_bool y
-	depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
-	depends on X86_32
-
-config X86_MPPARSE
-	def_bool y
-	depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
-
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EMBEDDED
Index: linux-2.6/arch/x86/mm/k8topology_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/k8topology_64.c
+++ linux-2.6/arch/x86/mm/k8topology_64.c
@@ -57,18 +57,22 @@ static __init void early_get_boot_cpu_id
 	/*
 	 * Find possible boot-time SMP configuration:
 	 */
+#ifdef CONFIG_X86_MPPARSE
 	early_find_smp_config();
+#endif
 #ifdef CONFIG_ACPI
 	/*
 	 * Read APIC information from ACPI tables.
 	 */
 	early_acpi_boot_init();
 #endif
+#ifdef CONFIG_X86_MPPARSE
 	/*
 	 * get boot-time SMP configuration:
 	 */
 	if (smp_found_config)
 		early_get_smp_config();
+#endif
 	early_init_lapic_mapping();
 }
 
