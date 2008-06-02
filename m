Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYFBGZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYFBGZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYFBGYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:24:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:33215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYFBGYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:24:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,576,1204531200"; 
   d="scan'208";a="389289986"
Subject: [PATCH 4/5] x86_64 boot: extract common part of head32.c and
	head64.c into head.c
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Jun 2008 14:26:23 +0800
Message-Id: <1212387983.301.29.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 02 Jun 2008 06:24:36.0252 (UTC) FILETIME=[542F1DC0:01C8C479]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extracts the common part of head32.c and head64.c into head.c.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/Makefile           |    1 
 arch/x86/kernel/Makefile    |    2 -
 arch/x86/kernel/head.c      |   55 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/head32.c    |   50 ----------------------------------------
 arch/x86/kernel/head64.c    |   50 ----------------------------------------
 include/asm-x86/bios_ebda.h |    2 +
 6 files changed, 59 insertions(+), 101 deletions(-)

--- /dev/null
+++ b/arch/x86/kernel/head.c
@@ -0,0 +1,55 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <asm/setup.h>
+#include <asm/bios_ebda.h>
+
+#define BIOS_LOWMEM_KILOBYTES 0x413
+
+/*
+ * The BIOS places the EBDA/XBDA at the top of conventional
+ * memory, and usually decreases the reported amount of
+ * conventional memory (int 0x12) too. This also contains a
+ * workaround for Dell systems that neglect to reserve EBDA.
+ * The same workaround also avoids a problem with the AMD768MPX
+ * chipset: reserve a page before VGA to prevent PCI prefetch
+ * into it (errata #56). Usually the page is reserved anyways,
+ * unless you have no PS/2 mouse plugged in.
+ */
+void __init reserve_ebda_region(void)
+{
+	unsigned int lowmem, ebda_addr;
+
+	/* To determine the position of the EBDA and the */
+	/* end of conventional memory, we need to look at */
+	/* the BIOS data area. In a paravirtual environment */
+	/* that area is absent. We'll just have to assume */
+	/* that the paravirt case can handle memory setup */
+	/* correctly, without our help. */
+	if (paravirt_enabled())
+		return;
+
+	/* end of low (conventional) memory */
+	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
+	lowmem <<= 10;
+
+	/* start of EBDA area */
+	ebda_addr = get_bios_ebda();
+
+	/* Fixup: bios puts an EBDA in the top 64K segment */
+	/* of conventional memory, but does not adjust lowmem. */
+	if ((lowmem - ebda_addr) <= 0x10000)
+		lowmem = ebda_addr;
+
+	/* Fixup: bios does not report an EBDA at all. */
+	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
+	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
+		lowmem = 0x9f000;
+
+	/* Paranoia: should never happen, but... */
+	if ((lowmem == 0) || (lowmem >= 0x100000))
+		lowmem = 0x9f000;
+
+	/* reserve all memory between lowmem and the 1MB mark */
+	reserve_early(lowmem, 0x100000, "BIOS reserved");
+}
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -13,56 +13,6 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 
-#define BIOS_LOWMEM_KILOBYTES 0x413
-
-/*
- * The BIOS places the EBDA/XBDA at the top of conventional
- * memory, and usually decreases the reported amount of
- * conventional memory (int 0x12) too. This also contains a
- * workaround for Dell systems that neglect to reserve EBDA.
- * The same workaround also avoids a problem with the AMD768MPX
- * chipset: reserve a page before VGA to prevent PCI prefetch
- * into it (errata #56). Usually the page is reserved anyways,
- * unless you have no PS/2 mouse plugged in.
- */
-static void __init reserve_ebda_region(void)
-{
-	unsigned int lowmem, ebda_addr;
-
-	/* To determine the position of the EBDA and the */
-	/* end of conventional memory, we need to look at */
-	/* the BIOS data area. In a paravirtual environment */
-	/* that area is absent. We'll just have to assume */
-	/* that the paravirt case can handle memory setup */
-	/* correctly, without our help. */
-	if (paravirt_enabled())
-		return;
-
-	/* end of low (conventional) memory */
-	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
-	lowmem <<= 10;
-
-	/* start of EBDA area */
-	ebda_addr = get_bios_ebda();
-
-	/* Fixup: bios puts an EBDA in the top 64K segment */
-	/* of conventional memory, but does not adjust lowmem. */
-	if ((lowmem - ebda_addr) <= 0x10000)
-		lowmem = ebda_addr;
-
-	/* Fixup: bios does not report an EBDA at all. */
-	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
-	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
-		lowmem = 0x9f000;
-
-	/* Paranoia: should never happen, but... */
-	if ((lowmem == 0) || (lowmem >= 0x100000))
-		lowmem = 0x9f000;
-
-	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_early(lowmem, 0x100000, "BIOS reserved");
-}
-
 void __init i386_start_kernel(void)
 {
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -65,56 +65,6 @@ static void __init copy_bootdata(char *r
 	}
 }
 
-#define BIOS_LOWMEM_KILOBYTES 0x413
-
-/*
- * The BIOS places the EBDA/XBDA at the top of conventional
- * memory, and usually decreases the reported amount of
- * conventional memory (int 0x12) too. This also contains a
- * workaround for Dell systems that neglect to reserve EBDA.
- * The same workaround also avoids a problem with the AMD768MPX
- * chipset: reserve a page before VGA to prevent PCI prefetch
- * into it (errata #56). Usually the page is reserved anyways,
- * unless you have no PS/2 mouse plugged in.
- */
-static void __init reserve_ebda_region(void)
-{
-	unsigned int lowmem, ebda_addr;
-
-	/* To determine the position of the EBDA and the */
-	/* end of conventional memory, we need to look at */
-	/* the BIOS data area. In a paravirtual environment */
-	/* that area is absent. We'll just have to assume */
-	/* that the paravirt case can handle memory setup */
-	/* correctly, without our help. */
-	if (paravirt_enabled())
-		return;
-
-	/* end of low (conventional) memory */
-	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
-	lowmem <<= 10;
-
-	/* start of EBDA area */
-	ebda_addr = get_bios_ebda();
-
-	/* Fixup: bios puts an EBDA in the top 64K segment */
-	/* of conventional memory, but does not adjust lowmem. */
-	if ((lowmem - ebda_addr) <= 0x10000)
-		lowmem = ebda_addr;
-
-	/* Fixup: bios does not report an EBDA at all. */
-	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
-	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
-		lowmem = 0x9f000;
-
-	/* Paranoia: should never happen, but... */
-	if ((lowmem == 0) || (lowmem >= 0x100000))
-		lowmem = 0x9f000;
-
-	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_early(lowmem, 0x100000, "BIOS reserved");
-}
-
 static void __init reserve_setup_data(void)
 {
 	struct setup_data *data;
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y                := head_$(BITS).o head$(BITS).o init_task.o vmlinux.lds
+extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o vmlinux.lds
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
--- a/include/asm-x86/bios_ebda.h
+++ b/include/asm-x86/bios_ebda.h
@@ -14,4 +14,6 @@ static inline unsigned int get_bios_ebda
 	return address;	/* 0 means none */
 }
 
+void reserve_ebda_region(void);
+
 #endif /* _MACH_BIOS_EBDA_H */
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -160,6 +160,7 @@ KBUILD_AFLAGS += $(mflags-y)
 
 head-y := arch/x86/kernel/head_$(BITS).o
 head-y += arch/x86/kernel/head$(BITS).o
+head-y += arch/x86/kernel/head.o
 head-y += arch/x86/kernel/init_task.o
 
 libs-y  += arch/x86/lib/

