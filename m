Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZGaU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZGaU7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 16:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZGaU7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 16:59:19 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54019 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbZGaU7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 16:59:18 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 3/3] m32r: Cleanup linker script using new linker script macros.
Date: Fri, 31 Jul 2009 16:58:07 -0400
Message-Id: <1249073887-30086-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073887-30086-1-git-send-email-tabbott@ksplice.com>
References: <1249073887-30086-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is largely a straightforward conversion.  One thing to note
is that the new macros use fewer separate output sections than the old
code; this should have no functional impact but is relevant for people
objdumping vmlinux files.

Also note that it moves the .data.init_task output sections inside
_edata.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/vmlinux.lds.S |   66 +++++-----------------------------------
 1 files changed, 8 insertions(+), 58 deletions(-)

diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 1984b9f..9b5a7eb 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -40,72 +40,22 @@ SECTIONS
 #endif
   _etext = .;			/* End of text section */
 
-  . = ALIGN(16);		/* Exception table */
-  __start___ex_table = .;
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
-
+  EXCEPTION_TABLE(16)
   RODATA
-
-  /* writeable */
-  .data : {			/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-	}
-
-  . = ALIGN(4096);
-  __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
-  . = ALIGN(4096);
-  __nosave_end = .;
-
-  . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
+  RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
   _edata = .;			/* End of data section */
 
-  . = ALIGN(8192);		/* init_task */
-  .data.init_task : { *(.data.init_task) }
-
   /* will be freed after init */
-  . = ALIGN(4096);		/* Init code and data */
+  . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
-  .init.text : {
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
-  .init.data : { INIT_DATA }
-  . = ALIGN(16);
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
-  SECURITY_INIT
-
-#ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(4096);
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
-#endif
-
-  PERCPU(4096)
-  . = ALIGN(4096);
+  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_DATA_SECTION(16)
+  PERCPU(PAGE_SIZE)
+  . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
 
-  __bss_start = .;		/* BSS */
-  .bss : { *(.bss) }
-  . = ALIGN(4);
-  __bss_stop = .;
+  BSS_SECTION(0, 0, 4)
 
   _end = . ;
 
-- 
1.6.3.3

