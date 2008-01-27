Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYA0Lbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYA0Lbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYA0Lbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:31:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:63840 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYA0Lbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:31:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=JkIWRGNmfrduU8OSrzFKGcrdpb2WvDJmULxdQdvdmkavOljYpzeWfJ3eK1zYujTSARMfm8OiK2E2H/4xLrClfARMAkZBZtumtLs24YKGS11tvHb35aVK6Fv+IATeifZxpcvk+AAB0Tp0gKVhwQ8dBcFMxO9fpWIKQ+ULT9WsyY8=
Date: Sun, 27 Jan 2008 12:31:16 +0100
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: make the best-fit section of fb_find_mode return
	the closest matching mode
Message-ID: <20080127113115.GA17722@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
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

Change this behaviour so that the true closest match in terms
of the city-block metric is returned.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 08d0725..bc29ef3 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -655,15 +655,15 @@ done:
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
+			if (diff > abs(db[i].xres - xres) +
+				   abs(db[i].yres - yres)) {
+				diff = abs(db[i].xres - xres) +
+				       abs(db[i].yres - yres);
+				best = i;
+			}
 		}
-	    }
 	}
 	if (best != -1) {
 	    fb_try_mode(var, info, &db[best], bpp);

