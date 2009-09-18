Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZIRT4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZIRT4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZIRT41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:56:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42979 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883AbZIRT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:56:25 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 2/3] frv: clean up linker script using new linker script macros.
Date: Fri, 18 Sep 2009 15:52:08 -0400
Message-Id: <1253303529-6342-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253303529-6342-1-git-send-email-tabbott@ksplice.com>
References: <1253303529-6342-1-git-send-email-tabbott@ksplice.com>
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
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/frv/kernel/vmlinux.lds.S |   61 +++++------------------------------------
 1 files changed, 7 insertions(+), 54 deletions(-)

diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index cfb4181..cbe811f 100644
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
@@ -154,22 +121,8 @@ SECTIONS
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
+  STABS_DEBUG
+  DWARF_DEBUG
 
   .comment 0 : { *(.comment) }
 
-- 
1.6.3.3

