Return-Path: <linux-kernel-owner+w=401wt.eu-S934081AbZHWNbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbZHWNbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbZHWNbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:31:39 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49789 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054AbZHWNbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WKu8BFyuhIvOGPsOke6UyK1pYKVbhj8W9UPgLQZonIGdt3hBfVhrYkWQsr9i4j9zp0
         M4daQ3X5brkK3h10TXvR0SqrDF7AvdZecbx2W0iNp7iyEkVsZXnN0rO0jeXCYOOG/UL5
         PV3fbgDHoB2KllIpj9GNnzmt8CF32k8DVsGm4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:32:00 +0200
Message-Id: <20090823133200.17784.16394.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 30/33] Staging: rt2870: add Antenna Diversity support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt2870: add Antenna Diversity support

rt3070:
* remove non-working AntDiversity config parameter
* remove unused bRxAntDiversity field from COMMON_CONFIG

rt2870:
* propagate Antenna Diversity support from rt3070

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/eeprom.c    |   16 ++++------------
 drivers/staging/rt2860/common/mlme.c      |   10 +++++-----
 drivers/staging/rt2860/common/rtmp_init.c |    2 +-
 drivers/staging/rt2860/rt_profile.c       |   17 -----------------
 drivers/staging/rt2860/rtmp.h             |    7 ++-----
 drivers/staging/rt2860/sta/rtmp_data.c    |    9 +++------
 6 files changed, 15 insertions(+), 46 deletions(-)

Index: b/drivers/staging/rt2860/common/eeprom.c
===================================================================
--- a/drivers/staging/rt2860/common/eeprom.c
+++ b/drivers/staging/rt2860/common/eeprom.c
@@ -181,14 +181,11 @@ USHORT RTMP_EEPROM_READ16(
     UINT32		x;
     USHORT		data;
 
-#ifdef RT30xx
+#ifdef RT2870
 	if (pAd->NicConfig2.field.AntDiversity)
     {
     	pAd->EepromAccess = TRUE;
     }
-//2008/09/11:KH add to support efuse<--
-//2008/09/11:KH add to support efuse-->
-{
 #endif
     Offset /= 2;
     // reset bits and set EECS
@@ -214,7 +211,7 @@ USHORT RTMP_EEPROM_READ16(
 
     EEpromCleanup(pAd);
 
-#ifdef RT30xx
+#ifdef RT2870
 	// Antenna and EEPROM access are both using EESK pin,
     // Therefor we should avoid accessing EESK at the same time
     // Then restore antenna after EEPROM access
@@ -223,7 +220,6 @@ USHORT RTMP_EEPROM_READ16(
 	    pAd->EepromAccess = FALSE;
 	    AsicSetRxAnt(pAd, pAd->RxAnt.Pair1PrimaryRxAnt);
     }
-}
 #endif
     return data;
 }	//ReadEEprom
@@ -235,14 +231,11 @@ VOID RTMP_EEPROM_WRITE16(
 {
     UINT32 x;
 
-#ifdef RT30xx
+#ifdef RT2870
 	if (pAd->NicConfig2.field.AntDiversity)
     {
     	pAd->EepromAccess = TRUE;
     }
-	//2008/09/11:KH add to support efuse<--
-//2008/09/11:KH add to support efuse-->
-	{
 #endif
 	Offset /= 2;
 
@@ -278,7 +271,7 @@ VOID RTMP_EEPROM_WRITE16(
 
     EEpromCleanup(pAd);
 
-#ifdef RT30xx
+#ifdef RT2870
 	// Antenna and EEPROM access are both using EESK pin,
     // Therefor we should avoid accessing EESK at the same time
     // Then restore antenna after EEPROM access
@@ -287,7 +280,6 @@ VOID RTMP_EEPROM_WRITE16(
 	    pAd->EepromAccess = FALSE;
 	    AsicSetRxAnt(pAd, pAd->RxAnt.Pair1PrimaryRxAnt);
     }
-}
 #endif
 }
 
Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -8004,7 +8004,7 @@ CHAR RTMPMaxRssi(
 	return larger;
 }
 
-#ifdef RT30xx
+#ifdef RT2870
 // Antenna divesity use GPIO3 and EESK pin for control
 // Antenna and EEPROM access are both using EESK pin,
 // Therefor we should avoid accessing EESK at the same time
@@ -8052,7 +8052,7 @@ VOID AsicSetRxAnt(
 		DBGPRINT_RAW(RT_DEBUG_TRACE, ("AsicSetRxAnt, switch to aux antenna\n"));
 	}
 }
-#endif /* RT30xx */
+#endif
 
 /*
     ========================================================================
@@ -8078,7 +8078,7 @@ VOID AsicEvaluateRxAnt(
 				fRTMP_ADAPTER_NIC_NOT_EXIST |
 				fRTMP_ADAPTER_BSS_SCAN_IN_PROGRESS)
 				|| OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
-#ifdef RT30xx
+#ifdef RT2870
 				|| (pAd->EepromAccess)
 #endif
 				)
@@ -8182,9 +8182,9 @@ VOID AsicRxAntEvalTimeout(
 							fRTMP_ADAPTER_RADIO_OFF			|
 							fRTMP_ADAPTER_NIC_NOT_EXIST)
 							|| OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
-#ifdef RT30xx
+#ifdef RT2870
 							|| (pAd->EepromAccess)
-#endif // RT30xx //
+#endif
 							)
 		return;
 
Index: b/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -3415,7 +3415,7 @@ VOID	UserCfgInit(
 		}
 	}
 
-#ifdef RT30xx
+#ifdef RT2870
 	pAd->EepromAccess = FALSE;
 #endif
 	pAd->Antenna.word = 0;
Index: b/drivers/staging/rt2860/rt_profile.c
===================================================================
--- a/drivers/staging/rt2860/rt_profile.c
+++ b/drivers/staging/rt2860/rt_profile.c
@@ -1429,23 +1429,6 @@ NDIS_STATUS	RTMPReadParametersHook(
 								DBGPRINT(RT_DEBUG_TRACE, ("TGnWifiTest=%d\n", pAd->StaCfg.bTGnWifiTest));
 						}
 					}
-
-#ifdef RT30xx
-						{
-							if(RTMPGetKeyParameter("AntDiversity", tmpbuf, 10, buffer))
-							{
-								for (i = 0, macptr = rstrtok(tmpbuf,";"); macptr; macptr = rstrtok(NULL,";"), i++)
-								{
-									if(simple_strtol(macptr, 0, 10) != 0)  //Enable
-										pAd->CommonCfg.bRxAntDiversity = TRUE;
-									else //Disable
-										pAd->CommonCfg.bRxAntDiversity = FALSE;
-
-									DBGPRINT(RT_DEBUG_ERROR, ("AntDiversity=%d\n", pAd->CommonCfg.bRxAntDiversity));
-								}
-							}
-						}
-#endif // RT30xx //
 				}
 			}
 			else
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -1295,7 +1295,7 @@ typedef struct _BBP_TUNING_STRUCT {
 
 typedef struct _SOFT_RX_ANT_DIVERSITY_STRUCT {
 	UCHAR     EvaluatePeriod;		 // 0:not evalute status, 1: evaluate status, 2: switching status
-#ifdef RT30xx
+#ifdef RT2870
 	UCHAR     EvaluateStableCnt;
 #endif
 	UCHAR     Pair1PrimaryRxAnt;     // 0:Ant-E1, 1:Ant-E2
@@ -1899,9 +1899,6 @@ typedef struct _COMMON_CONFIG {
 
 	BOOLEAN				NdisRadioStateOff; //For HCT 12.0, set this flag to TRUE instead of called MlmeRadioOff.
 	ABGBAND_STATE		BandState;		// For setting BBP used on B/G or A mode.
-#ifdef RT30xx
-	BOOLEAN				bRxAntDiversity; // 0:disable, 1:enable Software Rx Antenna Diversity.
-#endif
 
 	// IEEE802.11H--DFS.
 	RADAR_DETECT_STRUCT	RadarDetect;
@@ -2667,7 +2664,7 @@ typedef struct _RTMP_ADAPTER
 	ULONG                   EepromVersion;          // byte 0: version, byte 1: revision, byte 2~3: unused
 	UCHAR                   EEPROMAddressNum;       // 93c46=6  93c66=8
 	USHORT                  EEPROMDefaultValue[NUM_EEPROM_BBP_PARMS];
-#ifdef RT30xx
+#ifdef RT2870
 	BOOLEAN                 EepromAccess;
 #endif
 	ULONG                   FirmwareVersion;        // byte 0: Minor version, byte 1: Major version, otherwise unused.
Index: b/drivers/staging/rt2860/sta/rtmp_data.c
===================================================================
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -575,10 +575,7 @@ VOID STAHandleRxMgmtFrame(
 	{
 
 		// We should collect RSSI not only U2M data but also my beacon
-		if (
-#ifdef RT30xx
-		    pAd->RxAnt.EvaluatePeriod == 0 &&
-#endif
+		if (pAd->RxAnt.EvaluatePeriod == 0 &&
 		    pHeader->FC.SubType == SUBTYPE_BEACON &&
 		    MAC_ADDR_EQUAL(&pAd->CommonCfg.Bssid, &pHeader->Addr2)) {
 			Update_Rssi_Sample(pAd, &pAd->StaCfg.RssiSample, pRxWI);
@@ -587,7 +584,7 @@ VOID STAHandleRxMgmtFrame(
 			pAd->StaCfg.LastSNR1 = (UCHAR)(pRxWI->SNR1);
 		}
 
-#ifdef RT30xx
+#ifdef RT2870
 		// collect rssi information for antenna diversity
 		if (pAd->NicConfig2.field.AntDiversity)
 		{
@@ -597,7 +594,7 @@ VOID STAHandleRxMgmtFrame(
 					pAd->StaCfg.NumOfAvgRssiSample ++;
 			}
 		}
-#endif // RT30xx //
+#endif
 
 		// First check the size, it MUST not exceed the mlme queue size
 		if (pRxWI->MPDUtotalByteCount > MGMT_DMA_BUFFER_SIZE)
