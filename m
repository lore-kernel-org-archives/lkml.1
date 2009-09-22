Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZIVOX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZIVOX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZIVOXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:23:24 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56397 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756595AbZIVOXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:23:16 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>, Chris Zankel <chris@zankel.net>
Subject: [PATCH 10/13] xtensa: Cleanup linker script using new linker script macros.
Date: Tue, 22 Sep 2009 10:22:24 -0400
Message-Id: <1253629347-23119-11-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/xtensa/kernel/vmlinux.lds.S |   75 +++++++-------------------------------
 1 files changed, 14 insertions(+), 61 deletions(-)

diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 921b6ff..9b52615 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
  */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
+#include <asm/thread_info.h>
 
 #include <variant/core.h>
 #include <platform/hardware.h>
@@ -107,41 +109,18 @@ SECTIONS
 
   .fixup   : { *(.fixup) }
 
-  . = ALIGN(16);
-
-  __ex_table : {
-    __start___ex_table = .;
-    *(__ex_table)
-    __stop___ex_table = .;
-  }
-
+  EXCEPTION_TABLE(16)
   /* Data section */
 
-  . = ALIGN(XCHAL_ICACHE_LINESIZE);
   _fdata = .;
-  .data :
-  {
-    DATA_DATA
-    CONSTRUCTORS
-    . = ALIGN(XCHAL_ICACHE_LINESIZE);
-    *(.data.cacheline_aligned)
-  }
-
+  RW_DATA_SECTION(XCHAL_ICACHE_LINESIZE, PAGE_SIZE, THREAD_SIZE)
   _edata = .;
 
-  /* The initial task */
-  . = ALIGN(8192);
-  .data.init_task : { *(.data.init_task) }
-
   /* Initialization code and data: */
 
-  . = ALIGN(1 << 12);
+  . = ALIGN(PAGE_SIZE);
   __init_begin = .;
-  .init.text : {
-  	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
+  INIT_TEXT_SECTION(PAGE_SIZE)
 
   .init.data :
   {
@@ -168,36 +147,15 @@ SECTIONS
 		   .DebugInterruptVector.text);
   
     __boot_reloc_table_end = ABSOLUTE(.) ;
-  }
 
-  . = ALIGN(XCHAL_ICACHE_LINESIZE);
-
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
-
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
+    INIT_SETUP(XCHAL_ICACHE_LINESIZE)
+    INIT_CALLS
+    CON_INITCALL
+    SECURITY_INITCALL
+    INIT_RAM_FS
   }
-  __initcall_end = .;
-
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
-
-  SECURITY_INIT
-
-
-#ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(4096);
-  __initramfs_start =.;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
-#endif
-
-  PERCPU(4096)
 
+  PERCPU(PAGE_SIZE)
 
   /* We need this dummy segment here */
 
@@ -252,16 +210,11 @@ SECTIONS
 		  .DoubleExceptionVector.literal)
 
   . = (LOADADDR( .DoubleExceptionVector.text ) + SIZEOF( .DoubleExceptionVector.text ) + 3) & ~ 3;
-  . = ALIGN(1 << 12);
+  . = ALIGN(PAGE_SIZE);
 
   __init_end = .;
 
-  . = ALIGN(8192);
-
-  /* BSS section */
-  _bss_start = .;
-  .bss : { *(.bss.page_aligned) *(.bss) }
-  _bss_end = .;
+  BSS_SECTION(0, 8192, 0)
 
   _end = .;
 
-- 
1.6.3.3

