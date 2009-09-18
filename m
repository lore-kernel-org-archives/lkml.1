Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbZIRUkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbZIRUkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbZIRUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:40:06 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65082 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035AbZIRUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:40:04 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linux-parisc@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 1/2] parisc: Clean up linker script using new linker script macros.
Date: Fri, 18 Sep 2009 16:34:37 -0400
Message-Id: <1253306078-7066-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253306078-7066-1-git-send-email-tabbott@ksplice.com>
References: <1253306078-7066-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has the (likely harmless) side effect of moving
.data.init_task inside the _edata.

It also changes the alignment of .data.init_task from 16384 to
THREAD_SIZE, which can in some configurations be larger than 16384.  I
believe that this change fixes a potential bug on those
configurations.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/parisc/kernel/vmlinux.lds.S |   79 ++------------------------------------
 1 files changed, 4 insertions(+), 75 deletions(-)

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index aea1784..3fd66d9 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -77,13 +77,7 @@ SECTIONS
 	 */
 	. = ALIGN(PAGE_SIZE);
 	data_start = .;
-	. = ALIGN(16);
-	/* Exception table */
-	__ex_table : {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 
 	NOTES
 
@@ -94,23 +88,8 @@ SECTIONS
 		__stop___unwind = .;
 	}
 
-	/* rarely changed data like cpu maps */
-	. = ALIGN(16);
-	.data.read_mostly : {
-		*(.data.read_mostly)
-	}
-
-	. = ALIGN(L1_CACHE_BYTES);
 	/* Data */
-	.data : {
-		DATA_DATA
-		CONSTRUCTORS
-	}
-
-	. = ALIGN(L1_CACHE_BYTES);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 
 	/* PA-RISC locks requires 16-byte alignment */
 	. = ALIGN(16);
@@ -118,17 +97,6 @@ SECTIONS
 		*(.data.lock_aligned)
 	}
 
-	/* nosave data is really only used for software suspend...it's here
-	 * just in case we ever implement it
-	 */
-	. = ALIGN(PAGE_SIZE);
-	__nosave_begin = .;
-	.data_nosave : {
-		*(.data.nosave)
-	}
-	. = ALIGN(PAGE_SIZE);
-	__nosave_end = .;
-
 	/* End of data section */
 	_edata = .;
 
@@ -147,14 +115,6 @@ SECTIONS
 	}
 	__bss_stop = .;
 
-
-	/* assembler code expects init_task to be 16k aligned */
-	. = ALIGN(16384);
-	/* init_task */
-	.data.init_task : {
-		*(.data.init_task)
-	}
-
 #ifdef CONFIG_64BIT
 	. = ALIGN(16);
 	/* Linkage tables */
@@ -172,31 +132,8 @@ SECTIONS
 	/* reserve space for interrupt stack by aligning __init* to 16k */
 	. = ALIGN(16384);
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
-	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-	SECURITY_INIT
+	INIT_TEXT_SECTION(16384)
+	INIT_DATA_SECTION(16)
 
 	/* alternate instruction replacement.  This is a mechanism x86 uses
 	 * to detect the CPU type and replace generic instruction sequences
@@ -222,14 +159,6 @@ SECTIONS
 	.exit.data : {
 		EXIT_DATA
 	}
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
 
 	PERCPU(PAGE_SIZE)
 	. = ALIGN(PAGE_SIZE);
-- 
1.6.3.3

