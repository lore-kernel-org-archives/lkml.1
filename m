Return-Path: <linux-kernel-owner+w=401wt.eu-S1751332AbXBMRhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbXBMRhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbXBMRhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:37:53 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:54543 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbXBMRhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:37:52 -0500
Date: Tue, 13 Feb 2007 18:38:05 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070213173805.GK8882@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RE3pQJLXZi4fr8Xo"
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] pxafb: Add option to enable/disable the cursor
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--RE3pQJLXZi4fr8Xo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Add cursor enable/disable, very useful if you wish a full screen boot
logo.
    
Cursor can be disabled from kernel command line:
    
   video=pxafb:nocursor
    
or from sysfs interface:
    
   echo 1 > /sys/module/pxafb/parameters/nocursor
    
Signed-off-by: Rodolfo Giometti <giometti@linux.it>

--RE3pQJLXZi4fr8Xo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pxafb-nocursor

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index b4947c8..5d33501 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -9,6 +9,8 @@
  *  which in turn is
  *   Based on acornfb.c Copyright (C) Russell King.
  *
+ * Cursor enable/disable by Rodolfo Giometti <giometti@linux.it>
+ *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive for
  * more details.
@@ -54,6 +56,10 @@
 
 #include "pxafb.h"
 
+static int nocursor = 0;
+module_param(nocursor, int, 0644);
+MODULE_PARM_DESC(nocursor, "cursor enable/disable");
+
 /* Bits which should not be set in machine configuration structures */
 #define LCCR0_INVALID_CONFIG_MASK (LCCR0_OUM|LCCR0_BM|LCCR0_QDM|LCCR0_DIS|LCCR0_EFM|LCCR0_IUM|LCCR0_SFM|LCCR0_LDM|LCCR0_ENB)
 #define LCCR3_INVALID_CONFIG_MASK (LCCR3_HSP|LCCR3_VSP|LCCR3_PCD|LCCR3_BPP)
@@ -464,6 +470,17 @@ static int pxafb_mmap(struct fb_info *info,
 	return -EINVAL;
 }
 
+/* fb_cursor
+ * Used to disable cursor drawing...
+ */
+int pxafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+{
+	if (nocursor)
+		return 0;
+	else
+		return -EINVAL;	/* just to force soft_cursor() call */
+}
+
 static struct fb_ops pxafb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_check_var	= pxafb_check_var,
@@ -474,6 +491,7 @@ static struct fb_ops pxafb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 	.fb_blank	= pxafb_blank,
 	.fb_mmap	= pxafb_mmap,
+	.fb_cursor	= pxafb_cursor,
 };
 
 /*
@@ -1308,6 +1326,9 @@ static int __init pxafb_parse_options(struct device *dev, char *options)
 			inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_4PixMono;
                 } else if (!strncmp(this_opt, "8pix", 4)) {
 			inf->lccr0 = (inf->lccr0 & ~LCCR0_DPD) | LCCR0_8PixMono;
+		} else if (!strncmp(this_opt, "nocursor", 8)) {
+			nocursor = 1;
+			dev_info(dev, "cursor disabled");
 		} else {
 			dev_err(dev, "unknown option: %s\n", this_opt);
 			return -EINVAL;

--RE3pQJLXZi4fr8Xo--
