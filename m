Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZHTL5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZHTL5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZHTL5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:57:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:49756 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754099AbZHTL53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:57:29 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18Xam1FkR8Xetv0Bvy3dzkpeFKLQq/lVLxmP9L7er
	8EttHDM/GEvzIO
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] fb: do not ignore fb_set_par errors
Date: Thu, 20 Aug 2009 11:59:57 +0000
Message-Id: <1250769597-14861-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1250769597-14861-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1250769597-14861-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fb: do not ignore fb_set_par errors

At the moment about half of the framebuffer drivers can return an error
code in fb_set_par. Until now it would be silently ignored by fbmem.c
and fbcon.c. This patch fixes fbmem.c to return the error code and
restore var on error. But it is not clear in which video mode the device
is when fb_set_par fails. It would be good and reasonable if it were in
the old state but there is no guarantee that this is true for all
existing drivers.
Although most errors should be caught by the previous fb_check_var some
errors can't as they are dynamic (memory allocations, ...) and can only
be detected while performing the operations which is forbidden in
fb_check_var.
This patch shouldn't have a negative impact on normal operation as all
drivers return 0 on success. The impact in case of error depends heavily
on the driver and caller but it's expected to be better than before.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/fbmem.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index a85c818..85c1595 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -954,6 +954,7 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 			goto done;
 
 		if ((var->activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW) {
+			struct fb_var_screeninfo old_var;
 			struct fb_videomode mode;
 
 			if (info->fbops->fb_get_caps) {
@@ -963,10 +964,17 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 					goto done;
 			}
 
+			old_var = info->var;
 			info->var = *var;
 
-			if (info->fbops->fb_set_par)
-				info->fbops->fb_set_par(info);
+			if (info->fbops->fb_set_par) {
+				ret = info->fbops->fb_set_par(info);
+
+				if (ret) {
+					info->var = old_var;
+					goto done;
+				}
+			}
 
 			fb_pan_display(info, &info->var);
 			fb_set_cmap(&info->cmap, info);
-- 
1.6.3.2

