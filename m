Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYKBMfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYKBMfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 07:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYKBMfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 07:35:19 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:48677 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYKBMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 07:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=ejHw+gxARteAIDdq/ArObmmFidZJszlXFL6hj8mvFx5M9DpyAGcOlMTHnpNschW60/
         aY72Z4ay9i7d7CWTzyBVTLP838u5Kk8GF/Y9QAMCcUKC0RX+WjlBFZKlq0RNHJYZT2/l
         epS6+gLr5mfmRuxqPL7/GVnn9YSaXHijoOuDY=
Date: Sun, 2 Nov 2008 13:35:06 +0100
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] uvesafb: fix selecting mode with the vbemode option
Message-ID: <20081102123506.GA3977@spock.one.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the vbemode option is used, uvesafb calls fb_get_mode() without
first setting the resolution in info->var.  This results in a division
by zero in fb_get_mode(), as evidenced e.g. in [1].  Fix this by ensuring
the info->var structure is populated before fb_get_mode() is called.

[1] http://bugzilla.kernel.org/show_bug.cgi?id=11661#c37

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 5074422..592c302 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -842,14 +842,16 @@ static int __devinit uvesafb_vbe_init_mode(struct fb_info *info)
 	if (vbemode) {
 		for (i = 0; i < par->vbe_modes_cnt; i++) {
 			if (par->vbe_modes[i].mode_id == vbemode) {
+				modeid = i;
+				uvesafb_setup_var(&info->var, info,
+						&par->vbe_modes[modeid]);
 				fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
-							&info->var, info);
+						&info->var, info);
 				/*
 				 * With pixclock set to 0, the default BIOS
 				 * timings will be used in set_par().
 				 */
 				info->var.pixclock = 0;
-				modeid = i;
 				goto gotmode;
 			}
 		}
@@ -896,8 +898,11 @@ static int __devinit uvesafb_vbe_init_mode(struct fb_info *info)
 			fb_videomode_to_var(&info->var, mode);
 		} else {
 			modeid = par->vbe_modes[0].mode_id;
+			uvesafb_setup_var(&info->var, info,
+					&par->vbe_modes[modeid]);
 			fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
-				    &info->var, info);
+					&info->var, info);
+
 			goto gotmode;
 		}
 	}
@@ -909,9 +914,9 @@ static int __devinit uvesafb_vbe_init_mode(struct fb_info *info)
 	if (modeid == -1)
 		return -EINVAL;
 
-gotmode:
 	uvesafb_setup_var(&info->var, info, &par->vbe_modes[modeid]);
 
+gotmode:
 	/*
 	 * If we are not VBE3.0+ compliant, we're done -- the BIOS will
 	 * ignore our timings anyway.


