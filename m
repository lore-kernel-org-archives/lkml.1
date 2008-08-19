Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYHSUDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYHSUDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYHSUDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:03:14 -0400
Received: from gw.goop.org ([64.81.55.164]:38790 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYHSUDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:03:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 3] add phys_addr_t for holding physical addresses
X-Mercurial-Node: 73196c9129c7298f24288d5fea4cecab1f4b74fe
Message-Id: <73196c9129c7298f2428.1219176170@localhost>
In-Reply-To: <patchbomb.1219176169@localhost>
Date: Tue, 19 Aug 2008 13:02:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ehabkost@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
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

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
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
diff --git a/arch/powerpc/include/asm/types.h b/arch/powerpc/include/asm/types.h
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -938,6 +938,9 @@
 	  has the cost of more pagetable lookup overhead, and also
 	  consumes more pagetable space per process.
 
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool X86_64 || X86_PAE
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
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
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -79,7 +79,6 @@
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef struct page *pgtable_t;
 
diff --git a/include/linux/types.h b/include/linux/types.h
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
diff --git a/mm/Kconfig b/mm/Kconfig
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -187,6 +187,9 @@
 	help
 	  This option allows memory and IO resources to be 64 bit.
 
+config PHYS_ADDR_T_64BIT
+	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
+
 config ZONE_DMA_FLAG
 	int
 	default "0" if !ZONE_DMA


