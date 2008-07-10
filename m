Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYGJDSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYGJDSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYGJDSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:18:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:53211 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYGJDSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=J2ibd7hTm/VAIiVm1GnnzUbrSq3P5Hngx+V31G/wBjIIHUXzK5j1uF3Jy0wB8Y+gqE
         RL5EJexZ2t79+L5bJT14sBRfEAbVn1gqaw4n7SNxC5M4EYD8IBdziJxa5R6TzHm34El/
         1UvtHC14bc9iUkLwFYthHryS+vnNWop8E+6Bw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: merge __acpi_map_table
Date: Wed, 9 Jul 2008 20:16:36 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com>
In-Reply-To: <200807092015.03004.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092016.36490.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and let 64bit fallback to use fixmap too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c |   23 ++++++-----------------
 include/asm-x86/fixmap_64.h |    5 +++++
 2 files changed, 11 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -109,21 +109,6 @@ static u64 acpi_lapic_addr __initdata =
  */
 enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
 
-#ifdef	CONFIG_X86_64
-
-/* rely on all ACPI tables being in the direct mapping */
-char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
-{
-	if (!phys_addr || !size)
-		return NULL;
-
-	if (phys_addr+size <= (max_pfn_mapped << PAGE_SHIFT) + PAGE_SIZE)
-		return __va(phys_addr);
-
-	return NULL;
-}
-
-#else
 
 /*
  * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
@@ -142,11 +127,15 @@ char *__init __acpi_map_table(unsigned l
 	unsigned long base, offset, mapped_size;
 	int idx;
 
-	if (phys + size < 8 * 1024 * 1024)
+	if (!phys || !size)
+		return NULL;
+
+	if (phys+size <= (max_pfn_mapped << PAGE_SHIFT))
 		return __va(phys);
 
 	offset = phys & (PAGE_SIZE - 1);
 	mapped_size = PAGE_SIZE - offset;
+	clear_fixmap(FIX_ACPI_END);
 	set_fixmap(FIX_ACPI_END, phys);
 	base = fix_to_virt(FIX_ACPI_END);
 
@@ -158,13 +147,13 @@ char *__init __acpi_map_table(unsigned l
 		if (--idx < FIX_ACPI_BEGIN)
 			return NULL;	/* cannot handle this */
 		phys += PAGE_SIZE;
+		clear_fixmap(idx);
 		set_fixmap(idx, phys);
 		mapped_size += PAGE_SIZE;
 	}
 
 	return ((unsigned char *)base + offset);
 }
-#endif
 
 #ifdef CONFIG_PCI_MMCONFIG
 /* The physical address of the MMCONFIG aperture.  Set from ACPI tables. */
Index: linux-2.6/include/asm-x86/fixmap_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/fixmap_64.h
+++ linux-2.6/include/asm-x86/fixmap_64.h
@@ -12,6 +12,7 @@
 #define _ASM_FIXMAP_64_H
 
 #include <linux/kernel.h>
+#include <asm/acpi.h>
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
@@ -49,6 +50,10 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
+#ifdef CONFIG_ACPI
+	FIX_ACPI_BEGIN,
+	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
+#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
