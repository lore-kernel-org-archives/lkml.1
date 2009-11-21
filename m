Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZKUP1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZKUP1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZKUP1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:27:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:15406 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZKUP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:27:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=U/enK6bIcv43Svb8HNz0CV6xRvaGa/puGg3BaxbqXPSUQ77M1hF5H8bl7F4+rEHXr1
         5L8yeHG+W5jGm6ne8/VMWHXFvc9/iaCVI9d6OIN3z3Gy8Dg2KVVb5NKDSPmWqGSlxlBx
         Lnd8phTp2tIeczhF69bShEDvRrdi/5FUwJnhQ=
Message-ID: <4B0806EC.3050201@gmail.com>
Date: Sat, 21 Nov 2009 16:27:40 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: david@identd.dyndns.org
CC: rt2x00 Users List <users@host1.serialmonkey.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [rt2x00-users] ieee80211_tx_status: headroom too small
References: <30353c3d0911201730n4682ff7dy8225d475599eb9bb@mail.gmail.com>
In-Reply-To: <30353c3d0911201730n4682ff7dy8225d475599eb9bb@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060503090405080102000000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060503090405080102000000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/21/09 02:30, David Ellingsworth wrote:
> Wasn't sure where to send this, but with the latest 2.6.32-rc8-wl
> kernel built from the wireless-testing repository I'm getting a number
> of "ieee80211_tx_status: headroom too small" errors in my syslog. I'm
> using the rt61pci driver in conjunction with hostap as a wpa2 secured
> access point. The relevant information about my card from lspci is:
> 
> 01:08.0 0280: 1814:0301
>         Subsystem: 1458:e934
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64, Cache Line Size: 128 bytes
>         Interrupt: pin A routed to IRQ 18
>         Region 0: Memory at fe6f0000 (32-bit, non-prefetchable) [size=32K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: rt61pci
> 
> If you need any other information, I'll be happy to provide it.
> 

Hi David,

This seems to be caused by the rt2x00 driver not properly declaring its alignment
maneuvring space properly, and thus it doesn't leave enough headroom left for
copying to the monitor interface.

Can you check whether the attached patch fixes the issue for you?
Note: patch looks a bit bigger than it actually is due to indenting cleanups.

---
Gertjan.


--------------060503090405080102000000
Content-Type: text/plain;
 name="align_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="align_fix.diff"

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6e68bc7..f534d70 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1432,7 +1432,8 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			       IEEE80211_HW_SIGNAL_DBM |
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+	    					RT2X00_ALIGN_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1623,20 +1624,21 @@ static const struct data_queue_desc rt2400pci_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2400pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2400pci_queue_rx,
-	.tx		= &rt2400pci_queue_tx,
-	.bcn		= &rt2400pci_queue_bcn,
-	.atim		= &rt2400pci_queue_atim,
-	.lib		= &rt2400pci_rt2x00_ops,
-	.hw		= &rt2400pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
+	.rx			= &rt2400pci_queue_rx,
+	.tx			= &rt2400pci_queue_tx,
+	.bcn			= &rt2400pci_queue_bcn,
+	.atim			= &rt2400pci_queue_atim,
+	.lib			= &rt2400pci_rt2x00_ops,
+	.hw			= &rt2400pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2400pci_rt2x00debug,
+	.debugfs		= &rt2400pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 9a31e5e..ae40947 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1733,7 +1733,8 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+	    					RT2X00_ALIGN_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1922,20 +1923,21 @@ static const struct data_queue_desc rt2500pci_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2500pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2500pci_queue_rx,
-	.tx		= &rt2500pci_queue_tx,
-	.bcn		= &rt2500pci_queue_bcn,
-	.atim		= &rt2500pci_queue_atim,
-	.lib		= &rt2500pci_rt2x00_ops,
-	.hw		= &rt2500pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
+	.rx			= &rt2500pci_queue_rx,
+	.tx			= &rt2500pci_queue_tx,
+	.bcn			= &rt2500pci_queue_bcn,
+	.atim			= &rt2500pci_queue_atim,
+	.lib			= &rt2500pci_rt2x00_ops,
+	.hw			= &rt2500pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2500pci_rt2x00debug,
+	.debugfs		= &rt2500pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b2de43e..02b2e1c 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1656,7 +1656,7 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1823,20 +1823,21 @@ static const struct data_queue_desc rt2500usb_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2500usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2500usb_queue_rx,
-	.tx		= &rt2500usb_queue_tx,
-	.bcn		= &rt2500usb_queue_bcn,
-	.atim		= &rt2500usb_queue_atim,
-	.lib		= &rt2500usb_rt2x00_ops,
-	.hw		= &rt2500usb_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXD_DESC_SIZE,
+	.rx			= &rt2500usb_queue_rx,
+	.tx			= &rt2500usb_queue_tx,
+	.bcn			= &rt2500usb_queue_bcn,
+	.atim			= &rt2500usb_queue_atim,
+	.lib			= &rt2500usb_rt2x00_ops,
+	.hw			= &rt2500usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2500usb_rt2x00debug,
+	.debugfs		= &rt2500usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b809c49..de358b5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2030,11 +2030,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	if (rt2x00_intf_is_usb(rt2x00dev))
-		rt2x00dev->hw->extra_tx_headroom =
-			TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
-	else if (rt2x00_intf_is_pci(rt2x00dev))
-		rt2x00dev->hw->extra_tx_headroom = TXWI_DESC_SIZE;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+	    					RT2X00_L2PAD_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 87a5094..dfc886f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -652,7 +652,7 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
-	__le32 *txwi = (__le32 *)(skb->data - rt2x00dev->hw->extra_tx_headroom);
+	__le32 *txwi = (__le32 *)(skb->data - rt2x00dev->ops->extra_tx_headroom);
 	u32 word;
 
 	/*
@@ -725,14 +725,14 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_BURST,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W1_SD_LEN0,
-			   rt2x00dev->hw->extra_tx_headroom);
+			   rt2x00dev->ops->extra_tx_headroom);
 	rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
 	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
-			   skbdesc->skb_dma + rt2x00dev->hw->extra_tx_headroom);
+			   skbdesc->skb_dma + rt2x00dev->ops->extra_tx_headroom);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
@@ -1201,19 +1201,20 @@ static const struct data_queue_desc rt2800pci_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt2800pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 8,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2800pci_queue_rx,
-	.tx		= &rt2800pci_queue_tx,
-	.bcn		= &rt2800pci_queue_bcn,
-	.lib		= &rt2800pci_rt2x00_ops,
-	.hw		= &rt2800_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 8,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXWI_DESC_SIZE,
+	.rx			= &rt2800pci_queue_rx,
+	.tx			= &rt2800pci_queue_tx,
+	.bcn			= &rt2800pci_queue_bcn,
+	.lib			= &rt2800pci_rt2x00_ops,
+	.hw			= &rt2800_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2800_rt2x00debug,
+	.debugfs		= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9ab15c4..af85d18 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -790,19 +790,20 @@ static const struct data_queue_desc rt2800usb_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt2800usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 8,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2800usb_queue_rx,
-	.tx		= &rt2800usb_queue_tx,
-	.bcn		= &rt2800usb_queue_bcn,
-	.lib		= &rt2800usb_rt2x00_ops,
-	.hw		= &rt2800_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 8,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
+	.rx			= &rt2800usb_queue_rx,
+	.tx			= &rt2800usb_queue_tx,
+	.bcn			= &rt2800usb_queue_bcn,
+	.lib			= &rt2800usb_rt2x00_ops,
+	.hw			= &rt2800_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2800_rt2x00debug,
+	.debugfs		= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1cbb7ac..83008ab 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -113,6 +113,12 @@
 	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
 
 /*
+ * Constants for extra TX headroom for alignment purposes.
+ */
+#define RT2X00_ALIGN_SIZE	4
+#define RT2X00_L2PAD_SIZE	8
+
+/*
  * Standard timing and size defines.
  * These values should follow the ieee80211 specifications.
  */
@@ -588,6 +594,7 @@ struct rt2x00_ops {
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
 	const unsigned int tx_queues;
+	const unsigned int extra_tx_headroom;
 	const struct data_queue_desc *rx;
 	const struct data_queue_desc *tx;
 	const struct data_queue_desc *bcn;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 82d0b89..b743f34 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -104,7 +104,7 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	 * is also mapped to the DMA so it can be used for transfering
 	 * additional descriptor information to the hardware.
 	 */
-	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_push(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->skb_dma =
 	    dma_map_single(rt2x00dev->dev, skb->data, skb->len, DMA_TO_DEVICE);
@@ -112,7 +112,7 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	/*
 	 * Restore data pointer to original location again.
 	 */
-	skb_pull(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_pull(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
 }
@@ -134,7 +134,7 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 		 * by the driver, but it was actually mapped to DMA.
 		 */
 		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma,
-				 skb->len + rt2x00dev->hw->extra_tx_headroom,
+				 skb->len + rt2x00dev->ops->extra_tx_headroom,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index bf04605..956f6be 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2546,7 +2546,8 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+	    					RT2X00_ALIGN_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2788,19 +2789,20 @@ static const struct data_queue_desc rt61pci_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt61pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 4,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt61pci_queue_rx,
-	.tx		= &rt61pci_queue_tx,
-	.bcn		= &rt61pci_queue_bcn,
-	.lib		= &rt61pci_rt2x00_ops,
-	.hw		= &rt61pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 4,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
+	.rx			= &rt61pci_queue_rx,
+	.tx			= &rt61pci_queue_tx,
+	.bcn			= &rt61pci_queue_bcn,
+	.lib			= &rt61pci_rt2x00_ops,
+	.hw			= &rt61pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt61pci_rt2x00debug,
+	.debugfs		= &rt61pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 5bbcf66..d4317dd 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2069,7 +2069,7 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2306,19 +2306,20 @@ static const struct data_queue_desc rt73usb_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt73usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 4,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt73usb_queue_rx,
-	.tx		= &rt73usb_queue_tx,
-	.bcn		= &rt73usb_queue_bcn,
-	.lib		= &rt73usb_rt2x00_ops,
-	.hw		= &rt73usb_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 4,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXD_DESC_SIZE,
+	.rx			= &rt73usb_queue_rx,
+	.tx			= &rt73usb_queue_tx,
+	.bcn			= &rt73usb_queue_bcn,
+	.lib			= &rt73usb_rt2x00_ops,
+	.hw			= &rt73usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt73usb_rt2x00debug,
+	.debugfs		= &rt73usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 

--------------060503090405080102000000--
