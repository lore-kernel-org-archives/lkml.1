Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbZIPUlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbZIPUlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbZIPUlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:41:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45737 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760041AbZIPUlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:41:02 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Nelson Elhage <nelhage@ksplice.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 2/2] arm: Clean up linker script using new linker script macros.
Date: Wed, 16 Sep 2009 16:40:06 -0400
Message-Id: <1253133606-24918-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253133606-24918-1-git-send-email-tabbott@ksplice.com>
References: <1253133606-24918-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

This patch is mostly a straightforward translation. The primary side
effect to the resulting vmlinux should be to increase the alignment on
the initramfs to the standard PAGE_SIZE from 32 bytes.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/arm/kernel/vmlinux.lds.S |   78 ++++++++++++-----------------------------
 1 files changed, 23 insertions(+), 55 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index d3fbd98..35d4a20 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -40,43 +40,31 @@ SECTIONS
 		__tagtable_begin = .;
 			*(.taglist.init)
 		__tagtable_end = .;
-		. = ALIGN(16);
-		__setup_start = .;
-			*(.init.setup)
-		__setup_end = .;
+
+		INIT_SETUP(16)
+
 		__early_begin = .;
 			*(.early_param.init)
 		__early_end = .;
-		__initcall_start = .;
-			INITCALLS
-		__initcall_end = .;
-		__con_initcall_start = .;
-			*(.con_initcall.init)
-		__con_initcall_end = .;
-		__security_initcall_start = .;
-			*(.security_initcall.init)
-		__security_initcall_end = .;
-#ifdef CONFIG_BLK_DEV_INITRD
-		. = ALIGN(32);
-		__initramfs_start = .;
-			usr/built-in.o(.init.ramfs)
-		__initramfs_end = .;
-#endif
-		. = ALIGN(PAGE_SIZE);
-		__per_cpu_load = .;
-		__per_cpu_start = .;
-			*(.data.percpu.page_aligned)
-			*(.data.percpu)
-			*(.data.percpu.shared_aligned)
-		__per_cpu_end = .;
+
+		INIT_CALLS
+		CON_INITCALL
+		SECURITY_INITCALL
+		INIT_RAM_FS
+
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
 		INIT_DATA
-		. = ALIGN(PAGE_SIZE);
-		__init_end = .;
 #endif
 	}
 
+	PERCPU(PAGE_SIZE)
+
+#ifndef CONFIG_XIP_KERNEL
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;
+#endif
+
 	/DISCARD/ : {			/* Exit code and data		*/
 		EXIT_TEXT
 		EXIT_DATA
@@ -155,7 +143,7 @@ SECTIONS
 		 * first, the init task union, aligned
 		 * to an 8192 byte boundary.
 		 */
-		*(.data.init_task)
+		INIT_TASK_DATA(THREAD_SIZE)
 
 #ifdef CONFIG_XIP_KERNEL
 		. = ALIGN(PAGE_SIZE);
@@ -165,17 +153,8 @@ SECTIONS
 		__init_end = .;
 #endif
 
-		. = ALIGN(PAGE_SIZE);
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-
-		/*
-		 * then the cacheline aligned data
-		 */
-		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(32)
 
 		/*
 		 * The exception fixup table (might need resorting at runtime)
@@ -197,21 +176,10 @@ SECTIONS
 	}
 	_edata_loc = __data_loc + SIZEOF(.data);
 
-	.bss : {
-		__bss_start = .;	/* BSS				*/
-		*(.bss)
-		*(COMMON)
-		__bss_stop = .;
-		_end = .;
-	}
-					/* Stabs debugging sections.	*/
-	.stab 0 : { *(.stab) }
-	.stabstr 0 : { *(.stabstr) }
-	.stab.excl 0 : { *(.stab.excl) }
-	.stab.exclstr 0 : { *(.stab.exclstr) }
-	.stab.index 0 : { *(.stab.index) }
-	.stab.indexstr 0 : { *(.stab.indexstr) }
-	.comment 0 : { *(.comment) }
+	BSS_SECTION(0, 0, 0)
+	_end = .;
+
+	STABS_DEBUG
 }
 
 /*
-- 
1.6.3.3

