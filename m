Return-Path: <linux-kernel-owner+w=401wt.eu-S967953AbXEHFae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967953AbXEHFae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967879AbXEHFaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:30:30 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:52205 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S967049AbXEHFa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:30:29 -0400
To: Samuel Ortiz <samuel@sortiz.org>
Cc: linuxppc-dev@ozlabs.org
Cc: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH] [POWERPC] 8xx: PQ SoC IRDA support
Date: Tue, 08 May 2007 09:27:23 +0400
Message-ID: <20070508052723.18404.8216.stgit@localhost.localdomain>
User-Agent: StGIT/0.11
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Adds support of IRDA transceiver residing on PowerQUICC processors and
enabling such on mpc885ads reference board. The driver is implemented 
using of_device concept, hereby implies arch/powerpc support of the target.

Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

---

 arch/powerpc/Kconfig                         |    1 
 arch/powerpc/boot/dts/mpc885ads.dts          |   10 
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |   39 +
 arch/powerpc/sysdev/fsl_soc.c                |   58 ++
 drivers/net/irda/Kconfig                     |    4 
 drivers/net/irda/Makefile                    |    1 
 drivers/net/irda/m8xx-sir.c                  |  715 ++++++++++++++++++++++++++
 include/asm-ppc/commproc.h                   |   67 ++
 8 files changed, 895 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a8e08f4..c283907 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -605,6 +605,7 @@ endmenu
 config ISA_DMA_API
 	bool
 	default y
+	depends on !PPC_8xx
 
 menu "Bus options"
 
diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index 110bf61..95b280c 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -178,6 +178,16 @@
 				interrupt-parent = <930>;
 				phy-handle = <e8002>;
 			};
+
+			scc@a20 {
+				device_type = "network";
+				compatible = "fsl,irda";
+				model = "SCC";
+				device-id = <2>;
+				reg = <a20 18 3d00 80>;
+				interrupts = <1d 3>;
+				interrupt-parent = <930>;
+			};
 		};
 	};
 };
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index a57b577..8611318 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -50,6 +50,7 @@ extern unsigned int mpc8xx_get_irq(void);
 static void init_smc1_uart_ioports(struct fs_uart_platform_info* fpi);
 static void init_smc2_uart_ioports(struct fs_uart_platform_info* fpi);
 static void init_scc3_ioports(struct fs_platform_info* ptr);
+static void init_irda_ioports(void);
 
 void __init mpc885ads_board_setup(void)
 {
@@ -115,6 +116,10 @@ void __init mpc885ads_board_setup(void)
 	immr_unmap(io_port);
 
 #endif
+
+#ifdef CONFIG_8XX_SIR
+	init_irda_ioports();
+#endif
 }
 
 
@@ -322,6 +327,40 @@ void init_smc_ioports(struct fs_uart_platform_info *data)
 	}
 }
 
+static void init_irda_ioports()
+{
+	iop8xx_t *io_port;
+	cpm8xx_t *cp;
+	unsigned *bcsr_io;
+
+	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
+
+	if (bcsr_io == NULL) {
+		printk(KERN_CRIT "Could not remap BCSR1\n");
+		return;
+	}
+
+	/* Enable the IRDA. */
+	clrbits32(bcsr_io,BCSR1_IRDAEN);
+	iounmap(bcsr_io);
+
+	io_port = (iop8xx_t *)immr_map(im_ioport);
+	cp = (cpm8xx_t *)immr_map(im_cpm);
+
+	/* Configure port A pins. */
+	setbits16(&io_port->iop_papar, 0x000c);
+	clrbits16(&io_port->iop_padir, 0x000c);
+
+	/* Configure Serial Interface clock routing.
+	 * First, clear all SCC bits to zero, then set the ones we want.
+	 */
+	clrbits32(&cp->cp_sicr, 0x0000ff00);
+	setbits32(&cp->cp_sicr, 0x00001200);
+
+	immr_unmap(io_port);
+	immr_unmap(cp);
+}
+
 int platform_device_skip(const char *model, int id)
 {
 #ifdef CONFIG_MPC8xx_SECOND_ETH_SCC3
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 8a123c7..f827147 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -1102,4 +1102,62 @@ err:
 
 arch_initcall(cpm_smc_uart_of_init);
 
+static const char *irda_regs = "regs";
+static const char *irda_pram = "pram";
+static const char *irda_irq = "interrupt";
+static char bus_id[9][BUS_ID_SIZE];
+
+static int __init fs_irda_of_init(void)
+{
+	struct device_node *np;
+	unsigned int i;
+	struct platform_device *fs_irda_dev = NULL;
+	int ret;
+
+	for (np = NULL, i = 0;
+	     (np = of_find_compatible_node(np, "network", "fsl,irda")) != NULL;
+	     i++) {
+		struct resource r[4];
+		unsigned int *id;
+		char *model;
+
+		memset(r, 0, sizeof(r));
+
+		model = (char *)get_property(np, "model", NULL);
+		if (model == NULL)
+			return -ENODEV;
+
+		id = (u32 *) get_property(np, "device-id", NULL);
+		if (platform_device_skip(model, *id))
+			continue;
+
+		ret = of_address_to_resource(np, 0, &r[0]);
+		if (ret)
+			return ret;
+		r[0].name = irda_regs;
+
+		if (strstr(model, "SCC")) {
+			ret = of_address_to_resource(np, 1, &r[1]);
+			if (ret)
+				return ret;
+			r[1].name = irda_pram;
+
+			r[2].start = r[2].end = irq_of_parse_and_map(np, 0);
+			r[2].flags = IORESOURCE_IRQ;
+			r[2].name = irda_irq;
+
+			fs_irda_dev =
+				    platform_device_register_simple("fsl-cpm-scc:irda", i, &r[0], 3);
+
+			if (IS_ERR(fs_irda_dev)) {
+				ret = PTR_ERR(fs_irda_dev);
+				return ret;
+			}
+		}
+	}
+	return 0;
+}
+
+arch_initcall(fs_irda_of_init);
+
 #endif /* CONFIG_8xx */
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 7c8ccc0..b3681e7 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -17,6 +17,10 @@ config IRTTY_SIR
 
 	  If unsure, say Y.
 
+config 8XX_SIR
+	  tristate "mpc8xx SIR"
+	  depends on 8xx && IRDA
+
 comment "Dongle support"
 
 config DONGLE
diff --git a/drivers/net/irda/Makefile b/drivers/net/irda/Makefile
index 5be09f1..fc7c0fd 100644
--- a/drivers/net/irda/Makefile
+++ b/drivers/net/irda/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_EP7211_IR)		+= ep7211_ir.o
 obj-$(CONFIG_AU1000_FIR)	+= au1k_ir.o
 # New SIR drivers
 obj-$(CONFIG_IRTTY_SIR)		+= irtty-sir.o	sir-dev.o
+obj-$(CONFIG_8XX_SIR)		+= m8xx-sir.o
 # New dongles drivers for new SIR drivers
 obj-$(CONFIG_ESI_DONGLE)	+= esi-sir.o
 obj-$(CONFIG_TEKRAM_DONGLE)	+= tekram-sir.o
diff --git a/drivers/net/irda/m8xx-sir.c b/drivers/net/irda/m8xx-sir.c
new file mode 100644
index 0000000..6fb215f
--- /dev/null
+++ b/drivers/net/irda/m8xx-sir.c
@@ -0,0 +1,715 @@
+/*
+ * Infra-red SIR driver for the MPC8xx processors.
+ *
+ * Copyright (c) 2005-2007 MontaVista Software Inc.
+ * Author: Yuri Shpilevsky <source@mvista.com>
+ *
+ *     This program is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of
+ *     the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/rtnetlink.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+
+#include <net/irda/irda.h>
+#include <net/irda/irmod.h>
+#include <net/irda/wrapper.h>
+#include <net/irda/irda_device.h>
+
+#include <asm/io.h>
+#include <asm/cacheflush.h>
+#include <asm/irq.h>
+#include <asm/8xx_immap.h>
+#include <asm/pgtable.h>
+#include <asm/mpc8xx.h>
+#include <asm/bitops.h>
+#include <asm/uaccess.h>
+#include <asm/commproc.h>
+#include <asm/fs_pd.h>
+
+/*
+ * Our netdevice.  There is only ever one of these.
+ */
+
+#define CPM_IRDA_RX_PAGES       4
+#define CPM_IRDA_RX_FRSIZE      2048
+#define CPM_IRDA_RX_FRPPG       (PAGE_SIZE / CPM_IRDA_RX_FRSIZE)
+#define RX_RING_SIZE            (CPM_IRDA_RX_FRPPG * CPM_IRDA_RX_PAGES)
+#define TX_RING_SIZE            8	/* Must be power of two */
+#define TX_RING_MOD_MASK        7
+
+struct mpc8xx_irda {
+	unsigned char open;
+
+	int speed;
+	int newspeed;
+
+	/* The saved address of a sent-in-place packet/buffer, for skfree().
+	 */
+	struct sk_buff *tx_skbuff[TX_RING_SIZE];
+	ushort skb_cur;
+	ushort skb_dirty;
+
+	struct net_device_stats stats;
+	struct device *dev;
+	struct irda_platform_data *pdata;
+	struct irlap_cb *irlap;
+	struct qos_info qos;
+
+	scc_t *sccp;
+	scc_ahdlc_t *ahp;
+	int irq;
+	cbd_t *rx_bd_base;
+	cbd_t *tx_bd_base;
+	cbd_t *dirty_tx;
+	cbd_t *cur_rx, *cur_tx;	/* The next free ring entry */
+	unsigned char *rx_vaddr[RX_RING_SIZE];
+	int tx_free;
+	spinlock_t lock;
+};
+
+#define HPSIR_MAX_RXLEN		2050
+#define HPSIR_MAX_TXLEN		2050
+#define TXBUFF_MAX_SIZE		HPSIR_MAX_TXLEN
+
+static void mpc8xx_irda_set_speed(struct net_device *dev, int speed);
+
+/************************************************************************************/
+
+/* Low level init/uninstall function IrDA protocol stack registration
+ */
+
+static void mpc8xx_irda_rx(struct net_device *dev)
+{
+	struct mpc8xx_irda *si = dev->priv;
+	cbd_t *bdp;
+	struct sk_buff *skb;
+	int len;
+	ushort status;
+
+	bdp = si->cur_rx;
+
+	for (;;) {
+		if (bdp->cbd_sc & BD_AHDLC_RX_EMPTY)
+			break;
+		status = bdp->cbd_sc;
+
+		if (status & BD_AHDLC_RX_STATS) {
+			/* process errors
+			 */
+			if (bdp->cbd_sc & BD_AHDLC_RX_AB)
+				si->stats.rx_length_errors++;
+			if (bdp->cbd_sc & BD_AHDLC_RX_CR)	/* CRC Error */
+				si->stats.rx_crc_errors++;
+			if (bdp->cbd_sc & BD_AHDLC_RX_OV)	/* FIFO overrun */
+				si->stats.rx_over_errors++;
+		} else {
+			/* Process the incoming frame.
+			 */
+			len = bdp->cbd_datlen;
+
+			skb = dev_alloc_skb(len + 1);
+			if (skb == NULL) {
+				printk(KERN_INFO
+				       "%s: Memory squeeze, dropping packet.\n",
+				       dev->name);
+				si->stats.rx_dropped++;
+			} else {
+				skb->dev = dev;
+				skb_reserve(skb, 1);
+				memcpy(skb_put(skb, len),
+				       si->rx_vaddr[bdp - si->rx_bd_base], len);
+				skb_trim(skb, skb->len - 2);
+
+				si->stats.rx_packets++;
+				si->stats.rx_bytes += len;
+
+				skb->mac.raw = skb->data;
+				skb->protocol = htons(ETH_P_IRDA);
+				netif_rx(skb);
+			}
+		}
+
+		/* Clear the status flags for this buffer.
+		 */
+		bdp->cbd_sc &= ~BD_AHDLC_RX_STATS;
+
+		/* Mark the buffer empty.
+		 */
+		bdp->cbd_sc |= BD_AHDLC_RX_EMPTY;
+
+		/* Update BD pointer to next entry.
+		 */
+		if (bdp->cbd_sc & BD_AHDLC_RX_WRAP)
+			bdp = si->rx_bd_base;
+		else
+			bdp++;
+	}
+	si->cur_rx = (cbd_t *) bdp;
+}
+
+static irqreturn_t mpc8xx_irda_irq(int irq, void *dev_id)
+{
+	struct net_device *dev = dev_id;
+	struct mpc8xx_irda *si = dev->priv;
+	scc_t *sccp = si->sccp;
+	cbd_t *bdp;
+	ushort int_events;
+	int must_restart = 0;
+
+	/* Get the interrupt events that caused us to be here.
+	 */
+	int_events = in_be16(&sccp->scc_scce);
+	out_be16(&sccp->scc_scce, int_events);
+
+	/* Handle receive event in its own function.
+	 */
+	if (int_events & SCC_AHDLC_RXF)
+		mpc8xx_irda_rx(dev);
+
+	spin_lock(&si->lock);
+
+	/* Transmit OK, or non-fatal error.  Update the buffer descriptors.
+	 */
+	if (int_events & (SCC_AHDLC_TXE | SCC_AHDLC_TXB)) {
+		bdp = si->dirty_tx;
+
+		while ((bdp->cbd_sc & BD_AHDLC_TX_READY) == 0) {
+			if (si->tx_free == TX_RING_SIZE)
+				break;
+
+			if (bdp->cbd_sc & BD_AHDLC_TX_CTS)
+				must_restart = 1;
+
+			si->stats.tx_packets++;
+
+			/* Free the sk buffer associated with this last transmit.
+			 */
+			dev_kfree_skb_irq(si->tx_skbuff[si->skb_dirty]);
+			si->skb_dirty = (si->skb_dirty + 1) & TX_RING_MOD_MASK;
+
+			/* Update pointer to next buffer descriptor to be transmitted.
+			 */
+			if (bdp->cbd_sc & BD_AHDLC_TX_WRAP)
+				bdp = si->tx_bd_base;
+			else
+				bdp++;
+
+			/* Since we have freed up a buffer, the ring is no longer full.
+			 */
+			if (!si->tx_free++) {
+				if (netif_queue_stopped(dev))
+					netif_wake_queue(dev);
+			}
+
+			si->dirty_tx = (cbd_t *) bdp;
+
+			if (si->newspeed) {
+				mpc8xx_irda_set_speed(dev, si->newspeed);
+				si->speed = si->newspeed;
+				si->newspeed = 0;
+			}
+		}
+
+		if (must_restart) {
+			cpm8xx_t *cp = immr_map(im_cpm);
+			printk(KERN_INFO "restart TX\n");
+
+			/* Some transmit errors cause the transmitter to shut
+			 * down.  We now issue a restart transmit.  Since the
+			 * errors close the BD and update the pointers, the restart
+			 * _should_ pick up without having to reset any of our
+			 * pointers either.
+			 */
+			out_be16(&cp->cp_cpcr,
+			    mk_cr_cmd(CPM_CR_CH_SCC2,
+				      CPM_CR_RESTART_TX) | CPM_CR_FLG);
+			while (in_be16(&cp->cp_cpcr) & CPM_CR_FLG) ;
+		}
+	}
+
+	spin_unlock(&si->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int mpc8xx_irda_hard_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct mpc8xx_irda *si = dev->priv;
+	volatile scc_ahdlc_t *ahp = si->ahp;
+	int speed = irda_get_next_speed(skb);
+	cbd_t *bdp;
+	int mtt;
+	u16 xbofs;
+	unsigned long flags;
+
+	/*
+	 * Does this packet contain a request to change the interface
+	 * speed?  If so, remember it until we complete the transmission
+	 * of this frame.
+	 */
+	if (speed != si->speed && speed != -1)
+		si->newspeed = speed;
+
+	mtt = irda_get_mtt(skb);
+
+	spin_lock_irqsave(&si->lock, flags);
+
+	/*
+	 * If this is an empty frame, we can bypass a lot.
+	 */
+	if (skb->len == 0) {
+		if (si->newspeed) {
+			si->newspeed = 0;
+			mpc8xx_irda_set_speed(dev, speed);
+		}
+		spin_unlock_irqrestore(&si->lock, flags);
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
+	/* Get a Tx ring entry */
+	bdp = si->cur_tx;
+
+	/* Clear all of the status flags.
+	 */
+	bdp->cbd_sc &= ~BD_AHDLC_TX_STATS;
+
+	/* Set xbofs
+	 */
+	{
+		struct irda_skb_cb *cb = (struct irda_skb_cb *)skb->cb;
+		xbofs =
+		    (cb->magic != LAP_MAGIC) ? 10 : cb->xbofs + cb->xbofs_delay;
+		xbofs = (xbofs > 163) ? 163 : xbofs;
+		out_be16(&ahp->ahdlc_nof, xbofs);
+	}
+
+	/* Set buffer length and buffer pointer.
+	 */
+	bdp->cbd_datlen = skb->len;
+	bdp->cbd_bufaddr = __pa(skb->data);
+
+	/* Push the data cache so the CPM does not get stale memory data.
+	 */
+	flush_dcache_range((unsigned long)(skb->data),
+			   (unsigned long)(skb->data + skb->len));
+
+	/* Save skb pointer.
+	 */
+	si->tx_skbuff[si->skb_cur] = skb;
+
+	si->stats.tx_bytes += skb->len;
+	si->skb_cur = (si->skb_cur + 1) & TX_RING_MOD_MASK;
+
+	/* If we have a mean turn-around time, impose the specified
+	 * specified delay.  We could shorten this by timing from
+	 * the point we received the packet.
+	 */
+	if (mtt > 0)
+		udelay(mtt);
+
+	/* Send it on its way.  Tell CPM its ready, interrupt when done,
+	 * its the last BD of the frame, and to put the CRC on the end.
+	 */
+	bdp->cbd_sc |=
+	    (BD_AHDLC_TX_READY | BD_AHDLC_TX_INTR | BD_AHDLC_TX_LAST);
+
+	dev->trans_start = jiffies;
+
+	/* If this was the last BD in the ring, start at the beginning again.
+	 */
+	if (bdp->cbd_sc & BD_AHDLC_TX_WRAP)
+		bdp = si->tx_bd_base;
+	else
+		bdp++;
+
+	spin_unlock_irqrestore(&si->lock, flags);
+
+	if (!--si->tx_free)
+		netif_stop_queue(dev);
+
+	si->cur_tx = (cbd_t *) bdp;
+
+	return 0;
+}
+
+static int
+mpc8xx_irda_ioctl(struct net_device *dev, struct ifreq *ifreq, int cmd)
+{
+	struct if_irda_req *rq = (struct if_irda_req *)ifreq;
+	struct mpc8xx_irda *si = dev->priv;
+	int ret = -EOPNOTSUPP;
+
+	switch (cmd) {
+	case SIOCSBANDWIDTH:
+		if (capable(CAP_NET_ADMIN)) {
+			/* We are unable to set the speed if the
+			 * device is not running.
+			 */
+			if (si->open)
+				mpc8xx_irda_set_speed(dev, rq->ifr_baudrate);
+			else
+				printk(KERN_INFO
+				       "mpc8xx_irda_ioctl: SIOCSBANDWIDTH: !netif_running\n");
+			ret = 0;
+		}
+		break;
+
+	case SIOCSMEDIABUSY:
+		ret = -EPERM;
+		if (capable(CAP_NET_ADMIN)) {
+			irda_device_set_media_busy(dev, TRUE);
+			ret = 0;
+		}
+		break;
+
+	case SIOCGRECEIVING:
+		rq->ifr_receiving = 0;
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static struct net_device_stats *mpc8xx_irda_stats(struct net_device *ndev)
+{
+	struct mpc8xx_irda *si = ndev->priv;
+	return &si->stats;
+}
+
+static int mpc8xx_irda_pd_setup(struct mpc8xx_irda *si)
+{
+	struct platform_device *pdev = to_platform_device(si->dev);
+	struct resource *r;
+
+	/* Fill out IRQ field */
+	si->irq = platform_get_irq_byname(pdev, "interrupt");
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	si->sccp = ioremap(r->start, r->end - r->start + 1);
+
+	if (si->sccp == NULL)
+		return -EINVAL;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pram");
+	si->ahp = ioremap(r->start, r->end - r->start + 1);
+
+	if (si->ahp == NULL)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int mpc8xx_irda_startup(struct net_device *dev)
+{
+	struct mpc8xx_irda *si = dev->priv;
+	cbd_t *bdp;
+	volatile cpm8xx_t *cp = immr_map(im_cpm);
+	scc_t *sccp;
+	volatile scc_ahdlc_t *ahp;
+	dma_addr_t mem_addr;
+	int i, j, k;
+	unsigned char *ba;
+	int err = -ENOMEM;
+
+	spin_lock_init(&si->lock);
+
+	if ((err = mpc8xx_irda_pd_setup(si)))
+		return err;
+
+	sccp = si->sccp;
+	ahp = si->ahp;
+
+	/* Disable receive and transmit.
+	 */
+	clrbits32(&sccp->scc_gsmrl, SCC_GSMRL_ENR | SCC_GSMRL_ENT);
+
+	/* Allocate space for the buffer descriptors in the DP ram.
+	 * These are relative offsets in the DP ram address space.
+	 * Initialize base addresses for the buffer descriptors.
+	 */
+	i = cpm_dpalloc(sizeof(cbd_t) * RX_RING_SIZE, 8);
+	out_be16(&ahp->scc_genscc.scc_rbase, i);
+	si->rx_bd_base = cpm_dpram_addr(i);
+	si->cur_rx = si->rx_bd_base;
+
+	i = cpm_dpalloc(sizeof(cbd_t) * TX_RING_SIZE, 8);
+	out_be16(&ahp->scc_genscc.scc_tbase, i);
+	si->tx_bd_base = cpm_dpram_addr(i);
+	si->dirty_tx = si->cur_tx = si->tx_bd_base;
+	si->tx_free = TX_RING_SIZE;
+
+	/* Issue init Tx and Rx BD command for SCC2.
+	 */
+	out_be16(&cp->cp_cpcr, mk_cr_cmd(CPM_CR_CH_SCC2, CPM_CR_INIT_TRX) | CPM_CR_FLG);
+	while (in_be16(&cp->cp_cpcr) & CPM_CR_FLG) ;
+
+	si->skb_cur = si->skb_dirty = 0;
+
+	/* Initialize function code registers for big-endian.
+	 */
+	out_8(&ahp->scc_genscc.scc_rfcr, SCC_EB);
+	out_8(&ahp->scc_genscc.scc_tfcr, SCC_EB);
+
+	/* Set maximum bytes per receive buffer.
+	 * This appears to be an Ethernet frame size, not the buffer
+	 * fragment size.  It must be a multiple of four.
+	 */
+	out_be16(&ahp->scc_genscc.scc_mrblr, 14384);
+
+	/* Set CRC preset and mask.
+	 */
+	out_be32(&ahp->ahdlc_cpres, 0x0000ffff);
+	out_be32(&ahp->ahdlc_cmask, 0x0000f0b8);
+
+	/* Clear zero register.
+	 */
+	out_be16(&ahp->ahdlc_zero, 0);
+
+	/* Program RFTHR to the number of frames to be received
+	 * before generating an interrupt.
+	 */
+	out_be16(&ahp->ahdlc_rfthr, 1);
+
+	/* Program the control character tables, TXCTL_TBL and RXCTL_TBL.
+	 */
+	out_be32(&ahp->ahdlc_txctl_tbl, 0);	// initialized to zero for IrLAP.
+	out_be32(&ahp->ahdlc_rxctl_tbl, 0);	// initialized to zero for IrLAP.
+
+	out_be16(&ahp->ahdlc_bof, 0xC0);	//IRLAP_BOF; /* Begin. of Flag Char */
+	out_be16(&ahp->ahdlc_eof, 0xC1);	//IRLAP_EOF; /* End of Flag Char */
+	out_be16(&ahp->ahdlc_esc, 0x7D);	//IRLAP_ESC; /* Control Escape Char */
+	out_be16(&ahp->ahdlc_nof, 12);
+
+	/* Now allocate the host memory pages and initialize the
+	 * buffer descriptors.
+	 */
+	bdp = si->tx_bd_base;
+	for (i = 0; i < TX_RING_SIZE; i++) {
+		/* Initialize the BD for every fragment in the page.
+		 */
+		bdp->cbd_sc = 0;
+		bdp->cbd_bufaddr = 0;
+		bdp++;
+	}
+
+	/* Set the last buffer to wrap.
+	 */
+	bdp--;
+	bdp->cbd_sc |= BD_SC_WRAP;
+
+	bdp = si->rx_bd_base;
+	k = 0;
+	for (i = 0; i < CPM_IRDA_RX_PAGES; i++) {
+
+		/* Allocate a page.
+		 */
+		ba = (unsigned char *)dma_alloc_coherent(NULL, PAGE_SIZE,
+							 &mem_addr, GFP_KERNEL);
+
+		/* Initialize the BD for every fragment in the page.
+		 */
+		for (j = 0; j < CPM_IRDA_RX_FRPPG; j++) {
+			bdp->cbd_sc = BD_AHDLC_RX_EMPTY | BD_AHDLC_RX_INTR;
+			bdp->cbd_bufaddr = mem_addr;
+			si->rx_vaddr[k++] = ba;
+			mem_addr += CPM_IRDA_RX_FRSIZE;
+			ba += CPM_IRDA_RX_FRSIZE;
+			bdp++;
+		}
+	}
+
+	/* Set the last buffer to wrap.
+	 */
+	bdp--;
+	bdp->cbd_sc |= BD_SC_WRAP;
+
+	out_be16(&sccp->scc_scce, 0xffff);	/* Clear any pending events */
+	out_be16(&sccp->scc_sccm, SCC_AHDLC_TXE | SCC_AHDLC_RXF | SCC_AHDLC_TXB);
+
+	err = request_irq(si->irq, mpc8xx_irda_irq, 0, dev->name, dev);
+	if (err) {
+		kfree(si);
+		return err;
+	}
+
+	/* Set GSMR_H to enable all normal operating modes.
+	 * Set GSMR_L to enable Ethernet to MC68160.
+	 */
+	out_be32(&sccp->scc_gsmrh, SCC_GSMRH_RFW | SCC_GSMRH_IRP);
+	out_be32(&sccp->scc_gsmrl, SCC_GSMRL_SIR | SCC_GSMRL_MODE_AHDLC | SCC_GSMRL_TDCR_16 |
+				   SCC_GSMRL_TDCR_16 | SCC_GSMRL_RDCR_16);
+
+	out_be16(&sccp->scc_dsr, 0x7e7e);
+
+	/* Set processing mode.
+	 */
+	out_be16(&sccp->scc_psmr, SCC_PMSR_CHLN);
+
+	/* Enable the transmit and receive processing.
+	 */
+	setbits32(&sccp->scc_gsmrl, SCC_GSMRL_ENR | SCC_GSMRL_ENT);
+
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+static int mpc8xx_irda_start(struct net_device *dev)
+{
+	struct mpc8xx_irda *si = dev->priv;
+	int err = 0;
+
+	if ((err = mpc8xx_irda_startup(dev)))
+		return err;
+
+	mpc8xx_irda_set_speed(dev, si->speed = 9600);
+
+	/* Open new IrLAP layer instance, now that everything should be
+	 * initialized properly
+	 */
+	si->irlap = irlap_open(dev, &si->qos, "MPC8xx SIR");
+	err = -ENOMEM;
+	if (!si->irlap) {
+		si->open = 0;
+		return err;
+	}
+
+	/* Now start the queue
+	 */
+	si->open = 1;
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+static int mpc8xx_irda_stop(struct net_device *dev)
+{
+	struct mpc8xx_irda *si = dev->priv;
+
+	disable_irq(dev->irq);
+
+	/* Stop IrLAP */
+	if (si->irlap) {
+		irlap_close(si->irlap);
+		si->irlap = NULL;
+	}
+
+	netif_stop_queue(dev);
+	si->open = 0;
+
+	/* Free resources
+	 */
+	free_irq(dev->irq, dev);
+
+	return 0;
+}
+
+static void mpc8xx_irda_set_speed(struct net_device *dev, int speed)
+{
+	cpm_setbrg(2, speed);
+}
+
+static int mpc8xx_irda_probe(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct net_device *ndev;
+	struct mpc8xx_irda *si;
+	int err;
+
+	if (!(ndev = alloc_irdadev(sizeof(struct mpc8xx_irda))))
+		return -ENOMEM;
+
+	si = ndev->priv;
+	si->dev = dev;
+	si->pdata = pdev->dev.platform_data;
+
+	ndev->hard_start_xmit = mpc8xx_irda_hard_xmit;
+	ndev->open = mpc8xx_irda_start;
+	ndev->stop = mpc8xx_irda_stop;
+	ndev->do_ioctl = mpc8xx_irda_ioctl;
+	ndev->get_stats = mpc8xx_irda_stats;
+
+	irda_init_max_qos_capabilies(&si->qos);
+
+	/* We support original IRDA up to 115k2.
+	 * Min Turn Time set to 1ms or greater.
+	 */
+
+	si->qos.baud_rate.bits =
+	    IR_9600 | IR_19200 | IR_38400 | IR_57600 | IR_115200;
+	si->qos.min_turn_time.bits = 7;
+	irda_qos_bits_to_value(&si->qos);
+
+	err = register_netdev(ndev);
+
+	if (!err) {
+		dev_set_drvdata(&pdev->dev, ndev);
+		printk(KERN_INFO "IrDA: Registered device %s\n", ndev->name);
+	} else
+		free_netdev(ndev);
+
+	return err;
+}
+
+static int mpc8xx_irda_remove(struct device *_dev)
+{
+	struct net_device *dev = dev_get_drvdata(_dev);
+
+	if (dev) {
+		rtnl_lock();
+		unregister_netdevice(dev);
+		free_netdev(dev);
+		rtnl_unlock();
+	}
+
+	/*
+	 * We now know that the netdevice is no longer in use, and all
+	 * references to our driver have been removed.  The only structure
+	 * which may still be present is the netdevice, which will get
+	 * cleaned up by net/core/dev.c
+	 */
+
+	return 0;
+}
+
+static struct device_driver m8xxir_driver = {
+	.name = "fsl-cpm-scc:irda",
+	.bus = &platform_bus_type,
+	.probe = mpc8xx_irda_probe,
+	.remove = mpc8xx_irda_remove,
+};
+
+static int mpc8xx_irda_init(void)
+{
+	return driver_register(&m8xxir_driver);
+}
+
+static void __exit mpc8xx_irda_exit(void)
+{
+	driver_unregister(&m8xxir_driver);
+}
+
+module_init(mpc8xx_irda_init);
+module_exit(mpc8xx_irda_exit);
+
+MODULE_AUTHOR("source@mvista.com");
+MODULE_DESCRIPTION("MPC8XX SIR");
+MODULE_LICENSE("GPL");
diff --git a/include/asm-ppc/commproc.h b/include/asm-ppc/commproc.h
index 4f99df1..9e251c3 100644
--- a/include/asm-ppc/commproc.h
+++ b/include/asm-ppc/commproc.h
@@ -616,6 +616,73 @@ typedef struct spi {
 #define SPIE_TXB	0x02
 #define SPIE_RXB	0x01
 
+/* Asynchronous HDLC Mode Parameter RAM.
+*/
+typedef struct scc_ahdlc {
+	sccp_t  scc_genscc;
+	uint    ahdlc_res1;	/* Reserved */
+	uint    ahdlc_cmask;	/* Constant mask for CRC */
+	uint    ahdlc_cpres;	/* Preset CRC */
+	ushort  ahdlc_bof;	/* Beginning of flag character */
+	ushort  ahdlc_eof;	/* End of flag character */
+	ushort  ahdlc_esc;	/* Control escape character. */
+	ushort  ahdlc_res2;	/* Reserved */
+	ushort  ahdlc_res3;	/* Reserved */
+	ushort  ahdlc_zero;	/* Clear this field */
+	ushort  ahdlc_res4;	/* Reserved */
+	ushort  ahdlc_rfthr;	/* Received frames threshold */
+	uint    ahdlc_res5;	/* Reserved */
+	uint    ahdlc_txctl_tbl;/* Control Tx character tables */
+	uint    ahdlc_rxctl_tbl;/* Control Rx character tables */
+	ushort  ahdlc_nof;	/* Number of opening flags to be sent at the beginning of a frame */
+	ushort  ahdlc_res6;	/* Reserved */
+} scc_ahdlc_t;
+
+/* SCC Mode Register (PMSR) as used by Ethernet.
+*/
+#define SCC_PMSR_CHLN		((ushort)0x3000)        /* 8 bits character length */
+#define SICR_IRDA_MASK		((uint)0x0000ff00)
+#define SICR_IRDA_CLKRT		((uint)0x00001200)
+
+/* SCC Event register as used by Asynchronous HDLC.
+*/
+#define SCC_AHDLC_GLR		((ushort)0x1000)
+#define SCC_AHDLC_GLT		((ushort)0x0800)
+#define SCC_AHDLC_IDL		((ushort)0x0100)
+#define SCC_AHDLC_BRKE		((ushort)0x0040)
+#define SCC_AHDLC_BRKS		((ushort)0x0020)
+#define SCC_AHDLC_TXE		((ushort)0x0010)
+#define SCC_AHDLC_RXF		((ushort)0x0008)
+#define SCC_AHDLC_BSY		((ushort)0x0004)
+#define SCC_AHDLC_TXB		((ushort)0x0002)
+#define SCC_AHDLC_RXB		((ushort)0x0001)
+
+/* Buffer descriptor control/status used by AHDLC receive.
+*/
+#define BD_AHDLC_RX_EMPTY	((ushort)0x8000)
+#define BD_AHDLC_RX_WRAP	((ushort)0x2000)
+#define BD_AHDLC_RX_INTR	((ushort)0x1000)
+#define BD_AHDLC_RX_LAST	((ushort)0x0800)
+#define BD_AHDLC_RX_FIRST	((ushort)0x0400)
+#define BD_AHDLC_RX_CM		((ushort)0x0200)
+#define BD_AHDLC_RX_BRK		((ushort)0x0080)
+#define BD_AHDLC_RX_BOF		((ushort)0x0040)
+#define BD_AHDLC_RX_AB		((ushort)0x0008)
+#define BD_AHDLC_RX_CR		((ushort)0x0004)
+#define BD_AHDLC_RX_OV		((ushort)0x0002)
+#define BD_AHDLC_RX_CD		((ushort)0x0001)
+#define BD_AHDLC_RX_STATS	((ushort)0x008f)        /* All status bits */
+
+/* Buffer descriptor control/status used by AHDLC transmit.
+*/
+#define BD_AHDLC_TX_READY	((ushort)0x8000)
+#define BD_AHDLC_TX_WRAP	((ushort)0x2000)
+#define BD_AHDLC_TX_INTR	((ushort)0x1000)
+#define BD_AHDLC_TX_LAST	((ushort)0x0800)
+#define BD_AHDLC_TX_CM		((ushort)0x0200)
+#define BD_AHDLC_TX_CTS		((ushort)0x0001)
+#define BD_AHDLC_TX_STATS	((ushort)0x03ff)        /* All status bits */
+
 /*
  * RISC Controller Configuration Register definitons
  */
