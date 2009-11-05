Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZKEGkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZKEGkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZKEGkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:40:39 -0500
Received: from sedf.de ([212.83.34.151]:37878 "EHLO sedf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZKEGkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:40:31 -0500
Date: Thu, 5 Nov 2009 07:06:54 +0100
From: Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 1/3] staging: rt2860: remove reading a file from /etc
Message-ID: <20091105060654.GA8664@sedf.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Dalfu=C3=9F <sd@sedf.de>
Subject: [Patch 1/3] staging: rt2860: remove reading a file from /etc

This patch is based on 2.6.32-rc6

This patch removes the whole ugly reading-from-/etc stuff.
No lines are added or modified, but a lot of lines (for loading and
parsing the file from /etc) are removed. Nearly all removed lines had
been in rt_profile.c, rest is header and the call of
RTMPReadParametersHook() in rt_main_dev.c.

Signed-off-by: Sebastian Dalfu=C3=9F <sd@sedf.de>
---
diff -ru a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_li=
nux.h
--- a/drivers/staging/rt2860/rt_linux.h	2009-11-03 20:37:49.000000000 +0100
+++ b/drivers/staging/rt2860/rt_linux.h	2009-11-04 23:49:52.382174611 +0100
@@ -89,18 +89,12 @@
 /* order of "if defined()" is important, because for 3070 driver
    both RT2870 and RT3070 are defined */
 #if defined(RT2860)
- #define STA_PROFILE_PATH			"/etc/Wireless/RT2860STA/RT2860STA.dat"
- #define STA_RTMP_FIRMWARE_FILE_NAME "/etc/Wireless/RT2860STA/RT2860STA.bi=
n"
  #define STA_NIC_DEVICE_NAME			"RT2860STA"
  #define STA_DRIVER_VERSION			"1.8.1.1"
 #elif defined(RT3070)
- #define STA_PROFILE_PATH			"/etc/Wireless/RT3070STA/RT3070STA.dat"
- #define STA_RT2870_IMAGE_FILE_NAME  "/etc/Wireless/RT3070STA/rt2870.bin"
  #define STA_NIC_DEVICE_NAME			"RT3070STA"
  #define STA_DRIVER_VERSION			"2.0.1.0"
 #elif defined(RT2870)
- #define STA_PROFILE_PATH			"/etc/Wireless/RT2870STA/RT2870STA.dat"
- #define STA_RT2870_IMAGE_FILE_NAME  "/etc/Wireless/RT2870STA/rt2870.bin"
  #define STA_NIC_DEVICE_NAME			"RT2870STA"
  #define STA_DRIVER_VERSION			"1.4.0.0"
 #endif
diff -ru a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt=
_main_dev.c
--- a/drivers/staging/rt2860/rt_main_dev.c	2009-11-03 20:37:49.000000000 +0=
100
+++ b/drivers/staging/rt2860/rt_main_dev.c	2009-11-04 23:46:51.542194598 +0=
100
@@ -454,15 +454,7 @@
 		goto err3;
 	}
=20
-	// Read parameters from Config File
-	Status =3D RTMPReadParametersHook(pAd);
-
 	printk("1. Phy Mode =3D %d\n", pAd->CommonCfg.PhyMode);
-	if (Status !=3D NDIS_STATUS_SUCCESS)
-	{
-		DBGPRINT_ERR(("NICReadRegParameters failed, Status[=3D0x%08x]\n",Status)=
);
-		goto err4;
-	}
=20
 #ifdef RT2870
 	pAd->CommonCfg.bMultipleIRP =3D FALSE;
diff -ru a/drivers/staging/rt2860/rt_profile.c b/drivers/staging/rt2860/rt_=
profile.c
--- a/drivers/staging/rt2860/rt_profile.c	2009-11-03 20:37:49.000000000 +01=
00
+++ b/drivers/staging/rt2860/rt_profile.c	2009-11-04 23:46:17.173042588 +01=
00
@@ -27,11 +27,6 @@
=20
 #include "rt_config.h"
=20
-static void HTParametersHook(
-	IN	PRTMP_ADAPTER pAd,
-	IN	CHAR		  *pValueStr,
-	IN	CHAR		  *pInput);
-
 #define ETH_MAC_ADDR_STR_LEN 17  // in format of xx:xx:xx:xx:xx:xx
=20
 // We assume the s1 is a sting, s2 is a memory space with 6 bytes. and con=
tent of s1 will be changed.
@@ -686,1177 +681,3 @@
     os_free_mem(NULL, temp_buf2);
     return TRUE;
 }
-
-
-static int rtmp_parse_key_buffer_from_file(IN  PRTMP_ADAPTER pAd,IN  char =
*buffer,IN  ULONG KeyType,IN  INT BSSIdx,IN  INT KeyIdx)
-{
-	PUCHAR		keybuff;
-	INT			i =3D BSSIdx, idx =3D KeyIdx;
-	ULONG		KeyLen;
-	UCHAR		CipherAlg =3D CIPHER_WEP64;
-
-	keybuff =3D buffer;
-	KeyLen =3D strlen(keybuff);
-
-	if (KeyType =3D=3D 1)
-	{//Ascii
-		if( (KeyLen =3D=3D 5) || (KeyLen =3D=3D 13))
-		{
-			pAd->SharedKey[i][idx].KeyLen =3D KeyLen;
-			NdisMoveMemory(pAd->SharedKey[i][idx].Key, keybuff, KeyLen);
-			if (KeyLen =3D=3D 5)
-				CipherAlg =3D CIPHER_WEP64;
-			else
-				CipherAlg =3D CIPHER_WEP128;
-			pAd->SharedKey[i][idx].CipherAlg =3D CipherAlg;
-
-			DBGPRINT(RT_DEBUG_TRACE, ("I/F(wlan%d) Key%dStr=3D%s and type=3D%s\n", =
i, idx+1, keybuff, (KeyType =3D=3D 0) ? "Hex":"Ascii"));
-			return 1;
-		}
-		else
-		{//Invalid key length
-			DBGPRINT(RT_DEBUG_ERROR, ("Key%dStr is Invalid key length! KeyLen =3D %=
ld!\n", idx+1, KeyLen));
-			return 0;
-		}
-	}
-	else
-	{//Hex type
-		if( (KeyLen =3D=3D 10) || (KeyLen =3D=3D 26))
-		{
-			pAd->SharedKey[i][idx].KeyLen =3D KeyLen / 2;
-			AtoH(keybuff, pAd->SharedKey[i][idx].Key, KeyLen / 2);
-			if (KeyLen =3D=3D 10)
-				CipherAlg =3D CIPHER_WEP64;
-			else
-				CipherAlg =3D CIPHER_WEP128;
-			pAd->SharedKey[i][idx].CipherAlg =3D CipherAlg;
-
-			DBGPRINT(RT_DEBUG_TRACE, ("I/F(wlan%d) Key%dStr=3D%s and type=3D%s\n", =
i, idx+1, keybuff, (KeyType =3D=3D 0) ? "Hex":"Ascii"));
-			return 1;
-		}
-		else
-		{//Invalid key length
-			DBGPRINT(RT_DEBUG_ERROR, ("I/F(wlan%d) Key%dStr is Invalid key length! =
KeyLen =3D %ld!\n", i, idx+1, KeyLen));
-			return 0;
-		}
-	}
-}
-static void rtmp_read_key_parms_from_file(IN  PRTMP_ADAPTER pAd, char *tmp=
buf, char *buffer)
-{
-	char		tok_str[16];
-	PUCHAR		macptr;
-	INT			i =3D 0, idx;
-	ULONG		KeyType[MAX_MBSSID_NUM];
-	ULONG		KeyIdx;
-
-	NdisZeroMemory(KeyType, MAX_MBSSID_NUM);
-
-	//DefaultKeyID
-	if(RTMPGetKeyParameter("DefaultKeyID", tmpbuf, 25, buffer))
-	{
-		{
-			KeyIdx =3D simple_strtol(tmpbuf, 0, 10);
-			if((KeyIdx >=3D 1 ) && (KeyIdx <=3D 4))
-				pAd->StaCfg.DefaultKeyId =3D (UCHAR) (KeyIdx - 1);
-			else
-				pAd->StaCfg.DefaultKeyId =3D 0;
-
-			DBGPRINT(RT_DEBUG_TRACE, ("DefaultKeyID(0~3)=3D%d\n", pAd->StaCfg.Defau=
ltKeyId));
-		}
-	}
-
-
-	for (idx =3D 0; idx < 4; idx++)
-	{
-		sprintf(tok_str, "Key%dType", idx + 1);
-		//Key1Type
-		if (RTMPGetKeyParameter(tok_str, tmpbuf, 128, buffer))
-		{
-		    for (i =3D 0, macptr =3D rstrtok(tmpbuf,";"); macptr; macptr =3D rst=
rtok(NULL,";"), i++)
-		    {
-			    KeyType[i] =3D simple_strtol(macptr, 0, 10);
-		    }
-
-			{
-				sprintf(tok_str, "Key%dStr", idx + 1);
-				if (RTMPGetCriticalParameter(tok_str, tmpbuf, 128, buffer))
-				{
-					rtmp_parse_key_buffer_from_file(pAd, tmpbuf, KeyType[BSS0], BSS0, idx=
);
-				}
-			}
-		}
-	}
-}
-
-static void rtmp_read_sta_wmm_parms_from_file(IN  PRTMP_ADAPTER pAd, char =
*tmpbuf, char *buffer)
-{
-	PUCHAR					macptr;
-	INT						i=3D0;
-	BOOLEAN					bWmmEnable =3D FALSE;
-
-	//WmmCapable
-	if(RTMPGetKeyParameter("WmmCapable", tmpbuf, 32, buffer))
-	{
-		if(simple_strtol(tmpbuf, 0, 10) !=3D 0) //Enable
-		{
-			pAd->CommonCfg.bWmmCapable =3D TRUE;
-			bWmmEnable =3D TRUE;
-		}
-		else //Disable
-		{
-			pAd->CommonCfg.bWmmCapable =3D FALSE;
-		}
-
-		DBGPRINT(RT_DEBUG_TRACE, ("WmmCapable=3D%d\n", pAd->CommonCfg.bWmmCapabl=
e));
-	}
-
-	//AckPolicy for AC_BK, AC_BE, AC_VI, AC_VO
-	if(RTMPGetKeyParameter("AckPolicy", tmpbuf, 32, buffer))
-	{
-		for (i =3D 0, macptr =3D rstrtok(tmpbuf,";"); macptr; macptr =3D rstrtok=
(NULL,";"), i++)
-		{
-			pAd->CommonCfg.AckPolicy[i] =3D (UCHAR)simple_strtol(macptr, 0, 10);
-
-			DBGPRINT(RT_DEBUG_TRACE, ("AckPolicy[%d]=3D%d\n", i, pAd->CommonCfg.Ack=
Policy[i]));
-		}
-	}
-
-	if (bWmmEnable)
-	{
-		//APSDCapable
-		if(RTMPGetKeyParameter("APSDCapable", tmpbuf, 10, buffer))
-		{
-			if(simple_strtol(tmpbuf, 0, 10) !=3D 0)  //Enable
-				pAd->CommonCfg.bAPSDCapable =3D TRUE;
-			else
-				pAd->CommonCfg.bAPSDCapable =3D FALSE;
-
-			DBGPRINT(RT_DEBUG_TRACE, ("APSDCapable=3D%d\n", pAd->CommonCfg.bAPSDCap=
able));
-		}
-
-		//APSDAC for AC_BE, AC_BK, AC_VI, AC_VO
-		if(RTMPGetKeyParameter("APSDAC", tmpbuf, 32, buffer))
-		{
-			BOOLEAN apsd_ac[4];
-
-			for (i =3D 0, macptr =3D rstrtok(tmpbuf,";"); macptr; macptr =3D rstrto=
k(NULL,";"), i++)
-			{
-				apsd_ac[i] =3D (BOOLEAN)simple_strtol(macptr, 0, 10);
-
-				DBGPRINT(RT_DEBUG_TRACE, ("APSDAC%d  %d\n", i,  apsd_ac[i]));
-			}
-
-			pAd->CommonCfg.bAPSDAC_BE =3D apsd_ac[0];
-			pAd->CommonCfg.bAPSDAC_BK =3D apsd_ac[1];
-			pAd->CommonCfg.bAPSDAC_VI =3D apsd_ac[2];
-			pAd->CommonCfg.bAPSDAC_VO =3D apsd_ac[3];
-		}
-	}
-
-}
-
-NDIS_STATUS	RTMPReadParametersHook(
-	IN	PRTMP_ADAPTER pAd)
-{
-	PUCHAR					src =3D NULL;
-	struct file				*srcf;
-	INT 					retval;
-   	mm_segment_t			orgfs;
-	CHAR					*buffer;
-	CHAR					*tmpbuf;
-	ULONG					RtsThresh;
-	ULONG					FragThresh;
-	UCHAR	                keyMaterial[40];
-
-	PUCHAR					macptr;
-	INT						i =3D 0;
-
-	buffer =3D kmalloc(MAX_INI_BUFFER_SIZE, MEM_ALLOC_FLAG);
-	if(buffer =3D=3D NULL)
-        return NDIS_STATUS_FAILURE;
-
-	tmpbuf =3D kmalloc(MAX_PARAM_BUFFER_SIZE, MEM_ALLOC_FLAG);
-	if(tmpbuf =3D=3D NULL)
-	{
-		kfree(buffer);
-        return NDIS_STATUS_FAILURE;
-	}
-
-	src =3D STA_PROFILE_PATH;
-
-    orgfs =3D get_fs();
-    set_fs(KERNEL_DS);
-
-	if (src && *src)
-	{
-		srcf =3D filp_open(src, O_RDONLY, 0);
-		if (IS_ERR(srcf))
-		{
-			DBGPRINT(RT_DEBUG_ERROR, ("--> Error %ld opening %s\n", -PTR_ERR(srcf),=
src));
-		}
-		else
-		{
-			// The object must have a read method
-			if (srcf->f_op && srcf->f_op->read)
-			{
-				memset(buffer, 0x00, MAX_INI_BUFFER_SIZE);
-				retval=3Dsrcf->f_op->read(srcf, buffer, MAX_INI_BUFFER_SIZE, &srcf->f_=
pos);
-				if (retval < 0)
-				{
-					DBGPRINT(RT_DEBUG_TRACE, ("--> Read %s error %d\n", src, -retval));
-				}
-				else
-				{
-					// set file parameter to portcfg
-					//CountryRegion
-					if(RTMPGetKeyParameter("CountryRegion", tmpbuf, 25, buffer))
-					{
-						pAd->CommonCfg.CountryRegion =3D (UCHAR) simple_strtol(tmpbuf, 0, 10=
);
-						DBGPRINT(RT_DEBUG_TRACE, ("CountryRegion=3D%d\n", pAd->CommonCfg.Cou=
ntryRegion));
-					}
-					//CountryRegionABand
-					if(RTMPGetKeyParameter("CountryRegionABand", tmpbuf, 25, buffer))
-					{
-						pAd->CommonCfg.CountryRegionForABand=3D (UCHAR) simple_strtol(tmpbuf=
, 0, 10);
-						DBGPRINT(RT_DEBUG_TRACE, ("CountryRegionABand=3D%d\n", pAd->CommonCf=
g.CountryRegionForABand));
-					}
-					//CountryCode
-					if(RTMPGetKeyParameter("CountryCode", tmpbuf, 25, buffer))
-					{
-						NdisMoveMemory(pAd->CommonCfg.CountryCode, tmpbuf , 2);
-
-						if (strlen(pAd->CommonCfg.CountryCode) !=3D 0)
-						{
-							pAd->CommonCfg.bCountryFlag =3D TRUE;
-						}
-						DBGPRINT(RT_DEBUG_TRACE, ("CountryCode=3D%s\n", pAd->CommonCfg.Count=
ryCode));
-					}
-					//ChannelGeography
-					if(RTMPGetKeyParameter("ChannelGeography", tmpbuf, 25, buffer))
-					{
-						UCHAR Geography =3D (UCHAR) simple_strtol(tmpbuf, 0, 10);
-						if (Geography <=3D BOTH)
-						{
-							pAd->CommonCfg.Geography =3D Geography;
-							pAd->CommonCfg.CountryCode[2] =3D
-								(pAd->CommonCfg.Geography =3D=3D BOTH) ? ' ' : ((pAd->CommonCfg.Ge=
ography =3D=3D IDOR) ? 'I' : 'O');
-							DBGPRINT(RT_DEBUG_TRACE, ("ChannelGeography=3D%d\n", pAd->CommonCfg=
=2EGeography));
-						}
-					}
-					else
-					{
-						pAd->CommonCfg.Geography =3D BOTH;
-						pAd->CommonCfg.CountryCode[2] =3D ' ';
-					}
-
-					{
-						//SSID
-						if (RTMPGetCriticalParameter("SSID", tmpbuf, 256, buffer))
-						{
-							if (strlen(tmpbuf) <=3D 32)
-							{
-			 					pAd->CommonCfg.SsidLen =3D (UCHAR) strlen(tmpbuf);
-								NdisZeroMemory(pAd->CommonCfg.Ssid, NDIS_802_11_LENGTH_SSID);
-								NdisMoveMemory(pAd->CommonCfg.Ssid, tmpbuf, pAd->CommonCfg.SsidLen=
);
-								pAd->MlmeAux.AutoReconnectSsidLen =3D pAd->CommonCfg.SsidLen;
-								NdisZeroMemory(pAd->MlmeAux.AutoReconnectSsid, NDIS_802_11_LENGTH_=
SSID);
-								NdisMoveMemory(pAd->MlmeAux.AutoReconnectSsid, tmpbuf, pAd->MlmeAu=
x.AutoReconnectSsidLen);
-								pAd->MlmeAux.SsidLen =3D pAd->CommonCfg.SsidLen;
-								NdisZeroMemory(pAd->MlmeAux.Ssid, NDIS_802_11_LENGTH_SSID);
-								NdisMoveMemory(pAd->MlmeAux.Ssid, tmpbuf, pAd->MlmeAux.SsidLen);
-								DBGPRINT(RT_DEBUG_TRACE, ("%s::(SSID=3D%s)\n", __func__, tmpbuf));
-							}
-						}
-					}
-
-					{
-						//NetworkType
-						if (RTMPGetKeyParameter("NetworkType", tmpbuf, 25, buffer))
-						{
-							pAd->bConfigChanged =3D TRUE;
-							if (strcmp(tmpbuf, "Adhoc") =3D=3D 0)
-								pAd->StaCfg.BssType =3D BSS_ADHOC;
-							else //Default Infrastructure mode
-								pAd->StaCfg.BssType =3D BSS_INFRA;
-							// Reset Ralink supplicant to not use, it will be set to start when=
 UI set PMK key
-							pAd->StaCfg.WpaState =3D SS_NOTUSE;
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(NetworkType=3D%d)\n", __func__, pAd=
->StaCfg.BssType));
-						}
-					}
-
-					//Channel
-					if(RTMPGetKeyParameter("Channel", tmpbuf, 10, buffer))
-					{
-						pAd->CommonCfg.Channel =3D (UCHAR) simple_strtol(tmpbuf, 0, 10);
-						DBGPRINT(RT_DEBUG_TRACE, ("Channel=3D%d\n", pAd->CommonCfg.Channel));
-					}
-					//WirelessMode
-					if(RTMPGetKeyParameter("WirelessMode", tmpbuf, 10, buffer))
-					{
-						int value  =3D 0, maxPhyMode =3D PHY_11G;
-
-						maxPhyMode =3D PHY_11N_5G;
-
-						value =3D simple_strtol(tmpbuf, 0, 10);
-
-						if (value <=3D maxPhyMode)
-						{
-							pAd->CommonCfg.PhyMode =3D value;
-						}
-						DBGPRINT(RT_DEBUG_TRACE, ("PhyMode=3D%d\n", pAd->CommonCfg.PhyMode));
-					}
-                    //BasicRate
-					if(RTMPGetKeyParameter("BasicRate", tmpbuf, 10, buffer))
-					{
-						pAd->CommonCfg.BasicRateBitmap =3D (ULONG) simple_strtol(tmpbuf, 0, =
10);
-						DBGPRINT(RT_DEBUG_TRACE, ("BasicRate=3D%ld\n", pAd->CommonCfg.BasicR=
ateBitmap));
-					}
-					//BeaconPeriod
-					if(RTMPGetKeyParameter("BeaconPeriod", tmpbuf, 10, buffer))
-					{
-						pAd->CommonCfg.BeaconPeriod =3D (USHORT) simple_strtol(tmpbuf, 0, 10=
);
-						DBGPRINT(RT_DEBUG_TRACE, ("BeaconPeriod=3D%d\n", pAd->CommonCfg.Beac=
onPeriod));
-					}
-                    //TxPower
-					if(RTMPGetKeyParameter("TxPower", tmpbuf, 10, buffer))
-					{
-						pAd->CommonCfg.TxPowerPercentage =3D (ULONG) simple_strtol(tmpbuf, 0=
, 10);
-
-						pAd->CommonCfg.TxPowerDefault =3D pAd->CommonCfg.TxPowerPercentage;
-
-						DBGPRINT(RT_DEBUG_TRACE, ("TxPower=3D%ld\n", pAd->CommonCfg.TxPowerP=
ercentage));
-					}
-					//BGProtection
-					if(RTMPGetKeyParameter("BGProtection", tmpbuf, 10, buffer))
-					{
-						switch (simple_strtol(tmpbuf, 0, 10))
-						{
-							case 1: //Always On
-								pAd->CommonCfg.UseBGProtection =3D 1;
-								break;
-							case 2: //Always OFF
-								pAd->CommonCfg.UseBGProtection =3D 2;
-								break;
-							case 0: //AUTO
-							default:
-								pAd->CommonCfg.UseBGProtection =3D 0;
-								break;
-						}
-						DBGPRINT(RT_DEBUG_TRACE, ("BGProtection=3D%ld\n", pAd->CommonCfg.Use=
BGProtection));
-					}
-					//OLBCDetection
-					if(RTMPGetKeyParameter("DisableOLBC", tmpbuf, 10, buffer))
-					{
-						switch (simple_strtol(tmpbuf, 0, 10))
-						{
-							case 1: //disable OLBC Detection
-								pAd->CommonCfg.DisableOLBCDetect =3D 1;
-								break;
-							case 0: //enable OLBC Detection
-								pAd->CommonCfg.DisableOLBCDetect =3D 0;
-								break;
-							default:
-								pAd->CommonCfg.DisableOLBCDetect=3D 0;
-								break;
-						}
-						DBGPRINT(RT_DEBUG_TRACE, ("OLBCDetection=3D%ld\n", pAd->CommonCfg.Di=
sableOLBCDetect));
-					}
-					//TxPreamble
-					if(RTMPGetKeyParameter("TxPreamble", tmpbuf, 10, buffer))
-					{
-						switch (simple_strtol(tmpbuf, 0, 10))
-						{
-							case Rt802_11PreambleShort:
-								pAd->CommonCfg.TxPreamble =3D Rt802_11PreambleShort;
-								break;
-							case Rt802_11PreambleLong:
-							default:
-								pAd->CommonCfg.TxPreamble =3D Rt802_11PreambleLong;
-								break;
-						}
-						DBGPRINT(RT_DEBUG_TRACE, ("TxPreamble=3D%ld\n", pAd->CommonCfg.TxPre=
amble));
-					}
-					//RTSThreshold
-					if(RTMPGetKeyParameter("RTSThreshold", tmpbuf, 10, buffer))
-					{
-						RtsThresh =3D simple_strtol(tmpbuf, 0, 10);
-						if( (RtsThresh >=3D 1) && (RtsThresh <=3D MAX_RTS_THRESHOLD) )
-							pAd->CommonCfg.RtsThreshold  =3D (USHORT)RtsThresh;
-						else
-							pAd->CommonCfg.RtsThreshold =3D MAX_RTS_THRESHOLD;
-
-						DBGPRINT(RT_DEBUG_TRACE, ("RTSThreshold=3D%d\n", pAd->CommonCfg.RtsT=
hreshold));
-					}
-					//FragThreshold
-					if(RTMPGetKeyParameter("FragThreshold", tmpbuf, 10, buffer))
-					{
-						FragThresh =3D simple_strtol(tmpbuf, 0, 10);
-						pAd->CommonCfg.bUseZeroToDisableFragment =3D FALSE;
-
-						if (FragThresh > MAX_FRAG_THRESHOLD || FragThresh < MIN_FRAG_THRESHO=
LD)
-						{ //illegal FragThresh so we set it to default
-							pAd->CommonCfg.FragmentThreshold =3D MAX_FRAG_THRESHOLD;
-							pAd->CommonCfg.bUseZeroToDisableFragment =3D TRUE;
-						}
-						else if (FragThresh % 2 =3D=3D 1)
-						{
-							// The length of each fragment shall always be an even number of oc=
tets, except for the last fragment
-							// of an MSDU or MMPDU, which may be either an even or an odd numbe=
r of octets.
-							pAd->CommonCfg.FragmentThreshold =3D (USHORT)(FragThresh - 1);
-						}
-						else
-						{
-							pAd->CommonCfg.FragmentThreshold =3D (USHORT)FragThresh;
-						}
-						//pAd->CommonCfg.AllowFragSize =3D (pAd->CommonCfg.FragmentThreshold=
) - LENGTH_802_11 - LENGTH_CRC;
-						DBGPRINT(RT_DEBUG_TRACE, ("FragThreshold=3D%d\n", pAd->CommonCfg.Fra=
gmentThreshold));
-					}
-					//TxBurst
-					if(RTMPGetKeyParameter("TxBurst", tmpbuf, 10, buffer))
-					{
-						if(simple_strtol(tmpbuf, 0, 10) !=3D 0)  //Enable
-							pAd->CommonCfg.bEnableTxBurst =3D TRUE;
-						else //Disable
-							pAd->CommonCfg.bEnableTxBurst =3D FALSE;
-						DBGPRINT(RT_DEBUG_TRACE, ("TxBurst=3D%d\n", pAd->CommonCfg.bEnableTx=
Burst));
-					}
-
-#ifdef AGGREGATION_SUPPORT
-					//PktAggregate
-					if(RTMPGetKeyParameter("PktAggregate", tmpbuf, 10, buffer))
-					{
-						if(simple_strtol(tmpbuf, 0, 10) !=3D 0)  //Enable
-							pAd->CommonCfg.bAggregationCapable =3D TRUE;
-						else //Disable
-							pAd->CommonCfg.bAggregationCapable =3D FALSE;
-#ifdef PIGGYBACK_SUPPORT
-						pAd->CommonCfg.bPiggyBackCapable =3D pAd->CommonCfg.bAggregationCapa=
ble;
-#endif // PIGGYBACK_SUPPORT //
-						DBGPRINT(RT_DEBUG_TRACE, ("PktAggregate=3D%d\n", pAd->CommonCfg.bAgg=
regationCapable));
-					}
-#else
-					pAd->CommonCfg.bAggregationCapable =3D FALSE;
-					pAd->CommonCfg.bPiggyBackCapable =3D FALSE;
-#endif // AGGREGATION_SUPPORT //
-
-					// WmmCapable
-					rtmp_read_sta_wmm_parms_from_file(pAd, tmpbuf, buffer);
-
-					//ShortSlot
-					if(RTMPGetKeyParameter("ShortSlot", tmpbuf, 10, buffer))
-					{
-						if(simple_strtol(tmpbuf, 0, 10) !=3D 0)  //Enable
-							pAd->CommonCfg.bUseShortSlotTime =3D TRUE;
-						else //Disable
-							pAd->CommonCfg.bUseShortSlotTime =3D FALSE;
-
-						DBGPRINT(RT_DEBUG_TRACE, ("ShortSlot=3D%d\n", pAd->CommonCfg.bUseSho=
rtSlotTime));
-					}
-					//IEEE80211H
-					if(RTMPGetKeyParameter("IEEE80211H", tmpbuf, 10, buffer))
-					{
-					    for (i =3D 0, macptr =3D rstrtok(tmpbuf,";"); macptr; macptr =3D =
rstrtok(NULL,";"), i++)
-					    {
-    						if(simple_strtol(macptr, 0, 10) !=3D 0)  //Enable
-    							pAd->CommonCfg.bIEEE80211H =3D TRUE;
-    						else //Disable
-    							pAd->CommonCfg.bIEEE80211H =3D FALSE;
-
-    						DBGPRINT(RT_DEBUG_TRACE, ("IEEE80211H=3D%d\n", pAd->CommonCfg.bI=
EEE80211H));
-					    }
-					}
-					//CSPeriod
-					if(RTMPGetKeyParameter("CSPeriod", tmpbuf, 10, buffer))
-					{
-					    if(simple_strtol(tmpbuf, 0, 10) !=3D 0)
-							pAd->CommonCfg.RadarDetect.CSPeriod =3D simple_strtol(tmpbuf, 0, 10=
);
-						else
-							pAd->CommonCfg.RadarDetect.CSPeriod =3D 0;
-
-   						DBGPRINT(RT_DEBUG_TRACE, ("CSPeriod=3D%d\n", pAd->CommonCfg.Radar=
Detect.CSPeriod));
-					}
-
-					//RDRegion
-					if(RTMPGetKeyParameter("RDRegion", tmpbuf, 128, buffer))
-					{
-						if ((strncmp(tmpbuf, "JAP_W53", 7) =3D=3D 0) || (strncmp(tmpbuf, "ja=
p_w53", 7) =3D=3D 0))
-						{
-							pAd->CommonCfg.RadarDetect.RDDurRegion =3D JAP_W53;
-							pAd->CommonCfg.RadarDetect.DfsSessionTime =3D 15;
-						}
-						else if ((strncmp(tmpbuf, "JAP_W56", 7) =3D=3D 0) || (strncmp(tmpbuf=
, "jap_w56", 7) =3D=3D 0))
-						{
-							pAd->CommonCfg.RadarDetect.RDDurRegion =3D JAP_W56;
-							pAd->CommonCfg.RadarDetect.DfsSessionTime =3D 13;
-						}
-						else if ((strncmp(tmpbuf, "JAP", 3) =3D=3D 0) || (strncmp(tmpbuf, "j=
ap", 3) =3D=3D 0))
-						{
-							pAd->CommonCfg.RadarDetect.RDDurRegion =3D JAP;
-							pAd->CommonCfg.RadarDetect.DfsSessionTime =3D 5;
-						}
-						else  if ((strncmp(tmpbuf, "FCC", 3) =3D=3D 0) || (strncmp(tmpbuf, "=
fcc", 3) =3D=3D 0))
-						{
-							pAd->CommonCfg.RadarDetect.RDDurRegion =3D FCC;
-							pAd->CommonCfg.RadarDetect.DfsSessionTime =3D 5;
-						}
-						else if ((strncmp(tmpbuf, "CE", 2) =3D=3D 0) || (strncmp(tmpbuf, "ce=
", 2) =3D=3D 0))
-						{
-							pAd->CommonCfg.RadarDetect.RDDurRegion =3D CE;
-							pAd->CommonCfg.RadarDetect.DfsSessionTime =3D 13;
-						}
-						else
-						{
-							pAd->CommonCfg.RadarDetect.RDDurRegion =3D CE;
-							pAd->CommonCfg.RadarDetect.DfsSessionTime =3D 13;
-						}
-
-						DBGPRINT(RT_DEBUG_TRACE, ("RDRegion=3D%d\n", pAd->CommonCfg.RadarDet=
ect.RDDurRegion));
-					}
-					else
-					{
-						pAd->CommonCfg.RadarDetect.RDDurRegion =3D CE;
-						pAd->CommonCfg.RadarDetect.DfsSessionTime =3D 13;
-					}
-
-					//WirelessEvent
-					if(RTMPGetKeyParameter("WirelessEvent", tmpbuf, 10, buffer))
-					{
-					    if(simple_strtol(tmpbuf, 0, 10) !=3D 0)
-							pAd->CommonCfg.bWirelessEvent =3D simple_strtol(tmpbuf, 0, 10);
-						else
-							pAd->CommonCfg.bWirelessEvent =3D 0;	// disable
-   						DBGPRINT(RT_DEBUG_TRACE, ("WirelessEvent=3D%d\n", pAd->CommonCfg.=
bWirelessEvent));
-					}
-					if(RTMPGetKeyParameter("WiFiTest", tmpbuf, 10, buffer))
-					{
-					    if(simple_strtol(tmpbuf, 0, 10) !=3D 0)
-							pAd->CommonCfg.bWiFiTest=3D simple_strtol(tmpbuf, 0, 10);
-						else
-							pAd->CommonCfg.bWiFiTest =3D 0;	// disable
-
-   						DBGPRINT(RT_DEBUG_TRACE, ("WiFiTest=3D%d\n", pAd->CommonCfg.bWiFi=
Test));
-					}
-					//AuthMode
-					if(RTMPGetKeyParameter("AuthMode", tmpbuf, 128, buffer))
-					{
-						{
-							if ((strcmp(tmpbuf, "WEPAUTO") =3D=3D 0) || (strcmp(tmpbuf, "wepaut=
o") =3D=3D 0))
-							    pAd->StaCfg.AuthMode =3D Ndis802_11AuthModeAutoSwitch;
-							else if ((strcmp(tmpbuf, "SHARED") =3D=3D 0) || (strcmp(tmpbuf, "sh=
ared") =3D=3D 0))
-							    pAd->StaCfg.AuthMode =3D Ndis802_11AuthModeShared;
-							else if ((strcmp(tmpbuf, "WPAPSK") =3D=3D 0) || (strcmp(tmpbuf, "wp=
apsk") =3D=3D 0))
-							    pAd->StaCfg.AuthMode =3D Ndis802_11AuthModeWPAPSK;
-							else if ((strcmp(tmpbuf, "WPANONE") =3D=3D 0) || (strcmp(tmpbuf, "w=
panone") =3D=3D 0))
-							    pAd->StaCfg.AuthMode =3D Ndis802_11AuthModeWPANone;
-							else if ((strcmp(tmpbuf, "WPA2PSK") =3D=3D 0) || (strcmp(tmpbuf, "w=
pa2psk") =3D=3D 0))
-							    pAd->StaCfg.AuthMode =3D Ndis802_11AuthModeWPA2PSK;
-							else if ((strcmp(tmpbuf, "WPA") =3D=3D 0) || (strcmp(tmpbuf, "wpa")=
 =3D=3D 0))
-							    pAd->StaCfg.AuthMode =3D Ndis802_11AuthModeWPA;
-							else if ((strcmp(tmpbuf, "WPA2") =3D=3D 0) || (strcmp(tmpbuf, "wpa2=
") =3D=3D 0))
-							    pAd->StaCfg.AuthMode =3D Ndis802_11AuthModeWPA2;
-				                        else
-				                            pAd->StaCfg.AuthMode =3D Ndis802_11AuthMod=
eOpen;
-
-				                        pAd->StaCfg.PortSecured =3D WPA_802_1X_PORT_NO=
T_SECURED;
-
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=3D%d)\n", __func__, pAd-=
>StaCfg.WepStatus));
-						}
-					}
-					//EncrypType
-					if(RTMPGetKeyParameter("EncrypType", tmpbuf, 128, buffer))
-					{
-						{
-							if ((strcmp(tmpbuf, "WEP") =3D=3D 0) || (strcmp(tmpbuf, "wep") =3D=
=3D 0))
-								pAd->StaCfg.WepStatus	=3D Ndis802_11WEPEnabled;
-							else if ((strcmp(tmpbuf, "TKIP") =3D=3D 0) || (strcmp(tmpbuf, "tkip=
") =3D=3D 0))
-								pAd->StaCfg.WepStatus	=3D Ndis802_11Encryption2Enabled;
-							else if ((strcmp(tmpbuf, "AES") =3D=3D 0) || (strcmp(tmpbuf, "aes")=
 =3D=3D 0))
-								pAd->StaCfg.WepStatus	=3D Ndis802_11Encryption3Enabled;
-							else
-								pAd->StaCfg.WepStatus	=3D Ndis802_11WEPDisabled;
-
-							// Update all wepstatus related
-							pAd->StaCfg.PairCipher	=3D pAd->StaCfg.WepStatus;
-							pAd->StaCfg.GroupCipher =3D pAd->StaCfg.WepStatus;
-							pAd->StaCfg.OrigWepStatus 	=3D pAd->StaCfg.WepStatus;
-							pAd->StaCfg.bMixCipher =3D FALSE;
-
-							DBGPRINT(RT_DEBUG_TRACE, ("%s::(EncrypType=3D%d)\n", __func__, pAd-=
>StaCfg.WepStatus));
-						}
-					}
-
-					{
-						if(RTMPGetCriticalParameter("WPAPSK", tmpbuf, 512, buffer))
-						{
-							int     err=3D0;
-
-							tmpbuf[strlen(tmpbuf)] =3D '\0'; // make STA can process .$^& for W=
PAPSK input
-
-							if ((pAd->StaCfg.AuthMode !=3D Ndis802_11AuthModeWPAPSK) &&
-								(pAd->StaCfg.AuthMode !=3D Ndis802_11AuthModeWPA2PSK) &&
-								(pAd->StaCfg.AuthMode !=3D Ndis802_11AuthModeWPANone)
-								)
-							{
-								err =3D 1;
-							}
-							else if ((strlen(tmpbuf) >=3D 8) && (strlen(tmpbuf) < 64))
-							{
-								PasswordHash((char *)tmpbuf, pAd->CommonCfg.Ssid, pAd->CommonCfg.S=
sidLen, keyMaterial);
-								NdisMoveMemory(pAd->StaCfg.PMK, keyMaterial, 32);
-
-							}
-							else if (strlen(tmpbuf) =3D=3D 64)
-							{
-								AtoH(tmpbuf, keyMaterial, 32);
-								NdisMoveMemory(pAd->StaCfg.PMK, keyMaterial, 32);
-							}
-							else
-							{
-								err =3D 1;
-								DBGPRINT(RT_DEBUG_ERROR, ("%s::(WPAPSK key-string required 8 ~ 64 =
characters!)\n", __func__));
-							}
-
-							if (err =3D=3D 0)
-	                        			{
-	                        				if ((pAd->StaCfg.AuthMode =3D=3D Ndis802_11Au=
thModeWPAPSK) ||
-									(pAd->StaCfg.AuthMode =3D=3D Ndis802_11AuthModeWPA2PSK))
-								{
-									// Start STA supplicant state machine
-									pAd->StaCfg.WpaState =3D SS_START;
-								}
-								else if (pAd->StaCfg.AuthMode =3D=3D Ndis802_11AuthModeWPANone)
-								{
-									pAd->StaCfg.WpaState =3D SS_NOTUSE;
-								}
-
-								DBGPRINT(RT_DEBUG_TRACE, ("%s::(WPAPSK=3D%s)\n", __func__, tmpbuf)=
);
-							}
-						}
-					}
-
-					//DefaultKeyID, KeyType, KeyStr
-					rtmp_read_key_parms_from_file(pAd, tmpbuf, buffer);
-
-					HTParametersHook(pAd, tmpbuf, buffer);
-
-					{
-						//PSMode
-#ifdef RT2860
-						if (RTMPGetKeyParameter("PSMode", tmpbuf, 32, buffer))
-#endif
-#ifdef RT2870
-						if (RTMPGetKeyParameter("PSMode", tmpbuf, 10, buffer))
-#endif
-						{
-							if (pAd->StaCfg.BssType =3D=3D BSS_INFRA)
-							{
-								if ((strcmp(tmpbuf, "MAX_PSP") =3D=3D 0) || (strcmp(tmpbuf, "max_p=
sp") =3D=3D 0))
-								{
-									// do NOT turn on PSM bit here, wait until MlmeCheckForPsmChange()
-									// to exclude certain situations.
-									//	   MlmeSetPsm(pAd, PWR_SAVE);
-									OPSTATUS_SET_FLAG(pAd, fOP_STATUS_RECEIVE_DTIM);
-									if (pAd->StaCfg.bWindowsACCAMEnable =3D=3D FALSE)
-										pAd->StaCfg.WindowsPowerMode =3D Ndis802_11PowerModeMAX_PSP;
-									pAd->StaCfg.WindowsBatteryPowerMode =3D Ndis802_11PowerModeMAX_PS=
P;
-									pAd->StaCfg.DefaultListenCount =3D 5;
-								}
-								else if ((strcmp(tmpbuf, "Fast_PSP") =3D=3D 0) || (strcmp(tmpbuf, =
"fast_psp") =3D=3D 0)
-									|| (strcmp(tmpbuf, "FAST_PSP") =3D=3D 0))
-								{
-									// do NOT turn on PSM bit here, wait until MlmeCheckForPsmChange()
-									// to exclude certain situations.
-									//	   MlmeSetPsmBit(pAd, PWR_SAVE);
-									OPSTATUS_SET_FLAG(pAd, fOP_STATUS_RECEIVE_DTIM);
-									if (pAd->StaCfg.bWindowsACCAMEnable =3D=3D FALSE)
-										pAd->StaCfg.WindowsPowerMode =3D Ndis802_11PowerModeFast_PSP;
-									pAd->StaCfg.WindowsBatteryPowerMode =3D Ndis802_11PowerModeFast_P=
SP;
-									pAd->StaCfg.DefaultListenCount =3D 3;
-								}
-								else if ((strcmp(tmpbuf, "Legacy_PSP") =3D=3D 0) || (strcmp(tmpbuf=
, "legacy_psp") =3D=3D 0)
-									|| (strcmp(tmpbuf, "LEGACY_PSP") =3D=3D 0))
-								{
-									// do NOT turn on PSM bit here, wait until MlmeCheckForPsmChange()
-									// to exclude certain situations.
-									//	   MlmeSetPsmBit(pAd, PWR_SAVE);
-									OPSTATUS_SET_FLAG(pAd, fOP_STATUS_RECEIVE_DTIM);
-									if (pAd->StaCfg.bWindowsACCAMEnable =3D=3D FALSE)
-										pAd->StaCfg.WindowsPowerMode =3D Ndis802_11PowerModeLegacy_PSP;
-									pAd->StaCfg.WindowsBatteryPowerMode =3D Ndis802_11PowerModeLegacy=
_PSP;
-									pAd->StaCfg.DefaultListenCount =3D 3;
-								}
-								else
-								{ //Default Ndis802_11PowerModeCAM
-									// clear PSM bit immediately
-									MlmeSetPsmBit(pAd, PWR_ACTIVE);
-									OPSTATUS_SET_FLAG(pAd, fOP_STATUS_RECEIVE_DTIM);
-									if (pAd->StaCfg.bWindowsACCAMEnable =3D=3D FALSE)
-										pAd->StaCfg.WindowsPowerMode =3D Ndis802_11PowerModeCAM;
-									pAd->StaCfg.WindowsBatteryPowerMode =3D Ndis802_11PowerModeCAM;
-								}
-								DBGPRINT(RT_DEBUG_TRACE, ("PSMode=3D%ld\n", pAd->StaCfg.WindowsPow=
erMode));
-							}
-						}
-						// FastRoaming
-						if (RTMPGetKeyParameter("FastRoaming", tmpbuf, 32, buffer))
-						{
-							if (simple_strtol(tmpbuf, 0, 10) =3D=3D 0)
-								pAd->StaCfg.bFastRoaming =3D FALSE;
-							else
-								pAd->StaCfg.bFastRoaming =3D TRUE;
-
-							DBGPRINT(RT_DEBUG_TRACE, ("FastRoaming=3D%d\n", pAd->StaCfg.bFastRo=
aming));
-						}
-						// RoamThreshold
-						if (RTMPGetKeyParameter("RoamThreshold", tmpbuf, 32, buffer))
-						{
-							long lInfo =3D simple_strtol(tmpbuf, 0, 10);
-
-							if (lInfo > 90 || lInfo < 60)
-								pAd->StaCfg.dBmToRoam =3D -70;
-							else
-								pAd->StaCfg.dBmToRoam =3D (CHAR)(-1)*lInfo;
-
-							DBGPRINT(RT_DEBUG_TRACE, ("RoamThreshold=3D%d  dBm\n", pAd->StaCfg.=
dBmToRoam));
-						}
-
-						if(RTMPGetKeyParameter("TGnWifiTest", tmpbuf, 10, buffer))
-						{
-							if(simple_strtol(tmpbuf, 0, 10) =3D=3D 0)
-								pAd->StaCfg.bTGnWifiTest =3D FALSE;
-							else
-								pAd->StaCfg.bTGnWifiTest =3D TRUE;
-								DBGPRINT(RT_DEBUG_TRACE, ("TGnWifiTest=3D%d\n", pAd->StaCfg.bTGnWi=
fiTest));
-						}
-					}
-				}
-			}
-			else
-			{
-				DBGPRINT(RT_DEBUG_TRACE, ("--> %s does not have a write method\n", src=
));
-			}
-
-			retval=3Dfilp_close(srcf,NULL);
-
-			if (retval)
-			{
-				DBGPRINT(RT_DEBUG_TRACE, ("--> Error %d closing %s\n", -retval, src));
-			}
-		}
-	}
-
-	set_fs(orgfs);
-
-	kfree(buffer);
-	kfree(tmpbuf);
-
-	return (NDIS_STATUS_SUCCESS);
-}
-
-static void	HTParametersHook(
-	IN	PRTMP_ADAPTER pAd,
-	IN	CHAR		  *pValueStr,
-	IN	CHAR		  *pInput)
-{
-
-	INT Value;
-
-    if (RTMPGetKeyParameter("HT_PROTECT", pValueStr, 25, pInput))
-    {
-        Value =3D simple_strtol(pValueStr, 0, 10);
-        if (Value =3D=3D 0)
-        {
-            pAd->CommonCfg.bHTProtect =3D FALSE;
-        }
-        else
-        {
-            pAd->CommonCfg.bHTProtect =3D TRUE;
-        }
-        DBGPRINT(RT_DEBUG_TRACE, ("HT: Protection  =3D %s\n", (Value=3D=3D=
0) ? "Disable" : "Enable"));
-    }
-
-    if (RTMPGetKeyParameter("HT_MIMOPSEnable", pValueStr, 25, pInput))
-    {
-        Value =3D simple_strtol(pValueStr, 0, 10);
-        if (Value =3D=3D 0)
-        {
-            pAd->CommonCfg.bMIMOPSEnable =3D FALSE;
-        }
-        else
-        {
-            pAd->CommonCfg.bMIMOPSEnable =3D TRUE;
-        }
-        DBGPRINT(RT_DEBUG_TRACE, ("HT: MIMOPSEnable  =3D %s\n", (Value=3D=
=3D0) ? "Disable" : "Enable"));
-    }
-
-
-    if (RTMPGetKeyParameter("HT_MIMOPSMode", pValueStr, 25, pInput))
-    {
-        Value =3D simple_strtol(pValueStr, 0, 10);
-        if (Value > MMPS_ENABLE)
-        {
-			pAd->CommonCfg.BACapability.field.MMPSmode =3D MMPS_ENABLE;
-        }
-        else
-        {
-            //TODO: add mimo power saving mechanism
-            pAd->CommonCfg.BACapability.field.MMPSmode =3D MMPS_ENABLE;
-			//pAd->CommonCfg.BACapability.field.MMPSmode =3D Value;
-        }
-        DBGPRINT(RT_DEBUG_TRACE, ("HT: MIMOPS Mode  =3D %d\n", Value));
-    }
-
-    if (RTMPGetKeyParameter("HT_BADecline", pValueStr, 25, pInput))
-    {
-        Value =3D simple_strtol(pValueStr, 0, 10);
-        if (Value =3D=3D 0)
-        {
-            pAd->CommonCfg.bBADecline =3D FALSE;
-        }
-        else
-        {
-            pAd->CommonCfg.bBADecline =3D TRUE;
-        }
-        DBGPRINT(RT_DEBUG_TRACE, ("HT: BA Decline  =3D %s\n", (Value=3D=3D=
0) ? "Disable" : "Enable"));
-    }
-
-
-    if (RTMPGetKeyParameter("HT_DisableReordering", pValueStr, 25, pInput))
-    {
-        Value =3D simple_strtol(pValueStr, 0, 10);
-        if (Value =3D=3D 0)
-        {
-            pAd->CommonCfg.bDisableReordering =3D FALSE;
-        }
-        else
-        {
-            pAd->CommonCfg.bDisableReordering =3D TRUE;
-        }
-        DBGPRINT(RT_DEBUG_TRACE, ("HT: DisableReordering  =3D %s\n", (Valu=
e=3D=3D0) ? "Disable" : "Enable"));
-    }
-
-    if (RTMPGetKeyParameter("HT_AutoBA", pValueStr, 25, pInput))
-    {
-        Value =3D simple_strtol(pValueStr, 0, 10);
-        if (Value =3D=3D 0)
-        {
-            pAd->CommonCfg.BACapability.field.AutoBA =3D FALSE;
-	    pAd->CommonCfg.BACapability.field.Policy =3D BA_NOTUSE;
-        }
-        else
-        {
-            pAd->CommonCfg.BACapability.field.AutoBA =3D TRUE;
-	    pAd->CommonCfg.BACapability.field.Policy =3D IMMED_BA;
-        }
-        pAd->CommonCfg.REGBACapability.field.AutoBA =3D pAd->CommonCfg.BAC=
apability.field.AutoBA;
-	pAd->CommonCfg.REGBACapability.field.Policy =3D pAd->CommonCfg.BACapabili=
ty.field.Policy;
-        DBGPRINT(RT_DEBUG_TRACE, ("HT: Auto BA  =3D %s\n", (Value=3D=3D0) =
? "Disable" : "Enable"));
-    }
-
-	// Tx_+HTC frame
-    if (RTMPGetKeyParameter("HT_HTC", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-		if (Value =3D=3D 0)
-		{
-			pAd->HTCEnable =3D FALSE;
-		}
-		else
-		{
-            		pAd->HTCEnable =3D TRUE;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Tx +HTC frame =3D %s\n", (Value=3D=3D0) ?=
 "Disable" : "Enable"));
-	}
-
-	// Enable HT Link Adaptation Control
-	if (RTMPGetKeyParameter("HT_LinkAdapt", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-		if (Value =3D=3D 0)
-		{
-			pAd->bLinkAdapt =3D FALSE;
-		}
-		else
-		{
-			pAd->HTCEnable =3D TRUE;
-			pAd->bLinkAdapt =3D TRUE;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Link Adaptation Control =3D %s\n", (Value=
=3D=3D0) ? "Disable" : "Enable(+HTC)"));
-	}
-
-	// Reverse Direction Mechanism
-    if (RTMPGetKeyParameter("HT_RDG", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-		if (Value =3D=3D 0)
-		{
-			pAd->CommonCfg.bRdg =3D FALSE;
-		}
-		else
-		{
-			pAd->HTCEnable =3D TRUE;
-            pAd->CommonCfg.bRdg =3D TRUE;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: RDG =3D %s\n", (Value=3D=3D0) ? "Disable"=
 : "Enable(+HTC)"));
-	}
-
-
-
-
-	// Tx A-MSUD ?
-    if (RTMPGetKeyParameter("HT_AMSDU", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-		if (Value =3D=3D 0)
-		{
-			pAd->CommonCfg.BACapability.field.AmsduEnable =3D FALSE;
-		}
-		else
-		{
-            pAd->CommonCfg.BACapability.field.AmsduEnable =3D TRUE;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Tx A-MSDU =3D %s\n", (Value=3D=3D0) ? "Di=
sable" : "Enable"));
-	}
-
-	// MPDU Density
-    if (RTMPGetKeyParameter("HT_MpduDensity", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-		if (Value <=3D7 && Value >=3D 0)
-		{
-			pAd->CommonCfg.BACapability.field.MpduDensity =3D Value;
-			DBGPRINT(RT_DEBUG_TRACE, ("HT: MPDU Density =3D %d\n", Value));
-		}
-		else
-		{
-			pAd->CommonCfg.BACapability.field.MpduDensity =3D 4;
-			DBGPRINT(RT_DEBUG_TRACE, ("HT: MPDU Density =3D %d (Default)\n", 4));
-		}
-	}
-
-	// Max Rx BA Window Size
-    if (RTMPGetKeyParameter("HT_BAWinSize", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-
-		if (Value >=3D1 && Value <=3D 64)
-		{
-			pAd->CommonCfg.REGBACapability.field.RxBAWinLimit =3D Value;
-			pAd->CommonCfg.BACapability.field.RxBAWinLimit =3D Value;
-			DBGPRINT(RT_DEBUG_TRACE, ("HT: BA Windw Size =3D %d\n", Value));
-		}
-		else
-		{
-            pAd->CommonCfg.REGBACapability.field.RxBAWinLimit =3D 64;
-			pAd->CommonCfg.BACapability.field.RxBAWinLimit =3D 64;
-			DBGPRINT(RT_DEBUG_TRACE, ("HT: BA Windw Size =3D 64 (Defualt)\n"));
-		}
-
-	}
-
-	// Guard Interval
-	if (RTMPGetKeyParameter("HT_GI", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-
-		if (Value =3D=3D GI_400)
-		{
-			pAd->CommonCfg.RegTransmitSetting.field.ShortGI =3D GI_400;
-		}
-		else
-		{
-			pAd->CommonCfg.RegTransmitSetting.field.ShortGI =3D GI_800;
-		}
-
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Guard Interval =3D %s\n", (Value=3D=3DGI_=
400) ? "400" : "800" ));
-	}
-
-	// HT Operation Mode : Mixed Mode , Green Field
-	if (RTMPGetKeyParameter("HT_OpMode", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-
-		if (Value =3D=3D HTMODE_GF)
-		{
-
-			pAd->CommonCfg.RegTransmitSetting.field.HTMODE  =3D HTMODE_GF;
-		}
-		else
-		{
-			pAd->CommonCfg.RegTransmitSetting.field.HTMODE  =3D HTMODE_MM;
-		}
-
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Operate Mode =3D %s\n", (Value=3D=3DHTMOD=
E_GF) ? "Green Field" : "Mixed Mode" ));
-	}
-
-	// Fixed Tx mode : CCK, OFDM
-	if (RTMPGetKeyParameter("FixedTxMode", pValueStr, 25, pInput))
-	{
-		UCHAR	fix_tx_mode;
-
-		{
-			fix_tx_mode =3D FIXED_TXMODE_HT;
-
-			if (strcmp(pValueStr, "OFDM") =3D=3D 0 || strcmp(pValueStr, "ofdm") =3D=
=3D 0)
-			{
-				fix_tx_mode =3D FIXED_TXMODE_OFDM;
-			}
-			else if (strcmp(pValueStr, "CCK") =3D=3D 0 || strcmp(pValueStr, "cck") =
=3D=3D 0)
-			{
-		        fix_tx_mode =3D FIXED_TXMODE_CCK;
-			}
-			else if (strcmp(pValueStr, "HT") =3D=3D 0 || strcmp(pValueStr, "ht") =
=3D=3D 0)
-			{
-		        fix_tx_mode =3D FIXED_TXMODE_HT;
-		}
-		else
-		{
-				Value =3D simple_strtol(pValueStr, 0, 10);
-				// 1 : CCK
-				// 2 : OFDM
-				// otherwise : HT
-				if (Value =3D=3D FIXED_TXMODE_CCK || Value =3D=3D FIXED_TXMODE_OFDM)
-					fix_tx_mode =3D Value;
-				else
-					fix_tx_mode =3D FIXED_TXMODE_HT;
-		}
-
-			pAd->StaCfg.DesiredTransmitSetting.field.FixedTxMode =3D fix_tx_mode;
-			DBGPRINT(RT_DEBUG_TRACE, ("Fixed Tx Mode =3D %d\n", fix_tx_mode));
-
-		}
-	}
-
-
-	// Channel Width
-	if (RTMPGetKeyParameter("HT_BW", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-
-		if (Value =3D=3D BW_40)
-		{
-			pAd->CommonCfg.RegTransmitSetting.field.BW  =3D BW_40;
-		}
-		else
-		{
-            pAd->CommonCfg.RegTransmitSetting.field.BW  =3D BW_20;
-		}
-
-#ifdef MCAST_RATE_SPECIFIC
-		pAd->CommonCfg.MCastPhyMode.field.BW =3D pAd->CommonCfg.RegTransmitSetti=
ng.field.BW;
-#endif // MCAST_RATE_SPECIFIC //
-
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Channel Width =3D %s\n", (Value=3D=3DBW_4=
0) ? "40 MHz" : "20 MHz" ));
-	}
-
-	if (RTMPGetKeyParameter("HT_EXTCHA", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-
-		if (Value =3D=3D 0)
-		{
-
-			pAd->CommonCfg.RegTransmitSetting.field.EXTCHA  =3D EXTCHA_BELOW;
-		}
-		else
-		{
-            pAd->CommonCfg.RegTransmitSetting.field.EXTCHA =3D EXTCHA_ABOV=
E;
-		}
-
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Ext Channel =3D %s\n", (Value=3D=3D0) ? "=
BELOW" : "ABOVE" ));
-	}
-
-	// MSC
-	if (RTMPGetKeyParameter("HT_MCS", pValueStr, 50, pInput))
-	{
-		{
-			Value =3D simple_strtol(pValueStr, 0, 10);
-
-			if ((Value >=3D 0 && Value <=3D 23) || (Value =3D=3D 32)) // 3*3
-		{
-				pAd->StaCfg.DesiredTransmitSetting.field.MCS  =3D Value;
-				pAd->StaCfg.bAutoTxRateSwitch =3D FALSE;
-				DBGPRINT(RT_DEBUG_TRACE, ("HT: MCS =3D %d\n", pAd->StaCfg.DesiredTrans=
mitSetting.field.MCS));
-		}
-		else
-		{
-				pAd->StaCfg.DesiredTransmitSetting.field.MCS  =3D MCS_AUTO;
-				pAd->StaCfg.bAutoTxRateSwitch =3D TRUE;
-				DBGPRINT(RT_DEBUG_TRACE, ("HT: MCS =3D AUTO\n"));
-		}
-	}
-	}
-
-	// STBC
-    if (RTMPGetKeyParameter("HT_STBC", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-		if (Value =3D=3D STBC_USE)
-		{
-			pAd->CommonCfg.RegTransmitSetting.field.STBC =3D STBC_USE;
-		}
-		else
-		{
-			pAd->CommonCfg.RegTransmitSetting.field.STBC =3D STBC_NONE;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: STBC =3D %d\n", pAd->CommonCfg.RegTransmi=
tSetting.field.STBC));
-	}
-
-	// 40_Mhz_Intolerant
-	if (RTMPGetKeyParameter("HT_40MHZ_INTOLERANT", pValueStr, 25, pInput))
-	{
-		Value =3D simple_strtol(pValueStr, 0, 10);
-		if (Value =3D=3D 0)
-		{
-			pAd->CommonCfg.bForty_Mhz_Intolerant =3D FALSE;
-		}
-		else
-		{
-			pAd->CommonCfg.bForty_Mhz_Intolerant =3D TRUE;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: 40MHZ INTOLERANT =3D %d\n", pAd->CommonCf=
g.bForty_Mhz_Intolerant));
-	}
-	//HT_TxStream
-	if(RTMPGetKeyParameter("HT_TxStream", pValueStr, 10, pInput))
-	{
-		switch (simple_strtol(pValueStr, 0, 10))
-		{
-			case 1:
-				pAd->CommonCfg.TxStream =3D 1;
-				break;
-			case 2:
-				pAd->CommonCfg.TxStream =3D 2;
-				break;
-			case 3: // 3*3
-			default:
-				pAd->CommonCfg.TxStream =3D 3;
-
-				if (pAd->MACVersion < RALINK_2883_VERSION)
-					pAd->CommonCfg.TxStream =3D 2; // only 2 tx streams for RT2860 series
-				break;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Tx Stream =3D %d\n", pAd->CommonCfg.TxStr=
eam));
-	}
-	//HT_RxStream
-	if(RTMPGetKeyParameter("HT_RxStream", pValueStr, 10, pInput))
-	{
-		switch (simple_strtol(pValueStr, 0, 10))
-		{
-			case 1:
-				pAd->CommonCfg.RxStream =3D 1;
-				break;
-			case 2:
-				pAd->CommonCfg.RxStream =3D 2;
-				break;
-			case 3:
-			default:
-				pAd->CommonCfg.RxStream =3D 3;
-
-				if (pAd->MACVersion < RALINK_2883_VERSION)
-					pAd->CommonCfg.RxStream =3D 2; // only 2 rx streams for RT2860 series
-				break;
-		}
-		DBGPRINT(RT_DEBUG_TRACE, ("HT: Rx Stream =3D %d\n", pAd->CommonCfg.RxStr=
eam));
-	}
-
-}
diff -ru a/drivers/staging/rt2860/TODO b/drivers/staging/rt2860/TODO
--- a/drivers/staging/rt2860/TODO	2009-11-03 20:37:49.000000000 +0100
+++ b/drivers/staging/rt2860/TODO	2009-11-04 23:45:12.258866979 +0100
@@ -9,7 +9,6 @@
 	- checkpatch.pl clean
 	- sparse clean
 	- port to in-kernel 80211 stack and common rt2x00 infrastructure
-	- remove reading from /etc/ config files
 	- review by the wireless developer community
=20
 Please send any patches or complaints about this driver to Greg

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrya34ACgkQQfdJUNXnsjrXtACeLh7dlJ6hUuxqDdvfNqUSQxLB
igkAoKuAcH77PoK9T17NFDhjyJlleuZZ
=8VfT
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
