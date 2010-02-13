Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab0BMKuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 05:50:08 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64542 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0BMKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:50:05 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 05:50:05 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v9LjPYWTFGXvp9rC0mdXSzBCmudv3mK6ekRCsBKuaED8LsqUJLbNlziLpeW0+KeyoB
         JEoO837znFnpUntxe7NazcBILRtctHe+SO0ginvli5O7jRlFesUt4xgS+afgpIOu/arw
         kLe4O4O4vNCiDKUiRqDiqvJ/PvasfciLy1Ycs=
Date: Sat, 13 Feb 2010 11:41:48 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Jones <pjones@redhat.com>, Dave Airlie <airlied@redhat.com>,
       Huang Ying <ying.huang@intel.com>, linux-fbdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alex Zhavnerchik <alex.vizor@gmail.com>
Subject: [PATCH] efifb: fix framebuffer handoff
Message-ID: <20100213104148.GB2880@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4410f3910947dcea8672280b3adecd53cec4e85e
(fbdev: add support for handoff from firmware to hw framebuffers)
didn't add fb_destroy operation to efifb. Fix it and change
aperture_size to match size passed to request_mem_region.

See: http://bugzilla.kernel.org/show_bug.cgi?id=15151

Reported-by: Alex Zhavnerchik <alex.vizor@gmail.com>
Tested-by: Alex Zhavnerchik <alex.vizor@gmail.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/video/efifb.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index eb12182..d25df51 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -161,8 +161,17 @@ static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	return 0;
 }
 
+static void efifb_destroy(struct fb_info *info)
+{
+	if (info->screen_base)
+		iounmap(info->screen_base);
+	release_mem_region(info->aperture_base, info->aperture_size);
+	framebuffer_release(info);
+}
+
 static struct fb_ops efifb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_destroy	= efifb_destroy,
 	.fb_setcolreg	= efifb_setcolreg,
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
@@ -281,7 +290,7 @@ static int __init efifb_probe(struct platform_device *dev)
 	info->par = NULL;
 
 	info->aperture_base = efifb_fix.smem_start;
-	info->aperture_size = size_total;
+	info->aperture_size = size_remap;
 
 	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
 	if (!info->screen_base) {
-- 
1.6.6

