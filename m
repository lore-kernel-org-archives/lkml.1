Return-Path: <linux-kernel-owner+w=401wt.eu-S1760458AbXHKOnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbXHKOnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbXHKOm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:42:57 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:49232 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbXHKOm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:42:56 -0400
Date: Sat, 11 Aug 2007 16:42:32 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] uvesafb: use the default refresh rate if the monitor
	limits are not set
Message-ID: <20070811144232.GG13632@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the default refresh rate if the monitor limits aren't set (either using
data from the EDID block, or explicitly by the user).

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 2f1e5af..2e5f1b5 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -689,10 +689,13 @@ static void __devinit uvesafb_vbe_getmonspecs(struct uvesafb_ktask *task,
 
 	/*
 	 * If we don't get all necessary data from the EDID block,
-	 * mark it as incompatible with the GTF.
+	 * mark it as incompatible with the GTF and set nocrtc so
+	 * that we always use the default BIOS refresh rate.
 	 */
-	if (uvesafb_vbe_getedid(task, info))
+	if (uvesafb_vbe_getedid(task, info)) {
 		info->monspecs.gtf = 0;
+		par->nocrtc = 1;
+	}
 
 	/* Kernel command line overrides. */
 	if (maxclk)
@@ -711,6 +714,7 @@ static void __devinit uvesafb_vbe_getmonspecs(struct uvesafb_ktask *task,
 		info->monspecs.vfmin = 60;
 		info->monspecs.hfmin = 29000;
 		info->monspecs.gtf = 1;
+		par->nocrtc = 0;
 	}
 
 	if (info->monspecs.gtf)
@@ -720,7 +724,8 @@ static void __devinit uvesafb_vbe_getmonspecs(struct uvesafb_ktask *task,
 			(int)(info->monspecs.hfmax / 1000),
 			(int)(info->monspecs.dclkmax / 1000000));
 	else
-		printk(KERN_INFO "uvesafb: no monitor limits have been set\n");
+		printk(KERN_INFO "uvesafb: no monitor limits have been set, "
+				 "default refresh rate will be used\n");
 
 	/* Add VBE modes to the modelist. */
 	for (i = 0; i < par->vbe_modes_cnt; i++) {


