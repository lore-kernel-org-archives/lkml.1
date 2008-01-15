Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYAONhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYAONhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYAONg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:36:57 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:41613 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYAONg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:36:56 -0500
Date: Tue, 15 Jan 2008 14:36:24 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Yuusei KUWANA <kuwana@nyanyan.to>
Subject: [PATCH] CRIS v10: vmlinux.lds.S Fix kernel oops on boot and use common defines
Message-ID: <20080115133624.GD3912@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Move alignment to page size of init data outside ifdef for BLK_DEV_INITRD.
  The reservation up to page size of memory after init data was previously
  not done if BLK_DEV_INITRD was undefined.
  This caused a kernel oops when init memory pages were freed after startup,
  data placed in the same page as the last init memory would also be freed
  and reused, with disastrous results.

- Use macros for initcalls and .text sections.

- Replace hardcoded page size constant with PAGE_SIZE define.

- Change include/asm-cris/page.h to use the _AC macro to instead
  of testing __ASSEMBLY__.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---

NOTE: This patch supercedes
arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
by Yuusei KUWANA <kuwana@nyanyan.to> in the -mm tree.

That patch only restricts which sections are counted as init memory,
and does not solve the underlying problem (that memory that is not part
of init data can be freed)

 arch/cris/arch-v10/vmlinux.lds.S |   33 +++++++++++++++------------------
 include/asm-cris/page.h          |    7 ++-----
 2 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/cris/arch-v10/vmlinux.lds.S b/arch/cris/arch-v10/vmlinux.lds.S
index 9859d49..97a7876 100644
--- a/arch/cris/arch-v10/vmlinux.lds.S
+++ b/arch/cris/arch-v10/vmlinux.lds.S
@@ -9,7 +9,8 @@
  */	
 
 #include <asm-generic/vmlinux.lds.h>
-		
+#include <asm/page.h>
+
 jiffies = jiffies_64;
 SECTIONS
 {
@@ -23,7 +24,7 @@ SECTIONS
 	_stext = .;
 	__stext = .;
 	.text : {
-		*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		*(.fixup)
@@ -49,10 +50,10 @@ SECTIONS
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
 
-	. = ALIGN(8192);              /* init_task and stack, must be aligned */
+	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned */
   	.data.init_task : { *(.data.init_task) }
 
-  	. = ALIGN(8192);              /* Init code and data */
+	. = ALIGN(PAGE_SIZE);	/* Init code and data */
   	__init_begin = .;
 	.init.text : { 
 		   _sinittext = .;
@@ -66,13 +67,7 @@ SECTIONS
   	__setup_end = .;
   	.initcall.init : {
 		__initcall_start = .;
-		*(.initcall1.init);
-		*(.initcall2.init);
-		*(.initcall3.init);
-		*(.initcall4.init);
-		*(.initcall5.init);
-		*(.initcall6.init);
-		*(.initcall7.init);
+		INITCALLS
 		__initcall_end = .;	
 	}
 
@@ -88,16 +83,18 @@ SECTIONS
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
-		/* We fill to the next page, so we can discard all init
-		   pages without needing to consider what payload might be
-		   appended to the kernel image.  */
-		FILL (0); 
-		. = ALIGN (8192);
 	}
 #endif
-	
 	__vmlinux_end = .;            /* last address of the physical file */
-  	__init_end = .;
+
+	/*
+	 * We fill to the next page, so we can discard all init
+	 * pages without needing to consider what payload might be
+	 * appended to the kernel image.
+	 */
+	. = ALIGN(PAGE_SIZE);
+
+	__init_end = .;
 
 	__data_end = . ;              /* Move to _edata ? */
 	__bss_start = .;              /* BSS */
diff --git a/include/asm-cris/page.h b/include/asm-cris/page.h
index 0648e31..b84353e 100644
--- a/include/asm-cris/page.h
+++ b/include/asm-cris/page.h
@@ -4,14 +4,11 @@
 #ifdef __KERNEL__
 
 #include <asm/arch/page.h>
+#include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	13
-#ifndef __ASSEMBLY__
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#endif
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #define clear_page(page)        memset((void *)(page), 0, PAGE_SIZE)
-- 
1.5.3.6.970.gd25430


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
