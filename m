Return-Path: <linux-kernel-owner+w=401wt.eu-S1161201AbXBUKEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161201AbXBUKEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161220AbXBUKDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:03:33 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:13217 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161222AbXBUKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:03:26 -0500
Date: Wed, 21 Feb 2007 11:03:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] nss: Free unused memory in kernel image.
Message-ID: <20070221100326.GK13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] nss: Free unused memory in kernel image.

With CONFIG_SHARED_KERNEL the kernel text segment that might be in a
read only memory sections starts at 1MB. Memory between 0x12000 and
0x100000 is unused then. Free this, so we have appr. an extra MB
of memory available.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/head31.S   |   15 ++-------------
 arch/s390/kernel/head64.S   |   16 ++--------------
 arch/s390/kernel/ipl.c      |    7 +++++++
 arch/s390/kernel/setup.c    |    7 ++++++-
 drivers/s390/cio/cio.c      |    2 +-
 include/asm-s390/sections.h |    2 +-
 6 files changed, 19 insertions(+), 30 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/head31.S linux-2.6-patched/arch/s390/kernel/head31.S
--- linux-2.6/arch/s390/kernel/head31.S	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head31.S	2007-02-21 10:47:34.000000000 +0100
@@ -148,20 +148,9 @@ startup_continue:
 .Lstartup_init:
 	    .long startup_init
 
-	.globl ipl_schib
-ipl_schib:
-	.rept 13
-	.long 0
-	.endr
-
-	.globl ipl_flags
-ipl_flags:
-	.long 0
-	.globl ipl_devno
-ipl_devno:
-	.word 0
-
 	.org	0x12000
+	.globl	_ehead
+_ehead:
 #ifdef CONFIG_SHARED_KERNEL
 	.org	0x100000
 #endif
diff -urpN linux-2.6/arch/s390/kernel/head64.S linux-2.6-patched/arch/s390/kernel/head64.S
--- linux-2.6/arch/s390/kernel/head64.S	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head64.S	2007-02-21 10:47:34.000000000 +0100
@@ -154,21 +154,9 @@ startup_continue:
 .Lparmaddr:
 	.quad	PARMAREA
 
-	.globl	ipl_schib
-ipl_schib:
-	.rept 13
-	.long 0
-	.endr
-
-	.globl	ipl_flags
-ipl_flags:
-	.long	0
-	.globl	ipl_devno
-ipl_devno:
-	.word 0
-
 	.org	0x12000
-
+	.globl	_ehead
+_ehead:
 #ifdef CONFIG_SHARED_KERNEL
 	.org	0x100000
 #endif
diff -urpN linux-2.6/arch/s390/kernel/ipl.c linux-2.6-patched/arch/s390/kernel/ipl.c
--- linux-2.6/arch/s390/kernel/ipl.c	2007-02-21 10:47:33.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ipl.c	2007-02-21 10:47:34.000000000 +0100
@@ -43,6 +43,13 @@ enum ipl_type {
 #define IPL_FCP_STR	 "fcp"
 #define IPL_NSS_STR	 "nss"
 
+/*
+ * Must be in data section since the bss section
+ * is not cleared when these are accessed.
+ */
+u16 ipl_devno __attribute__((__section__(".data"))) = 0;
+u32 ipl_flags __attribute__((__section__(".data"))) = 0;
+
 static char *ipl_type_str(enum ipl_type type)
 {
 	switch (type) {
diff -urpN linux-2.6/arch/s390/kernel/setup.c linux-2.6-patched/arch/s390/kernel/setup.c
--- linux-2.6/arch/s390/kernel/setup.c	2007-02-21 10:47:32.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/setup.c	2007-02-21 10:47:34.000000000 +0100
@@ -690,9 +690,14 @@ setup_memory(void)
 	psw_set_key(PAGE_DEFAULT_KEY);
 
 	free_bootmem_with_active_regions(0, max_pfn);
-	reserve_bootmem(0, PFN_PHYS(start_pfn));
 
 	/*
+	 * Reserve memory used for lowcore/command line/kernel image.
+	 */
+	reserve_bootmem(0, (unsigned long)_ehead);
+	reserve_bootmem((unsigned long)_stext,
+			PFN_PHYS(start_pfn) - (unsigned long)_stext);
+	/*
 	 * Reserve the bootmem bitmap itself as well. We do this in two
 	 * steps (first step was init_bootmem()) because this catches
 	 * the (very unlikely) case of us accidentally initializing the
diff -urpN linux-2.6/drivers/s390/cio/cio.c linux-2.6-patched/drivers/s390/cio/cio.c
--- linux-2.6/drivers/s390/cio/cio.c	2007-02-21 10:47:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/cio.c	2007-02-21 10:47:34.000000000 +0100
@@ -1048,7 +1048,7 @@ void reipl_ccw_dev(struct ccw_dev_id *de
 	do_reipl_asm(*((__u32*)&schid));
 }
 
-extern struct schib ipl_schib;
+static struct schib __initdata ipl_schib;
 
 /*
  * ipl_save_parameters gets called very early. It is not allowed to access
diff -urpN linux-2.6/include/asm-s390/sections.h linux-2.6-patched/include/asm-s390/sections.h
--- linux-2.6/include/asm-s390/sections.h	2007-02-21 10:47:14.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/sections.h	2007-02-21 10:47:34.000000000 +0100
@@ -3,6 +3,6 @@
 
 #include <asm-generic/sections.h>
 
-extern char _eshared[];
+extern char _eshared[], _ehead[];
 
 #endif
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

