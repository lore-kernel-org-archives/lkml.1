Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZIVPSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZIVPSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZIVPSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:18:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57523 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbZIVPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:18:37 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH] powerpc: Cleanup linker script using new linker script macros.
Date: Tue, 22 Sep 2009 11:18:09 -0400
Message-Id: <1253632689-24173-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253632689-24173-1-git-send-email-tabbott@ksplice.com>
References: <1253632689-24173-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |   69 ++++++++-----------------------------
 1 files changed, 15 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 58da407..f564293 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -6,6 +6,7 @@
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
+#include <asm/thread_info.h>
 
 ENTRY(_stext)
 
@@ -71,12 +72,7 @@ SECTIONS
 	/* Read-only data */
 	RODATA
 
-	/* Exception & bug tables */
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(0)
 
 	NOTES :kernel :notes
 
@@ -93,12 +89,7 @@ SECTIONS
  */
 	. = ALIGN(PAGE_SIZE);
 	__init_begin = .;
-
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	} :kernel
+	INIT_TEXT_SECTION(PAGE_SIZE) :kernel
 
 	/* .exit.text is discarded at runtime, not link time,
 	 * to deal with references from __bug_table
@@ -122,23 +113,16 @@ SECTIONS
 #endif
 	}
 
-	. = ALIGN(16);
 	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
+		INIT_SETUP(16)
 	}
 
 	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-		}
+		INIT_CALLS
+	}
 
 	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
+		CON_INITCALL
 	}
 
 	SECURITY_INIT
@@ -169,14 +153,10 @@ SECTIONS
 		__stop___fw_ftr_fixup = .;
 	}
 #endif
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
 	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
+		INIT_RAM_FS
 	}
-#endif
+
 	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(8);
@@ -240,36 +220,24 @@ SECTIONS
 #endif
 
 	/* The initial task and kernel stack */
-#ifdef CONFIG_PPC32
-	. = ALIGN(8192);
-#else
-	. = ALIGN(16384);
-#endif
 	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
+		INIT_TASK_DATA(THREAD_SIZE)
 	}
 
-	. = ALIGN(PAGE_SIZE);
 	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
 	}
 
-	. = ALIGN(L1_CACHE_BYTES);
 	.data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		*(.data.cacheline_aligned)
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 	}
 
-	. = ALIGN(L1_CACHE_BYTES);
 	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
+		READ_MOSTLY_DATA(L1_CACHE_BYTES)
 	}
 
-	. = ALIGN(PAGE_SIZE);
 	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
+		NOSAVE_DATA
 	}
 
 	. = ALIGN(PAGE_SIZE);
@@ -280,14 +248,7 @@ SECTIONS
  * And finally the bss
  */
 
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		__bss_start = .;
-		*(.sbss) *(.scommon)
-		*(.dynbss)
-		*(.bss)
-		*(COMMON)
-		__bss_stop = .;
-	}
+	BSS_SECTION(0, 0, 0)
 
 	. = ALIGN(PAGE_SIZE);
 	_end = . ;
-- 
1.6.3.3

