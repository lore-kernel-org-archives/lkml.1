Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYDSNfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYDSNfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYDSNfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:35:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57985 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYDSNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:34:58 -0400
Date: Sat, 19 Apr 2008 15:35:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: remove unused struct net_dev
Message-ID: <20080419133541.GA20281@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


remove unused struct net_dev.

---
commit 192dfca4d5a025bd7d14ba1284897e0108a1cee6
tree 3ca911f2fa4a8fbd5e6f4288691e982fb5d3cc7f
parent 08118c99165a5e6c0f6f9e5730175a0708b93b0d
author Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 15:35:08 +0200
committer Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 15:35:08 +0200

 .../net/wireless/winbond/winbondport/linux/wbusb.c |   51 +++-------
 drivers/net/wireless/winbond/winbondport/wblinux.c |  114 +-------------------
 .../net/wireless/winbond/winbondport/wblinux_s.h   |    5 -
 3 files changed, 17 insertions(+), 153 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 500e5bf..d883873 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -1,4 +1,8 @@
-
+/*
+ * Copyright 2008 Pavel Machek <pavel@suse.cz>
+ *
+ * Distribute under GPLv2.
+ */
 #include "sysdef.h"
 #include <net/mac80211.h>
 
@@ -208,7 +212,6 @@ int wb35_probe(struct usb_interface *int
 	PADAPTER	Adapter;
 	PWBLINUX	pWbLinux;
 	PWBUSB		pWbUsb;
-	struct net_device *netdev = NULL;
         struct usb_host_interface *interface;
 	struct usb_endpoint_descriptor *endpoint;
 	int	i, ret = -1;
@@ -245,21 +248,11 @@ int wb35_probe(struct usb_interface *int
 		if (ltmp)  // Is already initialized?
 			break;
 
-		netdev = alloc_etherdev( sizeof(ADAPTER) );
-
-		if (!netdev) {
-			printk("[w35und]init_etherdev out of memory\n");
-			module_put(THIS_MODULE);
-			break;
-		}
 
-		// Clear out the adapter block, which sets all default values to FALSE, or NULL.
-		Adapter = netdev_priv(netdev);
+		Adapter = kzalloc(sizeof(ADAPTER), GFP_KERNEL);
 
-		memset(Adapter, 0, sizeof(ADAPTER));
 		my_adapter = Adapter;
 		pWbLinux = &Adapter->WbLinux;
-		pWbLinux->netdev = netdev;
 		pWbUsb = &Adapter->sHwData.WbUsb;
 		pWbUsb->udev = udev;
 
@@ -276,24 +269,6 @@ int wb35_probe(struct usb_interface *int
 			break;
 		}
 
-		// Set MAC Address
-		{
-			phw_data_t pHwData = &Adapter->sHwData;
-			hal_get_permanent_address(pHwData, netdev->dev_addr);
-		}
-
-		//Moved later, to make possible the changing of MAC
-		//Needs some more work
-		dev_alloc_name(netdev, "wlan%d");
-		SET_NETDEV_DEV(netdev, &intf->dev);
-
-#if 0
-		if (register_netdev(netdev)) {
-			printk("w35und: couldn't register the netdev!\n");
-			break;
-		}
-#endif
-
 		{
 			struct wbsoft_priv *priv;
 			struct ieee80211_hw *dev;
@@ -309,7 +284,13 @@ #endif
 			my_dev = dev;
 
 			SET_IEEE80211_DEV(dev, &udev->dev);
-			SET_IEEE80211_PERM_ADDR(dev, netdev->dev_addr);
+			{
+				phw_data_t pHwData = &Adapter->sHwData;
+				unsigned char		dev_addr[MAX_ADDR_LEN];
+				hal_get_permanent_address(pHwData, dev_addr);
+				SET_IEEE80211_PERM_ADDR(dev, dev_addr);	
+			}
+
 
 			dev->extra_tx_headroom = 12;	/* FIXME */
 			dev->flags = IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
@@ -317,7 +298,7 @@ #endif
 			dev->channel_change_time = 1000;
 			dev->max_rssi = 100;
 
-			dev->queues = 1; /* ADM8211C supports more, maybe ADM8211B too */
+			dev->queues = 1;
 
 			wbsoft_modes[0].num_channels = 1;
 			wbsoft_modes[0].channels = wbsoft_channels;
@@ -339,8 +320,6 @@ #endif
 
 	} while(FALSE);
 
-	if (netdev)
-		free_netdev(netdev);
 	return -ENOMEM;
 }
 
@@ -410,8 +389,6 @@ void wb35_disconnect(struct usb_interfac
 	// Card remove
 	WbWlanHalt(Adapter);
 
-	if (pWbLinux->netdev)
-		free_netdev(pWbLinux->netdev);
 }
 
 
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index 742b2d1..ab7a27c 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -60,127 +60,20 @@ WBLINUX_Initial(PADAPTER Adapter)
 void
 WBLinux_ReceivePacket(PADAPTER Adapter, PRXLAYER1 pRxLayer1)
 {
-	PWBLINUX pWbLinux = &Adapter->WbLinux;
-	struct sk_buff *skb = NULL;
-	PUCHAR		BufAddr;
-	u32		ByteCount = 0;
-	u32		i;
-	u16		BufSize;
-
-	for( i=0; i<pRxLayer1->BufferNumber; i++ ) {
-		BufSize = pRxLayer1->BufferQueue[i].BufferSize;
-		ByteCount += BufSize;
-	}
-#ifdef _PE_RX_DUMP_
-	WBDEBUG(( "[w35und]---> Rx total length =%d BuffNum=%d\n", ByteCount, pRxLayer1->BufferNumber ));
-#endif
-
-	if ((skb = dev_alloc_skb( ByteCount + 2 )) != NULL) {
-		skb->dev = pWbLinux->netdev;
-		skb_reserve( skb, 2 );
-        
-		for (i=0; i<pRxLayer1->BufferNumber; i++) {
-			BufSize = pRxLayer1->BufferQueue[i].BufferSize;
-			BufAddr = pRxLayer1->BufferQueue[i].pBufferAddress;
-			// I Think this fits better - Scythe - 
-			memcpy(skb->data, BufAddr, BufSize);
-			skb_put( skb, BufSize );
-		}
-
-		skb->protocol = eth_type_trans( skb, pWbLinux->netdev );
-
-		netif_rx( skb );
-		pWbLinux->netdev->last_rx = jiffies;
-		pWbLinux->stats.rx_packets ++;
-		pWbLinux->stats.rx_bytes += ByteCount;
-	} else {
-#ifdef _PE_RX_DUMP_
-		WBDEBUG(( "[w35und]RX SKB ALLOCATE IS FAILED !\n" ));
-#endif
-	}
+	BUG();
 }
 
 
 void
 WBLINUX_GetNextPacket(PADAPTER Adapter,  PDESCRIPTOR pDes)
 {
-	PWBLINUX	pWbLinux = &Adapter->WbLinux;
-	struct sk_buff  *pSkb;
-	u8 	        *pSkbBuffer;
-	int		buf_size;
-
-	//Get a Linux packet to transmit
-	pSkb = pWbLinux->skb_array[ pWbLinux->skb_GetIndex ];
-	pWbLinux->skb_array[ pWbLinux->skb_GetIndex ] = NULL;
-
-	// Move the point to the next
-	pWbLinux->skb_GetIndex++;
-	pWbLinux->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
-
-	//================================================================================
-	// Fill the related information into descriptor												//
-	//================================================================================
-	pWbLinux->packet_return = pSkb;
-	pSkbBuffer = pSkb->data;
-	buf_size = pSkb->len;
-	pWbLinux->stats.tx_packets++; // 20060331 move here
-	pWbLinux->stats.tx_bytes += buf_size; // 20060331 move here
-
-	//931130.5.t
-	//		+------------+
-	//		| header + 2 |  <-- DA + SA + T/L
-	//		+------------+
-	//		+-------------------------------+
-	//		| data							|
-	//		+-------------------------------+
-	//					:
-	//					:
-	//
-	DESCRIPTOR_ADD_BUFFER( pDes, pSkbBuffer, DOT_3_TYPE_OFFSET+2 );
-	buf_size -= (DOT_3_TYPE_OFFSET+2);
-	pSkbBuffer += (DOT_3_TYPE_OFFSET+2);
-
-	if (buf_size)
-		DESCRIPTOR_ADD_BUFFER( pDes, pSkbBuffer, (u16)buf_size );
+	BUG();
 }
 
 void
 WBLINUX_GetNextPacketCompleted(PADAPTER Adapter, PDESCRIPTOR pDes)
 {
-	PWBLINUX	pWbLinux = &Adapter->WbLinux;
-	s32		room_space = 0;
-	struct sk_buff *pSkb;
-	unsigned char		IsStart = FALSE;
-
-	// Return the send result to LINUX
-	pSkb = pWbLinux->packet_return;
-	pWbLinux->packet_return = NULL;
-	if (in_irq())
-		dev_kfree_skb_irq(pSkb);
-	else
-		dev_kfree_skb(pSkb);
-	MIB_GS_XMIT_OK_INC;
-
-	// Trying to wakeup the netif if necessary
-	if (pWbLinux->netif_state_stop)	{
-		room_space = pWbLinux->skb_GetIndex - pWbLinux->skb_SetIndex;
-		if (room_space < 0) // Ex: + + G + S + + +
-			room_space += WBLINUX_PACKET_ARRAY_SIZE;
-
-		OS_SPIN_LOCK_ACQUIRED( &pWbLinux->SpinLock );
-		if (pWbLinux->netif_state_stop) {
-			pWbLinux->netif_state_stop = 0;
-			IsStart = TRUE;
-		}
-		OS_SPIN_LOCK_RELEASED( &pWbLinux->SpinLock );
-
-		if (IsStart) {
-#ifdef _PE_TX_DUMP_
-			WBDEBUG(("[w35und] tx netif start---"));
-#endif
-			netif_wake_queue( pWbLinux->netdev );
-		}
-	}
+	BUG();
 }
 
 void
@@ -190,7 +83,6 @@ WBLINUX_Destroy(PADAPTER Adapter)
 
 	WBLINUX_stop( Adapter );
 	OS_SPIN_LOCK_FREE( &pWbNdis->SpinLock );
-	unregister_netdev( pWbLinux->netdev );
 #ifdef _PE_USB_INI_DUMP_
 	WBDEBUG(("[w35und] unregister_netdev!\n"));
 #endif
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux_s.h b/drivers/net/wireless/winbond/winbondport/wblinux_s.h
index 613421a..5f483b7 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wblinux_s.h
@@ -29,13 +29,8 @@ typedef struct _WBLINUX
 	OS_SPIN_LOCK	SpinLock;
 	u32	shutdown;
 
-	// For storing the 802.3 NDIS packet
-	struct net_device_stats 	stats;
-
 	OS_ATOMIC	ThreadCount;
 
-	struct net_device *netdev;
-
 	u32	LinkStatus;		// OS_DISCONNECTED or OS_CONNECTED
 
 	u32	RxByteCount;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
