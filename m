Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYIKIcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYIKIcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYIKIbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:31:47 -0400
Received: from gw.goop.org ([64.81.55.164]:33258 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYIKIbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:31:46 -0400
Message-ID: <48C8D771.9020605@goop.org>
Date: Thu, 11 Sep 2008 01:31:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] add phys_addr_t for holding physical addresses
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
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
---
 arch/powerpc/Kconfig             |    3 +++
 arch/powerpc/include/asm/types.h |    7 -------
 arch/x86/Kconfig                 |    3 +++
 include/asm-x86/page_32.h        |    2 --
 include/asm-x86/page_64.h        |    1 -
 include/linux/types.h            |    6 ++++++
 mm/Kconfig                       |    3 +++
 7 files changed, 15 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -21,6 +21,9 @@
 
 config PPC_MERGE
 	def_bool y
+
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool PPC64 || PHYS_64BIT
 
 config MMU
 	bool
===================================================================
--- a/arch/powerpc/include/asm/types.h
+++ b/arch/powerpc/include/asm/types.h
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
===================================================================
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -992,6 +992,9 @@
 	  has the cost of more pagetable lookup overhead, and also
 	  consumes more pagetable space per process.
 
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool X86_64 || X86_PAE
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
===================================================================
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
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
===================================================================
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -79,7 +79,6 @@
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef struct page *pgtable_t;
 
===================================================================
--- a/include/linux/types.h
+++ b/include/linux/types.h
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
===================================================================
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -190,6 +190,9 @@
 	help
 	  This option allows memory and IO resources to be 64 bit.
 
+config PHYS_ADDR_T_64BIT
+	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
+
 config ZONE_DMA_FLAG
 	int
 	default "0" if !ZONE_DMA


