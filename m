Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994Ab0BHLQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:16:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39172 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701Ab0BHLQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:16:42 -0500
Subject: [PATCH] kmemcheck: Test the full object in
	kmemcheck_is_obj_initialized()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christian Casteyde <casteyde.christian@free.fr>
Date: Mon, 08 Feb 2010 11:16:24 +0000
Message-ID: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-51-gc7506
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2010 11:16:25.0523 (UTC) FILETIME=[26FBD830:01CAA8B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for bug #14845 (bugzilla.kernel.org). The
update_checksum() function in mm/kmemleak.c calls
kmemcheck_is_obj_initialised() before scanning an object. When
KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
the crc32_le() reads smaller intervals (32-bit) for which
kmemleak_is_obj_initialised() may be false leading to a kmemcheck
warning.

Note that kmemcheck_is_obj_initialized() is currently only used by
kmemleak before scanning a memory location.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Casteyde <casteyde.christian@free.fr>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
---
 arch/x86/mm/kmemcheck/kmemcheck.c |    2 +-
 arch/x86/mm/kmemcheck/shadow.c    |   16 ++++++++++++++--
 arch/x86/mm/kmemcheck/shadow.h    |    2 ++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index 8cc1833..b3b531a 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -337,7 +337,7 @@ bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
 	if (!shadow)
 		return true;
 
-	status = kmemcheck_shadow_test(shadow, size);
+	status = kmemcheck_shadow_test_all(shadow, size);
 
 	return status == KMEMCHECK_SHADOW_INITIALIZED;
 }
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index 3f66b82..aec1242 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -125,12 +125,12 @@ void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n)
 
 enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
 {
+#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
 	uint8_t *x;
 	unsigned int i;
 
 	x = shadow;
 
-#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
 	/*
 	 * Make sure _some_ bytes are initialized. Gcc frequently generates
 	 * code to access neighboring bytes.
@@ -139,13 +139,25 @@ enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
 		if (x[i] == KMEMCHECK_SHADOW_INITIALIZED)
 			return x[i];
 	}
+
+	return x[0];
 #else
+	return kmemcheck_shadow_test_all(shadow, size);
+#endif
+}
+
+enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+	unsigned int i;
+
+	x = shadow;
+
 	/* All bytes must be initialized. */
 	for (i = 0; i < size; ++i) {
 		if (x[i] != KMEMCHECK_SHADOW_INITIALIZED)
 			return x[i];
 	}
-#endif
 
 	return x[0];
 }
diff --git a/arch/x86/mm/kmemcheck/shadow.h b/arch/x86/mm/kmemcheck/shadow.h
index af46d9a..ff0b2f7 100644
--- a/arch/x86/mm/kmemcheck/shadow.h
+++ b/arch/x86/mm/kmemcheck/shadow.h
@@ -11,6 +11,8 @@ enum kmemcheck_shadow {
 void *kmemcheck_shadow_lookup(unsigned long address);
 
 enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size);
+enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow,
+						unsigned int size);
 void kmemcheck_shadow_set(void *shadow, unsigned int size);
 
 #endif

