Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435Ab0ADRXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0ADRXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617Ab0ADRXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:23:39 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:58894 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751551Ab0ADRXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:23:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=k6vxLTCkYlC1V9qy6/u266oCnoX55CLntn5IMpjSHJWT0K2KpFXJz2gX4oj5xZQeVGu5QD5WF96yfFgHie2dmflJvyd3xJAqRzOMjSMtLiURokpNZ0m6XxQIc6W19GiU;
Date: Mon, 4 Jan 2010 09:23:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 33/37] drm: add KGDB/KDB support Add support for KDB
 entry/exit.
Message-ID: <20100104092335.7c52f249@jbarnes-piketon>
In-Reply-To: <1261604584-5796-1-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-33-git-send-email-jason.wessel@windriver.com>
	<1261604584-5796-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you send this one over to Dave Airlie <airlied@linux.ie>?  At KS he
indicated he'd be happy to just apply it, since other drivers will need
it too (along with the driver specific code of course).

Jesse

On Wed, 23 Dec 2009 15:43:00 -0600
Jason Wessel <jason.wessel@windriver.com> wrote:

> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> ---
>  drivers/gpu/drm/drm_fb_helper.c      |   83
> ++++++++++++++++++++++++++++++ drivers/gpu/drm/i915/intel_display.c
> |   93 ++++++++++++++++++++++++++++++++++
> include/drm/drm_crtc_helper.h        |    2 +
> include/drm/drm_fb_helper.h          |    4 ++ 4 files changed, 182
> insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c
> b/drivers/gpu/drm/drm_fb_helper.c index 1b49fa0..80aab3c 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -29,6 +29,7 @@
>   */
>  #include <linux/sysrq.h>
>  #include <linux/fb.h>
> +#include <linux/kgdb.h>
>  #include "drmP.h"
>  #include "drm_crtc.h"
>  #include "drm_fb_helper.h"
> @@ -233,6 +234,84 @@ int drm_fb_helper_parse_command_line(struct
> drm_device *dev) return 0;
>  }
>  
> +#define to_fb_helper(ops) (container_of((ops), struct drm_fb_helper,
> kdb_ops)) +
> +static int drm_fb_kdb_enter(struct dbg_kms_console_ops *ops)
> +{
> +	struct drm_fb_helper *helper = to_fb_helper(ops);
> +	struct drm_crtc_helper_funcs *funcs;
> +	int i;
> +
> +	if (atomic_read(&kgdb_active))
> +		goto out; /* already in KDB, don't reset mode */
> +
> +	if (list_empty(&kernel_fb_helper_list))
> +		return false;
> +
> +	list_for_each_entry(helper, &kernel_fb_helper_list,
> kernel_fb_list) {
> +		for (i = 0; i < helper->crtc_count; i++) {
> +			struct drm_mode_set *mode_set =
> +				&helper->crtc_info[i].mode_set;
> +
> +			if (!mode_set->crtc->enabled)
> +				continue;
> +
> +			funcs =
> mode_set->crtc->helper_private;
> +			funcs->mode_set_base_atomic(mode_set->crtc,
> +						    mode_set->fb,
> +						    mode_set->x,
> +						    mode_set->y);
> +
> +		}
> +	}
> +
> +out:
> +	return 0;
> +}
> +
> +/* Find the real fb for a given fb helper CRTC */
> +static struct drm_framebuffer *drm_mode_config_fb(struct drm_crtc
> *crtc) +{
> +	struct drm_device *dev = crtc->dev;
> +	struct drm_crtc *c;
> +
> +	list_for_each_entry(c, &dev->mode_config.crtc_list, head) {
> +		if (crtc->base.id == c->base.id)
> +			return c->fb;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int drm_fb_kdb_exit(struct dbg_kms_console_ops *ops)
> +{
> +	struct drm_fb_helper *helper = to_fb_helper(ops);
> +	struct drm_crtc *crtc;
> +	struct drm_crtc_helper_funcs *funcs;
> +	struct drm_framebuffer *fb;
> +	int i;
> +
> +	for (i = 0; i < helper->crtc_count; i++) {
> +		struct drm_mode_set *mode_set =
> &helper->crtc_info[i].mode_set;
> +		crtc = mode_set->crtc;
> +		funcs = crtc->helper_private;
> +		fb = drm_mode_config_fb(crtc);
> +
> +		if (!crtc->enabled)
> +			continue;
> +
> +		if (!fb) {
> +			DRM_ERROR("no fb to restore??\n");
> +			continue;
> +		}
> +
> +		funcs->mode_set_base_atomic(mode_set->crtc, fb,
> crtc->x,
> +					    crtc->y);
> +	}
> +
> +	return 0;
> +}
> +
>  bool drm_fb_helper_force_kernel_mode(void)
>  {
>  	int i = 0;
> @@ -924,6 +1003,9 @@ int drm_fb_helper_single_fb_probe(struct
> drm_device *dev, /* Switch back to kernel console on panic */
>  	/* multi card linked list maybe */
>  	if (list_empty(&kernel_fb_helper_list)) {
> +		fb_helper->kdb_ops.activate_console =
> drm_fb_kdb_enter;
> +		fb_helper->kdb_ops.restore_console = drm_fb_kdb_exit;
> +		dbg_kms_console_ops_register(&fb_helper->kdb_ops);
>  		printk(KERN_INFO "registered panic notifier\n");
>  		atomic_notifier_chain_register(&panic_notifier_list,
>  					       &paniced);
> @@ -938,6 +1020,7 @@ void drm_fb_helper_free(struct drm_fb_helper
> *helper) {
>  	list_del(&helper->kernel_fb_list);
>  	if (list_empty(&kernel_fb_helper_list)) {
> +		dbg_kms_console_ops_unregister(&helper->kdb_ops);
>  		printk(KERN_INFO "unregistered panic notifier\n");
>  		atomic_notifier_chain_unregister(&panic_notifier_list,
>  						 &paniced);
> diff --git a/drivers/gpu/drm/i915/intel_display.c
> b/drivers/gpu/drm/i915/intel_display.c index 52cd9b0..e134a81 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1234,6 +1234,98 @@ intel_pin_and_fence_fb_obj(struct drm_device
> *dev, struct drm_gem_object *obj) return 0;
>  }
>  
> +/* Assume fb object is pinned & idle & fenced and just update base
> pointers */ +static int
> +intel_pipe_set_base_atomic(struct drm_crtc *crtc, struct
> drm_framebuffer *fb,
> +			   int x, int y)
> +{
> +	struct drm_device *dev = crtc->dev;
> +	struct drm_i915_private *dev_priv = dev->dev_private;
> +	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
> +	struct intel_framebuffer *intel_fb;
> +	struct drm_i915_gem_object *obj_priv;
> +	struct drm_gem_object *obj;
> +	int plane = intel_crtc->plane;
> +	unsigned long Start, Offset;
> +	int dspbase = (plane == 0 ? DSPAADDR : DSPBADDR);
> +	int dspsurf = (plane == 0 ? DSPASURF : DSPBSURF);
> +	int dspstride = (plane == 0) ? DSPASTRIDE : DSPBSTRIDE;
> +	int dsptileoff = (plane == 0 ? DSPATILEOFF : DSPBTILEOFF);
> +	int dspcntr_reg = (plane == 0) ? DSPACNTR : DSPBCNTR;
> +	u32 dspcntr;
> +
> +	switch (plane) {
> +	case 0:
> +	case 1:
> +		break;
> +	default:
> +		DRM_ERROR("Can't update plane %d in SAREA\n", plane);
> +		return -EINVAL;
> +	}
> +
> +	intel_fb = to_intel_framebuffer(fb);
> +	obj = intel_fb->obj;
> +	obj_priv = obj->driver_private;
> +
> +	dspcntr = I915_READ(dspcntr_reg);
> +	/* Mask out pixel format bits in case we change it */
> +	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
> +	switch (fb->bits_per_pixel) {
> +	case 8:
> +		dspcntr |= DISPPLANE_8BPP;
> +		break;
> +	case 16:
> +		if (fb->depth == 15)
> +			dspcntr |= DISPPLANE_15_16BPP;
> +		else
> +			dspcntr |= DISPPLANE_16BPP;
> +		break;
> +	case 24:
> +	case 32:
> +		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
> +		break;
> +	default:
> +		DRM_ERROR("Unknown color depth\n");
> +		return -EINVAL;
> +	}
> +	if (IS_I965G(dev)) {
> +		if (obj_priv->tiling_mode != I915_TILING_NONE)
> +			dspcntr |= DISPPLANE_TILED;
> +		else
> +			dspcntr &= ~DISPPLANE_TILED;
> +	}
> +
> +	if (IS_IRONLAKE(dev))
> +		/* must disable */
> +		dspcntr |= DISPPLANE_TRICKLE_FEED_DISABLE;
> +
> +	I915_WRITE(dspcntr_reg, dspcntr);
> +
> +	Start = obj_priv->gtt_offset;
> +	Offset = y * fb->pitch + x * (fb->bits_per_pixel / 8);
> +
> +	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset,
> x, y);
> +	I915_WRITE(dspstride, fb->pitch);
> +	if (IS_I965G(dev)) {
> +		I915_WRITE(dspbase, Offset);
> +		I915_READ(dspbase);
> +		I915_WRITE(dspsurf, Start);
> +		I915_READ(dspsurf);
> +		I915_WRITE(dsptileoff, (y << 16) | x);
> +	} else {
> +		I915_WRITE(dspbase, Start + Offset);
> +		I915_READ(dspbase);
> +	}
> +
> +	if ((IS_I965G(dev) || plane == 0))
> +		intel_update_fbc(crtc, &crtc->mode);
> +
> +	intel_wait_for_vblank(dev);
> +	intel_increase_pllclock(crtc, true);
> +
> +	return 0;
> +}
> +
>  static int
>  intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
>  		    struct drm_framebuffer *old_fb)
> @@ -4243,6 +4335,7 @@ static const struct drm_crtc_helper_funcs
> intel_helper_funcs = { .mode_fixup = intel_crtc_mode_fixup,
>  	.mode_set = intel_crtc_mode_set,
>  	.mode_set_base = intel_pipe_set_base,
> +	.mode_set_base_atomic = intel_pipe_set_base_atomic,
>  	.prepare = intel_crtc_prepare,
>  	.commit = intel_crtc_commit,
>  	.load_lut = intel_crtc_load_lut,
> diff --git a/include/drm/drm_crtc_helper.h
> b/include/drm/drm_crtc_helper.h index b29e201..4c12319 100644
> --- a/include/drm/drm_crtc_helper.h
> +++ b/include/drm/drm_crtc_helper.h
> @@ -61,6 +61,8 @@ struct drm_crtc_helper_funcs {
>  	/* Move the crtc on the current fb to the given position
> *optional* */ int (*mode_set_base)(struct drm_crtc *crtc, int x, int
> y, struct drm_framebuffer *old_fb);
> +	int (*mode_set_base_atomic)(struct drm_crtc *crtc,
> +				    struct drm_framebuffer *fb, int
> x, int y); 
>  	/* reload the current crtc LUT */
>  	void (*load_lut)(struct drm_crtc *crtc);
> diff --git a/include/drm/drm_fb_helper.h b/include/drm/drm_fb_helper.h
> index 58c892a..c4f87a5 100644
> --- a/include/drm/drm_fb_helper.h
> +++ b/include/drm/drm_fb_helper.h
> @@ -30,6 +30,8 @@
>  #ifndef DRM_FB_HELPER_H
>  #define DRM_FB_HELPER_H
>  
> +#include <linux/kgdb.h>
> +
>  struct drm_fb_helper_crtc {
>  	uint32_t crtc_id;
>  	struct drm_mode_set mode_set;
> @@ -63,8 +65,10 @@ struct drm_fb_helper_connector {
>  
>  struct drm_fb_helper {
>  	struct drm_framebuffer *fb;
> +	struct drm_framebuffer *saved_fb;
>  	struct drm_device *dev;
>  	struct drm_display_mode *mode;
> +	struct dbg_kms_console_ops kdb_ops;
>  	int crtc_count;
>  	struct drm_fb_helper_crtc *crtc_info;
>  	struct drm_fb_helper_funcs *funcs;


-- 
Jesse Barnes, Intel Open Source Technology Center
