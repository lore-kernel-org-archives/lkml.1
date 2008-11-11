Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYKKIPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYKKIPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYKKIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:15:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50773 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYKKIP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:15:28 -0500
Date: Tue, 11 Nov 2008 08:15:26 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes for 2.6.27-rc5
Message-ID: <alpine.DEB.0.82.0811110811350.2182@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This fixes two regressions, one in radeon suspend/resume, and one in 
965/GM45 suspend/resume. It also removes a major racy piece of code for 
doing vblank swaps, it really was never used properly and userspace never 
relied on it being there. It also stops the drm binding twice to certain 
Intel PCI devices where the second head isn't a real device but a dumb 
placeholder.

Intel are working on some interrupt handling issues that we might have 
some fixes for quite soon, and the AGP on PAE issue is still outstanding.

Dave.

 drivers/gpu/drm/drm_drv.c           |   10 +-
 drivers/gpu/drm/drm_irq.c           |   80 --------
 drivers/gpu/drm/drm_lock.c          |    9 -
 drivers/gpu/drm/drm_stub.c          |    1 -
 drivers/gpu/drm/i915/i915_dma.c     |   16 +-
 drivers/gpu/drm/i915/i915_drv.h     |   19 +--
 drivers/gpu/drm/i915/i915_gem.c     |    8 +-
 drivers/gpu/drm/i915/i915_irq.c     |  383 ++---------------------------------
 drivers/gpu/drm/i915/i915_reg.h     |    3 +
 drivers/gpu/drm/i915/i915_suspend.c |    9 +
 drivers/gpu/drm/radeon/radeon_cp.c  |   15 +-
 drivers/gpu/drm/radeon/radeon_drv.h |    2 +-
 include/drm/drmP.h                  |    5 -
 include/drm/drm_pciids.h            |   46 ++--
 14 files changed, 84 insertions(+), 522 deletions(-)

commit 0baf823a10bd4131f70e9712d1f02de3c247f1df
Author: Keith Packard <keithp@keithp.com>
Date:   Sat Nov 8 11:44:14 2008 +1000

    drm/i915: Move legacy breadcrumb out of the reserved status page area
    
    Addresses in the hardware status page below index 0x20 are reserved for use
    by the hardware. The legacy breadcrumb was sitting at index 5. Move it to
    index 0x21, and make sure everyone uses the defined value instead of
    hard-coded constants.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit afa21e0584f78964c092981fad94e45d38cda249
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Nov 11 18:02:12 2008 +1000

    drm/i915: Filter pci devices based on PCI_CLASS_DISPLAY_VGA
    
    This fixes hangs on 855-class hardware by avoiding double attachment of the
    driver due to the stub second head device having the same pci id as the real
    device.
    
    Other DRM drivers probably want this treatment as well, but I'm applying it
    just to this one for safety. But we should clean up the drm_pciids.h mess
    now so that each driver has its own pci id list header in its own directory.
    Lets do that in the next release.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 78538bf14995a136c2d9a22159ada49937359119
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Nov 11 17:56:16 2008 +1000

    drm/radeon: map registers at load time
    
    Now that the radeon driver has suspend/resume functions, it needs to map its
    registers at load time or it will likely crash if a suspend operation occurs
    before the driver has been initialized.
    
    This patch moves the register mapping code from firstopen to load and makes
    the mapping into a _DRM_DRIVER one so that the core won't remove it at
    lastclose time.
    
    Fixes (at least partially) kernel bz #11891.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 5d8e6bb7a20b6206e1fe44565efc383a941b81fa
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Nov 4 18:36:29 2008 -0800

    drm: Remove infrastructure for supporting i915's vblank swapping.
    
    It's not used in any other drivers, and doesn't look like it will be from
    drm.git master.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit bd95e0a4a6bb9485fe35dda62719663f6ceabae1
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Nov 4 12:01:24 2008 -0800

    i915: Remove racy delayed vblank swap ioctl.
    
    When userland detected that this ioctl was supported (by version number check),
    it used it in a racy way -- dispatch delayed swap, wait for vblank, continue
    rendering. As there was no mechanism for it to wait for the swap to finish,
    sometimes it would render before the swap and garbage would be displayed on
    the screen.
    
    By removing the ioctl and returning -EINVAL, userland returns to its previous,
    correct rendering path of waiting for a vblank then dispatching a swap.  The
    only path that could have used this ioctl correctly was page flipping, which
    relied on only one client running and emitting wait-for-vblank-before-rendering
    in the command stream.  That path also falls back correctly, at the performance
    cost of not being able to queue up rendering before the flip occurs.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d3e74d0237b102d34979015fbf6df02ca4413074
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Nov 3 14:46:17 2008 -0800

    i915: Don't whine when pci_enable_msi() fails.
    
    This probably just means the chipset doesn't support MSI, which is fine.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 6a47baa6ce7e6fb5fed8d1fd0af36a96a4ad133f
Author: Owen Taylor <otaylor@redhat.com>
Date:   Mon Nov 3 14:38:17 2008 -0800

    i915: Don't attempt to short-circuit object_wait_rendering by checking domains.
    
    This could return early when reading after writing a buffer, if somebody
    had already put it on the flushing list (write domains are 0, but still
    active), leading to glReadPixels failure.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ad42ca8f4490de06462aee234ea0083cbd8b46aa
Author: Keith Packard <keithp@keithp.com>
Date:   Sun Nov 2 23:38:20 2008 -0800

    i915: Clean up sarea pointers on leavevt
    
    This corresponds to the setup of the sarea pointers in DMA initialization,
    though neither is exactly the point at which the sarea is set up or torn down.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 881ee9889c8b98671c5491e43666bf5d4f78a180
Author: Keith Packard <keithp@keithp.com>
Date:   Sun Nov 2 23:08:44 2008 -0800

    i915: Save/restore MCHBAR_RENDER_STANDBY on GM965/GM45
    
    This register is set by the 2D driver to prevent lockups, and so it needs to
    be preserved across suspend/resume too. This makes my X200s work.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
