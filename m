Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYK1D01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYK1D01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 22:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYK1D0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 22:26:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44237 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYK1D0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 22:26:16 -0500
Date: Fri, 28 Nov 2008 03:26:14 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes for 2.6.28 final
Message-ID: <alpine.DEB.2.00.0811280325110.25353@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This larger than we wished patch, fixes a number of regressions reported.

1. vblank rework causes hangs on VT switch - fixes touches all drivers.
2. i915 irq/msi code had various issues on various hw - including a screaming
IRQ.
3. a suspend/resume regression on intel hw with DRI2 userspace.
4. A BUG_ON being hit.

Dave.

 drivers/gpu/drm/drm_drv.c            |    2 +
 drivers/gpu/drm/drm_irq.c            |    4 +-
 drivers/gpu/drm/i915/i915_dma.c      |    7 +
 drivers/gpu/drm/i915/i915_drv.h      |   11 ++
 drivers/gpu/drm/i915/i915_gem.c      |   74 +++++----
 drivers/gpu/drm/i915/i915_irq.c      |  293 ++++++++++++++++++----------------
 drivers/gpu/drm/i915/i915_opregion.c |   18 +--
 drivers/gpu/drm/i915/i915_suspend.c  |    6 +
 drivers/gpu/drm/mga/mga_dma.c        |    8 +
 drivers/gpu/drm/mga/mga_irq.c        |    5 -
 drivers/gpu/drm/r128/r128_drv.c      |    6 +
 drivers/gpu/drm/r128/r128_drv.h      |    1 +
 drivers/gpu/drm/r128/r128_irq.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c   |    6 +
 drivers/gpu/drm/radeon/radeon_irq.c  |    5 -
 drivers/gpu/drm/via/via_irq.c        |    1 -
 drivers/gpu/drm/via/via_map.c        |   11 ++-
 include/drm/drmP.h                   |    1 +
 18 files changed, 262 insertions(+), 199 deletions(-)

commit 461cba2d294fe83297edf8a6556912812903dce1
Author: Peng Li <peng.li@intel.com>
Date:   Tue Nov 18 12:39:02 2008 +0800

    drm/i915: Save/restore HWS_PGA on suspend/resume
    
    It fixes suspend/resume failure of xf86-video-intel dri2
    branch. As dri2 branch doesn't call I830DRIResume() to restore
    hardware status page anymore, we need to preserve
    this register across suspend/resume.
    
    Signed-off-by: Peng Li <peng.li@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 52440211dcdc52c0b757f8b34d122e11b12cdd50
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Nov 18 09:30:25 2008 -0800

    drm: move drm vblank initialization/cleanup to driver load/unload
    
    drm vblank initialization keeps track of the changes in driver-supplied
    frame counts across vt switch and mode setting, but only if you let it by
    not tearing down the drm vblank structure.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6133047aa64d2fd5b3b79dff74f696ded45615b2
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Nov 20 23:14:48 2008 -0800

    drm/i915: execbuffer pins objects, no need to ensure they're still in the GTT
    
    Before we had the notion of pinning objects, we had a kludge around to make
    sure all of the objects were still resident in the GTT before we committed
    to executing a batch buffer. We don't need this any longer, and it sticks an
    error return in the middle of object domain computations that must be
    associated with a subsequent flush/invalidate emmission into the ring.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 05eff845a28499762075d3a72e238a31f4d2407c
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Nov 19 14:03:05 2008 -0800

    drm/i915: Always read pipestat in irq_handler
    
    Because we write pipestat before iir, it's possible that a pipestat
    interrupt will occur between the pipestat write and the iir write. This
    leaves pipestat with an interrupt status not visible in iir. This may cause
    an interrupt flood as we never clear the pipestat event.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2678d9d6964b29ecd1975870c7a850242b29bc5c
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Nov 20 22:54:54 2008 -0800

    drm/i915: Subtract total pinned bytes from available aperture size
    
    The old code was wandering through the active list looking for pinned
    buffers; there may be other pinned buffers around. Fortunately, we keep a
    count of the total amount of pinned memory and can use that instead.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 28dfe52a6e8a1495067c4331358700a170d0ee86
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Nov 13 15:00:55 2008 -0800

    drm/i915: Avoid BUG_ONs on VT switch with a wedged chipset.
    
    Instead, just warn that bad things are happening and do our best to clean up
    the mess without the GPU's help.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cdfbc41f6d602fc0105fb2b4e0645cc1aa274c12
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Nov 4 15:50:30 2008 -0800

    drm/i915: Remove IMR masking during interrupt handler, and restart it if needed.
    
    The IMR masking was a technique recommended for avoiding getting stuck with
    no interrupts generated again in MSI mode.  It kept new IIR bits from getting
    set between the IIR read and the IIR write, which would have otherwise
    prevented an MSI from ever getting generated again.  However, this caused a
    problem for vblank as the IMR mask would keep the pipe event interrupt from
    getting reflected in IIR, even after the IMR mask was brought back down.
    
    Instead, just check the state of IIR after we ack the interrupts we're going
    to handle, and restart if we didn't get IIR all the way to zero.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7c463586427bbbad726ba561bae4ba5acada2481
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Nov 4 02:03:27 2008 -0800

    drm/i915: Manage PIPESTAT to control vblank interrupts instead of IMR.
    
    The pipestat fields affect reporting of all vblank-related interrupts, so we
    have to reset them during the irq_handler, and while enabling vblank
    interrupts.  Otherwise, if a pipe status field had been set to non-zero
    before enabling reporting, we would never see an interrupt again.
    
    This patch adds i915_enable_pipestat and i915_disable_pipestat to abstract
    out the steps needed to change the reported interrupts.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
