Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYJ3RGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYJ3RGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbYJ3REt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:04:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:27579 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbYJ3REr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=D5gqMCmsgb8tsXBU34q1llwMBi21ag9U9FeFcdeTkbPrL+FksFfcYev56sfm1LuKrl
         dn1zaWwee8iEjlTEO2CLkQH2uGdp17/kEj/TEsXC4VNeG7Ofosme8z9khAmzt+9krnVg
         NxtMe9aol57haAiEdGj0v5zTJA1JvkY8oq5FA=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 7/7] w35und: remove rxisr.c as dead code
Date: Thu, 30 Oct 2008 19:04:56 +0200
Message-Id: <1225386296-19632-7-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1225386296-19632-6-git-send-email-penberg@cs.helsinki.fi>
References: <>
 <1225386296-19632-1-git-send-email-penberg@cs.helsinki.fi>
 <1225386296-19632-2-git-send-email-penberg@cs.helsinki.fi>
 <1225386296-19632-3-git-send-email-penberg@cs.helsinki.fi>
 <1225386296-19632-4-git-send-email-penberg@cs.helsinki.fi>
 <1225386296-19632-5-git-send-email-penberg@cs.helsinki.fi>
 <1225386296-19632-6-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vRxTimerStart() function is never called nor does the timer do anything
useful so remove the code.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/Makefile |    1 -
 drivers/staging/winbond/mds.c    |    3 ---
 drivers/staging/winbond/mds_f.h  |    5 -----
 drivers/staging/winbond/mds_s.h  |    2 --
 drivers/staging/winbond/rxisr.c  |   28 ----------------------------
 drivers/staging/winbond/sysdef.h |    3 ---
 6 files changed, 0 insertions(+), 42 deletions(-)
 delete mode 100644 drivers/staging/winbond/rxisr.c

diff --git a/drivers/staging/winbond/Makefile b/drivers/staging/winbond/Makefile
index d337571..b49c973 100644
--- a/drivers/staging/winbond/Makefile
+++ b/drivers/staging/winbond/Makefile
@@ -4,7 +4,6 @@ w35und-objs :=			\
 	mto.o			\
 	phy_calibration.o	\
 	reg.o			\
-	rxisr.o			\
 	wb35reg.o		\
 	wb35rx.o		\
 	wb35tx.o		\
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 0dd1eec..8b638d7 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -16,15 +16,12 @@ Mds_initial(struct wbsoft_priv * adapter)
 	pMds->TxRTSThreshold = DEFAULT_RTSThreshold;
 	pMds->TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
 
-	vRxTimerInit(adapter);//for WPA countermeasure
-
 	return hal_get_tx_buffer( &adapter->sHwData, &pMds->pTxBuffer );
 }
 
 void
 Mds_Destroy(struct wbsoft_priv * adapter)
 {
-	vRxTimerStop(adapter);
 }
 
 static void Mds_DurationSet(struct wbsoft_priv *adapter,  PDESCRIPTOR pDes,  u8 *buffer)
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index 8109eba..ee0f120 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -11,11 +11,6 @@ void Mds_SendComplete(  struct wbsoft_priv *adapter,  PT02_DESCRIPTOR pT02 );
 void Mds_MpduProcess(  struct wbsoft_priv *adapter,  PDESCRIPTOR pRxDes );
 extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
-
-void vRxTimerInit(struct wbsoft_priv *adapter);
-void vRxTimerStart(struct wbsoft_priv *adapter, int timeout_value);
-void vRxTimerStop(struct wbsoft_priv *adapter);
-
 // For Asynchronous indicating. The routine collocates with USB.
 void Mds_MsduProcess(  struct wbsoft_priv *adapter,  PRXLAYER1 pRxLayer1,  u8 SlotIndex);
 
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index 29f1568..ebf61e3 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -142,8 +142,6 @@ typedef struct _MDS
 	u8		boCounterMeasureBlock;
 	u8		reserved_4[2];
 
-	struct timer_list timer;
-
 	u32	TxTsc; // 20060214
 	u32	TxTsc_2; // 20060214
 
diff --git a/drivers/staging/winbond/rxisr.c b/drivers/staging/winbond/rxisr.c
deleted file mode 100644
index f4619d9..0000000
--- a/drivers/staging/winbond/rxisr.c
+++ /dev/null
@@ -1,28 +0,0 @@
-#include "sysdef.h"
-#include "core.h"
-
-static void RxTimerHandler(unsigned long data)
-{
-	WARN_ON(1);
-}
-
-void vRxTimerInit(struct wbsoft_priv *adapter)
-{
-	init_timer(&adapter->Mds.timer);
-	adapter->Mds.timer.function = RxTimerHandler;
-	adapter->Mds.timer.data = (unsigned long) adapter;
-}
-
-void vRxTimerStart(struct wbsoft_priv *adapter, int timeout_value)
-{
-	if (timeout_value < MIN_TIMEOUT_VAL)
-		timeout_value = MIN_TIMEOUT_VAL;
-
-	adapter->Mds.timer.expires = jiffies + msecs_to_jiffies(timeout_value);
-	add_timer(&adapter->Mds.timer);
-}
-
-void vRxTimerStop(struct wbsoft_priv *adapter)
-{
-	del_timer_sync(&adapter->Mds.timer);
-}
diff --git a/drivers/staging/winbond/sysdef.h b/drivers/staging/winbond/sysdef.h
index 60e4c04..251b9c5 100644
--- a/drivers/staging/winbond/sysdef.h
+++ b/drivers/staging/winbond/sysdef.h
@@ -37,7 +37,4 @@
 #define _PE_USB_INI_DUMP_
 #endif
 
-// Kernel Timer resolution, NDIS is 10ms, 10000us
-#define MIN_TIMEOUT_VAL	(10) //ms
-
 #endif
-- 
1.5.3.7

