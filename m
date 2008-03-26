Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbYCZXez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbYCZXez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYCZXes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:34:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:34304 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbYCZXer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:34:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,561,1199692800"; 
   d="scan'208";a="361209986"
From: Jesse Barnes <jesse.barnes@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] don't suspend/resume 8xx chips
Date: Wed, 26 Mar 2008 16:28:12 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261628.12336.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent testing has turned up some bugs in the new Intel suspend/resume code 
for old, 8xx chipsets.  So for 2.6.25 it probably makes sense to apply this 
patch, which should prevent the new code from getting called on those 
chipsets.  We should have this fixed soon, but not in time for 2.6.25 
unfortunately.  Note that this patch (along with the suspend/resume code in 
general) could use more testing.

Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
index e9d6663..6964a28 100644
--- a/drivers/char/drm/i915_dma.c
+++ b/drivers/char/drm/i915_dma.c
@@ -762,6 +762,11 @@ int i915_driver_load(struct drm_device *dev, unsigned 
long
        unsigned long base, size;
        int ret = 0, mmio_bar = IS_I9XX(dev) ? 0 : 1;

+       if (!IS_I9XX(dev)) {
+               dev->driver->suspend = NULL;
+               dev->driver->resume = NULL;
+       }
+
        /* i915 has 4 more counters */
        dev->counters += 4;
        dev->types[6] = _DRM_STAT_IRQ;
