Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbZJ1HxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbZJ1HxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbZJ1HxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:53:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34666
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932562AbZJ1HxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:53:19 -0400
Date: Wed, 28 Oct 2009 00:53:42 -0700 (PDT)
Message-Id: <20091028.005342.60092591.davem@davemloft.net>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091027.230450.222178419.davem@davemloft.net>
References: <20091027.222814.137568780.davem@davemloft.net>
	<alpine.DEB.2.00.0910280539150.19088@skynet.skynet.ie>
	<20091027.230450.222178419.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 27 Oct 2009 23:04:50 -0700 (PDT)

> From: Dave Airlie <airlied@linux.ie>
> Date: Wed, 28 Oct 2009 05:42:27 +0000 (GMT)
> 
>> I'll add this to my TODO for before the next merge window as its
>> definitely more than I can manage now.
> 
> I'll do it.

Ok, everything was straightforward except for radeon_cs, which
has three levels of indirection for the tables of data and
relocation chunks userland can pass into the DRM :-/

There is no way to isolate the compat handling without parsing
and bringing the pointer array and the chunk headers into the
kernel twice.

So I guess I'm willing to capitulate with is_compat_task() checks in
radeon_cs_init(), but if you want to improve this interface I see two
ways:

1) Eliminate one level of indirection so there is just a straight
   scatter-gather list at one level.

2) Use a base pointer and a set of offsets to communicate at least
   one level of indirection.

Both schemes should satisfy the buffering flexibility these
interfaces seem to be geared towards giving to userland.

Anyways the following patch is tested and seems to work well.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 5ab2cf9..ba44eba 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -24,6 +24,8 @@
  * Authors:
  *    Jerome Glisse <glisse@freedesktop.org>
  */
+#include <linux/compat.h>
+
 #include "drmP.h"
 #include "radeon_drm.h"
 #include "radeon_reg.h"
@@ -107,7 +109,12 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 	if (p->chunks_array == NULL) {
 		return -ENOMEM;
 	}
-	chunk_array_ptr = (uint64_t *)(unsigned long)(cs->chunks);
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		chunk_array_ptr = compat_ptr((compat_uptr_t) cs->chunks);
+	else
+#endif
+		chunk_array_ptr = (uint64_t *)(unsigned long)(cs->chunks);
 	if (DRM_COPY_FROM_USER(p->chunks_array, chunk_array_ptr,
 			       sizeof(uint64_t)*cs->num_chunks)) {
 		return -EFAULT;
@@ -120,9 +127,15 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 	for (i = 0; i < p->nchunks; i++) {
 		struct drm_radeon_cs_chunk __user **chunk_ptr = NULL;
 		struct drm_radeon_cs_chunk user_chunk;
-		uint32_t __user *cdata;
 
-		chunk_ptr = (void __user*)(unsigned long)p->chunks_array[i];
+#ifdef CONFIG_COMPAT
+		if (is_compat_task())
+			chunk_ptr = compat_ptr((compat_uptr_t)
+					       p->chunks_array[i]);
+		else
+#endif
+			chunk_ptr = (void __user*) (unsigned long)
+				p->chunks_array[i];
 		if (DRM_COPY_FROM_USER(&user_chunk, chunk_ptr,
 				       sizeof(struct drm_radeon_cs_chunk))) {
 			return -EFAULT;
@@ -142,9 +155,16 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 		}
 
 		p->chunks[i].length_dw = user_chunk.length_dw;
-		p->chunks[i].user_ptr = (void __user *)(unsigned long)user_chunk.chunk_data;
+#ifdef CONFIG_COMPAT
+		if (is_compat_task())
+			p->chunks[i].user_ptr =
+				compat_ptr((compat_uptr_t)
+					   user_chunk.chunk_data);
+		else
+#endif
+			p->chunks[i].user_ptr = (void __user *) (unsigned long)
+				user_chunk.chunk_data;
 
-		cdata = (uint32_t *)(unsigned long)user_chunk.chunk_data;
 		if (p->chunks[i].chunk_id != RADEON_CHUNK_ID_IB) {
 			size = p->chunks[i].length_dw * sizeof(uint32_t);
 			p->chunks[i].kdata = kmalloc(size, GFP_KERNEL);
diff --git a/drivers/gpu/drm/radeon/radeon_ioc32.c b/drivers/gpu/drm/radeon/radeon_ioc32.c
index a1bf11d..3c4dfa2 100644
--- a/drivers/gpu/drm/radeon/radeon_ioc32.c
+++ b/drivers/gpu/drm/radeon/radeon_ioc32.c
@@ -156,7 +156,7 @@ static int compat_radeon_cp_stipple(struct file *file, unsigned int cmd,
 typedef struct drm_radeon_tex_image32 {
 	unsigned int x, y;	/* Blit coordinates */
 	unsigned int width, height;
-	u32 data;
+	compat_uptr_t data;
 } drm_radeon_tex_image32_t;
 
 typedef struct drm_radeon_texture32 {
@@ -165,7 +165,7 @@ typedef struct drm_radeon_texture32 {
 	int format;
 	int width;		/* Texture image coordinates */
 	int height;
-	u32 image;
+	compat_uptr_t image;
 } drm_radeon_texture32_t;
 
 static int compat_radeon_cp_texture(struct file *file, unsigned int cmd,
@@ -180,8 +180,7 @@ static int compat_radeon_cp_texture(struct file *file, unsigned int cmd,
 		return -EFAULT;
 	if (req32.image == 0)
 		return -EINVAL;
-	if (copy_from_user(&img32, (void __user *)(unsigned long)req32.image,
-			   sizeof(img32)))
+	if (copy_from_user(&img32, compat_ptr(req32.image), sizeof(img32)))
 		return -EFAULT;
 
 	request = compat_alloc_user_space(sizeof(*request) + sizeof(*image));
@@ -200,8 +199,7 @@ static int compat_radeon_cp_texture(struct file *file, unsigned int cmd,
 	    || __put_user(img32.y, &image->y)
 	    || __put_user(img32.width, &image->width)
 	    || __put_user(img32.height, &image->height)
-	    || __put_user((const void __user *)(unsigned long)img32.data,
-			  &image->data))
+	    || __put_user(compat_ptr(img32.data), &image->data))
 		return -EFAULT;
 
 	return drm_ioctl(file->f_path.dentry->d_inode, file,
@@ -212,9 +210,9 @@ typedef struct drm_radeon_vertex2_32 {
 	int idx;		/* Index of vertex buffer */
 	int discard;		/* Client finished with buffer? */
 	int nr_states;
-	u32 state;
+	compat_uptr_t state;
 	int nr_prims;
-	u32 prim;
+	compat_uptr_t prim;
 } drm_radeon_vertex2_32_t;
 
 static int compat_radeon_cp_vertex2(struct file *file, unsigned int cmd,
@@ -231,11 +229,9 @@ static int compat_radeon_cp_vertex2(struct file *file, unsigned int cmd,
 	    || __put_user(req32.idx, &request->idx)
 	    || __put_user(req32.discard, &request->discard)
 	    || __put_user(req32.nr_states, &request->nr_states)
-	    || __put_user((void __user *)(unsigned long)req32.state,
-			  &request->state)
+	    || __put_user(compat_ptr(req32.state), &request->state)
 	    || __put_user(req32.nr_prims, &request->nr_prims)
-	    || __put_user((void __user *)(unsigned long)req32.prim,
-			  &request->prim))
+	    || __put_user(compat_ptr(req32.prim), &request->prim))
 		return -EFAULT;
 
 	return drm_ioctl(file->f_path.dentry->d_inode, file,
@@ -244,9 +240,9 @@ static int compat_radeon_cp_vertex2(struct file *file, unsigned int cmd,
 
 typedef struct drm_radeon_cmd_buffer32 {
 	int bufsz;
-	u32 buf;
+	compat_uptr_t buf;
 	int nbox;
-	u32 boxes;
+	compat_uptr_t boxes;
 } drm_radeon_cmd_buffer32_t;
 
 static int compat_radeon_cp_cmdbuf(struct file *file, unsigned int cmd,
@@ -261,11 +257,9 @@ static int compat_radeon_cp_cmdbuf(struct file *file, unsigned int cmd,
 	request = compat_alloc_user_space(sizeof(*request));
 	if (!access_ok(VERIFY_WRITE, request, sizeof(*request))
 	    || __put_user(req32.bufsz, &request->bufsz)
-	    || __put_user((void __user *)(unsigned long)req32.buf,
-			  &request->buf)
+	    || __put_user(compat_ptr(req32.buf), &request->buf)
 	    || __put_user(req32.nbox, &request->nbox)
-	    || __put_user((void __user *)(unsigned long)req32.boxes,
-			  &request->boxes))
+	    || __put_user(compat_ptr(req32.boxes), &request->boxes))
 		return -EFAULT;
 
 	return drm_ioctl(file->f_path.dentry->d_inode, file,
@@ -274,7 +268,7 @@ static int compat_radeon_cp_cmdbuf(struct file *file, unsigned int cmd,
 
 typedef struct drm_radeon_getparam32 {
 	int param;
-	u32 value;
+	compat_uptr_t value;
 } drm_radeon_getparam32_t;
 
 static int compat_radeon_cp_getparam(struct file *file, unsigned int cmd,
@@ -289,8 +283,7 @@ static int compat_radeon_cp_getparam(struct file *file, unsigned int cmd,
 	request = compat_alloc_user_space(sizeof(*request));
 	if (!access_ok(VERIFY_WRITE, request, sizeof(*request))
 	    || __put_user(req32.param, &request->param)
-	    || __put_user((void __user *)(unsigned long)req32.value,
-			  &request->value))
+	    || __put_user(compat_ptr(req32.value), &request->value))
 		return -EFAULT;
 
 	return drm_ioctl(file->f_path.dentry->d_inode, file,
@@ -301,7 +294,7 @@ typedef struct drm_radeon_mem_alloc32 {
 	int region;
 	int alignment;
 	int size;
-	u32 region_offset;	/* offset from start of fb or GART */
+	compat_uptr_t region_offset;	/* offset from start of fb or GART */
 } drm_radeon_mem_alloc32_t;
 
 static int compat_radeon_mem_alloc(struct file *file, unsigned int cmd,
@@ -318,7 +311,7 @@ static int compat_radeon_mem_alloc(struct file *file, unsigned int cmd,
 	    || __put_user(req32.region, &request->region)
 	    || __put_user(req32.alignment, &request->alignment)
 	    || __put_user(req32.size, &request->size)
-	    || __put_user((int __user *)(unsigned long)req32.region_offset,
+	    || __put_user(compat_ptr(req32.region_offset),
 			  &request->region_offset))
 		return -EFAULT;
 
@@ -327,7 +320,7 @@ static int compat_radeon_mem_alloc(struct file *file, unsigned int cmd,
 }
 
 typedef struct drm_radeon_irq_emit32 {
-	u32 irq_seq;
+	compat_uptr_t irq_seq;
 } drm_radeon_irq_emit32_t;
 
 static int compat_radeon_irq_emit(struct file *file, unsigned int cmd,
@@ -341,43 +334,42 @@ static int compat_radeon_irq_emit(struct file *file, unsigned int cmd,
 
 	request = compat_alloc_user_space(sizeof(*request));
 	if (!access_ok(VERIFY_WRITE, request, sizeof(*request))
-	    || __put_user((int __user *)(unsigned long)req32.irq_seq,
-			  &request->irq_seq))
+	    || __put_user(compat_ptr(req32.irq_seq), &request->irq_seq))
 		return -EFAULT;
 
 	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_IRQ_EMIT, (unsigned long)request);
 }
 
-/* The two 64-bit arches where alignof(u64)==4 in 32-bit code */
 #if defined (CONFIG_X86_64) || defined(CONFIG_IA64)
 typedef struct drm_radeon_setparam32 {
 	int param;
 	u64 value;
 } __attribute__((packed)) drm_radeon_setparam32_t;
+#else
+#define drm_radeon_setparam32_t drm_radeon_setparam_t
+#endif
 
 static int compat_radeon_cp_setparam(struct file *file, unsigned int cmd,
 				     unsigned long arg)
 {
 	drm_radeon_setparam32_t req32;
 	drm_radeon_setparam_t __user *request;
+	compat_uptr_t uptr;
 
 	if (copy_from_user(&req32, (void __user *) arg, sizeof(req32)))
 		return -EFAULT;
 
 	request = compat_alloc_user_space(sizeof(*request));
+	uptr = req32.value;
 	if (!access_ok(VERIFY_WRITE, request, sizeof(*request))
 	    || __put_user(req32.param, &request->param)
-	    || __put_user((void __user *)(unsigned long)req32.value,
-			  &request->value))
+	    || __put_user(compat_ptr(uptr), &request->value))
 		return -EFAULT;
 
 	return drm_ioctl(file->f_dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_SETPARAM, (unsigned long) request);
 }
-#else
-#define compat_radeon_cp_setparam NULL
-#endif /* X86_64 || IA64 */
 
 drm_ioctl_compat_t *radeon_compat_ioctls[] = {
 	[DRM_RADEON_CP_INIT] = compat_radeon_cp_init,
@@ -392,6 +384,95 @@ drm_ioctl_compat_t *radeon_compat_ioctls[] = {
 	[DRM_RADEON_IRQ_EMIT] = compat_radeon_irq_emit,
 };
 
+static int compat_radeon_info_ioctl(struct file *file, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct drm_radeon_info __user *uinfo;
+	struct drm_radeon_info kinfo;
+	compat_uptr_t uaddr;
+	void *uptr;
+
+	if (copy_from_user(&kinfo, (void __user *) arg, sizeof(kinfo)))
+		return -EFAULT;
+
+	uaddr = kinfo.value;
+	uptr = compat_ptr(uaddr);
+	if (kinfo.value == (uint64_t) uptr)
+		return drm_ioctl(file->f_dentry->d_inode, file,
+				 DRM_IOCTL_RADEON_INFO, arg);
+
+	kinfo.value = (uint64_t) uptr;
+
+	uinfo = compat_alloc_user_space(sizeof(*uinfo));
+	if (copy_to_user(uinfo, &kinfo, sizeof(kinfo)))
+		return -EFAULT;
+
+	return drm_ioctl(file->f_dentry->d_inode, file,
+			 DRM_IOCTL_RADEON_INFO, (unsigned long) uinfo);
+}
+
+static int compat_radeon_gem_pread_ioctl(struct file *file, unsigned int cmd,
+					 unsigned long arg)
+{
+	struct drm_radeon_gem_pread __user *upread;
+	struct drm_radeon_gem_pread kpread;
+	compat_uptr_t uaddr;
+	void *uptr;
+
+	if (copy_from_user(&kpread, (void __user *) arg, sizeof(kpread)))
+		return -EFAULT;
+
+	uaddr = kpread.data_ptr;
+	uptr = compat_ptr(uaddr);
+
+	if (kpread.data_ptr == (uint64_t) uptr)
+		return drm_ioctl(file->f_dentry->d_inode, file,
+				 DRM_IOCTL_RADEON_GEM_PREAD, arg);
+
+	kpread.data_ptr = (uint64_t) uptr;
+
+	upread = compat_alloc_user_space(sizeof(*upread));
+	if (copy_to_user(upread, &kpread, sizeof(kpread)))
+		return -EFAULT;
+
+	return drm_ioctl(file->f_dentry->d_inode, file,
+			 DRM_IOCTL_RADEON_GEM_PREAD, (unsigned long) upread);
+}
+
+static int compat_radeon_gem_pwrite_ioctl(struct file *file, unsigned int cmd,
+					  unsigned long arg)
+{
+	struct drm_radeon_gem_pwrite __user *upwrite;
+	struct drm_radeon_gem_pwrite kpwrite;
+	compat_uptr_t uaddr;
+	void *uptr;
+
+	if (copy_from_user(&kpwrite, (void __user *) arg, sizeof(kpwrite)))
+		return -EFAULT;
+
+	uaddr = kpwrite.data_ptr;
+	uptr = compat_ptr(uaddr);
+
+	if (kpwrite.data_ptr == (uint64_t) uptr)
+		return drm_ioctl(file->f_dentry->d_inode, file,
+				 DRM_IOCTL_RADEON_GEM_PWRITE, arg);
+
+	kpwrite.data_ptr = (uint64_t) uptr;
+
+	upwrite = compat_alloc_user_space(sizeof(*upwrite));
+	if (copy_to_user(upwrite, &kpwrite, sizeof(kpwrite)))
+		return -EFAULT;
+
+	return drm_ioctl(file->f_dentry->d_inode, file,
+			 DRM_IOCTL_RADEON_GEM_PREAD, (unsigned long) upwrite);
+}
+
+static drm_ioctl_compat_t *radeon_compat_kms_ioctls[] = {
+	[DRM_RADEON_INFO] = compat_radeon_info_ioctl,
+	[DRM_RADEON_GEM_PREAD] = compat_radeon_gem_pread_ioctl,
+	[DRM_RADEON_GEM_PWRITE] = compat_radeon_gem_pwrite_ioctl,
+};
+
 /**
  * Called whenever a 32-bit process running under a 64-bit kernel
  * performs an ioctl on /dev/dri/card<n>.
@@ -426,13 +507,20 @@ long radeon_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 long radeon_kms_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int nr = DRM_IOCTL_NR(cmd);
+	drm_ioctl_compat_t *fn = NULL;
 	int ret;
 
 	if (nr < DRM_COMMAND_BASE)
 		return drm_compat_ioctl(filp, cmd, arg);
 
+	if (nr < DRM_COMMAND_BASE + DRM_ARRAY_SIZE(radeon_compat_kms_ioctls))
+		fn = radeon_compat_kms_ioctls[nr - DRM_COMMAND_BASE];
+
 	lock_kernel();		/* XXX for now */
-	ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
+	if (fn != NULL)
+		ret = (*fn) (filp, cmd, arg);
+	else
+		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;
