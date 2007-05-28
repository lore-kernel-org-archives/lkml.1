Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbXE1Ill@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbXE1Ill (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbXE1Igv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:51 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:31495 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754AbXE1Igg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:36 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300053:sNHT26455730"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 13/20] Blackfin arch: move more of our startup code to .init so it can be freed once we are up and running
Date: Mon, 28 May 2007 16:37:48 +0800
Message-Id: <11803414793116-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c    |   10 +++++-----
 arch/blackfin/mach-bf533/head.S |   13 ++++++++-----
 arch/blackfin/mach-bf537/head.S |   13 ++++++++-----
 arch/blackfin/mach-bf561/head.S |   13 ++++++++-----
 4 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 02dc743..d9517e7 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -90,7 +90,7 @@ void __init bf53x_cache_init(void)
 #endif
 }
 
-void bf53x_relocate_l1_mem(void)
+void __init bf53x_relocate_l1_mem(void)
 {
 	unsigned long l1_code_length;
 	unsigned long l1_data_a_length;
@@ -411,7 +411,7 @@ static int __init topology_init(void)
 subsys_initcall(topology_init);
 
 #if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
-u16 lock_kernel_check(u32 start, u32 end)
+static u16 __init lock_kernel_check(u32 start, u32 end)
 {
 	if ((start <= (u32) _stext && end >= (u32) _end)
 	    || (start >= (u32) _stext && end <= (u32) _end))
@@ -681,7 +681,7 @@ static void __init generate_cpl_tables(void)
 
 #endif
 
-static inline u_long get_vco(void)
+static u_long get_vco(void)
 {
 	u_long msel;
 	u_long vco;
@@ -889,8 +889,8 @@ struct seq_operations cpuinfo_op = {
 	.show = show_cpuinfo,
 };
 
-void cmdline_init(unsigned long r0)
+void __init cmdline_init(char *r0)
 {
 	if (r0)
-		strncpy(command_line, (char *)r0, COMMAND_LINE_SIZE);
+		strncpy(command_line, r0, COMMAND_LINE_SIZE);
 }
diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 33d1f62..7e2aa8d 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -28,6 +28,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/blackfin.h>
 #if CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach/mem_init.h>
@@ -45,10 +46,9 @@
 
 #define INITIAL_STACK	0xFFB01000
 
-.text
+__INIT
 
 ENTRY(__start)
-ENTRY(__stext)
 	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
 	/* Set the SYSCFG register:
@@ -266,6 +266,7 @@ ENTRY(__stext)
 
 .LWAIT_HERE:
 	jump .LWAIT_HERE;
+ENDPROC(__start)
 
 ENTRY(_real_start)
 	[ -- sp ] = reti;
@@ -334,9 +335,10 @@ ENTRY(_real_start)
 	sp = r1;
 	usp = sp;
 	fp = sp;
-	call _start_kernel;
-.L_exit:
-	jump.s	.L_exit;
+	jump.l _start_kernel;
+ENDPROC(_real_start)
+
+__FINIT
 
 .section .l1.text
 #if CONFIG_BFIN_KERNEL_CLOCK
@@ -446,6 +448,7 @@ ENTRY(_start_dma_code)
 	SSYNC;
 
 	RTS;
+ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
 
 ENTRY(_bfin_reset)
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index 3f490bf..7d902bb 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -28,6 +28,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/blackfin.h>
 #if CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach/mem_init.h>
@@ -42,10 +43,9 @@
 
 #define INITIAL_STACK	0xFFB01000
 
-.text
+__INIT
 
 ENTRY(__start)
-ENTRY(__stext)
 	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
 	/* Set the SYSCFG register:
@@ -275,6 +275,7 @@ ENTRY(__stext)
 
 .LWAIT_HERE:
 	jump .LWAIT_HERE;
+ENDPROC(__start)
 
 ENTRY(_real_start)
 	[ -- sp ] = reti;
@@ -343,9 +344,10 @@ ENTRY(_real_start)
 	sp = r1;
 	usp = sp;
 	fp = sp;
-	call _start_kernel;
-.L_exit:
-	jump.s	.L_exit;
+	jump.l _start_kernel;
+ENDPROC(_real_start)
+
+__FINIT
 
 .section .l1.text
 #if CONFIG_BFIN_KERNEL_CLOCK
@@ -464,6 +466,7 @@ ENTRY(_start_dma_code)
 	SSYNC;
 
 	RTS;
+ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
 
 ENTRY(_bfin_reset)
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 3029e94..31cbc75 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -28,6 +28,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/blackfin.h>
 #if CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach/mem_init.h>
@@ -42,10 +43,9 @@
 
 #define INITIAL_STACK	0xFFB01000
 
-.text
+__INIT
 
 ENTRY(__start)
-ENTRY(__stext)
 	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
 	/* Set the SYSCFG register:
@@ -221,6 +221,7 @@ ENTRY(__stext)
 
 .LWAIT_HERE:
 	jump .LWAIT_HERE;
+ENDPROC(__start)
 
 ENTRY(_real_start)
 	[ -- sp ] = reti;
@@ -289,9 +290,10 @@ ENTRY(_real_start)
 	sp = r1;
 	usp = sp;
 	fp = sp;
-	call _start_kernel;
-.L_exit:
-	jump.s	.L_exit;
+	jump.l _start_kernel;
+ENDPROC(_real_start)
+
+__FINIT
 
 .section .l1.text
 #if CONFIG_BFIN_KERNEL_CLOCK
@@ -393,6 +395,7 @@ ENTRY(_start_dma_code)
 	SSYNC;
 
 	RTS;
+ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
 
 ENTRY(_bfin_reset)
-- 
1.5.2
