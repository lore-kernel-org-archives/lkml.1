Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZGaVEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZGaVEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZGaVEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:04:07 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54732 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbZGaVEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:04:05 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>,
       Geoffrey Thomas <geofft@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 2/2] alpha: Clean up linker script using new linker script macros.
Date: Fri, 31 Jul 2009 16:56:26 -0400
Message-Id: <1249073786-29788-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073786-29788-1-git-send-email-tabbott@ksplice.com>
References: <1249073786-29788-1-git-send-email-tabbott@ksplice.com>
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
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/alpha/kernel/vmlinux.lds.S |   88 +++-----------------------------------
 1 files changed, 7 insertions(+), 81 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index a4bb75e..7836aa3 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -32,84 +32,19 @@ SECTIONS
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
+	. = ALIGN(PAGE_SIZE);
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
@@ -119,16 +54,7 @@ SECTIONS
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
 
 	/* Sections to be discarded */
-- 
1.6.3.3

