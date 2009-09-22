Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZIVOZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZIVOZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZIVOY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:24:59 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57479 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943AbZIVOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:24:58 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 11/13] um: Clean up linker script using standard macros.
Date: Tue, 22 Sep 2009 10:22:25 -0400
Message-Id: <1253629347-23119-12-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/um/include/asm/common.lds.S |   29 ++++++-----------------------
 arch/um/kernel/dyn.lds.S         |    9 ++-------
 arch/um/kernel/uml.lds.S         |   26 ++++++--------------------
 3 files changed, 14 insertions(+), 50 deletions(-)

diff --git a/arch/um/include/asm/common.lds.S b/arch/um/include/asm/common.lds.S
index 37ecc55..ac55b9e 100644
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
@@ -118,8 +103,6 @@
 
    . = ALIGN(4096);
   .init.ramfs : {
-	__initramfs_start = .;
-	*(.init.ramfs)
-	__initramfs_end = .;
+	INIT_RAM_FS
   }
 
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 715a188..7fcad58 100644
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
index 2ebd397..e7a6cca 100644
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

