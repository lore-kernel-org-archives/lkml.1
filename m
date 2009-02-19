Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZBSNrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZBSNrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZBSNrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:16 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:49874 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZBSNrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FdCzBkNtyUtIw/OsPkykmMfs+QNwHGfkSBqeGkAjmFK0/rxx2tucAH4yvf6DAgR2Ha
         SboJ04Z0pv8wtO7sfeMPWL/7vxiAxg/j3ZnhqQ0gCtJedL5xvSgADumqNAJJmyHgw6sr
         JXXwzpe57b5+Ne1C1vV1JIskuwn7ecEU9b8HA=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] [ARM] pxa: introduce plat-pxa for PXA common code and add DMA support
Date: Thu, 19 Feb 2009 21:45:50 +0800
Message-Id: <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

1. introduce folder of 'arch/arm/plat-pxa' for common code across different
   PXA processor families

2. initially moved DMA code into plat-pxa

3. common code in <mach/dma.h> moved into <plat/dma.h>, new processors
   should implement its own <mach/dma.h>, provide the following required
   definitions and '#include <plat/dma.h>' in the end:

   - DMAC_REGS_VIRT for mapped virtual address of the DMA registers'
     physical I/O memory

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/Kconfig                      |    5 ++
 arch/arm/Makefile                     |    1 +
 arch/arm/mach-pxa/Makefile            |    2 +-
 arch/arm/mach-pxa/include/mach/dma.h  |   83 +-------------------------------
 arch/arm/plat-pxa/Kconfig             |    3 +
 arch/arm/plat-pxa/Makefile            |    6 ++
 arch/arm/{mach-pxa => plat-pxa}/dma.c |    6 +-
 arch/arm/plat-pxa/include/plat/dma.h  |   85 +++++++++++++++++++++++++++++++++
 8 files changed, 105 insertions(+), 86 deletions(-)
 create mode 100644 arch/arm/plat-pxa/Kconfig
 create mode 100644 arch/arm/plat-pxa/Makefile
 rename arch/arm/{mach-pxa => plat-pxa}/dma.c (97%)
 create mode 100644 arch/arm/plat-pxa/include/plat/dma.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5e0c5ab..a268734 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -481,6 +481,7 @@ config ARCH_PXA
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
+	select PLAT_PXA
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
@@ -618,6 +619,7 @@ source "arch/arm/mach-loki/Kconfig"
 source "arch/arm/mach-mv78xx0/Kconfig"
 
 source "arch/arm/mach-pxa/Kconfig"
+source "arch/arm/plat-pxa/Kconfig"
 
 source "arch/arm/mach-sa1100/Kconfig"
 
@@ -687,6 +689,9 @@ config PLAT_IOP
 config PLAT_ORION
 	bool
 
+config PLAT_PXA
+	bool
+
 source arch/arm/mm/Kconfig
 
 config IWMMXT
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 24e0f01..5f578a2 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -105,6 +105,7 @@ ifeq ($(CONFIG_ARCH_SA1100),y)
  textofs-$(CONFIG_SA1111)	   := 0x00208000
 endif
  machine-$(CONFIG_ARCH_PXA)	   := pxa
+    plat-$(CONFIG_PLAT_PXA)	   := pxa
  machine-$(CONFIG_ARCH_L7200)	   := l7200
  machine-$(CONFIG_ARCH_INTEGRATOR) := integrator
  textofs-$(CONFIG_ARCH_CLPS711X)   := 0x00028000
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 361fcfa..2d84202 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support (must be linked before board specific support)
-obj-y				+= clock.o devices.o generic.o irq.o dma.o \
+obj-y				+= clock.o devices.o generic.o irq.o \
 				   time.o gpio.o reset.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 
diff --git a/arch/arm/mach-pxa/include/mach/dma.h b/arch/arm/mach-pxa/include/mach/dma.h
index b0812f5..5bd5589 100644
--- a/arch/arm/mach-pxa/include/mach/dma.h
+++ b/arch/arm/mach-pxa/include/mach/dma.h
@@ -16,87 +16,6 @@
 
 /* DMA Controller Registers Definitions */
 #define DMAC_REGS_VIRT	io_p2v(0x40000000)
-#define DMAC_REG(x)	(*((volatile u32 *)(DMAC_REGS_VIRT + (x))))
-
-#define DCSR(n)		DMAC_REG((n) << 2)
-#define DALGN		DMAC_REG(0x00a0)  /* DMA Alignment Register */
-#define DINT		DMAC_REG(0x00f0)  /* DMA Interrupt Register */
-#define DDADR(n)	DMAC_REG(0x0200 + ((n) << 4))
-#define DSADR(n)	DMAC_REG(0x0204 + ((n) << 4))
-#define DTADR(n)	DMAC_REG(0x0208 + ((n) << 4))
-#define DCMD(n)		DMAC_REG(0x020c + ((n) << 4))
-#define DRCMR(n)	DMAC_REG((((n) < 64) ? 0x0100 : 0x1100) + \
-				 (((n) & 0x3f) << 2))
-
-#define DCSR_RUN	(1 << 31)	/* Run Bit (read / write) */
-#define DCSR_NODESC	(1 << 30)	/* No-Descriptor Fetch (read / write) */
-#define DCSR_STOPIRQEN	(1 << 29)	/* Stop Interrupt Enable (read / write) */
-#define DCSR_REQPEND	(1 << 8)	/* Request Pending (read-only) */
-#define DCSR_STOPSTATE	(1 << 3)	/* Stop State (read-only) */
-#define DCSR_ENDINTR	(1 << 2)	/* End Interrupt (read / write) */
-#define DCSR_STARTINTR	(1 << 1)	/* Start Interrupt (read / write) */
-#define DCSR_BUSERR	(1 << 0)	/* Bus Error Interrupt (read / write) */
-
-#if defined(CONFIG_PXA27x) || defined(CONFIG_PXA3xx)
-#define DCSR_EORIRQEN	(1 << 28)       /* End of Receive Interrupt Enable (R/W) */
-#define DCSR_EORJMPEN	(1 << 27)       /* Jump to next descriptor on EOR */
-#define DCSR_EORSTOPEN	(1 << 26)       /* STOP on an EOR */
-#define DCSR_SETCMPST	(1 << 25)       /* Set Descriptor Compare Status */
-#define DCSR_CLRCMPST	(1 << 24)       /* Clear Descriptor Compare Status */
-#define DCSR_CMPST	(1 << 10)       /* The Descriptor Compare Status */
-#define DCSR_EORINTR	(1 << 9)        /* The end of Receive */
-#endif
-
-#define DRCMR_MAPVLD	(1 << 7)	/* Map Valid (read / write) */
-#define DRCMR_CHLNUM	0x1f		/* mask for Channel Number (read / write) */
-
-#define DDADR_DESCADDR	0xfffffff0	/* Address of next descriptor (mask) */
-#define DDADR_STOP	(1 << 0)	/* Stop (read / write) */
-
-#define DCMD_INCSRCADDR	(1 << 31)	/* Source Address Increment Setting. */
-#define DCMD_INCTRGADDR	(1 << 30)	/* Target Address Increment Setting. */
-#define DCMD_FLOWSRC	(1 << 29)	/* Flow Control by the source. */
-#define DCMD_FLOWTRG	(1 << 28)	/* Flow Control by the target. */
-#define DCMD_STARTIRQEN	(1 << 22)	/* Start Interrupt Enable */
-#define DCMD_ENDIRQEN	(1 << 21)	/* End Interrupt Enable */
-#define DCMD_ENDIAN	(1 << 18)	/* Device Endian-ness. */
-#define DCMD_BURST8	(1 << 16)	/* 8 byte burst */
-#define DCMD_BURST16	(2 << 16)	/* 16 byte burst */
-#define DCMD_BURST32	(3 << 16)	/* 32 byte burst */
-#define DCMD_WIDTH1	(1 << 14)	/* 1 byte width */
-#define DCMD_WIDTH2	(2 << 14)	/* 2 byte width (HalfWord) */
-#define DCMD_WIDTH4	(3 << 14)	/* 4 byte width (Word) */
-#define DCMD_LENGTH	0x01fff		/* length mask (max = 8K - 1) */
-
-/*
- * Descriptor structure for PXA's DMA engine
- * Note: this structure must always be aligned to a 16-byte boundary.
- */
-
-typedef struct pxa_dma_desc {
-	volatile u32 ddadr;	/* Points to the next descriptor + flags */
-	volatile u32 dsadr;	/* DSADR value for the current transfer */
-	volatile u32 dtadr;	/* DTADR value for the current transfer */
-	volatile u32 dcmd;	/* DCMD value for the current transfer */
-} pxa_dma_desc;
-
-typedef enum {
-	DMA_PRIO_HIGH = 0,
-	DMA_PRIO_MEDIUM = 1,
-	DMA_PRIO_LOW = 2
-} pxa_dma_prio;
-
-/*
- * DMA registration
- */
-
-int __init pxa_init_dma(int irq, int num_ch);
-
-int pxa_request_dma (char *name,
-			 pxa_dma_prio prio,
-			 void (*irq_handler)(int, void *),
-			 void *data);
-
-void pxa_free_dma (int dma_ch);
 
+#include <plat/dma.h>
 #endif /* _ASM_ARCH_DMA_H */
diff --git a/arch/arm/plat-pxa/Kconfig b/arch/arm/plat-pxa/Kconfig
new file mode 100644
index 0000000..b158e98
--- /dev/null
+++ b/arch/arm/plat-pxa/Kconfig
@@ -0,0 +1,3 @@
+if PLAT_PXA
+
+endif
diff --git a/arch/arm/plat-pxa/Makefile b/arch/arm/plat-pxa/Makefile
new file mode 100644
index 0000000..dcc3cea
--- /dev/null
+++ b/arch/arm/plat-pxa/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for code common across different PXA processor families
+#
+
+obj-y	:= dma.o
+
diff --git a/arch/arm/mach-pxa/dma.c b/arch/arm/plat-pxa/dma.c
similarity index 97%
rename from arch/arm/mach-pxa/dma.c
rename to arch/arm/plat-pxa/dma.c
index 01217e0..70aeee4 100644
--- a/arch/arm/mach-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/arm/mach-pxa/dma.c
+ *  linux/arch/arm/plat-pxa/dma.c
  *
  *  PXA DMA registration and IRQ dispatching
  *
@@ -34,8 +34,8 @@ static struct dma_channel *dma_channels;
 static int num_dma_channels;
 
 int pxa_request_dma (char *name, pxa_dma_prio prio,
-			 void (*irq_handler)(int, void *),
-		 	 void *data)
+			void (*irq_handler)(int, void *),
+			void *data)
 {
 	unsigned long flags;
 	int i, found = 0;
diff --git a/arch/arm/plat-pxa/include/plat/dma.h b/arch/arm/plat-pxa/include/plat/dma.h
new file mode 100644
index 0000000..a7b91dc
--- /dev/null
+++ b/arch/arm/plat-pxa/include/plat/dma.h
@@ -0,0 +1,85 @@
+#ifndef __PLAT_DMA_H
+#define __PLAT_DMA_H
+
+#define DMAC_REG(x)	(*((volatile u32 *)(DMAC_REGS_VIRT + (x))))
+
+#define DCSR(n)		DMAC_REG((n) << 2)
+#define DALGN		DMAC_REG(0x00a0)  /* DMA Alignment Register */
+#define DINT		DMAC_REG(0x00f0)  /* DMA Interrupt Register */
+#define DDADR(n)	DMAC_REG(0x0200 + ((n) << 4))
+#define DSADR(n)	DMAC_REG(0x0204 + ((n) << 4))
+#define DTADR(n)	DMAC_REG(0x0208 + ((n) << 4))
+#define DCMD(n)		DMAC_REG(0x020c + ((n) << 4))
+#define DRCMR(n)	DMAC_REG((((n) < 64) ? 0x0100 : 0x1100) + \
+				 (((n) & 0x3f) << 2))
+
+#define DCSR_RUN	(1 << 31)	/* Run Bit (read / write) */
+#define DCSR_NODESC	(1 << 30)	/* No-Descriptor Fetch (read / write) */
+#define DCSR_STOPIRQEN	(1 << 29)	/* Stop Interrupt Enable (read / write) */
+#define DCSR_REQPEND	(1 << 8)	/* Request Pending (read-only) */
+#define DCSR_STOPSTATE	(1 << 3)	/* Stop State (read-only) */
+#define DCSR_ENDINTR	(1 << 2)	/* End Interrupt (read / write) */
+#define DCSR_STARTINTR	(1 << 1)	/* Start Interrupt (read / write) */
+#define DCSR_BUSERR	(1 << 0)	/* Bus Error Interrupt (read / write) */
+
+#define DCSR_EORIRQEN	(1 << 28)       /* End of Receive Interrupt Enable (R/W) */
+#define DCSR_EORJMPEN	(1 << 27)       /* Jump to next descriptor on EOR */
+#define DCSR_EORSTOPEN	(1 << 26)       /* STOP on an EOR */
+#define DCSR_SETCMPST	(1 << 25)       /* Set Descriptor Compare Status */
+#define DCSR_CLRCMPST	(1 << 24)       /* Clear Descriptor Compare Status */
+#define DCSR_CMPST	(1 << 10)       /* The Descriptor Compare Status */
+#define DCSR_EORINTR	(1 << 9)        /* The end of Receive */
+
+#define DRCMR_MAPVLD	(1 << 7)	/* Map Valid (read / write) */
+#define DRCMR_CHLNUM	0x1f		/* mask for Channel Number (read / write) */
+
+#define DDADR_DESCADDR	0xfffffff0	/* Address of next descriptor (mask) */
+#define DDADR_STOP	(1 << 0)	/* Stop (read / write) */
+
+#define DCMD_INCSRCADDR	(1 << 31)	/* Source Address Increment Setting. */
+#define DCMD_INCTRGADDR	(1 << 30)	/* Target Address Increment Setting. */
+#define DCMD_FLOWSRC	(1 << 29)	/* Flow Control by the source. */
+#define DCMD_FLOWTRG	(1 << 28)	/* Flow Control by the target. */
+#define DCMD_STARTIRQEN	(1 << 22)	/* Start Interrupt Enable */
+#define DCMD_ENDIRQEN	(1 << 21)	/* End Interrupt Enable */
+#define DCMD_ENDIAN	(1 << 18)	/* Device Endian-ness. */
+#define DCMD_BURST8	(1 << 16)	/* 8 byte burst */
+#define DCMD_BURST16	(2 << 16)	/* 16 byte burst */
+#define DCMD_BURST32	(3 << 16)	/* 32 byte burst */
+#define DCMD_WIDTH1	(1 << 14)	/* 1 byte width */
+#define DCMD_WIDTH2	(2 << 14)	/* 2 byte width (HalfWord) */
+#define DCMD_WIDTH4	(3 << 14)	/* 4 byte width (Word) */
+#define DCMD_LENGTH	0x01fff		/* length mask (max = 8K - 1) */
+
+/*
+ * Descriptor structure for PXA's DMA engine
+ * Note: this structure must always be aligned to a 16-byte boundary.
+ */
+
+typedef struct pxa_dma_desc {
+	volatile u32 ddadr;	/* Points to the next descriptor + flags */
+	volatile u32 dsadr;	/* DSADR value for the current transfer */
+	volatile u32 dtadr;	/* DTADR value for the current transfer */
+	volatile u32 dcmd;	/* DCMD value for the current transfer */
+} pxa_dma_desc;
+
+typedef enum {
+	DMA_PRIO_HIGH = 0,
+	DMA_PRIO_MEDIUM = 1,
+	DMA_PRIO_LOW = 2
+} pxa_dma_prio;
+
+/*
+ * DMA registration
+ */
+
+int __init pxa_init_dma(int irq, int num_ch);
+
+int pxa_request_dma (char *name,
+			 pxa_dma_prio prio,
+			 void (*irq_handler)(int, void *),
+			 void *data);
+
+void pxa_free_dma (int dma_ch);
+
+#endif /* __PLAT_DMA_H */
-- 
1.6.0.4

