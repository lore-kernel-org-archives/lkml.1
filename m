Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZGaVDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZGaVDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZGaVDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:03:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54671 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbZGaVDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:03:09 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] frv: clean up linker script using new linker script macros.
Date: Fri, 31 Jul 2009 16:57:44 -0400
Message-Id: <1249073864-29975-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073864-29975-1-git-send-email-tabbott@ksplice.com>
References: <1249073864-29975-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

This is largely a straightforward conversion. The patch results in
fewer output sections, and some data being reordered, but should have
no functional impact.

Also, note that this patch moves some data (namely, init_task and
cacheline-aligned) inside [_sdata,_edata].

Because frv already builds using -ffunction-sections -fdata-sections,
we can't use BSS_SECTION or RW_DATA_SECTION yet, since they do not
currently include the required .bss.* and .data.* sections.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/vmlinux.lds.S |   64 +++++-----------------------------------
 1 files changed, 8 insertions(+), 56 deletions(-)

diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index be7a33f..7775d49 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -35,45 +35,13 @@ SECTIONS
 #endif
   }
   _einittext = .;
-  .init.data : { INIT_DATA }
-
-  . = ALIGN(8);
-  __setup_start = .;
-  .setup.init : { KEEP(*(.init.setup)) }
-  __setup_end = .;
-
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
-  SECURITY_INIT
 
+  INIT_DATA_SECTION(8)
   PERCPU(4096)
 
-#ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(4096);
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
-#endif
-
-  . = ALIGN(THREAD_SIZE);
+  . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
-  /* put sections together that have massive alignment issues */
-  . = ALIGN(THREAD_SIZE);
-  .data.init_task : {
-	  /* init task record & stack */
-	  *(.data.init_task)
-  }
-
-  . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
   .trap : {
 	/* trap table management - read entry-table.S before modifying */
 	. = ALIGN(8192);
@@ -119,13 +87,12 @@ SECTIONS
 
 	}
 
-  . = ALIGN(8);		/* Exception table */
-  __start___ex_table = .;
-  __ex_table : { KEEP(*(__ex_table)) }
-  __stop___ex_table = .;
+  EXCEPTION_TABLE(8)
 
   _sdata = .;
   .data : {			/* Data */
+	INIT_TASK_DATA(THREAD_SIZE)
+	CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 	DATA_DATA
 	*(.data.*)
 	EXIT_DATA
@@ -154,24 +121,9 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __kernel_image_end = .;
 
-  /* Stabs debugging sections.  */
-  .stab 0 : { *(.stab) }
-  .stabstr 0 : { *(.stabstr) }
-  .stab.excl 0 : { *(.stab.excl) }
-  .stab.exclstr 0 : { *(.stab.exclstr) }
-  .stab.index 0 : { *(.stab.index) }
-  .stab.indexstr 0 : { *(.stab.indexstr) }
-
-  .debug_line		0 : { *(.debug_line) }
-  .debug_info		0 : { *(.debug_info) }
-  .debug_abbrev		0 : { *(.debug_abbrev) }
-  .debug_aranges	0 : { *(.debug_aranges) }
-  .debug_frame		0 : { *(.debug_frame) }
-  .debug_pubnames	0 : { *(.debug_pubnames) }
-  .debug_str		0 : { *(.debug_str) }
-  .debug_ranges		0 : { *(.debug_ranges) }
-
-  .comment 0 : { *(.comment) }
+  STABS_DEBUG
+  DWARF_DEBUG
+
 }
 
 __kernel_image_size_no_bss = __bss_start - __kernel_image_start;
-- 
1.6.3.3

