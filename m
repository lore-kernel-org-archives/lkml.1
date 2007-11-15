Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbXKOHIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbXKOHIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932468AbXKOGsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43714 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765614AbXKOGsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:13 -0500
Date: Wed, 14 Nov 2007 22:45:48 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>
Subject: [patch 35/40] radeon: set the address to access the GART table on
	the CPU side correctly
Message-ID: <20071115064548.GJ19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="radeon-set-the-address-to-access-the-gart-table-on-the-cpu-side-correctly.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Airlie <airlied@linux.ie>

Upstream as 7fc86860cf73e060ab8ed9763010dfe5b5389b1c

This code relied on the CPU and GPU address for the aperture being the same,
On some r5xx hardware I was playing with I noticed that this isn't always true.
This fixes issues seen on some r400 cards. (bugs.freedesktop.org 9957)

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/drm/radeon_cp.c  |    5 +++--
 drivers/char/drm/radeon_drv.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/drm/radeon_cp.c
+++ b/drivers/char/drm/radeon_cp.c
@@ -1679,7 +1679,7 @@ static int radeon_do_init_cp(struct drm_
 			dev_priv->gart_info.bus_addr =
 			    dev_priv->pcigart_offset + dev_priv->fb_location;
 			dev_priv->gart_info.mapping.offset =
-			    dev_priv->gart_info.bus_addr;
+			    dev_priv->pcigart_offset + dev_priv->fb_aper_offset;
 			dev_priv->gart_info.mapping.size =
 			    dev_priv->gart_info.table_size;
 
@@ -2291,7 +2291,8 @@ int radeon_driver_firstopen(struct drm_d
 	if (ret != 0)
 		return ret;
 
-	ret = drm_addmap(dev, drm_get_resource_start(dev, 0),
+	dev_priv->fb_aper_offset = drm_get_resource_start(dev, 0);
+	ret = drm_addmap(dev, dev_priv->fb_aper_offset,
 			 drm_get_resource_len(dev, 0), _DRM_FRAME_BUFFER,
 			 _DRM_WRITE_COMBINING, &map);
 	if (ret != 0)
--- a/drivers/char/drm/radeon_drv.h
+++ b/drivers/char/drm/radeon_drv.h
@@ -293,6 +293,7 @@ typedef struct drm_radeon_private {
 
 	/* starting from here on, data is preserved accross an open */
 	uint32_t flags;		/* see radeon_chip_flags */
+	unsigned long fb_aper_offset;
 } drm_radeon_private_t;
 
 typedef struct drm_radeon_buf_priv {

-- 
