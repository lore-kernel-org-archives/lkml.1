Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYHKTkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYHKTkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYHKTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:39:41 -0400
Received: from gw.goop.org ([64.81.55.164]:58124 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbYHKTjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:39:40 -0400
Message-ID: <48A0954E.20400@goop.org>
Date: Mon, 11 Aug 2008 12:38:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ehabkost@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] add phys_addr_t for holding physical addresses
References: <489B6B40.5050705@goop.org>	<20080807145648.ab3dfa90.akpm@linux-foundation.org>	<489B72C3.30603@goop.org>	<20080807162741.8dfcd336.akpm@linux-foundation.org>	<489B8908.2010007@goop.org> <20080807170617.79ca3ce7.akpm@linux-foundation.org>
In-Reply-To: <20080807170617.79ca3ce7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a kernel-wide "phys_addr_t" which is guaranteed to be able to hold
any physical address.  By default it equals the word size of the
architecture, but a 32-bit architecture can set ARCH_PHYS_ADDR_T_64BIT
if it needs a 64-bit phys_addr_t.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
diff -r 4909b40dbdc5 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig	Fri Aug 08 13:40:52 2008 -0700
+++ b/arch/powerpc/Kconfig	Mon Aug 11 10:32:52 2008 -0700
@@ -21,6 +21,9 @@
 
 config PPC_MERGE
 	def_bool y
+
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool PPC64 || PHYS_64BIT
 
 config MMU
 	bool
diff -r 4909b40dbdc5 arch/x86/Kconfig
--- a/arch/x86/Kconfig	Fri Aug 08 13:40:52 2008 -0700
+++ b/arch/x86/Kconfig	Mon Aug 11 10:32:53 2008 -0700
@@ -1002,6 +1002,9 @@
 	  has the cost of more pagetable lookup overhead, and also
 	  consumes more pagetable space per process.
 
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool X86_64 || X86_PAE
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
diff -r 4909b40dbdc5 include/asm-powerpc/types.h
--- a/include/asm-powerpc/types.h	Fri Aug 08 13:40:52 2008 -0700
+++ b/include/asm-powerpc/types.h	Mon Aug 11 10:32:53 2008 -0700
@@ -48,13 +48,6 @@
 
 typedef __vector128 vector128;
 
-/* Physical address used by some IO functions */
-#if defined(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)
-typedef u64 phys_addr_t;
-#else
-typedef u32 phys_addr_t;
-#endif
-
 #ifdef __powerpc64__
 typedef u64 dma_addr_t;
 #else
diff -r 4909b40dbdc5 include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h	Fri Aug 08 13:40:52 2008 -0700
+++ b/include/asm-x86/page_32.h	Mon Aug 11 10:32:53 2008 -0700
@@ -33,7 +33,6 @@
 typedef u64	pudval_t;
 typedef u64	pgdval_t;
 typedef u64	pgprotval_t;
-typedef u64	phys_addr_t;
 
 typedef union {
 	struct {
@@ -54,7 +53,6 @@
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef union {
 	pteval_t pte;
diff -r 4909b40dbdc5 include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h	Fri Aug 08 13:40:52 2008 -0700
+++ b/include/asm-x86/page_64.h	Mon Aug 11 10:32:53 2008 -0700
@@ -79,7 +79,6 @@
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef struct page *pgtable_t;
 
diff -r 4909b40dbdc5 include/linux/types.h
--- a/include/linux/types.h	Fri Aug 08 13:40:52 2008 -0700
+++ b/include/linux/types.h	Mon Aug 11 10:32:53 2008 -0700
@@ -197,6 +197,12 @@
 typedef u32 resource_size_t;
 #endif
 
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+typedef u64 phys_addr_t;
+#else
+typedef u32 phys_addr_t;
+#endif
+
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;
diff -r 4909b40dbdc5 mm/Kconfig
--- a/mm/Kconfig	Fri Aug 08 13:40:52 2008 -0700
+++ b/mm/Kconfig	Mon Aug 11 10:32:53 2008 -0700
@@ -190,6 +190,9 @@
 	help
 	  This option allows memory and IO resources to be 64 bit.
 
+config PHYS_ADDR_T_64BIT
+	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
+
 config ZONE_DMA_FLAG
 	int
 	default "0" if !ZONE_DMA


