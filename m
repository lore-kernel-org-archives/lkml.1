Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYKJDZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYKJDZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYKJDYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:24:08 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:32448 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYKJDXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:23:54 -0500
X-IronPort-AV: E=Sophos;i="4.33,572,1220241600"; 
   d="scan'208";a="62305286"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/4] usb: musb: add Blackfin specific configuration to MUSB (add missing file changes)
Date: Mon, 10 Nov 2008 11:25:12 +0800
Message-Id: <1226287515-27247-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226287515-27247-1-git-send-email-cooloney@kernel.org>
References: <1226287515-27247-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add back some missing file changes in previous patch named
"[PATCH 15/17] usb: musb: add Blackfin specific configuration to MUSB"

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_core.c |   52 ++----
 drivers/usb/musb/musb_host.c |   22 +--
 drivers/usb/musb/musb_regs.h |  353 +++++++++++++++++++++++++++++++-----------
 3 files changed, 286 insertions(+), 141 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index f948265..27768dd 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -148,7 +148,8 @@ static inline struct musb *dev_to_musb(struct device *dev)
 
 /*-------------------------------------------------------------------------*/
 
-#ifndef CONFIG_USB_TUSB6010
+#if !defined(CONFIG_USB_TUSB6010) && !defined(CONFIG_BLACKFIN)
+
 /*
  * Load an endpoint's FIFO
  */
@@ -1124,25 +1125,25 @@ fifo_setup(struct musb *musb, struct musb_hw_ep  *hw_ep,
 #endif
 	switch (cfg->style) {
 	case FIFO_TX:
-		musb_writeb(mbase, MUSB_TXFIFOSZ, c_size);
-		musb_writew(mbase, MUSB_TXFIFOADD, c_off);
+		musb_write_txfifosz(mbase, c_size);
+		musb_write_txfifoadd(mbase, c_off);
 		hw_ep->tx_double_buffered = !!(c_size & MUSB_FIFOSZ_DPB);
 		hw_ep->max_packet_sz_tx = maxpacket;
 		break;
 	case FIFO_RX:
-		musb_writeb(mbase, MUSB_RXFIFOSZ, c_size);
-		musb_writew(mbase, MUSB_RXFIFOADD, c_off);
+		musb_write_rxfifosz(mbase, c_size);
+		musb_write_rxfifoadd(mbase, c_off);
 		hw_ep->rx_double_buffered = !!(c_size & MUSB_FIFOSZ_DPB);
 		hw_ep->max_packet_sz_rx = maxpacket;
 		break;
 	case FIFO_RXTX:
-		musb_writeb(mbase, MUSB_TXFIFOSZ, c_size);
-		musb_writew(mbase, MUSB_TXFIFOADD, c_off);
+		musb_write_txfifosz(mbase, c_size);
+		musb_write_txfifoadd(mbase, c_off);
 		hw_ep->rx_double_buffered = !!(c_size & MUSB_FIFOSZ_DPB);
 		hw_ep->max_packet_sz_rx = maxpacket;
 
-		musb_writeb(mbase, MUSB_RXFIFOSZ, c_size);
-		musb_writew(mbase, MUSB_RXFIFOADD, c_off);
+		musb_write_rxfifosz(mbase, c_size);
+		musb_write_rxfifoadd(mbase, c_off);
 		hw_ep->tx_double_buffered = hw_ep->rx_double_buffered;
 		hw_ep->max_packet_sz_tx = maxpacket;
 
@@ -1246,9 +1247,10 @@ static int __init ep_config_from_table(struct musb *musb)
  */
 static int __init ep_config_from_hw(struct musb *musb)
 {
-	u8 epnum = 0, reg;
+	u8 epnum = 0;
 	struct musb_hw_ep *hw_ep;
 	void *mbase = musb->mregs;
+	int ret = 0;
 
 	DBG(2, "<== static silicon ep config\n");
 
@@ -1258,26 +1260,9 @@ static int __init ep_config_from_hw(struct musb *musb)
 		musb_ep_select(mbase, epnum);
 		hw_ep = musb->endpoints + epnum;
 
-		/* read from core using indexed model */
-		reg = musb_readb(hw_ep->regs, 0x10 + MUSB_FIFOSIZE);
-		if (!reg) {
-			/* 0's returned when no more endpoints */
+		ret = musb_read_fifosize(musb, hw_ep, epnum);
+		if (ret < 0)
 			break;
-		}
-		musb->nr_endpoints++;
-		musb->epmask |= (1 << epnum);
-
-		hw_ep->max_packet_sz_tx = 1 << (reg & 0x0f);
-
-		/* shared TX/RX FIFO? */
-		if ((reg & 0xf0) == 0xf0) {
-			hw_ep->max_packet_sz_rx = hw_ep->max_packet_sz_tx;
-			hw_ep->is_shared_fifo = true;
-			continue;
-		} else {
-			hw_ep->max_packet_sz_rx = 1 << ((reg & 0xf0) >> 4);
-			hw_ep->is_shared_fifo = false;
-		}
 
 		/* FIXME set up hw_ep->{rx,tx}_double_buffered */
 
@@ -1326,7 +1311,7 @@ static int __init musb_core_init(u16 musb_type, struct musb *musb)
 
 	/* log core options (read using indexed model) */
 	musb_ep_select(mbase, 0);
-	reg = musb_readb(mbase, 0x10 + MUSB_CONFIGDATA);
+	reg = musb_read_configdata(mbase);
 
 	strcpy(aInfo, (reg & MUSB_CONFIGDATA_UTMIDW) ? "UTMI-16" : "UTMI-8");
 	if (reg & MUSB_CONFIGDATA_DYNFIFO)
@@ -1391,7 +1376,7 @@ static int __init musb_core_init(u16 musb_type, struct musb *musb)
 	}
 
 	/* log release info */
-	hwvers = musb_readw(mbase, MUSB_HWVERS);
+	hwvers = musb_read_hwvers(mbase);
 	rev_major = (hwvers >> 10) & 0x1f;
 	rev_minor = hwvers & 0x3ff;
 	snprintf(aRevision, 32, "%d.%d%s", rev_major,
@@ -1400,8 +1385,7 @@ static int __init musb_core_init(u16 musb_type, struct musb *musb)
 			musb_driver_name, type, aRevision, aDate);
 
 	/* configure ep0 */
-	musb->endpoints[0].max_packet_sz_tx = MUSB_EP0_FIFOSIZE;
-	musb->endpoints[0].max_packet_sz_rx = MUSB_EP0_FIFOSIZE;
+	musb_configure_ep0(musb);
 
 	/* discover endpoint configuration */
 	musb->nr_endpoints = 1;
@@ -1445,7 +1429,7 @@ static int __init musb_core_init(u16 musb_type, struct musb *musb)
 
 		hw_ep->regs = MUSB_EP_OFFSET(i, 0) + mbase;
 #ifdef CONFIG_USB_MUSB_HDRC_HCD
-		hw_ep->target_regs = MUSB_BUSCTL_OFFSET(i, 0) + mbase;
+		hw_ep->target_regs = musb_read_target_reg_base(i, mbase);
 		hw_ep->rx_reinit = 1;
 		hw_ep->tx_reinit = 1;
 #endif
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 07a0b01..5f4342a 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -606,12 +606,10 @@ musb_rx_reinit(struct musb *musb, struct musb_qh *qh, struct musb_hw_ep *ep)
 
 	/* target addr and (for multipoint) hub addr/port */
 	if (musb->is_multipoint) {
-		musb_writeb(ep->target_regs, MUSB_RXFUNCADDR,
-			qh->addr_reg);
-		musb_writeb(ep->target_regs, MUSB_RXHUBADDR,
-			qh->h_addr_reg);
-		musb_writeb(ep->target_regs, MUSB_RXHUBPORT,
-			qh->h_port_reg);
+		musb_write_rxfunaddr(ep->target_regs, qh->addr_reg);
+		musb_write_rxhubaddr(ep->target_regs, qh->h_addr_reg);
+		musb_write_rxhubport(ep->target_regs, qh->h_port_reg);
+
 	} else
 		musb_writeb(musb->mregs, MUSB_FADDR, qh->addr_reg);
 
@@ -725,15 +723,9 @@ static void musb_ep_program(struct musb *musb, u8 epnum,
 
 		/* target addr and (for multipoint) hub addr/port */
 		if (musb->is_multipoint) {
-			musb_writeb(mbase,
-				MUSB_BUSCTL_OFFSET(epnum, MUSB_TXFUNCADDR),
-				qh->addr_reg);
-			musb_writeb(mbase,
-				MUSB_BUSCTL_OFFSET(epnum, MUSB_TXHUBADDR),
-				qh->h_addr_reg);
-			musb_writeb(mbase,
-				MUSB_BUSCTL_OFFSET(epnum, MUSB_TXHUBPORT),
-				qh->h_port_reg);
+			musb_write_txfunaddr(mbase, epnum, qh->addr_reg);
+			musb_write_txhubaddr(mbase, epnum, qh->h_addr_reg);
+			musb_write_txhubport(mbase, epnum, qh->h_port_reg);
 /* FIXME if !epnum, do the same for RX ... */
 		} else
 			musb_writeb(mbase, MUSB_FADDR, qh->addr_reg);
diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index 9c22866..3e50aef 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -38,97 +38,6 @@
 #define MUSB_EP0_FIFOSIZE	64	/* This is non-configurable */
 
 /*
- * Common USB registers
- */
-
-#define MUSB_FADDR		0x00	/* 8-bit */
-#define MUSB_POWER		0x01	/* 8-bit */
-
-#define MUSB_INTRTX		0x02	/* 16-bit */
-#define MUSB_INTRRX		0x04
-#define MUSB_INTRTXE		0x06
-#define MUSB_INTRRXE		0x08
-#define MUSB_INTRUSB		0x0A	/* 8 bit */
-#define MUSB_INTRUSBE		0x0B	/* 8 bit */
-#define MUSB_FRAME		0x0C
-#define MUSB_INDEX		0x0E	/* 8 bit */
-#define MUSB_TESTMODE		0x0F	/* 8 bit */
-
-/* Get offset for a given FIFO from musb->mregs */
-#ifdef	CONFIG_USB_TUSB6010
-#define MUSB_FIFO_OFFSET(epnum)	(0x200 + ((epnum) * 0x20))
-#else
-#define MUSB_FIFO_OFFSET(epnum)	(0x20 + ((epnum) * 4))
-#endif
-
-/*
- * Additional Control Registers
- */
-
-#define MUSB_DEVCTL		0x60	/* 8 bit */
-
-/* These are always controlled through the INDEX register */
-#define MUSB_TXFIFOSZ		0x62	/* 8-bit (see masks) */
-#define MUSB_RXFIFOSZ		0x63	/* 8-bit (see masks) */
-#define MUSB_TXFIFOADD		0x64	/* 16-bit offset shifted right 3 */
-#define MUSB_RXFIFOADD		0x66	/* 16-bit offset shifted right 3 */
-
-/* REVISIT: vctrl/vstatus: optional vendor utmi+phy register at 0x68 */
-#define MUSB_HWVERS		0x6C	/* 8 bit */
-
-#define MUSB_EPINFO		0x78	/* 8 bit */
-#define MUSB_RAMINFO		0x79	/* 8 bit */
-#define MUSB_LINKINFO		0x7a	/* 8 bit */
-#define MUSB_VPLEN		0x7b	/* 8 bit */
-#define MUSB_HS_EOF1		0x7c	/* 8 bit */
-#define MUSB_FS_EOF1		0x7d	/* 8 bit */
-#define MUSB_LS_EOF1		0x7e	/* 8 bit */
-
-/* Offsets to endpoint registers */
-#define MUSB_TXMAXP		0x00
-#define MUSB_TXCSR		0x02
-#define MUSB_CSR0		MUSB_TXCSR	/* Re-used for EP0 */
-#define MUSB_RXMAXP		0x04
-#define MUSB_RXCSR		0x06
-#define MUSB_RXCOUNT		0x08
-#define MUSB_COUNT0		MUSB_RXCOUNT	/* Re-used for EP0 */
-#define MUSB_TXTYPE		0x0A
-#define MUSB_TYPE0		MUSB_TXTYPE	/* Re-used for EP0 */
-#define MUSB_TXINTERVAL		0x0B
-#define MUSB_NAKLIMIT0		MUSB_TXINTERVAL	/* Re-used for EP0 */
-#define MUSB_RXTYPE		0x0C
-#define MUSB_RXINTERVAL		0x0D
-#define MUSB_FIFOSIZE		0x0F
-#define MUSB_CONFIGDATA		MUSB_FIFOSIZE	/* Re-used for EP0 */
-
-/* Offsets to endpoint registers in indexed model (using INDEX register) */
-#define MUSB_INDEXED_OFFSET(_epnum, _offset)	\
-	(0x10 + (_offset))
-
-/* Offsets to endpoint registers in flat models */
-#define MUSB_FLAT_OFFSET(_epnum, _offset)	\
-	(0x100 + (0x10*(_epnum)) + (_offset))
-
-#ifdef CONFIG_USB_TUSB6010
-/* TUSB6010 EP0 configuration register is special */
-#define MUSB_TUSB_OFFSET(_epnum, _offset)	\
-	(0x10 + _offset)
-#include "tusb6010.h"		/* Needed "only" for TUSB_EP0_CONF */
-#endif
-
-/* "bus control"/target registers, for host side multipoint (external hubs) */
-#define MUSB_TXFUNCADDR		0x00
-#define MUSB_TXHUBADDR		0x02
-#define MUSB_TXHUBPORT		0x03
-
-#define MUSB_RXFUNCADDR		0x04
-#define MUSB_RXHUBADDR		0x06
-#define MUSB_RXHUBPORT		0x07
-
-#define MUSB_BUSCTL_OFFSET(_epnum, _offset) \
-	(0x80 + (8*(_epnum)) + (_offset))
-
-/*
  * MUSB Register bits
  */
 
@@ -228,7 +137,6 @@
 
 /* TXCSR in Peripheral and Host mode */
 #define MUSB_TXCSR_AUTOSET		0x8000
-#define MUSB_TXCSR_MODE			0x2000
 #define MUSB_TXCSR_DMAENAB		0x1000
 #define MUSB_TXCSR_FRCDATATOG		0x0800
 #define MUSB_TXCSR_DMAMODE		0x0400
@@ -297,4 +205,265 @@
 /* HUBADDR */
 #define MUSB_HUBADDR_MULTI_TT		0x80
 
+
+#ifndef CONFIG_BLACKFIN
+
+/*
+ * Common USB registers
+ */
+
+#define MUSB_FADDR		0x00	/* 8-bit */
+#define MUSB_POWER		0x01	/* 8-bit */
+
+#define MUSB_INTRTX		0x02	/* 16-bit */
+#define MUSB_INTRRX		0x04
+#define MUSB_INTRTXE		0x06
+#define MUSB_INTRRXE		0x08
+#define MUSB_INTRUSB		0x0A	/* 8 bit */
+#define MUSB_INTRUSBE		0x0B	/* 8 bit */
+#define MUSB_FRAME		0x0C
+#define MUSB_INDEX		0x0E	/* 8 bit */
+#define MUSB_TESTMODE		0x0F	/* 8 bit */
+
+/* Get offset for a given FIFO from musb->mregs */
+#ifdef	CONFIG_USB_TUSB6010
+#define MUSB_FIFO_OFFSET(epnum)	(0x200 + ((epnum) * 0x20))
+#else
+#define MUSB_FIFO_OFFSET(epnum)	(0x20 + ((epnum) * 4))
+#endif
+
+/*
+ * Additional Control Registers
+ */
+
+#define MUSB_DEVCTL		0x60	/* 8 bit */
+
+/* These are always controlled through the INDEX register */
+#define MUSB_TXFIFOSZ		0x62	/* 8-bit (see masks) */
+#define MUSB_RXFIFOSZ		0x63	/* 8-bit (see masks) */
+#define MUSB_TXFIFOADD		0x64	/* 16-bit offset shifted right 3 */
+#define MUSB_RXFIFOADD		0x66	/* 16-bit offset shifted right 3 */
+
+/* REVISIT: vctrl/vstatus: optional vendor utmi+phy register at 0x68 */
+#define MUSB_HWVERS		0x6C	/* 8 bit */
+
+#define MUSB_EPINFO		0x78	/* 8 bit */
+#define MUSB_RAMINFO		0x79	/* 8 bit */
+#define MUSB_LINKINFO		0x7a	/* 8 bit */
+#define MUSB_VPLEN		0x7b	/* 8 bit */
+#define MUSB_HS_EOF1		0x7c	/* 8 bit */
+#define MUSB_FS_EOF1		0x7d	/* 8 bit */
+#define MUSB_LS_EOF1		0x7e	/* 8 bit */
+
+/* Offsets to endpoint registers */
+#define MUSB_TXMAXP		0x00
+#define MUSB_TXCSR		0x02
+#define MUSB_CSR0		MUSB_TXCSR	/* Re-used for EP0 */
+#define MUSB_RXMAXP		0x04
+#define MUSB_RXCSR		0x06
+#define MUSB_RXCOUNT		0x08
+#define MUSB_COUNT0		MUSB_RXCOUNT	/* Re-used for EP0 */
+#define MUSB_TXTYPE		0x0A
+#define MUSB_TYPE0		MUSB_TXTYPE	/* Re-used for EP0 */
+#define MUSB_TXINTERVAL		0x0B
+#define MUSB_NAKLIMIT0		MUSB_TXINTERVAL	/* Re-used for EP0 */
+#define MUSB_RXTYPE		0x0C
+#define MUSB_RXINTERVAL		0x0D
+#define MUSB_FIFOSIZE		0x0F
+#define MUSB_CONFIGDATA		MUSB_FIFOSIZE	/* Re-used for EP0 */
+
+/* Offsets to endpoint registers in indexed model (using INDEX register) */
+#define MUSB_INDEXED_OFFSET(_epnum, _offset)	\
+	(0x10 + (_offset))
+
+/* Offsets to endpoint registers in flat models */
+#define MUSB_FLAT_OFFSET(_epnum, _offset)	\
+	(0x100 + (0x10*(_epnum)) + (_offset))
+
+#ifdef CONFIG_USB_TUSB6010
+/* TUSB6010 EP0 configuration register is special */
+#define MUSB_TUSB_OFFSET(_epnum, _offset)	\
+	(0x10 + _offset)
+#include "tusb6010.h"		/* Needed "only" for TUSB_EP0_CONF */
+#endif
+
+#define MUSB_TXCSR_MODE			0x2000
+
+/* "bus control"/target registers, for host side multipoint (external hubs) */
+#define MUSB_TXFUNCADDR		0x00
+#define MUSB_TXHUBADDR		0x02
+#define MUSB_TXHUBPORT		0x03
+
+#define MUSB_RXFUNCADDR		0x04
+#define MUSB_RXHUBADDR		0x06
+#define MUSB_RXHUBPORT		0x07
+
+#define MUSB_BUSCTL_OFFSET(_epnum, _offset) \
+	(0x80 + (8*(_epnum)) + (_offset))
+
+static inline void musb_write_txfifosz(void __iomem *mbase, u8 c_size)
+{
+	musb_writeb(mbase, MUSB_TXFIFOSZ, c_size);
+}
+
+static inline void musb_write_txfifoadd(void __iomem *mbase, u16 c_off)
+{
+	musb_writew(mbase, MUSB_TXFIFOADD, c_off);
+}
+
+static inline void musb_write_rxfifosz(void __iomem *mbase, u8 c_size)
+{
+	musb_writeb(mbase, MUSB_RXFIFOSZ, c_size);
+}
+
+static inline void  musb_write_rxfifoadd(void __iomem *mbase, u16 c_off)
+{
+	musb_writew(mbase, MUSB_RXFIFOADD, c_off);
+}
+
+static inline u8 musb_read_configdata(void __iomem *mbase)
+{
+	return musb_readb(mbase, 0x10 + MUSB_CONFIGDATA);
+}
+
+static inline u16 musb_read_hwvers(void __iomem *mbase)
+{
+	return musb_readw(mbase, MUSB_HWVERS);
+}
+
+static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase)
+{
+	return (MUSB_BUSCTL_OFFSET(i, 0) + mbase);
+}
+
+static inline void musb_write_rxfunaddr(void __iomem *ep_target_regs,
+		u8 qh_addr_req)
+{
+	musb_writeb(ep_target_regs, MUSB_RXFUNCADDR, qh_addr_reg);
+}
+
+static inline void musb_write_rxhubaddr(void __iomem *ep_target_regs,
+		u8 qh_h_addr_reg)
+{
+	musb_writeb(ep_target_regs, MUSB_RXHUBADDR, qh_h_addr_reg);
+}
+
+static inline void musb_write_rxhubport(void __iomem *ep_target_regs,
+		u8 qh_h_port_reg)
+{
+	musb_writeb(ep_target_regs, MUSB_RXHUBPORT, qh_h_port_reg);
+}
+
+static inline void  musb_write_txfunaddr(void __iomem *mbase, u8 epnum,
+		u8 qh_addr_reg)
+{
+	musb_writeb(mbase, MUSB_BUSCTL_OFFSET(epnum, MUSB_TXFUNCADDR),
+			qh_addr_reg);
+}
+
+static inline void  musb_write_txhubaddr(void __iomem *mbase, u8 epnum,
+		u8 qh_addr_reg)
+{
+	musb_writeb(mbase, MUSB_BUSCTL_OFFSET(epnum, MUSB_TXHUBADDR),
+			qh_h_addr_reg);
+}
+
+static inline void  musb_write_txhubport(void __iomem *mbase, u8 epnum,
+		u8 qh_h_port_reg)
+{
+	musb_writeb(mbase, MUSB_BUSCTL_OFFSET(epnum, MUSB_TXHUBPORT),
+			qh_h_port_reg);
+}
+
+#else /* CONFIG_BLACKFIN */
+
+#define USB_BASE		USB_FADDR
+#define USB_OFFSET(reg)		(reg - USB_BASE)
+
+/*
+ * Common USB registers
+ */
+#define MUSB_FADDR		USB_OFFSET(USB_FADDR)	/* 8-bit */
+#define MUSB_POWER		USB_OFFSET(USB_POWER)	/* 8-bit */
+#define MUSB_INTRTX		USB_OFFSET(USB_INTRTX)	/* 16-bit */
+#define MUSB_INTRRX		USB_OFFSET(USB_INTRRX)
+#define MUSB_INTRTXE		USB_OFFSET(USB_INTRTXE)
+#define MUSB_INTRRXE		USB_OFFSET(USB_INTRRXE)
+#define MUSB_INTRUSB		USB_OFFSET(USB_INTRUSB)	/* 8 bit */
+#define MUSB_INTRUSBE		USB_OFFSET(USB_INTRUSBE)/* 8 bit */
+#define MUSB_FRAME		USB_OFFSET(USB_FRAME)
+#define MUSB_INDEX		USB_OFFSET(USB_INDEX)	/* 8 bit */
+#define MUSB_TESTMODE		USB_OFFSET(USB_TESTMODE)/* 8 bit */
+
+/* Get offset for a given FIFO from musb->mregs */
+#define MUSB_FIFO_OFFSET(epnum)	\
+	(USB_OFFSET(USB_EP0_FIFO) + ((epnum) * 8))
+
+/*
+ * Additional Control Registers
+ */
+
+#define MUSB_DEVCTL		USB_OFFSET(USB_OTG_DEV_CTL)	/* 8 bit */
+
+#define MUSB_LINKINFO		USB_OFFSET(USB_LINKINFO)/* 8 bit */
+#define MUSB_VPLEN		USB_OFFSET(USB_VPLEN)	/* 8 bit */
+#define MUSB_HS_EOF1		USB_OFFSET(USB_HS_EOF1)	/* 8 bit */
+#define MUSB_FS_EOF1		USB_OFFSET(USB_FS_EOF1)	/* 8 bit */
+#define MUSB_LS_EOF1		USB_OFFSET(USB_LS_EOF1)	/* 8 bit */
+
+/* Offsets to endpoint registers */
+#define MUSB_TXMAXP		0x00
+#define MUSB_TXCSR		0x04
+#define MUSB_CSR0		MUSB_TXCSR	/* Re-used for EP0 */
+#define MUSB_RXMAXP		0x08
+#define MUSB_RXCSR		0x0C
+#define MUSB_RXCOUNT		0x10
+#define MUSB_COUNT0		MUSB_RXCOUNT	/* Re-used for EP0 */
+#define MUSB_TXTYPE		0x14
+#define MUSB_TYPE0		MUSB_TXTYPE	/* Re-used for EP0 */
+#define MUSB_TXINTERVAL		0x18
+#define MUSB_NAKLIMIT0		MUSB_TXINTERVAL	/* Re-used for EP0 */
+#define MUSB_RXTYPE		0x1C
+#define MUSB_RXINTERVAL		0x20
+#define MUSB_TXCOUNT		0x28
+
+/* Offsets to endpoint registers in indexed model (using INDEX register) */
+#define MUSB_INDEXED_OFFSET(_epnum, _offset)	\
+	(0x40 + (_offset))
+
+/* Offsets to endpoint registers in flat models */
+#define MUSB_FLAT_OFFSET(_epnum, _offset)	\
+	(USB_OFFSET(USB_EP_NI0_TXMAXP) + (0x40 * (_epnum)) + (_offset))
+
+/* Not implemented - HW has seperate Tx/Rx FIFO */
+#define MUSB_TXCSR_MODE			0x0000
+
+/*
+ * Dummy stub for clk framework, it will be removed
+ * until Blackfin supports clk framework
+ */
+#define clk_get(dev, id)	NULL
+#define clk_put(clock)		do {} while (0)
+#define clk_enable(clock)	do {} while (0)
+#define clk_disable(clock)	do {} while (0)
+
+#define musb_write_txfifosz(mbase, c_size)	do {} while (0)
+#define musb_write_txfifoadd(mbase, c_off)	do {} while (0)
+#define musb_write_rxfifosz(mbase, c_size)	do {} while (0)
+#define musb_write_rxfifoadd(mbase, c_off)	do {} while (0)
+
+#define musb_read_configdata(mbase)	0
+#define musb_read_hwvers(mbase)		0
+#define musb_read_target_reg_base(i, mbase)	0
+
+#define musb_write_rxfunaddr(ep_target_regs, qh_addr_reg)	do {} while (0)
+#define musb_write_rxhubaddr(ep_target_regs, qh_h_addr_reg)	do {} while (0)
+#define musb_write_rxhubport(ep_target_regs, qh_h_port_reg)	do {} while (0)
+
+#define musb_write_txfunaddr(mbase, epnum, qh_addr_reg)		do {} while (0)
+#define musb_write_txhubaddr(mbase, epnum, qh_h_addr_reg)	do {} while (0)
+#define musb_write_txhubport(mbase, epnum, qh_h_port_reg)	do {} while (0)
+
+#endif /* CONFIG_BLACKFIN */
+
 #endif	/* __MUSB_REGS_H__ */
-- 
1.5.6.3
