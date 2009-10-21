Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbZJUUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbZJUUox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZJUUow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:44:52 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZJUUom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NSnrSk9Eu+ptOQdcEu6MSJhtxC3kK3zE15ZJzxoBN3JWaXT+SmQ6QE65SBuMijQHbf
         azSdk/TYXcosUkGFigArsS3kL51xcf0fDdkYluDY1dosDktZh1SixKkk8fwXOaV+9bwy
         7eUWkaiFSvLpXTJc9ebK+OaxSl89VMAf8pfw0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:44:27 +0200
Message-Id: <20091021204427.4593.14756.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/12] Staging: rt28x0: remove support for private driver parameters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove support for private driver parameters

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/Makefile           |    1 
 drivers/staging/rt2860/common/cmm_info.c  |    2 
 drivers/staging/rt2860/common/rtmp_init.c |    9 --
 drivers/staging/rt2860/rt_profile.c       |   95 ------------------------------
 drivers/staging/rt2860/rtmp.h             |    3 
 drivers/staging/rt2870/Makefile           |    1 
 6 files changed, 1 insertion(+), 110 deletions(-)

Index: b/drivers/staging/rt2860/Makefile
===================================================================
--- a/drivers/staging/rt2860/Makefile
+++ b/drivers/staging/rt2860/Makefile
@@ -38,7 +38,6 @@ rt2860sta-objs :=	\
 	sta/connect.o		\
 	sta/wpa.o		\
 	rt_linux.o		\
-	rt_profile.o		\
 	rt_main_dev.o		\
 	sta_ioctl.o		\
 	common/ba_action.o	\
Index: b/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -3439,16 +3439,7 @@ int rt28xx_init(
 		goto err3;
 	}
 
-	// Read parameters from Config File
-	Status = RTMPReadParametersHook(pAd);
-
 	DBGPRINT(RT_DEBUG_OFF, ("1. Phy Mode = %d\n", pAd->CommonCfg.PhyMode));
-	if (Status != NDIS_STATUS_SUCCESS)
-	{
-		DBGPRINT_ERR(("NICReadRegParameters failed, Status[=0x%08x]\n",Status));
-//		goto err4;
-		Status = 0;
-	}
 
 #ifdef RTMP_MAC_USB
 	pAd->CommonCfg.bMultipleIRP = FALSE;
Index: b/drivers/staging/rt2860/rt_profile.c
===================================================================
--- a/drivers/staging/rt2860/rt_profile.c
+++ /dev/null
@@ -1,95 +0,0 @@
-/*
- *************************************************************************
- * Ralink Tech Inc.
- * 5F., No.36, Taiyuan St., Jhubei City,
- * Hsinchu County 302,
- * Taiwan, R.O.C.
- *
- * (c) Copyright 2002-2007, Ralink Technology, Inc.
- *
- * This program is free software; you can redistribute it and/or modify  *
- * it under the terms of the GNU General Public License as published by  *
- * the Free Software Foundation; either version 2 of the License, or     *
- * (at your option) any later version.                                   *
- *                                                                       *
- * This program is distributed in the hope that it will be useful,       *
- * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
- * GNU General Public License for more details.                          *
- *                                                                       *
- * You should have received a copy of the GNU General Public License     *
- * along with this program; if not, write to the                         *
- * Free Software Foundation, Inc.,                                       *
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
- *                                                                       *
- *************************************************************************
-
-    Module Name:
-	rt_profile.c
-
-    Abstract:
-
-    Revision History:
-    Who          When          What
-    ---------    ----------    ----------------------------------------------
-      */
-
-#include "rt_config.h"
-
-
-NDIS_STATUS	RTMPReadParametersHook(
-	IN	PRTMP_ADAPTER pAd)
-{
-	PSTRING					src = NULL;
-	RTMP_OS_FD				srcf;
-	RTMP_OS_FS_INFO			osFSInfo;
-	INT						retval = NDIS_STATUS_FAILURE;
-	PSTRING					buffer;
-
-	buffer = kmalloc(MAX_INI_BUFFER_SIZE, MEM_ALLOC_FLAG);
-	if(buffer == NULL)
-		return NDIS_STATUS_FAILURE;
-	memset(buffer, 0x00, MAX_INI_BUFFER_SIZE);
-
-    {
-    {
-			src = STA_PROFILE_PATH;
-    }
-	}
-
-	if (src && *src)
-    {
-		RtmpOSFSInfoChange(&osFSInfo, TRUE);
-		srcf = RtmpOSFileOpen(src, O_RDONLY, 0);
-		if (IS_FILE_OPEN_ERR(srcf))
-		{
-			DBGPRINT(RT_DEBUG_ERROR, ("Open file \"%s\" failed!\n", src));
-    }
-	else
-    {
-			retval =RtmpOSFileRead(srcf, buffer, MAX_INI_BUFFER_SIZE);
-			if (retval > 0)
-    {
-				RTMPSetProfileParameters(pAd, buffer);
-				retval = NDIS_STATUS_SUCCESS;
-    }
-			else
-				DBGPRINT(RT_DEBUG_ERROR, ("Read file \"%s\" failed(errCode=%d)!\n", src, retval));
-
-			retval = RtmpOSFileClose(srcf);
-			if ( retval != 0)
-		{
-				retval = NDIS_STATUS_FAILURE;
-				DBGPRINT(RT_DEBUG_ERROR, ("Close file \"%s\" failed(errCode=%d)!\n", src, retval));
-		}
-	}
-
-		RtmpOSFSInfoChange(&osFSInfo, FALSE);
-	}
-
-	kfree(buffer);
-
-	return (retval);
-
-}
-
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2453,9 +2453,6 @@ NDIS_STATUS RTMPAllocAdapterBlock(
 NDIS_STATUS RTMPAllocTxRxRingMemory(
 	IN  PRTMP_ADAPTER   pAd);
 
-NDIS_STATUS	RTMPReadParametersHook(
-	IN	PRTMP_ADAPTER pAd);
-
 NDIS_STATUS	RTMPSetProfileParameters(
 	IN RTMP_ADAPTER *pAd,
 	IN PSTRING		pBuffer);
Index: b/drivers/staging/rt2870/Makefile
===================================================================
--- a/drivers/staging/rt2870/Makefile
+++ b/drivers/staging/rt2870/Makefile
@@ -39,7 +39,6 @@ rt2870sta-objs :=		\
 	sta/connect.o		\
 	sta/wpa.o		\
 	rt_linux.o		\
-	rt_profile.o		\
 	rt_main_dev.o		\
 	sta_ioctl.o		\
 	common/ba_action.o	\
