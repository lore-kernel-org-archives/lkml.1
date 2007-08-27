Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXH0Vua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXH0Vua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXH0Vg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:36:28 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4056 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943AbXH0Vg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:36:26 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: airlied@linux.ie
Subject: Re: [PATCH 01/23] introduce drm_zalloc as a drm_alloc + memset replacement
Date: Mon, 27 Aug 2007 23:36:18 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20070827205750.514001000@tuxland.pl> <20070827211341.994873000@tuxland.pl>
In-Reply-To: <20070827211341.994873000@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708272336.19389.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Add drm_zalloc().

Ugh. Too fast. Ofcourse this is the correct version. Sorry.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- linux-2.6.23-rc3-mm1-a/drivers/char/drm/drmP.h	2007-08-27 18:32:26.000000000 +0200
+++ linux-2.6.23-rc3-mm1-b/drivers/char/drm/drmP.h	2007-08-26 15:34:40.000000000 +0200
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
--- linux-2.6.23-rc3-mm1-a/drivers/char/drm/drm_memory_debug.h	2007-08-27 18:32:26.000000000 +0200
+++ linux-2.6.23-rc3-mm1-b/drivers/char/drm/drm_memory_debug.h	2007-08-27 23:28:31.000000000 +0200
@@ -167,13 +167,24 @@ void *drm_alloc (size_t size, int area)
 void *drm_calloc (size_t nmemb, size_t size, int area) {
 	void *addr;

-	addr = drm_alloc (nmemb * size, area);
-	if (addr != NULL)
-		memset((void *)addr, 0, size * nmemb);
+	addr = drm_alloc(nmemb * size, area);
+	if (addr)
+		memset(addr, 0, size * nmemb);

 	return addr;
 }

+void *drm_zalloc(size_t size, int area)
+{
+	void *addr;
+
+	addr = drm_alloc(size, area);
+	if (addr)
+		memset(addr, 0, size);
+
+	return addr;
+}
+
 void *drm_realloc (void *oldpt, size_t oldsize, size_t size, int area) {
 	void *pt;

