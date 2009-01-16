Return-Path: <linux-kernel-owner+w=401wt.eu-S1765951AbZAPIuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765951AbZAPIuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbZAPIts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:49:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36175 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765687AbZAPItn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:49:43 -0500
Date: Fri, 16 Jan 2009 08:49:41 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.0901160847060.6422@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

This contains some fixes since the kms code got merged, one reported 
regression, and updates the kms driver to work on a few machines that 
needed a different object for cursor use.

I suspect we have at least one more kms fixup coming, with a locking 
cleanup and ref count on certain objects needs fixing.

Dave.

 drivers/gpu/drm/drm_crtc_helper.c    |  175 ++++++++++++++++++++++---------
 drivers/gpu/drm/drm_irq.c            |   18 +++-
 drivers/gpu/drm/i915/i915_dma.c      |   10 ++
 drivers/gpu/drm/i915/i915_drv.h      |   23 ++++
 drivers/gpu/drm/i915/i915_gem.c      |  189 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/i915_irq.c      |    6 +
 drivers/gpu/drm/i915/intel_display.c |   43 ++++++---
 drivers/gpu/drm/i915/intel_lvds.c    |    7 ++
 include/drm/drm_crtc.h               |    2 +-
 include/drm/drm_crtc_helper.h        |    2 +-
 10 files changed, 406 insertions(+), 69 deletions(-)

commit 34b8686e12eaf9878aaab89e92222060c3e7cc48
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Jan 15 14:03:07 2009 +1000

    drm/i915: lock correct mutex around object unreference.
    
    This makes sure the mutex is held around the unreference.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 71acb5eb8d95b371f4cdd88a47f3c83c870d1c8f
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Dec 30 20:31:46 2008 +1000

    drm/i915: add support for physical memory objects
    
    This is an initial patch to do support for objects which needs physical
    contiguous main ram, cursors and overlay registers on older chipsets.
    
    These objects are bound on cursor bin, like pinning, and we copy
    the data to/from the backing store object into the real one on attach/detach.
    
    notes:
    possible over the top in attach/detach operations.
    no overlay support yet.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e285f3cd2c376d2336f9a383241a98266363c7d4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Jan 14 10:53:36 2009 -0800

    drm/i915: make LVDS fixed mode a preferred mode
    
    The detected fixed panel mode really is preferred, so mark it as such and
    add it to the LVDS connector mode list.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 712531bfe95be42a672ebab51b55580e7d92c464
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Jan 9 13:56:14 2009 -0800

    drm: handle depth & bpp changes correctly
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 40a518d9f1fd8ed1061b8b4e2ce8a44794f4eb03
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Jan 12 12:05:32 2009 -0800

    drm: initial KMS config fixes
    
    When mode setting is first initialized, the driver will call into
    drm_helper_initial_config() to set up an initial output and framebuffer
    configuration.  This routine is responsible for probing the available
    connectors, encoders, and crtcs, looking for modes and putting together
    something reasonable (where reasonable is defined as "allows kernel
    messages to be visible on as many displays as possible").
    
    However, the code was a bit too aggressive in setting default modes when
    none were found on a given connector.  Even if some connectors had modes,
    any connectors found lacking modes would have the default 800x600 mode added
    to their mode list, which in some cases could cause problems later down the
    line.  In my case, the LVDS was perfectly available, but the initial config
    code added 800x600 modes to both of the detected but unavailable HDMI
    connectors (which are on my non-existent docking station).  This ended up
    preventing later code from setting a mode on my LVDS, which is bad.
    
    This patch fixes that behavior by making the initial config code walk
    through the connectors first, counting the available modes, before it decides
    to add any default modes to a possibly connected output.  It also fixes the
    logic in drm_target_preferred() that was causing zeroed out modes to be set
    as the preferred mode for a given connector, even if no modes were available.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 3a03ac1a0223f779a3de313523408ddb099e5679
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Jan 11 09:03:49 2009 +1000

    drm/i915: setup sarea properly in master_priv
    
    If we are running DRI1 userspace, we really need to set the sarea up properly.
    
    thanks to Richard for finding/testing this.
    
    Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dc1336ff4fe08ae7cfe8301bfd7f0b2cfd31d20a
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Jan 6 10:21:24 2009 -0800

    drm/i915: set vblank enabled flag correctly across IRQ install/uninstall
    
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

commit 71e0ffa599f54058d9b8724b4b14d0486751681d
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Jan 8 10:42:15 2009 -0800

    drm/i915: don't enable vblanks on disabled pipes
    
    In some cases userland may be confused and try to wait on vblank events from
    pipes that aren't actually enabled.  We shouldn't allow this, so return
    -EINVAL if the pipe isn't on.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
