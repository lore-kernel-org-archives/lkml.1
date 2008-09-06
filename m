Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYIFJ3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYIFJ3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 05:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYIFJ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 05:29:40 -0400
Received: from host41-139-dynamic.116-80-r.retail.telecomitalia.it ([80.116.139.41]:56606
	"EHLO poppero1" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752253AbYIFJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 05:29:40 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2008 05:29:39 EDT
Date: Sat, 6 Sep 2008 11:19:19 +0200
From: Roberto Oppedisano <roppedisano@infracomspa.it>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rate limit drm:radeon_cp_idle/reset errors
Message-ID: <20080906091919.GA5021@infracomspa.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching from kwin composite wm (KDE 4.1) to compiz I often hit the
following error:

Sep  6 10:24:31 poppero1 kernel: [  186.138203] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.138568] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840

probably due to broken X drivers/apps; after hitting this the error my laptop
(hp nx7010) is totally unresponsitive to keyboard/mouse, also if it can be 
shut down via the power button:

Sep  6 10:24:59 poppero1 powersave-wm_shutdown[4843]: DIAG: Process script for event button.power ID 10
Sep  6 10:24:59 poppero1 powersave-wm_shutdown[4843]: INFO: Event: BUTTON_POWER occured.
Sep  6 10:24:59 poppero1 powersave-wm_shutdown[4843]: INFO: Parameters: Event - button.power; Current Active Scheme: scheme_performance - ACPI event line: button/power PWRF 00000080
00000001
Sep  6 10:25:00 poppero1 shutdown[4852]: shutting down for system halt
...

Without the attached patch, which rate limits DRM_ERROR, the syslog is flooded
by thuosands of messages; here's the output with the patch applied.

Sep  6 10:24:31 poppero1 kernel: [  186.138774] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.138968] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.139214] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.139408] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.139601] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.139866] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.140072] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:31 poppero1 kernel: [  186.140467] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:36 poppero1 kernel: [  191.139019] __ratelimit: 253431 callbacks suppressed
Sep  6 10:24:36 poppero1 kernel: [  191.139030] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
Sep  6 10:24:36 poppero1 kernel: [  191.139314] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840

Also if it doesn't solve a bug I think it may still be worth applying it. 
Patch is against current git.

Signed-off-by: Roberto Oppedisano <roberto.oppedisano@infracom.it>

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 1c1b13e..1107361 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -162,7 +162,8 @@ struct drm_device;
  * \param arg arguments
  */
 #define DRM_ERROR(fmt, arg...) \
-	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
+	if (printk_ratelimit()) \
+		printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
 
 /**
  * Memory error output.

