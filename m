Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbYBTBMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbYBTBMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYBTBMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:12:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55108 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYBTBMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:12:33 -0500
Date: Wed, 20 Feb 2008 01:10:25 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm patches for 2.6.25-rc3
Message-ID: <alpine.DEB.0.82.0802200107360.23529@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

Mainly fixes for i915 suspend/resume issues, sis/radeon pci id addition,
and initial support for the GART on the AMD rs690 chipsets, along with 
the final nopage removal.

Dave.

 drivers/char/drm/drmP.h       |    2 +-
 drivers/char/drm/drm_pciids.h |    3 +
 drivers/char/drm/drm_sysfs.c  |    2 +-
 drivers/char/drm/drm_vm.c     |  125 ++++++++++++++++++-----------------------
 drivers/char/drm/i915_dma.c   |    5 +-
 drivers/char/drm/i915_drv.c   |   51 +++++++++++++----
 drivers/char/drm/i915_drv.h   |   17 ++++++
 drivers/char/drm/radeon_cp.c  |   81 ++++++++++++++++++++++++++
 drivers/char/drm/radeon_drv.h |   38 ++++++++++++
 9 files changed, 240 insertions(+), 84 deletions(-)

commit feac7af508ebdfe1db9920d4e45d0ffd286abe75
Author: Chaoyu Chen <chaoyu_chen@sis.com>
Date:   Wed Feb 20 10:12:39 2008 +1000

    drm/sis: add pciid for SiS 662/671 chipset
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f9e9716a67fbea4594749bf1022fdfd0b96099db
Author: Mirko <mailbox.stan@gmail.com>
Date:   Wed Feb 20 10:07:57 2008 +1000

    drm: add new rv380 pciid
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b932ccb5674eb649133b5c33950405c37d17aab3
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Feb 20 10:02:20 2008 +1000

    drm: add support for passing state into the suspend hooks.
    
    fix i915 driver to use state for hibernate save avoidance.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit da636ad6a0d72eb5cb99738056af0bcc3db9ef9d
Author: Jesse Barnes <jesse.barnes@intel.com>
Date:   Mon Jan 28 21:05:22 2008 -0800

    drm/i915: Fix hibernate save/restore of VGA attribute regs
    
    In hibernate, we may end up calling the VGA save regs function twice, so we need to make sure it's idempotent.  That means leaving ARX in index mode after the first save operation.  Fixes hibernate on 965.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1f84e550a870bf5f5f399b611db68f3324ea7883
Author: Keith Packard <keithp@keithp.com>
Date:   Sat Feb 16 19:19:29 2008 -0800

    drm/i915 more registers for S3 (DSPCLK_GATE_D, CACHE_MODE_0, MI_ARB_STATE)
    
    Failing to preserve the MI_ARB_STATE register was causing FIFO underruns on
    the VGA output on my HP 2510p after resume.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c0c4261b6fd80f0fc5546ed67058592469a4f5b7
Author: Jesse Barnes <jbarnes@hobbes.virtuousgeek.org>
Date:   Thu Feb 7 17:33:28 2008 -0800

    drm/i915: restore pipeconf regs unconditionally
    
    On many chipsets, the checks for DPLL enable or VGA mode will prevent the pipeconf regs from being restored, which could result in a blank display or X failing to come back after resume.  So restore them unconditionally along with actually restoring pipe B's palette correctly.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0da3ea12fc2607beb67c2d54d0347807ea615573
Author: Jesse Barnes <jbarnes@nietzche.virtuousgeek.org>
Date:   Wed Feb 20 09:39:58 2008 +1000

    drm/i915: save/restore interrupt state
    
    On resume, if the interrupt state isn't restored correctly, we may end
    up with a flood of unexpected or ill-timed interrupts, which could cause
    the kernel to disable the interrupt or vblank events to happen at the
    wrong time.  So save/restore them properly.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ca0b07d9a969c6561e5d6f69c861fbedf8d09e5d
Author: Nick Piggin <npiggin@suse.de>
Date:   Thu Feb 7 16:20:50 2008 +1000

    drm: convert drm from nopage to fault.
    
    Remove redundant vma range checks.
    
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b39d50e53b1bb27f6c29f88a697a4af78427dffd
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Feb 19 20:59:09 2008 +1000

    i915: wrap chipset types requiring hw status set ioctl
    
    Also applys to recent added new chipset.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 60f92683943c5b7a85963b283d6f8a853aa09203
Author: Maciej Cencora <m.cencora@gmail.com>
Date:   Tue Feb 19 21:32:45 2008 +1000

    drm/radeon: add initial rs690 support to drm.
    
    This adds support for configuring the RS690 GART.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
