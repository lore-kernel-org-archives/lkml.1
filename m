Return-Path: <linux-kernel-owner+w=401wt.eu-S1163444AbXD1SQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163444AbXD1SQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161155AbXD1SQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:16:11 -0400
Received: from ns.suse.de ([195.135.220.2]:34416 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163287AbXD1Rwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:35 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [10/35] x86: adjust inclusion of asm/fixmap.h
Message-Id: <20070428175234.7ABF3151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Move inclusion of asm/fixmap.h to where it is really used rather than
where it may have been used long ago (requires a few other adjustments
to includes due to previous implicit dependencies).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/genapic.c      |    1 +
 arch/x86_64/kernel/genapic_flat.c |    1 +
 include/asm-i386/hpet.h           |    2 --
 include/asm-i386/kexec.h          |    5 -----
 include/asm-i386/pgalloc.h        |    1 -
 include/asm-i386/smp.h            |    7 ++-----
 include/asm-x86_64/ipi.h          |    4 +---
 include/asm-x86_64/pgalloc.h      |    1 -
 include/asm-x86_64/pgtable.h      |    1 -
 include/asm-x86_64/smp.h          |    3 +--
 10 files changed, 6 insertions(+), 20 deletions(-)

Index: linux/arch/x86_64/kernel/genapic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic.c
+++ linux/arch/x86_64/kernel/genapic.c
@@ -18,6 +18,7 @@
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
+#include <asm/genapic.h>
 
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
Index: linux/arch/x86_64/kernel/genapic_flat.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic_flat.c
+++ linux/arch/x86_64/kernel/genapic_flat.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
+#include <asm/genapic.h>
 
 static cpumask_t flat_target_cpus(void)
 {
Index: linux/include/asm-i386/hpet.h
===================================================================
--- linux.orig/include/asm-i386/hpet.h
+++ linux/include/asm-i386/hpet.h
@@ -28,8 +28,6 @@
 
 #include <linux/timex.h>
 
-#include <asm/fixmap.h>
-
 /*
  * Documentation on HPET can be found at:
  *      http://www.intel.com/ial/home/sp/pcmmspec.htm
Index: linux/include/asm-i386/kexec.h
===================================================================
--- linux.orig/include/asm-i386/kexec.h
+++ linux/include/asm-i386/kexec.h
@@ -21,7 +21,6 @@
 
 #ifndef __ASSEMBLY__
 
-#include <asm/fixmap.h>
 #include <asm/ptrace.h>
 #include <asm/string.h>
 
@@ -29,10 +28,6 @@
  * KEXEC_SOURCE_MEMORY_LIMIT maximum page get_free_page can return.
  * I.e. Maximum page that is mapped directly into kernel memory,
  * and kmap is not required.
- *
- * Someone correct me if FIXADDR_START - PAGEOFFSET is not the correct
- * calculation for the amount of memory directly mappable into the
- * kernel memory space.
  */
 
 /* Maximum physical address we can use pages from */
Index: linux/include/asm-i386/pgalloc.h
===================================================================
--- linux.orig/include/asm-i386/pgalloc.h
+++ linux/include/asm-i386/pgalloc.h
@@ -1,7 +1,6 @@
 #ifndef _I386_PGALLOC_H
 #define _I386_PGALLOC_H
 
-#include <asm/fixmap.h>
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 
Index: linux/include/asm-i386/smp.h
===================================================================
--- linux.orig/include/asm-i386/smp.h
+++ linux/include/asm-i386/smp.h
@@ -11,16 +11,13 @@
 #include <asm/pda.h>
 #endif
 
-#ifdef CONFIG_X86_LOCAL_APIC
-#ifndef __ASSEMBLY__
-#include <asm/fixmap.h>
+#if defined(CONFIG_X86_LOCAL_APIC) && !defined(__ASSEMBLY__)
 #include <asm/bitops.h>
 #include <asm/mpspec.h>
+#include <asm/apic.h>
 #ifdef CONFIG_X86_IO_APIC
 #include <asm/io_apic.h>
 #endif
-#include <asm/apic.h>
-#endif
 #endif
 
 #define BAD_APICID 0xFFu
Index: linux/include/asm-x86_64/ipi.h
===================================================================
--- linux.orig/include/asm-x86_64/ipi.h
+++ linux/include/asm-x86_64/ipi.h
@@ -18,10 +18,8 @@
  * Subject to the GNU Public License, v.2
  */
 
-#include <asm/fixmap.h>
 #include <asm/hw_irq.h>
-#include <asm/apicdef.h>
-#include <asm/genapic.h>
+#include <asm/apic.h>
 
 /*
  * the following functions deal with sending IPIs between CPUs.
Index: linux/include/asm-x86_64/pgalloc.h
===================================================================
--- linux.orig/include/asm-x86_64/pgalloc.h
+++ linux/include/asm-x86_64/pgalloc.h
@@ -1,7 +1,6 @@
 #ifndef _X86_64_PGALLOC_H
 #define _X86_64_PGALLOC_H
 
-#include <asm/fixmap.h>
 #include <asm/pda.h>
 #include <linux/threads.h>
 #include <linux/mm.h>
Index: linux/include/asm-x86_64/pgtable.h
===================================================================
--- linux.orig/include/asm-x86_64/pgtable.h
+++ linux/include/asm-x86_64/pgtable.h
@@ -6,7 +6,6 @@
  * the x86-64 page table tree.
  */
 #include <asm/processor.h>
-#include <asm/fixmap.h>
 #include <asm/bitops.h>
 #include <linux/threads.h>
 #include <asm/pda.h>
Index: linux/include/asm-x86_64/smp.h
===================================================================
--- linux.orig/include/asm-x86_64/smp.h
+++ linux/include/asm-x86_64/smp.h
@@ -10,10 +10,9 @@
 #include <linux/init.h>
 extern int disable_apic;
 
-#include <asm/fixmap.h>
 #include <asm/mpspec.h>
-#include <asm/io_apic.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/thread_info.h>
 
 #ifdef CONFIG_SMP
