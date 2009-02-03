Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZBCKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZBCKdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 05:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZBCKdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 05:33:11 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:60127 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZBCKdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 05:33:09 -0500
X-Greylist: delayed 1775 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 05:33:09 EST
X-Spam-Hammy: 0.000-+--HTo:D*org, 0.000-+--HCc:D*org, 
	0.000-+--H*Ad:D*kernel.org
X-Spam-Spammy: 
Date: Tue, 3 Feb 2009 11:03:28 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       airlied@linux.ie, eric@anholt.net, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: + drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch
	added to -mm tree
Message-ID: <20090203100328.GA4523@viiv.ffwll.ch>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, airlied@linux.ie,
	eric@anholt.net, dri-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200901292050.n0TKol5b015605@imap1.linux-foundation.org> <200901291324.17624.jbarnes@virtuousgeek.org> <20090129134825.620e3f84.akpm@linux-foundation.org> <20090131152508.GA4668@viiv.ffwll.ch> <20090202224448.b19eaca4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202224448.b19eaca4.akpm@linux-foundation.org>
X-Operating-System: Linux viiv 2.6.29-rc2-00443-ge2a80a2 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 10:44:48PM -0800, Andrew Morton wrote:
> > Enabling kms works flawlessly now, but when I fire up X, the screen blanks
> > (no more blinking cursors), then X hangs. vt-switchings doesn't work
> > anymore, otherwise the machine looked fine (ping on the network was fine,
> > couldn't check anything else for lack of a running sshd on the crashing
> > machine). Twice using SysRq-T (half a minute in between) showed that Xorg
> > was indeed stuck, both times with the exact same backtrace:
> > 
> > Xorg          D 00203246  6448  6049   6048
> >  f1c81df0 00203046 f6322720 00203246 f1c81de0 f83fb98d f6322720 f632297c
> >  00203046 f1d88444 00203046 f2f63cc0 f8388dae f1d88444 ffffffff f1d88408
> >  00203246 f1c81e2c c02e18ba f83fb98d 00000000 f6322720 f1d88430 f1d88444
> > Call Trace:
> >  [<f83fb98d>] ? intel_lvds_get_modes+0x69/0x94 [i915]
> >  [<f8388dae>] ? drm_mode_getconnector+0x54/0x31f [drm]
> >  [<c02e18ba>] mutex_lock_nested+0x158/0x254
> >  [<f83fb98d>] ? intel_lvds_get_modes+0x69/0x94 [i915]
> >  [<f83fb98d>] intel_lvds_get_modes+0x69/0x94 [i915]
> >  [<f838a170>] drm_helper_probe_single_connector_modes+0xb8/0x194 [drm]
> >  [<f8388e20>] drm_mode_getconnector+0xc6/0x31f [drm]
> >  [<c02e13bc>] ? mutex_unlock+0xd/0xf
> >  [<f837f71f>] drm_ioctl+0x1c1/0x23d [drm]
> >  [<f8388d5a>] ? drm_mode_getconnector+0x0/0x31f [drm]
> >  [<f837f55e>] ? drm_ioctl+0x0/0x23d [drm]
> >  [<c0191277>] vfs_ioctl+0x43/0x56
> >  [<c0191a34>] do_vfs_ioctl+0x49f/0x4e0
> >  [<c0186c42>] ? vfs_write+0xf5/0x131
> >  [<c0191aba>] sys_ioctl+0x45/0x5f
> >  [<c0102e91>] sysenter_do_call+0x12/0x31
> > 
> > This is on 2.6.29-rc3-00100-gf2257b7.
> > 
> 
> So I assume that it would make sense to track this as a post-2.6.28
> regression?

Nope. Like the previous issue it only happens when I run-time enable
kernel modesetting (with # modprobe i915 modeset=1), which is not the
default.

I'm gonna open a new bz entry with all the details (and all the people on cc
minus regression handlers). But first I'll check with CONFIG_LOCKDEP
whether it's really a locking goof-up.

-Daniel

-- 
Daniel Vetter
E-Mail: daniel.vetter@ffwll.ch
Tel.: +41 (0)79 365 57 48
