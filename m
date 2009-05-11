Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZEKUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZEKUPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZEKUPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:15:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:46289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZEKUPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:15:30 -0400
Message-ID: <4A088731.6040906@kernel.org>
Date: Mon, 11 May 2009 13:14:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: read apic ID in the !acpi_lapic case
References: <49FC85A9.2070702@kernel.org> <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org> <20090511110234.GH4648@elte.hu> <20090511134140.GH4624@lenovo> <20090511134950.GA949@elte.hu> <4A0863C5.9070206@kernel.org> <20090511180521.GL4624@lenovo> <20090511200143.GJ28684@elte.hu>
In-Reply-To: <20090511200143.GJ28684@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> Needs a delta patch against -tip - i got this stuff stable today but 
> i dont want to replace patches as it has a problematic track record 
> already.
> 

diff to current tip/master

[PATCH] x86: add native_apic_read_dummy -v2

when apic is not used ( not there, or disable_apic ), try to install
dummy read too.

could save 4k in that case.

v2: update to after Cyrill's patch

[ Impact: fix bug when try to dump APIC reg ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>

---
 arch/x86/include/asm/smp.h     |    2 -
 arch/x86/kernel/apic/apic.c    |   46 +++++++++++++++++++----------------------
 arch/x86/kernel/apic/io_apic.c |    5 ++++
 3 files changed, 28 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -243,17 +243,24 @@ static int modern_apic(void)
  * bare function to substitute write operation
  * and it's _that_ fast :)
  */
-void native_apic_write_dummy(u32 reg, u32 v)
+static void native_apic_write_dummy(u32 reg, u32 v)
 {
 	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
 }
 
+static u32 native_apic_read_dummy(u32 reg)
+{
+	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	return 0;
+}
+
 /*
- * right after this call apic->write doesn't do anything
+ * right after this call apic->write/read doesn't do anything
  * note that there is no restore operation it works one way
  */
 void apic_disable(void)
 {
+	apic->read = native_apic_read_dummy;
 	apic->write = native_apic_write_dummy;
 }
 
@@ -1580,32 +1587,23 @@ void __init init_apic_mappings(void)
 		return;
 	}
 
-	/*
-	 * If no local APIC can be found then set up a fake all
-	 * zeroes page to simulate the local APIC and another
-	 * one for the IO-APIC.
-	 */
+	/* If no local APIC can be found return early */
 	if (!smp_found_config && detect_init_APIC()) {
-		apic_phys = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
-		apic_phys = __pa(apic_phys);
-	} else
+		/* lets NOP'ify apic operations */
+		pr_info("APIC: disable apic facility\n");
+		apic_disable();
+	} else {
 		apic_phys = mp_lapic_addr;
 
-	/*
-	 * acpi lapic path already maps that address in
-	 * acpi_register_lapic_address()
-	 */
-	if (!acpi_lapic)
-		set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-
-	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-			APIC_BASE, apic_phys);
+		/*
+		 * acpi lapic path already maps that address in
+		 * acpi_register_lapic_address()
+		 */
+		if (!acpi_lapic)
+			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 
-	/* lets check if we may NOP'ify apic operations */
-	if (!cpu_has_apic) {
-		pr_info("APIC: disable apic facility\n");
-		apic_disable();
-		return;
+		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
+					APIC_BASE, apic_phys);
 	}
 
 	/*
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1859,6 +1859,11 @@ __apicdebuginit(void) print_PIC(void)
 __apicdebuginit(int) print_all_ICs(void)
 {
 	print_PIC();
+
+	/* don't print out if apic is not there */
+	if (!cpu_has_apic || disable_apic)
+		return 0;
+
 	print_all_local_APICs();
 	print_IO_APIC();
 
Index: linux-2.6/arch/x86/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smp.h
+++ linux-2.6/arch/x86/include/asm/smp.h
@@ -180,7 +180,7 @@ extern int safe_smp_processor_id(void);
 static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
+	return GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 }
 
 #endif
