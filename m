Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZGaVCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZGaVCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZGaVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:02:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54582 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbZGaVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:02:03 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Subject: [PATCH 3/3] mips: clean up linker script using new linker script macros.
Date: Fri, 31 Jul 2009 16:58:19 -0400
Message-Id: <1249073899-30145-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073899-30145-1-git-send-email-tabbott@ksplice.com>
References: <1249073899-30145-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

This patch results in fewer output sections and in some data being
reordered, but should have no functional impact.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/vmlinux.lds.S |   86 ++++------------------------------------
 1 files changed, 8 insertions(+), 78 deletions(-)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 6bfdb2e..a6d2c7a 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -43,13 +43,7 @@ SECTIONS
 	} :text = 0
 	_etext = .;	/* End of text section */
 
-	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 
 	/* Exception table for data bus errors */
 	__dbe_table : {
@@ -66,20 +60,10 @@ SECTIONS
 	/* writeable */
 	.data : {	/* Data */
 		. = . + DATAOFFSET;		/* for CONFIG_MAPPED_KERNEL */
-		/*
-		 * This ALIGN is needed as a workaround for a bug a
-		 * gcc bug upto 4.1 which limits the maximum alignment
-		 * to at most 32kB and results in the following
-		 * warning:
-		 *
-		 *  CC      arch/mips/kernel/init_task.o
-		 * arch/mips/kernel/init_task.c:30: warning: alignment
-		 * of ‘init_thread_union’ is greater than maximum
-		 * object file alignment.  Using 32768
-		 */
-		. = ALIGN(PAGE_SIZE);
-		*(.data.init_task)
 
+		INIT_TASK_DATA(PAGE_SIZE)
+		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		DATA_DATA
 		CONSTRUCTORS
 	}
@@ -96,51 +80,13 @@ SECTIONS
 	.sdata : {
 		*(.sdata)
 	}
-
-	. = ALIGN(PAGE_SIZE);
-	.data_nosave : {
-		__nosave_begin = .;
-		*(.data.nosave)
-	}
-	. = ALIGN(PAGE_SIZE);
-	__nosave_end = .;
-
-	. = ALIGN(1 << CONFIG_MIPS_L1_CACHE_SHIFT);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
 	_edata =  .;			/* End of data section */
 
 	/* will be freed after init */
 	. = ALIGN(PAGE_SIZE);		/* Init code and data */
 	__init_begin = .;
-	.init.text : {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-	.init.data : {
-		INIT_DATA
-	}
-	. = ALIGN(16);
-	.init.setup : {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-
-	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-	SECURITY_INIT
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
 
 	/* .exit.text is discarded at runtime, not link time, to deal with
 	 * references from .rodata
@@ -151,29 +97,13 @@ SECTIONS
 	.exit.data : {
 		EXIT_DATA
 	}
-#if defined(CONFIG_BLK_DEV_INITRD)
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
+
 	PERCPU(PAGE_SIZE)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
 
-	__bss_start = .;	/* BSS */
-	.sbss  : {
-		*(.sbss)
-		*(.scommon)
-	}
-	.bss : {
-		*(.bss)
-		*(COMMON)
-	}
-	__bss_stop = .;
+	BSS_SECTION(0, 0, 0)
 
 	_end = . ;
 
-- 
1.6.3.3

