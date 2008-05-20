Return-Path: <linux-kernel-owner+w=401wt.eu-S1765455AbYETSG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765455AbYETSG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765807AbYETSF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:05:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:11772 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765603AbYETSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KUdUVqgEqVD4/pcG2H9TxDDffkNslYzT+kjtuRcMReIyAsKKK+LXZxeRzLagUoCretUNXkJG4vJt//G1mbi2gc0Qyatl1qbs5sPV41LBJgg6b8KQFaZsGeWWQfRM9l5se72Rl3Vgyeyul4K2U6TE2m0AkRtYbulvuRyGFbclqEM=
Subject: [PATCH 03/21] drivers/net: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:05:32 -0700
Message-Id: <1211306732.5915.169.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/8139cp.c                       |    4 ++--
 drivers/net/8139too.c                      |    6 +++---
 drivers/net/bfin_mac.c                     |    8 ++++----
 drivers/net/forcedeth.c                    |    4 ++--
 drivers/net/mlx4/eq.c                      |    2 +-
 drivers/net/mlx4/fw.c                      |   16 ++++++++--------
 drivers/net/netxen/netxen_nic_init.c       |    2 +-
 drivers/net/netxen/netxen_nic_niu.c        |   16 ++++++++--------
 drivers/net/niu.c                          |   12 ++++++------
 drivers/net/pppol2tp.c                     |   12 ++++++------
 drivers/net/rrunner.c                      |    8 ++++----
 drivers/net/sc92031.c                      |    2 +-
 drivers/net/sunhme.c                       |    4 ++--
 drivers/net/tulip/dmfe.c                   |    5 ++---
 drivers/net/tun.c                          |    2 +-
 drivers/net/typhoon.c                      |   12 ++++++------
 drivers/net/usb/catc.c                     |    4 ++--
 drivers/net/usb/kaweth.c                   |    2 +-
 drivers/net/usb/net1080.c                  |    4 ++--
 drivers/net/usb/pegasus.c                  |    2 +-
 drivers/net/usb/rndis_host.c               |    2 +-
 drivers/net/usb/rtl8150.c                  |    2 +-
 drivers/net/wireless/adm8211.c             |   11 +++++------
 drivers/net/wireless/hostap/hostap_ioctl.c |    8 ++++----
 drivers/net/wireless/libertas/cmd.c        |   15 +++++----------
 drivers/net/wireless/libertas/scan.c       |    4 ++--
 drivers/net/wireless/orinoco.c             |    2 +-
 drivers/net/wireless/p54/p54common.c       |    2 +-
 drivers/net/wireless/prism54/islpci_mgt.h  |    4 ++--
 drivers/net/wireless/rtl8180_dev.c         |    4 ++--
 drivers/net/wireless/zd1201.c              |    8 ++++----
 31 files changed, 91 insertions(+), 98 deletions(-)

diff --git a/drivers/net/8139cp.c b/drivers/net/8139cp.c
index a453eda..f3da4f0 100644
--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
@@ -1018,8 +1018,8 @@ static void cp_init_hw (struct cp_private *cp)
 	cpw8_f (Cfg9346, Cfg9346_Unlock);
 
 	/* Restore our idea of the MAC address. */
-	cpw32_f (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
-	cpw32_f (MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr + 4)));
+	cpw32_f(MAC0 + 0, get_le32(dev->dev_addr + 0));
+	cpw32_f(MAC0 + 4, get_le32(dev->dev_addr + 4));
 
 	cp_start_hw(cp);
 	cpw8(TxThresh, 0x06); /* XXX convert magic num to a constant */
diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index 53bd903..4204d6c 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -1373,8 +1373,8 @@ static void rtl8139_hw_start (struct net_device *dev)
 	/* unlock Config[01234] and BMCR register writes */
 	RTL_W8_F (Cfg9346, Cfg9346_Unlock);
 	/* Restore our idea of the MAC address. */
-	RTL_W32_F (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
-	RTL_W32_F (MAC0 + 4, le16_to_cpu (*(__le16 *) (dev->dev_addr + 4)));
+	RTL_W32_F(MAC0 + 0, get_le32(dev->dev_addr + 0));
+	RTL_W32_F(MAC0 + 4, get_le16(dev->dev_addr + 4));
 
 	/* Must enable Tx/Rx before setting transfer thresholds! */
 	RTL_W8 (ChipCmd, CmdRxEnb | CmdTxEnb);
@@ -1945,7 +1945,7 @@ static int rtl8139_rx(struct net_device *dev, struct rtl8139_private *tp,
 		rmb();
 
 		/* read size+status of next frame from DMA ring buffer */
-		rx_status = le32_to_cpu (*(__le32 *) (rx_ring + ring_offset));
+		rx_status = get_le32(rx_ring + ring_offset);
 		rx_size = rx_status >> 16;
 		pkt_size = rx_size - 4;
 
diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 89c0018..fb592d5 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -534,8 +534,8 @@ void setup_system_regs(struct net_device *dev)
 
 static void setup_mac_addr(u8 *mac_addr)
 {
-	u32 addr_low = le32_to_cpu(*(__le32 *) & mac_addr[0]);
-	u16 addr_hi = le16_to_cpu(*(__le16 *) & mac_addr[4]);
+	u32 addr_low = get_le32(&mac_addr[0]);
+	u16 addr_hi = get_le16(&mac_addr[4]);
 
 	/* this depends on a little-endian machine */
 	bfin_write_EMAC_ADDRLO(addr_low);
@@ -974,8 +974,8 @@ static int __init bfin_mac_probe(struct platform_device *pdev)
 	lp = netdev_priv(ndev);
 
 	/* Grab the MAC address in the MAC */
-	*(__le32 *) (&(ndev->dev_addr[0])) = cpu_to_le32(bfin_read_EMAC_ADDRLO());
-	*(__le16 *) (&(ndev->dev_addr[4])) = cpu_to_le16((u16) bfin_read_EMAC_ADDRHI());
+	put_le32(bfin_read_EMAC_ADDRLO(), &ndev->dev_addr[0]);
+	put_le16(bfin_read_EMAC_ADDRHI(), &ndev->dev_addr[4]);
 
 	/* probe mac */
 	/*todo: how to proble? which is revision_register */
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 35f66d4..ea8f3ef 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -2938,8 +2938,8 @@ static void nv_set_multicast(struct net_device *dev)
 				walk = dev->mc_list;
 				while (walk != NULL) {
 					u32 a, b;
-					a = le32_to_cpu(*(__le32 *) walk->dmi_addr);
-					b = le16_to_cpu(*(__le16 *) (&walk->dmi_addr[4]));
+					a = get_le32(walk->dmi_addr);
+					b = get_le16(&walk->dmi_addr[4]);
 					alwaysOn[0] &= a;
 					alwaysOff[0] &= ~a;
 					alwaysOn[1] &= b;
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index e141a15..e276b68 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -458,7 +458,7 @@ static void mlx4_free_eq(struct mlx4_dev *dev,
 		for (i = 0; i < sizeof (struct mlx4_eq_context) / 4; ++i) {
 			if (i % 4 == 0)
 				printk("[%02x] ", i * 4);
-			printk(" %08x", be32_to_cpup(mailbox->buf + i * 4));
+			printk(" %08x", get_be32(mailbox->buf + i * 4));
 			if ((i + 1) % 4 == 0)
 				printk("\n");
 		}
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index d82f275..5239581 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -51,9 +51,9 @@ extern void __buggy_use_of_MLX4_PUT(void);
 		void *__p = (char *) (source) + (offset);	      \
 		switch (sizeof (dest)) {			      \
 		case 1: (dest) = *(u8 *) __p;	    break;	      \
-		case 2: (dest) = be16_to_cpup(__p); break;	      \
-		case 4: (dest) = be32_to_cpup(__p); break;	      \
-		case 8: (dest) = be64_to_cpup(__p); break;	      \
+		case 2: (dest) = get_be16(__p);	    break;	      \
+		case 4: (dest) = get_be32(__p);	    break;	      \
+		case 8: (dest) = get_be64(__p);	    break;	      \
 		default: __buggy_use_of_MLX4_GET();		      \
 		}						      \
 	} while (0)
@@ -63,9 +63,9 @@ extern void __buggy_use_of_MLX4_PUT(void);
 		void *__d = ((char *) (dest) + (offset));	      \
 		switch (sizeof(source)) {			      \
 		case 1: *(u8 *) __d = (source);		       break; \
-		case 2:	*(__be16 *) __d = cpu_to_be16(source); break; \
-		case 4:	*(__be32 *) __d = cpu_to_be32(source); break; \
-		case 8:	*(__be64 *) __d = cpu_to_be64(source); break; \
+		case 2:	put_be16(source, __d);		       break; \
+		case 4:	put_be32(source, __d);		       break; \
+		case 8:	put_be64(source, __d);		       break; \
 		default: __buggy_use_of_MLX4_PUT();		      \
 		}						      \
 	} while (0)
@@ -604,8 +604,8 @@ static void get_board_id(void *vsd, char *board_id)
 
 	memset(board_id, 0, MLX4_BOARD_ID_LEN);
 
-	if (be16_to_cpup(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
-	    be16_to_cpup(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
+	if (get_be16(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
+	    get_be16(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
 		strlcpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID, MLX4_BOARD_ID_LEN);
 	} else {
 		/*
diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index 45fa33e..9544f92 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -443,7 +443,7 @@ static int do_rom_fast_read_words(struct netxen_adapter *adapter, int addr,
 		ret = do_rom_fast_read(adapter, addridx, &v);
 		if (ret != 0)
 			break;
-		*(__le32 *)bytes = cpu_to_le32(v);
+		put_le32(v, bytes);
 		bytes += 4;
 	}
 
diff --git a/drivers/net/netxen/netxen_nic_niu.c b/drivers/net/netxen/netxen_nic_niu.c
index 1c852a7..1c2c7f9 100644
--- a/drivers/net/netxen/netxen_nic_niu.c
+++ b/drivers/net/netxen/netxen_nic_niu.c
@@ -587,8 +587,8 @@ static int netxen_niu_macaddr_get(struct netxen_adapter *adapter,
 	if (netxen_nic_hw_read_wx(adapter, NETXEN_NIU_GB_STATION_ADDR_1(phy),
 				  &stationlow, 4))
 		return -EIO;
-	((__le32 *)val)[1] = cpu_to_le32(stationhigh);
-	((__le32 *)val)[0] = cpu_to_le32(stationlow);
+	put_le32(stationhigh, val + 4);
+	put_le32(stationlow, val);
 
 	memcpy(addr, val + 2, 6);
 
@@ -612,13 +612,13 @@ int netxen_niu_macaddr_set(struct netxen_adapter *adapter,
 	for (i = 0; i < 10; i++) {
 		temp[0] = temp[1] = 0;
 		memcpy(temp + 2, addr, 2);
-		val = le32_to_cpu(*(__le32 *)temp);
+		val = get_le32(temp);
 		if (netxen_nic_hw_write_wx
 		    (adapter, NETXEN_NIU_GB_STATION_ADDR_1(phy), &val, 4))
 			return -EIO;
 
 		memcpy(temp, ((u8 *) addr) + 2, sizeof(__le32));
-		val = le32_to_cpu(*(__le32 *)temp);
+		val = get_le32(temp);
 		if (netxen_nic_hw_write_wx
 		    (adapter, NETXEN_NIU_GB_STATION_ADDR_0(phy), &val, 4))
 			return -2;
@@ -825,13 +825,13 @@ int netxen_niu_xg_macaddr_set(struct netxen_adapter *adapter,
 	switch (phy) {
 	case 0:
 	    memcpy(temp + 2, addr, 2);
-	    val = le32_to_cpu(*(__le32 *)temp);
+	    val = get_le32(temp);
 	    if (netxen_nic_hw_write_wx(adapter, NETXEN_NIU_XGE_STATION_ADDR_0_1,
 				&val, 4))
 		return -EIO;
 
 	    memcpy(&temp, ((u8 *) addr) + 2, sizeof(__le32));
-	    val = le32_to_cpu(*(__le32 *)temp);
+	    val = get_le32(temp);
 	    if (netxen_nic_hw_write_wx(adapter, NETXEN_NIU_XGE_STATION_ADDR_0_HI,
 				&val, 4))
 		return -EIO;
@@ -839,13 +839,13 @@ int netxen_niu_xg_macaddr_set(struct netxen_adapter *adapter,
 
 	case 1:
 	    memcpy(temp + 2, addr, 2);
-	    val = le32_to_cpu(*(__le32 *)temp);
+	    val = get_le32(temp);
 	    if (netxen_nic_hw_write_wx(adapter, NETXEN_NIU_XG1_STATION_ADDR_0_1,
 				&val, 4))
 		return -EIO;
 
 	    memcpy(&temp, ((u8 *) addr) + 2, sizeof(__le32));
-	    val = le32_to_cpu(*(__le32 *)temp);
+	    val = get_le32(temp);
 	    if (netxen_nic_hw_write_wx(adapter, NETXEN_NIU_XG1_STATION_ADDR_0_HI,
 				&val, 4))
 		return -EIO;
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 918f802..ed42d35 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -3034,7 +3034,7 @@ static int niu_rx_pkt_ignore(struct niu *np, struct rx_ring_info *rp)
 
 		num_rcr++;
 
-		val = le64_to_cpup(&rp->rcr[index]);
+		val = get_le64(&rp->rcr[index]);
 		addr = (val & RCR_ENTRY_PKT_BUF_ADDR) <<
 			RCR_ENTRY_PKT_BUF_ADDR_SHIFT;
 		page = niu_find_rxpage(rp, addr, &link);
@@ -3079,7 +3079,7 @@ static int niu_process_rx_pkt(struct niu *np, struct rx_ring_info *rp)
 
 		num_rcr++;
 
-		val = le64_to_cpup(&rp->rcr[index]);
+		val = get_le64(&rp->rcr[index]);
 
 		len = (val & RCR_ENTRY_L2_LEN) >>
 			RCR_ENTRY_L2_LEN_SHIFT;
@@ -3199,7 +3199,7 @@ static int release_tx_packet(struct niu *np, struct tx_ring_info *rp, int idx)
 	int i, len;
 
 	tp = (struct tx_pkt_hdr *) skb->data;
-	tx_flags = le64_to_cpup(&tp->flags);
+	tx_flags = get_le64(&tp->flags);
 
 	rp->tx_packets++;
 	rp->tx_bytes += (((tx_flags & TXHDR_LEN) >> TXHDR_LEN_SHIFT) -
@@ -3282,8 +3282,8 @@ static int niu_rx_work(struct niu *np, struct rx_ring_info *rp, int budget)
 	stat = nr64(RX_DMA_CTL_STAT(rp->rx_channel));
 	qlen = nr64(RCRSTAT_A(rp->rx_channel)) & RCRSTAT_A_QLEN;
 #else
-	stat = le64_to_cpup(&mbox->rx_dma_ctl_stat);
-	qlen = (le64_to_cpup(&mbox->rcrstat_a) & RCRSTAT_A_QLEN);
+	stat = get_le64(&mbox->rx_dma_ctl_stat);
+	qlen = get_le64(&mbox->rcrstat_a) & RCRSTAT_A_QLEN;
 #endif
 	mbox->rx_dma_ctl_stat = 0;
 	mbox->rcrstat_a = 0;
@@ -3722,7 +3722,7 @@ static void niu_rxchan_intr(struct niu *np, struct rx_ring_info *rp,
 			    int ldn)
 {
 	struct rxdma_mailbox *mbox = rp->mbox;
-	u64 stat_write, stat = le64_to_cpup(&mbox->rx_dma_ctl_stat);
+	u64 stat_write, stat = get_le64(&mbox->rx_dma_ctl_stat);
 
 	stat_write = (RX_DMA_CTL_STAT_RCRTHRES |
 		      RX_DMA_CTL_STAT_RCRTO);
diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index 7935991..0b0424e 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -518,7 +518,7 @@ static int pppol2tp_recv_core(struct sock *sock, struct sk_buff *skb)
 	optr = ptr = skb->data;
 
 	/* Get L2TP header flags */
-	hdrflags = ntohs(*(__be16*)ptr);
+	hdrflags = get_be16(ptr);
 
 	/* Trace packet contents, if enabled */
 	if (tunnel->debug & PPPOL2TP_MSG_DATA) {
@@ -554,9 +554,9 @@ static int pppol2tp_recv_core(struct sock *sock, struct sk_buff *skb)
 		ptr += 2;
 
 	/* Extract tunnel and session ID */
-	tunnel_id = ntohs(*(__be16 *) ptr);
+	tunnel_id = get_be16(ptr);
 	ptr += 2;
-	session_id = ntohs(*(__be16 *) ptr);
+	session_id = get_be16(ptr);
 	ptr += 2;
 
 	/* Find the session context */
@@ -582,9 +582,9 @@ static int pppol2tp_recv_core(struct sock *sock, struct sk_buff *skb)
 	 */
 	if (hdrflags & L2TP_HDRFLAG_S) {
 		u16 ns, nr;
-		ns = ntohs(*(__be16 *) ptr);
+		ns = get_be16(ptr);
 		ptr += 2;
-		nr = ntohs(*(__be16 *) ptr);
+		nr = get_be16(ptr);
 		ptr += 2;
 
 		/* Received a packet with sequence numbers. If we're the LNS,
@@ -642,7 +642,7 @@ static int pppol2tp_recv_core(struct sock *sock, struct sk_buff *skb)
 
 	/* If offset bit set, skip it. */
 	if (hdrflags & L2TP_HDRFLAG_O) {
-		offset = ntohs(*(__be16 *)ptr);
+		offset = get_be16(ptr);
 		ptr += 2 + offset;
 	}
 
diff --git a/drivers/net/rrunner.c b/drivers/net/rrunner.c
index 3dd8f13..1ebffb5 100644
--- a/drivers/net/rrunner.c
+++ b/drivers/net/rrunner.c
@@ -544,10 +544,10 @@ static int __devinit rr_init(struct net_device *dev)
 	 * other method I've seen.  -VAL
 	 */
 
-	*(__be16 *)(dev->dev_addr) =
-	  htons(rr_read_eeprom_word(rrpriv, offsetof(struct eeprom, manf.BoardULA)));
-	*(__be32 *)(dev->dev_addr+2) =
-	  htonl(rr_read_eeprom_word(rrpriv, offsetof(struct eeprom, manf.BoardULA[4])));
+	put_be16(rr_read_eeprom_word(rrpriv, offsetof(struct eeprom, manf.BoardULA)),
+		 dev->dev_addr);
+	put_be32(rr_read_eeprom_word(rrpriv, offsetof(struct eeprom, manf.BoardULA[4])),
+		 dev->dev_addr + 2);
 
 	printk("  MAC: %s\n", print_mac(mac, dev->dev_addr));
 
diff --git a/drivers/net/sc92031.c b/drivers/net/sc92031.c
index f64a860..ac13fc8 100644
--- a/drivers/net/sc92031.c
+++ b/drivers/net/sc92031.c
@@ -771,7 +771,7 @@ static void _sc92031_rx_tasklet(struct net_device *dev)
 		unsigned rx_size, rx_size_align, pkt_size;
 		struct sk_buff *skb;
 
-		rx_status = le32_to_cpup((__le32 *)(rx_ring + rx_ring_offset));
+		rx_status = get_le32(rx_ring + rx_ring_offset);
 		rmb();
 
 		rx_size = rx_status >> 20;
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index b4e7f30..9db1efc 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -237,7 +237,7 @@ static void pci_hme_write_txd(struct happy_meal_txd *txd, u32 flags, u32 addr)
 
 static u32 pci_hme_read_desc32(hme32 *p)
 {
-	return le32_to_cpup((__le32 *)p);
+	return get_le32(p);
 }
 
 #define hme_write32(__hp, __reg, __val) \
@@ -302,7 +302,7 @@ do {	(__txd)->tx_addr = (__force hme32)cpu_to_le32(__addr); \
 } while(0)
 static inline u32 hme_read_desc32(struct happy_meal *hp, hme32 *p)
 {
-	return le32_to_cpup((__le32 *)p);
+	return get_le32(p);
 }
 #define hme_dma_map(__hp, __ptr, __size, __dir) \
 	pci_map_single((__hp)->happy_dev, (__ptr), (__size), (__dir))
diff --git a/drivers/net/tulip/dmfe.c b/drivers/net/tulip/dmfe.c
index 6562004..27975ec 100644
--- a/drivers/net/tulip/dmfe.c
+++ b/drivers/net/tulip/dmfe.c
@@ -1909,7 +1909,7 @@ static void dmfe_parse_srom(struct dmfe_board_info * db)
 	if ( ( (int) srom[18] & 0xff) == SROM_V41_CODE) {
 		/* SROM V4.01 */
 		/* Get NIC support media mode */
-		db->NIC_capability = le16_to_cpup((__le16 *) (srom + 34));
+		db->NIC_capability = get_le16(srom + 34);
 		db->PHY_reg4 = 0;
 		for (tmp_reg = 1; tmp_reg < 0x10; tmp_reg <<= 1) {
 			switch( db->NIC_capability & tmp_reg ) {
@@ -1921,8 +1921,7 @@ static void dmfe_parse_srom(struct dmfe_board_info * db)
 		}
 
 		/* Media Mode Force or not check */
-		dmfe_mode = (le32_to_cpup((__le32 *) (srom + 34)) &
-			     le32_to_cpup((__le32 *) (srom + 36)));
+		dmfe_mode = (get_le32(srom + 34) & get_le32(srom + 36));
 		switch(dmfe_mode) {
 		case 0x4: dmfe_media_mode = DMFE_100MHF; break;	/* 100MHF */
 		case 0x2: dmfe_media_mode = DMFE_10MFD; break;	/* 10MFD */
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0ce07a3..2e47a10 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -552,7 +552,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		/* Be promiscuous by default to maintain previous behaviour. */
 		tun->if_flags = IFF_PROMISC;
 		/* Generate random Ethernet address. */
-		*(__be16 *)tun->dev_addr = htons(0x00FF);
+		put_be16(0x00FF, tun->dev_addr);
 		get_random_bytes(tun->dev_addr + sizeof(u16), 4);
 		memset(tun->chr_filter, 0, sizeof tun->chr_filter);
 
diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index c0dd25b..e1d343c 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -1927,8 +1927,8 @@ typhoon_start_runtime(struct typhoon *tp)
 		goto error_out;
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_SET_MAC_ADDRESS);
-	xp_cmd.parm1 = cpu_to_le16(ntohs(*(__be16 *)&dev->dev_addr[0]));
-	xp_cmd.parm2 = cpu_to_le32(ntohl(*(__be32 *)&dev->dev_addr[2]));
+	xp_cmd.parm1 = cpu_to_le16(get_be16(&dev->dev_addr[0]));
+	xp_cmd.parm2 = cpu_to_le32(get_be32(&dev->dev_addr[2]));
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
 	if(err < 0)
 		goto error_out;
@@ -2227,8 +2227,8 @@ typhoon_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_SET_MAC_ADDRESS);
-	xp_cmd.parm1 = cpu_to_le16(ntohs(*(__be16 *)&dev->dev_addr[0]));
-	xp_cmd.parm2 = cpu_to_le32(ntohl(*(__be32 *)&dev->dev_addr[2]));
+	xp_cmd.parm1 = cpu_to_le16(get_be16(&dev->dev_addr[0]));
+	xp_cmd.parm2 = cpu_to_le32(get_be32(&dev->dev_addr[2]));
 	if(typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL) < 0) {
 		printk(KERN_ERR "%s: unable to set mac address in suspend\n",
 				dev->name);
@@ -2463,8 +2463,8 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto error_out_reset;
 	}
 
-	*(__be16 *)&dev->dev_addr[0] = htons(le16_to_cpu(xp_resp[0].parm1));
-	*(__be32 *)&dev->dev_addr[2] = htonl(le32_to_cpu(xp_resp[0].parm2));
+	put_be16(le16_to_cpu(xp_resp[0].parm1), &dev->dev_addr[0]);
+	put_be32(le32_to_cpu(xp_resp[0].parm2), &dev->dev_addr[2]);
 
 	if(!is_valid_ether_addr(dev->dev_addr)) {
 		printk(ERR_PFX "%s: Could not obtain valid ethernet address, "
diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 76752d8..589286b 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -242,7 +242,7 @@ static void catc_rx_done(struct urb *urb)
 
 	do {
 		if(!catc->is_f5u011) {
-			pkt_len = le16_to_cpup((__le16*)pkt_start);
+			pkt_len = get_le16(pkt_start);
 			if (pkt_len > urb->actual_length) {
 				catc->stats.rx_length_errors++;
 				catc->stats.rx_errors++;
@@ -302,7 +302,7 @@ static void catc_irq_done(struct urb *urb)
 		else if (data[1] & 0x20)
 			linksts = LinkBad;
 	} else {
-		hasdata = (unsigned int)(be16_to_cpup((__be16*)data) & 0x0fff);
+		hasdata = (unsigned int)(get_be16(data) & 0x0fff);
 		if (data[0] == 0x90)
 			linksts = LinkGood;
 		else if (data[0] == 0xA0)
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 0dcfc03..0cff7e1 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -589,7 +589,7 @@ static void kaweth_usb_receive(struct urb *urb)
 	int count = urb->actual_length;
 	int count2 = urb->transfer_buffer_length;
 
-	__u16 pkt_len = le16_to_cpup((__le16 *)kaweth->rx_buf);
+	__u16 pkt_len = get_le16(kaweth->rx_buf);
 
 	struct sk_buff *skb;
 
diff --git a/drivers/net/usb/net1080.c b/drivers/net/usb/net1080.c
index 034e8a7..4304278 100644
--- a/drivers/net/usb/net1080.c
+++ b/drivers/net/usb/net1080.c
@@ -439,8 +439,8 @@ static int net1080_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	}
 
 	header = (struct nc_header *) skb->data;
-	hdr_len = le16_to_cpup(&header->hdr_len);
-	packet_len = le16_to_cpup(&header->packet_len);
+	hdr_len = get_le16(&header->hdr_len);
+	packet_len = get_le16(&header->packet_len);
 	if (FRAMED_SIZE(packet_len) > NC_MAX_PACKET) {
 		dev->stats.rx_frame_errors++;
 		dbg("packet too big, %d", packet_len);
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index b588c89..2a4f981 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -665,7 +665,7 @@ static void read_bulk_callback(struct urb *urb)
 		goto goon;
 	}
 	if (pegasus->chip == 0x8513) {
-		pkt_len = le32_to_cpu(*(__le32 *)urb->transfer_buffer);
+		pkt_len = get_le32(urb->transfer_buffer);
 		pkt_len &= 0x0fff;
 		pegasus->rx_skb->data += 2;
 	} else {
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 21a7785..9305179 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -407,7 +407,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 	u.set->oid = OID_GEN_CURRENT_PACKET_FILTER;
 	u.set->len = ccpu2(4);
 	u.set->offset = ccpu2((sizeof *u.set) - 8);
-	*(__le32 *)(u.buf + sizeof *u.set) = RNDIS_DEFAULT_FILTER;
+	put_le32(RNDIS_DEFAULT_FILTER, u.buf + sizeof(*u.set));
 
 	retval = rndis_command(dev, u.header);
 	if (unlikely(retval < 0)) {
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index df56a51..e806301 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -455,7 +455,7 @@ static void read_bulk_callback(struct urb *urb)
 		goto goon;
 
 	res = urb->actual_length;
-	rx_stat = le16_to_cpu(*(__le16 *)(urb->transfer_buffer + res - 4));
+	rx_stat = get_le16(urb->transfer_buffer + res - 4);
 	pkt_len = res - 4;
 
 	skb_put(dev->rx_skb, pkt_len);
diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 5c0d2b0..8e24407 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1293,7 +1293,7 @@ static void adm8211_set_bssid(struct ieee80211_hw *dev, const u8 *bssid)
 	struct adm8211_priv *priv = dev->priv;
 	u32 reg;
 
-	ADM8211_CSR_WRITE(BSSID0, le32_to_cpu(*(__le32 *)bssid));
+	ADM8211_CSR_WRITE(BSSID0, get_le32(bssid));
 	reg = ADM8211_CSR_READ(ABDA1);
 	reg &= 0x0000ffff;
 	reg |= (bssid[4] << 16) | (bssid[5] << 24);
@@ -1425,8 +1425,8 @@ static int adm8211_add_interface(struct ieee80211_hw *dev,
 
 	ADM8211_IDLE();
 
-	ADM8211_CSR_WRITE(PAR0, le32_to_cpu(*(__le32 *)conf->mac_addr));
-	ADM8211_CSR_WRITE(PAR1, le16_to_cpu(*(__le16 *)(conf->mac_addr + 4)));
+	ADM8211_CSR_WRITE(PAR0, get_le32(conf->mac_addr));
+	ADM8211_CSR_WRITE(PAR1, get_le16(conf->mac_addr + 4));
 
 	adm8211_update_mode(dev);
 
@@ -1881,9 +1881,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	*(__le32 *)perm_addr = cpu_to_le32(ADM8211_CSR_READ(PAR0));
-	*(__le16 *)&perm_addr[4] =
-		cpu_to_le16(ADM8211_CSR_READ(PAR1) & 0xFFFF);
+	put_le32(ADM8211_CSR_READ(PAR0), perm_addr);
+	put_le16(ADM8211_CSR_READ(PAR1) & 0xFFFF, &perm_addr[4]);
 
 	if (!is_valid_ether_addr(perm_addr)) {
 		printk(KERN_WARNING "%s (adm8211): Invalid hwaddr in EEPROM!\n",
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 0ca0bfe..1a6e169 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -84,7 +84,7 @@ static int prism2_get_datarates(struct net_device *dev, u8 *rates)
 	if (len < 2)
 		return 0;
 
-	val = le16_to_cpu(*(__le16 *) buf); /* string length */
+	val = get_le16(buf); /* string length */
 
 	if (len - 2 < val || val > 10)
 		return 0;
@@ -812,7 +812,7 @@ static int prism2_ioctl_giwnickn(struct net_device *dev,
 
 	len = local->func->get_rid(dev, HFA384X_RID_CNFOWNNAME,
 				   &name, MAX_NAME_LEN + 2, 0);
-	val = le16_to_cpu(*(__le16 *) name);
+	val = get_le16(name);
 	if (len > MAX_NAME_LEN + 2 || len < 0 || val > MAX_NAME_LEN)
 		return -EOPNOTSUPP;
 
@@ -963,7 +963,7 @@ static int prism2_ioctl_giwessid(struct net_device *dev,
 		memset(ssid, 0, sizeof(ssid));
 		len = local->func->get_rid(dev, HFA384X_RID_CURRENTSSID,
 					   &ssid, MAX_SSID_LEN + 2, 0);
-		val = le16_to_cpu(*(__le16 *) ssid);
+		val = get_le16(ssid);
 		if (len > MAX_SSID_LEN + 2 || len < 0 || val > MAX_SSID_LEN) {
 			return -EOPNOTSUPP;
 		}
@@ -3097,7 +3097,7 @@ static int prism2_set_genericelement(struct net_device *dev, u8 *elem,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	*((__le16 *) buf) = cpu_to_le16(len);
+	put_le16(len, buf);
 	memcpy(buf + 2, elem, len);
 
 	kfree(local->generic_elem);
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 6328b95..652b0ad 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -537,8 +537,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
 				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
 				ulTemp = *(u32 *)pdata_buf;
-				*((__le16 *)(pSNMPMIB->value)) =
-				    cpu_to_le16((u16) ulTemp);
+				put_le16(ulTemp, pSNMPMIB->value);
 			}
 			break;
 		}
@@ -555,9 +554,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
 				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
 				ulTemp = *((u32 *) pdata_buf);
-				*((__le16 *)(pSNMPMIB->value)) =
-				    cpu_to_le16((u16) ulTemp);
-
+				put_le16(ulTemp, pSNMPMIB->value);
 			}
 
 			break;
@@ -575,8 +572,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
 				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
 				ulTemp = *((u32 *)pdata_buf);
-				*(__le16 *)(pSNMPMIB->value) =
-				    cpu_to_le16((u16) ulTemp);
+				put_le16(ulTemp, pSNMPMIB->value);
 
 			}
 			break;
@@ -589,8 +585,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 		} else if (cmd_action == CMD_ACT_SET) {
 			pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
 			pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
-			*((__le16 *)(pSNMPMIB->value)) =
-			    cpu_to_le16((u16) priv->txretrycount);
+			put_le16(priv->txretrycount, pSNMPMIB->value);
 		}
 
 		break;
@@ -607,7 +602,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 	       "SNMP_CMD: action 0x%x, oid 0x%x, oidsize 0x%x, value 0x%x\n",
 	       le16_to_cpu(pSNMPMIB->querytype), le16_to_cpu(pSNMPMIB->oid),
 	       le16_to_cpu(pSNMPMIB->bufsize),
-	       le16_to_cpu(*(__le16 *) pSNMPMIB->value));
+	       get_le16(pSNMPMIB->value));
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index d448c97..e189074 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -567,11 +567,11 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 	pos += 8;
 
 	/* beacon interval is 2 bytes long */
-	bss->beaconperiod = le16_to_cpup((void *) pos);
+	bss->beaconperiod = get_le16(pos);
 	pos += 2;
 
 	/* capability information is 2 bytes long */
-	bss->capability = le16_to_cpup((void *) pos);
+	bss->capability = get_le16(pos);
 	lbs_deb_scan("process_bss: capabilities 0x%04x\n", bss->capability);
 	pos += 2;
 
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 6d13a0d..c82c126 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1167,7 +1167,7 @@ static int orinoco_process_scan_results(struct net_device *dev,
 	case FIRMWARE_TYPE_INTERSIL:
 		offset = 4;
 		if (priv->has_hostscan) {
-			atom_len = le16_to_cpup((__le16 *)buf);
+			atom_len = get_le16(buf);
 			/* Sanity check for atom_len */
 			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
 				printk(KERN_ERR "%s: Invalid atom_len in scan "
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 63f9bad..a38314a 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -94,7 +94,7 @@ void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
-			switch (be32_to_cpu(*(__be32 *)bootrec->data)) {
+			switch (get_be32(bootrec->data)) {
 			case FW_FMAC:
 				printk(KERN_INFO "p54: FreeMAC firmware\n");
 				break;
diff --git a/drivers/net/wireless/prism54/islpci_mgt.h b/drivers/net/wireless/prism54/islpci_mgt.h
index f91a88f..32a2560 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.h
+++ b/drivers/net/wireless/prism54/islpci_mgt.h
@@ -86,9 +86,9 @@ extern int pc_debug;
 #define PIMFOR_FLAG_LITTLE_ENDIAN               0x02
 
 static inline void
-add_le32p(__le32 * le_number, u32 add)
+add_le32p(__le32 *le_number, u32 add)
 {
-	*le_number = cpu_to_le32(le32_to_cpup(le_number) + add);
+	le32_add_cpu(le_number, add);
 }
 
 void display_buffer(char *, int);
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index c181f23..5d86bf4 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -688,9 +688,9 @@ static int rtl8180_add_interface(struct ieee80211_hw *dev,
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->MAC[0],
-			  le32_to_cpu(*(__le32 *)conf->mac_addr));
+			  get_le32(conf->mac_addr));
 	rtl818x_iowrite16(priv, (__le16 __iomem *)&priv->map->MAC[4],
-			  le16_to_cpu(*(__le16 *)(conf->mac_addr + 4)));
+			  get_le16(conf->mac_addr + 4));
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	return 0;
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index d5c0c66..40a95f7 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -311,8 +311,8 @@ static void zd1201_usbrx(struct urb *urb)
 		len = ntohs(*(__be16 *)&data[datalen-2]);
 		if (len>datalen)
 			len=datalen;
-		fc = le16_to_cpu(*(__le16 *)&data[datalen-16]);
-		seq = le16_to_cpu(*(__le16 *)&data[datalen-24]);
+		fc = get_le16(&data[datalen - 16]);
+		seq = get_le16(&data[datalen - 24]);
 
 		if (zd->monitor) {
 			if (datalen < 24)
@@ -716,7 +716,7 @@ static int zd1201_join(struct zd1201 *zd, char *essid, int essidlen)
 	if (err)
 		return err;
 
-	*(__le16 *)buf = cpu_to_le16(essidlen);
+	put_le16(essidlen, buf);
 	memcpy(buf+2, essid, essidlen);
 	if (!zd->ap) {	/* Normal station */
 		err = zd1201_setconfig(zd, ZD1201_RID_CNFDESIREDSSID, buf,
@@ -998,7 +998,7 @@ static int zd1201_set_mode(struct net_device *dev,
 		return err;
 	if (zd->monitor && !monitor) {
 			zd1201_disable(zd);
-			*(__le16 *)buffer = cpu_to_le16(zd->essidlen);
+			put_le16(zd->essidlen, buffer);
 			memcpy(buffer+2, zd->essid, zd->essidlen);
 			err = zd1201_setconfig(zd, ZD1201_RID_CNFDESIREDSSID,
 			    buffer, IW_ESSID_MAX_SIZE+2, 1);
-- 
1.5.5.1.570.g26b5e


