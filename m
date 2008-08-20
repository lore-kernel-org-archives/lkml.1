Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYHTMFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYHTMFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYHTMFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:05:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56984 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbYHTMFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:05:06 -0400
Date: Wed, 20 Aug 2008 13:05:01 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: mcarlson@broadcom.com
Cc: mchan@broadcom.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Major stalls due to commit 7c5026aa9b81dd45df8d3f4e0be73e485976a8b6
Message-ID: <20080820120501.GC20199@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had the pleasure of getting hold of one of these machines
http://www.terrasoftsolutions.com/products/powerstation/ and after some
tinkering installed 2.6.27-rc3. However, it was way slower and jerkier
(keyboard input for example would stop processing for up to 2 seconds)
than the distribution kernel. Network is a bit useless and kernel builds
went from about 4 minutes to about 12 even when built locally. I also noted
with NO_HZ enabled that a soft-lockup would be reported in a timer related
to tg3. The card in question is

0001:02:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5780
Gigabit
 Ethernet (rev 10)
        Subsystem: IBM Device 0329
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
        Memory at b8100000 (64-bit, non-prefetchable) [size=64K]
        Memory at b8110000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at <ignored> [disabled]
        Capabilities: [40] PCI-X non-bridge device
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data <?>
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
        Kernel driver in use: tg3
        Kernel modules: tg3

I bisected part of the problem to the commit below and reverted it in
2.6.27-rc3. Much of the jerkiness is gone as well as the soft-lockup.
Kernel builds are still a little slower but I'm guessing that is
something else.

From: Matt Carlson <mcarlson@broadcom.com>
Date: Fri, 2 May 2008 16:49:29 -0700
Subject: [PATCH] tg3: Add link state reporting to UMP firmware

All variants of the 5714, 5715, and 5780 offer a feature called the
"Universal Management Port".  This feature is implemented in firmware
and is largely transparent to the driver, except...

It turns out that the UMP firmware needs to know the current status
of the link.  Because the firmware cannot touch the PHY registers while
the driver is in control of the device, it needs the driver to report
link status changes through an additional handshaking mechanism.
Without this handshake, it has been observed in the field that the UMP
firmware will not operate correctly.

This patch implements the new handshake with the UMP firmware.  Since
the handshake uses the same mechanism ASF heartbeats use, code was
added to detect and wait for completion of a pending previous event.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index bf376b3..3ba6c52 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -1656,12 +1656,76 @@ static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 	return 0;
 }
 
+/* tp->lock is held. */
+static void tg3_wait_for_event_ack(struct tg3 *tp)
+{
+	int i;
+
+	/* Wait for up to 2.5 milliseconds */
+	for (i = 0; i < 250000; i++) {
+		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
+			break;
+		udelay(10);
+	}
+}
+
+/* tp->lock is held. */
+static void tg3_ump_link_report(struct tg3 *tp)
+{
+	u32 reg;
+	u32 val;
+
+	if (!(tp->tg3_flags2 & TG3_FLG2_5780_CLASS) ||
+	    !(tp->tg3_flags  & TG3_FLAG_ENABLE_ASF))
+		return;
+
+	tg3_wait_for_event_ack(tp);
+
+	tg3_write_mem(tp, NIC_SRAM_FW_CMD_MBOX, FWCMD_NICDRV_LINK_UPDATE);
+
+	tg3_write_mem(tp, NIC_SRAM_FW_CMD_LEN_MBOX, 14);
+
+	val = 0;
+	if (!tg3_readphy(tp, MII_BMCR, &reg))
+		val = reg << 16;
+	if (!tg3_readphy(tp, MII_BMSR, &reg))
+		val |= (reg & 0xffff);
+	tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX, val);
+
+	val = 0;
+	if (!tg3_readphy(tp, MII_ADVERTISE, &reg))
+		val = reg << 16;
+	if (!tg3_readphy(tp, MII_LPA, &reg))
+		val |= (reg & 0xffff);
+	tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX + 4, val);
+
+	val = 0;
+	if (!(tp->tg3_flags2 & TG3_FLG2_MII_SERDES)) {
+		if (!tg3_readphy(tp, MII_CTRL1000, &reg))
+			val = reg << 16;
+		if (!tg3_readphy(tp, MII_STAT1000, &reg))
+			val |= (reg & 0xffff);
+	}
+	tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX + 8, val);
+
+	if (!tg3_readphy(tp, MII_PHYADDR, &reg))
+		val = reg << 16;
+	else
+		val = 0;
+	tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX + 12, val);
+
+	val = tr32(GRC_RX_CPU_EVENT);
+	val |= GRC_RX_CPU_DRIVER_EVENT;
+	tw32_f(GRC_RX_CPU_EVENT, val);
+}
+
 static void tg3_link_report(struct tg3 *tp)
 {
 	if (!netif_carrier_ok(tp->dev)) {
 		if (netif_msg_link(tp))
 			printk(KERN_INFO PFX "%s: Link is down.\n",
 			       tp->dev->name);
+		tg3_ump_link_report(tp);
 	} else if (netif_msg_link(tp)) {
 		printk(KERN_INFO PFX "%s: Link is up at %d Mbps, %s duplex.\n",
 		       tp->dev->name,
@@ -1679,6 +1743,7 @@ static void tg3_link_report(struct tg3 *tp)
 		       "on" : "off",
 		       (tp->link_config.active_flowctrl & TG3_FLOW_CTRL_RX) ?
 		       "on" : "off");
+		tg3_ump_link_report(tp);
 	}
 }
 
@@ -5500,19 +5565,17 @@ static void tg3_stop_fw(struct tg3 *tp)
 	if ((tp->tg3_flags & TG3_FLAG_ENABLE_ASF) &&
 	   !(tp->tg3_flags3 & TG3_FLG3_ENABLE_APE)) {
 		u32 val;
-		int i;
+
+		/* Wait for RX cpu to ACK the previous event. */
+		tg3_wait_for_event_ack(tp);
 
 		tg3_write_mem(tp, NIC_SRAM_FW_CMD_MBOX, FWCMD_NICDRV_PAUSE_FW);
 		val = tr32(GRC_RX_CPU_EVENT);
-		val |= (1 << 14);
+		val |= GRC_RX_CPU_DRIVER_EVENT;
 		tw32(GRC_RX_CPU_EVENT, val);
 
-		/* Wait for RX cpu to ACK the event.  */
-		for (i = 0; i < 100; i++) {
-			if (!(tr32(GRC_RX_CPU_EVENT) & (1 << 14)))
-				break;
-			udelay(1);
-		}
+		/* Wait for RX cpu to ACK this event. */
+		tg3_wait_for_event_ack(tp);
 	}
 }
 
@@ -7402,14 +7465,16 @@ static void tg3_timer(unsigned long __opaque)
 		if (tp->tg3_flags & TG3_FLAG_ENABLE_ASF) {
 			u32 val;
 
+			tg3_wait_for_event_ack(tp);
+
 			tg3_write_mem(tp, NIC_SRAM_FW_CMD_MBOX,
 				      FWCMD_NICDRV_ALIVE3);
 			tg3_write_mem(tp, NIC_SRAM_FW_CMD_LEN_MBOX, 4);
 			/* 5 seconds timeout */
 			tg3_write_mem(tp, NIC_SRAM_FW_CMD_DATA_MBOX, 5);
 			val = tr32(GRC_RX_CPU_EVENT);
-			val |= (1 << 14);
-			tw32(GRC_RX_CPU_EVENT, val);
+			val |= GRC_RX_CPU_DRIVER_EVENT;
+			tw32_f(GRC_RX_CPU_EVENT, val);
 		}
 		tp->asf_counter = tp->asf_multiplier;
 	}
diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
index bf387ff..0404f93 100644
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -1429,6 +1429,7 @@
 #define  GRC_LCLCTRL_AUTO_SEEPROM	0x01000000
 #define GRC_TIMER			0x0000680c
 #define GRC_RX_CPU_EVENT		0x00006810
+#define  GRC_RX_CPU_DRIVER_EVENT	0x00004000
 #define GRC_RX_TIMER_REF		0x00006814
 #define GRC_RX_CPU_SEM			0x00006818
 #define GRC_REMOTE_RX_CPU_ATTN		0x0000681c
@@ -1676,6 +1677,7 @@
 #define  FWCMD_NICDRV_IPV6ADDR_CHG	 0x00000004
 #define  FWCMD_NICDRV_FIX_DMAR		 0x00000005
 #define  FWCMD_NICDRV_FIX_DMAW		 0x00000006
+#define  FWCMD_NICDRV_LINK_UPDATE	 0x0000000c
 #define  FWCMD_NICDRV_ALIVE2		 0x0000000d
 #define  FWCMD_NICDRV_ALIVE3		 0x0000000e
 #define NIC_SRAM_FW_CMD_LEN_MBOX	0x00000b7c

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
