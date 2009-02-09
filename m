Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZBIIbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZBIIbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZBIIbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:31:00 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58264 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBIIa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:30:59 -0500
Date: Mon, 9 Feb 2009 08:30:57 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm
Message-ID: <alpine.DEB.2.00.0902090827390.32114@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-142357707-1234168257=:32114"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-142357707-1234168257=:32114
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This fixes some regressions and also a number of bugs in the Intel KMS and 
GEM code. Sorry its a bit bigger than I like sending, but I got backlogged 
with real life stuff and kept pushing this off.

I've got at least two more things to get fixed, Intel has a lockdep issue 
and I'm waiting for Eric to get back from travelling to confirm the fix is 
correct, and we have a radeon regression on susp/resume which I think is 
vblank related. This should fix your vblank issue and the CONFIG_FB fix 
from Ingo.

Dave.

 drivers/gpu/drm/Kconfig                |    2 +-
 drivers/gpu/drm/drm_irq.c              |    1 +
 drivers/gpu/drm/drm_memory.c           |    7 +-
 drivers/gpu/drm/i915/i915_dma.c        |   47 ++-
 drivers/gpu/drm/i915/i915_drv.c        |    1 -
 drivers/gpu/drm/i915/i915_drv.h        |    8 +
 drivers/gpu/drm/i915/i915_gem.c        |   83 ++-
 drivers/gpu/drm/i915/i915_gem_tiling.c |   91 ++++-
 drivers/gpu/drm/i915/i915_irq.c        |   13 +
 drivers/gpu/drm/i915/i915_reg.h        |   10 +-
 drivers/gpu/drm/i915/intel_display.c   |   20 +-
 drivers/gpu/drm/i915/intel_drv.h       |    1 +
 drivers/gpu/drm/i915/intel_lvds.c      |   49 +--
 drivers/gpu/drm/i915/intel_sdvo.c      |  870 ++++++++++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_sdvo_regs.h |  404 +++++++++++++++-
 drivers/gpu/drm/radeon/radeon_cp.c     |    6 +-
 drivers/video/Kconfig                  |    6 +-
 include/drm/i915_drm.h                 |    2 +
 18 files changed, 1428 insertions(+), 193 deletions(-)

commit d2f59357700487a8b944f4f7777d1e97cf5ea2ed
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Feb 5 16:03:34 2009 +0100

    drm/i915: select framebuffer support automatically
    
    Migration helper.
    
    The i915 driver recently added a 'depends on FB' rule to its
    Kconfig entry - which silently turns off DRM_I915 if someone
    has a working config but no CONFIG_FB selected, and upgrades
    to the latest upstream kernel.
    
    Norbert Preining reported this problem:
    
       Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=12599
       Subject     : dri /dev node disappeared with 2.6.29-rc1
    
    So change it to "select FB", which auto-selects framebuffer
    support. This way the driver keeps working, regardless of
    whether FB was enabled before or not.
    
    Kconfig select's of interactive options can be problematic to
    dependencies and can cause build breakages - but in this case
    it's safe because it's a leaf entry with no dependencies of its
    own.
    
    ( There is some minor circular dependency fallout as FB_I810
      and FB_INTEL also used 'depends on FB' constructs - update
      those to "select FB" too. )
    
    Reported-by: Norbert Preining <preining@logic.at>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9880b7a527ffbb52f65c2de0a8d4eea86e24775e
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Feb 6 10:22:41 2009 -0800

    drm/i915: add get_vblank_counter function for GM45
    
    As discussed in the long thread about vblank related timeouts, it turns out
    GM45 has different frame count registers than previous chips.  This patch
    adds support for them, which prevents us from waiting on really stale
    sequence values in drm_wait_vblank (which rather than returning immediately
    ends up timing out or getting interrupted).
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 14d200c5e5bd19219d930bbb9a5a22758c8f5bec
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Feb 6 13:04:49 2009 -0800

    drm/i915: capture last_vblank count at IRQ uninstall time too
    
    In dc1336ff4fe08ae7cfe8301bfd7f0b2cfd31d20a (set vblank enable flag correctly
    across IRQ uninstall), we made sure drivers that uninstall their interrupt
    handler set the vblank enabled flag correctly, so that when interrupts are
    re-enabled, vblank interrupts & counts work as expected.  However I missed the
    last_vblank field:  it needs to be updated as well, otherwise, at the next
    drm_update_vblank_count we'll end up comparing a current count to a stale
    one (the last one captured by the disable function), which may trigger the
    wraparound handling, leading to a jumpy counter and hangs in drm_wait_vblank.
    
    The jumpy counter can prevent the DRM_WAIT_ON from returning success if the
    difference between the current count and the requested count is greater than
    2^23, leading to timeouts or hangs, if the ioctl is restarted in a loop (as
    is the case in libdrm < 2.4.4).
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Acked-by: Michel Dänzer <michel@daenzer.net>
    Tested-by: Timo Aaltonen <tjaalton@cc.hut.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7d8d58b23fd01e60ed44d8d8c10b2df86e638faa
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 4 14:15:10 2009 +0000

    drm/i915: Unlock mutex on i915_gem_fault() error path
    
    If we failed to allocate a new fence register we would return
    VM_FAULT_SIGBUS without relinquishing the lock.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 122ee2a63bc49d21f402f6b6d2208306cdcc98c1
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Feb 3 12:10:21 2009 -0800

    drm/i915: Quiet the message on get/setparam ioctl with an unknown value.
    
    Getting an unknown get/setparam used to be more significant back when they
    didn't change much.  However, now that we're in the git world we're using
    them instead of a monotonic version number to signal feature availability,
    so clients ask about unknown params on older kernels more often.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 565dcd4635f4f8c0ac4dee38a5625bc325799b1e
Author: Paul Collins <paul@burly.ondioline.org>
Date:   Wed Feb 4 23:05:41 2009 +1300

    drm/i915: skip LVDS initialization on Apple Mac Mini
    
    The Apple Mac Mini falsely reports LVDS.  Use DMI to check whether we
    are running on a Mac Mini, and skip LVDS initialization if that proves
    to be the case.
    
    Signed-off-by: Paul Collins <paul@ondioline.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e2f0ba97d60e59fe5c6237851933a9c38a8f9a24
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 2 15:11:52 2009 -0800

    drm/i915: sync SDVO code with stable userland modesetting driver
    
    Pull in an update from the 2D driver (hopefully the last one, future work
    should be done here and pulled back into xf86-video-intel as needed).
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 72daad40dc0be179e0dc85c17d5dc1e850b5e8e4
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Jan 30 21:10:22 2009 +0000

    drm/i915: Unref the object after failing to set tiling mode.
    
    Cleanup the object reference on the error paths.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 0f973f27888e4664b253ab2cf69c67c2eb80ab1b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Jan 26 17:10:45 2009 -0800

    drm/i915: add fence register management to execbuf
    
    Adds code to set up fence registers at execbuf time on pre-965 chips as
    necessary.  Also fixes up a few bugs in the pre-965 tile register support
    (get_order != ffs).  The number of fences available to the kernel defaults
    to the hw limit minus 3 (for legacy X front/back/depth), but a new parameter
    allows userspace to override that as needed.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d9ddcb96e05cfbadf3dbf66859bcaf5eae25af0b
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Jan 27 10:33:49 2009 -0800

    drm/i915: Return error from i915_gem_object_get_fence_reg() when failing.
    
    Previously, the caller would continue along without knowing that the
    function failed, resulting in potential mis-rendering.  Right now vm_fault
    just returns SIGBUS in that case, and we may need to disable signal handling
    to avoid that happening.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ab657db12d7020629f26f30d287558a8d0e32b41
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Jan 23 12:57:47 2009 -0800

    drm/i915: Set up an MTRR covering the GTT at driver load.
    
    We'd love to just be using PAT, but even on chips with PAT it gets disabled
    sometimes due to an errata.  It would probably be better to have pat_enabled
    exported and only bother with this when !pat_enabled.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 725e30ad6601d7fe443d9215d6331758a9d7e0c8
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Jan 22 13:01:02 2009 -0800

    drm/i915: Skip SDVO/HDMI init when the chipset tells us it's not present.
    
    This saves startup time from probing SDVO, and saves setting up HDMI outputs
    on G4X devices that don't have them.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e806b4957412bf472d826bd8cc571da041248799
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Jan 22 09:56:58 2009 -0800

    drm/i915: Suppress GEM teardown on X Server exit in KMS mode.
    
    Fixes hangs when starting X for the second time.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9b8d5a124f133fe9a75397d20b874844a2e3d7e9
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Feb 7 11:15:41 2009 +1000

    drm/radeon: fix ioremap conflict with AGP mappings
    
    this solves a regression from
    http://bugzilla.kernel.org/show_bug.cgi?id=12441
    
    Reported-by: Daniel Vetter <daniel@ffwll.ch>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ac048e1734699dd98f4bdf4daf2b9592d4a4d38e
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Feb 3 19:05:12 2009 +1000

    i915: fix unneeded locking in i915 LVDS get modes code.
    
    This code is always called under the lock from the higher layers,
    so need to go locking it here.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-142357707-1234168257=:32114--
