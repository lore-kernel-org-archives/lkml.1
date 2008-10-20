Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYJTWsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYJTWsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYJTWr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:47:57 -0400
Received: from www.tglx.de ([62.245.132.106]:32909 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYJTWr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:47:57 -0400
Date: Tue, 21 Oct 2008 00:47:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix CONFIG_HIGHMEM compile error in
 drivers/gpu/drm/i915/i915_gem.c
Message-ID: <alpine.LFD.2.00.0810210034420.3301@apollo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9b7530cc329eb036cfa589930c270e85031f554c
i915: cleanup coding horrors in i915_gem_gtt_pwrite()

broke the i386 build for CONFIG_HIGHMEM=y.

Caught by automatic testing http://www.tglx.de/autoqa-logs/000137-0006-0001.log

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 49c5a17..dc2e6fd 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -182,7 +182,8 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
  * happens to let us map card memory without taking IPIs.  When the vmap
  * rework lands we should be able to dump this hack.
  */
-static inline int fast_user_write(unsigned long pfn, char __user *user_data, int l)
+static inline int fast_user_write(unsigned long pfn, char __user *user_data,
+				  int l, int o)
 {
 #ifdef CONFIG_HIGHMEM
 	unsigned long unwritten;
@@ -251,7 +252,7 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 
 		pfn = (dev->agp->base >> PAGE_SHIFT) + i;
 
-		if (!fast_user_write(pfn, user_data, l)) {
+		if (!fast_user_write(pfn, user_data, l, o)) {
 			unsigned long unwritten;
 			char __iomem *vaddr;
 
