Return-Path: <linux-kernel-owner+w=401wt.eu-S1764333AbZCTXjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764333AbZCTXjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761750AbZCTXY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:57 -0400
Received: from kroah.org ([198.145.64.141]:48825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761670AbZCTXY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:29 2009
Message-Id: <20090320222928.879548230@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:48 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: [patch 38/43] drm/i915: set vblank enabled flag correctly across IRQ install/uninstall
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-set-vblank-enabled-flag-correctly-across-irq-install-uninstall.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit dc1336ff4fe08ae7cfe8301bfd7f0b2cfd31d20a upstream.

In the absence of kernel mode setting, many drivers disable IRQs across VT
switch.  The core DRM vblank code is missing a check for this case however;
even after IRQ disable, the vblank code will still have the vblank_enabled
flag set, so unless we track the fact that they're disabled at IRQ uninstall
time, when we VT switch back in we won't actually re-enable them, which means
any apps waiting on vblank before the switch will hang.

This patch does that and also adds a sanity check to the wait condition to
look for the irq_enabled flag in general, as well as adding a wakeup to the
IRQ uninstall path.

Fixes fdo bug #18879 with compiz hangs at VT switch.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_irq.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -259,7 +259,8 @@ EXPORT_SYMBOL(drm_irq_install);
  */
 int drm_irq_uninstall(struct drm_device * dev)
 {
-	int irq_enabled;
+	unsigned long irqflags;
+	int irq_enabled, i;
 
 	if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ))
 		return -EINVAL;
@@ -269,6 +270,16 @@ int drm_irq_uninstall(struct drm_device 
 	dev->irq_enabled = 0;
 	mutex_unlock(&dev->struct_mutex);
 
+	/*
+	 * Wake up any waiters so they don't hang.
+	 */
+	spin_lock_irqsave(&dev->vbl_lock, irqflags);
+	for (i = 0; i < dev->num_crtcs; i++) {
+		DRM_WAKEUP(&dev->vbl_queue[i]);
+		dev->vblank_enabled[i] = 0;
+	}
+	spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
+
 	if (!irq_enabled)
 		return -EINVAL;
 
@@ -617,8 +628,9 @@ int drm_wait_vblank(struct drm_device *d
 		DRM_DEBUG("waiting on vblank count %d, crtc %d\n",
 			  vblwait->request.sequence, crtc);
 		DRM_WAIT_ON(ret, dev->vbl_queue[crtc], 3 * DRM_HZ,
-			    ((drm_vblank_count(dev, crtc)
-			      - vblwait->request.sequence) <= (1 << 23)));
+			    (((drm_vblank_count(dev, crtc) -
+			       vblwait->request.sequence) <= (1 << 23)) ||
+			     !dev->irq_enabled));
 
 		if (ret != -EINTR) {
 			struct timeval now;


