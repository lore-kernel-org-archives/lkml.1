Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbZFEIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbZFEIIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbZFEIFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37466 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZFEIFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 06/62] Blackfin: fix link failure due to CONFIG_EXCEPTION_L1_SCRATCH
Date: Fri,  5 Jun 2009 04:04:15 -0400
Message-Id: <1244189111-19639-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Move exception stack mess from entry.S to init.c to fix link failure when
CONFIG_EXCEPTION_L1_SCRATCH is in use.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/Kconfig             |    2 +-
 arch/blackfin/mach-common/entry.S |   17 -----------------
 arch/blackfin/mm/init.c           |   14 ++++++++++++--
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 6b97aa8..672b7b0 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -808,7 +808,7 @@ config APP_STACK_L1
 config EXCEPTION_L1_SCRATCH
 	bool "Locate exception stack in L1 Scratch Memory"
 	default n
-	depends on !APP_STACK_L1 && !SYSCALL_TAB_L1
+	depends on !APP_STACK_L1
 	help
 	  Whenever an exception occurs, use the L1 Scratch memory for
 	  stack storage.  You cannot place the stacks of FLAT binaries
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index a063a43..f0636fd 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -36,7 +36,6 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/unistd.h>
-#include <linux/threads.h>
 #include <asm/blackfin.h>
 #include <asm/errno.h>
 #include <asm/fixed_code.h>
@@ -1588,19 +1587,3 @@ ENTRY(_sys_call_table)
 	.long _sys_ni_syscall
 	.endr
 END(_sys_call_table)
-
-#ifdef CONFIG_EXCEPTION_L1_SCRATCH
-/* .section .l1.bss.scratch */
-.set _exception_stack_top, L1_SCRATCH_START + L1_SCRATCH_LENGTH
-#else
-#ifdef CONFIG_SYSCALL_TAB_L1
-.section .l1.bss
-#else
-.bss
-#endif
-ENTRY(_exception_stack)
-	.rept 1024 * NR_CPUS
-	.long 0
-	.endr
-_exception_stack_top:
-#endif
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index 9c3629b..00543c8 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -52,9 +52,14 @@ static unsigned long empty_bad_page_table;
 
 static unsigned long empty_bad_page;
 
-unsigned long empty_zero_page;
+static unsigned long empty_zero_page;
 
-extern unsigned long exception_stack[NR_CPUS][1024];
+#ifndef CONFIG_EXCEPTION_L1_SCRATCH
+#if defined CONFIG_SYSCALL_TAB_L1
+__attribute__((l1_data))
+#endif
+static unsigned long exception_stack[NR_CPUS][1024];
+#endif
 
 struct blackfin_pda cpu_pda[NR_CPUS];
 EXPORT_SYMBOL(cpu_pda);
@@ -117,7 +122,12 @@ asmlinkage void __init init_pda(void)
 	cpu_pda[0].next = &cpu_pda[1];
 	cpu_pda[1].next = &cpu_pda[0];
 
+#ifdef CONFIG_EXCEPTION_L1_SCRATCH
+	cpu_pda[cpu].ex_stack = (unsigned long *)(L1_SCRATCH_START + \
+					L1_SCRATCH_LENGTH);
+#else
 	cpu_pda[cpu].ex_stack = exception_stack[cpu + 1];
+#endif
 
 #ifdef CONFIG_SMP
 	cpu_pda[cpu].imask = 0x1f;
-- 
1.6.3.1

