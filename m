Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZBCGpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZBCGpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 01:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZBCGpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 01:45:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbZBCGpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 01:45:08 -0500
Date: Mon, 2 Feb 2009 22:44:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, airlied@linux.ie, eric@anholt.net,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: + drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch
 added to -mm tree
Message-Id: <20090202224448.b19eaca4.akpm@linux-foundation.org>
In-Reply-To: <20090131152508.GA4668@viiv.ffwll.ch>
References: <200901292050.n0TKol5b015605@imap1.linux-foundation.org>
	<200901291324.17624.jbarnes@virtuousgeek.org>
	<20090129134825.620e3f84.akpm@linux-foundation.org>
	<20090131152508.GA4668@viiv.ffwll.ch>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Sat, 31 Jan 2009 16:25:08 +0100 Daniel Vetter <daniel@ffwll.ch> wrote:

> On Thu, Jan 29, 2009 at 01:48:25PM -0800, Andrew Morton wrote:
> > On Thu, 29 Jan 2009 13:24:17 -0800
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > On Thursday, January 29, 2009 12:50 pm akpm@linux-foundation.org wrote:
> > > > diff -puN
> > > > drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-fix-lock
> > > >ing-snafu drivers/gpu/drm/i915/intel_lvds.c ---
> > > > a/drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-fix-lo
> > > >cking-snafu +++ a/drivers/gpu/drm/i915/intel_lvds.c
> > > > @@ -311,7 +311,7 @@ static int intel_lvds_get_modes(struct d
> > > >  	if (dev_priv->panel_fixed_mode != NULL) {
> > > >  		struct drm_display_mode *mode;
> > > >
> > > > -		mutex_unlock(&dev->mode_config.mutex);
> > > > +		mutex_lock(&dev->mode_config.mutex);
> > > >  		mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
> > > >  		drm_mode_probed_add(connector, mode);
> > > >  		mutex_unlock(&dev->mode_config.mutex);
> > > > _
> > > >
> > > > Patches currently in -mm which might be from akpm@linux-foundation.org are
> > > 
> > > Oops.  This should go upstream asap.
> > 
> > yup, I'll send it later today hopefully.
> 
> Thanks for the speedy fix. Unfortunately it looks like the locking in this
> area still doesn't quite work:
> 
> Enabling kms works flawlessly now, but when I fire up X, the screen blanks
> (no more blinking cursors), then X hangs. vt-switchings doesn't work
> anymore, otherwise the machine looked fine (ping on the network was fine,
> couldn't check anything else for lack of a running sshd on the crashing
> machine). Twice using SysRq-T (half a minute in between) showed that Xorg
> was indeed stuck, both times with the exact same backtrace:
> 
> Xorg          D 00203246  6448  6049   6048
>  f1c81df0 00203046 f6322720 00203246 f1c81de0 f83fb98d f6322720 f632297c
>  00203046 f1d88444 00203046 f2f63cc0 f8388dae f1d88444 ffffffff f1d88408
>  00203246 f1c81e2c c02e18ba f83fb98d 00000000 f6322720 f1d88430 f1d88444
> Call Trace:
>  [<f83fb98d>] ? intel_lvds_get_modes+0x69/0x94 [i915]
>  [<f8388dae>] ? drm_mode_getconnector+0x54/0x31f [drm]
>  [<c02e18ba>] mutex_lock_nested+0x158/0x254
>  [<f83fb98d>] ? intel_lvds_get_modes+0x69/0x94 [i915]
>  [<f83fb98d>] intel_lvds_get_modes+0x69/0x94 [i915]
>  [<f838a170>] drm_helper_probe_single_connector_modes+0xb8/0x194 [drm]
>  [<f8388e20>] drm_mode_getconnector+0xc6/0x31f [drm]
>  [<c02e13bc>] ? mutex_unlock+0xd/0xf
>  [<f837f71f>] drm_ioctl+0x1c1/0x23d [drm]
>  [<f8388d5a>] ? drm_mode_getconnector+0x0/0x31f [drm]
>  [<f837f55e>] ? drm_ioctl+0x0/0x23d [drm]
>  [<c0191277>] vfs_ioctl+0x43/0x56
>  [<c0191a34>] do_vfs_ioctl+0x49f/0x4e0
>  [<c0186c42>] ? vfs_write+0xf5/0x131
>  [<c0191aba>] sys_ioctl+0x45/0x5f
>  [<c0102e91>] sysenter_do_call+0x12/0x31
> 
> This is on 2.6.29-rc3-00100-gf2257b7.
> 

So I assume that it would make sense to track this as a post-2.6.28
regression?

