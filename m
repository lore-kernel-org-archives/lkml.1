Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYBJSrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYBJSrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYBJSrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:47:12 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:23473 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYBJSrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:47:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:x-pgp-key:user-agent:sender;
        b=KURuxSAFxTglLM4HfUo7v4QOrkODmWL49igutP88DQMxuaJWgDByuvHwsUWcj97eEkDKer+HUyHQ5r3n+OIs118bgEV3Qif3ANxo0lfUKb1M0ky41iAkWA4TMkCrI1Hba47oEQ+zyQaoSAl3CQ1ex6w3O/aHeXBpldS/sFYdEGg=
Date: Sun, 10 Feb 2008 19:46:13 +0100
From: Michal Januszewski <spock@gentoo.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: make the best-fit section of fb_find_mode return
	the closest matching mode
Message-ID: <20080210184613.GA11006@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20080127113115.GA17722@spock.one.pl> <20080127132510.b00017cb.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080127132510.b00017cb.krzysztof.h1@poczta.fm>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>

Currently, if a perfect match in terms of resolution is not found,
fb_find_mode() only looks for a best-fit mode among modes with a
higher resolution than the one requested.  Thus, if the user
requests a resolution higher than the largest supported one, they
are dropped to the default mode (usually a low resolution one).

Change this behaviour so that all valid video modes are considered
when looking for a best-fit mode, while still preferring modes
with a higher resolution.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 08d0725..0b6a45f 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -522,7 +522,7 @@ int fb_find_mode(struct fb_var_screeninfo *var,
 	int res_specified = 0, bpp_specified = 0, refresh_specified = 0;
 	unsigned int xres = 0, yres = 0, bpp = default_bpp, refresh = 0;
 	int yres_specified = 0, cvt = 0, rb = 0, interlace = 0, margins = 0;
-	u32 best, diff;
+	u32 best, diff, tdiff;
 
 	for (i = namelen-1; i >= 0; i--) {
 	    switch (name[i]) {
@@ -651,19 +651,27 @@ done:
 		return (refresh_specified) ? 2 : 1;
 	}
 
-	diff = xres + yres;
+	diff = 2 * (xres + yres);
 	best = -1;
 	DPRINTK("Trying best-fit modes\n");
 	for (i = 0; i < dbsize; i++) {
-	    if (xres <= db[i].xres && yres <= db[i].yres) {
 		DPRINTK("Trying %ix%i\n", db[i].xres, db[i].yres);
 		if (!fb_try_mode(var, info, &db[i], bpp)) {
-		    if (diff > (db[i].xres - xres) + (db[i].yres - yres)) {
-			diff = (db[i].xres - xres) + (db[i].yres - yres);
-			best = i;
-		    }
+			tdiff = abs(db[i].xres - xres) +
+				abs(db[i].yres - yres);
+
+			/*
+			 * Penalize modes with resolutions smaller
+			 * than requested.
+			 */
+			if (xres > db[i].xres || yres > db[i].yres)
+				tdiff += xres + yres;
+
+			if (diff > tdiff) {
+				diff = tdiff;
+				best = i;
+			}
 		}
-	    }
 	}
 	if (best != -1) {
 	    fb_try_mode(var, info, &db[best], bpp);
