Return-Path: <linux-kernel-owner+w=401wt.eu-S965375AbZLQTOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375AbZLQTOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965354AbZLQTOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:14:32 -0500
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:36984 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965366AbZLQTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:14:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zfuc2OPPbmV3EsoxreriOFI54YsSU3WLSuZcJ3pRJkCL0Qh6yg53vS3pgwk1e6Fcoshg9p/b0A3kR0ZNhNjorE/W2OvD8T/ovP9OFq+R0pFDFm8eE/vEKHe5mrNavUiJ;
Date: Thu, 17 Dec 2009 11:13:59 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091217111359.54f4c518@jbarnes-piketon>
In-Reply-To: <200912171852.02906.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	<200912162241.27591.arnd@arndb.de>
	<20091217092523.755ecf29@jbarnes-piketon>
	<200912171852.02906.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 18:52:02 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 17 December 2009, Jesse Barnes wrote:
> > It does very little else that should affect things.  You're sure
> > reverting the commit makes things ok?
> 
> No, not sure. But I've been running the kernel before that commit
> for days without ever seeing a crash. 2.6.31 (also without that
> commit but otherwise pretty similar) has been stable for weeks
> weeks on the same box.
> 
> Once any given kernel version crashes, which can take up to
> a day while I'm waiting for the bug to show up, it will typically
> crash on that same kernel again within seconds after boot,
> just to annoy me and prevent me from using that kernel for
> other things.
> 
> > Other potential problems:
> >   - clock gating (the call to intel_init_clock_gating)
> >   - the actual mark_busy stuff itself (calls to intel_mark_busy)
> >   - intel_idle_update (but powersave=0 should prevent that)
> > 
> > If you want to keep testing you could try removing those calls...
> 
> Ok, I'll try that. The problem is keeping me from doing any useful
> upstream kernel work on my main machine, so I'm rather motivated ;-)

Another patch to try...

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 279dc96..b8ca398 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3779,125 +3779,6 @@ static void intel_gpu_idle_timer(unsigned long arg)
 	queue_work(dev_priv->wq, &dev_priv->idle_work);
 }
 
-void intel_increase_renderclock(struct drm_device *dev, bool schedule)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-
-	if (IS_IRONLAKE(dev))
-		return;
-
-	if (!dev_priv->render_reclock_avail) {
-		DRM_DEBUG_DRIVER("not reclocking render clock\n");
-		return;
-	}
-
-	/* Restore render clock frequency to original value */
-	if (IS_G4X(dev) || IS_I9XX(dev))
-		pci_write_config_word(dev->pdev, GCFGC, dev_priv->orig_clock);
-	else if (IS_I85X(dev))
-		pci_write_config_word(dev->pdev, HPLLCC, dev_priv->orig_clock);
-	DRM_DEBUG_DRIVER("increasing render clock frequency\n");
-
-	/* Schedule downclock */
-	if (schedule)
-		mod_timer(&dev_priv->idle_timer, jiffies +
-			  msecs_to_jiffies(GPU_IDLE_TIMEOUT));
-}
-
-void intel_decrease_renderclock(struct drm_device *dev)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-
-	if (IS_IRONLAKE(dev))
-		return;
-
-	if (!dev_priv->render_reclock_avail) {
-		DRM_DEBUG_DRIVER("not reclocking render clock\n");
-		return;
-	}
-
-	if (IS_G4X(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~GM45_GC_RENDER_CLOCK_MASK;
-		gcfgc |= GM45_GC_RENDER_CLOCK_266_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I965G(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~I965_GC_RENDER_CLOCK_MASK;
-		gcfgc |= I965_GC_RENDER_CLOCK_267_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I945G(dev) || IS_I945GM(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~I945_GC_RENDER_CLOCK_MASK;
-		gcfgc |= I945_GC_RENDER_CLOCK_166_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I915G(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~I915_GC_RENDER_CLOCK_MASK;
-		gcfgc |= I915_GC_RENDER_CLOCK_166_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I85X(dev)) {
-		u16 hpllcc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, HPLLCC, &hpllcc);
-
-		/* Up to maximum... */
-		hpllcc &= ~GC_CLOCK_CONTROL_MASK;
-		hpllcc |= GC_CLOCK_133_200;
-
-		pci_write_config_word(dev->pdev, HPLLCC, hpllcc);
-	}
-	DRM_DEBUG_DRIVER("decreasing render clock frequency\n");
-}
-
-/* Note that no increase function is needed for this - increase_renderclock()
- *  will also rewrite these bits
- */
-void intel_decrease_displayclock(struct drm_device *dev)
-{
-	if (IS_IRONLAKE(dev))
-		return;
-
-	if (IS_I945G(dev) || IS_I945GM(dev) || IS_I915G(dev) ||
-	    IS_I915GM(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~0xf0;
-		gcfgc |= 0x80;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	}
-}
-
 #define CRTC_IDLE_TIMEOUT 1000 /* ms */
 
 static void intel_crtc_idle_timer(unsigned long arg)
@@ -4011,12 +3892,6 @@ static void intel_idle_update(struct work_struct *work)
 
 	mutex_lock(&dev->struct_mutex);
 
-	/* GPU isn't processing, downclock it. */
-	if (!dev_priv->busy) {
-		intel_decrease_renderclock(dev);
-		intel_decrease_displayclock(dev);
-	}
-
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		/* Skip inactive CRTCs */
 		if (!crtc->fb)
@@ -4050,13 +3925,11 @@ void intel_mark_busy(struct drm_device *dev, struct drm_gem_object *obj)
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return;
 
-	if (!dev_priv->busy) {
+	if (!dev_priv->busy)
 		dev_priv->busy = true;
-		intel_increase_renderclock(dev, true);
-	} else {
+	else
 		mod_timer(&dev_priv->idle_timer, jiffies +
 			  msecs_to_jiffies(GPU_IDLE_TIMEOUT));
-	}
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		if (!crtc->fb)
@@ -4770,7 +4643,6 @@ void intel_modeset_cleanup(struct drm_device *dev)
 		del_timer_sync(&intel_crtc->idle_timer);
 	}
 
-	intel_increase_renderclock(dev, false);
 	del_timer_sync(&dev_priv->idle_timer);
 
 	if (dev_priv->display.disable_fbc)
