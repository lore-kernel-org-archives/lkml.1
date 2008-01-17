Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYAQXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYAQXwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbYAQXwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:52:05 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:43971 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbYAQXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:52:04 -0500
Date: Thu, 17 Jan 2008 18:52:03 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: akpm@linux-foundation.org
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: [mm patch] i915: fix invalid opcode exception on cpus without
	clflush
Message-ID: <20080117235203.GB21681@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i915_flush_ttm was unconditionally executing a clflush instruction
to (obviously) flush the cache. Instead, check if the cpu supports
clflush, and if not, fall back to calling wbinvd to flush the entire
cache.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>

--- a/drivers/char/drm/i915_buffer.c
+++ b/drivers/char/drm/i915_buffer.c
@@ -286,7 +286,18 @@ void i915_flush_ttm(struct drm_ttm *ttm)
 		return;
 
 	DRM_MEMORYBARRIER();
+
+#ifdef CONFIG_X86_32
+	/* Hopefully nobody has built an x86-64 processor without clflush */
+	if (!cpu_has_clflush) {
+		wbinvd();
+		DRM_MEMORYBARRIER();
+		return;
+	}
+#endif
+
 	for (i = ttm->num_pages - 1; i >= 0; i--)
 		drm_cache_flush_page(drm_ttm_get_page(ttm, i));
+
 	DRM_MEMORYBARRIER();
 }
