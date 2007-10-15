Return-Path: <linux-kernel-owner+w=401wt.eu-S1762601AbXJOBR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762601AbXJOBR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXJOBRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:17:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55537 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbXJOBRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:17:18 -0400
Date: Mon, 15 Oct 2007 02:17:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm patches for 2.6.24-rc1
Message-ID: <Pine.LNX.4.64.0710150214200.27521@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This contains a major macro removal and ioctl related usercopy cleanups, 
it also fixes a bug in the intel interrupt code with a dodgy calloc size.

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

Dave.

  drivers/char/drm/drm.h            |   20 +-
  drivers/char/drm/drmP.h           |  237 +++++++------
  drivers/char/drm/drm_agpsupport.c |  130 +++-----
  drivers/char/drm/drm_auth.c       |   48 ++--
  drivers/char/drm/drm_bufs.c       |  203 ++++-------
  drivers/char/drm/drm_context.c    |  177 ++++------
  drivers/char/drm/drm_dma.c        |   11 +-
  drivers/char/drm/drm_drawable.c   |   67 ++---
  drivers/char/drm/drm_drv.c        |  186 ++++++-----
  drivers/char/drm/drm_fops.c       |   34 +-
  drivers/char/drm/drm_ioc32.c      |    2 +-
  drivers/char/drm/drm_ioctl.c      |  196 +++++-------
  drivers/char/drm/drm_irq.c        |   98 +++----
  drivers/char/drm/drm_lock.c       |   75 ++---
  drivers/char/drm/drm_os_linux.h   |   10 -
  drivers/char/drm/drm_pciids.h     |    2 -
  drivers/char/drm/drm_scatter.c    |   48 +--
  drivers/char/drm/drm_vm.c         |    4 +-
  drivers/char/drm/i810_dma.c       |  312 ++++++------------
  drivers/char/drm/i810_drm.h       |    5 -
  drivers/char/drm/i810_drv.h       |    9 +-
  drivers/char/drm/i830_dma.c       |  210 +++++-------
  drivers/char/drm/i830_drv.h       |   15 +-
  drivers/char/drm/i830_irq.c       |   30 +--
  drivers/char/drm/i915_dma.c       |  214 ++++++-------
  drivers/char/drm/i915_drv.h       |   36 ++-
  drivers/char/drm/i915_irq.c       |  128 +++----
  drivers/char/drm/i915_mem.c       |  125 +++----
  drivers/char/drm/mga_dma.c        |  140 ++++-----
  drivers/char/drm/mga_drv.h        |   21 +-
  drivers/char/drm/mga_state.c      |  197 +++++-------
  drivers/char/drm/mga_warp.c       |    8 +-
  drivers/char/drm/r128_cce.c       |  138 ++++-----
  drivers/char/drm/r128_drm.h       |   18 -
  drivers/char/drm/r128_drv.h       |   23 +-
  drivers/char/drm/r128_state.c     |  351 +++++++++-----------
  drivers/char/drm/r300_cmdbuf.c    |   68 ++--
  drivers/char/drm/radeon_cp.c      |  146 ++++-----
  drivers/char/drm/radeon_drv.h     |   43 ++--
  drivers/char/drm/radeon_irq.c     |   34 +--
  drivers/char/drm/radeon_mem.c     |  108 +++----
  drivers/char/drm/radeon_state.c   |  683 +++++++++++++++++--------------------
  drivers/char/drm/savage_bci.c     |  145 ++++-----
  drivers/char/drm/savage_drv.h     |    9 +-
  drivers/char/drm/savage_state.c   |  200 ++++++------
  drivers/char/drm/sis_drv.c        |    2 +-
  drivers/char/drm/sis_drv.h        |    5 +-
  drivers/char/drm/sis_mm.c         |  112 +++----
  drivers/char/drm/via_dma.c        |  144 ++++-----
  drivers/char/drm/via_dmablit.c    |   54 ++--
  drivers/char/drm/via_drv.h        |   22 +-
  drivers/char/drm/via_irq.c        |   47 ++--
  drivers/char/drm/via_map.c        |   14 +-
  drivers/char/drm/via_mm.c         |   83 ++---
  drivers/char/drm/via_verifier.c   |    8 +-
  drivers/char/drm/via_video.c      |   20 +-
  56 files changed, 2359 insertions(+), 3116 deletions(-)

commit ace3dff5b7f0bf5a647e60dcd0c0a7d46792f5d9
Author: Xavier Bachelot <xavier@bachelot.org>
Date:   Mon Oct 15 11:09:35 2007 +1000

     via invalid device ids removal

     0x1106, 0x7204 is unknown and thus is not an IGP/GPU.
     0x1106, 0x3304 is K8M800 hostbridge, not an IGP/GPU.
     None of them are in drm git tree.

     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Dave Airlie <airlied@redhat.com>

commit eed0f722b3fccb1eb2706b5f484cb511d46f70b8
Author: chaohong guo <Minskey.Guo@Sun.COM>
Date:   Mon Oct 15 10:45:49 2007 +1000

     radeon: Commit the ring after each partial texture upload blit.

     This makes sure each blit starts as early as possible, which may improve
     texture upload performance in some cases.

     Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 54583bf4efda79388fc13163e35c016c8bc5de81
Author: Dave Airlie <airlied@redhat.com>
Date:   Sun Oct 14 21:21:30 2007 +1000

     i915: fix vbl swap allocation size.

     Oops...

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit c153f45f9b7e30289157bba3ff5682291df16caa
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Sep 3 12:06:45 2007 +1000

     drm: Replace DRM_IOCTL_ARGS with (dev, data, file_priv) and remove DRM_DEVICE.

     The data is now in kernel space, copied in/out as appropriate according to t
     This results in DRM_COPY_{TO,FROM}_USER going away, and error paths to deal
     with those failures.  This also means that XFree86 4.2.0 support for i810 DR
     is lost.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b589ee5943a9610ebaea6e4e3433f2ae4d812b0b
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Aug 28 15:16:47 2007 +1000

     drm: remove XFREE86_VERSION macros.

     These are no longer needed or being used.

     Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6c340eac0285f3d62406d2d902d0e96fbf2a5dc0
Author: Eric Anholt <eric@anholt.net>
Date:   Sat Aug 25 20:23:09 2007 +1000

     drm: Replace filp in ioctl arguments with drm_file *file_priv.

     As a fallout, replace filp storage with file_priv storage for "unique
     identifier of a client" all over the DRM.  There is a 1:1 mapping, so this
     should be a noop.  This could be a minor performance improvement, as everyth
     on Linux dereferenced filp to get file_priv anyway, while only the mmap ioct
     went the other direction.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 20caafa6ecb2487d9b223aa33e7cc704f912a758
Author: Eric Anholt <eric@anholt.net>
Date:   Sat Aug 25 19:22:43 2007 +1000

     drm: Remove DRM_ERR OS macro.

     This was used to make all ioctl handlers return -errno on linux and errno on
     *BSD.  Instead, just return -errno in shared code, and flip sign on return f
     shared code to *BSD code.

     Signed-off-by: Dave Airlie <airlied@linux.ie>
