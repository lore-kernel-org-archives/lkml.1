Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbZIPQlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbZIPQlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759791AbZIPQlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:41:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38965 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759755AbZIPQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:41:07 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH v2] avr32: clean up linker script using standard macros.
Date: Wed, 16 Sep 2009 12:40:47 -0400
Message-Id: <1253119247-19174-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253119247-19174-1-git-send-email-tabbott@ksplice.com>
References: <1253119247-19174-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

As a side effect, this patch changes the .init.ramfs data to be
PAGE_SIZE-aligned, instead of 32-byte aligned.  Also, the init data is
moved into its own output sections rather than the .init output
section.

There should be no other changes to the resulting vmlinux as a result
of this patch.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/kernel/vmlinux.lds.S |   64 +++++---------------------------------
 1 files changed, 9 insertions(+), 55 deletions(-)

diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index c4b5665..9cd2bd9 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -39,30 +39,10 @@ SECTIONS
 		__tagtable_begin = .;
 			*(.taglist.init)
 		__tagtable_end = .;
-			INIT_DATA
-		. = ALIGN(16);
-		__setup_start = .;
-			*(.init.setup)
-		__setup_end = .;
-		. = ALIGN(4);
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
-			*(.init.ramfs)
-		__initramfs_end = .;
-#endif
-		. = ALIGN(PAGE_SIZE);
-		__init_end = .;
 	}
+	INIT_DATA_SECTION(16)
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;
 
 	.text		: AT(ADDR(.text) - LOAD_OFFSET) {
 		_evba = .;
@@ -78,34 +58,16 @@ SECTIONS
 		_etext = .;
 	} = 0xd703d703
 
-	. = ALIGN(4);
-	__ex_table	: AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
-
+	EXCEPTION_TABLE(4)
 	RODATA
 
-	. = ALIGN(THREAD_SIZE);
-
 	.data		: AT(ADDR(.data) - LOAD_OFFSET) {
 		_data = .;
 		_sdata = .;
-		/*
-		 * First, the init task union, aligned to an 8K boundary.
-		 */
-		*(.data.init_task)
 
-		/* Then, the page-aligned data */
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
-
-		/* Then, the cacheline aligned data */
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
-
-		/* And the rest... */
+		INIT_TASK_DATA(THREAD_SIZE)
+		PAGE_ALIGNED_DATA(PAGE_SIZE);
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 		*(.data.rel*)
 		DATA_DATA
 		CONSTRUCTORS
@@ -113,16 +75,8 @@ SECTIONS
 		_edata = .;
 	}
 
-
-	. = ALIGN(8);
-	.bss    	: AT(ADDR(.bss) - LOAD_OFFSET) {
-		__bss_start = .;
-		*(.bss)
-		*(COMMON)
-		. = ALIGN(8);
-		__bss_stop = .;
-		_end = .;
-	}
+	BSS_SECTION(0, 8, 8)
+	_end = .;
 
 	DWARF_DEBUG
 
-- 
1.6.3.3

