Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYJWDwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYJWDwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 23:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYJWDwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 23:52:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33992 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYJWDwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 23:52:09 -0400
Date: Thu, 23 Oct 2008 04:52:04 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes for 2.6.27-rc1
Message-ID: <alpine.DEB.0.82.0810230448150.21357@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1180388520-1224733924=:21357"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1180388520-1224733924=:21357
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

This contains a lot of stability fixes from Intel for the GEM work along 
with fixing some general drm issues.

Keith is working on a patchset to implement the new IO stuff, which we can 
discuss later if it needs to hit 2.6.27 or if .28 is good enough.

Dave.

 drivers/gpu/drm/drm_drawable.c       |   15 ++-
 drivers/gpu/drm/drm_ioc32.c          |   34 ++++
 drivers/gpu/drm/drm_irq.c            |    5 +-
 drivers/gpu/drm/drm_lock.c           |    2 +
 drivers/gpu/drm/drm_proc.c           |    4 +-
 drivers/gpu/drm/i915/i915_dma.c      |    5 +-
 drivers/gpu/drm/i915/i915_drv.h      |   10 +-
 drivers/gpu/drm/i915/i915_gem.c      |    2 -
 drivers/gpu/drm/i915/i915_gem_proc.c |   15 ++-
 drivers/gpu/drm/i915/i915_irq.c      |  277 ++++++++++++++++++----------------
 10 files changed, 223 insertions(+), 146 deletions(-)

commit 7e78f72524b794fa8d73dc59aeeacc12a2e937fe
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Oct 21 11:53:01 2008 -0700

    drm: Avoid oops in DRM_IOCTL_RM_DRAW if a bad handle is supplied.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Acked-by: Michel Dänzer <michel@tungstengraphics.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 49568873705e45a0de77b7824a9a46d3201019a7
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Oct 21 11:38:50 2008 -0700

    drm: Add 32-bit compatibility for DRM_IOCTL_UPDATE_DRAW.
    
    This fixes vblank support for a 32-bit X Server on a 64-bit kernel.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 42f52ef8d96b1434f12ad9f895b5412fda392847
Author: Keith Packard <keithp@keithp.com>
Date:   Sat Oct 18 19:39:29 2008 -0700

    drm/i915: use pipes, not planes to label vblank data
    
    vblank in the kernel is far simpler if it deals with pipes instead of
    planes, so we're changing both user and kernel side.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9e44af790f8bf8c3aa8a3101fd4f9bca2e932baa
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Oct 16 21:18:27 2008 -0700

    drm/i915: hold dev->struct_mutex and DRM lock during vblank ring operations
    
    To synchronize clip lists with the X server, the DRM lock must be held while
    looking at drawable clip lists. To synchronize with other ring access, the
    ring mutex must be held while inserting commands into the ring.  Failure to
    do the first resulted in easy visual corruption when moving windows, and the
    second could have corrupted the ring with DRI2.
    
    Grabbing the DRM lock involves using the DRM tasklet mechanism, grabbing the
    ring mutex means potentially sleeping. Deal with both of these by always
    running the tasklet from a work handler.
    
    Also, protect from clip list changes since the vblank request was queued by
    making sure the window has at least one rectangle while looking inside,
    preventing oopses .
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fe8133dc07e613587f8e667bce769edce8490f2a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Oct 17 15:43:02 2008 -0700

    i915: Fix format string warnings on x86-64.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a2d44cca4fc9ae04ed2c9fc2ef16b6989eeae218
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Oct 17 14:41:03 2008 -0700

    i915: Don't dereference HWS in /proc debug files when it isn't initialized.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Acked-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 053d7f244a8739d96d316c77a97cd063804c8e35
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Oct 17 15:41:26 2008 -0700

    i915: Enable IMR passthrough of vblank events before enabling it in pipestat.
    
    Otherwise, if we lost the race, the pipestat bit would be set without being
    reflected in IIR, and we would never clear the pipestat bit so the pipe
    event would never be generated again, and all vblank waits would time out.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Acked-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 35ad68c18148a18938ff4f40e945c9734e7d2265
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Oct 17 11:03:53 2008 -0700

    drm: Remove two leaks of vblank reference count in error paths.
    
    If the failing paths were hit, the vblank IRQ would never get turned off
    again.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Acked-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 786225eb2f4e55b5dda3cf8c62a145e824aae199
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Fri Oct 17 15:48:44 2008 +0800

    drm: fix leak of cliprects in drm_rmdraw()
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d1ed629f44b3a4108d5c445971535f05f441fce7
Author: Keith Packard <keithp@keithp.com>
Date:   Fri Oct 17 00:44:42 2008 -0700

    i915: Disable MSI on GM965 (errata says it doesn't work)
    
    Current Intel errata for the GM965 says that using MSI may cause interrupts
    to be delayed or lost. The only workaround offered is to not use it.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 863842736fb4571b22e0f7f4696bf13eeec57166
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Fri Oct 17 13:15:48 2008 +0800

    drm: Set cliprects to NULL when changing drawable to having 0 cliprects.
    
    This avoids setting the cliprects pointer to a zero-sized allocation.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e9d21d7f5ae1e625f3687d88bb50b00478c533ad
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Oct 16 11:31:38 2008 -0700

    i915: Protect vblank IRQ reg access with spinlock
    
    This uses the same spinlock as the user_irq code as it shares the same
    register, ensuring that interrupt registers are updated atomically.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

--29444707-1180388520-1224733924=:21357--
