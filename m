Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXBNH6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXBNH6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXBNH6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:58:40 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:51025
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXBNH6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:58:39 -0500
Message-Id: <45D2CF1C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 14 Feb 2007 07:58:04 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust inclusion of asm/fixmap.h
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move inclusion of asm/fixmap.h to where it is really used rather than
where it may have been used long ago (requires a few other adjustments
to includes due to previous implicit dependencies).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.20/arch/x86_64/kernel/genapic.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/arch/x86_64/kernel/genapic.c	2007-02-09 10:17:39.000000000 +0100
@@ -18,6 +18,7 @@
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
+#include <asm/genapic.h>
 
 #if defined(CONFIG_ACPI)
 #include <acpi/acpi_bus.h>
--- linux-2.6.20/arch/x86_64/kernel/genapic_cluster.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/arch/x86_64/kernel/genapic_cluster.c	2007-02-09 10:17:39.000000000 +0100
@@ -17,7 +17,7 @@
 #include <linux/init.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
-
+#include <asm/genapic.h>
 
 /*
  * Set up the logical destination ID.
--- linux-2.6.20/arch/x86_64/kernel/genapic_flat.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/arch/x86_64/kernel/genapic_flat.c	2007-02-09 10:17:39.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
+#include <asm/genapic.h>
 
 static cpumask_t flat_target_cpus(void)
 {
--- linux-2.6.20/include/asm-i386/hpet.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-i386/hpet.h	2007-02-09 10:17:39.000000000 +0100
@@ -28,8 +28,6 @@
 
 #include <linux/timex.h>
 
-#include <asm/fixmap.h>
-
 /*
  * Documentation on HPET can be found at:
  *      http://www.intel.com/ial/home/sp/pcmmspec.htm 
--- linux-2.6.20/include/asm-i386/kexec.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-i386/kexec.h	2007-02-09 10:17:39.000000000 +0100
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
--- linux-2.6.20/include/asm-i386/pgalloc.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-i386/pgalloc.h	2007-02-09 10:17:39.000000000 +0100
@@ -1,7 +1,6 @@
 #ifndef _I386_PGALLOC_H
 #define _I386_PGALLOC_H
 
-#include <asm/fixmap.h>
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 
--- linux-2.6.20/include/asm-i386/smp.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-i386/smp.h	2007-02-09 10:17:39.000000000 +0100
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
--- linux-2.6.20/include/asm-x86_64/ipi.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-x86_64/ipi.h	2007-02-09 10:17:39.000000000 +0100
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
--- linux-2.6.20/include/asm-x86_64/pgalloc.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-x86_64/pgalloc.h	2007-02-09 10:17:39.000000000 +0100
@@ -1,7 +1,6 @@
 #ifndef _X86_64_PGALLOC_H
 #define _X86_64_PGALLOC_H
 
-#include <asm/fixmap.h>
 #include <asm/pda.h>
 #include <linux/threads.h>
 #include <linux/mm.h>
--- linux-2.6.20/include/asm-x86_64/pgtable.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-x86_64/pgtable.h	2007-02-09 10:17:39.000000000 +0100
@@ -6,7 +6,6 @@
  * the x86-64 page table tree.
  */
 #include <asm/processor.h>
-#include <asm/fixmap.h>
 #include <asm/bitops.h>
 #include <linux/threads.h>
 #include <asm/pda.h>
--- linux-2.6.20/include/asm-x86_64/smp.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-x86-fixmap/include/asm-x86_64/smp.h	2007-02-09 10:17:39.000000000 +0100
@@ -9,10 +9,9 @@
 #include <linux/bitops.h>
 extern int disable_apic;
 
-#include <asm/fixmap.h>
 #include <asm/mpspec.h>
-#include <asm/io_apic.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/thread_info.h>
 
 #ifdef CONFIG_SMP


