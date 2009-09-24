Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZIXOle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZIXOle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZIXOld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:41:33 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35902 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbZIXOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:41:21 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Geoffrey Thomas <geofft@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: [PATCH v2 11/11] alpha: Clean up linker script using new linker script macros.
Date: Thu, 24 Sep 2009 10:36:26 -0400
Message-Id: <1253802986-8132-12-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253802986-8132-1-git-send-email-tabbott@ksplice.com>
References: <1253802986-8132-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geoffrey Thomas <geofft@ksplice.com>

Note that .data.page_aligned and .data.cacheline_aligned are now after
_data; it was probably a bug that they were before it.

Also, some explicit ALIGN(8)'s between various initcall sections were
removed; this should be harmless as the implicit alignment of
initcall_t was already 8.

Signed-off-by: Geoffrey Thomas <geofft@ksplice.com>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/vmlinux.lds.S |   90 ++++-----------------------------------
 1 files changed, 9 insertions(+), 81 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 82803df..2906665 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -32,84 +32,21 @@ SECTIONS
 	} :kernel
 
 	RODATA
-
-	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 
 	/* Will be freed after init */
-	. = ALIGN(PAGE_SIZE);
-	/* Init code and data */
-	__init_begin = .;
-	.init.text : {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-	.init.data : {
-		INIT_DATA
-	}
-
-	. = ALIGN(16);
-	.init.setup : {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-
-	. = ALIGN(8);
-	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-
-	. = ALIGN(8);
-	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-
-	. = ALIGN(8);
-	SECURITY_INIT
-
+	__init_begin = ALIGN(PAGE_SIZE);
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
 	PERCPU(PAGE_SIZE)
-
-	. = ALIGN(2 * PAGE_SIZE);
+	/* Align to THREAD_SIZE rather than PAGE_SIZE here so any padding page
+	   needed for the THREAD_SIZE aligned init_task gets freed after init */
+	. = ALIGN(THREAD_SIZE);
 	__init_end = .;
 	/* Freed after init ends here */
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.page_aligned)
-	}
-
-	. = ALIGN(64);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
-
 	_data = .;
-	/* Data */
-	.data : {
-		INIT_TASK_DATA(THREAD_SIZE)
-		DATA_DATA
-		CONSTRUCTORS
-	}
+	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
 
 	.got : {
 		*(.got)
@@ -119,16 +56,7 @@ SECTIONS
 	}
 	_edata = .;	/* End of data section */
 
-	__bss_start = .;
-	.sbss : {
-		*(.sbss)
-		*(.scommon)
-	}
-	.bss : {
-		*(.bss)
-		*(COMMON)
-	}
-	__bss_stop = .;
+	BSS_SECTION(0, 0, 0)
 	_end = .;
 
 	.mdebug 0 : {
-- 
1.6.3.3

