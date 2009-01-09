Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZAISD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZAISD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZAISDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:03:46 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55696 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZAISDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:03:45 -0500
Subject: Re: [git pull] drm
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1231513655.5317.30.camel@dax.rpnet.com>
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	 <1231513655.5317.30.camel@dax.rpnet.com>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 18:03:52 +0000
Message-Id: <1231524232.5317.43.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-01-09 at 15:07 +0000, Richard Purdie wrote:
> I just updated to the latest kernel from git to test some other patches
> and after logging into GDM the X server hangs before launching the
> desktop (it appears to be trying to run glxinfo) on my Thinkpad T61
> (i915 graphics). Bisection shows this happens after applying this
> commit:
> 
> On Mon, 2008-12-29 at 08:32 +0000, Dave Airlie wrote:
> > commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
> > Author: Dave Airlie <airlied@redhat.com>
> > Date:   Fri Nov 28 14:22:24 2008 +1000

Just to further follow up, the following fragment of the above commit is
the bit that causes the problem. With this applied, X locks up but I've
run out of time today to look into it further.

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 0a83573..f7f064b 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -44,10 +44,8 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
 
 static int drm_setup(struct drm_device * dev)
 {
-	drm_local_map_t *map;
 	int i;
 	int ret;
-	u32 sareapage;
 
 	if (dev->driver->firstopen) {
 		ret = dev->driver->firstopen(dev);
@@ -55,12 +53,6 @@ static int drm_setup(struct drm_device * dev)
 			return ret;
 	}
 
-	/* prebuild the SAREA */
-	sareapage = max_t(unsigned, SAREA_MAX, PAGE_SIZE);
-	i = drm_addmap(dev, 0, sareapage, _DRM_SHM, _DRM_CONTAINS_LOCK, &map);
-	if (i != 0)
-		return i;
-
 	atomic_set(&dev->ioctl_count, 0);
 	atomic_set(&dev->vma_count, 0);
 	dev->buf_use = 0;
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index afa8a12..dacdf3c 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -39,6 +39,7 @@
 int i915_wait_ring(struct drm_device * dev, int n, const char *caller)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 	drm_i915_ring_buffer_t *ring = &(dev_priv->ring);
 	u32 acthd_reg = IS_I965G(dev) ? ACTHD_I965 : ACTHD;
 	u32 last_acthd = I915_READ(acthd_reg);
@@ -55,8 +56,8 @@ int i915_wait_ring(struct drm_device * dev, int n, const char *caller)
 		if (ring->space >= n)
 			return 0;
 
-		if (dev_priv->sarea_priv)
-			dev_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
+		if (master_priv->sarea_priv)
+			master_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
 
 		if (ring->head != last_head)
 			i = 0;
@@ -121,6 +122,7 @@ static void i915_free_hws(struct drm_device *dev)
 void i915_kernel_lost_context(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_i915_master_private *master_priv;
 	drm_i915_ring_buffer_t *ring = &(dev_priv->ring);
 
 	ring->head = I915_READ(PRB0_HEAD) & HEAD_ADDR;
@@ -129,8 +131,12 @@ void i915_kernel_lost_context(struct drm_device * dev)
 	if (ring->space < 0)
 		ring->space += ring->Size;
 
-	if (ring->head == ring->tail && dev_priv->sarea_priv)
-		dev_priv->sarea_priv->perf_boxes |= I915_BOX_RING_EMPTY;
+	if (!dev->primary->master)
+		return;
+
+	master_priv = dev->primary->master->driver_priv;
+	if (ring->head == ring->tail && master_priv->sarea_priv)
+		master_priv->sarea_priv->perf_boxes |= I915_BOX_RING_EMPTY;
 }
 
 static int i915_dma_cleanup(struct drm_device * dev)
@@ -154,25 +160,13 @@ static int i915_dma_cleanup(struct drm_device * dev)
 	if (I915_NEED_GFX_HWS(dev))
 		i915_free_hws(dev);
 
-	dev_priv->sarea = NULL;
-	dev_priv->sarea_priv = NULL;
-
 	return 0;
 }
 
 static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-
-	dev_priv->sarea = drm_getsarea(dev);
-	if (!dev_priv->sarea) {
-		DRM_ERROR("can not find sarea!\n");
-		i915_dma_cleanup(dev);
-		return -EINVAL;
-	}
-
-	dev_priv->sarea_priv = (drm_i915_sarea_t *)
-	    ((u8 *) dev_priv->sarea->handle + init->sarea_priv_offset);
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 
 	if (init->ring_size != 0) {
 		if (dev_priv->ring.ring_obj != NULL) {
@@ -207,7 +201,8 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 	dev_priv->back_offset = init->back_offset;
 	dev_priv->front_offset = init->front_offset;
 	dev_priv->current_page = 0;
-	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
+	if (master_priv->sarea_priv)
+		master_priv->sarea_priv->pf_current_page = 0;
 
 	/* Allow hardware batchbuffers unless told otherwise.
 	 */
@@ -222,11 +217,6 @@ static int i915_dma_resume(struct drm_device * dev)
 
 	DRM_DEBUG("%s\n", __func__);
 
-	if (!dev_priv->sarea) {
-		DRM_ERROR("can not find sarea!\n");
-		return -EINVAL;
-	}
-
 	if (dev_priv->ring.map.handle == NULL) {
 		DRM_ERROR("can not ioremap virtual address for"
 			  " ring buffer\n");
@@ -435,13 +425,14 @@ i915_emit_box(struct drm_device *dev,
 static void i915_emit_breadcrumb(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 	RING_LOCALS;
 
 	dev_priv->counter++;
 	if (dev_priv->counter > 0x7FFFFFFFUL)
 		dev_priv->counter = 0;
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_enqueue = dev_priv->counter;
+	if (master_priv->sarea_priv)
+		master_priv->sarea_priv->last_enqueue = dev_priv->counter;
 
 	BEGIN_LP_RING(4);
 	OUT_RING(MI_STORE_DWORD_INDEX);
@@ -537,15 +528,17 @@ static int i915_dispatch_batchbuffer(struct drm_device * dev,
 static int i915_dispatch_flip(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_i915_master_private *master_priv =
+		dev->primary->master->driver_priv;
 	RING_LOCALS;
 
-	if (!dev_priv->sarea_priv)
+	if (!master_priv->sarea_priv)
 		return -EINVAL;
 
 	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
 		  __func__,
 		  dev_priv->current_page,
-		  dev_priv->sarea_priv->pf_current_page);
+		  master_priv->sarea_priv->pf_current_page);
 
 	i915_kernel_lost_context(dev);
 
@@ -572,7 +565,7 @@ static int i915_dispatch_flip(struct drm_device * dev)
 	OUT_RING(0);
 	ADVANCE_LP_RING();
 
-	dev_priv->sarea_priv->last_enqueue = dev_priv->counter++;
+	master_priv->sarea_priv->last_enqueue = dev_priv->counter++;
 
 	BEGIN_LP_RING(4);
 	OUT_RING(MI_STORE_DWORD_INDEX);
@@ -581,7 +574,7 @@ static int i915_dispatch_flip(struct drm_device * dev)
 	OUT_RING(0);
 	ADVANCE_LP_RING();
 
-	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
+	master_priv->sarea_priv->pf_current_page = dev_priv->current_page;
 	return 0;
 }
 
@@ -611,8 +604,9 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 	drm_i915_sarea_t *sarea_priv = (drm_i915_sarea_t *)
-	    dev_priv->sarea_priv;
+	    master_priv->sarea_priv;
 	drm_i915_batchbuffer_t *batch = data;
 	int ret;
 
@@ -644,8 +638,9 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 			  struct drm_file *file_priv)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 	drm_i915_sarea_t *sarea_priv = (drm_i915_sarea_t *)
-	    dev_priv->sarea_priv;
+	    master_priv->sarea_priv;
 	drm_i915_cmdbuffer_t *cmdbuf = data;
 	int ret;
 
@@ -802,6 +797,30 @@ static int i915_set_status_page(struct drm_device *dev, void *data,
 	return 0;
 }
 
+int i915_master_create(struct drm_device *dev, struct drm_master *master)
+{
+	struct drm_i915_master_private *master_priv;
+
+	master_priv = drm_calloc(1, sizeof(*master_priv), DRM_MEM_DRIVER);
+	if (!master_priv)
+		return -ENOMEM;
+
+	master->driver_priv = master_priv;
+	return 0;
+}
+
+void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
+{
+	struct drm_i915_master_private *master_priv = master->driver_priv;
+
+	if (!master_priv)
+		return;
+
+	drm_free(master_priv, sizeof(*master_priv), DRM_MEM_DRIVER);
+
+	master->driver_priv = NULL;
+}
+
 int i915_driver_load(struct drm_device *dev, unsigned long flags)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index a80ead2..c916483 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -107,6 +107,8 @@ static struct drm_driver driver = {
 	.reclaim_buffers = drm_core_reclaim_buffers,
 	.get_map_ofs = drm_core_get_map_ofs,
 	.get_reg_ofs = drm_core_get_reg_ofs,
+	.master_create = i915_master_create,
+	.master_destroy = i915_master_destroy,
 	.proc_init = i915_gem_proc_init,
 	.proc_cleanup = i915_gem_proc_cleanup,
 	.gem_init_object = i915_gem_init_object,
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 6d8ef2f..ba096f9 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -103,15 +103,18 @@ struct intel_opregion {
 	int enabled;
 };
 
+struct drm_i915_master_private {
+	drm_local_map_t *sarea;
+	struct _drm_i915_sarea *sarea_priv;
+};
+
 typedef struct drm_i915_private {
 	struct drm_device *dev;
 
 	int has_gem;
 
 	void __iomem *regs;
-	drm_local_map_t *sarea;
 
-	drm_i915_sarea_t *sarea_priv;
 	drm_i915_ring_buffer_t ring;
 
 	drm_dma_handle_t *status_page_dmah;
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 69b9a42..9b673d2 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -168,6 +168,7 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 {
 	struct drm_device *dev = (struct drm_device *) arg;
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	struct drm_i915_master_private *master_priv;
 	u32 iir, new_iir;
 	u32 pipea_stats, pipeb_stats;
 	u32 vblank_status;
@@ -222,9 +223,12 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 		I915_WRITE(IIR, iir);
 		new_iir = I915_READ(IIR); /* Flush posted writes */
 
-		if (dev_priv->sarea_priv)
-			dev_priv->sarea_priv->last_dispatch =
-				READ_BREADCRUMB(dev_priv);
+		if (dev->primary->master) {
+			master_priv = dev->primary->master->driver_priv;
+			if (master_priv->sarea_priv)
+				master_priv->sarea_priv->last_dispatch =
+					READ_BREADCRUMB(dev_priv);
+		}
 
 		if (iir & I915_USER_INTERRUPT) {
 			dev_priv->mm.irq_gem_seqno = i915_get_gem_seqno(dev);
@@ -269,6 +273,7 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 static int i915_emit_irq(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 	RING_LOCALS;
 
 	i915_kernel_lost_context(dev);
@@ -278,8 +283,8 @@ static int i915_emit_irq(struct drm_device * dev)
 	dev_priv->counter++;
 	if (dev_priv->counter > 0x7FFFFFFFUL)
 		dev_priv->counter = 1;
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_enqueue = dev_priv->counter;
+	if (master_priv->sarea_priv)
+		master_priv->sarea_priv->last_enqueue = dev_priv->counter;
 
 	BEGIN_LP_RING(4);
 	OUT_RING(MI_STORE_DWORD_INDEX);
@@ -317,21 +322,20 @@ void i915_user_irq_put(struct drm_device *dev)
 static int i915_wait_irq(struct drm_device * dev, int irq_nr)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 	int ret = 0;
 
 	DRM_DEBUG("irq_nr=%d breadcrumb=%d\n", irq_nr,
 		  READ_BREADCRUMB(dev_priv));
 
 	if (READ_BREADCRUMB(dev_priv) >= irq_nr) {
-		if (dev_priv->sarea_priv) {
-			dev_priv->sarea_priv->last_dispatch =
-				READ_BREADCRUMB(dev_priv);
-		}
+		if (master_priv->sarea_priv)
+			master_priv->sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
 		return 0;
 	}
 
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
+	if (master_priv->sarea_priv)
+		master_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
 
 	i915_user_irq_get(dev);
 	DRM_WAIT_ON(ret, dev_priv->irq_queue, 3 * DRM_HZ,
@@ -343,10 +347,6 @@ static int i915_wait_irq(struct drm_device * dev, int irq_nr)
 			  READ_BREADCRUMB(dev_priv), (int)dev_priv->counter);
 	}
 
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_dispatch =
-			READ_BREADCRUMB(dev_priv);
-
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_mem.c b/drivers/gpu/drm/i915/i915_mem.c
index 6126a60..96e2719 100644
--- a/drivers/gpu/drm/i915/i915_mem.c
+++ b/drivers/gpu/drm/i915/i915_mem.c
@@ -46,7 +46,8 @@
 static void mark_block(struct drm_device * dev, struct mem_block *p, int in_use)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	drm_i915_sarea_t *sarea_priv = dev_priv->sarea_priv;
+	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
+	drm_i915_sarea_t *sarea_priv = master_priv->sarea_priv;
 	struct drm_tex_region *list;
 	unsigned shift, nr;
 	unsigned start;

-- 
Richard Purdie
Intel Open Source Technology Centre

