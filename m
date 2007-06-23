Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbXFWLAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbXFWLAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbXFWK72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:59:28 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:59934 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbXFWK71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:59:27 -0400
Date: Sat, 23 Jun 2007 12:50:46 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] fbdev: make fb_find_mode look for a mode with the
	highest refresh rate
Message-ID: <20070623105046.GB12623@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the refresh rate hasn't been explicitly specified, fd_find_mode
currently returns the first mode with the requested resolution. Change
it so that it returns a mode with the requested resolution and the
highest refresh rate.

Also export fb_destroy_modelist, which is used in uvesafb.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
drivers/video/modedb.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 3741ad7..98ee77b 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -606,16 +606,18 @@ done:
 	DPRINTK("Trying specified video mode%s %ix%i\n",
 	    refresh_specified ? "" : " (ignoring refresh rate)", xres, yres);
 
+	if (!refresh_specified)
+		refresh = 200;
 	diff = refresh;
 	best = -1;
 	for (i = 0; i < dbsize; i++) {
 		if (name_matches(db[i], name, namelen) ||
 		    (res_specified && res_matches(db[i], xres, yres))) {
 			if(!fb_try_mode(var, info, &db[i], bpp)) {
-				if(!refresh_specified || db[i].refresh == refresh)
+				if (refresh_specified && db[i].refresh == refresh)
 					return 1;
 				else {
-					if(diff > abs(db[i].refresh - refresh)) {
+					if (diff > abs(db[i].refresh - refresh)) {
 						diff = abs(db[i].refresh - refresh);
 						best = i;
 					}
@@ -938,6 +940,7 @@ void fb_destroy_modelist(struct list_head *head)
 		kfree(pos);
 	}
 }
+EXPORT_SYMBOL_GPL(fb_destroy_modelist);
 
 /**
  * fb_videomode_to_modelist: convert mode array to mode list


