Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYJ3QNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYJ3QNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbYJ3QL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:11:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:7970 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968AbYJ3QLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=WUZeKLh+VDubZ39x2QCvFF6LCGvsuZQzO8AMjzFq9kZdMJtn4xMOekuTGDW9i3TSuN
         6yExW2xL1yYBHql+vjCSf/oXcI919yXzcwk6H6kdFBfSACNsTHAghxYM2Bk9AgMOlmd9
         4Wl4YAx1b1rN722QH9gS50blvFfZ80neQtnLM=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 7/7] w35und: remove ->shutdown from struct wbsoft_priv
Date: Thu, 30 Oct 2008 18:12:07 +0200
Message-Id: <1225383127-16406-7-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1225383127-16406-6-git-send-email-penberg@cs.helsinki.fi>
References: <>
 <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-5-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-6-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not actually used for anything, so remove it.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/Makefile    |    1 -
 drivers/staging/winbond/core.h      |    1 -
 drivers/staging/winbond/wbhal.c     |    1 -
 drivers/staging/winbond/wblinux.c   |   31 -------------------------------
 drivers/staging/winbond/wblinux_f.h |    2 --
 drivers/staging/winbond/wbusb.c     |    6 +-----
 6 files changed, 1 insertions(+), 41 deletions(-)
 delete mode 100644 drivers/staging/winbond/wblinux.c
 delete mode 100644 drivers/staging/winbond/wblinux_s.h

diff --git a/drivers/staging/winbond/Makefile b/drivers/staging/winbond/Makefile
index a93732e..d337571 100644
--- a/drivers/staging/winbond/Makefile
+++ b/drivers/staging/winbond/Makefile
@@ -9,7 +9,6 @@ w35und-objs :=			\
 	wb35rx.o		\
 	wb35tx.o		\
 	wbhal.o			\
-	wblinux.o		\
 	wbusb.o			\
 
 
diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 9c9d5d2..fe142a1 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -24,7 +24,6 @@ struct wbsoft_priv {
 	MDS Mds;
 
 	spinlock_t SpinLock;
-	u32 shutdown;
 
 	atomic_t ThreadCount;
 
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index d2be5fb..7ab5300 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -850,7 +850,6 @@ void hal_surprise_remove(struct wbsoft_priv *adapter)
 		#ifdef _PE_STATE_DUMP_
 		WBDEBUG(("Calling hal_surprise_remove\n"));
 		#endif
-		WBLINUX_stop( adapter );
 	}
 }
 
diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
deleted file mode 100644
index 0461516..0000000
--- a/drivers/staging/winbond/wblinux.c
+++ /dev/null
@@ -1,31 +0,0 @@
-//============================================================================
-//  Copyright (c) 1996-2005 Winbond Electronic Corporation
-//
-//  Module Name:
-//    wblinux.c
-//
-//  Abstract:
-//    Linux releated routines
-//
-//============================================================================
-#include <linux/netdevice.h>
-
-#include "mds_f.h"
-#include "mto_f.h"
-#include "sysdef.h"
-#include "wbhal_f.h"
-#include "wblinux_f.h"
-
-void
-WBLINUX_stop(  struct wbsoft_priv * adapter )
-{
-	if (atomic_inc_return(&adapter->ThreadCount) == 1) {
-		// Shutdown module immediately
-		adapter->shutdown = 1;
-#ifdef _PE_STATE_DUMP_
-		WBDEBUG(( "[w35und] SKB_RELEASE OK\n" ));
-#endif
-	}
-
-	atomic_dec(&adapter->ThreadCount);
-}
diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
index f531a01..868e877 100644
--- a/drivers/staging/winbond/wblinux_f.h
+++ b/drivers/staging/winbond/wblinux_f.h
@@ -10,9 +10,7 @@
 // wblinux_f.h
 //
 int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev );
-void WBLINUX_stop(  struct wbsoft_priv *adapter );
 void wb35_set_multicast( struct net_device *netdev );
 struct net_device_stats * wb35_netdev_stats( struct net_device *netdev );
-void WBLINUX_stop(  struct wbsoft_priv *adapter );
 
 #endif
diff --git a/drivers/staging/winbond/wblinux_s.h b/drivers/staging/winbond/wblinux_s.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index b981662..cb4dee5 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -302,8 +302,7 @@ error:
 	case 4:
 	case 3: Mds_Destroy( priv );
 	case 2:
-	case 1: WBLINUX_stop(priv);
-		hal_halt( pHwData, NULL );
+	case 1: hal_halt( pHwData, NULL );
 	case 0: break;
 	}
 
@@ -402,9 +401,6 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 #endif
 	msleep(100);// Waiting Irp completed
 
-	// Destroy the NDIS module
-	WBLINUX_stop(adapter);
-
 	// Halt the HAL
 	hal_halt(&adapter->sHwData, NULL);
 }
-- 
1.5.3.7

