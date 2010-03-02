Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab0CBX7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:59:00 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44948 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab0CBX65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:58:57 -0500
From: imunsie@au1.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Armin Schindler <mac@melware.de>,
       Karsten Keil <isdn@linux-pingi.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stoyan Gaydarov <sgayda2@uiuc.edu>
Subject: [PATCH 1/2] Silence compiler warnings for array access in Eicon DIVA ISDN driver
Date: Wed,  3 Mar 2010 10:58:36 +1100
Message-Id: <1267574318-3643-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

When compiling this driver, the compiler throws the following warnings:

drivers/isdn/hardware/eicon/message.c:8426: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8427: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8434: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8435: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8436: warning: array subscript is above array bounds
drivers/isdn/hardware/eicon/message.c:8447: warning: array subscript is above array bounds

This arises from the particular semantics the driver is using to write
to the nlc array (static byte[256]). The array has a length in byte 0
followed by a T30_INFO struct starting at byte 1.

The T30_INFO struct has a number of variable length strings after the
station_id entry, which cannot be explicitly defined in the struct and
the driver accesses them with an array index to station_id beyond the
length of station_id.

This patch merely changes the semantics that the driver uses to access
the entries after the station_id entry to use the original 256 byte
nlc array taking the offset and length of the station_id entry to
calculate where to write in the array, thereby silencing the warning.

Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
---
 drivers/isdn/hardware/eicon/message.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index ae89fb8..4bd469b 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -8423,17 +8423,17 @@ static word add_b23(PLCI *plci, API_PARSE *bp)
             pos = 0;
           else
           {
-            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
-            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
+            nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
+            nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
             len = (byte)b3_config_parms[2].length;
             if (len > 20)
               len = 20;
             if (CAPI_MAX_DATE_TIME_LENGTH + 2 + len + 2 + b3_config_parms[3].length <= CAPI_MAX_HEAD_LINE_SPACE)
             {
               for (i = 0; i < len; i++)
-                ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte   *)b3_config_parms[2].info)[1+i];
-              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
-              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
+                nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ((byte   *)b3_config_parms[2].info)[1+i];
+              nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
+              nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] = ' ';
             }
           }
         }
@@ -8444,9 +8444,8 @@ static word add_b23(PLCI *plci, API_PARSE *bp)
         ((T30_INFO *)&nlc[1])->head_line_len = (byte)(pos + len);
         nlc[0] += (byte)(pos + len);
         for (i = 0; i < len; i++)
-          ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte   *)b3_config_parms[3].info)[1+i];
-        }
-      else
+          nlc[1 + offsetof(T30_INFO, station_id) + 20 + pos++] =  ((byte   *)b3_config_parms[3].info)[1+i];
+      } else
         ((T30_INFO *)&nlc[1])->head_line_len = 0;
 
       plci->nsf_control_bits = 0;
-- 
1.6.6.1

