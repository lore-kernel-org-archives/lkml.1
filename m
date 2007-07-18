Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbXGRIlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbXGRIlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbXGRIlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:41:14 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:35563 "EHLO tria"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754164AbXGRIlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:41:12 -0400
Date: Wed, 18 Jul 2007 10:41:02 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: find mode with highest refresh rate in
	fb_find_mode()
Message-ID: <20070718084102.GA22694@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if the refresh rate is not specified fb_find_mode() returns
the first known video mode with the requested resoluion, which provides
no guarantees wrt the refresh rate.  Change this so that the mode with
the highest refresh rate is returned instead.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 3741ad7..f70143a 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -606,26 +606,29 @@ done:
 	DPRINTK("Trying specified video mode%s %ix%i\n",
 	    refresh_specified ? "" : " (ignoring refresh rate)", xres, yres);
 
-	diff = refresh;
+	if (!refresh_specified)
+		diff = 0
+	else
+		diff = refresh;
+
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
+				if (diff < db[i].refresh) {
+					diff = db[i].refresh;
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


