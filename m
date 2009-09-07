Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbZIGDI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbZIGDI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbZIGDI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:08:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60584 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758721AbZIGDIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:08:55 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] um: Clean up linker script using standard macros.
Date: Sun,  6 Sep 2009 23:08:32 -0400
Message-Id: <1252292912-12838-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/um/include/asm/common.lds.S |   29 ++++++-----------------------
 arch/um/kernel/dyn.lds.S         |    9 ++-------
 arch/um/kernel/uml.lds.S         |   26 ++++++--------------------
 3 files changed, 14 insertions(+), 50 deletions(-)

diff --git a/arch/um/include/asm/common.lds.S b/arch/um/include/asm/common.lds.S
index cb02486..3e1ea07 100644
--- a/arch/um/include/asm/common.lds.S
+++ b/arch/um/include/asm/common.lds.S
@@ -16,11 +16,7 @@
 
   . = ALIGN(4096);
   .note : { *(.note.*) }
-  __ex_table : {
-	__start___ex_table = .;
-	*(__ex_table)
-	__stop___ex_table = .;
-  }
+  EXCEPTION_TABLE(0)
 
   BUG_TABLE
 
@@ -43,28 +39,17 @@
   }
 	
   .init.setup : {
-	__setup_start = .;
-	*(.init.setup)
-	__setup_end = .;
+	INIT_SETUP(0)
   }
 
-  . = ALIGN(32);
-  .data.percpu : {
-	__per_cpu_start = . ;
-	*(.data.percpu)
-	__per_cpu_end = . ;
-  }
+  PERCPU(32)
 	
   .initcall.init : {
-	__initcall_start = .;
-	INITCALLS
-	__initcall_end = .;
+	INIT_CALLS
   }
 
   .con_initcall.init : {
-	__con_initcall_start = .;
-	*(.con_initcall.init)
-	__con_initcall_end = .;
+	CON_INITCALL
   }
 
   .uml.initcall.init : {
@@ -118,9 +103,7 @@
 
    . = ALIGN(4096);
   .init.ramfs : {
-	__initramfs_start = .;
-	*(.init.ramfs)
-	__initramfs_end = .;
+	INIT_RAM_FS
   }
 
   /* Sections to be discarded */
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 9975e1a..9b8c26e 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -16,11 +16,7 @@ SECTIONS
   _text = .;
   _stext = .;
   __init_begin = .;
-  .init.text : {
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
+  INIT_TEXT_SECTION(PAGE_SIZE)
 
   . = ALIGN(PAGE_SIZE);
 
@@ -96,8 +92,7 @@ SECTIONS
   .init_array     : { *(.init_array) }
   .fini_array     : { *(.fini_array) }
   .data           : {
-    . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    INIT_TASK_DATA(KERNEL_STACK_SIZE)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
     DATA_DATA
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 11b8352..dd0890c 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -22,11 +22,7 @@ SECTIONS
   _text = .;
   _stext = .;
   __init_begin = .;
-  .init.text : {
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
+  INIT_TEXT_SECTION(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
 
   .text      :
@@ -52,8 +48,7 @@ SECTIONS
   init.data : { INIT_DATA }
   .data    :
   {
-    . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    INIT_TASK_DATA(KERNEL_STACK_SIZE)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
     DATA_DATA
@@ -81,19 +76,10 @@ SECTIONS
   _edata  =  .;
   PROVIDE (edata = .);
   . = ALIGN(PAGE_SIZE);
-  .sbss      :
-  {
-   __bss_start = .;
-   PROVIDE(_bss_start = .);
-   *(.sbss)
-   *(.scommon)
-  }
-  .bss       :
-  {
-   *(.dynbss)
-   *(.bss)
-   *(COMMON)
-  }
+  __bss_start = .;
+  PROVIDE(_bss_start = .);
+  SBSS(0)
+  BSS(0)
   _end = .;
   PROVIDE (end = .);
 
-- 
1.6.3.3

