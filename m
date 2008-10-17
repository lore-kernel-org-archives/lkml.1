Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYJQWnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYJQWnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYJQWnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:43:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbYJQWnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:43:45 -0400
Date: Fri, 17 Oct 2008 15:43:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm patches for 2.6.27-rc1
In-Reply-To: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, Dave Airlie wrote:
> 
> Please pull the 'drm-next' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

Grr.

This whole merge series has been full of people sending me UNTESTED CRAP.

So what's the excuse _this_ time for adding all these stupid warnings to 
my build log? Did nobody test this?

  drivers/gpu/drm/drm_proc.c: In function ¡drm_gem_one_name_info¢:
  drivers/gpu/drm/drm_proc.c:525: warning: format ¡%d¢ expects type ¡int¢, but argument 3 has type ¡size_t¢
  drivers/gpu/drm/drm_proc.c:533: warning: format ¡%9d¢ expects type ¡int¢, but argument 4 has type ¡size_t¢
  drivers/gpu/drm/i915/i915_gem.c: In function ¡i915_gem_gtt_pwrite¢:
  drivers/gpu/drm/i915/i915_gem.c:184: warning: unused variable ¡vaddr_atomic¢

and I wonder how many other warnings got added that I never even noticed 
because I don't build them?

And yes, it's not just warnings. One of thse is horribly bad code:

	nid->len += sprintf(&nid->buf[nid->len],
                            "%6d%9d%8d%9d\n",
                            obj->name, obj->size,
                            atomic_read(&obj->handlecount.refcount),
                            atomic_read(&obj->refcount.refcount));

where it's just wrong to use the field width as a separator. Because if 
the counts are big enough, the separator suddenly goes away!

So that format string should be

	"%6d %8zd %7d %8d\n"

instead. Which  gives the same output when you don't overflow, and doesn't 
have the overflow bug when you do.

As to that "vaddr_atomic" thing, the warning would have been avoided if 
you had just cleanly split up the optimistic fast case.

IOW, write cleaner code, and the warning just goes away on its own. 
Something like the appended. UNTESTED!

Hmm?

I really wish people were more careful, and took more pride in trying to 
write readable code, with small modular functions instead. And move those 
variables down to the block they are needed in.

Anyway, I pulled the thing, but _please_ test this cleanup and send it 
back to me if it passes your testing. Ok? 

			Linus

---
 drivers/gpu/drm/drm_proc.c      |    4 +-
 drivers/gpu/drm/i915/i915_gem.c |   59 +++++++++++++++++++++++---------------
 2 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index d490db4..ae73b7f 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -522,12 +522,12 @@ static int drm_gem_one_name_info(int id, void *ptr, void *data)
 	struct drm_gem_object *obj = ptr;
 	struct drm_gem_name_info_data   *nid = data;
 
-	DRM_INFO("name %d size %d\n", obj->name, obj->size);
+	DRM_INFO("name %d size %zd\n", obj->name, obj->size);
 	if (nid->eof)
 		return 0;
 
 	nid->len += sprintf(&nid->buf[nid->len],
-			    "%6d%9d%8d%9d\n",
+			    "%6d %8zd %7d %8d\n",
 			    obj->name, obj->size,
 			    atomic_read(&obj->handlecount.refcount),
 			    atomic_read(&obj->refcount.refcount));
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 9ac73dd..b8c8b2e 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -171,6 +171,36 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
+/*
+ * Try to write quickly with an atomic kmap. Return true on success.
+ *
+ * If this fails (which includes a partial write), we'll redo the whole
+ * thing with the slow version.
+ *
+ * This is a workaround for the low performance of iounmap (approximate
+ * 10% cpu cost on normal 3D workloads).  kmap_atomic on HIGHMEM kernels
+ * happens to let us map card memory without taking IPIs.  When the vmap
+ * rework lands we should be able to dump this hack.
+ */
+static inline int fast_user_write(unsigned long pfn, char __user *user_data, int l)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long unwritten;
+	char *vaddr_atomic;
+
+	vaddr_atomic = kmap_atomic_pfn(pfn, KM_USER0);
+#if WATCH_PWRITE
+	DRM_INFO("pwrite i %d o %d l %d pfn %ld vaddr %p\n",
+		 i, o, l, pfn, vaddr_atomic);
+#endif
+	unwritten = __copy_from_user_inatomic_nocache(vaddr_atomic + o, user_data, l);
+	kunmap_atomic(vaddr_atomic, KM_USER0);
+	return !unwritten;
+#else
+	return 1;
+#endif
+}
+
 static int
 i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 		    struct drm_i915_gem_pwrite *args,
@@ -180,12 +210,7 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 	ssize_t remain;
 	loff_t offset;
 	char __user *user_data;
-	char __iomem *vaddr;
-	char *vaddr_atomic;
-	int i, o, l;
 	int ret = 0;
-	unsigned long pfn;
-	unsigned long unwritten;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
@@ -209,6 +234,9 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 	obj_priv->dirty = 1;
 
 	while (remain > 0) {
+		unsigned long pfn;
+		int i, o, l;
+
 		/* Operation in this page
 		 *
 		 * i = page number
@@ -223,25 +251,10 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 
 		pfn = (dev->agp->base >> PAGE_SHIFT) + i;
 
-#ifdef CONFIG_HIGHMEM
-		/* This is a workaround for the low performance of iounmap
-		 * (approximate 10% cpu cost on normal 3D workloads).
-		 * kmap_atomic on HIGHMEM kernels happens to let us map card
-		 * memory without taking IPIs.  When the vmap rework lands
-		 * we should be able to dump this hack.
-		 */
-		vaddr_atomic = kmap_atomic_pfn(pfn, KM_USER0);
-#if WATCH_PWRITE
-		DRM_INFO("pwrite i %d o %d l %d pfn %ld vaddr %p\n",
-			 i, o, l, pfn, vaddr_atomic);
-#endif
-		unwritten = __copy_from_user_inatomic_nocache(vaddr_atomic + o,
-							      user_data, l);
-		kunmap_atomic(vaddr_atomic, KM_USER0);
+		if (!fast_user_write(pfn, user_data, l)) {
+			unsigned long unwritten;
+			char __iomem *vaddr;
 
-		if (unwritten)
-#endif /* CONFIG_HIGHMEM */
-		{
 			vaddr = ioremap_wc(pfn << PAGE_SHIFT, PAGE_SIZE);
 #if WATCH_PWRITE
 			DRM_INFO("pwrite slow i %d o %d l %d "
