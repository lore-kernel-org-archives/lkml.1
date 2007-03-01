Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbXCAEQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbXCAEQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 23:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXCAEQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 23:16:11 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:19810 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbXCAEQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 23:16:08 -0500
X-IronPort-AV: i="4.14,233,1170651600"; 
   d="scan'208"; a="23202877:sNHT29441300"
Subject: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
	ethernet controller driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, nico@cam.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 01 Mar 2007 12:15:29 +0800
Message-Id: <1172722530.5264.78.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

As SMC91X ethernet controller are used in blackfin STAMP 533 development
board, this patch add blackfin support to the smc91x linux driver. 

It's name is blackfin-driver-net-stamp533.patch.

[PATCH] Blackfin: patch add blackfin support in smc91x ethernet
controller driver

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 drivers/net/Kconfig  |    2 +-
 drivers/net/smc91x.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/net/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/Kconfig	2007-03-01 11:33:24.000000000 +0800
+++ linux-2.6/drivers/net/Kconfig	2007-03-01 11:39:14.000000000 +0800
@@ -822,7 +822,7 @@
 	tristate "SMC 91C9x/91C1xxx support"
 	select CRC32
 	select MII
-	depends on NET_ETHERNET && (ARM || REDWOOD_5 || REDWOOD_6 || M32R || SUPERH || SOC_AU1X00)
+	depends on NET_ETHERNET && (ARM || REDWOOD_5 || REDWOOD_6 || M32R || SUPERH || SOC_AU1X00 || BFIN)
 	help
 	  This is a driver for SMC's 91x series of Ethernet chipsets,
 	  including the SMC91C94 and the SMC91C111. Say Y if you want it
Index: linux-2.6/drivers/net/smc91x.h
===================================================================
--- linux-2.6.orig/drivers/net/smc91x.h	2007-03-01 11:33:18.000000000 +0800
+++ linux-2.6/drivers/net/smc91x.h	2007-03-01 11:39:14.000000000 +0800
@@ -55,6 +55,53 @@
 #define SMC_insw(a, r, p, l)	readsw((a) + (r), p, l)
 #define SMC_outsw(a, r, p, l)	writesw((a) + (r), p, l)
 
+#elif defined(CONFIG_BFIN)
+
+#define SMC_IRQ_FLAGS		IRQF_TRIGGER_HIGH	
+
+# if defined (CONFIG_BFIN561_EZKIT)
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	1
+#define SMC_IO_SHIFT		0
+#define SMC_NOWAIT      	1
+#define SMC_USE_BFIN_DMA	0
+
+
+#define SMC_inw(a, r)       	readw((a) + (r))
+#define SMC_outw(v, a, r)   	writew(v, (a) + (r))
+#define SMC_inl(a, r)       	readl((a) + (r))
+#define SMC_outl(v, a, r)   	writel(v, (a) + (r))
+#define SMC_outsl(a, r, p, l)	outsl((unsigned long *)((a) + (r)), p, l)
+#define SMC_insl(a, r, p, l) 	insl ((unsigned long *)((a) + (r)), p, l)
+# else
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	0
+#define SMC_IO_SHIFT		0
+#define SMC_NOWAIT      	1
+#define SMC_USE_BFIN_DMA	0
+
+
+#define SMC_inw(a, r)       	readw((a) + (r))
+#define SMC_outw(v, a, r)   	writew(v, (a) + (r))
+#define SMC_outsw(a, r, p, l)	outsw((unsigned long *)((a) + (r)), p, l)
+#define SMC_insw(a, r, p, l) 	insw ((unsigned long *)((a) + (r)), p, l)
+# endif
+/* check if the mac in reg is valid */
+#define SMC_GET_MAC_ADDR(addr)					\
+	do {							\
+		unsigned int __v;				\
+		__v = SMC_inw( ioaddr, ADDR0_REG );		\
+		addr[0] = __v; addr[1] = __v >> 8;		\
+		__v = SMC_inw( ioaddr, ADDR1_REG );		\
+		addr[2] = __v; addr[3] = __v >> 8;		\
+		__v = SMC_inw( ioaddr, ADDR2_REG );		\
+		addr[4] = __v; addr[5] = __v >> 8;		\
+		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
+			random_ether_addr(addr);		\
+		}						\
+	} while (0)
 #elif defined(CONFIG_REDWOOD_5) || defined(CONFIG_REDWOOD_6)
 
 /* We can only do 16-bit reads and writes in the static memory space. */
---

Thanks,
-Bryan
