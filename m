Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbXLXOkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbXLXOkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbXLXOkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:40:25 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58565 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXLXOkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:40:21 -0500
Date: Mon, 24 Dec 2007 15:40:06 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 20/38] drivers/net: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241539340.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
--- a/drivers/net/arcnet/arcnet.c	2007-10-22 11:25:13.000000000 +0200
+++ b/drivers/net/arcnet/arcnet.c	2007-12-23 20:38:12.000000000 +0100
@@ -940,7 +940,7 @@ irqreturn_t arcnet_interrupt(int irq, vo
 
 			/* is the RECON info empty or old? */
 			if (!lp->first_recon || !lp->last_recon ||
-			    jiffies - lp->last_recon > HZ * 10) {
+			    time_after(jiffies, lp->last_recon + HZ * 10)) {
 				if (lp->network_down)
 					BUGMSG(D_NORMAL, "reconfiguration detected: cabling restored?\n");
 				lp->first_recon = lp->last_recon = jiffies;
@@ -974,7 +974,8 @@ irqreturn_t arcnet_interrupt(int irq, vo
 					lp->num_recons = 1;
 				}
 			}
-		} else if (lp->network_down && jiffies - lp->last_recon > HZ * 10) {
+		} else if (lp->network_down &&
+			   time_after(jiffies, lp->last_recon + HZ * 10)) {
 			if (lp->network_down)
 				BUGMSG(D_NORMAL, "cabling restored?\n");
 			lp->first_recon = lp->last_recon = 0;
diff -r -u -p a/drivers/net/ax88796.c b/drivers/net/ax88796.c
--- a/drivers/net/ax88796.c	2007-10-22 11:25:13.000000000 +0200
+++ b/drivers/net/ax88796.c	2007-12-23 20:30:39.000000000 +0100
@@ -150,7 +150,7 @@ static void ax_reset_8390(struct net_dev
 
 	/* This check _should_not_ be necessary, omit eventually. */
 	while ((ei_inb(addr + EN0_ISR) & ENISR_RESET) == 0) {
-		if (jiffies - reset_start_time > 2*HZ/100) {
+		if (time_after(jiffies, reset_start_time + 2*HZ/100)) {
 			printk(KERN_WARNING "%s: %s did not complete.\n",
 			       __FUNCTION__, dev->name);
 			break;
@@ -280,7 +280,7 @@ static void ax_block_output(struct net_d
 	dma_start = jiffies;
 
 	while ((ei_inb(nic_base + EN0_ISR) & ENISR_RDC) == 0) {
-		if (jiffies - dma_start > 2*HZ/100) {		/* 20ms */
+		if (time_after(jiffies, dma_start + 2*HZ/100)) { /* 20ms */
 			printk(KERN_WARNING "%s: timeout waiting for Tx RDC.\n", dev->name);
 			ax_reset_8390(dev);
 			ax_NS8390_init(dev,1);
diff -r -u -p a/drivers/net/cassini.c b/drivers/net/cassini.c
--- a/drivers/net/cassini.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/cassini.c	2007-12-23 20:38:34.000000000 +0100
@@ -91,6 +91,7 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/mutex.h>
+#include <linux/jiffies.h>
 
 #include <net/checksum.h>
 
@@ -4141,8 +4142,9 @@ static void cas_link_timer(unsigned long
 
 	if (link_transition_timeout != 0 &&
 	    cp->link_transition_jiffies_valid &&
-	    ((jiffies - cp->link_transition_jiffies) >
-	      (link_transition_timeout))) {
+	    (time_after(jiffies,
+			cp->link_transition_jiffies +
+			(link_transition_timeout)))) {
 		/* One-second counter so link-down workaround doesn't
 		 * cause resets to occur so fast as to fool the switch
 		 * into thinking the link is down.
diff -r -u -p a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
--- a/drivers/net/cs89x0.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/cs89x0.c	2007-12-23 20:38:54.000000000 +0100
@@ -145,6 +145,7 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -450,7 +451,7 @@ wait_eeprom_ready(struct net_device *dev
 	   just in case EEPROM is ready when SI_BUSY in the
 	   PP_SelfST is clear */
 	while(readreg(dev, PP_SelfST) & SI_BUSY)
-		if (jiffies - timeout >= 40)
+		if (time_before_eq(jiffies, timeout + 40))
 			return -1;
 	return 0;
 }
@@ -1055,7 +1056,8 @@ void  __init reset_chip(struct net_devic
 
 	/* Wait until the chip is reset */
 	reset_start_time = jiffies;
-	while( (readreg(dev, PP_SelfST) & INIT_DONE) == 0 && jiffies - reset_start_time < 2)
+	while((readreg(dev, PP_SelfST) & INIT_DONE) == 0 &&
+	      time_before(jiffies, reset_start_time + 2))
 		;
 }
 
@@ -1078,7 +1080,7 @@ control_dc_dc(struct net_device *dev, in
 	writereg(dev, PP_SelfCTL, selfcontrol);
 
 	/* Wait for the DC/DC converter to power up - 500ms */
-	while (jiffies - timenow < HZ)
+	while (time_before(jiffies, timenow + HZ))
 		;
 }
 
@@ -1106,7 +1108,7 @@ detect_tp(struct net_device *dev)
 	control_dc_dc(dev, 0);
 
         /* Delay for the hardware to work out if the TP cable is present - 150ms */
-	for (timenow = jiffies; jiffies - timenow < 15; )
+	for (timenow = jiffies; time_before(jiffies, timenow + 15); )
                 ;
 	if ((readreg(dev, PP_LineST) & LINK_OK) == 0)
 		return DETECTED_NONE;
@@ -1148,7 +1150,7 @@ detect_tp(struct net_device *dev)
 		if ((lp->auto_neg_cnf & AUTO_NEG_BITS) == AUTO_NEG_ENABLE) {
 			printk(KERN_INFO "%s: negotiating duplex...\n",dev->name);
 			while (readreg(dev, PP_AutoNegST) & AUTO_NEG_BUSY) {
-				if (jiffies - timenow > 4000) {
+				if (time_after(jiffies, timenow + 4000)) {
 					printk(KERN_ERR "**** Full / half duplex auto-negotiation timed out ****\n");
 					break;
 				}
@@ -1181,10 +1183,10 @@ send_test_pkt(struct net_device *dev)
         writeword(dev->base_addr, TX_LEN_PORT, ETH_ZLEN);
 
 	/* Test to see if the chip has allocated memory for the packet */
-	while (jiffies - timenow < 5)
+	while (time_before(jiffies, timenow + 5))
 		if (readreg(dev, PP_BusST) & READY_FOR_TX_NOW)
 			break;
-	if (jiffies - timenow >= 5)
+	if (time_before_eq(jiffies, timenow + 5))
 		return 0;	/* this shouldn't happen */
 
 	/* Write the contents of the packet */
@@ -1192,7 +1194,7 @@ send_test_pkt(struct net_device *dev)
 
 	if (net_debug > 1) printk("Sending test packet ");
 	/* wait a couple of jiffies for packet to be received */
-	for (timenow = jiffies; jiffies - timenow < 3; )
+	for (timenow = jiffies; time_before(jiffies, timenow + 3); )
                 ;
         if ((readreg(dev, PP_TxEvent) & TX_SEND_OK_BITS) == TX_OK) {
                 if (net_debug > 1) printk("succeeded\n");
diff -r -u -p a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
--- a/drivers/net/e1000/e1000_ethtool.c	2007-12-09 09:35:19.000000000 +0100
+++ b/drivers/net/e1000/e1000_ethtool.c	2007-12-23 20:30:39.000000000 +0100
@@ -1537,12 +1537,12 @@ e1000_run_loopback_test(struct e1000_ada
 			 * enough time to complete the receives, if it's
 			 * exceeded, break and error off
 			 */
-		} while (good_cnt < 64 && jiffies < (time + 20));
+		} while (good_cnt < 64 && time_before(jiffies, time + 20));
 		if (good_cnt != 64) {
 			ret_val = 13; /* ret_val is the same as mis-compare */
 			break;
 		}
-		if (jiffies >= (time + 2)) {
+		if (time_before_eq(jiffies, time + 2)) {
 			ret_val = 14; /* error code for time out error */
 			break;
 		}
diff -r -u -p a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
--- a/drivers/net/e1000e/ethtool.c	2007-12-09 09:35:19.000000000 +0100
+++ b/drivers/net/e1000e/ethtool.c	2007-12-23 20:30:39.000000000 +0100
@@ -32,6 +32,7 @@
 #include <linux/ethtool.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 
 #include "e1000.h"
 
@@ -1442,7 +1443,7 @@ static int e1000_run_loopback_test(struc
 			ret_val = 13; /* ret_val is the same as mis-compare */
 			break;
 		}
-		if (jiffies >= (time + 2)) {
+		if (time_before_eq(jiffies, time + 2)) {
 			ret_val = 14; /* error code for time out error */
 			break;
 		}
diff -r -u -p a/drivers/net/eepro100.c b/drivers/net/eepro100.c
--- a/drivers/net/eepro100.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/eepro100.c	2007-12-23 20:30:39.000000000 +0100
@@ -112,6 +112,7 @@ static int options[] = {-1, -1, -1, -1, 
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
+#include <linux/jiffies.h>
 
 static int use_io;
 static int debug = -1;
@@ -1182,7 +1183,7 @@ static void speedo_timer(unsigned long d
 			   dev->name, ioread16(ioaddr + SCBStatus));
 	}
 	if (sp->rx_mode < 0  ||
-		(sp->rx_bug  && jiffies - sp->last_rx_time > 2*HZ)) {
+		(sp->rx_bug && time_after(jiffies, sp->last_rx_time + 2*HZ))) {
 		/* We haven't received a packet in a Long Time.  We might have been
 		   bitten by the receiver hang bug.  This can be cleared by sending
 		   a set multicast list command. */
diff -r -u -p a/drivers/net/es3210.c b/drivers/net/es3210.c
--- a/drivers/net/es3210.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/es3210.c	2007-12-23 20:30:39.000000000 +0100
@@ -56,6 +56,7 @@ static const char version[] =
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/jiffies.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -322,7 +323,7 @@ static void es_reset_8390(struct net_dev
 	if (ei_debug > 1) printk("%s: resetting the ES3210...", dev->name);
 
 	end = jiffies + 2*HZ/100;
-        while ((signed)(end - jiffies) > 0) continue;
+	while (time_before(jiffies, end)) continue;
 
 	ei_status.txing = 0;
 	outb(0x01, ioaddr + ES_RESET_PORT);
diff -r -u -p a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
--- a/drivers/net/hamradio/dmascc.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/hamradio/dmascc.c	2007-12-23 20:39:29.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/sockios.h>
 #include <linux/workqueue.h>
+#include <linux/jiffies.h>
 #include <asm/atomic.h>
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -389,7 +390,7 @@ static int __init dmascc_init(void)
 		udelay(2000000 / TMR_0_HZ);
 
 		/* Timing loop */
-		while (jiffies - time < 13) {
+		while (time_before(jiffies, time + 13)) {
 			for (i = 0; i < hw[h].num_devs; i++)
 				if (base[i] && counting[i]) {
 					/* Read back Timer 1: latch; read LSB; read MSB */
@@ -530,7 +531,7 @@ static int __init setup_adapter(int card
 
 	/* Wait and detect IRQ */
 	time = jiffies;
-	while (jiffies - time < 2 + HZ / TMR_0_HZ);
+	while (time_before(jiffies, time + 2 + HZ / TMR_0_HZ));
 	irq = probe_irq_off(irqs);
 
 	/* Clear pending interrupt, disable interrupts */
@@ -1375,7 +1376,8 @@ static void es_isr(struct scc_priv *priv
 		/* Switch state */
 		write_scc(priv, R15, 0);
 		if (priv->tx_count &&
-		    (jiffies - priv->tx_start) < priv->param.txtimeout) {
+		    time_before(jiffies,
+				priv->tx_start + priv->param.txtimeout)) {
 			priv->state = TX_PAUSE;
 			start_timer(priv, priv->param.txpause, 0);
 		} else {
diff -r -u -p a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
--- a/drivers/net/iseries_veth.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/iseries_veth.c	2007-12-23 20:30:39.000000000 +0100
@@ -69,6 +69,7 @@
 #include <linux/mm.h>
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
+#include <linux/jiffies.h>
 
 #include <asm/abs_addr.h>
 #include <asm/iseries/mf.h>
@@ -1322,7 +1323,7 @@ static void veth_timed_reset(unsigned lo
 	if (cnx->outstanding_tx > 0) {
 		trigger_time = cnx->last_contact + cnx->reset_timeout;
 
-		if (trigger_time < jiffies) {
+		if (time_after(jiffies, trigger_time)) {
 			cnx->state |= VETH_STATE_RESET;
 			veth_kick_statemachine(cnx);
 			veth_error("%d packets not acked by LPAR %d within %d "
diff -r -u -p a/drivers/net/ne2k-pci.c b/drivers/net/ne2k-pci.c
--- a/drivers/net/ne2k-pci.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/ne2k-pci.c	2007-12-23 20:30:39.000000000 +0100
@@ -53,6 +53,7 @@ static int options[MAX_UNITS];
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/jiffies.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -279,7 +280,7 @@ static int __devinit ne2k_pci_init_one (
 		*/
 		while ((inb(ioaddr + EN0_ISR) & ENISR_RESET) == 0)
 			/* Limit wait: '2' avoids jiffy roll-over. */
-			if (jiffies - reset_start_time > 2) {
+			if (time_after(jiffies, reset_start_time + 2)) {
 				dev_err(&pdev->dev,
 					"Card failure (no reset ack).\n");
 				goto err_out_free_netdev;
@@ -454,7 +455,7 @@ static void ne2k_pci_reset_8390(struct n
 
 	/* This check _should_not_ be necessary, omit eventually. */
 	while ((inb(NE_BASE+EN0_ISR) & ENISR_RESET) == 0)
-		if (jiffies - reset_start_time > 2) {
+		if (time_after(jiffies, reset_start_time + 2)) {
 			printk("%s: ne2k_pci_reset_8390() did not complete.\n", dev->name);
 			break;
 		}
@@ -611,7 +612,7 @@ static void ne2k_pci_block_output(struct
 	dma_start = jiffies;
 
 	while ((inb(nic_base + EN0_ISR) & ENISR_RDC) == 0)
-		if (jiffies - dma_start > 2) {			/* Avoid clock roll-over. */
+		if (time_after(jiffies, dma_start + 2)) {	/* Avoid clock roll-over. */
 			printk(KERN_WARNING "%s: timeout waiting for Tx RDC.\n", dev->name);
 			ne2k_pci_reset_8390(dev);
 			NS8390_init(dev,1);
diff -r -u -p a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
--- a/drivers/net/netxen/netxen_nic_init.c	2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/netxen/netxen_nic_init.c	2007-12-23 20:41:00.000000000 +0100
@@ -33,6 +33,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include "netxen_nic.h"
 #include "netxen_nic_hw.h"
 #include "netxen_nic_phan_reg.h"
@@ -1300,8 +1301,9 @@ int netxen_process_cmd_ring(unsigned lon
 		}
 		if (unlikely(netif_queue_stopped(adapter->netdev)
 			     && netif_carrier_ok(adapter->netdev))
-		    && ((jiffies - adapter->netdev->trans_start) >
-			adapter->netdev->watchdog_timeo)) {
+		    && (time_after(jiffies,
+				   adapter->netdev->trans_start +
+				   adapter->netdev->watchdog_timeo))) {
 			SCHEDULE_WORK(&adapter->tx_timeout_task);
 		}
 
diff -r -u -p a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c	2007-10-22 11:25:15.000000000 +0200
+++ b/drivers/net/tokenring/3c359.c	2007-12-23 20:30:39.000000000 +0100
@@ -61,6 +61,7 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
 
 #include <net/checksum.h>
 
@@ -408,7 +409,7 @@ static int xl_hw_reset(struct net_device
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 40*HZ) {
+		if (time_after(jiffies, t + 40*HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL  card not responding to global reset.\n", dev->name);
 			return -ENODEV;
 		}
@@ -519,7 +520,7 @@ static int xl_hw_reset(struct net_device
 	t=jiffies;
 	while ( !(readw(xl_mmio + MMIO_INTSTATUS_AUTO) & INTSTAT_SRB) ) { 
 		schedule();		
-		if(jiffies-t > 15*HZ) {
+		if (time_after(jiffies, t + 15*HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			return -ENODEV; 
 		}
@@ -793,7 +794,7 @@ static int xl_open_hw(struct net_device 
 	t=jiffies;
 	while (! (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(jiffies-t > 40*HZ) {
+		if (time_after(jiffies, t + 40*HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1007,7 +1008,7 @@ static void xl_reset(struct net_device *
 
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
-		if(jiffies-t > 40*HZ) {
+		if (time_after(jiffies, t + 40*HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1274,7 +1275,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if (time_after(jiffies, t + 10*HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1283,7 +1284,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if (time_after(jiffies, t + 10*HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNDISABLE not responding.\n", dev->name);
 			break ;
 		}
@@ -1292,7 +1293,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if (time_after(jiffies, t + 10*HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1309,7 +1310,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (!(readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if (time_after(jiffies, t + 10*HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-CLOSENIC not responding.\n", dev->name);
 			break ; 
 		}
@@ -1338,7 +1339,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if (time_after(jiffies, t + 10*HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPRESET not responding.\n", dev->name);
 			break ; 
 		}
@@ -1347,7 +1348,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if (time_after(jiffies, t + 10*HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNRESET not responding.\n", dev->name);
 			break ; 
 		}
diff -r -u -p a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
--- a/drivers/net/wan/farsync.c	2007-07-20 17:45:52.000000000 +0200
+++ b/drivers/net/wan/farsync.c	2007-12-23 20:30:39.000000000 +0100
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/if.h>
 #include <linux/hdlc.h>
+#include <linux/jiffies.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
@@ -697,14 +698,14 @@ fst_cpureset(struct fst_card_info *card)
 		 * We are delaying here to allow the 9054 to reset itself
 		 */
 		j = jiffies + 1;
-		while (jiffies < j)
+		while (time_before(jiffies, j))
 			/* Do nothing */ ;
 		outw(0x240f, card->pci_conf + CNTRL_9054 + 2);
 		/*
 		 * We are delaying here to allow the 9054 to reload its eeprom
 		 */
 		j = jiffies + 1;
-		while (jiffies < j)
+		while (time_before(jiffies, j))
 			/* Do nothing */ ;
 		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
 
diff -r -u -p a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
--- a/drivers/net/wan/lmc/lmc_main.c	2007-11-01 10:30:40.000000000 +0100
+++ b/drivers/net/wan/lmc/lmc_main.c	2007-12-23 20:30:39.000000000 +0100
@@ -57,6 +57,7 @@
 #include <linux/skbuff.h>
 #include <linux/inet.h>
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
 
 #include <net/syncppp.h>
 
@@ -2164,7 +2165,7 @@ static void lmc_driver_timeout(struct ne
     printk("%s: Xmitter busy|\n", dev->name);
 
     sc->stats.tx_tbusy_calls++ ;
-    if (jiffies - dev->trans_start < TX_TIMEOUT) {
+    if (time_before(jiffies, dev->trans_start + TX_TIMEOUT)) {
         goto bug_out;
     }
 
diff -r -u -p a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
--- a/drivers/net/wireless/atmel.c	2007-10-22 11:25:19.000000000 +0200
+++ b/drivers/net/wireless/atmel.c	2007-12-23 20:30:39.000000000 +0100
@@ -66,6 +66,7 @@
 #include <linux/device.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
+#include <linux/jiffies.h>
 #include <net/ieee80211.h>
 #include "atmel.h"
 
@@ -2284,7 +2285,7 @@ static int atmel_set_scan(struct net_dev
 		return -EAGAIN;
 
 	/* Timeout old surveys. */
-	if ((jiffies - priv->last_survey) > (20 * HZ))
+	if (time_after(jiffies, priv->last_survey + 20 * HZ))
 		priv->site_survey_state = SITE_SURVEY_IDLE;
 	priv->last_survey = jiffies;
 
diff -r -u -p a/drivers/net/wireless/b43legacy/leds.c b/drivers/net/wireless/b43legacy/leds.c
--- a/drivers/net/wireless/b43legacy/leds.c	2007-10-22 11:25:19.000000000 +0200
+++ b/drivers/net/wireless/b43legacy/leds.c	2007-12-23 20:40:21.000000000 +0100
@@ -175,8 +175,8 @@ void b43legacy_leds_update(struct b43leg
 {
 	struct b43legacy_led *led;
 	struct b43legacy_phy *phy = &dev->phy;
-	const int transferring = (jiffies - dev->stats.last_tx)
-				  < B43legacy_LED_XFER_THRES;
+	const int transferring =
+	  time_before(jiffies, dev->stats.last_tx + B43legacy_LED_XFER_THRES);
 	int i;
 	int turn_on;
 	unsigned long interval = 0;
diff -r -u -p a/drivers/net/wireless/bcm43xx/bcm43xx_leds.c b/drivers/net/wireless/bcm43xx/bcm43xx_leds.c
--- a/drivers/net/wireless/bcm43xx/bcm43xx_leds.c	2007-10-22 11:25:19.000000000 +0200
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_leds.c	2007-12-23 20:39:56.000000000 +0100
@@ -30,6 +30,7 @@
 #include "bcm43xx.h"
 
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
 
 
 static void bcm43xx_led_changestate(struct bcm43xx_led *led)
@@ -175,7 +176,8 @@ void bcm43xx_leds_update(struct bcm43xx_
 	struct bcm43xx_led *led;
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	const int transferring = (jiffies - bcm->stats.last_tx) < BCM43xx_LED_XFER_THRES;
+	const int transferring =
+	  time_before(jiffies, bcm->stats.last_tx + BCM43xx_LED_XFER_THRES);
 	int i, turn_on;
 	unsigned long interval = 0;
 	u16 ledctl;
diff -r -u -p a/drivers/net/wireless/netwave_cs.c b/drivers/net/wireless/netwave_cs.c
--- a/drivers/net/wireless/netwave_cs.c	2007-12-04 13:19:55.000000000 +0100
+++ b/drivers/net/wireless/netwave_cs.c	2007-12-23 20:30:39.000000000 +0100
@@ -55,6 +55,7 @@
 #include <linux/skbuff.h>
 #include <linux/bitops.h>
 #include <linux/wireless.h>
+#include <linux/jiffies.h>
 #include <net/iw_handler.h>
 
 #include <pcmcia/cs_types.h>
@@ -315,7 +316,7 @@ static void netwave_snapshot(netwave_pri
     /* if time since last snapshot is > 1 sec. (100 jiffies?)  then take 
      * new snapshot, else return cached data. This is the recommended rate.  
      */
-    if ( jiffies - priv->lastExec > 100) { 
+    if (time_after(jiffies, priv->lastExec + 100)) {
 	/* Take site survey  snapshot */ 
 	/*printk( KERN_DEBUG "Taking new snapshot. %ld\n", jiffies -
 	  priv->lastExec); */
