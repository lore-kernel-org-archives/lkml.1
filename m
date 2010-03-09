Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0CIVPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:15:33 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55334 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0CIVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:15:27 -0500
Date: Tue, 9 Mar 2010 22:15:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] drivers/staging: drop redundant memset
Message-ID: <Pine.LNX.4.64.1003092214590.4974@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The region set by the call to memset is immediately overwritten by the
subsequent call to memcpy.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3,e4;
@@

- memset(e1,e2,e3);
  memcpy(e1,e4,e3);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/rt2860/sta/assoc.c        |    1 -
 drivers/staging/rt2860/sta_ioctl.c        |    1 -
 drivers/staging/rtl8192su/r819xU_cmdpkt.c |    1 -
 drivers/staging/rtl8192u/r819xU_cmdpkt.c  |    1 -
 drivers/staging/vt6655/iwctl.c            |    2 --
 drivers/staging/vt6656/iwctl.c            |    2 --
 6 files changed, 8 deletions(-)

diff -u -p a/drivers/staging/rt2860/sta/assoc.c b/drivers/staging/rt2860/sta/assoc.c
--- a/drivers/staging/rt2860/sta/assoc.c
+++ b/drivers/staging/rt2860/sta/assoc.c
@@ -1596,7 +1596,6 @@ BOOLEAN StaAddMacTableEntry(struct rt_rt
 		union iwreq_data wrqu;
 		wext_notify_event_assoc(pAd);
 
-		memset(wrqu.ap_addr.sa_data, 0, MAC_ADDR_LEN);
 		memcpy(wrqu.ap_addr.sa_data, pAd->MlmeAux.Bssid, MAC_ADDR_LEN);
 		wireless_send_event(pAd->net_dev, SIOCGIWAP, &wrqu, NULL);
 
diff -u -p a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -608,7 +608,6 @@ int rt_ioctl_siwap(struct net_device *de
 	/* Prevent to connect AP again in STAMlmePeriodicExec */
 	pAdapter->MlmeAux.AutoReconnectSsidLen = 32;
 
-	memset(Bssid, 0, MAC_ADDR_LEN);
 	memcpy(Bssid, ap_addr->sa_data, MAC_ADDR_LEN);
 	MlmeEnqueue(pAdapter,
 		    MLME_CNTL_STATE_MACHINE,
diff -u -p a/drivers/staging/rtl8192su/r819xU_cmdpkt.c b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
--- a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
@@ -63,7 +63,6 @@ SendTxCommandPacket(
 	tcb_desc->bLastIniPkt = 0;
 	skb_reserve(skb, USB_HWDESC_HEADER_LEN);
 	ptr_buf = skb_put(skb, DataLen);
-	memset(ptr_buf,0,DataLen);
 	memcpy(ptr_buf,pData,DataLen);
 	tcb_desc->txbuf_size= (u16)DataLen;
 
diff -u -p a/drivers/staging/rtl8192u/r819xU_cmdpkt.c b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
@@ -63,7 +63,6 @@ SendTxCommandPacket(
 	tcb_desc->bLastIniPkt = 0;
 	skb_reserve(skb, USB_HWDESC_HEADER_LEN);
 	ptr_buf = skb_put(skb, DataLen);
-	memset(ptr_buf,0,DataLen);
 	memcpy(ptr_buf,pData,DataLen);
 	tcb_desc->txbuf_size= (u16)DataLen;
 
diff -u -p a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -699,7 +699,6 @@ if (pMgmt->eScanState ==  WMAC_IS_SCANNI
 	if (wrq->sa_family != ARPHRD_ETHER)
 		rc = -EINVAL;
 	else {
-		memset(pMgmt->abyDesireBSSID, 0xFF, 6);
 		memcpy(pMgmt->abyDesireBSSID, wrq->sa_data, 6);
 		                //2008-0409-05, <Add> by Einsn Liu
 		if((pDevice->bLinkPass == TRUE) &&
@@ -889,7 +888,6 @@ if (pMgmt->eScanState ==  WMAC_IS_SCANNI
            BYTE                   abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	  UINT            ii , uSameBssidNum=0;
 
-	  memset(abyTmpDesireSSID,0,sizeof(abyTmpDesireSSID));
 	  memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
             pCurr = BSSpSearchBSSList(pDevice,
                                       NULL,
diff -u -p a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -758,7 +758,6 @@ int iwctl_siwap(struct net_device *dev,
 	if (wrq->sa_family != ARPHRD_ETHER)
 		rc = -EINVAL;
 	else {
-		memset(pMgmt->abyDesireBSSID, 0xFF, 6);
 		memcpy(pMgmt->abyDesireBSSID, wrq->sa_data, 6);
 
 	//mike :add
@@ -936,7 +935,6 @@ int iwctl_siwessid(struct net_device *de
            BYTE                   abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	  UINT            ii , uSameBssidNum=0;
 
-	  memset(abyTmpDesireSSID,0,sizeof(abyTmpDesireSSID));
 	  memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
             pCurr = BSSpSearchBSSList(pDevice,
                                       NULL,
