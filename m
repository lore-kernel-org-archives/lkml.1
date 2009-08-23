Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbZHWNcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbZHWNcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934066AbZHWNcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:32:50 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001AbZHWNbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=icCWUy5T5R4h+pvS3vv+lfWqGhcYQcgVg3i76/da1OdHGyZj55U05W6xaqNqCprc2Y
         2O4uRFX7On52CWbtdWFwgS7mTR8rIz4BwN0sTLixFrFUgHiYCDdxhrvoCJSh7LYbeNBm
         BtQngb5KXuxQCZbz7t2aLfnzj+wZj6T41Z++Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:41 +0200
Message-Id: <20090823133141.17784.97782.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 27/33] Staging: rt2870: remove SHOW_ADHOC_ENTRY_INFO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt2870: remove SHOW_ADHOC_ENTRY_INFO support

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/sta_ioctl.c |   61 -------------------------------------
 1 file changed, 61 deletions(-)

Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -87,10 +87,6 @@ struct iw_priv_args privtab[] = {
 	  0, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_MASK, "radio_on" },
 	{ SHOW_CFG_VALUE,
 	  IW_PRIV_TYPE_CHAR | 1024, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_MASK, "show" },
-#if !defined(RT2860) && !defined(RT30xx)
-	{ SHOW_ADHOC_ENTRY_INFO,
-	  0, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_MASK, "adhocEntry" },
-#endif
 /* --- sub-ioctls relations --- */
 
 { RTPRIV_IOCTL_STATISTICS,
@@ -176,12 +172,6 @@ INT Set_ShortRetryLimit_Proc(
 	IN	PRTMP_ADAPTER	pAdapter,
 	IN	PUCHAR			arg);
 
-#if !defined(RT2860) && !defined(RT30xx)
-INT	Show_Adhoc_MacTable_Proc(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	PCHAR			extra);
-#endif
-
 static struct {
 	CHAR *name;
 	INT (*set_proc)(PRTMP_ADAPTER pAdapter, PUCHAR arg);
@@ -1854,12 +1844,6 @@ rt_private_show(struct net_device *dev, 
 					wrq->length = strlen(extra) + 1; // 1: size of '\0'
 			}
 			break;
-#if !defined(RT2860) && !defined(RT30xx)
-		case SHOW_ADHOC_ENTRY_INFO:
-			Show_Adhoc_MacTable_Proc(pAd, extra);
-			wrq->length = strlen(extra) + 1; // 1: size of '\0'
-			break;
-#endif
         default:
             DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n", __func__, subcmd));
             break;
@@ -3820,48 +3804,3 @@ INT Set_ShortRetryLimit_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("IF Set_ShortRetryLimit_Proc::(tx_rty_cfg=0x%x)\n", tx_rty_cfg.word));
 	return TRUE;
 }
-
-#if !defined(RT2860) && !defined(RT30xx)
-INT	Show_Adhoc_MacTable_Proc(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	PCHAR			extra)
-{
-	INT i;
-
-	sprintf(extra, "\n");
-
-	sprintf(extra + strlen(extra), "HT Operating Mode : %d\n", pAd->CommonCfg.AddHTInfo.AddHtInfo2.OperaionMode);
-
-	sprintf(extra + strlen(extra), "\n%-19s%-4s%-4s%-7s%-7s%-7s%-10s%-6s%-6s%-6s%-6s\n",
-			"MAC", "AID", "BSS", "RSSI0", "RSSI1", "RSSI2", "PhMd", "BW", "MCS", "SGI", "STBC");
-
-	for (i=1; i<MAX_LEN_OF_MAC_TABLE; i++)
-	{
-		PMAC_TABLE_ENTRY pEntry = &pAd->MacTab.Content[i];
-
-		if (strlen(extra) > (IW_PRIV_SIZE_MASK - 30))
-		    break;
-		if ((pEntry->ValidAsCLI || pEntry->ValidAsApCli) && (pEntry->Sst == SST_ASSOC))
-		{
-			sprintf(extra + strlen(extra), "%02X:%02X:%02X:%02X:%02X:%02X  ",
-				pEntry->Addr[0], pEntry->Addr[1], pEntry->Addr[2],
-				pEntry->Addr[3], pEntry->Addr[4], pEntry->Addr[5]);
-			sprintf(extra + strlen(extra), "%-4d", (int)pEntry->Aid);
-			sprintf(extra + strlen(extra), "%-4d", (int)pEntry->apidx);
-			sprintf(extra + strlen(extra), "%-7d", pEntry->RssiSample.AvgRssi0);
-			sprintf(extra + strlen(extra), "%-7d", pEntry->RssiSample.AvgRssi1);
-			sprintf(extra + strlen(extra), "%-7d", pEntry->RssiSample.AvgRssi2);
-			sprintf(extra + strlen(extra), "%-10s", GetPhyMode(pEntry->HTPhyMode.field.MODE));
-			sprintf(extra + strlen(extra), "%-6s", GetBW(pEntry->HTPhyMode.field.BW));
-			sprintf(extra + strlen(extra), "%-6d", pEntry->HTPhyMode.field.MCS);
-			sprintf(extra + strlen(extra), "%-6d", pEntry->HTPhyMode.field.ShortGI);
-			sprintf(extra + strlen(extra), "%-6d", pEntry->HTPhyMode.field.STBC);
-			sprintf(extra + strlen(extra), "%-10d, %d, %d%%\n", pEntry->DebugFIFOCount, pEntry->DebugTxCount,
-						(pEntry->DebugTxCount) ? ((pEntry->DebugTxCount-pEntry->DebugFIFOCount)*100/pEntry->DebugTxCount) : 0);
-			sprintf(extra, "%s\n", extra);
-		}
-	}
-
-	return TRUE;
-}
-#endif /* RT2870 */
