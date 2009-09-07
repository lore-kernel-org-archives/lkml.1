Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbZIGDK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbZIGDK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZIGDKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:10:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60830 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758772AbZIGDKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:10:22 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH] microblaze: Cleanup linker script using new linker script macros.
Date: Sun,  6 Sep 2009 23:10:10 -0400
Message-Id: <1252293010-13038-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasn't able to further clean up the linker script using the
INIT_DATA_SECTION macro because of the FIXME comment for the
.init.ramfs section; when that is resolved we should convert
microblaze to use INIT_DATA_SECTION.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/microblaze/kernel/vmlinux.lds.S |   39 +++++++---------------------------
 1 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
index d34d38d..5e95ee0 100644
--- a/arch/microblaze/kernel/vmlinux.lds.S
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -13,6 +13,8 @@ OUTPUT_ARCH(microblaze)
 ENTRY(_start)
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
+#include <asm/thread_info.h>
 
 jiffies = jiffies_64 + 4;
 
@@ -39,12 +41,7 @@ SECTIONS {
 
 	. = ALIGN(16);
 	RODATA
-	. = ALIGN(16);
-	__ex_table : {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 
 	/*
 	 * sdata2 section can go anywhere, but must be word aligned
@@ -61,12 +58,7 @@ SECTIONS {
 	}
 
 	_sdata = . ;
-	.data ALIGN (4096) : { /* page aligned when MMU used - origin 0x4 */
-		DATA_DATA
-		CONSTRUCTORS
-	}
-	. = ALIGN(32);
-	.data.cacheline_aligned : { *(.data.cacheline_aligned) }
+	RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
 	_edata = . ;
 
 	/* Reserve some low RAM for r0 based memory references */
@@ -74,10 +66,6 @@ SECTIONS {
 	r0_ram = . ;
 	. = . +  4096;	/* a page should be enough */
 
-	/* The initial task */
-	. = ALIGN(8192);
-	.data.init_task : { *(.data.init_task) }
-
 	/* Under the microblaze ABI, .sdata and .sbss must be contiguous */
 	. = ALIGN(8);
 	.sdata : {
@@ -96,12 +84,7 @@ SECTIONS {
 
 	__init_begin = .;
 
-	. = ALIGN(4096);
-	.init.text : {
-		_sinittext = . ;
-		INIT_TEXT
-		_einittext = .;
-	}
+	INIT_TEXT_SECTION(PAGE_SIZE)
 
 	.init.data : {
 		INIT_DATA
@@ -115,21 +98,15 @@ SECTIONS {
 	}
 
 	.init.setup : {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
+		INIT_SETUP(0)
 	}
 
 	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
+		INIT_CALLS
 	}
 
 	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
+		CON_INITCALL
 	}
 
 	SECURITY_INIT
-- 
1.6.3.3

