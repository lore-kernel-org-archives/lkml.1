Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbXCAJYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbXCAJYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933209AbXCAJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:24:06 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:47924 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205AbXCAJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:24:05 -0500
X-IronPort-AV: i="4.14,234,1170651600"; 
   d="scan'208"; a="29470817:sNHT197569372"
Subject: Re: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
	ethernet controller driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nico@cam.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070301005428.e5823f15.akpm@linux-foundation.org>
References: <1172722530.5264.78.camel@roc-desktop>
	 <20070301005428.e5823f15.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 01 Mar 2007 17:23:23 +0800
Message-Id: <1172741003.5264.88.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 00:54 -0800, Andrew Morton wrote:
> On Thu, 01 Mar 2007 12:15:29 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> 
> > +/* check if the mac in reg is valid */
> > +#define SMC_GET_MAC_ADDR(addr)					\
> > +	do {							\
> > +		unsigned int __v;				\
> > +		__v = SMC_inw( ioaddr, ADDR0_REG );		\
> > +		addr[0] = __v; addr[1] = __v >> 8;		\
> > +		__v = SMC_inw( ioaddr, ADDR1_REG );		\
> > +		addr[2] = __v; addr[3] = __v >> 8;		\
> > +		__v = SMC_inw( ioaddr, ADDR2_REG );		\
> > +		addr[4] = __v; addr[5] = __v >> 8;		\
> > +		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
> > +			random_ether_addr(addr);		\
> > +		}						\
> > +	} while (0)
> 
> Please follow kernel coding style:
> 
> 	__v = SMC_inw(ioaddr, ADDR2_REG);
> 
> 
> Can this not be implemented as a C function?

Thanks, Fixed in the new one.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
Cc: Jeff Garzik <jeff@garzik.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org> 
---

 drivers/net/Kconfig  |    2 +-
 drivers/net/smc91x.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/net/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/Kconfig	2007-03-01 10:31:52.000000000 +0800
+++ linux-2.6/drivers/net/Kconfig	2007-03-01 17:07:49.000000000 +0800
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
--- linux-2.6.orig/drivers/net/smc91x.h	2007-03-01 10:31:52.000000000 +0800
+++ linux-2.6/drivers/net/smc91x.h	2007-03-01 17:08:35.000000000 +0800
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
+		__v = SMC_inw(ioaddr, ADDR0_REG);		\
+		addr[0] = __v; addr[1] = __v >> 8;		\
+		__v = SMC_inw(ioaddr, ADDR1_REG);		\
+		addr[2] = __v; addr[3] = __v >> 8;		\
+		__v = SMC_inw(ioaddr, ADDR2_REG);		\
+		addr[4] = __v; addr[5] = __v >> 8;		\
+		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
+			random_ether_addr(addr);		\
+		}						\
+	} while (0)
 #elif defined(CONFIG_REDWOOD_5) || defined(CONFIG_REDWOOD_6)
 
 /* We can only do 16-bit reads and writes in the static memory space. */
_

Best Regards,
-Bryan Wu
