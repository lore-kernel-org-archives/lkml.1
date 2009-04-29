Return-Path: <linux-kernel-owner+w=401wt.eu-S1762877AbZD2Whq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762877AbZD2Whq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759475AbZD2WVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:47 -0400
Received: from kroah.org ([198.145.64.141]:40532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759760AbZD2WVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220929.295259303@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ivan Vecera <ivecera@redhat.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 42/58] r8169: Dont update statistics counters when interface is down
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=r8169-don-t-update-statistics-counters-when-interface-is-down.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Upstream as 355423d0849f4506bc71ab2738d38cb74429aaef (post 2.6.28).

Some Realtek chips (RTL8169sb/8110sb in my case) are unable to retrieve
ethtool statistics when the interface is down. The process stays in
endless loop in rtl8169_get_ethtool_stats. This is because these chips
need to have receiver enabled (CmdRxEnb bit in ChipCmd register) that is
cleared when the interface is going down. It's better to update statistics
only when the interface is up and otherwise return copy of statistics
grabbed when the interface was up (in rtl8169_close).

It is interesting that PCI-E NICs (like 8168b/8111b...) are not affected.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   93 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 35 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -375,6 +375,22 @@ enum features {
 	RTL_FEATURE_GMII	= (1 << 2),
 };
 
+struct rtl8169_counters {
+	__le64	tx_packets;
+	__le64	rx_packets;
+	__le64	tx_errors;
+	__le32	rx_errors;
+	__le16	rx_missed;
+	__le16	align_errors;
+	__le32	tx_one_collision;
+	__le32	tx_multi_collision;
+	__le64	rx_unicast;
+	__le64	rx_broadcast;
+	__le32	rx_multicast;
+	__le16	tx_aborted;
+	__le16	tx_underun;
+};
+
 struct rtl8169_private {
 	void __iomem *mmio_addr;	/* memory map physical address */
 	struct pci_dev *pci_dev;	/* Index of PCI device */
@@ -416,6 +432,7 @@ struct rtl8169_private {
 	unsigned features;
 
 	struct mii_if_info mii;
+	struct rtl8169_counters counters;
 };
 
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
@@ -960,22 +977,6 @@ static const char rtl8169_gstrings[][ETH
 	"tx_underrun",
 };
 
-struct rtl8169_counters {
-	__le64	tx_packets;
-	__le64	rx_packets;
-	__le64	tx_errors;
-	__le32	rx_errors;
-	__le16	rx_missed;
-	__le16	align_errors;
-	__le32	tx_one_collision;
-	__le32	tx_multi_collision;
-	__le64	rx_unicast;
-	__le64	rx_broadcast;
-	__le32	rx_multicast;
-	__le16	tx_aborted;
-	__le16	tx_underun;
-};
-
 static int rtl8169_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
@@ -986,16 +987,21 @@ static int rtl8169_get_sset_count(struct
 	}
 }
 
-static void rtl8169_get_ethtool_stats(struct net_device *dev,
-				      struct ethtool_stats *stats, u64 *data)
+static void rtl8169_update_counters(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->mmio_addr;
 	struct rtl8169_counters *counters;
 	dma_addr_t paddr;
 	u32 cmd;
+	int wait = 1000;
 
-	ASSERT_RTNL();
+	/*
+	 * Some chips are unable to dump tally counters when the receiver
+	 * is disabled.
+	 */
+	if ((RTL_R8(ChipCmd) & CmdRxEnb) == 0)
+		return;
 
 	counters = pci_alloc_consistent(tp->pci_dev, sizeof(*counters), &paddr);
 	if (!counters)
@@ -1006,31 +1012,45 @@ static void rtl8169_get_ethtool_stats(st
 	RTL_W32(CounterAddrLow, cmd);
 	RTL_W32(CounterAddrLow, cmd | CounterDump);
 
-	while (RTL_R32(CounterAddrLow) & CounterDump) {
-		if (msleep_interruptible(1))
+	while (wait--) {
+		if ((RTL_R32(CounterAddrLow) & CounterDump) == 0) {
+			/* copy updated counters */
+			memcpy(&tp->counters, counters, sizeof(*counters));
 			break;
+		}
+		udelay(10);
 	}
 
 	RTL_W32(CounterAddrLow, 0);
 	RTL_W32(CounterAddrHigh, 0);
 
-	data[0] = le64_to_cpu(counters->tx_packets);
-	data[1] = le64_to_cpu(counters->rx_packets);
-	data[2] = le64_to_cpu(counters->tx_errors);
-	data[3] = le32_to_cpu(counters->rx_errors);
-	data[4] = le16_to_cpu(counters->rx_missed);
-	data[5] = le16_to_cpu(counters->align_errors);
-	data[6] = le32_to_cpu(counters->tx_one_collision);
-	data[7] = le32_to_cpu(counters->tx_multi_collision);
-	data[8] = le64_to_cpu(counters->rx_unicast);
-	data[9] = le64_to_cpu(counters->rx_broadcast);
-	data[10] = le32_to_cpu(counters->rx_multicast);
-	data[11] = le16_to_cpu(counters->tx_aborted);
-	data[12] = le16_to_cpu(counters->tx_underun);
-
 	pci_free_consistent(tp->pci_dev, sizeof(*counters), counters, paddr);
 }
 
+static void rtl8169_get_ethtool_stats(struct net_device *dev,
+				      struct ethtool_stats *stats, u64 *data)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	ASSERT_RTNL();
+
+	rtl8169_update_counters(dev);
+
+	data[0] = le64_to_cpu(tp->counters.tx_packets);
+	data[1] = le64_to_cpu(tp->counters.rx_packets);
+	data[2] = le64_to_cpu(tp->counters.tx_errors);
+	data[3] = le32_to_cpu(tp->counters.rx_errors);
+	data[4] = le16_to_cpu(tp->counters.rx_missed);
+	data[5] = le16_to_cpu(tp->counters.align_errors);
+	data[6] = le32_to_cpu(tp->counters.tx_one_collision);
+	data[7] = le32_to_cpu(tp->counters.tx_multi_collision);
+	data[8] = le64_to_cpu(tp->counters.rx_unicast);
+	data[9] = le64_to_cpu(tp->counters.rx_broadcast);
+	data[10] = le32_to_cpu(tp->counters.rx_multicast);
+	data[11] = le16_to_cpu(tp->counters.tx_aborted);
+	data[12] = le16_to_cpu(tp->counters.tx_underun);
+}
+
 static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch(stringset) {
@@ -2979,6 +2999,9 @@ static int rtl8169_close(struct net_devi
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct pci_dev *pdev = tp->pci_dev;
 
+	/* update counters before going down */
+	rtl8169_update_counters(dev);
+
 	rtl8169_down(dev);
 
 	free_irq(dev->irq, dev);


