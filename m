Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbZELKh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbZELKh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZELKhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:37:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:59987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZELKhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:37:14 -0400
Date: Tue, 12 May 2009 10:36:29 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, mingo@elte.hu
In-Reply-To: <49FC85A9.2070702@kernel.org>
References: <49FC85A9.2070702@kernel.org>
Subject: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org>
Git-Commit-ID: 4797f6b021a3fa399942245d07a1feb30df81bb8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 10:36:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4797f6b021a3fa399942245d07a1feb30df81bb8
Gitweb:     http://git.kernel.org/tip/4797f6b021a3fa399942245d07a1feb30df81bb8
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 2 May 2009 10:40:57 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 May 2009 12:22:06 +0200

x86: read apic ID in the !acpi_lapic case

Ed found that on 32-bit, boot_cpu_physical_apicid is not read right,
when the mptable is broken.

Interestingly, actually three paths use/set it:

 1. acpi: at that time that is already read from reg
 2. mptable: only read from mptable
 3. no madt, and no mptable, that use default apic id 0 for 64-bit, -1 for 32-bit

so we could read the apic id for the 2/3 path. We trust the hardware
register more than we trust a BIOS data structure (the mptable).

We can also avoid the double set_fixmap() when acpi_lapic
is used, and also need to move cpu_has_apic earlier and
call apic_disable().

Also when need to update the apic id, we'd better read and
set the apic version as well - so that quirks are applied precisely.

v2: make path 3 with 64bit, use -1 as apic id, so could read it later.
v3: fix whitespace problem pointed out by Ed Swierk
v5: fix boot crash

[ Impact: get correct apic id for bsp other than acpi path ]

Reported-by: Ed Swierk <eswierk@aristanetworks.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <49FC85A9.2070702@kernel.org>
[ v4: sanity-check in the ACPI case too ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/smp.h     |    2 +-
 arch/x86/kernel/apic/apic.c    |   46 +++++++++++++++++++--------------------
 arch/x86/kernel/apic/io_apic.c |    5 ++++
 3 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19e0d88..6a84ed1 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -180,7 +180,7 @@ extern int safe_smp_processor_id(void);
 static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
+	return GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 }
 
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 07cffc1..b0fd264 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -242,17 +242,24 @@ static int modern_apic(void)
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
 
@@ -1576,32 +1583,23 @@ void __init init_apic_mappings(void)
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1f3d366..74d2b48 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1878,6 +1878,11 @@ __apicdebuginit(void) print_PIC(void)
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
 
