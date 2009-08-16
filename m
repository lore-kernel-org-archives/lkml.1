Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZHPT3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZHPT3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZHPT3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:29:50 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49711 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbZHPT3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l/bE1kHqRwfkVUSb7T38I5iOGfMLCY/10am7d8Uy8GIKkzHqp0YSN6N1JjZ7uyDQwx
         zOH0aBl3aBM1/qn+WJtHiqvpw0/Rp5DsAVR4xdlTH7yDak9zcKluMNstKYrc+3NaB2t0
         O6SrrPuF1ZhmVRMO1TmMrjRFB7o1g+MWAurpA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:29:59 +0200
Message-Id: <20090816192959.3789.63900.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/22] Staging: rtxxx0: remove dead platform specific code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: remove dead platform specific code

Remove dead support for:

* IKANOS_VX_1X0
* INF_TWINPASS
* INF_DANUBE
* BRCM_6358

platforms.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/rt_config.h   |    4 --
 drivers/staging/rt2860/rt_linux.c    |    4 --
 drivers/staging/rt2860/rt_linux.h    |   59 -----------------------------------
 drivers/staging/rt2860/rt_main_dev.c |    7 ----
 drivers/staging/rt2860/rtmp.h        |   16 ---------
 5 files changed, 90 deletions(-)

Index: b/drivers/staging/rt2860/rt_config.h
===================================================================
--- a/drivers/staging/rt2860/rt_config.h
+++ b/drivers/staging/rt2860/rt_config.h
@@ -68,9 +68,5 @@
 #include "igmp_snoop.h"
 #endif // IGMP_SNOOP_SUPPORT //
 
-#ifdef IKANOS_VX_1X0
-#include	"vr_ikans.h"
-#endif // IKANOS_VX_1X0 //
-
 #endif	// __RT_CONFIG_H__
 
Index: b/drivers/staging/rt2860/rt_linux.c
===================================================================
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -662,13 +662,9 @@ void announce_802_3_packet(
 	pRxPkt = RTPKT_TO_OSPKT(pPacket);
 
     /* Push up the protocol stack */
-#ifdef IKANOS_VX_1X0
-	IKANOS_DataFrameRx(pAd, pRxPkt->dev, pRxPkt, pRxPkt->len);
-#else
 	pRxPkt->protocol = eth_type_trans(pRxPkt, pRxPkt->dev);
 
 	netif_rx(pRxPkt);
-#endif // IKANOS_VX_1X0 //
 }
 
 
Index: b/drivers/staging/rt2860/rt_linux.h
===================================================================
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -444,51 +444,6 @@ extern ULONG    RTDebugLevel;
 }
 
 #ifdef RT2860
-#if defined(INF_TWINPASS) || defined(INF_DANUBE) || defined(IKANOS_VX_1X0)
-//Patch for ASIC turst read/write bug, needs to remove after metel fix
-#define RTMP_IO_READ32(_A, _R, _pV)									\
-{																	\
-    if ((_A)->bPCIclkOff == FALSE)                                      \
-    {                                                                   \
-	(*_pV = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0)));		\
-	(*_pV = readl((void *)((_A)->CSRBaseAddress + (_R))));			\
-	(*_pV = SWAP32(*((UINT32 *)(_pV))));                           \
-    }                                                                   \
-}
-#define RTMP_IO_FORCE_READ32(_A, _R, _pV)							\
-{																	\
-	(*_pV = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0)));		\
-	(*_pV = readl((void *)((_A)->CSRBaseAddress + (_R))));			\
-	(*_pV = SWAP32(*((UINT32 *)(_pV))));                           \
-}
-#define RTMP_IO_READ8(_A, _R, _pV)									\
-{																	\
-	(*_pV = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0)));		\
-	(*_pV = readb((void *)((_A)->CSRBaseAddress + (_R))));			\
-}
-#define RTMP_IO_WRITE32(_A, _R, _V)									\
-{																	\
-    if ((_A)->bPCIclkOff == FALSE)                                      \
-    {                                                                   \
-	UINT32	_Val;													\
-	_Val = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0));		\
-	_Val = SWAP32(_V);												\
-	writel(_Val, (void *)((_A)->CSRBaseAddress + (_R)));			\
-    }                                                                   \
-}
-#define RTMP_IO_WRITE8(_A, _R, _V)									\
-{																	\
-	UINT	Val;													\
-	Val = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0));		\
-	writeb((_V), (PUCHAR)((_A)->CSRBaseAddress + (_R)));			\
-}
-#define RTMP_IO_WRITE16(_A, _R, _V)									\
-{																	\
-	UINT	Val;													\
-	Val = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0));		\
-	writew(SWAP16((_V)), (PUSHORT)((_A)->CSRBaseAddress + (_R)));	\
-}
-#else
 //Patch for ASIC turst read/write bug, needs to remove after metel fix
 #define RTMP_IO_READ32(_A, _R, _pV)								\
 {																\
@@ -519,32 +474,18 @@ extern ULONG    RTDebugLevel;
 	writel(_V, (void *)((_A)->CSRBaseAddress + (_R)));								\
     }                                                               \
 }
-#if defined(BRCM_6358)
-#define RTMP_IO_WRITE8(_A, _R, _V)            \
-{                    \
-	ULONG Val;                \
-	UCHAR _i;                \
-	_i = (_R & 0x3);             \
-	Val = readl((void *)((_A)->CSRBaseAddress + (_R - _i)));   \
-	Val = Val & (~(0x000000ff << ((_i)*8)));         \
-	Val = Val | ((ULONG)_V << ((_i)*8));         \
-	writel((Val), (void *)((_A)->CSRBaseAddress + (_R - _i)));    \
-}
-#else
 #define RTMP_IO_WRITE8(_A, _R, _V)												\
 {																				\
 	UINT	Val;																\
 	Val = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0));			\
 	writeb((_V), (PUCHAR)((_A)->CSRBaseAddress + (_R)));		\
 }
-#endif
 #define RTMP_IO_WRITE16(_A, _R, _V)												\
 {																				\
 	UINT	Val;																\
 	Val = readl((void *)((_A)->CSRBaseAddress + MAC_CSR0));			\
 	writew((_V), (PUSHORT)((_A)->CSRBaseAddress + (_R)));	\
 }
-#endif
 #endif /* RT2860 */
 #ifdef RT2870
 //Patch for ASIC turst read/write bug, needs to remove after metel fix
Index: b/drivers/staging/rt2860/rt_main_dev.c
===================================================================
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -515,9 +515,6 @@ static int rt28xx_init(IN struct net_dev
 	NICInitRT30xxRFRegisters(pAd);
 #endif // RT2870 //
 
-#ifdef IKANOS_VX_1X0
-	VR_IKANOS_FP_Init(pAd->ApCfg.BssidNum, pAd->PermanentAddress);
-#endif // IKANOS_VX_1X0 //
 
 		//
 	// Initialize RF register to default value
@@ -678,11 +675,7 @@ static const struct net_device_ops rt286
 	.ndo_validate_addr	= NULL,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_change_mtu		= eth_change_mtu,
-#ifdef IKANOS_VX_1X0
-	.ndo_start_xmit		= IKANOS_DataFramesTx,
-#else
 	.ndo_start_xmit		= rt28xx_send_packets,
-#endif
 };
 
 /* Must not be called for mdev and apdev */
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2532,16 +2532,6 @@ typedef struct _INF_USB_CONFIG
 
 }INF_USB_CONFIG;
 
-#ifdef IKANOS_VX_1X0
-	typedef void (*IkanosWlanTxCbFuncP)(void *, void *);
-
-	struct IKANOS_TX_INFO
-	{
-		struct net_device *netdev;
-		IkanosWlanTxCbFuncP *fp;
-	};
-#endif // IKANOS_VX_1X0 //
-
 #ifdef DBG_DIAGNOSE
 #define DIAGNOSE_TIME	10   // 10 sec
 typedef struct _RtmpDiagStrcut_
@@ -2989,12 +2979,6 @@ typedef struct _RTMP_ADAPTER
 	UCHAR					flg_be_adjust;
 	ULONG					be_adjust_last_time;
 
-#ifdef IKANOS_VX_1X0
-	struct IKANOS_TX_INFO	IkanosTxInfo;
-	struct IKANOS_TX_INFO	IkanosRxInfo[MAX_MBSSID_NUM + MAX_WDS_ENTRY + MAX_APCLI_NUM + MAX_MESH_NUM];
-#endif // IKANOS_VX_1X0 //
-
-
 #ifdef DBG_DIAGNOSE
 	RtmpDiagStruct	DiagStruct;
 #endif // DBG_DIAGNOSE //
