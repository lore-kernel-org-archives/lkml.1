Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbZGaVBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbZGaVBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZGaVBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:01:37 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54564 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbZGaVBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:01:35 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Subject: [PATCH 2/3] mips: use PAGE_SIZE in assembly instead of _PAGE_SIZE.
Date: Fri, 31 Jul 2009 16:58:18 -0400
Message-Id: <1249073899-30145-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073899-30145-1-git-send-email-tabbott@ksplice.com>
References: <1249073899-30145-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

Now that PAGE_SIZE is available to assembly directly, there is no need
to separately expose it as _PAGE_SIZE through asm-offsets.

In addition, remove _PAGE_SHIFT from asm-offsets, since it was never
needed, and is not used anywhere.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/asm-offsets.c |    3 ---
 arch/mips/kernel/vmlinux.lds.S |   15 ++++++++-------
 arch/mips/power/hibernate.S    |    3 ++-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index 8d006ec..2c1e1d0 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -183,9 +183,6 @@ void output_mm_defines(void)
 	OFFSET(MM_PGD, mm_struct, pgd);
 	OFFSET(MM_CONTEXT, mm_struct, context);
 	BLANK();
-	DEFINE(_PAGE_SIZE, PAGE_SIZE);
-	DEFINE(_PAGE_SHIFT, PAGE_SHIFT);
-	BLANK();
 	DEFINE(_PGD_T_SIZE, sizeof(pgd_t));
 	DEFINE(_PMD_T_SIZE, sizeof(pmd_t));
 	DEFINE(_PTE_T_SIZE, sizeof(pte_t));
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 58738c8..6bfdb2e 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -1,4 +1,5 @@
 #include <asm/asm-offsets.h>
+#include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips
@@ -76,7 +77,7 @@ SECTIONS
 		 * of ‘init_thread_union’ is greater than maximum
 		 * object file alignment.  Using 32768
 		 */
-		. = ALIGN(_PAGE_SIZE);
+		. = ALIGN(PAGE_SIZE);
 		*(.data.init_task)
 
 		DATA_DATA
@@ -96,12 +97,12 @@ SECTIONS
 		*(.sdata)
 	}
 
-	. = ALIGN(_PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);
 	.data_nosave : {
 		__nosave_begin = .;
 		*(.data.nosave)
 	}
-	. = ALIGN(_PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
 
 	. = ALIGN(1 << CONFIG_MIPS_L1_CACHE_SHIFT);
@@ -111,7 +112,7 @@ SECTIONS
 	_edata =  .;			/* End of data section */
 
 	/* will be freed after init */
-	. = ALIGN(_PAGE_SIZE);		/* Init code and data */
+	. = ALIGN(PAGE_SIZE);		/* Init code and data */
 	__init_begin = .;
 	.init.text : {
 		_sinittext = .;
@@ -151,15 +152,15 @@ SECTIONS
 		EXIT_DATA
 	}
 #if defined(CONFIG_BLK_DEV_INITRD)
-	. = ALIGN(_PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);
 	.init.ramfs : {
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
 	}
 #endif
-	PERCPU(_PAGE_SIZE)
-	. = ALIGN(_PAGE_SIZE);
+	PERCPU(PAGE_SIZE)
+	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
 
diff --git a/arch/mips/power/hibernate.S b/arch/mips/power/hibernate.S
index 4b8174b..0cf86fb 100644
--- a/arch/mips/power/hibernate.S
+++ b/arch/mips/power/hibernate.S
@@ -8,6 +8,7 @@
  *         Wu Zhangjin <wuzj@lemote.com>
  */
 #include <asm/asm-offsets.h>
+#include <asm/page.h>
 #include <asm/regdef.h>
 #include <asm/asm.h>
 
@@ -34,7 +35,7 @@ LEAF(swsusp_arch_resume)
 0:
 	PTR_L t1, PBE_ADDRESS(t0)   /* source */
 	PTR_L t2, PBE_ORIG_ADDRESS(t0) /* destination */
-	PTR_ADDIU t3, t1, _PAGE_SIZE
+	PTR_ADDIU t3, t1, PAGE_SIZE
 1:
 	REG_L t8, (t1)
 	REG_S t8, (t2)
-- 
1.6.3.3

