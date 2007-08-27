Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbXH0VOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbXH0VOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXH0VNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:46 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1132 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXH0VNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:45 -0400
Message-Id: <20070827211341.994873000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:51 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 01/23] introduce drm_zalloc as a drm_alloc + memset replacement
Content-Disposition: inline; filename=add-drm_zalloc.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add drm_zalloc().

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drmP.h             |    7 +++++++
 drivers/char/drm/drm_memory_debug.h |   17 ++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drmP.h
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drmP.h
@@ -1125,10 +1125,17 @@ static __inline__ void *drm_calloc(size_
 {
 	return kcalloc(nmemb, size, GFP_KERNEL);
 }
+
+/** Wrapper around kzalloc() */
+static __inline__ void *drm_zalloc(size_t size, int area)
+{
+	return kzalloc(size, GFP_KERNEL);
+}
 #else
 extern void *drm_alloc(size_t size, int area);
 extern void drm_free(void *pt, size_t size, int area);
 extern void *drm_calloc(size_t nmemb, size_t size, int area);
+extern void *drm_zalloc(size_t size, int area);
 #endif
 
 /*@}*/
--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_memory_debug.h
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_memory_debug.h
@@ -167,13 +167,24 @@ void *drm_alloc (size_t size, int area) 
 void *drm_calloc (size_t nmemb, size_t size, int area) {
 	void *addr;
 
-	addr = drm_alloc (nmemb * size, area);
-	if (addr != NULL)
-		memset((void *)addr, 0, size * nmemb);
+	addr = drm_alloc(nmemb * size, area);
+	if (!addr)
+		memset(addr, 0, size * nmemb);
 
 	return addr;
 }
 
+void *drm_zalloc(size_t size, int area)
+{
+	void *addr;
+
+	addr = drm_alloc(size, area);
+	if (!addr)
+		memset(addr, 0, size);
+	
+	return addr;
+}
+
 void *drm_realloc (void *oldpt, size_t oldsize, size_t size, int area) {
 	void *pt;
 

--
