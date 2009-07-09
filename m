Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbZGIOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbZGIOqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbZGIOq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:46:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48310 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758018AbZGIOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:46:26 -0400
Date: Thu, 9 Jul 2009 10:45:59 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: linux-kernel@vger.kernel.org
cc: Paul Mundt <lethal@linux-sh.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-sh@vger.kernel.org, Anders Kaseorg <andersk@ksplice.com>
Subject: [PATCH] sh: Clean up linker script using new linker script macros.
Message-ID: <alpine.DEB.1.10.0907082333190.6580@vinegar-pot.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the sh architecture to use the new linker script 
macros in include/asm-generic/vmlinux.lds.h.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/vmlinux.lds.S |   87 +++++------------------------------------
 1 files changed, 11 insertions(+), 76 deletions(-)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index f53c76a..7e833db 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -50,12 +50,7 @@ SECTIONS
 		_etext = .;		/* End of text section */
 	} = 0x0009
 
-	. = ALIGN(16);		/* Exception table */
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 
 	NOTES
 	RO_DATA(PAGE_SIZE)
@@ -71,69 +66,14 @@ SECTIONS
 		__uncached_end = .;
 	}
 
-	. = ALIGN(THREAD_SIZE);
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {		/* Data */
-		*(.data.init_task)
-
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
-
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.read_mostly)
-
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
-
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-
-		DATA_DATA
-		CONSTRUCTORS
-	}
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 
 	_edata = .;			/* End of data section */
 
 	. = ALIGN(PAGE_SIZE);		/* Init code and data */
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		__init_begin = .;
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { INIT_DATA }
-
-	. = ALIGN(16);
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-
-	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-
-	SECURITY_INIT
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
+	__init_begin = .;
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
 
 	. = ALIGN(4);
 	.machvec.init : AT(ADDR(.machvec.init) - LOAD_OFFSET) {
@@ -152,16 +92,11 @@ SECTIONS
 	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { EXIT_DATA }
 
 	. = ALIGN(PAGE_SIZE);
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		__init_end = .;
-		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
-		*(.bss)
-		*(COMMON)
-		. = ALIGN(4);
-		_ebss = .;			/* uClinux MTD sucks */
-		_end = . ;
-	}
+	__init_end = .;
+	BSS(PAGE_SIZE)
+	. = ALIGN(4);
+	_ebss = .;			/* uClinux MTD sucks */
+	_end = . ;
 
 	/*
 	 * When something in the kernel is NOT compiled as a module, the
@@ -170,7 +105,7 @@ SECTIONS
 	 * it's a module.
 	 */
 	/DISCARD/ : {
-		*(.exitcall.exit)
+		EXIT_CALL
 	}
 
 	STABS_DEBUG
-- 
1.6.3.3
