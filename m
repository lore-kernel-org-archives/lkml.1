Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZLWVns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZLWVns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbZLWVnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:43:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:48144 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbZLWVnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:43:37 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 35/37] drm_fb_helper: Preserve capability to use atomic kms
Date: Wed, 23 Dec 2009 15:43:02 -0600
Message-Id: <1261604584-5796-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261604584-5796-2-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-33-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-1-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:43:17.0076 (UTC) FILETIME=[EFCD2140:01CA8418]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199 changed logic of when
a pixclock was valid vs invalid.

The atomic kernel mode setting used by the kernel debugger relied upon
the drm_fb_helper_check_var() to always return -EINVAL.  Until a
better solution exists, this behavior will be restored.

CC: David Airlie <airlied@linux.ie>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 80aab3c..b390fd8 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -683,6 +683,10 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 
 	if (var->pixclock != 0)
 		return -EINVAL;
+#ifdef CONFIG_KGDB
+	if (atomic_read(&kgdb_active) != -1)
+		return -EINVAL;
+#endif
 
 	/* Need to resize the fb object !!! */
 	if (var->xres > fb->width || var->yres > fb->height) {
-- 
1.6.4.rc1

