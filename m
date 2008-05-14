Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYENHHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYENHHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYENHGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:06:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYENHGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:06:50 -0400
Date: Wed, 14 May 2008 09:06:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc2 hosed X?
Message-ID: <20080514070631.GB10549@elte.hu>
References: <20080513103828.GA8288@gamma.logic.tuwien.ac.at> <21d7e9970805140000o2191160eida777023909bf033@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970805140000o2191160eida777023909bf033@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@gmail.com> wrote:

> You might try pulling in my git tree which Linus ignored last week I 
> think.. 'drm-patches' branch.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches
> 
> maybe the reverting patch it contains might help..

Here it is below for those who'd like to try that fix as a standalone 
patch.

	Ingo

--------------------->
commit af6061af0d9f84a4665f88186dc1ff9e4fb78330
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed May 7 12:15:39 2008 +1000

    Revert "drm/vbl rework: rework how the drm deals with vblank."
    
    This reverts commit ac741ab71bb39e6977694ac0cc26678d8673cda4.
    
    Okay this looks like wasn't as fully baked as I'd led myself to believe.
    
    Revert for now for further baking.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

diff --git a/drivers/char/drm/drm.h b/drivers/char/drm/drm.h
index 6874f31..3a05c6d 100644
--- a/drivers/char/drm/drm.h
+++ b/drivers/char/drm/drm.h
@@ -471,7 +471,6 @@ struct drm_irq_busid {
 enum drm_vblank_seq_type {
 	_DRM_VBLANK_ABSOLUTE = 0x0,	/**< Wait for specific vblank sequence number */
 	_DRM_VBLANK_RELATIVE = 0x1,	/**< Wait for given number of vblanks */
-	_DRM_VBLANK_FLIP = 0x8000000,	/**< Scheduled buffer swap should flip */
 	_DRM_VBLANK_NEXTONMISS = 0x10000000,	/**< If missed, wait for next vblank */
 	_DRM_VBLANK_SECONDARY = 0x20000000,	/**< Secondary display controller */
 	_DRM_VBLANK_SIGNAL = 0x40000000	/**< Send signal instead of blocking */
@@ -504,21 +503,6 @@ union drm_wait_vblank {
 	struct drm_wait_vblank_reply reply;
 };
 
-enum drm_modeset_ctl_cmd {
-	_DRM_PRE_MODESET = 1,
-	_DRM_POST_MODESET = 2,
-};
-
-/**
- * DRM_IOCTL_MODESET_CTL ioctl argument type
- *
- * \sa drmModesetCtl().
- */
-struct drm_modeset_ctl {
-	unsigned long arg;
-	enum drm_modeset_ctl_cmd cmd;
-};
-
 /**
  * DRM_IOCTL_AGP_ENABLE ioctl argument type.
  *
@@ -603,7 +587,6 @@ struct drm_set_version {
 #define DRM_IOCTL_GET_CLIENT            DRM_IOWR(0x05, struct drm_client)
 #define DRM_IOCTL_GET_STATS             DRM_IOR( 0x06, struct drm_stats)
 #define DRM_IOCTL_SET_VERSION		DRM_IOWR(0x07, struct drm_set_version)
-#define DRM_IOCTL_MODESET_CTL           DRM_IOW(0x08, struct drm_modeset_ctl)
 
 #define DRM_IOCTL_SET_UNIQUE		DRM_IOW( 0x10, struct drm_unique)
 #define DRM_IOCTL_AUTH_MAGIC		DRM_IOW( 0x11, struct drm_auth)
diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 213b3ca..0764b66 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -100,8 +100,10 @@ struct drm_device;
 #define DRIVER_HAVE_DMA    0x20
 #define DRIVER_HAVE_IRQ    0x40
 #define DRIVER_IRQ_SHARED  0x80
+#define DRIVER_IRQ_VBL     0x100
 #define DRIVER_DMA_QUEUE   0x200
 #define DRIVER_FB_DMA      0x400
+#define DRIVER_IRQ_VBL2    0x800
 
 /***********************************************************************/
 /** \name Begin the DRM... */
@@ -577,52 +579,10 @@ struct drm_driver {
 	int (*context_dtor) (struct drm_device *dev, int context);
 	int (*kernel_context_switch) (struct drm_device *dev, int old,
 				      int new);
-	void (*kernel_context_switch_unlock) (struct drm_device * dev);
-	/**
-	 * get_vblank_counter - get raw hardware vblank counter
-	 * @dev: DRM device
-	 * @crtc: counter to fetch
-	 *
-	 * Driver callback for fetching a raw hardware vblank counter
-	 * for @crtc.  If a device doesn't have a hardware counter, the
-	 * driver can simply return the value of drm_vblank_count and
-	 * make the enable_vblank() and disable_vblank() hooks into no-ops,
-	 * leaving interrupts enabled at all times.
-	 *
-	 * Wraparound handling and loss of events due to modesetting is dealt
-	 * with in the DRM core code.
-	 *
-	 * RETURNS
-	 * Raw vblank counter value.
-	 */
-	u32 (*get_vblank_counter) (struct drm_device *dev, int crtc);
-
-	/**
-	 * enable_vblank - enable vblank interrupt events
-	 * @dev: DRM device
-	 * @crtc: which irq to enable
-	 *
-	 * Enable vblank interrupts for @crtc.  If the device doesn't have
-	 * a hardware vblank counter, this routine should be a no-op, since
-	 * interrupts will have to stay on to keep the count accurate.
-	 *
-	 * RETURNS
-	 * Zero on success, appropriate errno if the given @crtc's vblank
-	 * interrupt cannot be enabled.
-	 */
-	int (*enable_vblank) (struct drm_device *dev, int crtc);
-
-	/**
-	 * disable_vblank - disable vblank interrupt events
-	 * @dev: DRM device
-	 * @crtc: which irq to enable
-	 *
-	 * Disable vblank interrupts for @crtc.  If the device doesn't have
-	 * a hardware vblank counter, this routine should be a no-op, since
-	 * interrupts will have to stay on to keep the count accurate.
-	 */
-	void (*disable_vblank) (struct drm_device *dev, int crtc);
-	int (*dri_library_name) (struct drm_device *dev, char * buf);
+	void (*kernel_context_switch_unlock) (struct drm_device *dev);
+	int (*vblank_wait) (struct drm_device *dev, unsigned int *sequence);
+	int (*vblank_wait2) (struct drm_device *dev, unsigned int *sequence);
+	int (*dri_library_name) (struct drm_device *dev, char *buf);
 
 	/**
 	 * Called by \c drm_device_is_agp.  Typically used to determine if a
@@ -641,7 +601,7 @@ struct drm_driver {
 
 	irqreturn_t(*irq_handler) (DRM_IRQ_ARGS);
 	void (*irq_preinstall) (struct drm_device *dev);
-	int (*irq_postinstall) (struct drm_device *dev);
+	void (*irq_postinstall) (struct drm_device *dev);
 	void (*irq_uninstall) (struct drm_device *dev);
 	void (*reclaim_buffers) (struct drm_device *dev,
 				 struct drm_file * file_priv);
@@ -770,21 +730,13 @@ struct drm_device {
 	/** \name VBLANK IRQ support */
 	/*@{ */
 
-	wait_queue_head_t *vbl_queue;	/**< VBLANK wait queue */
-	atomic_t *_vblank_count;	/**< number of VBLANK interrupts (driver must alloc the right number of counters) */
+	wait_queue_head_t vbl_queue;	/**< VBLANK wait queue */
+	atomic_t vbl_received;
+	atomic_t vbl_received2;		/**< number of secondary VBLANK interrupts */
 	spinlock_t vbl_lock;
-	struct list_head *vbl_sigs;		/**< signal list to send on VBLANK */
-	atomic_t vbl_signal_pending;	/* number of signals pending on all crtcs*/
-	atomic_t *vblank_refcount;	/* number of users of vblank interrupts per crtc */
-	u32 *last_vblank;		/* protected by dev->vbl_lock, used */
-					/* for wraparound handling */
-	u32 *vblank_offset;		/* used to track how many vblanks */
-	int *vblank_enabled;		/* so we don't call enable more than
-					   once per disable */
-	u32 *vblank_premodeset;		/*  were lost during modeset */
-	struct timer_list vblank_disable_timer;
-
-	unsigned long max_vblank_count; /**< size of vblank counter register */
+	struct list_head vbl_sigs;		/**< signal list to send on VBLANK */
+	struct list_head vbl_sigs2;	/**< signals to send on secondary VBLANK */
+	unsigned int vbl_pending;
 	spinlock_t tasklet_lock;	/**< For drm_locked_tasklet */
 	void (*locked_tasklet_func)(struct drm_device *dev);
 
@@ -804,7 +756,6 @@ struct drm_device {
 #ifdef __alpha__
 	struct pci_controller *hose;
 #endif
-	int num_crtcs;			/**< Number of CRTCs on this device */
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
 	void *dev_private;		/**< device private data */
 	struct drm_sigdata sigdata;	   /**< For block_all_signals */
@@ -1039,19 +990,11 @@ extern void drm_driver_irq_preinstall(struct drm_device *dev);
 extern void drm_driver_irq_postinstall(struct drm_device *dev);
 extern void drm_driver_irq_uninstall(struct drm_device *dev);
 
-extern int drm_vblank_init(struct drm_device *dev, int num_crtcs);
-extern int drm_wait_vblank(struct drm_device *dev, void *data, struct drm_file *filp);
-extern int drm_vblank_wait(struct drm_device * dev, unsigned int *vbl_seq);
-extern void drm_locked_tasklet(struct drm_device *dev, void(*func)(struct drm_device*));
-extern u32 drm_vblank_count(struct drm_device *dev, int crtc);
-extern void drm_update_vblank_count(struct drm_device *dev, int crtc);
-extern void drm_handle_vblank(struct drm_device *dev, int crtc);
-extern int drm_vblank_get(struct drm_device *dev, int crtc);
-extern void drm_vblank_put(struct drm_device *dev, int crtc);
-
-				/* Modesetting support */
-extern int drm_modeset_ctl(struct drm_device *dev, void *data,
+extern int drm_wait_vblank(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv);
+extern int drm_vblank_wait(struct drm_device *dev, unsigned int *vbl_seq);
+extern void drm_vbl_send_signals(struct drm_device *dev);
+extern void drm_locked_tasklet(struct drm_device *dev, void(*func)(struct drm_device*));
 
 				/* AGP/GART support (drm_agpsupport.h) */
 extern struct drm_agp_head *drm_agp_init(struct drm_device *dev);
diff --git a/drivers/char/drm/drm_irq.c b/drivers/char/drm/drm_irq.c
index 286f9d6..089c015 100644
--- a/drivers/char/drm/drm_irq.c
+++ b/drivers/char/drm/drm_irq.c
@@ -71,117 +71,6 @@ int drm_irq_by_busid(struct drm_device *dev, void *data,
 	return 0;
 }
 
-static void vblank_disable_fn(unsigned long arg)
-{
-	struct drm_device *dev = (struct drm_device *)arg;
-	unsigned long irqflags;
-	int i;
-
-	for (i = 0; i < dev->num_crtcs; i++) {
-		spin_lock_irqsave(&dev->vbl_lock, irqflags);
-		if (atomic_read(&dev->vblank_refcount[i]) == 0 &&
-		    dev->vblank_enabled[i]) {
-			dev->driver->disable_vblank(dev, i);
-			dev->vblank_enabled[i] = 0;
-		}
-		spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
-	}
-}
-
-static void drm_vblank_cleanup(struct drm_device *dev)
-{
-	/* Bail if the driver didn't call drm_vblank_init() */
-	if (dev->num_crtcs == 0)
-		return;
-
-	del_timer(&dev->vblank_disable_timer);
-
-	vblank_disable_fn((unsigned long)dev);
-
-	drm_free(dev->vbl_queue, sizeof(*dev->vbl_queue) * dev->num_crtcs,
-		 DRM_MEM_DRIVER);
-	drm_free(dev->vbl_sigs, sizeof(*dev->vbl_sigs) * dev->num_crtcs,
-		 DRM_MEM_DRIVER);
-	drm_free(dev->_vblank_count, sizeof(*dev->_vblank_count) *
-		 dev->num_crtcs, DRM_MEM_DRIVER);
-	drm_free(dev->vblank_refcount, sizeof(*dev->vblank_refcount) *
-		 dev->num_crtcs, DRM_MEM_DRIVER);
-	drm_free(dev->vblank_enabled, sizeof(*dev->vblank_enabled) *
-		 dev->num_crtcs, DRM_MEM_DRIVER);
-	drm_free(dev->last_vblank, sizeof(*dev->last_vblank) * dev->num_crtcs,
-		 DRM_MEM_DRIVER);
-	drm_free(dev->vblank_premodeset, sizeof(*dev->vblank_premodeset) *
-		 dev->num_crtcs, DRM_MEM_DRIVER);
-	drm_free(dev->vblank_offset, sizeof(*dev->vblank_offset) * dev->num_crtcs,
-		 DRM_MEM_DRIVER);
-
-	dev->num_crtcs = 0;
-}
-
-int drm_vblank_init(struct drm_device *dev, int num_crtcs)
-{
-	int i, ret = -ENOMEM;
-
-	setup_timer(&dev->vblank_disable_timer, vblank_disable_fn,
-		    (unsigned long)dev);
-	spin_lock_init(&dev->vbl_lock);
-	atomic_set(&dev->vbl_signal_pending, 0);
-	dev->num_crtcs = num_crtcs;
-
-	dev->vbl_queue = drm_alloc(sizeof(wait_queue_head_t) * num_crtcs,
-				   DRM_MEM_DRIVER);
-	if (!dev->vbl_queue)
-		goto err;
-
-	dev->vbl_sigs = drm_alloc(sizeof(struct list_head) * num_crtcs,
-				  DRM_MEM_DRIVER);
-	if (!dev->vbl_sigs)
-		goto err;
-
-	dev->_vblank_count = drm_alloc(sizeof(atomic_t) * num_crtcs,
-				      DRM_MEM_DRIVER);
-	if (!dev->_vblank_count)
-		goto err;
-
-	dev->vblank_refcount = drm_alloc(sizeof(atomic_t) * num_crtcs,
-					 DRM_MEM_DRIVER);
-	if (!dev->vblank_refcount)
-		goto err;
-
-	dev->vblank_enabled = drm_calloc(num_crtcs, sizeof(int),
-					 DRM_MEM_DRIVER);
-	if (!dev->vblank_enabled)
-		goto err;
-
-	dev->last_vblank = drm_calloc(num_crtcs, sizeof(u32), DRM_MEM_DRIVER);
-	if (!dev->last_vblank)
-		goto err;
-
-	dev->vblank_premodeset = drm_calloc(num_crtcs, sizeof(u32),
-					    DRM_MEM_DRIVER);
-	if (!dev->vblank_premodeset)
-		goto err;
-
-	dev->vblank_offset = drm_calloc(num_crtcs, sizeof(u32), DRM_MEM_DRIVER);
-	if (!dev->vblank_offset)
-		goto err;
-
-	/* Zero per-crtc vblank stuff */
-	for (i = 0; i < num_crtcs; i++) {
-		init_waitqueue_head(&dev->vbl_queue[i]);
-		INIT_LIST_HEAD(&dev->vbl_sigs[i]);
-		atomic_set(&dev->_vblank_count[i], 0);
-		atomic_set(&dev->vblank_refcount[i], 0);
-	}
-
-	return 0;
-
-err:
-	drm_vblank_cleanup(dev);
-	return ret;
-}
-EXPORT_SYMBOL(drm_vblank_init);
-
 /**
  * Install IRQ handler.
  *
@@ -220,6 +109,17 @@ static int drm_irq_install(struct drm_device * dev)
 
 	DRM_DEBUG("irq=%d\n", dev->irq);
 
+	if (drm_core_check_feature(dev, DRIVER_IRQ_VBL)) {
+		init_waitqueue_head(&dev->vbl_queue);
+
+		spin_lock_init(&dev->vbl_lock);
+
+		INIT_LIST_HEAD(&dev->vbl_sigs);
+		INIT_LIST_HEAD(&dev->vbl_sigs2);
+
+		dev->vbl_pending = 0;
+	}
+
 	/* Before installing handler */
 	dev->driver->irq_preinstall(dev);
 
@@ -237,14 +137,9 @@ static int drm_irq_install(struct drm_device * dev)
 	}
 
 	/* After installing handler */
-	ret = dev->driver->irq_postinstall(dev);
-	if (ret < 0) {
-		mutex_lock(&dev->struct_mutex);
-		dev->irq_enabled = 0;
-		mutex_unlock(&dev->struct_mutex);
-	}
+	dev->driver->irq_postinstall(dev);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -275,8 +170,6 @@ int drm_irq_uninstall(struct drm_device * dev)
 
 	free_irq(dev->irq, dev);
 
-	drm_vblank_cleanup(dev);
-
 	dev->locked_tasklet_func = NULL;
 
 	return 0;
@@ -321,148 +214,6 @@ int drm_control(struct drm_device *dev, void *data,
 }
 
 /**
- * drm_vblank_count - retrieve "cooked" vblank counter value
- * @dev: DRM device
- * @crtc: which counter to retrieve
- *
- * Fetches the "cooked" vblank count value that represents the number of
- * vblank events since the system was booted, including lost events due to
- * modesetting activity.
- */
-u32 drm_vblank_count(struct drm_device *dev, int crtc)
-{
-	return atomic_read(&dev->_vblank_count[crtc]) +
-		dev->vblank_offset[crtc];
-}
-EXPORT_SYMBOL(drm_vblank_count);
-
-/**
- * drm_update_vblank_count - update the master vblank counter
- * @dev: DRM device
- * @crtc: counter to update
- *
- * Call back into the driver to update the appropriate vblank counter
- * (specified by @crtc).  Deal with wraparound, if it occurred, and
- * update the last read value so we can deal with wraparound on the next
- * call if necessary.
- */
-void drm_update_vblank_count(struct drm_device *dev, int crtc)
-{
-	unsigned long irqflags;
-	u32 cur_vblank, diff;
-
-	/*
-	 * Interrupts were disabled prior to this call, so deal with counter
-	 * wrap if needed.
-	 * NOTE!  It's possible we lost a full dev->max_vblank_count events
-	 * here if the register is small or we had vblank interrupts off for
-	 * a long time.
-	 */
-	cur_vblank = dev->driver->get_vblank_counter(dev, crtc);
-	spin_lock_irqsave(&dev->vbl_lock, irqflags);
-	if (cur_vblank < dev->last_vblank[crtc]) {
-		diff = dev->max_vblank_count -
-			dev->last_vblank[crtc];
-		diff += cur_vblank;
-	} else {
-		diff = cur_vblank - dev->last_vblank[crtc];
-	}
-	dev->last_vblank[crtc] = cur_vblank;
-	spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
-
-	atomic_add(diff, &dev->_vblank_count[crtc]);
-}
-EXPORT_SYMBOL(drm_update_vblank_count);
-
-/**
- * drm_vblank_get - get a reference count on vblank events
- * @dev: DRM device
- * @crtc: which CRTC to own
- *
- * Acquire a reference count on vblank events to avoid having them disabled
- * while in use.  Note callers will probably want to update the master counter
- * using drm_update_vblank_count() above before calling this routine so that
- * wakeups occur on the right vblank event.
- *
- * RETURNS
- * Zero on success, nonzero on failure.
- */
-int drm_vblank_get(struct drm_device *dev, int crtc)
-{
-	unsigned long irqflags;
-	int ret = 0;
-
-	spin_lock_irqsave(&dev->vbl_lock, irqflags);
-	/* Going from 0->1 means we have to enable interrupts again */
-	if (atomic_add_return(1, &dev->vblank_refcount[crtc]) == 1 &&
-	    !dev->vblank_enabled[crtc]) {
-		ret = dev->driver->enable_vblank(dev, crtc);
-		if (ret)
-			atomic_dec(&dev->vblank_refcount[crtc]);
-		else
-			dev->vblank_enabled[crtc] = 1;
-	}
-	spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
-
-	return ret;
-}
-EXPORT_SYMBOL(drm_vblank_get);
-
-/**
- * drm_vblank_put - give up ownership of vblank events
- * @dev: DRM device
- * @crtc: which counter to give up
- *
- * Release ownership of a given vblank counter, turning off interrupts
- * if possible.
- */
-void drm_vblank_put(struct drm_device *dev, int crtc)
-{
-	/* Last user schedules interrupt disable */
-	if (atomic_dec_and_test(&dev->vblank_refcount[crtc]))
-	    mod_timer(&dev->vblank_disable_timer, jiffies + 5*DRM_HZ);
-}
-EXPORT_SYMBOL(drm_vblank_put);
-
-/**
- * drm_modeset_ctl - handle vblank event counter changes across mode switch
- * @DRM_IOCTL_ARGS: standard ioctl arguments
- *
- * Applications should call the %_DRM_PRE_MODESET and %_DRM_POST_MODESET
- * ioctls around modesetting so that any lost vblank events are accounted for.
- */
-int drm_modeset_ctl(struct drm_device *dev, void *data,
-		    struct drm_file *file_priv)
-{
-	struct drm_modeset_ctl *modeset = data;
-	int crtc, ret = 0;
-	u32 new;
-
-	crtc = modeset->arg;
-	if (crtc >= dev->num_crtcs) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	switch (modeset->cmd) {
-	case _DRM_PRE_MODESET:
-		dev->vblank_premodeset[crtc] =
-			dev->driver->get_vblank_counter(dev, crtc);
-		break;
-	case _DRM_POST_MODESET:
-		new = dev->driver->get_vblank_counter(dev, crtc);
-		dev->vblank_offset[crtc] = dev->vblank_premodeset[crtc] - new;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-out:
-	return ret;
-}
-
-/**
  * Wait for VBLANK.
  *
  * \param inode device inode.
@@ -481,13 +232,12 @@ out:
  *
  * If a signal is not requested, then calls vblank_wait().
  */
-int drm_wait_vblank(struct drm_device *dev, void *data,
-		    struct drm_file *file_priv)
+int drm_wait_vblank(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 	union drm_wait_vblank *vblwait = data;
 	struct timeval now;
 	int ret = 0;
-	unsigned int flags, seq, crtc;
+	unsigned int flags, seq;
 
 	if ((!dev->irq) || (!dev->irq_enabled))
 		return -EINVAL;
@@ -501,13 +251,13 @@ int drm_wait_vblank(struct drm_device *dev, void *data,
 	}
 
 	flags = vblwait->request.type & _DRM_VBLANK_FLAGS_MASK;
-	crtc = flags & _DRM_VBLANK_SECONDARY ? 1 : 0;
 
-	if (crtc >= dev->num_crtcs)
+	if (!drm_core_check_feature(dev, (flags & _DRM_VBLANK_SECONDARY) ?
+				    DRIVER_IRQ_VBL2 : DRIVER_IRQ_VBL))
 		return -EINVAL;
 
-	drm_update_vblank_count(dev, crtc);
-	seq = drm_vblank_count(dev, crtc);
+	seq = atomic_read((flags & _DRM_VBLANK_SECONDARY) ? &dev->vbl_received2
+			  : &dev->vbl_received);
 
 	switch (vblwait->request.type & _DRM_VBLANK_TYPES_MASK) {
 	case _DRM_VBLANK_RELATIVE:
@@ -526,7 +276,8 @@ int drm_wait_vblank(struct drm_device *dev, void *data,
 
 	if (flags & _DRM_VBLANK_SIGNAL) {
 		unsigned long irqflags;
-		struct list_head *vbl_sigs = &dev->vbl_sigs[crtc];
+		struct list_head *vbl_sigs = (flags & _DRM_VBLANK_SECONDARY)
+				      ? &dev->vbl_sigs2 : &dev->vbl_sigs;
 		struct drm_vbl_sig *vbl_sig;
 
 		spin_lock_irqsave(&dev->vbl_lock, irqflags);
@@ -547,26 +298,22 @@ int drm_wait_vblank(struct drm_device *dev, void *data,
 			}
 		}
 
-		if (atomic_read(&dev->vbl_signal_pending) >= 100) {
+		if (dev->vbl_pending >= 100) {
 			spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
 			return -EBUSY;
 		}
 
+		dev->vbl_pending++;
+
 		spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
 
-		vbl_sig = drm_calloc(1, sizeof(struct drm_vbl_sig),
-				     DRM_MEM_DRIVER);
-		if (!vbl_sig)
+		if (!
+		    (vbl_sig =
+		     drm_alloc(sizeof(struct drm_vbl_sig), DRM_MEM_DRIVER))) {
 			return -ENOMEM;
-
-		ret = drm_vblank_get(dev, crtc);
-		if (ret) {
-			drm_free(vbl_sig, sizeof(struct drm_vbl_sig),
-				 DRM_MEM_DRIVER);
-			return ret;
 		}
 
-		atomic_inc(&dev->vbl_signal_pending);
+		memset((void *)vbl_sig, 0, sizeof(*vbl_sig));
 
 		vbl_sig->sequence = vblwait->request.sequence;
 		vbl_sig->info.si_signo = vblwait->request.signal;
@@ -580,20 +327,17 @@ int drm_wait_vblank(struct drm_device *dev, void *data,
 
 		vblwait->reply.sequence = seq;
 	} else {
-		unsigned long cur_vblank;
-
-		ret = drm_vblank_get(dev, crtc);
-		if (ret)
-			return ret;
-		DRM_WAIT_ON(ret, dev->vbl_queue[crtc], 3 * DRM_HZ,
-			    (((cur_vblank = drm_vblank_count(dev, crtc))
-			      - vblwait->request.sequence) <= (1 << 23)));
-		drm_vblank_put(dev, crtc);
-		do_gettimeofday(&now);
+		if (flags & _DRM_VBLANK_SECONDARY) {
+			if (dev->driver->vblank_wait2)
+				ret = dev->driver->vblank_wait2(dev, &vblwait->request.sequence);
+		} else if (dev->driver->vblank_wait)
+			ret =
+			    dev->driver->vblank_wait(dev,
+						     &vblwait->request.sequence);
 
+		do_gettimeofday(&now);
 		vblwait->reply.tval_sec = now.tv_sec;
 		vblwait->reply.tval_usec = now.tv_usec;
-		vblwait->reply.sequence = cur_vblank;
 	}
 
       done:
@@ -604,57 +348,44 @@ int drm_wait_vblank(struct drm_device *dev, void *data,
  * Send the VBLANK signals.
  *
  * \param dev DRM device.
- * \param crtc CRTC where the vblank event occurred
  *
  * Sends a signal for each task in drm_device::vbl_sigs and empties the list.
  *
  * If a signal is not requested, then calls vblank_wait().
  */
-static void drm_vbl_send_signals(struct drm_device * dev, int crtc)
+void drm_vbl_send_signals(struct drm_device * dev)
 {
-	struct drm_vbl_sig *vbl_sig, *tmp;
-	struct list_head *vbl_sigs;
-	unsigned int vbl_seq;
 	unsigned long flags;
+	int i;
 
 	spin_lock_irqsave(&dev->vbl_lock, flags);
 
-	vbl_sigs = &dev->vbl_sigs[crtc];
-	vbl_seq = drm_vblank_count(dev, crtc);
+	for (i = 0; i < 2; i++) {
+		struct drm_vbl_sig *vbl_sig, *tmp;
+		struct list_head *vbl_sigs = i ? &dev->vbl_sigs2 : &dev->vbl_sigs;
+		unsigned int vbl_seq = atomic_read(i ? &dev->vbl_received2 :
+						   &dev->vbl_received);
 
-	list_for_each_entry_safe(vbl_sig, tmp, vbl_sigs, head) {
-	    if ((vbl_seq - vbl_sig->sequence) <= (1 << 23)) {
-		vbl_sig->info.si_code = vbl_seq;
-		send_sig_info(vbl_sig->info.si_signo,
-			      &vbl_sig->info, vbl_sig->task);
+		list_for_each_entry_safe(vbl_sig, tmp, vbl_sigs, head) {
+			if ((vbl_seq - vbl_sig->sequence) <= (1 << 23)) {
+				vbl_sig->info.si_code = vbl_seq;
+				send_sig_info(vbl_sig->info.si_signo,
+					      &vbl_sig->info, vbl_sig->task);
 
-		list_del(&vbl_sig->head);
+				list_del(&vbl_sig->head);
 
-		drm_free(vbl_sig, sizeof(*vbl_sig),
-			 DRM_MEM_DRIVER);
-		atomic_dec(&dev->vbl_signal_pending);
-		drm_vblank_put(dev, crtc);
-	    }
+				drm_free(vbl_sig, sizeof(*vbl_sig),
+					 DRM_MEM_DRIVER);
+
+				dev->vbl_pending--;
+			}
+		}
 	}
 
 	spin_unlock_irqrestore(&dev->vbl_lock, flags);
 }
 
-/**
- * drm_handle_vblank - handle a vblank event
- * @dev: DRM device
- * @crtc: where this event occurred
- *
- * Drivers should call this routine in their vblank interrupt handlers to
- * update the vblank counter and send any signals that may be pending.
- */
-void drm_handle_vblank(struct drm_device *dev, int crtc)
-{
-	drm_update_vblank_count(dev, crtc);
-	DRM_WAKEUP(&dev->vbl_queue[crtc]);
-	drm_vbl_send_signals(dev, crtc);
-}
-EXPORT_SYMBOL(drm_handle_vblank);
+EXPORT_SYMBOL(drm_vbl_send_signals);
 
 /**
  * Tasklet wrapper function.
diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
index f47e46e..8897434 100644
--- a/drivers/char/drm/i915_dma.c
+++ b/drivers/char/drm/i915_dma.c
@@ -415,13 +415,10 @@ static void i915_emit_breadcrumb(struct drm_device *dev)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
 
-	if (++dev_priv->counter > BREADCRUMB_MASK) {
-		 dev_priv->counter = 1;
-		 DRM_DEBUG("Breadcrumb counter wrapped around\n");
-	}
+	dev_priv->sarea_priv->last_enqueue = ++dev_priv->counter;
 
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_enqueue = dev_priv->counter;
+	if (dev_priv->counter > 0x7FFFFFFFUL)
+		dev_priv->sarea_priv->last_enqueue = dev_priv->counter = 1;
 
 	BEGIN_LP_RING(4);
 	OUT_RING(CMD_STORE_DWORD_IDX);
@@ -431,26 +428,6 @@ static void i915_emit_breadcrumb(struct drm_device *dev)
 	ADVANCE_LP_RING();
 }
 
-int i915_emit_mi_flush(struct drm_device *dev, uint32_t flush)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	uint32_t flush_cmd = CMD_MI_FLUSH;
-	RING_LOCALS;
-
-	flush_cmd |= flush;
-
-	i915_kernel_lost_context(dev);
-
-	BEGIN_LP_RING(4);
-	OUT_RING(flush_cmd);
-	OUT_RING(0);
-	OUT_RING(0);
-	OUT_RING(0);
-	ADVANCE_LP_RING();
-
-	return 0;
-}
-
 static int i915_dispatch_cmdbuffer(struct drm_device * dev,
 				   drm_i915_cmdbuffer_t * cmd)
 {
@@ -534,74 +511,52 @@ static int i915_dispatch_batchbuffer(struct drm_device * dev,
 	return 0;
 }
 
-static void i915_do_dispatch_flip(struct drm_device * dev, int plane, int sync)
+static int i915_dispatch_flip(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	u32 num_pages, current_page, next_page, dspbase;
-	int shift = 2 * plane, x, y;
 	RING_LOCALS;
 
-	/* Calculate display base offset */
-	num_pages = dev_priv->sarea_priv->third_handle ? 3 : 2;
-	current_page = (dev_priv->sarea_priv->pf_current_page >> shift) & 0x3;
-	next_page = (current_page + 1) % num_pages;
+	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
+		  __FUNCTION__,
+		  dev_priv->current_page,
+		  dev_priv->sarea_priv->pf_current_page);
 
-	switch (next_page) {
-	default:
-	case 0:
-		dspbase = dev_priv->sarea_priv->front_offset;
-		break;
-	case 1:
-		dspbase = dev_priv->sarea_priv->back_offset;
-		break;
-	case 2:
-		dspbase = dev_priv->sarea_priv->third_offset;
-		break;
-	}
+	i915_kernel_lost_context(dev);
+
+	BEGIN_LP_RING(2);
+	OUT_RING(INST_PARSER_CLIENT | INST_OP_FLUSH | INST_FLUSH_MAP_CACHE);
+	OUT_RING(0);
+	ADVANCE_LP_RING();
 
-	if (plane == 0) {
-		x = dev_priv->sarea_priv->planeA_x;
-		y = dev_priv->sarea_priv->planeA_y;
+	BEGIN_LP_RING(6);
+	OUT_RING(CMD_OP_DISPLAYBUFFER_INFO | ASYNC_FLIP);
+	OUT_RING(0);
+	if (dev_priv->current_page == 0) {
+		OUT_RING(dev_priv->back_offset);
+		dev_priv->current_page = 1;
 	} else {
-		x = dev_priv->sarea_priv->planeB_x;
-		y = dev_priv->sarea_priv->planeB_y;
+		OUT_RING(dev_priv->front_offset);
+		dev_priv->current_page = 0;
 	}
+	OUT_RING(0);
+	ADVANCE_LP_RING();
 
-	dspbase += (y * dev_priv->sarea_priv->pitch + x) * dev_priv->cpp;
+	BEGIN_LP_RING(2);
+	OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_PLANE_A_FLIP);
+	OUT_RING(0);
+	ADVANCE_LP_RING();
 
-	DRM_DEBUG("plane=%d current_page=%d dspbase=0x%x\n", plane, current_page,
-		  dspbase);
+	dev_priv->sarea_priv->last_enqueue = dev_priv->counter++;
 
 	BEGIN_LP_RING(4);
-	OUT_RING(sync ? 0 :
-		 (MI_WAIT_FOR_EVENT | (plane ? MI_WAIT_FOR_PLANE_B_FLIP :
-				       MI_WAIT_FOR_PLANE_A_FLIP)));
-	OUT_RING(CMD_OP_DISPLAYBUFFER_INFO | (sync ? 0 : ASYNC_FLIP) |
-		 (plane ? DISPLAY_PLANE_B : DISPLAY_PLANE_A));
-	OUT_RING(dev_priv->sarea_priv->pitch * dev_priv->cpp);
-	OUT_RING(dspbase);
+	OUT_RING(CMD_STORE_DWORD_IDX);
+	OUT_RING(20);
+	OUT_RING(dev_priv->counter);
+	OUT_RING(0);
 	ADVANCE_LP_RING();
 
-	dev_priv->sarea_priv->pf_current_page &= ~(0x3 << shift);
-	dev_priv->sarea_priv->pf_current_page |= next_page << shift;
-}
-
-void i915_dispatch_flip(struct drm_device * dev, int planes, int sync)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	int i;
-
-	DRM_DEBUG("planes=0x%x pfCurrentPage=%d\n",
-		  planes, dev_priv->sarea_priv->pf_current_page);
-
-	i915_emit_mi_flush(dev, MI_READ_FLUSH | MI_EXE_FLUSH);
-
-	for (i = 0; i < 2; i++)
-		if (planes & (1 << i))
-			i915_do_dispatch_flip(dev, i, sync);
-
-	i915_emit_breadcrumb(dev);
-
+	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
+	return 0;
 }
 
 static int i915_quiescent(struct drm_device * dev)
@@ -624,6 +579,7 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	u32 *hw_status = dev_priv->hw_status_page;
 	drm_i915_sarea_t *sarea_priv = (drm_i915_sarea_t *)
 	    dev_priv->sarea_priv;
 	drm_i915_batchbuffer_t *batch = data;
@@ -646,7 +602,7 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 
 	ret = i915_dispatch_batchbuffer(dev, batch);
 
-	sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
+	sarea_priv->last_dispatch = (int)hw_status[5];
 	return ret;
 }
 
@@ -654,6 +610,7 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 			  struct drm_file *file_priv)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	u32 *hw_status = dev_priv->hw_status_page;
 	drm_i915_sarea_t *sarea_priv = (drm_i915_sarea_t *)
 	    dev_priv->sarea_priv;
 	drm_i915_cmdbuffer_t *cmdbuf = data;
@@ -678,51 +635,18 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 		return ret;
 	}
 
-	sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
-	return 0;
-}
-
-static int i915_do_cleanup_pageflip(struct drm_device * dev)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	int i, planes, num_pages = dev_priv->sarea_priv->third_handle ? 3 : 2;
-
-	DRM_DEBUG("\n");
-
-	for (i = 0, planes = 0; i < 2; i++)
-		if (dev_priv->sarea_priv->pf_current_page & (0x3 << (2 * i))) {
-			dev_priv->sarea_priv->pf_current_page =
-				(dev_priv->sarea_priv->pf_current_page &
-				 ~(0x3 << (2 * i))) | ((num_pages - 1) << (2 * i));
-
-			planes |= 1 << i;
-		}
-
-	if (planes)
-		i915_dispatch_flip(dev, planes, 0);
-
+	sarea_priv->last_dispatch = (int)hw_status[5];
 	return 0;
 }
 
 static int i915_flip_bufs(struct drm_device *dev, void *data,
 			  struct drm_file *file_priv)
 {
-	drm_i915_flip_t *param = data;
-
-	DRM_DEBUG("\n");
+	DRM_DEBUG("%s\n", __FUNCTION__);
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	/* This is really planes */
-	if (param->pipes & ~0x3) {
-		DRM_ERROR("Invalid planes 0x%x, only <= 0x3 is valid\n",
-			  param->pipes);
-		return -EINVAL;
-	}
-
-	i915_dispatch_flip(dev, param->pipes, 0);
-
-	return 0;
+	return i915_dispatch_flip(dev);
 }
 
 static int i915_getparam(struct drm_device *dev, void *data,
@@ -883,8 +807,6 @@ void i915_driver_lastclose(struct drm_device * dev)
 	if (!dev_priv)
 		return;
 
-	if (drm_getsarea(dev) && dev_priv->sarea_priv)
-		i915_do_cleanup_pageflip(dev);
 	if (dev_priv->agp_heap)
 		i915_mem_takedown(&(dev_priv->agp_heap));
 
diff --git a/drivers/char/drm/i915_drm.h b/drivers/char/drm/i915_drm.h
index 0431c00..05c66cf 100644
--- a/drivers/char/drm/i915_drm.h
+++ b/drivers/char/drm/i915_drm.h
@@ -105,29 +105,14 @@ typedef struct _drm_i915_sarea {
 	unsigned int rotated_tiled;
 	unsigned int rotated2_tiled;
 
-	int planeA_x;
-	int planeA_y;
-	int planeA_w;
-	int planeA_h;
-	int planeB_x;
-	int planeB_y;
-	int planeB_w;
-	int planeB_h;
-
-	/* Triple buffering */
-	drm_handle_t third_handle;
-	int third_offset;
-	int third_size;
-	unsigned int third_tiled;
-
-	/* buffer object handles for the static buffers.  May change
-	 * over the lifetime of the client, though it doesn't in our current
-	 * implementation.
-	 */
-	unsigned int front_bo_handle;
-	unsigned int back_bo_handle;
-	unsigned int third_bo_handle;
-	unsigned int depth_bo_handle;
+	int pipeA_x;
+	int pipeA_y;
+	int pipeA_w;
+	int pipeA_h;
+	int pipeB_x;
+	int pipeB_y;
+	int pipeB_w;
+	int pipeB_h;
 } drm_i915_sarea_t;
 
 /* Flags for perf_boxes
@@ -161,7 +146,7 @@ typedef struct _drm_i915_sarea {
 
 #define DRM_IOCTL_I915_INIT		DRM_IOW( DRM_COMMAND_BASE + DRM_I915_INIT, drm_i915_init_t)
 #define DRM_IOCTL_I915_FLUSH		DRM_IO ( DRM_COMMAND_BASE + DRM_I915_FLUSH)
-#define DRM_IOCTL_I915_FLIP		DRM_IOW( DRM_COMMAND_BASE + DRM_I915_FLIP, drm_i915_flip_t)
+#define DRM_IOCTL_I915_FLIP		DRM_IO ( DRM_COMMAND_BASE + DRM_I915_FLIP)
 #define DRM_IOCTL_I915_BATCHBUFFER	DRM_IOW( DRM_COMMAND_BASE + DRM_I915_BATCHBUFFER, drm_i915_batchbuffer_t)
 #define DRM_IOCTL_I915_IRQ_EMIT         DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_IRQ_EMIT, drm_i915_irq_emit_t)
 #define DRM_IOCTL_I915_IRQ_WAIT         DRM_IOW( DRM_COMMAND_BASE + DRM_I915_IRQ_WAIT, drm_i915_irq_wait_t)
@@ -176,18 +161,6 @@ typedef struct _drm_i915_sarea {
 #define DRM_IOCTL_I915_GET_VBLANK_PIPE	DRM_IOR( DRM_COMMAND_BASE + DRM_I915_GET_VBLANK_PIPE, drm_i915_vblank_pipe_t)
 #define DRM_IOCTL_I915_VBLANK_SWAP	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_VBLANK_SWAP, drm_i915_vblank_swap_t)
 
-/* Asynchronous page flipping:
- */
-typedef struct drm_i915_flip {
-	/*
-	 * This is really talking about planes, and we could rename it
-	 * except for the fact that some of the duplicated i915_drm.h files
-	 * out there check for HAVE_I915_FLIP and so might pick up this
-	 * version.
-	 */
-	int pipes;
-} drm_i915_flip_t;
-
 /* Allow drivers to submit batchbuffers directly to hardware, relying
  * on the security mechanisms provided by hardware.
  */
diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
index bb8f1b2..b2b451d 100644
--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -533,7 +533,8 @@ static struct drm_driver driver = {
 	 */
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_REQUIRE_AGP | /* DRIVER_USE_MTRR |*/
-	    DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED,
+	    DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | DRIVER_IRQ_VBL |
+	    DRIVER_IRQ_VBL2,
 	.load = i915_driver_load,
 	.unload = i915_driver_unload,
 	.lastclose = i915_driver_lastclose,
@@ -541,9 +542,8 @@ static struct drm_driver driver = {
 	.suspend = i915_suspend,
 	.resume = i915_resume,
 	.device_is_agp = i915_driver_device_is_agp,
-	.get_vblank_counter = i915_get_vblank_counter,
-	.enable_vblank = i915_enable_vblank,
-	.disable_vblank = i915_disable_vblank,
+	.vblank_wait = i915_driver_vblank_wait,
+	.vblank_wait2 = i915_driver_vblank_wait2,
 	.irq_preinstall = i915_driver_irq_preinstall,
 	.irq_postinstall = i915_driver_irq_postinstall,
 	.irq_uninstall = i915_driver_irq_uninstall,
diff --git a/drivers/char/drm/i915_drv.h b/drivers/char/drm/i915_drv.h
index db7001f..2be7e1d 100644
--- a/drivers/char/drm/i915_drv.h
+++ b/drivers/char/drm/i915_drv.h
@@ -76,9 +76,8 @@ struct mem_block {
 typedef struct _drm_i915_vbl_swap {
 	struct list_head head;
 	drm_drawable_t drw_id;
-	unsigned int plane;
+	unsigned int pipe;
 	unsigned int sequence;
-	int flip;
 } drm_i915_vbl_swap_t;
 
 typedef struct drm_i915_private {
@@ -91,7 +90,7 @@ typedef struct drm_i915_private {
 	drm_dma_handle_t *status_page_dmah;
 	void *hw_status_page;
 	dma_addr_t dma_status_page;
-	uint32_t counter;
+	unsigned long counter;
 	unsigned int status_gfx_addr;
 	drm_local_map_t hws_map;
 
@@ -104,18 +103,13 @@ typedef struct drm_i915_private {
 
 	wait_queue_head_t irq_queue;
 	atomic_t irq_received;
-	atomic_t irq_emited;
+	atomic_t irq_emitted;
 
 	int tex_lru_log_granularity;
 	int allow_batchbuffer;
 	struct mem_block *agp_heap;
 	unsigned int sr01, adpa, ppcr, dvob, dvoc, lvds;
 	int vblank_pipe;
-	spinlock_t user_irq_lock;
-	int user_irq_refcount;
-	int fence_irq_on;
-	uint32_t irq_enable_reg;
-	int irq_enabled;
 
 	spinlock_t swaps_lock;
 	drm_i915_vbl_swap_t vbl_swaps;
@@ -222,7 +216,7 @@ extern void i915_driver_preclose(struct drm_device *dev,
 extern int i915_driver_device_is_agp(struct drm_device * dev);
 extern long i915_compat_ioctl(struct file *filp, unsigned int cmd,
 			      unsigned long arg);
-extern void i915_dispatch_flip(struct drm_device * dev, int pipes, int sync);
+
 /* i915_irq.c */
 extern int i915_irq_emit(struct drm_device *dev, void *data,
 			 struct drm_file *file_priv);
@@ -233,7 +227,7 @@ extern int i915_driver_vblank_wait(struct drm_device *dev, unsigned int *sequenc
 extern int i915_driver_vblank_wait2(struct drm_device *dev, unsigned int *sequence);
 extern irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS);
 extern void i915_driver_irq_preinstall(struct drm_device * dev);
-extern int i915_driver_irq_postinstall(struct drm_device * dev);
+extern void i915_driver_irq_postinstall(struct drm_device * dev);
 extern void i915_driver_irq_uninstall(struct drm_device * dev);
 extern int i915_vblank_pipe_set(struct drm_device *dev, void *data,
 				struct drm_file *file_priv);
@@ -241,9 +235,6 @@ extern int i915_vblank_pipe_get(struct drm_device *dev, void *data,
 				struct drm_file *file_priv);
 extern int i915_vblank_swap(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv);
-extern int i915_enable_vblank(struct drm_device *dev, int crtc);
-extern void i915_disable_vblank(struct drm_device *dev, int crtc);
-extern u32 i915_get_vblank_counter(struct drm_device *dev, int crtc);
 
 /* i915_mem.c */
 extern int i915_mem_alloc(struct drm_device *dev, void *data,
@@ -388,91 +379,21 @@ extern int i915_wait_ring(struct drm_device * dev, int n, const char *caller);
 
 /* Interrupt bits:
  */
-#define I915_PIPE_CONTROL_NOTIFY_INTERRUPT		(1<<18)
-#define I915_DISPLAY_PORT_INTERRUPT			(1<<17)
-#define I915_RENDER_COMMAND_PARSER_ERROR_INTERRUPT	(1<<15)
-#define I915_GMCH_THERMAL_SENSOR_EVENT_INTERRUPT	(1<<14)
-#define I915_HWB_OOM_INTERRUPT				(1<<13) /* binner out of memory */
-#define I915_SYNC_STATUS_INTERRUPT			(1<<12)
-#define I915_DISPLAY_PLANE_A_FLIP_PENDING_INTERRUPT	(1<<11)
-#define I915_DISPLAY_PLANE_B_FLIP_PENDING_INTERRUPT	(1<<10)
-#define I915_OVERLAY_PLANE_FLIP_PENDING_INTERRUPT	(1<<9)
-#define I915_DISPLAY_PLANE_C_FLIP_PENDING_INTERRUPT	(1<<8)
-#define I915_DISPLAY_PIPE_A_VBLANK_INTERRUPT		(1<<7)
-#define I915_DISPLAY_PIPE_A_EVENT_INTERRUPT		(1<<6)
-#define I915_DISPLAY_PIPE_B_VBLANK_INTERRUPT		(1<<5)
-#define I915_DISPLAY_PIPE_B_EVENT_INTERRUPT		(1<<4)
-#define I915_DEBUG_INTERRUPT				(1<<2)
-#define I915_USER_INTERRUPT				(1<<1)
-
+#define USER_INT_FLAG    (1<<1)
+#define VSYNC_PIPEB_FLAG (1<<5)
+#define VSYNC_PIPEA_FLAG (1<<7)
+#define HWB_OOM_FLAG     (1<<13) /* binner out of memory */
 
 #define I915REG_HWSTAM		0x02098
 #define I915REG_INT_IDENTITY_R	0x020a4
 #define I915REG_INT_MASK_R	0x020a8
 #define I915REG_INT_ENABLE_R	0x020a0
-#define I915REG_INSTPM	        0x020c0
-
-#define PIPEADSL		0x70000
-#define PIPEBDSL		0x71000
 
 #define I915REG_PIPEASTAT	0x70024
 #define I915REG_PIPEBSTAT	0x71024
-/*
- * The two pipe frame counter registers are not synchronized, so
- * reading a stable value is somewhat tricky. The following code
- * should work:
- *
- *  do {
- *    high1 = ((INREG(PIPEAFRAMEHIGH) & PIPE_FRAME_HIGH_MASK) >>
- *             PIPE_FRAME_HIGH_SHIFT;
- *    low1 =  ((INREG(PIPEAFRAMEPIXEL) & PIPE_FRAME_LOW_MASK) >>
- *             PIPE_FRAME_LOW_SHIFT);
- *    high2 = ((INREG(PIPEAFRAMEHIGH) & PIPE_FRAME_HIGH_MASK) >>
- *             PIPE_FRAME_HIGH_SHIFT);
- *  } while (high1 != high2);
- *  frame = (high1 << 8) | low1;
- */
-#define PIPEAFRAMEHIGH          0x70040
-#define PIPEBFRAMEHIGH		0x71040
-#define PIPE_FRAME_HIGH_MASK    0x0000ffff
-#define PIPE_FRAME_HIGH_SHIFT   0
-#define PIPEAFRAMEPIXEL         0x70044
-#define PIPEBFRAMEPIXEL		0x71044
 
-#define PIPE_FRAME_LOW_MASK     0xff000000
-#define PIPE_FRAME_LOW_SHIFT    24
-/*
- * Pixel within the current frame is counted in the PIPEAFRAMEPIXEL register
- * and is 24 bits wide.
- */
-#define PIPE_PIXEL_MASK         0x00ffffff
-#define PIPE_PIXEL_SHIFT        0
-
-#define I915_FIFO_UNDERRUN_STATUS		(1UL<<31)
-#define I915_CRC_ERROR_ENABLE			(1UL<<29)
-#define I915_CRC_DONE_ENABLE			(1UL<<28)
-#define I915_GMBUS_EVENT_ENABLE			(1UL<<27)
-#define I915_VSYNC_INTERRUPT_ENABLE		(1UL<<25)
-#define I915_DISPLAY_LINE_COMPARE_ENABLE	(1UL<<24)
-#define I915_DPST_EVENT_ENABLE			(1UL<<23)
-#define I915_LEGACY_BLC_EVENT_ENABLE		(1UL<<22)
-#define I915_ODD_FIELD_INTERRUPT_ENABLE		(1UL<<21)
-#define I915_EVEN_FIELD_INTERRUPT_ENABLE	(1UL<<20)
-#define I915_START_VBLANK_INTERRUPT_ENABLE	(1UL<<18)	/* 965 or later */
-#define I915_VBLANK_INTERRUPT_ENABLE		(1UL<<17)
-#define I915_OVERLAY_UPDATED_ENABLE		(1UL<<16)
-#define I915_CRC_ERROR_INTERRUPT_STATUS		(1UL<<13)
-#define I915_CRC_DONE_INTERRUPT_STATUS		(1UL<<12)
-#define I915_GMBUS_INTERRUPT_STATUS		(1UL<<11)
-#define I915_VSYNC_INTERRUPT_STATUS		(1UL<<9)
-#define I915_DISPLAY_LINE_COMPARE_STATUS	(1UL<<8)
-#define I915_DPST_EVENT_STATUS			(1UL<<7)
-#define I915_LEGACY_BLC_EVENT_STATUS		(1UL<<6)
-#define I915_ODD_FIELD_INTERRUPT_STATUS		(1UL<<5)
-#define I915_EVEN_FIELD_INTERRUPT_STATUS	(1UL<<4)
-#define I915_START_VBLANK_INTERRUPT_STATUS	(1UL<<2)	/* 965 or later */
-#define I915_VBLANK_INTERRUPT_STATUS		(1UL<<1)
-#define I915_OVERLAY_UPDATED_STATUS		(1UL<<0)
+#define I915_VBLANK_INTERRUPT_ENABLE	(1UL<<17)
+#define I915_VBLANK_CLEAR		(1UL<<1)
 
 #define SRX_INDEX		0x3c4
 #define SRX_DATA		0x3c5
diff --git a/drivers/char/drm/i915_irq.c b/drivers/char/drm/i915_irq.c
index 023ce66..f7f16e7 100644
--- a/drivers/char/drm/i915_irq.c
+++ b/drivers/char/drm/i915_irq.c
@@ -38,109 +38,6 @@
 #define MAX_NOPID ((u32)~0)
 
 /**
- * i915_get_pipe - return the the pipe associated with a given plane
- * @dev: DRM device
- * @plane: plane to look for
- *
- * The Intel Mesa & 2D drivers call the vblank routines with a plane number
- * rather than a pipe number, since they may not always be equal.  This routine
- * maps the given @plane back to a pipe number.
- */
-static int
-i915_get_pipe(struct drm_device *dev, int plane)
-{
-	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	u32 dspcntr;
-
-	dspcntr = plane ? I915_READ(DSPBCNTR) : I915_READ(DSPACNTR);
-
-	return dspcntr & DISPPLANE_SEL_PIPE_MASK ? 1 : 0;
-}
-
-/**
- * i915_get_plane - return the the plane associated with a given pipe
- * @dev: DRM device
- * @pipe: pipe to look for
- *
- * The Intel Mesa & 2D drivers call the vblank routines with a plane number
- * rather than a plane number, since they may not always be equal.  This routine
- * maps the given @pipe back to a plane number.
- */
-static int
-i915_get_plane(struct drm_device *dev, int pipe)
-{
-	if (i915_get_pipe(dev, 0) == pipe)
-		return 0;
-	return 1;
-}
-
-/**
- * i915_pipe_enabled - check if a pipe is enabled
- * @dev: DRM device
- * @pipe: pipe to check
- *
- * Reading certain registers when the pipe is disabled can hang the chip.
- * Use this routine to make sure the PLL is running and the pipe is active
- * before reading such registers if unsure.
- */
-static int
-i915_pipe_enabled(struct drm_device *dev, int pipe)
-{
-	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	unsigned long pipeconf = pipe ? PIPEBCONF : PIPEACONF;
-
-	if (I915_READ(pipeconf) & PIPEACONF_ENABLE)
-		return 1;
-
-	return 0;
-}
-
-/**
- * Emit a synchronous flip.
- *
- * This function must be called with the drawable spinlock held.
- */
-static void
-i915_dispatch_vsync_flip(struct drm_device *dev, struct drm_drawable_info *drw,
-			 int plane)
-{
-	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	drm_i915_sarea_t *sarea_priv = dev_priv->sarea_priv;
-	u16 x1, y1, x2, y2;
-	int pf_planes = 1 << plane;
-
-	/* If the window is visible on the other plane, we have to flip on that
-	 * plane as well.
-	 */
-	if (plane == 1) {
-		x1 = sarea_priv->planeA_x;
-		y1 = sarea_priv->planeA_y;
-		x2 = x1 + sarea_priv->planeA_w;
-		y2 = y1 + sarea_priv->planeA_h;
-	} else {
-		x1 = sarea_priv->planeB_x;
-		y1 = sarea_priv->planeB_y;
-		x2 = x1 + sarea_priv->planeB_w;
-		y2 = y1 + sarea_priv->planeB_h;
-	}
-
-	if (x2 > 0 && y2 > 0) {
-		int i, num_rects = drw->num_rects;
-		struct drm_clip_rect *rect = drw->rects;
-
-		for (i = 0; i < num_rects; i++)
-			if (!(rect[i].x1 >= x2 || rect[i].y1 >= y2 ||
-			      rect[i].x2 <= x1 || rect[i].y2 <= y1)) {
-				pf_planes = 0x3;
-
-				break;
-			}
-	}
-
-	i915_dispatch_flip(dev, pf_planes, 1);
-}
-
-/**
  * Emit blits for scheduled buffer swaps.
  *
  * This function will be called with the HW lock held.
@@ -148,19 +45,20 @@ i915_dispatch_vsync_flip(struct drm_device *dev, struct drm_drawable_info *drw,
 static void i915_vblank_tasklet(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	unsigned long irqflags;
 	struct list_head *list, *tmp, hits, *hit;
-	int nhits, nrects, slice[2], upper[2], lower[2], i, num_pages;
-	unsigned counter[2];
+	int nhits, nrects, slice[2], upper[2], lower[2], i;
+	unsigned counter[2] = { atomic_read(&dev->vbl_received),
+				atomic_read(&dev->vbl_received2) };
 	struct drm_drawable_info *drw;
 	drm_i915_sarea_t *sarea_priv = dev_priv->sarea_priv;
-	u32 cpp = dev_priv->cpp,  offsets[3];
+	u32 cpp = dev_priv->cpp;
 	u32 cmd = (cpp == 4) ? (XY_SRC_COPY_BLT_CMD |
 				XY_SRC_COPY_BLT_WRITE_ALPHA |
 				XY_SRC_COPY_BLT_WRITE_RGB)
 			     : XY_SRC_COPY_BLT_CMD;
 	u32 src_pitch = sarea_priv->pitch * cpp;
 	u32 dst_pitch = sarea_priv->pitch * cpp;
-	/* COPY rop (0xcc), map cpp to magic color depth constants */
 	u32 ropcpp = (0xcc << 16) | ((cpp - 1) << 24);
 	RING_LOCALS;
 
@@ -173,34 +71,24 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 		src_pitch >>= 2;
 	}
 
-	counter[0] = drm_vblank_count(dev, 0);
-	counter[1] = drm_vblank_count(dev, 1);
-
 	DRM_DEBUG("\n");
 
 	INIT_LIST_HEAD(&hits);
 
 	nhits = nrects = 0;
 
-	/* No irqsave/restore necessary.  This tasklet may be run in an
-	 * interrupt context or normal context, but we don't have to worry
-	 * about getting interrupted by something acquiring the lock, because
-	 * we are the interrupt context thing that acquires the lock.
-	 */
-	spin_lock(&dev_priv->swaps_lock);
+	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
 
 	/* Find buffer swaps scheduled for this vertical blank */
 	list_for_each_safe(list, tmp, &dev_priv->vbl_swaps.head) {
 		drm_i915_vbl_swap_t *vbl_swap =
 			list_entry(list, drm_i915_vbl_swap_t, head);
-		int pipe = i915_get_pipe(dev, vbl_swap->plane);
 
-		if ((counter[pipe] - vbl_swap->sequence) > (1<<23))
+		if ((counter[vbl_swap->pipe] - vbl_swap->sequence) > (1<<23))
 			continue;
 
 		list_del(list);
 		dev_priv->swaps_pending--;
-		drm_vblank_put(dev, pipe);
 
 		spin_unlock(&dev_priv->swaps_lock);
 		spin_lock(&dev->drw_lock);
@@ -238,23 +126,43 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 		spin_lock(&dev_priv->swaps_lock);
 	}
 
-	spin_unlock(&dev_priv->swaps_lock);
-
-	if (nhits == 0)
+	if (nhits == 0) {
+		spin_unlock_irqrestore(&dev_priv->swaps_lock, irqflags);
 		return;
+	}
+
+	spin_unlock(&dev_priv->swaps_lock);
 
 	i915_kernel_lost_context(dev);
 
-	upper[0] = upper[1] = 0;
-	slice[0] = max(sarea_priv->planeA_h / nhits, 1);
-	slice[1] = max(sarea_priv->planeB_h / nhits, 1);
-	lower[0] = sarea_priv->planeA_y + slice[0];
-	lower[1] = sarea_priv->planeB_y + slice[0];
+	if (IS_I965G(dev)) {
+		BEGIN_LP_RING(4);
+
+		OUT_RING(GFX_OP_DRAWRECT_INFO_I965);
+		OUT_RING(0);
+		OUT_RING(((sarea_priv->width - 1) & 0xffff) | ((sarea_priv->height - 1) << 16));
+		OUT_RING(0);
+		ADVANCE_LP_RING();
+	} else {
+		BEGIN_LP_RING(6);
 
-	offsets[0] = sarea_priv->front_offset;
-	offsets[1] = sarea_priv->back_offset;
-	offsets[2] = sarea_priv->third_offset;
-	num_pages = sarea_priv->third_handle ? 3 : 2;
+		OUT_RING(GFX_OP_DRAWRECT_INFO);
+		OUT_RING(0);
+		OUT_RING(0);
+		OUT_RING(sarea_priv->width | sarea_priv->height << 16);
+		OUT_RING(sarea_priv->width | sarea_priv->height << 16);
+		OUT_RING(0);
+
+		ADVANCE_LP_RING();
+	}
+
+	sarea_priv->ctxOwner = DRM_KERNEL_CONTEXT;
+
+	upper[0] = upper[1] = 0;
+	slice[0] = max(sarea_priv->pipeA_h / nhits, 1);
+	slice[1] = max(sarea_priv->pipeB_h / nhits, 1);
+	lower[0] = sarea_priv->pipeA_y + slice[0];
+	lower[1] = sarea_priv->pipeB_y + slice[0];
 
 	spin_lock(&dev->drw_lock);
 
@@ -266,8 +174,6 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 	for (i = 0; i++ < nhits;
 	     upper[0] = lower[0], lower[0] += slice[0],
 	     upper[1] = lower[1], lower[1] += slice[1]) {
-		int init_drawrect = 1;
-
 		if (i == nhits)
 			lower[0] = lower[1] = sarea_priv->height;
 
@@ -275,7 +181,7 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 			drm_i915_vbl_swap_t *swap_hit =
 				list_entry(hit, drm_i915_vbl_swap_t, head);
 			struct drm_clip_rect *rect;
-			int num_rects, plane, front, back;
+			int num_rects, pipe;
 			unsigned short top, bottom;
 
 			drw = drm_get_drawable_info(dev, swap_hit->drw_id);
@@ -283,50 +189,10 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 			if (!drw)
 				continue;
 
-			plane = swap_hit->plane;
-
-			if (swap_hit->flip) {
-				i915_dispatch_vsync_flip(dev, drw, plane);
-				continue;
-			}
-
-			if (init_drawrect) {
-				int width  = sarea_priv->width;
-				int height = sarea_priv->height;
-				if (IS_I965G(dev)) {
-					BEGIN_LP_RING(4);
-
-					OUT_RING(GFX_OP_DRAWRECT_INFO_I965);
-					OUT_RING(0);
-					OUT_RING(((width - 1) & 0xffff) | ((height - 1) << 16));
-					OUT_RING(0);
-
-					ADVANCE_LP_RING();
-				} else {
-					BEGIN_LP_RING(6);
-
-					OUT_RING(GFX_OP_DRAWRECT_INFO);
-					OUT_RING(0);
-					OUT_RING(0);
-					OUT_RING(((width - 1) & 0xffff) | ((height - 1) << 16));
-					OUT_RING(0);
-					OUT_RING(0);
-
-					ADVANCE_LP_RING();
-				}
-
-				sarea_priv->ctxOwner = DRM_KERNEL_CONTEXT;
-
-				init_drawrect = 0;
-			}
-
 			rect = drw->rects;
-			top = upper[plane];
-			bottom = lower[plane];
-
-			front = (dev_priv->sarea_priv->pf_current_page >>
-				 (2 * plane)) & 0x3;
-			back = (front + 1) % num_pages;
+			pipe = swap_hit->pipe;
+			top = upper[pipe];
+			bottom = lower[pipe];
 
 			for (num_rects = drw->num_rects; num_rects--; rect++) {
 				int y1 = max(rect->y1, top);
@@ -341,17 +207,17 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 				OUT_RING(ropcpp | dst_pitch);
 				OUT_RING((y1 << 16) | rect->x1);
 				OUT_RING((y2 << 16) | rect->x2);
-				OUT_RING(offsets[front]);
+				OUT_RING(sarea_priv->front_offset);
 				OUT_RING((y1 << 16) | rect->x1);
 				OUT_RING(src_pitch);
-				OUT_RING(offsets[back]);
+				OUT_RING(sarea_priv->back_offset);
 
 				ADVANCE_LP_RING();
 			}
 		}
 	}
 
-	spin_unlock(&dev->drw_lock);
+	spin_unlock_irqrestore(&dev->drw_lock, irqflags);
 
 	list_for_each_safe(hit, tmp, &hits) {
 		drm_i915_vbl_swap_t *swap_hit =
@@ -363,112 +229,67 @@ static void i915_vblank_tasklet(struct drm_device *dev)
 	}
 }
 
-u32 i915_get_vblank_counter(struct drm_device *dev, int plane)
-{
-	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	unsigned long high_frame;
-	unsigned long low_frame;
-	u32 high1, high2, low, count;
-	int pipe;
-
-	pipe = i915_get_pipe(dev, plane);
-	high_frame = pipe ? PIPEBFRAMEHIGH : PIPEAFRAMEHIGH;
-	low_frame = pipe ? PIPEBFRAMEPIXEL : PIPEAFRAMEPIXEL;
-
-	if (!i915_pipe_enabled(dev, pipe)) {
-	    printk(KERN_ERR "trying to get vblank count for disabled "
-		   "pipe %d\n", pipe);
-	    return 0;
-	}
-
-	/*
-	 * High & low register fields aren't synchronized, so make sure
-	 * we get a low value that's stable across two reads of the high
-	 * register.
-	 */
-	do {
-		high1 = ((I915_READ(high_frame) & PIPE_FRAME_HIGH_MASK) >>
-			 PIPE_FRAME_HIGH_SHIFT);
-		low =  ((I915_READ(low_frame) & PIPE_FRAME_LOW_MASK) >>
-			PIPE_FRAME_LOW_SHIFT);
-		high2 = ((I915_READ(high_frame) & PIPE_FRAME_HIGH_MASK) >>
-			 PIPE_FRAME_HIGH_SHIFT);
-	} while (high1 != high2);
-
-	count = (high1 << 8) | low;
-
-	/* count may be reset by other driver(e.g. 2D driver),
-	   we have no way to know if it is wrapped or resetted
-	   when count is zero. do a rough guess.
-	*/
-	if (count == 0 && dev->last_vblank[pipe] < dev->max_vblank_count/2)
-		dev->last_vblank[pipe] = 0;
-
-	return count;
-}
-
 irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 {
 	struct drm_device *dev = (struct drm_device *) arg;
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	u32 iir;
+	u16 temp;
 	u32 pipea_stats, pipeb_stats;
-	int vblank = 0;
-
-	iir = I915_READ(I915REG_INT_IDENTITY_R);
-	if (iir == 0) {
-		DRM_DEBUG ("iir 0x%08x im 0x%08x ie 0x%08x pipea 0x%08x pipeb 0x%08x\n",
-			   iir,
-			   I915_READ(I915REG_INT_MASK_R),
-			   I915_READ(I915REG_INT_ENABLE_R),
-			   I915_READ(I915REG_PIPEASTAT),
-			   I915_READ(I915REG_PIPEBSTAT));
-		return IRQ_NONE;
-	}
 
-	/*
-	 * Clear the PIPE(A|B)STAT regs before the IIR otherwise
-	 * we may get extra interrupts.
-	 */
-	if (iir & I915_DISPLAY_PIPE_A_EVENT_INTERRUPT) {
-		pipea_stats = I915_READ(I915REG_PIPEASTAT);
-		if (pipea_stats & (I915_START_VBLANK_INTERRUPT_STATUS|
-				   I915_VBLANK_INTERRUPT_STATUS))
-		{
-			vblank++;
-			drm_handle_vblank(dev, i915_get_plane(dev, 0));
-		}
-		I915_WRITE(I915REG_PIPEASTAT, pipea_stats);
-	}
-	if (iir & I915_DISPLAY_PIPE_B_EVENT_INTERRUPT) {
-		pipeb_stats = I915_READ(I915REG_PIPEBSTAT);
-		if (pipeb_stats & (I915_START_VBLANK_INTERRUPT_STATUS|
-				   I915_VBLANK_INTERRUPT_STATUS))
-		{
-			vblank++;
-			drm_handle_vblank(dev, i915_get_plane(dev, 1));
-		}
-		I915_WRITE(I915REG_PIPEBSTAT, pipeb_stats);
-	}
+	pipea_stats = I915_READ(I915REG_PIPEASTAT);
+	pipeb_stats = I915_READ(I915REG_PIPEBSTAT);
 
-	if (dev_priv->sarea_priv)
-	    dev_priv->sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
+	temp = I915_READ16(I915REG_INT_IDENTITY_R);
 
-	I915_WRITE(I915REG_INT_IDENTITY_R, iir);
-	(void) I915_READ(I915REG_INT_IDENTITY_R); /* Flush posted write */
+	temp &= (USER_INT_FLAG | VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG);
 
-	if (iir & I915_USER_INTERRUPT) {
+	DRM_DEBUG("%s flag=%08x\n", __FUNCTION__, temp);
+
+	if (temp == 0)
+		return IRQ_NONE;
+
+	I915_WRITE16(I915REG_INT_IDENTITY_R, temp);
+	(void) I915_READ16(I915REG_INT_IDENTITY_R);
+	DRM_READMEMORYBARRIER();
+
+	dev_priv->sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
+
+	if (temp & USER_INT_FLAG)
 		DRM_WAKEUP(&dev_priv->irq_queue);
-	}
-	if (vblank) {
+
+	if (temp & (VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG)) {
+		int vblank_pipe = dev_priv->vblank_pipe;
+
+		if ((vblank_pipe &
+		     (DRM_I915_VBLANK_PIPE_A | DRM_I915_VBLANK_PIPE_B))
+		    == (DRM_I915_VBLANK_PIPE_A | DRM_I915_VBLANK_PIPE_B)) {
+			if (temp & VSYNC_PIPEA_FLAG)
+				atomic_inc(&dev->vbl_received);
+			if (temp & VSYNC_PIPEB_FLAG)
+				atomic_inc(&dev->vbl_received2);
+		} else if (((temp & VSYNC_PIPEA_FLAG) &&
+			    (vblank_pipe & DRM_I915_VBLANK_PIPE_A)) ||
+			   ((temp & VSYNC_PIPEB_FLAG) &&
+			    (vblank_pipe & DRM_I915_VBLANK_PIPE_B)))
+			atomic_inc(&dev->vbl_received);
+
+		DRM_WAKEUP(&dev->vbl_queue);
+		drm_vbl_send_signals(dev);
+
 		if (dev_priv->swaps_pending > 0)
 			drm_locked_tasklet(dev, i915_vblank_tasklet);
+		I915_WRITE(I915REG_PIPEASTAT,
+			pipea_stats|I915_VBLANK_INTERRUPT_ENABLE|
+			I915_VBLANK_CLEAR);
+		I915_WRITE(I915REG_PIPEBSTAT,
+			pipeb_stats|I915_VBLANK_INTERRUPT_ENABLE|
+			I915_VBLANK_CLEAR);
 	}
 
 	return IRQ_HANDLED;
 }
 
-static int i915_emit_irq(struct drm_device *dev)
+static int i915_emit_irq(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
@@ -515,12 +336,42 @@ static int i915_wait_irq(struct drm_device * dev, int irq_nr)
 			  READ_BREADCRUMB(dev_priv), (int)dev_priv->counter);
 	}
 
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_dispatch =
-			READ_BREADCRUMB(dev_priv);
+	dev_priv->sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
 	return ret;
 }
 
+static int i915_driver_vblank_do_wait(struct drm_device *dev, unsigned int *sequence,
+				      atomic_t *counter)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	unsigned int cur_vblank;
+	int ret = 0;
+
+	if (!dev_priv) {
+		DRM_ERROR("called with no initialization\n");
+		return -EINVAL;
+	}
+
+	DRM_WAIT_ON(ret, dev->vbl_queue, 3 * DRM_HZ,
+		    (((cur_vblank = atomic_read(counter))
+			- *sequence) <= (1<<23)));
+
+	*sequence = cur_vblank;
+
+	return ret;
+}
+
+
+int i915_driver_vblank_wait(struct drm_device *dev, unsigned int *sequence)
+{
+	return i915_driver_vblank_do_wait(dev, sequence, &dev->vbl_received);
+}
+
+int i915_driver_vblank_wait2(struct drm_device *dev, unsigned int *sequence)
+{
+	return i915_driver_vblank_do_wait(dev, sequence, &dev->vbl_received2);
+}
+
 /* Needs the lock as it touches the ring.
  */
 int i915_irq_emit(struct drm_device *dev, void *data,
@@ -563,96 +414,18 @@ int i915_irq_wait(struct drm_device *dev, void *data,
 	return i915_wait_irq(dev, irqwait->irq_seq);
 }
 
-int i915_enable_vblank(struct drm_device *dev, int plane)
-{
-	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	int pipe = i915_get_pipe(dev, plane);
-	u32	pipestat_reg = 0;
-	u32	pipestat;
-
-	switch (pipe) {
-	case 0:
-		pipestat_reg = I915REG_PIPEASTAT;
-		dev_priv->irq_enable_reg |= I915_DISPLAY_PIPE_A_EVENT_INTERRUPT;
-		break;
-	case 1:
-		pipestat_reg = I915REG_PIPEBSTAT;
-		dev_priv->irq_enable_reg |= I915_DISPLAY_PIPE_B_EVENT_INTERRUPT;
-		break;
-	default:
-		DRM_ERROR("tried to enable vblank on non-existent pipe %d\n",
-			  pipe);
-		break;
-	}
-
-	if (pipestat_reg)
-	{
-		pipestat = I915_READ (pipestat_reg);
-		/*
-		 * Older chips didn't have the start vblank interrupt,
-		 * but
-		 */
-		if (IS_I965G (dev))
-			pipestat |= I915_START_VBLANK_INTERRUPT_ENABLE;
-		else
-			pipestat |= I915_VBLANK_INTERRUPT_ENABLE;
-		/*
-		 * Clear any pending status
-		 */
-		pipestat |= (I915_START_VBLANK_INTERRUPT_STATUS |
-			     I915_VBLANK_INTERRUPT_STATUS);
-		I915_WRITE(pipestat_reg, pipestat);
-	}
-	I915_WRITE(I915REG_INT_ENABLE_R, dev_priv->irq_enable_reg);
-
-	return 0;
-}
-
-void i915_disable_vblank(struct drm_device *dev, int plane)
-{
-	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	int pipe = i915_get_pipe(dev, plane);
-	u32	pipestat_reg = 0;
-	u32	pipestat;
-
-	switch (pipe) {
-	case 0:
-		pipestat_reg = I915REG_PIPEASTAT;
-		dev_priv->irq_enable_reg &= ~I915_DISPLAY_PIPE_A_EVENT_INTERRUPT;
-		break;
-	case 1:
-		pipestat_reg = I915REG_PIPEBSTAT;
-		dev_priv->irq_enable_reg &= ~I915_DISPLAY_PIPE_B_EVENT_INTERRUPT;
-		break;
-	default:
-		DRM_ERROR("tried to disable vblank on non-existent pipe %d\n",
-			  pipe);
-		break;
-	}
-
-	I915_WRITE(I915REG_INT_ENABLE_R, dev_priv->irq_enable_reg);
-	if (pipestat_reg)
-	{
-		pipestat = I915_READ (pipestat_reg);
-		pipestat &= ~(I915_START_VBLANK_INTERRUPT_ENABLE |
-			      I915_VBLANK_INTERRUPT_ENABLE);
-		/*
-		 * Clear any pending status
-		 */
-		pipestat |= (I915_START_VBLANK_INTERRUPT_STATUS |
-			     I915_VBLANK_INTERRUPT_STATUS);
-		I915_WRITE(pipestat_reg, pipestat);
-	}
-}
-
 static void i915_enable_interrupt (struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
+	u16 flag;
 
-	dev_priv->irq_enable_reg |= I915_USER_INTERRUPT;
+	flag = 0;
+	if (dev_priv->vblank_pipe & DRM_I915_VBLANK_PIPE_A)
+		flag |= VSYNC_PIPEA_FLAG;
+	if (dev_priv->vblank_pipe & DRM_I915_VBLANK_PIPE_B)
+		flag |= VSYNC_PIPEB_FLAG;
 
-	I915_WRITE(I915REG_INT_ENABLE_R, dev_priv->irq_enable_reg);
-	dev_priv->irq_enabled = 1;
+	I915_WRITE16(I915REG_INT_ENABLE_R, USER_INT_FLAG | flag);
 }
 
 /* Set the vblank monitor pipe
@@ -675,6 +448,8 @@ int i915_vblank_pipe_set(struct drm_device *dev, void *data,
 
 	dev_priv->vblank_pipe = pipe->pipe;
 
+	i915_enable_interrupt (dev);
+
 	return 0;
 }
 
@@ -692,9 +467,9 @@ int i915_vblank_pipe_get(struct drm_device *dev, void *data,
 
 	flag = I915_READ(I915REG_INT_ENABLE_R);
 	pipe->pipe = 0;
-	if (flag & I915_DISPLAY_PIPE_A_EVENT_INTERRUPT)
+	if (flag & VSYNC_PIPEA_FLAG)
 		pipe->pipe |= DRM_I915_VBLANK_PIPE_A;
-	if (flag & I915_DISPLAY_PIPE_B_EVENT_INTERRUPT)
+	if (flag & VSYNC_PIPEB_FLAG)
 		pipe->pipe |= DRM_I915_VBLANK_PIPE_B;
 
 	return 0;
@@ -709,30 +484,27 @@ int i915_vblank_swap(struct drm_device *dev, void *data,
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	drm_i915_vblank_swap_t *swap = data;
 	drm_i915_vbl_swap_t *vbl_swap;
-	unsigned int pipe, seqtype, curseq, plane;
+	unsigned int pipe, seqtype, curseq;
 	unsigned long irqflags;
 	struct list_head *list;
-	int ret;
 
 	if (!dev_priv) {
 		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
-	if (!dev_priv->sarea_priv || dev_priv->sarea_priv->rotation) {
+	if (dev_priv->sarea_priv->rotation) {
 		DRM_DEBUG("Rotation not supported\n");
 		return -EINVAL;
 	}
 
 	if (swap->seqtype & ~(_DRM_VBLANK_RELATIVE | _DRM_VBLANK_ABSOLUTE |
-			     _DRM_VBLANK_SECONDARY | _DRM_VBLANK_NEXTONMISS |
-			     _DRM_VBLANK_FLIP)) {
+			     _DRM_VBLANK_SECONDARY | _DRM_VBLANK_NEXTONMISS)) {
 		DRM_ERROR("Invalid sequence type 0x%x\n", swap->seqtype);
 		return -EINVAL;
 	}
 
-	plane = (swap->seqtype & _DRM_VBLANK_SECONDARY) ? 1 : 0;
-	pipe = i915_get_pipe(dev, plane);
+	pipe = (swap->seqtype & _DRM_VBLANK_SECONDARY) ? 1 : 0;
 
 	seqtype = swap->seqtype & (_DRM_VBLANK_RELATIVE | _DRM_VBLANK_ABSOLUTE);
 
@@ -743,11 +515,6 @@ int i915_vblank_swap(struct drm_device *dev, void *data,
 
 	spin_lock_irqsave(&dev->drw_lock, irqflags);
 
-	/* It makes no sense to schedule a swap for a drawable that doesn't have
-	 * valid information at this point. E.g. this could mean that the X
-	 * server is too old to push drawable information to the DRM, in which
-	 * case all such swaps would become ineffective.
-	 */
 	if (!drm_get_drawable_info(dev, swap->drawable)) {
 		spin_unlock_irqrestore(&dev->drw_lock, irqflags);
 		DRM_DEBUG("Invalid drawable ID %d\n", swap->drawable);
@@ -756,8 +523,7 @@ int i915_vblank_swap(struct drm_device *dev, void *data,
 
 	spin_unlock_irqrestore(&dev->drw_lock, irqflags);
 
-	drm_update_vblank_count(dev, pipe);
-	curseq = drm_vblank_count(dev, pipe);
+	curseq = atomic_read(pipe ? &dev->vbl_received2 : &dev->vbl_received);
 
 	if (seqtype == _DRM_VBLANK_RELATIVE)
 		swap->sequence += curseq;
@@ -771,43 +537,14 @@ int i915_vblank_swap(struct drm_device *dev, void *data,
 		}
 	}
 
-	if (swap->seqtype & _DRM_VBLANK_FLIP) {
-		swap->sequence--;
-
-		if ((curseq - swap->sequence) <= (1<<23)) {
-			struct drm_drawable_info *drw;
-
-			LOCK_TEST_WITH_RETURN(dev, file_priv);
-
-			spin_lock_irqsave(&dev->drw_lock, irqflags);
-
-			drw = drm_get_drawable_info(dev, swap->drawable);
-
-			if (!drw) {
-				spin_unlock_irqrestore(&dev->drw_lock,
-				    irqflags);
-				DRM_DEBUG("Invalid drawable ID %d\n",
-					  swap->drawable);
-				return -EINVAL;
-			}
-
-			i915_dispatch_vsync_flip(dev, drw, plane);
-
-			spin_unlock_irqrestore(&dev->drw_lock, irqflags);
-
-			return 0;
-		}
-	}
-
 	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
 
 	list_for_each(list, &dev_priv->vbl_swaps.head) {
 		vbl_swap = list_entry(list, drm_i915_vbl_swap_t, head);
 
 		if (vbl_swap->drw_id == swap->drawable &&
-		    vbl_swap->plane == plane &&
+		    vbl_swap->pipe == pipe &&
 		    vbl_swap->sequence == swap->sequence) {
-			vbl_swap->flip = (swap->seqtype & _DRM_VBLANK_FLIP);
 			spin_unlock_irqrestore(&dev_priv->swaps_lock, irqflags);
 			DRM_DEBUG("Already scheduled\n");
 			return 0;
@@ -830,19 +567,9 @@ int i915_vblank_swap(struct drm_device *dev, void *data,
 
 	DRM_DEBUG("\n");
 
-	ret = drm_vblank_get(dev, pipe);
-	if (ret) {
-		drm_free(vbl_swap, sizeof(*vbl_swap), DRM_MEM_DRIVER);
-		return ret;
-	}
-
 	vbl_swap->drw_id = swap->drawable;
-	vbl_swap->plane = plane;
+	vbl_swap->pipe = pipe;
 	vbl_swap->sequence = swap->sequence;
-	vbl_swap->flip = (swap->seqtype & _DRM_VBLANK_FLIP);
-
-	if (vbl_swap->flip)
-		swap->sequence++;
 
 	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
 
@@ -860,57 +587,37 @@ void i915_driver_irq_preinstall(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 
-	I915_WRITE16(I915REG_HWSTAM, 0xeffe);
+	I915_WRITE16(I915REG_HWSTAM, 0xfffe);
 	I915_WRITE16(I915REG_INT_MASK_R, 0x0);
 	I915_WRITE16(I915REG_INT_ENABLE_R, 0x0);
 }
 
-int i915_driver_irq_postinstall(struct drm_device * dev)
+void i915_driver_irq_postinstall(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	int ret, num_pipes = 2;
 
 	spin_lock_init(&dev_priv->swaps_lock);
 	INIT_LIST_HEAD(&dev_priv->vbl_swaps.head);
 	dev_priv->swaps_pending = 0;
 
-	dev_priv->user_irq_refcount = 0;
-	dev_priv->irq_enable_reg = 0;
-
-	ret = drm_vblank_init(dev, num_pipes);
-	if (ret)
-		return ret;
-
-	dev->max_vblank_count = 0xffffff; /* only 24 bits of frame count */
-
+	if (!dev_priv->vblank_pipe)
+		dev_priv->vblank_pipe = DRM_I915_VBLANK_PIPE_A;
 	i915_enable_interrupt(dev);
 	DRM_INIT_WAITQUEUE(&dev_priv->irq_queue);
-
-	/*
-	 * Initialize the hardware status page IRQ location.
-	 */
-
-	I915_WRITE(I915REG_INSTPM, (1 << 5) | (1 << 21));
-	return 0;
 }
 
 void i915_driver_irq_uninstall(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
-	u32 temp;
+	u16 temp;
 
 	if (!dev_priv)
 		return;
 
-	dev_priv->irq_enabled = 0;
-	I915_WRITE(I915REG_HWSTAM, 0xffffffff);
-	I915_WRITE(I915REG_INT_MASK_R, 0xffffffff);
-	I915_WRITE(I915REG_INT_ENABLE_R, 0x0);
-
-	temp = I915_READ(I915REG_PIPEASTAT);
-	I915_WRITE(I915REG_PIPEASTAT, temp);
-	temp = I915_READ(I915REG_PIPEBSTAT);
-	I915_WRITE(I915REG_PIPEBSTAT, temp);
-	temp = I915_READ(I915REG_INT_IDENTITY_R);
-	I915_WRITE(I915REG_INT_IDENTITY_R, temp);
+	I915_WRITE16(I915REG_HWSTAM, 0xffff);
+	I915_WRITE16(I915REG_INT_MASK_R, 0xffff);
+	I915_WRITE16(I915REG_INT_ENABLE_R, 0x0);
+
+	temp = I915_READ16(I915REG_INT_IDENTITY_R);
+	I915_WRITE16(I915REG_INT_IDENTITY_R, temp);
 }
diff --git a/drivers/char/drm/mga_drv.c b/drivers/char/drm/mga_drv.c
index 6b37909..5572939 100644
--- a/drivers/char/drm/mga_drv.c
+++ b/drivers/char/drm/mga_drv.c
@@ -45,16 +45,15 @@ static struct pci_device_id pciidlist[] = {
 static struct drm_driver driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_USE_MTRR | DRIVER_PCI_DMA |
-	    DRIVER_HAVE_DMA | DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED,
+	    DRIVER_HAVE_DMA | DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED |
+	    DRIVER_IRQ_VBL,
 	.dev_priv_size = sizeof(drm_mga_buf_priv_t),
 	.load = mga_driver_load,
 	.unload = mga_driver_unload,
 	.lastclose = mga_driver_lastclose,
 	.dma_quiescent = mga_driver_dma_quiescent,
 	.device_is_agp = mga_driver_device_is_agp,
-	.get_vblank_counter = mga_get_vblank_counter,
-	.enable_vblank = mga_enable_vblank,
-	.disable_vblank = mga_disable_vblank,
+	.vblank_wait = mga_driver_vblank_wait,
 	.irq_preinstall = mga_driver_irq_preinstall,
 	.irq_postinstall = mga_driver_irq_postinstall,
 	.irq_uninstall = mga_driver_irq_uninstall,
diff --git a/drivers/char/drm/mga_drv.h b/drivers/char/drm/mga_drv.h
index 8f7291f..f6ebd24 100644
--- a/drivers/char/drm/mga_drv.h
+++ b/drivers/char/drm/mga_drv.h
@@ -120,7 +120,6 @@ typedef struct drm_mga_private {
 	u32 clear_cmd;
 	u32 maccess;
 
-	atomic_t vbl_received;		/**< Number of vblanks received. */
 	wait_queue_head_t fence_queue;
 	atomic_t last_fence_retired;
 	u32 next_fence_to_post;
@@ -182,14 +181,11 @@ extern int mga_warp_install_microcode(drm_mga_private_t * dev_priv);
 extern int mga_warp_init(drm_mga_private_t * dev_priv);
 
 				/* mga_irq.c */
-extern int mga_enable_vblank(struct drm_device *dev, int crtc);
-extern void mga_disable_vblank(struct drm_device *dev, int crtc);
-extern u32 mga_get_vblank_counter(struct drm_device *dev, int crtc);
 extern int mga_driver_fence_wait(struct drm_device * dev, unsigned int *sequence);
 extern int mga_driver_vblank_wait(struct drm_device * dev, unsigned int *sequence);
 extern irqreturn_t mga_driver_irq_handler(DRM_IRQ_ARGS);
 extern void mga_driver_irq_preinstall(struct drm_device * dev);
-extern int mga_driver_irq_postinstall(struct drm_device * dev);
+extern void mga_driver_irq_postinstall(struct drm_device * dev);
 extern void mga_driver_irq_uninstall(struct drm_device * dev);
 extern long mga_compat_ioctl(struct file *filp, unsigned int cmd,
 			     unsigned long arg);
diff --git a/drivers/char/drm/mga_irq.c b/drivers/char/drm/mga_irq.c
index 06852fb..9302cb8 100644
--- a/drivers/char/drm/mga_irq.c
+++ b/drivers/char/drm/mga_irq.c
@@ -35,20 +35,6 @@
 #include "mga_drm.h"
 #include "mga_drv.h"
 
-u32 mga_get_vblank_counter(struct drm_device *dev, int crtc)
-{
-	const drm_mga_private_t *const dev_priv =
-		(drm_mga_private_t *) dev->dev_private;
-
-	if (crtc != 0) {
-		return 0;
-	}
-
-
-	return atomic_read(&dev_priv->vbl_received);
-}
-
-
 irqreturn_t mga_driver_irq_handler(DRM_IRQ_ARGS)
 {
 	struct drm_device *dev = (struct drm_device *) arg;
@@ -61,8 +47,9 @@ irqreturn_t mga_driver_irq_handler(DRM_IRQ_ARGS)
 	/* VBLANK interrupt */
 	if (status & MGA_VLINEPEN) {
 		MGA_WRITE(MGA_ICLEAR, MGA_VLINEICLR);
-		atomic_inc(&dev_priv->vbl_received);
-		drm_handle_vblank(dev, 0);
+		atomic_inc(&dev->vbl_received);
+		DRM_WAKEUP(&dev->vbl_queue);
+		drm_vbl_send_signals(dev);
 		handled = 1;
 	}
 
@@ -91,34 +78,22 @@ irqreturn_t mga_driver_irq_handler(DRM_IRQ_ARGS)
 	return IRQ_NONE;
 }
 
-int mga_enable_vblank(struct drm_device *dev, int crtc)
+int mga_driver_vblank_wait(struct drm_device * dev, unsigned int *sequence)
 {
-	drm_mga_private_t *dev_priv = (drm_mga_private_t *) dev->dev_private;
-
-	if (crtc != 0) {
-		DRM_ERROR("tried to enable vblank on non-existent crtc %d\n",
-			  crtc);
-		return 0;
-	}
-
-	MGA_WRITE(MGA_IEN, MGA_VLINEIEN | MGA_SOFTRAPEN);
-	return 0;
-}
+	unsigned int cur_vblank;
+	int ret = 0;
 
+	/* Assume that the user has missed the current sequence number
+	 * by about a day rather than she wants to wait for years
+	 * using vertical blanks...
+	 */
+	DRM_WAIT_ON(ret, dev->vbl_queue, 3 * DRM_HZ,
+		    (((cur_vblank = atomic_read(&dev->vbl_received))
+		      - *sequence) <= (1 << 23)));
 
-void mga_disable_vblank(struct drm_device *dev, int crtc)
-{
-	if (crtc != 0) {
-		DRM_ERROR("tried to disable vblank on non-existent crtc %d\n",
-			  crtc);
-	}
+	*sequence = cur_vblank;
 
-	/* Do *NOT* disable the vertical refresh interrupt.  MGA doesn't have
-	 * a nice hardware counter that tracks the number of refreshes when
-	 * the interrupt is disabled, and the kernel doesn't know the refresh
-	 * rate to calculate an estimate.
-	 */
-	/* MGA_WRITE(MGA_IEN, MGA_VLINEIEN | MGA_SOFTRAPEN); */
+	return ret;
 }
 
 int mga_driver_fence_wait(struct drm_device * dev, unsigned int *sequence)
@@ -150,22 +125,14 @@ void mga_driver_irq_preinstall(struct drm_device * dev)
 	MGA_WRITE(MGA_ICLEAR, ~0);
 }
 
-int mga_driver_irq_postinstall(struct drm_device * dev)
+void mga_driver_irq_postinstall(struct drm_device * dev)
 {
 	drm_mga_private_t *dev_priv = (drm_mga_private_t *) dev->dev_private;
-	int ret;
-
-	ret = drm_vblank_init(dev, 1);
-	if (ret)
-		return ret;
 
 	DRM_INIT_WAITQUEUE(&dev_priv->fence_queue);
 
-	/* Turn on soft trap interrupt.  Vertical blank interrupts are enabled
-	 * in mga_enable_vblank.
-	 */
-	MGA_WRITE(MGA_IEN, MGA_SOFTRAPEN);
-	return 0;
+	/* Turn on vertical blank interrupt and soft trap interrupt. */
+	MGA_WRITE(MGA_IEN, MGA_VLINEIEN | MGA_SOFTRAPEN);
 }
 
 void mga_driver_irq_uninstall(struct drm_device * dev)
diff --git a/drivers/char/drm/r128_drv.c b/drivers/char/drm/r128_drv.c
index 2888aa0..6108e75 100644
--- a/drivers/char/drm/r128_drv.c
+++ b/drivers/char/drm/r128_drv.c
@@ -43,13 +43,12 @@ static struct pci_device_id pciidlist[] = {
 static struct drm_driver driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_USE_MTRR | DRIVER_PCI_DMA | DRIVER_SG |
-	    DRIVER_HAVE_DMA | DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED,
+	    DRIVER_HAVE_DMA | DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED |
+	    DRIVER_IRQ_VBL,
 	.dev_priv_size = sizeof(drm_r128_buf_priv_t),
 	.preclose = r128_driver_preclose,
 	.lastclose = r128_driver_lastclose,
-	.get_vblank_counter = r128_get_vblank_counter,
-	.enable_vblank = r128_enable_vblank,
-	.disable_vblank = r128_disable_vblank,
+	.vblank_wait = r128_driver_vblank_wait,
 	.irq_preinstall = r128_driver_irq_preinstall,
 	.irq_postinstall = r128_driver_irq_postinstall,
 	.irq_uninstall = r128_driver_irq_uninstall,
diff --git a/drivers/char/drm/r128_drv.h b/drivers/char/drm/r128_drv.h
index 80af9e0..011105e 100644
--- a/drivers/char/drm/r128_drv.h
+++ b/drivers/char/drm/r128_drv.h
@@ -97,8 +97,6 @@ typedef struct drm_r128_private {
 	u32 crtc_offset;
 	u32 crtc_offset_cntl;
 
-	atomic_t vbl_received;
-
 	u32 color_fmt;
 	unsigned int front_offset;
 	unsigned int front_pitch;
@@ -151,12 +149,11 @@ extern int r128_wait_ring(drm_r128_private_t * dev_priv, int n);
 extern int r128_do_cce_idle(drm_r128_private_t * dev_priv);
 extern int r128_do_cleanup_cce(struct drm_device * dev);
 
-extern int r128_enable_vblank(struct drm_device *dev, int crtc);
-extern void r128_disable_vblank(struct drm_device *dev, int crtc);
-extern u32 r128_get_vblank_counter(struct drm_device *dev, int crtc);
+extern int r128_driver_vblank_wait(struct drm_device * dev, unsigned int *sequence);
+
 extern irqreturn_t r128_driver_irq_handler(DRM_IRQ_ARGS);
 extern void r128_driver_irq_preinstall(struct drm_device * dev);
-extern int r128_driver_irq_postinstall(struct drm_device * dev);
+extern void r128_driver_irq_postinstall(struct drm_device * dev);
 extern void r128_driver_irq_uninstall(struct drm_device * dev);
 extern void r128_driver_lastclose(struct drm_device * dev);
 extern void r128_driver_preclose(struct drm_device * dev,
diff --git a/drivers/char/drm/r128_irq.c b/drivers/char/drm/r128_irq.c
index 5b95bd8..c76fdca 100644
--- a/drivers/char/drm/r128_irq.c
+++ b/drivers/char/drm/r128_irq.c
@@ -35,16 +35,6 @@
 #include "r128_drm.h"
 #include "r128_drv.h"
 
-u32 r128_get_vblank_counter(struct drm_device *dev, int crtc)
-{
-	const drm_r128_private_t *dev_priv = dev->dev_private;
-
-	if (crtc != 0)
-		return 0;
-
-	return atomic_read(&dev_priv->vbl_received);
-}
-
 irqreturn_t r128_driver_irq_handler(DRM_IRQ_ARGS)
 {
 	struct drm_device *dev = (struct drm_device *) arg;
@@ -56,38 +46,30 @@ irqreturn_t r128_driver_irq_handler(DRM_IRQ_ARGS)
 	/* VBLANK interrupt */
 	if (status & R128_CRTC_VBLANK_INT) {
 		R128_WRITE(R128_GEN_INT_STATUS, R128_CRTC_VBLANK_INT_AK);
-		atomic_inc(&dev_priv->vbl_received);
-		drm_handle_vblank(dev, 0);
+		atomic_inc(&dev->vbl_received);
+		DRM_WAKEUP(&dev->vbl_queue);
+		drm_vbl_send_signals(dev);
 		return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
 }
 
-int r128_enable_vblank(struct drm_device *dev, int crtc)
+int r128_driver_vblank_wait(struct drm_device * dev, unsigned int *sequence)
 {
-	drm_r128_private_t *dev_priv = dev->dev_private;
-
-	if (crtc != 0) {
-		DRM_ERROR("%s:  bad crtc %d\n", __FUNCTION__, crtc);
-		return -EINVAL;
-	}
+	unsigned int cur_vblank;
+	int ret = 0;
 
-	R128_WRITE(R128_GEN_INT_CNTL, R128_CRTC_VBLANK_INT_EN);
-	return 0;
-}
+	/* Assume that the user has missed the current sequence number
+	 * by about a day rather than she wants to wait for years
+	 * using vertical blanks...
+	 */
+	DRM_WAIT_ON(ret, dev->vbl_queue, 3 * DRM_HZ,
+		    (((cur_vblank = atomic_read(&dev->vbl_received))
+		      - *sequence) <= (1 << 23)));
 
-void r128_disable_vblank(struct drm_device *dev, int crtc)
-{
-	if (crtc != 0)
-		DRM_ERROR("%s:  bad crtc %d\n", __FUNCTION__, crtc);
+	*sequence = cur_vblank;
 
-	/*
-	 * FIXME: implement proper interrupt disable by using the vblank
-	 * counter register (if available)
-	 *
-	 * R128_WRITE(R128_GEN_INT_CNTL,
-	 *            R128_READ(R128_GEN_INT_CNTL) & ~R128_CRTC_VBLANK_INT_EN);
-	 */
+	return ret;
 }
 
 void r128_driver_irq_preinstall(struct drm_device * dev)
@@ -100,9 +82,12 @@ void r128_driver_irq_preinstall(struct drm_device * dev)
 	R128_WRITE(R128_GEN_INT_STATUS, R128_CRTC_VBLANK_INT_AK);
 }
 
-int r128_driver_irq_postinstall(struct drm_device * dev)
+void r128_driver_irq_postinstall(struct drm_device * dev)
 {
-	return drm_vblank_init(dev, 1);
+	drm_r128_private_t *dev_priv = (drm_r128_private_t *) dev->dev_private;
+
+	/* Turn on VBL interrupt */
+	R128_WRITE(R128_GEN_INT_CNTL, R128_CRTC_VBLANK_INT_EN);
 }
 
 void r128_driver_irq_uninstall(struct drm_device * dev)
diff --git a/drivers/char/drm/radeon_drv.c b/drivers/char/drm/radeon_drv.c
index a261031..349ac3d 100644
--- a/drivers/char/drm/radeon_drv.c
+++ b/drivers/char/drm/radeon_drv.c
@@ -59,7 +59,8 @@ static struct pci_device_id pciidlist[] = {
 static struct drm_driver driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_USE_MTRR | DRIVER_PCI_DMA | DRIVER_SG |
-	    DRIVER_HAVE_IRQ | DRIVER_HAVE_DMA | DRIVER_IRQ_SHARED,
+	    DRIVER_HAVE_IRQ | DRIVER_HAVE_DMA | DRIVER_IRQ_SHARED |
+	    DRIVER_IRQ_VBL | DRIVER_IRQ_VBL2,
 	.dev_priv_size = sizeof(drm_radeon_buf_priv_t),
 	.load = radeon_driver_load,
 	.firstopen = radeon_driver_firstopen,
@@ -68,9 +69,8 @@ static struct drm_driver driver = {
 	.postclose = radeon_driver_postclose,
 	.lastclose = radeon_driver_lastclose,
 	.unload = radeon_driver_unload,
-	.get_vblank_counter = radeon_get_vblank_counter,
-	.enable_vblank = radeon_enable_vblank,
-	.disable_vblank = radeon_disable_vblank,
+	.vblank_wait = radeon_driver_vblank_wait,
+	.vblank_wait2 = radeon_driver_vblank_wait2,
 	.dri_library_name = dri_library_name,
 	.irq_preinstall = radeon_driver_irq_preinstall,
 	.irq_postinstall = radeon_driver_irq_postinstall,
diff --git a/drivers/char/drm/radeon_drv.h b/drivers/char/drm/radeon_drv.h
index b791420..173ae62 100644
--- a/drivers/char/drm/radeon_drv.h
+++ b/drivers/char/drm/radeon_drv.h
@@ -304,9 +304,6 @@ typedef struct drm_radeon_private {
 
 	u32 scratch_ages[5];
 
-	unsigned int crtc_last_cnt;
-	unsigned int crtc2_last_cnt;
-
 	/* starting from here on, data is preserved accross an open */
 	uint32_t flags;		/* see radeon_chip_flags */
 	unsigned long fb_aper_offset;
@@ -377,13 +374,13 @@ extern int radeon_irq_emit(struct drm_device *dev, void *data, struct drm_file *
 extern int radeon_irq_wait(struct drm_device *dev, void *data, struct drm_file *file_priv);
 
 extern void radeon_do_release(struct drm_device * dev);
-extern u32 radeon_get_vblank_counter(struct drm_device *dev, int crtc);
-extern int radeon_enable_vblank(struct drm_device *dev, int crtc);
-extern void radeon_disable_vblank(struct drm_device *dev, int crtc);
-extern void radeon_do_release(struct drm_device * dev);
+extern int radeon_driver_vblank_wait(struct drm_device * dev,
+				     unsigned int *sequence);
+extern int radeon_driver_vblank_wait2(struct drm_device * dev,
+				      unsigned int *sequence);
 extern irqreturn_t radeon_driver_irq_handler(DRM_IRQ_ARGS);
 extern void radeon_driver_irq_preinstall(struct drm_device * dev);
-extern int radeon_driver_irq_postinstall(struct drm_device * dev);
+extern void radeon_driver_irq_postinstall(struct drm_device * dev);
 extern void radeon_driver_irq_uninstall(struct drm_device * dev);
 extern int radeon_vblank_crtc_get(struct drm_device *dev);
 extern int radeon_vblank_crtc_set(struct drm_device *dev, int64_t value);
@@ -561,12 +558,6 @@ extern int r300_do_cp_cmdbuf(struct drm_device * dev,
 				? DRM_READ32( dev_priv->ring_rptr, RADEON_SCRATCHOFF(x) ) \
 				: RADEON_READ( RADEON_SCRATCH_REG0 + 4*(x) ) )
 
-#define RADEON_CRTC_CRNT_FRAME 0x0214
-#define RADEON_CRTC2_CRNT_FRAME 0x0314
-
-#define RADEON_CRTC_STATUS		0x005c
-#define RADEON_CRTC2_STATUS		0x03fc
-
 #define RADEON_GEN_INT_CNTL		0x0040
 #	define RADEON_CRTC_VBLANK_MASK		(1 << 0)
 #	define RADEON_CRTC2_VBLANK_MASK		(1 << 9)
diff --git a/drivers/char/drm/radeon_irq.c b/drivers/char/drm/radeon_irq.c
index 507d6b7..009af38 100644
--- a/drivers/char/drm/radeon_irq.c
+++ b/drivers/char/drm/radeon_irq.c
@@ -35,61 +35,12 @@
 #include "radeon_drm.h"
 #include "radeon_drv.h"
 
-static void radeon_irq_set_state(struct drm_device *dev, u32 mask, int state)
+static __inline__ u32 radeon_acknowledge_irqs(drm_radeon_private_t * dev_priv,
+					      u32 mask)
 {
-	drm_radeon_private_t *dev_priv = dev->dev_private;
-
-	if (state)
-		dev_priv->irq_enable_reg |= mask;
-	else
-		dev_priv->irq_enable_reg &= ~mask;
-
-	RADEON_WRITE(RADEON_GEN_INT_CNTL, dev_priv->irq_enable_reg);
-}
-
-int radeon_enable_vblank(struct drm_device *dev, int crtc)
-{
-	switch (crtc) {
-	case 0:
-		radeon_irq_set_state(dev, RADEON_CRTC_VBLANK_MASK, 1);
-		break;
-	case 1:
-		radeon_irq_set_state(dev, RADEON_CRTC2_VBLANK_MASK, 1);
-		break;
-	default:
-		DRM_ERROR("tried to enable vblank on non-existent crtc %d\n",
-			  crtc);
-		return EINVAL;
-	}
-
-	return 0;
-}
-
-void radeon_disable_vblank(struct drm_device *dev, int crtc)
-{
-	switch (crtc) {
-	case 0:
-		radeon_irq_set_state(dev, RADEON_CRTC_VBLANK_MASK, 0);
-		break;
-	case 1:
-		radeon_irq_set_state(dev, RADEON_CRTC2_VBLANK_MASK, 0);
-		break;
-	default:
-		DRM_ERROR("tried to enable vblank on non-existent crtc %d\n",
-			  crtc);
-		break;
-	}
-}
-
-static __inline__ u32 radeon_acknowledge_irqs(drm_radeon_private_t * dev_priv)
-{
-	u32 irqs = RADEON_READ(RADEON_GEN_INT_STATUS) &
-		(RADEON_SW_INT_TEST | RADEON_CRTC_VBLANK_STAT |
-		 RADEON_CRTC2_VBLANK_STAT);
-
+	u32 irqs = RADEON_READ(RADEON_GEN_INT_STATUS) & mask;
 	if (irqs)
 		RADEON_WRITE(RADEON_GEN_INT_STATUS, irqs);
-
 	return irqs;
 }
 
@@ -121,21 +72,39 @@ irqreturn_t radeon_driver_irq_handler(DRM_IRQ_ARGS)
 	/* Only consider the bits we're interested in - others could be used
 	 * outside the DRM
 	 */
-	stat = radeon_acknowledge_irqs(dev_priv);
+	stat = radeon_acknowledge_irqs(dev_priv, (RADEON_SW_INT_TEST_ACK |
+						  RADEON_CRTC_VBLANK_STAT |
+						  RADEON_CRTC2_VBLANK_STAT));
 	if (!stat)
 		return IRQ_NONE;
 
 	stat &= dev_priv->irq_enable_reg;
 
 	/* SW interrupt */
-	if (stat & RADEON_SW_INT_TEST)
+	if (stat & RADEON_SW_INT_TEST) {
 		DRM_WAKEUP(&dev_priv->swi_queue);
+	}
 
 	/* VBLANK interrupt */
-	if (stat & RADEON_CRTC_VBLANK_STAT)
-		drm_handle_vblank(dev, 0);
-	if (stat & RADEON_CRTC2_VBLANK_STAT)
-		drm_handle_vblank(dev, 1);
+	if (stat & (RADEON_CRTC_VBLANK_STAT|RADEON_CRTC2_VBLANK_STAT)) {
+		int vblank_crtc = dev_priv->vblank_crtc;
+
+		if ((vblank_crtc &
+		     (DRM_RADEON_VBLANK_CRTC1 | DRM_RADEON_VBLANK_CRTC2)) ==
+		    (DRM_RADEON_VBLANK_CRTC1 | DRM_RADEON_VBLANK_CRTC2)) {
+			if (stat & RADEON_CRTC_VBLANK_STAT)
+				atomic_inc(&dev->vbl_received);
+			if (stat & RADEON_CRTC2_VBLANK_STAT)
+				atomic_inc(&dev->vbl_received2);
+		} else if (((stat & RADEON_CRTC_VBLANK_STAT) &&
+			   (vblank_crtc & DRM_RADEON_VBLANK_CRTC1)) ||
+			   ((stat & RADEON_CRTC2_VBLANK_STAT) &&
+			    (vblank_crtc & DRM_RADEON_VBLANK_CRTC2)))
+			atomic_inc(&dev->vbl_received);
+
+		DRM_WAKEUP(&dev->vbl_queue);
+		drm_vbl_send_signals(dev);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -175,27 +144,54 @@ static int radeon_wait_irq(struct drm_device * dev, int swi_nr)
 	return ret;
 }
 
-u32 radeon_get_vblank_counter(struct drm_device *dev, int crtc)
+static int radeon_driver_vblank_do_wait(struct drm_device * dev,
+					unsigned int *sequence, int crtc)
 {
-	drm_radeon_private_t *dev_priv = dev->dev_private;
-	u32 crtc_cnt_reg, crtc_status_reg;
-
+	drm_radeon_private_t *dev_priv =
+	    (drm_radeon_private_t *) dev->dev_private;
+	unsigned int cur_vblank;
+	int ret = 0;
+	int ack = 0;
+	atomic_t *counter;
 	if (!dev_priv) {
 		DRM_ERROR("called with no initialization\n");
 		return -EINVAL;
 	}
 
-	if (crtc == 0) {
-		crtc_cnt_reg = RADEON_CRTC_CRNT_FRAME;
-		crtc_status_reg = RADEON_CRTC_STATUS;
-	} else if (crtc == 1) {
-		crtc_cnt_reg = RADEON_CRTC2_CRNT_FRAME;
-		crtc_status_reg = RADEON_CRTC2_STATUS;
-	} else {
+	if (crtc == DRM_RADEON_VBLANK_CRTC1) {
+		counter = &dev->vbl_received;
+		ack |= RADEON_CRTC_VBLANK_STAT;
+	} else if (crtc == DRM_RADEON_VBLANK_CRTC2) {
+		counter = &dev->vbl_received2;
+		ack |= RADEON_CRTC2_VBLANK_STAT;
+	} else
 		return -EINVAL;
-	}
 
-	return RADEON_READ(crtc_cnt_reg) + (RADEON_READ(crtc_status_reg) & 1);
+	radeon_acknowledge_irqs(dev_priv, ack);
+
+	dev_priv->stats.boxes |= RADEON_BOX_WAIT_IDLE;
+
+	/* Assume that the user has missed the current sequence number
+	 * by about a day rather than she wants to wait for years
+	 * using vertical blanks...
+	 */
+	DRM_WAIT_ON(ret, dev->vbl_queue, 3 * DRM_HZ,
+		    (((cur_vblank = atomic_read(counter))
+		      - *sequence) <= (1 << 23)));
+
+	*sequence = cur_vblank;
+
+	return ret;
+}
+
+int radeon_driver_vblank_wait(struct drm_device *dev, unsigned int *sequence)
+{
+	return radeon_driver_vblank_do_wait(dev, sequence, DRM_RADEON_VBLANK_CRTC1);
+}
+
+int radeon_driver_vblank_wait2(struct drm_device *dev, unsigned int *sequence)
+{
+	return radeon_driver_vblank_do_wait(dev, sequence, DRM_RADEON_VBLANK_CRTC2);
 }
 
 /* Needs the lock as it touches the ring.
@@ -238,6 +234,21 @@ int radeon_irq_wait(struct drm_device *dev, void *data, struct drm_file *file_pr
 	return radeon_wait_irq(dev, irqwait->irq_seq);
 }
 
+static void radeon_enable_interrupt(struct drm_device *dev)
+{
+	drm_radeon_private_t *dev_priv = (drm_radeon_private_t *) dev->dev_private;
+
+	dev_priv->irq_enable_reg = RADEON_SW_INT_ENABLE;
+	if (dev_priv->vblank_crtc & DRM_RADEON_VBLANK_CRTC1)
+		dev_priv->irq_enable_reg |= RADEON_CRTC_VBLANK_MASK;
+
+	if (dev_priv->vblank_crtc & DRM_RADEON_VBLANK_CRTC2)
+		dev_priv->irq_enable_reg |= RADEON_CRTC2_VBLANK_MASK;
+
+	RADEON_WRITE(RADEON_GEN_INT_CNTL, dev_priv->irq_enable_reg);
+	dev_priv->irq_enabled = 1;
+}
+
 /* drm_dma.h hooks
 */
 void radeon_driver_irq_preinstall(struct drm_device * dev)
@@ -249,27 +260,20 @@ void radeon_driver_irq_preinstall(struct drm_device * dev)
 	RADEON_WRITE(RADEON_GEN_INT_CNTL, 0);
 
 	/* Clear bits if they're already high */
-	radeon_acknowledge_irqs(dev_priv);
+	radeon_acknowledge_irqs(dev_priv, (RADEON_SW_INT_TEST_ACK |
+					   RADEON_CRTC_VBLANK_STAT |
+					   RADEON_CRTC2_VBLANK_STAT));
 }
 
-int radeon_driver_irq_postinstall(struct drm_device * dev)
+void radeon_driver_irq_postinstall(struct drm_device * dev)
 {
 	drm_radeon_private_t *dev_priv =
 	    (drm_radeon_private_t *) dev->dev_private;
-	int ret;
 
 	atomic_set(&dev_priv->swi_emitted, 0);
 	DRM_INIT_WAITQUEUE(&dev_priv->swi_queue);
 
-	ret = drm_vblank_init(dev, 2);
-	if (ret)
-		return ret;
-
-	dev->max_vblank_count = 0x001fffff;
-
-	radeon_irq_set_state(dev, RADEON_SW_INT_ENABLE, 1);
-
-	return 0;
+	radeon_enable_interrupt(dev);
 }
 
 void radeon_driver_irq_uninstall(struct drm_device * dev)
@@ -311,5 +315,6 @@ int radeon_vblank_crtc_set(struct drm_device *dev, int64_t value)
 		return -EINVAL;
 	}
 	dev_priv->vblank_crtc = (unsigned int)value;
+	radeon_enable_interrupt(dev);
 	return 0;
 }
diff --git a/drivers/char/drm/via_drv.c b/drivers/char/drm/via_drv.c
index 37870a4..80c01cd 100644
--- a/drivers/char/drm/via_drv.c
+++ b/drivers/char/drm/via_drv.c
@@ -40,13 +40,11 @@ static struct pci_device_id pciidlist[] = {
 static struct drm_driver driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_USE_MTRR | DRIVER_HAVE_IRQ |
-	    DRIVER_IRQ_SHARED,
+	    DRIVER_IRQ_SHARED | DRIVER_IRQ_VBL,
 	.load = via_driver_load,
 	.unload = via_driver_unload,
 	.context_dtor = via_final_context,
-	.get_vblank_counter = via_get_vblank_counter,
-	.enable_vblank = via_enable_vblank,
-	.disable_vblank = via_disable_vblank,
+	.vblank_wait = via_driver_vblank_wait,
 	.irq_preinstall = via_driver_irq_preinstall,
 	.irq_postinstall = via_driver_irq_postinstall,
 	.irq_uninstall = via_driver_irq_uninstall,
diff --git a/drivers/char/drm/via_drv.h b/drivers/char/drm/via_drv.h
index fe67030..2daae81 100644
--- a/drivers/char/drm/via_drv.h
+++ b/drivers/char/drm/via_drv.h
@@ -75,7 +75,6 @@ typedef struct drm_via_private {
 	struct timeval last_vblank;
 	int last_vblank_valid;
 	unsigned usec_per_vblank;
-	atomic_t vbl_received;
 	drm_via_state_t hc_state;
 	char pci_buf[VIA_PCI_BUF_SIZE];
 	const uint32_t *fire_offsets[VIA_FIRE_BUF_SIZE];
@@ -131,13 +130,11 @@ extern int via_init_context(struct drm_device * dev, int context);
 extern int via_final_context(struct drm_device * dev, int context);
 
 extern int via_do_cleanup_map(struct drm_device * dev);
-extern u32 via_get_vblank_counter(struct drm_device *dev, int crtc);
-extern int via_enable_vblank(struct drm_device *dev, int crtc);
-extern void via_disable_vblank(struct drm_device *dev, int crtc);
+extern int via_driver_vblank_wait(struct drm_device * dev, unsigned int *sequence);
 
 extern irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS);
 extern void via_driver_irq_preinstall(struct drm_device * dev);
-extern int via_driver_irq_postinstall(struct drm_device * dev);
+extern void via_driver_irq_postinstall(struct drm_device * dev);
 extern void via_driver_irq_uninstall(struct drm_device * dev);
 
 extern int via_dma_cleanup(struct drm_device * dev);
diff --git a/drivers/char/drm/via_irq.c b/drivers/char/drm/via_irq.c
index f1ab6fc..c6bb978 100644
--- a/drivers/char/drm/via_irq.c
+++ b/drivers/char/drm/via_irq.c
@@ -92,17 +92,8 @@ static int via_irqmap_unichrome[] = {-1, -1, -1, 0, -1, 1};
 static unsigned time_diff(struct timeval *now, struct timeval *then)
 {
 	return (now->tv_usec >= then->tv_usec) ?
-		now->tv_usec - then->tv_usec :
-		1000000 - (then->tv_usec - now->tv_usec);
-}
-
-u32 via_get_vblank_counter(struct drm_device *dev, int crtc)
-{
-	drm_via_private_t *dev_priv = dev->dev_private;
-	if (crtc != 0)
-		return 0;
-
-	return atomic_read(&dev_priv->vbl_received);
+	    now->tv_usec - then->tv_usec :
+	    1000000 - (then->tv_usec - now->tv_usec);
 }
 
 irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS)
@@ -117,8 +108,8 @@ irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS)
 
 	status = VIA_READ(VIA_REG_INTERRUPT);
 	if (status & VIA_IRQ_VBLANK_PENDING) {
-		atomic_inc(&dev_priv->vbl_received);
-		if (!(atomic_read(&dev_priv->vbl_received) & 0x0F)) {
+		atomic_inc(&dev->vbl_received);
+		if (!(atomic_read(&dev->vbl_received) & 0x0F)) {
 			do_gettimeofday(&cur_vblank);
 			if (dev_priv->last_vblank_valid) {
 				dev_priv->usec_per_vblank =
@@ -128,11 +119,12 @@ irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS)
 			dev_priv->last_vblank = cur_vblank;
 			dev_priv->last_vblank_valid = 1;
 		}
-		if (!(atomic_read(&dev_priv->vbl_received) & 0xFF)) {
+		if (!(atomic_read(&dev->vbl_received) & 0xFF)) {
 			DRM_DEBUG("US per vblank is: %u\n",
 				  dev_priv->usec_per_vblank);
 		}
-		drm_handle_vblank(dev, 0);
+		DRM_WAKEUP(&dev->vbl_queue);
+		drm_vbl_send_signals(dev);
 		handled = 1;
 	}
 
@@ -171,34 +163,31 @@ static __inline__ void viadrv_acknowledge_irqs(drm_via_private_t * dev_priv)
 	}
 }
 
-int via_enable_vblank(struct drm_device *dev, int crtc)
+int via_driver_vblank_wait(struct drm_device * dev, unsigned int *sequence)
 {
-	drm_via_private_t *dev_priv = dev->dev_private;
-	u32 status;
+	drm_via_private_t *dev_priv = (drm_via_private_t *) dev->dev_private;
+	unsigned int cur_vblank;
+	int ret = 0;
 
-	if (crtc != 0) {
-		DRM_ERROR("%s:  bad crtc %d\n", __FUNCTION__, crtc);
+	DRM_DEBUG("\n");
+	if (!dev_priv) {
+		DRM_ERROR("called with no initialization\n");
 		return -EINVAL;
 	}
 
-	status = VIA_READ(VIA_REG_INTERRUPT);
-	VIA_WRITE(VIA_REG_INTERRUPT, status & VIA_IRQ_VBLANK_ENABLE);
+	viadrv_acknowledge_irqs(dev_priv);
 
-	VIA_WRITE8(0x83d4, 0x11);
-	VIA_WRITE8(0x83d5, VIA_READ8(0x83d5) | 0x30);
+	/* Assume that the user has missed the current sequence number
+	 * by about a day rather than she wants to wait for years
+	 * using vertical blanks...
+	 */
 
-	return 0;
-}
+	DRM_WAIT_ON(ret, dev->vbl_queue, 3 * DRM_HZ,
+		    (((cur_vblank = atomic_read(&dev->vbl_received)) -
+		      *sequence) <= (1 << 23)));
 
-void via_disable_vblank(struct drm_device *dev, int crtc)
-{
-	drm_via_private_t *dev_priv = dev->dev_private;
-
-	VIA_WRITE8(0x83d4, 0x11);
-	VIA_WRITE8(0x83d5, VIA_READ8(0x83d5) & ~0x30);
-
-	if (crtc != 0)
-		DRM_ERROR("%s:  bad crtc %d\n", __FUNCTION__, crtc);
+	*sequence = cur_vblank;
+	return ret;
 }
 
 static int
@@ -303,25 +292,23 @@ void via_driver_irq_preinstall(struct drm_device * dev)
 	}
 }
 
-int via_driver_irq_postinstall(struct drm_device * dev)
+void via_driver_irq_postinstall(struct drm_device * dev)
 {
 	drm_via_private_t *dev_priv = (drm_via_private_t *) dev->dev_private;
 	u32 status;
 
-	DRM_DEBUG("via_driver_irq_postinstall\n");
-	if (!dev_priv)
-		return -EINVAL;
+	DRM_DEBUG("\n");
+	if (dev_priv) {
+		status = VIA_READ(VIA_REG_INTERRUPT);
+		VIA_WRITE(VIA_REG_INTERRUPT, status | VIA_IRQ_GLOBAL
+			  | dev_priv->irq_enable_mask);
 
-	drm_vblank_init(dev, 1);
-	status = VIA_READ(VIA_REG_INTERRUPT);
-	VIA_WRITE(VIA_REG_INTERRUPT, status | VIA_IRQ_GLOBAL
-		  | dev_priv->irq_enable_mask);
+		/* Some magic, oh for some data sheets ! */
 
-	/* Some magic, oh for some data sheets ! */
-	VIA_WRITE8(0x83d4, 0x11);
-	VIA_WRITE8(0x83d5, VIA_READ8(0x83d5) | 0x30);
+		VIA_WRITE8(0x83d4, 0x11);
+		VIA_WRITE8(0x83d5, VIA_READ8(0x83d5) | 0x30);
 
-	return 0;
+	}
 }
 
 void via_driver_irq_uninstall(struct drm_device * dev)
