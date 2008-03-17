Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYCQAhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYCQAhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 20:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYCQAg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 20:36:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38906 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbYCQAg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 20:36:59 -0400
Date: Mon, 17 Mar 2008 00:36:55 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm fixes for linux-2.6.25-rc6
Message-ID: <alpine.DEB.0.82.0803170033270.32458@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Sorry this is so late, but a number of things cropped up in the last week 
I thought were urgent enough to get into 2.6.25 final.

The PCI GART changes should fix
'2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang'

The VIA fixes are for a number of upstream bugs, along with the pci ids 
fixups so we work properly on a new series of ATI cards.

Dave.

 drivers/char/drm/ati_pcigart.c |   91 ++++++++++------------------------------
 drivers/char/drm/drmP.h        |    3 +
 drivers/char/drm/drm_fops.c    |    7 ++-
 drivers/char/drm/drm_lock.c    |   35 +++++++++-------
 drivers/char/drm/drm_pciids.h  |    7 ++-
 drivers/char/drm/r128_cce.c    |    1 +
 drivers/char/drm/radeon_cp.c   |    1 +
 drivers/char/drm/via_dma.c     |   59 +++++++++++++++++++++++---
 drivers/char/drm/via_dmablit.c |    2 +-
 9 files changed, 110 insertions(+), 96 deletions(-)

commit b05c23851ab820b1957cd2f322eaa1ac44c196bd
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Mar 17 10:24:24 2008 +1000

    drm/ati_pcigart: fix the PCIGART to use drm_pci to allocate GART table.
    
    This fixes a problem on 64-bit with 4GB with ATI RS690 chipsets. It
    makes sure the pcigart table is allocated in coherent memory for DMA operations.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 16d3be46d9ffbc2c562b25d66d59666db2cf2cd5
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Mar 17 10:22:12 2008 +1000

    drm/radeon: fixup RV550 chip family
    
    This fixes up the RV550 chips which are based on RV515, not RV530.
    It also adds another RS690 PCI ID.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f0fb6d7798e7e2d1f37a2c15892910661bdaba55
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Mon Mar 17 10:07:20 2008 +1000

    drm/via: attempt again to stabilise the AGP DMA command submission.
    
    It's worth remembering that all new bright ideas on how to make this command reader work properly and according to docs will probably fail :( Bring in some old code.
    
    Also allow a larger SG-DMA download stride, and remove unnecessary waits for
    command regulators pauses.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9df5808cca52f33e1deb52b5010c68c6ed1656fe
Author: Mike Isely <isely@isely.net>
Date:   Thu Mar 13 15:30:35 2008 -0500

    drm: Fix race that can lockup the kernel
    
    The i915_vblank_swap() function schedules an automatic buffer swap
    upon receipt of the vertical sync interrupt.  Such an operation is
    lengthy so it can't be allowed to happen in normal interrupt context,
    thus the DRM implements this by scheduling the work in a kernel
    softirq-scheduled tasklet.  In order for the buffer swap to work
    safely, the DRM's central lock must be taken, via a call to
    drm_lock_take() located in drivers/char/drm/drm_irq.c within the
    function drm_locked_tasklet_func().  The lock-taking logic uses a
    non-interrupt-blocking spinlock to implement the manipulations needed
    to take the lock.  This semantic would be safe if all attempts to use
    the spinlock only happen from process context.  However this buffer
    swap happens from softirq context which is really a form of interrupt
    context.  Thus we have an unsafe situation, in that
    drm_locked_tasklet_func() can block on a spinlock already taken by a
    thread in process context which will never get scheduled again because
    of the blocked softirq tasklet.  This wedges the kernel hard.
    
    To trigger this bug, run a dual-head cloned mode configuration which
    uses the i915 drm, then execute an opengl application which
    synchronizes buffer swaps against the vertical sync interrupt.  In my
    testing, a lockup always results after running anywhere from 5 minutes
    to an hour and a half.  I believe dual-head is needed to really
    trigger the problem because then the vertical sync interrupt handling
    is no longer predictable (due to being interrupt-sourced from two
    different heads running at different speeds).  This raises the
    probability of the tasklet trying to run while the userspace DRI is
    doing things to the GPU (and manipulating the DRM lock).
    
    The fix is to change the relevant spinlock semantics to be the
    interrupt-blocking form.  After this change I am no longer able to
    trigger the lockup; the longest test run so far was 20 hours (test
    stopped after that point).
    
    Note: I have examined the places where this spinlock is being
    employed; all are reasonably short bounded sequences and should be
    suitable for interrupts being blocked without impacting overall kernel
    interrupt response latency.
    
    Signed-off-by: Mike Isely <isely@pobox.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
