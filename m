Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZCRR1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZCRR1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbZCRR0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:26:49 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:37717 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbZCRR0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:26:49 -0400
Subject: [PATCH] drm: reorder struct drm_ioctl_desc to save space on 64 bit
 builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: airlied@linux.ie
Cc: lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Wed, 18 Mar 2009 17:26:44 +0000
Message-Id: <1237397204.2794.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm: reorder struct drm_ioctl_desc to save space on 64 bit builds

shrinks drm_ioctl_desc from 24 bytes to 16 bytes by reordering members
to remove padding.

updates DRM_IOCTL_DEF macro to initialise structure members by name to
handle the structure reorder.

The applied patch reduces data used in drm.ko from 10440 to 9032

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

This patch is against v2.6.29-rc8, it compiles but hasn't had any other
testing as I don't have any of this hardware.

size reports
drm.ko
text	data	bss
106297	10440	144	116881	1c891
106297	9032	144	115473	1c311 +patch

I also built these 2 drivers
sis.ko
text data bss
3817	2116	0	5933	172d	
3817	1932	0	5749	1675 +patch

radeon.ko
text data bss
94744	9880	16400	121024
94744	9656	16400	120800 +patch

regards
Richard


diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index e5f4ae9..62c2ef3 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -281,16 +281,16 @@ typedef int drm_ioctl_compat_t(struct file *filp, unsigned int cmd,
 
 struct drm_ioctl_desc {
 	unsigned int cmd;
-	drm_ioctl_t *func;
 	int flags;
+	drm_ioctl_t *func;
 };
 
 /**
  * Creates a driver or general drm_ioctl_desc array entry for the given
  * ioctl, for use by drm_ioctl().
  */
-#define DRM_IOCTL_DEF(ioctl, func, flags) \
-	[DRM_IOCTL_NR(ioctl)] = {ioctl, func, flags}
+#define DRM_IOCTL_DEF(ioctl, _func, _flags) \
+	[DRM_IOCTL_NR(ioctl)] = {.cmd = ioctl, .func = _func, .flags = _flags}
 
 struct drm_magic_entry {
 	struct list_head head;


