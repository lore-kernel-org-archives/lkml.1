Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbYEUAiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbYEUAiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765981AbYEUAef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:34:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45371 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbYEUAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:34:33 -0400
Date: Wed, 21 May 2008 01:34:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] misc drivers/net endianness noise
Message-ID: <20080521003430.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/3c509.c                    |   15 +++++++--------
 drivers/net/atlx/atl1.c                |    2 +-
 drivers/net/usb/catc.c                 |    5 ++++-
 drivers/net/usb/rndis_host.c           |    4 ++--
 drivers/net/wireless/zd1211rw/zd_mac.c |    2 +-
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
 6 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/3c509.c b/drivers/net/3c509.c
index e6c545f..87d8795 100644
--- a/drivers/net/3c509.c
+++ b/drivers/net/3c509.c
@@ -413,7 +413,7 @@ static int __devinit el3_pnp_probe(struct pnp_dev *pdev,
 {
 	short i;
 	int ioaddr, irq, if_port;
-	u16 phys_addr[3];
+	__be16 phys_addr[3];
 	struct net_device *dev = NULL;
 	int err;
 
@@ -605,7 +605,7 @@ static int __init el3_mca_probe(struct device *device)
 
 	short i;
 	int ioaddr, irq, if_port;
-	u16 phys_addr[3];
+	__be16 phys_addr[3];
 	struct net_device *dev = NULL;
 	u_char pos4, pos5;
 	struct mca_device *mdev = to_mca_device(device);
@@ -635,14 +635,13 @@ static int __init el3_mca_probe(struct device *device)
 			printk(KERN_DEBUG "3c529: irq %d  ioaddr 0x%x  ifport %d\n", irq, ioaddr, if_port);
 	}
 	EL3WINDOW(0);
-	for (i = 0; i < 3; i++) {
-			phys_addr[i] = htons(read_eeprom(ioaddr, i));
-	}
+	for (i = 0; i < 3; i++)
+		phys_addr[i] = htons(read_eeprom(ioaddr, i));
 
 	dev = alloc_etherdev(sizeof (struct el3_private));
 	if (dev == NULL) {
-			release_region(ioaddr, EL3_IO_EXTENT);
-			return -ENOMEM;
+		release_region(ioaddr, EL3_IO_EXTENT);
+		return -ENOMEM;
 	}
 
 	netdev_boot_setup_check(dev);
@@ -668,7 +667,7 @@ static int __init el3_eisa_probe (struct device *device)
 {
 	short i;
 	int ioaddr, irq, if_port;
-	u16 phys_addr[3];
+	__be16 phys_addr[3];
 	struct net_device *dev = NULL;
 	struct eisa_device *edev;
 	int err;
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 9c2394d..6e4c80d 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2135,7 +2135,7 @@ static int atl1_tso(struct atl1_adapter *adapter, struct sk_buff *skb,
 				return -1;
 		}
 
-		if (skb->protocol == ntohs(ETH_P_IP)) {
+		if (skb->protocol == htons(ETH_P_IP)) {
 			struct iphdr *iph = ip_hdr(skb);
 
 			real_len = (((unsigned char *)iph - skb->data) +
diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 76752d8..22c17bb 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -423,7 +423,10 @@ static int catc_hard_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	catc->tx_ptr = (((catc->tx_ptr - 1) >> 6) + 1) << 6;
 	tx_buf = catc->tx_buf[catc->tx_idx] + catc->tx_ptr;
-	*((u16*)tx_buf) = (catc->is_f5u011) ? cpu_to_be16((u16)skb->len) : cpu_to_le16((u16)skb->len);
+	if (catc->is_f5u011)
+		*(__be16 *)tx_buf = cpu_to_be16(skb->len);
+	else
+		*(__le16 *)tx_buf = cpu_to_le16(skb->len);
 	skb_copy_from_linear_data(skb, tx_buf + 2, skb->len);
 	catc->tx_ptr += skb->len + 2;
 
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 21a7785..3969b7a 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -283,8 +283,8 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 		struct rndis_set_c	*set_c;
 		struct rndis_halt	*halt;
 	} u;
-	u32			tmp, phym_unspec;
-	__le32			*phym;
+	u32			tmp;
+	__le32			phym_unspec, *phym;
 	int			reply_len;
 	unsigned char		*bp;
 
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 69c45ca..6424e5a 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -805,7 +805,7 @@ void zd_process_intr(struct work_struct *work)
 	u16 int_status;
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
 
-	int_status = le16_to_cpu(*(u16 *)(mac->intr_buffer+4));
+	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
 	if (int_status & INT_CFG_NEXT_BCN) {
 		if (net_ratelimit())
 			dev_dbg_f(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 12e24f0..8941f5e 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -342,7 +342,7 @@ static inline void handle_regs_int(struct urb *urb)
 	ZD_ASSERT(in_interrupt());
 	spin_lock(&intr->lock);
 
-	int_num = le16_to_cpu(*(u16 *)(urb->transfer_buffer+2));
+	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
 	if (int_num == CR_INTERRUPT) {
 		struct zd_mac *mac = zd_hw_mac(zd_usb_to_hw(urb->context));
 		memcpy(&mac->intr_buffer, urb->transfer_buffer,
-- 
1.5.3.GIT

