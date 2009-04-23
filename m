Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZDWHcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZDWHcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZDWH1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:32 -0400
Received: from sous-sol.org ([216.99.217.87]:48208 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754325AbZDWH1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:31 -0400
Message-Id: <20090423072303.222208746@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 020/100] drm: Use pgprot_writecombine in GEM GTT mapping to get the right bits for !PAT.
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-use-pgprot_writecombine-in-gem-gtt-mapping-to-get-the-right-bits-for-pat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

upstream commit: 1055f9ddad093f54dfd708a0f976582034d4ce1a

Otherwise, the PAGE_CACHE_WC would end up getting us a UC-only mapping, and
the write performance of GTT maps dropped 10x.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
[anholt: cleaned up unused var]
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/drm_gem.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -505,7 +505,6 @@ int drm_gem_mmap(struct file *filp, stru
 	struct drm_map *map = NULL;
 	struct drm_gem_object *obj;
 	struct drm_hash_item *hash;
-	unsigned long prot;
 	int ret = 0;
 
 	mutex_lock(&dev->struct_mutex);
@@ -538,11 +537,7 @@ int drm_gem_mmap(struct file *filp, stru
 	vma->vm_ops = obj->dev->driver->gem_vm_ops;
 	vma->vm_private_data = map->handle;
 	/* FIXME: use pgprot_writecombine when available */
-	prot = pgprot_val(vma->vm_page_prot);
-#ifdef CONFIG_X86
-	prot |= _PAGE_CACHE_WC;
-#endif
-	vma->vm_page_prot = __pgprot(prot);
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
 	/* Take a ref for this mapping of the object, so that the fault
 	 * handler can dereference the mmap offset's pointer to the object.

