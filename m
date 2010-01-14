Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638Ab0ANNIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0ANNIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625Ab0ANNIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:08:31 -0500
Received: from smtp.nokia.com ([192.100.105.134]:65072 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0ANNIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:08:30 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH 2/3] drm: Don't use own implementation of atoi()
Date: Thu, 14 Jan 2010 15:07:22 +0200
Message-Id: <282b89e0ab9019f803e3b4fc36b4c5780a696cb8.1263473812.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <8c5b5f9532bdb31baa11432bea0039bf39854596.1263473812.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
 <8c5b5f9532bdb31baa11432bea0039bf39854596.1263473812.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 14 Jan 2010 13:08:05.0186 (UTC) FILETIME=[9BF78A20:01CA951A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Kernel has simple_strtol() which would be used as atoi().

This is quite the same fix as in 2cb96f86628d6e97fcbda5fe4d8d74876239834c,
because code in drivers/gpu/drm/drm_fb_helper.c is based on
drivers/video/modedb.c.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/drm_fb_helper.c |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 1c2b7d4..a3c0a33 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -29,6 +29,7 @@
  */
 #include <linux/sysrq.h>
 #include <linux/fb.h>
+#include <linux/kernel.h>
 #include "drmP.h"
 #include "drm_crtc.h"
 #include "drm_fb_helper.h"
@@ -50,21 +51,6 @@ int drm_fb_helper_add_connector(struct drm_connector *connector)
 }
 EXPORT_SYMBOL(drm_fb_helper_add_connector);
 
-static int my_atoi(const char *name)
-{
-	int val = 0;
-
-	for (;; name++) {
-		switch (*name) {
-		case '0' ... '9':
-			val = 10*val+(*name-'0');
-			break;
-		default:
-			return val;
-		}
-	}
-}
-
 /**
  * drm_fb_helper_connector_parse_command_line - parse command line for connector
  * @connector - connector to parse line for
@@ -111,7 +97,7 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_connector *con
 			namelen = i;
 			if (!refresh_specified && !bpp_specified &&
 			    !yres_specified) {
-				refresh = my_atoi(&name[i+1]);
+				refresh = simple_strtol(&name[i+1], NULL, 10);
 				refresh_specified = 1;
 				if (cvt || rb)
 					cvt = 0;
@@ -121,7 +107,7 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_connector *con
 		case '-':
 			namelen = i;
 			if (!bpp_specified && !yres_specified) {
-				bpp = my_atoi(&name[i+1]);
+				bpp = simple_strtol(&name[i+1], NULL, 10);
 				bpp_specified = 1;
 				if (cvt || rb)
 					cvt = 0;
@@ -130,7 +116,7 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_connector *con
 			break;
 		case 'x':
 			if (!yres_specified) {
-				yres = my_atoi(&name[i+1]);
+				yres = simple_strtol(&name[i+1], NULL, 10);
 				yres_specified = 1;
 			} else
 				goto done;
@@ -170,7 +156,7 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_connector *con
 		}
 	}
 	if (i < 0 && yres_specified) {
-		xres = my_atoi(name);
+		xres = simple_strtol(name, NULL, 10);
 		res_specified = 1;
 	}
 done:
-- 
1.5.6.5

