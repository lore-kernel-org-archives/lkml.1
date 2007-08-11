Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXHKOoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXHKOoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbXHKOnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:43:52 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:49237 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758225AbXHKOnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:43:51 -0400
Date: Sat, 11 Aug 2007 16:43:27 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] uvesafb: try to set mode with default timings if
	setting it with our own timings failed
Message-ID: <20070811144327.GH13632@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the BIOS might not perform the mode switch correctly because of
the timings that we requested.  In case this happens, try to set the video
mode with the default timings instead.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 2e5f1b5..853323e 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -1218,6 +1218,7 @@ static int uvesafb_set_par(struct fb_info *info)
 	task = uvesafb_prep();
 	if (!task)
 		return -ENOMEM;
+setmode:
 	task->t.regs.eax = 0x4f02;
 	task->t.regs.ebx = mode->mode_id | 0x4000;	/* use LFB */
 
@@ -1260,10 +1261,25 @@ static int uvesafb_set_par(struct fb_info *info)
 
 	err = uvesafb_exec(task);
 	if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
-		printk(KERN_ERR "uvesafb: mode switch failed (eax=0x%x, "
-				"err=%d)\n", task->t.regs.eax, err);
-		err = -EINVAL;
-		goto out;
+		/*
+		 * The mode switch might have failed because we tried to
+		 * use our own timings.  Try again with the default timings.
+		 */
+		if (crtc != NULL) {
+			printk(KERN_WARNING "uvesafb: mode switch failed "
+				"(eax=0x%x, err=%d). Trying again with "
+				"default timings.\n", task->t.regs.eax, err);
+			uvesafb_reset(task);
+			kfree(crtc);
+			crtc = NULL;
+			info->var.pixclock = 0;
+			goto setmode;
+		} else {
+			printk(KERN_ERR "uvesafb: mode switch failed (eax="
+				"0x%x, err=%d)\n", task->t.regs.eax, err);
+			err = -EINVAL;
+			goto out;
+		}
 	}
 	par->mode_idx = i;

