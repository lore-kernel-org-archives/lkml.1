Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbXIVUEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbXIVUEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXIVUEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:04:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:52812 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXIVUEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=HWD33cy0GdGqakQtPZjdzId5XNTj8FlHZgQwCFTlMPOK8wDknyVqNZoJ9RR0z2mlGxbEr7BppsPg+MLvgxw6tvfMiAyqyoYub5DvTscB3POVXvwlvcSYkRGS0fcDRY52oiyrFIyo2A9AaO33+4Pp6btyW27WGD4i6uN5f1veKNY=
Date: Sun, 23 Sep 2007 00:03:49 +0400
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Uninline kcalloc()
Message-ID: <20070922200349.GA2119@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This saves some bytes on usual config here and allows inserting integer
overflow warning without pissing off printk-haters crowd later on.

   text    data     bss     dec     hex filename
2662791  195347  159744 3017882  2e0c9a vmlinux		-O2 before
2662535  195347  159744 3017626  2e0b9a vmlinux		-O2 after
-------------------------------
			   -256

2439726  195347  159744 2794817  2aa541 vmlinux		-Os before
2439598  195347  159744 2794689  2aa4c1 vmlinux		-Os after
-------------------------------
			   -128

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/slab.h |   58 ----------------------------------------
 mm/util.c            |   59 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 57 deletions(-)

--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -120,63 +120,7 @@ size_t ksize(const void *);
 #include <linux/slab_def.h>
 #endif
 
-/**
- * kcalloc - allocate memory for an array. The memory is set to zero.
- * @n: number of elements.
- * @size: element size.
- * @flags: the type of memory to allocate.
- *
- * The @flags argument may be one of:
- *
- * %GFP_USER - Allocate memory on behalf of user.  May sleep.
- *
- * %GFP_KERNEL - Allocate normal kernel ram.  May sleep.
- *
- * %GFP_ATOMIC - Allocation will not sleep.  May use emergency pools.
- *   For example, use this inside interrupt handlers.
- *
- * %GFP_HIGHUSER - Allocate pages from high memory.
- *
- * %GFP_NOIO - Do not do any I/O at all while trying to get memory.
- *
- * %GFP_NOFS - Do not make any fs calls while trying to get memory.
- *
- * %GFP_NOWAIT - Allocation will not sleep.
- *
- * %GFP_THISNODE - Allocate node-local memory only.
- *
- * %GFP_DMA - Allocation suitable for DMA.
- *   Should only be used for kmalloc() caches. Otherwise, use a
- *   slab created with SLAB_DMA.
- *
- * Also it is possible to set different flags by OR'ing
- * in one or more of the following additional @flags:
- *
- * %__GFP_COLD - Request cache-cold pages instead of
- *   trying to return cache-warm pages.
- *
- * %__GFP_HIGH - This allocation has high priority and may use emergency pools.
- *
- * %__GFP_NOFAIL - Indicate that this allocation is in no way allowed to fail
- *   (think twice before using).
- *
- * %__GFP_NORETRY - If memory is not immediately available,
- *   then give up at once.
- *
- * %__GFP_NOWARN - If allocation fails, don't issue any warnings.
- *
- * %__GFP_REPEAT - If allocation fails initially, try once more before failing.
- *
- * There are other flags available as well, but these are not intended
- * for general use, and so are not documented here. For a full list of
- * potential flags, always refer to linux/gfp.h.
- */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
-{
-	if (n != 0 && size > ULONG_MAX / n)
-		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
-}
+void *kcalloc(size_t n, size_t size, gfp_t flags);
 
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
 /**
--- a/mm/util.c
+++ b/mm/util.c
@@ -5,6 +5,65 @@
 #include <asm/uaccess.h>
 
 /**
+ * kcalloc - allocate memory for an array. The memory is set to zero.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate.
+ *
+ * The @flags argument may be one of:
+ *
+ * %GFP_USER - Allocate memory on behalf of user.  May sleep.
+ *
+ * %GFP_KERNEL - Allocate normal kernel ram.  May sleep.
+ *
+ * %GFP_ATOMIC - Allocation will not sleep.  May use emergency pools.
+ *   For example, use this inside interrupt handlers.
+ *
+ * %GFP_HIGHUSER - Allocate pages from high memory.
+ *
+ * %GFP_NOIO - Do not do any I/O at all while trying to get memory.
+ *
+ * %GFP_NOFS - Do not make any fs calls while trying to get memory.
+ *
+ * %GFP_NOWAIT - Allocation will not sleep.
+ *
+ * %GFP_THISNODE - Allocate node-local memory only.
+ *
+ * %GFP_DMA - Allocation suitable for DMA.
+ *   Should only be used for kmalloc() caches. Otherwise, use a
+ *   slab created with SLAB_DMA.
+ *
+ * Also it is possible to set different flags by OR'ing
+ * in one or more of the following additional @flags:
+ *
+ * %__GFP_COLD - Request cache-cold pages instead of
+ *   trying to return cache-warm pages.
+ *
+ * %__GFP_HIGH - This allocation has high priority and may use emergency pools.
+ *
+ * %__GFP_NOFAIL - Indicate that this allocation is in no way allowed to fail
+ *   (think twice before using).
+ *
+ * %__GFP_NORETRY - If memory is not immediately available,
+ *   then give up at once.
+ *
+ * %__GFP_NOWARN - If allocation fails, don't issue any warnings.
+ *
+ * %__GFP_REPEAT - If allocation fails initially, try once more before failing.
+ *
+ * There are other flags available as well, but these are not intended
+ * for general use, and so are not documented here. For a full list of
+ * potential flags, always refer to linux/gfp.h.
+ */
+void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	if (n != 0 && size > ULONG_MAX / n)
+		return NULL;
+	return __kmalloc(n * size, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(kcalloc);
+
+/**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
  * @gfp: the GFP mask used in the kmalloc() call when allocating memory
