Return-Path: <linux-kernel-owner+w=401wt.eu-S1763140AbZDHIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763140AbZDHIwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761615AbZDHIvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:51:37 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:60976 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762499AbZDHIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:51:27 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4/4] w35und: merge rest of wbhal.c to phy_calibration.c
Date: Wed,  8 Apr 2009 11:51:22 +0300
Message-Id: <1239180682-22860-4-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239180682-22860-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239180682-22860-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The remaining functions are local to phy_calibration.c so move them
there and remove wbhal.c.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/Makefile          |    1 -
 drivers/staging/winbond/phy_calibration.c |   19 +++++++++++++++++++
 drivers/staging/winbond/wbhal.c           |   20 --------------------
 drivers/staging/winbond/wbhal_f.h         |    4 ----
 4 files changed, 19 insertions(+), 25 deletions(-)
 delete mode 100644 drivers/staging/winbond/wbhal.c

diff --git a/drivers/staging/winbond/Makefile b/drivers/staging/winbond/Makefile
index b49c973..fb2b7d4 100644
--- a/drivers/staging/winbond/Makefile
+++ b/drivers/staging/winbond/Makefile
@@ -7,7 +7,6 @@ w35und-objs :=			\
 	wb35reg.o		\
 	wb35rx.o		\
 	wb35tx.o		\
-	wbhal.o			\
 	wbusb.o			\
 
 
diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index af8c01e..8c56962 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -340,6 +340,25 @@ void _sin_cos(s32 angle, s32 *sin, s32 *cos)
     }
 }
 
+static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 * pValue)
+{
+	if (number < 0x1000)
+		number += 0x1000;
+	return Wb35Reg_ReadSync(pHwData, number, pValue);
+}
+#define hw_get_dxx_reg( _A, _B, _C ) hal_get_dxx_reg( _A, _B, (u32 *)_C )
+
+static unsigned char hal_set_dxx_reg(struct hw_data *pHwData, u16 number, u32 value)
+{
+	unsigned char ret;
+
+	if (number < 0x1000)
+		number += 0x1000;
+	ret = Wb35Reg_WriteSync(pHwData, number, value);
+	return ret;
+}
+#define hw_set_dxx_reg( _A, _B, _C ) hal_set_dxx_reg( _A, _B, (u32)_C )
+
 
 void _reset_rx_cal(struct hw_data *phw_data)
 {
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
deleted file mode 100644
index b9a6e38..0000000
--- a/drivers/staging/winbond/wbhal.c
+++ /dev/null
@@ -1,20 +0,0 @@
-#include "sysdef.h"
-#include "wbhal_f.h"
-#include "wblinux_f.h"
-
-unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 * pValue)
-{
-	if (number < 0x1000)
-		number += 0x1000;
-	return Wb35Reg_ReadSync(pHwData, number, pValue);
-}
-
-unsigned char hal_set_dxx_reg(struct hw_data *pHwData, u16 number, u32 value)
-{
-	unsigned char ret;
-
-	if (number < 0x1000)
-		number += 0x1000;
-	ret = Wb35Reg_WriteSync(pHwData, number, value);
-	return ret;
-}
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
index fd1d3c2..bfdf05d 100644
--- a/drivers/staging/winbond/wbhal_f.h
+++ b/drivers/staging/winbond/wbhal_f.h
@@ -52,8 +52,6 @@ u32 hal_get_bss_pk_cnt(  struct hw_data * pHwData );
 
 #define PHY_DEBUG( msg, args... )
 
-unsigned char hal_get_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 * pValue );
-unsigned char hal_set_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 value );
 #define hal_get_time_count( _P )	(_P->time_count/10)	// return 100ms count
 #define hal_detect_error( _P )		(_P->WbUsb.DetectCount)
 
@@ -68,7 +66,5 @@ unsigned char hal_set_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 valu
 #define hal_join_request_stop(_A)
 #define hw_get_cxx_reg( _A, _B, _C )
 #define hw_set_cxx_reg( _A, _B, _C )
-#define hw_get_dxx_reg( _A, _B, _C )	hal_get_dxx_reg( _A, _B, (u32 *)_C )
-#define hw_set_dxx_reg( _A, _B, _C )	hal_set_dxx_reg( _A, _B, (u32)_C )
 
 
-- 
1.5.6.3

