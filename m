Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbXH2WvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbXH2WvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbXH2WvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:51:10 -0400
Received: from 110.47.78.83.cust.bluewin.ch ([83.78.47.110]:52439 "EHLO
	spock.one.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755639AbXH2WvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:51:09 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2007 18:51:08 EDT
Date: Thu, 30 Aug 2007 00:41:16 +0200
From: Michal Januszewski <spock@gentoo.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH] fbdev: find mode with the highest/safest refresh rate in
	fb_find_mode()
Message-ID: <20070829224116.GA25106@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070718084102.GA22694@spock.one.pl> <20070718143803.GA5787@localhost.localdomain> <1184771895.4523.33.camel@daplas> <20070826190913.GA24286@spock.one.pl> <1188168573.4806.5.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1188168573.4806.5.camel@daplas>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if the refresh rate is not specified, fb_find_mode() returns
the first known video mode with the requested resolution, which provides
no guarantees wrt the refresh rate.  Change this so that the mode with
the highest refresh rate is returned when the driver provides a custom
video mode database and the monitor limits, and a mode with the safe
60 Hz refresh rate otherwise.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 3741ad7..9598c46 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -606,26 +606,43 @@ done:
 	DPRINTK("Trying specified video mode%s %ix%i\n",
 	    refresh_specified ? "" : " (ignoring refresh rate)", xres, yres);
 
-	diff = refresh;
+	if (!refresh_specified) {
+		/*
+		 * If the caller has provided a custom mode database and a
+		 * valid monspecs structure, we look for the mode with the
+		 * highest refresh rate.  Otherwise we play it safe it and
+		 * try to find a mode with a refresh rate closest to the
+		 * standard 60 Hz.
+		 */
+		if (db != modedb &&
+		    info->monspecs.vfmin && info->monspecs.vfmax &&
+		    info->monspecs.hfmin && info->monspecs.hfmax &&
+		    info->monspecs.dclkmax) {
+			refresh = 1000;
+		} else {
+			refresh = 60;
+		}
+	}
+
+	diff = -1;
 	best = -1;
 	for (i = 0; i < dbsize; i++) {
-		if (name_matches(db[i], name, namelen) ||
-		    (res_specified && res_matches(db[i], xres, yres))) {
-			if(!fb_try_mode(var, info, &db[i], bpp)) {
-				if(!refresh_specified || db[i].refresh == refresh)
-					return 1;
-				else {
-					if(diff > abs(db[i].refresh - refresh)) {
-						diff = abs(db[i].refresh - refresh);
-						best = i;
-					}
+		if ((name_matches(db[i], name, namelen) ||
+		    (res_specified && res_matches(db[i], xres, yres))) &&
+		    !fb_try_mode(var, info, &db[i], bpp)) {
+			if (refresh_specified && db[i].refresh == refresh) {
+				return 1;
+			} else {
+				if (abs(db[i].refresh - refresh) < diff) {
+					diff = abs(db[i].refresh - refresh);
+					best = i;
 				}
 			}
 		}
 	}
 	if (best != -1) {
 		fb_try_mode(var, info, &db[best], bpp);
-		return 2;
+		return (refresh_specified) ? 2 : 1;
 	}
 
 	diff = xres + yres;

