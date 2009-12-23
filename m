Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZLWVnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZLWVnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbZLWVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:43:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:48146 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbZLWVnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:43:39 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH 34/37] i915: when kgdb is active display compression should be off
Date: Wed, 23 Dec 2009 15:43:01 -0600
Message-Id: <1261604584-5796-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261604584-5796-1-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-33-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:43:16.0091 (UTC) FILETIME=[EF36D4B0:01CA8418]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the HW compression is left on, the call backs from the HW will
crash the kernel.  The only time this code is called is when kernel
mode setting is in use with kgdb and the kdb shell.

The atomic display pipe handler callback will reset everything when
kgdb restores kernel to the run state.

CC: David Airlie <airlied@linux.ie>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e134a81..71816db 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1165,6 +1165,10 @@ static void intel_update_fbc(struct drm_crtc *crtc,
 		DRM_DEBUG_KMS("framebuffer not tiled, disabling compression\n");
 		goto out_disable;
 	}
+#ifdef CONFIG_KGDB
+	if (atomic_read(&kgdb_active) != -1)
+		goto out_disable;
+#endif /* CONFIG_KGDB */
 
 	if (dev_priv->display.fbc_enabled(crtc)) {
 		/* We can re-enable it in this case, but need to update pitch */
-- 
1.6.4.rc1

