Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZFOCmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZFOCmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZFOCmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:42:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52039 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZFOCmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:42:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=cbNkZHl0crqliLwWhe2KWfd4Ui6TpZk8hSbCh78Ya6nQb3pZoHhDqrAfBHlHVWOrn
	vwDtX3N2VlUHiickzGGoQ==
From: Brian Swetland <swetland@google.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, pavel@ucw.cz,
       Brian Swetland <swetland@google.com>
Subject: [PATCH 2/3] [ARM] msm: make debugging UART (for DEBUG_LL) configurable
Date: Sun, 14 Jun 2009 19:39:16 -0700
Message-Id: <1245033557-10968-3-git-send-email-swetland@google.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1245033557-10968-2-git-send-email-swetland@google.com>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
 <1245033557-10968-2-git-send-email-swetland@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Swetland <swetland@google.com>
---
 arch/arm/mach-msm/Kconfig                    |   24 ++++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/debug-macro.S |   25 ++++++++++++++++++-------
 arch/arm/mach-msm/include/mach/msm_iomap.h   |   12 ++++++++++++
 arch/arm/mach-msm/include/mach/uncompress.h  |    7 +++++++
 arch/arm/mach-msm/io.c                       |    3 +++
 5 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index d140abc..35f2a90 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -3,6 +3,30 @@ if ARCH_MSM
 comment "MSM Board Type"
 	depends on ARCH_MSM
 
+config MSM_DEBUG_UART
+	int
+	default 1 if MSM_DEBUG_UART1
+	default 2 if MSM_DEBUG_UART2
+	default 3 if MSM_DEBUG_UART3
+
+choice
+	prompt "Debug UART"
+
+	default MSM_DEBUG_UART_NONE
+
+	config MSM_DEBUG_UART_NONE
+		bool "None"
+
+	config MSM_DEBUG_UART1
+		bool "UART1"
+
+	config MSM_DEBUG_UART2
+		bool "UART2"
+
+	config MSM_DEBUG_UART3
+		bool "UART3"
+endchoice
+
 config MACH_HALIBUT
 	depends on ARCH_MSM
 	default y
diff --git a/arch/arm/mach-msm/include/mach/debug-macro.S b/arch/arm/mach-msm/include/mach/debug-macro.S
index 1db3c97..ab772cc 100644
--- a/arch/arm/mach-msm/include/mach/debug-macro.S
+++ b/arch/arm/mach-msm/include/mach/debug-macro.S
@@ -14,15 +14,18 @@
  *
  */
 
+
+
 #include <mach/hardware.h>
 #include <mach/msm_iomap.h>
 
+#ifdef CONFIG_MSM_DEBUG_UART
 	.macro	addruart,rx
 	@ see if the MMU is enabled and select appropriate base address
 	mrc	p15, 0, \rx, c1, c0
 	tst	\rx, #1
-	ldreq	\rx, =MSM_UART1_PHYS
-	movne	\rx, #0
+	ldreq	\rx, =MSM_DEBUG_UART_PHYS
+	ldrne	\rx, =MSM_DEBUG_UART_BASE
 	.endm
 
 	.macro	senduart,rd,rx
@@ -32,13 +35,21 @@
 
 	.macro	waituart,rd,rx
 	@ wait for TX_READY
-	teq	\rx, #0
-	bne	2f
-1:	ldr	\rd, [\rx, #0x08]
+1001:	ldr	\rd, [\rx, #0x08]
 	tst	\rd, #0x04
-	beq	1b
-2:
+	beq	1001b
+1002:
+	.endm
+#else
+	.macro	addruart,rx
+	.endm
+
+	.macro	senduart,rd,rx
+	.endm
+
+	.macro	waituart,rd,rx
 	.endm
+#endif
 
 	.macro	busyuart,rd,rx
 	.endm
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 2f7b4c8..9dae1a9 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -84,6 +84,18 @@
 #define MSM_UART3_PHYS        0xA9C00000
 #define MSM_UART3_SIZE        SZ_4K
 
+#ifdef CONFIG_MSM_DEBUG_UART
+#define MSM_DEBUG_UART_BASE   0xE1000000
+#if CONFIG_MSM_DEBUG_UART == 1
+#define MSM_DEBUG_UART_PHYS   MSM_UART1_PHYS
+#elif CONFIG_MSM_DEBUG_UART == 2
+#define MSM_DEBUG_UART_PHYS   MSM_UART2_PHYS
+#elif CONFIG_MSM_DEBUG_UART == 3
+#define MSM_DEBUG_UART_PHYS   MSM_UART3_PHYS
+#endif
+#define MSM_DEBUG_UART_SIZE   SZ_4K
+#endif
+
 #define MSM_SDC1_PHYS         0xA0400000
 #define MSM_SDC1_SIZE         SZ_4K
 
diff --git a/arch/arm/mach-msm/include/mach/uncompress.h b/arch/arm/mach-msm/include/mach/uncompress.h
index 026e895..d94292c 100644
--- a/arch/arm/mach-msm/include/mach/uncompress.h
+++ b/arch/arm/mach-msm/include/mach/uncompress.h
@@ -16,9 +16,16 @@
 #ifndef __ASM_ARCH_MSM_UNCOMPRESS_H
 
 #include "hardware.h"
+#include "linux/io.h"
+#include "mach/msm_iomap.h"
 
 static void putc(int c)
 {
+#if defined(MSM_DEBUG_UART_PHYS)
+	unsigned base = MSM_DEBUG_UART_PHYS;
+	while (!(readl(base + 0x08) & 0x04)) ;
+	writel(c, base + 0x0c);
+#endif
 }
 
 static inline void flush(void)
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 6e7692f..1c5e7da 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -42,6 +42,9 @@ static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
 	MSM_DEVICE(CLK_CTL),
+#ifdef CONFIG_MSM_DEBUG_UART
+	MSM_DEVICE(DEBUG_UART),
+#endif
 	{
 		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
 		.pfn =      __phys_to_pfn(MSM_SHARED_RAM_PHYS),
-- 
1.6.2.4

