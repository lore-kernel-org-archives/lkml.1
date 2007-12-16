Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXLPSpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXLPSpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXLPSpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:45:47 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:35304 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbXLPSpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:45:46 -0500
Message-id: <21488273061085829123.slaby@pripojeni.net>
In-reply-to: <9008147453061115361.slaby@pripojeni.net>
Subject: [PATCH 2/2] DRM: i915, fix oops after killing X
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <airlied@linux.ie>
Cc: <dri-devel@lists.sourceforge.net>
Cc: Eric Anholt <eric@anholt.net>
Cc: Wang Zhenyu <zhenyu.z.wang@intel.com>
Date: Sun, 16 Dec 2007 13:45:46 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i915, fix oops after killing X

Null sarea_priv, because next lastclose would have bad address in it if
initialization is not called in the meantime.

This is a problem in setups, where drm are closed after X starts. Next
lastclose is invoked on X kill. Newer intel drivers (2.2) with EXA support
hold the device whole time while X runs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>

---
commit c50f4766654ec13d8dc35f96a8d2c199d6ae5c91
tree 3e3a65f44bedf6d846cbb43a315d2f0bce8b7da2
parent f2e573d8a1b391584c76e95f287010b38867de64
author Jiri Slaby <jirislaby@gmail.com> Sun, 16 Dec 2007 19:24:13 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sun, 16 Dec 2007 19:24:13 +0100

 drivers/char/drm/i915_dma.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
index b274554..7a97eea 100644
--- a/drivers/char/drm/i915_dma.c
+++ b/drivers/char/drm/i915_dma.c
@@ -1335,6 +1335,12 @@ void i915_driver_lastclose(struct drm_device * dev)
 		i915_mem_takedown(&(dev_priv->agp_heap));
 
 	i915_dma_cleanup(dev);
+	
+	/* Mapping won't survive to the next firstopen anyways. It will
+	 * probably oops without it on next lastclose if we not null it
+	 * here, if it will be mapped anywhere else, but without dma being
+	 * initialized -js */
+	dev_priv->sarea_priv = NULL;
 }
 
 void i915_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
