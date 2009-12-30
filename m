Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZL3WRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZL3WRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZL3WRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:17:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZL3WRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:17:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: drm: gem_object_free without struct_mutex
Date: Wed, 30 Dec 2009 23:17:48 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <alpine.LSU.2.00.0912301934070.25797@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.0912301934070.25797@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302317.48530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC to Jesse.]

On Wednesday 30 December 2009, Hugh Dickins wrote:
> I've changed BUG_ON to WARN_ON in drm_gem.c (patch at bottom) to
> get this dmesg when I resume after suspend, instead of crashing.
> 
> Perhaps it's a patch that should go in, perhaps not, but obviously
> the real problem lies elsewhere.  Happens with 2.6.33-rc1 and -rc2.
> 
> No surprise if I'm stupidly misconfigured to get the "pin power context"
> error in the first place (.config on demand), but I don't deserve to BUG!
> 
> Hugh
> 
> [drm:intel_init_clock_gating] *ERROR* failed to pin power context: -16
> ------------[ cut here ]------------
> WARNING: at drivers/gpu/drm/drm_gem.c:438 drm_gem_object_free+0x20/0x5e()
> Hardware name: ESPRIMO Mobile V5505           
> Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
> Pid: 3793, comm: s2ram Not tainted 2.6.33-rc2 #4
> Call Trace:
>  [<7815298e>] warn_slowpath_common+0x59/0x6b
>  [<781529b3>] warn_slowpath_null+0x13/0x18
>  [<78317c1a>] ? drm_gem_object_free+0x20/0x5e
>  [<78317c1a>] drm_gem_object_free+0x20/0x5e
>  [<78317bfa>] ? drm_gem_object_free+0x0/0x5e
>  [<7829df11>] kref_put+0x38/0x45
>  [<7833a5f0>] intel_init_clock_gating+0x232/0x271
>  [<78317bfa>] ? drm_gem_object_free+0x0/0x5e
>  [<7832c307>] i915_restore_state+0x21a/0x2b3
>  [<7832379d>] i915_resume+0x3c/0xbb
>  [<78174fe5>] ? trace_hardirqs_on_caller+0xfc/0x123
>  [<7831c756>] ? drm_class_resume+0x0/0x3e
>  [<7831c78d>] drm_class_resume+0x37/0x3e
>  [<78351e0a>] legacy_resume+0x1e/0x51
>  [<78351ece>] device_resume+0x91/0xab
>  [<7831c756>] ? drm_class_resume+0x0/0x3e
>  [<78352226>] dpm_resume+0x58/0x10f
>  [<783522fb>] dpm_resume_end+0x1e/0x2c
>  [<78180f80>] suspend_devices_and_enter+0x61/0x84
>  [<78180ff8>] enter_state+0x55/0x83
>  [<7818091c>] state_store+0x94/0xaa
>  [<7829d09e>] kobj_attr_store+0x1e/0x23
>  [<782098e0>] sysfs_write_file+0x66/0x99
>  [<781cd2f0>] vfs_write+0x8a/0x108
>  [<781cd408>] sys_write+0x3c/0x63
>  [<78125c10>] sysenter_do_call+0x12/0x36
> ---[ end trace a343537f29950fda ]---
> 
> [PATCH] gem: free just WARN_ON(!mutex_is_locked)
> 
> drm_gem_object_free() WARN_ON(!mutex_is_locked) instead of BUG_ON:
> i915_resume()->i915_restore_state()->intel_init_clock_gating()
> is currently causing it to trigger with my config.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  drivers/gpu/drm/drm_gem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.33-rc2/drivers/gpu/drm/drm_gem.c	2009-12-03 03:51:21.000000000 +0000
> +++ linux/drivers/gpu/drm/drm_gem.c	2009-12-26 18:29:57.000000000 +0000
> @@ -435,7 +435,7 @@ drm_gem_object_free(struct kref *kref)
>  	struct drm_gem_object *obj = (struct drm_gem_object *) kref;
>  	struct drm_device *dev = obj->dev;
>  
> -	BUG_ON(!mutex_is_locked(&dev->struct_mutex));
> +	WARN_ON(!mutex_is_locked(&dev->struct_mutex));
>  
>  	if (dev->driver->gem_free_object != NULL)
>  		dev->driver->gem_free_object(obj);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

