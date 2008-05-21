Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbYEUIlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbYEUIlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761747AbYEUIk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:40:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764568AbYEUIkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:40:53 -0400
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       mingo@redhat.com, akpm@linux-foundation.org,
       Pat Campbell <plc@novell.com>
Subject: [PATCH 5/5] xen pvfb: Dynamic mode support (screen resizing)
References: <87d4ngm4s4.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 21 May 2008 10:40:36 +0200
Message-ID: <87zlqkkq2j.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pvfb backend indicates dynamic mode support by creating node
feature_resize with a non-zero value in its xenstore directory.
xen-fbfront sends a resize notification event on mode change.  Fully
backwards compatible both ways.

Framebuffer size and initial resolution can be controlled through
kernel parameter xen_fbfront.video.  The backend enforces a separate
size limit, which it advertises in node videoram in its xenstore
directory.

xen-kbdfront gets the maximum screen resolution from nodes width and
height in the backend's xenstore directory instead of hardcoding it.

Additional goodie: support for larger framebuffers (512M on a 64-bit
system with 4K pages).

Changing the number of bits per pixels dynamically is not supported,
yet.

Ported from
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/92f7b3144f41
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/bfc040135633

Signed-off-by: Pat Campbell <plc@novell.com>
Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 drivers/input/xen-kbdfront.c    |   10 ++
 drivers/video/xen-fbfront.c     |  183 ++++++++++++++++++++++++++++++++------
 include/xen/interface/io/fbif.h |   29 +++++-
 3 files changed, 188 insertions(+), 34 deletions(-)

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index eaf69cf..9ce3b3b 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -300,6 +300,16 @@ InitWait:
 		 */
 		if (dev->state != XenbusStateConnected)
 			goto InitWait; /* no InitWait seen yet, fudge it */
+
+		/* Set input abs params to match backend screen res */
+		if (xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				 "width", "%d", &val) > 0)
+			input_set_abs_params(info->ptr, ABS_X, 0, val, 0, 0);
+
+		if (xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				 "height", "%d", &val) > 0)
+			input_set_abs_params(info->ptr, ABS_Y, 0, val, 0, 0);
+
 		break;
 
 	case XenbusStateClosing:
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 291eef6..47ed39b 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -43,23 +43,47 @@ struct xenfb_info {
 	struct xenfb_page	*page;
 	unsigned long 		*mfns;
 	int			update_wanted; /* XENFB_TYPE_UPDATE wanted */
+	int			feature_resize; /* XENFB_TYPE_RESIZE ok */
+	struct xenfb_resize	resize;		/* protected by resize_lock */
+	int			resize_dpy;	/* ditto */
+	spinlock_t		resize_lock;
 
 	struct xenbus_device	*xbdev;
 };
 
-static u32 xenfb_mem_len = XENFB_WIDTH * XENFB_HEIGHT * XENFB_DEPTH / 8;
+#define XENFB_DEFAULT_FB_LEN (XENFB_WIDTH * XENFB_HEIGHT * XENFB_DEPTH / 8)
+
+enum { KPARAM_MEM, KPARAM_WIDTH, KPARAM_HEIGHT, KPARAM_CNT };
+static int video[KPARAM_CNT] = { 2, XENFB_WIDTH, XENFB_HEIGHT };
+module_param_array(video, int, NULL, 0);
+MODULE_PARM_DESC(video,
+	"Video memory size in MB, width, height in pixels (default 2,800,600)");
 
 static void xenfb_make_preferred_console(void);
 static int xenfb_remove(struct xenbus_device *);
-static void xenfb_init_shared_page(struct xenfb_info *);
+static void xenfb_init_shared_page(struct xenfb_info *, struct fb_info *);
 static int xenfb_connect_backend(struct xenbus_device *, struct xenfb_info *);
 static void xenfb_disconnect_backend(struct xenfb_info *);
 
+static void xenfb_send_event(struct xenfb_info *info,
+			     union xenfb_out_event *event)
+{
+	u32 prod;
+
+	prod = info->page->out_prod;
+	/* caller ensures !xenfb_queue_full() */
+	mb();			/* ensure ring space available */
+	XENFB_OUT_RING_REF(info->page, prod) = *event;
+	wmb();			/* ensure ring contents visible */
+	info->page->out_prod = prod + 1;
+
+	notify_remote_via_irq(info->irq);
+}
+
 static void xenfb_do_update(struct xenfb_info *info,
 			    int x, int y, int w, int h)
 {
 	union xenfb_out_event event;
-	u32 prod;
 
 	memset(&event, 0, sizeof(event));
 	event.type = XENFB_TYPE_UPDATE;
@@ -68,14 +92,19 @@ static void xenfb_do_update(struct xenfb_info *info,
 	event.update.width = w;
 	event.update.height = h;
 
-	prod = info->page->out_prod;
 	/* caller ensures !xenfb_queue_full() */
-	mb();			/* ensure ring space available */
-	XENFB_OUT_RING_REF(info->page, prod) = event;
-	wmb();			/* ensure ring contents visible */
-	info->page->out_prod = prod + 1;
+	xenfb_send_event(info, &event);
+}
 
-	notify_remote_via_irq(info->irq);
+static void xenfb_do_resize(struct xenfb_info *info)
+{
+	union xenfb_out_event event;
+
+	memset(&event, 0, sizeof(event));
+	event.resize = info->resize;
+
+	/* caller ensures !xenfb_queue_full() */
+	xenfb_send_event(info, &event);
 }
 
 static int xenfb_queue_full(struct xenfb_info *info)
@@ -87,12 +116,28 @@ static int xenfb_queue_full(struct xenfb_info *info)
 	return prod - cons == XENFB_OUT_RING_LEN;
 }
 
+static void xenfb_handle_resize_dpy(struct xenfb_info *info)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->resize_lock, flags);
+	if (info->resize_dpy) {
+		if (!xenfb_queue_full(info)) {
+			info->resize_dpy = 0;
+			xenfb_do_resize(info);
+		}
+	}
+	spin_unlock_irqrestore(&info->resize_lock, flags);
+}
+
 static void xenfb_refresh(struct xenfb_info *info,
 			  int x1, int y1, int w, int h)
 {
 	unsigned long flags;
-	int y2 = y1 + h - 1;
 	int x2 = x1 + w - 1;
+	int y2 = y1 + h - 1;
+
+	xenfb_handle_resize_dpy(info);
 
 	if (!info->update_wanted)
 		return;
@@ -225,6 +270,57 @@ static ssize_t xenfb_write(struct fb_info *p, const char __user *buf,
 	return res;
 }
 
+static int
+xenfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct xenfb_info *xenfb_info;
+	int required_mem_len;
+
+	xenfb_info = info->par;
+
+	if (!xenfb_info->feature_resize) {
+		if (var->xres == video[KPARAM_WIDTH] &&
+		    var->yres == video[KPARAM_HEIGHT] &&
+		    var->bits_per_pixel == xenfb_info->page->depth) {
+			return 0;
+		}
+		return -EINVAL;
+	}
+
+	/* Can't resize past initial width and height */
+	if (var->xres > video[KPARAM_WIDTH] || var->yres > video[KPARAM_HEIGHT])
+		return -EINVAL;
+
+	required_mem_len = var->xres * var->yres * xenfb_info->page->depth / 8;
+	if (var->bits_per_pixel == xenfb_info->page->depth &&
+	    var->xres <= info->fix.line_length / (XENFB_DEPTH / 8) &&
+	    required_mem_len <= info->fix.smem_len) {
+		var->xres_virtual = var->xres;
+		var->yres_virtual = var->yres;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int xenfb_set_par(struct fb_info *info)
+{
+	struct xenfb_info *xenfb_info;
+	unsigned long flags;
+
+	xenfb_info = info->par;
+
+	spin_lock_irqsave(&xenfb_info->resize_lock, flags);
+	xenfb_info->resize.type = XENFB_TYPE_RESIZE;
+	xenfb_info->resize.width = info->var.xres;
+	xenfb_info->resize.height = info->var.yres;
+	xenfb_info->resize.stride = info->fix.line_length;
+	xenfb_info->resize.depth = info->var.bits_per_pixel;
+	xenfb_info->resize.offset = 0;
+	xenfb_info->resize_dpy = 1;
+	spin_unlock_irqrestore(&xenfb_info->resize_lock, flags);
+	return 0;
+}
+
 static struct fb_ops xenfb_fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_read	= fb_sys_read,
@@ -233,6 +329,8 @@ static struct fb_ops xenfb_fb_ops = {
 	.fb_fillrect	= xenfb_fillrect,
 	.fb_copyarea	= xenfb_copyarea,
 	.fb_imageblit	= xenfb_imageblit,
+	.fb_check_var	= xenfb_check_var,
+	.fb_set_par     = xenfb_set_par,
 };
 
 static irqreturn_t xenfb_event_handler(int rq, void *dev_id)
@@ -261,6 +359,8 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 {
 	struct xenfb_info *info;
 	struct fb_info *fb_info;
+	int fb_size;
+	int val;
 	int ret;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -268,18 +368,35 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
 		return -ENOMEM;
 	}
+
+	/* Limit kernel param videoram amount to what is in xenstore */
+	if (xenbus_scanf(XBT_NIL, dev->otherend, "videoram", "%d", &val) == 1) {
+		if (val < video[KPARAM_MEM])
+			video[KPARAM_MEM] = val;
+	}
+
+	/* If requested res does not fit in available memory, use default */
+	fb_size = video[KPARAM_MEM] * 1024 * 1024;
+	if (video[KPARAM_WIDTH] * video[KPARAM_HEIGHT] * XENFB_DEPTH / 8
+	    > fb_size) {
+		video[KPARAM_WIDTH] = XENFB_WIDTH;
+		video[KPARAM_HEIGHT] = XENFB_HEIGHT;
+		fb_size = XENFB_DEFAULT_FB_LEN;
+	}
+
 	dev->dev.driver_data = info;
 	info->xbdev = dev;
 	info->irq = -1;
 	info->x1 = info->y1 = INT_MAX;
 	spin_lock_init(&info->dirty_lock);
+	spin_lock_init(&info->resize_lock);
 
-	info->fb = vmalloc(xenfb_mem_len);
+	info->fb = vmalloc(fb_size);
 	if (info->fb == NULL)
 		goto error_nomem;
-	memset(info->fb, 0, xenfb_mem_len);
+	memset(info->fb, 0, fb_size);
 
-	info->nr_pages = (xenfb_mem_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	info->nr_pages = (fb_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	info->mfns = vmalloc(sizeof(unsigned long) * info->nr_pages);
 	if (!info->mfns)
@@ -290,8 +407,6 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	if (!info->page)
 		goto error_nomem;
 
-	xenfb_init_shared_page(info);
-
 	/* abusing framebuffer_alloc() to allocate pseudo_palette */
 	fb_info = framebuffer_alloc(sizeof(u32) * 256, NULL);
 	if (fb_info == NULL)
@@ -304,9 +419,9 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	fb_info->screen_base = info->fb;
 
 	fb_info->fbops = &xenfb_fb_ops;
-	fb_info->var.xres_virtual = fb_info->var.xres = info->page->width;
-	fb_info->var.yres_virtual = fb_info->var.yres = info->page->height;
-	fb_info->var.bits_per_pixel = info->page->depth;
+	fb_info->var.xres_virtual = fb_info->var.xres = video[KPARAM_WIDTH];
+	fb_info->var.yres_virtual = fb_info->var.yres = video[KPARAM_HEIGHT];
+	fb_info->var.bits_per_pixel = XENFB_DEPTH;
 
 	fb_info->var.red = (struct fb_bitfield){16, 8, 0};
 	fb_info->var.green = (struct fb_bitfield){8, 8, 0};
@@ -318,9 +433,9 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	fb_info->var.vmode = FB_VMODE_NONINTERLACED;
 
 	fb_info->fix.visual = FB_VISUAL_TRUECOLOR;
-	fb_info->fix.line_length = info->page->line_length;
+	fb_info->fix.line_length = fb_info->var.xres * XENFB_DEPTH / 8;
 	fb_info->fix.smem_start = 0;
-	fb_info->fix.smem_len = xenfb_mem_len;
+	fb_info->fix.smem_len = fb_size;
 	strcpy(fb_info->fix.id, "xen");
 	fb_info->fix.type = FB_TYPE_PACKED_PIXELS;
 	fb_info->fix.accel = FB_ACCEL_NONE;
@@ -337,6 +452,8 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	fb_info->fbdefio = &xenfb_defio;
 	fb_deferred_io_init(fb_info);
 
+	xenfb_init_shared_page(info, fb_info);
+
 	ret = register_framebuffer(fb_info);
 	if (ret) {
 		fb_deferred_io_cleanup(fb_info);
@@ -389,7 +506,7 @@ static int xenfb_resume(struct xenbus_device *dev)
 	struct xenfb_info *info = dev->dev.driver_data;
 
 	xenfb_disconnect_backend(info);
-	xenfb_init_shared_page(info);
+	xenfb_init_shared_page(info, info->fb_info);
 	return xenfb_connect_backend(dev, info);
 }
 
@@ -417,20 +534,23 @@ static unsigned long vmalloc_to_mfn(void *address)
 	return pfn_to_mfn(vmalloc_to_pfn(address));
 }
 
-static void xenfb_init_shared_page(struct xenfb_info *info)
+static void xenfb_init_shared_page(struct xenfb_info *info,
+				   struct fb_info *fb_info)
 {
 	int i;
+	int epd = PAGE_SIZE / sizeof(info->mfns[0]);
 
 	for (i = 0; i < info->nr_pages; i++)
 		info->mfns[i] = vmalloc_to_mfn(info->fb + i * PAGE_SIZE);
 
-	info->page->pd[0] = vmalloc_to_mfn(info->mfns);
-	info->page->pd[1] = 0;
-	info->page->width = XENFB_WIDTH;
-	info->page->height = XENFB_HEIGHT;
-	info->page->depth = XENFB_DEPTH;
-	info->page->line_length = (info->page->depth / 8) * info->page->width;
-	info->page->mem_length = xenfb_mem_len;
+	for (i = 0; i * epd < info->nr_pages; i++)
+		info->page->pd[i] = vmalloc_to_mfn(&info->mfns[i * epd]);
+
+	info->page->width = fb_info->var.xres;
+	info->page->height = fb_info->var.yres;
+	info->page->depth = fb_info->var.bits_per_pixel;
+	info->page->line_length = fb_info->fix.line_length;
+	info->page->mem_length = fb_info->fix.smem_len;
 	info->page->in_cons = info->page->in_prod = 0;
 	info->page->out_cons = info->page->out_prod = 0;
 }
@@ -530,6 +650,11 @@ InitWait:
 			val = 0;
 		if (val)
 			info->update_wanted = 1;
+
+		if (xenbus_scanf(XBT_NIL, dev->otherend,
+				 "feature-resize", "%d", &val) < 0)
+			val = 0;
+		info->feature_resize = val;
 		break;
 
 	case XenbusStateClosing:
diff --git a/include/xen/interface/io/fbif.h b/include/xen/interface/io/fbif.h
index 5a934dd..974a51e 100644
--- a/include/xen/interface/io/fbif.h
+++ b/include/xen/interface/io/fbif.h
@@ -49,11 +49,27 @@ struct xenfb_update {
 	int32_t height;		/* rect height */
 };
 
+/*
+ * Framebuffer resize notification event
+ * Capable backend sets feature-resize in xenstore.
+ */
+#define XENFB_TYPE_RESIZE 3
+
+struct xenfb_resize {
+	uint8_t type;		/* XENFB_TYPE_RESIZE */
+	int32_t width;		/* width in pixels */
+	int32_t height;		/* height in pixels */
+	int32_t stride;		/* stride in bytes */
+	int32_t depth;		/* depth in bits */
+	int32_t offset;		/* start offset within framebuffer */
+};
+
 #define XENFB_OUT_EVENT_SIZE 40
 
 union xenfb_out_event {
 	uint8_t type;
 	struct xenfb_update update;
+	struct xenfb_resize resize;
 	char pad[XENFB_OUT_EVENT_SIZE];
 };
 
@@ -105,15 +121,18 @@ struct xenfb_page {
 	 * Each directory page holds PAGE_SIZE / sizeof(*pd)
 	 * framebuffer pages, and can thus map up to PAGE_SIZE *
 	 * PAGE_SIZE / sizeof(*pd) bytes.  With PAGE_SIZE == 4096 and
-	 * sizeof(unsigned long) == 4, that's 4 Megs.  Two directory
-	 * pages should be enough for a while.
+	 * sizeof(unsigned long) == 4/8, that's 4 Megs 32 bit and 2
+	 * Megs 64 bit.  256 directories give enough room for a 512
+	 * Meg framebuffer with a max resolution of 12,800x10,240.
+	 * Should be enough for a while with room leftover for
+	 * expansion.
 	 */
-	unsigned long pd[2];
+	unsigned long pd[256];
 };
 
 /*
- * Wart: xenkbd needs to know resolution.  Put it here until a better
- * solution is found, but don't leak it to the backend.
+ * Wart: xenkbd needs to know default resolution.  Put it here until a
+ * better solution is found, but don't leak it to the backend.
  */
 #ifdef __KERNEL__
 #define XENFB_WIDTH 800
-- 
1.5.3.3

