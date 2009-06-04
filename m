Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZFDDkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZFDDkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZFDDjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:39:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55609 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbZFDDjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:39:51 -0400
Date: Thu, 4 Jun 2009 04:39:50 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.0906040438210.7074@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Have been out on holidays, so sorry these are a bit late, the radeon one 
fixes a regression reported since -rc1 so is most important.

Dave.

 drivers/gpu/drm/drm_bufs.c          |    3 +-
 drivers/gpu/drm/drm_crtc.c          |    7 ++-
 drivers/gpu/drm/drm_crtc_helper.c   |  109 ++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/drm_edid.c          |    5 ++
 drivers/gpu/drm/drm_irq.c           |    8 ++-
 drivers/gpu/drm/drm_sysfs.c         |    7 +-
 drivers/gpu/drm/i915/i915_dma.c     |   12 +---
 drivers/gpu/drm/i915/intel_crt.c    |    6 +--
 drivers/gpu/drm/i915/intel_dvo.c    |    1 +
 drivers/gpu/drm/i915/intel_hdmi.c   |    1 +
 drivers/gpu/drm/i915/intel_lvds.c   |    8 +--
 drivers/gpu/drm/i915/intel_sdvo.c   |    1 +
 drivers/gpu/drm/i915/intel_tv.c     |    1 +
 drivers/gpu/drm/radeon/radeon_cp.c  |    4 +-
 drivers/gpu/drm/radeon/radeon_drv.h |    5 +-
 include/drm/drm_crtc.h              |    3 +
 include/drm/drm_crtc_helper.h       |    2 +
 17 files changed, 151 insertions(+), 32 deletions(-)

commit fc43896630a421321a19d7970bac27ac94e9d162
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Jun 4 10:20:34 2009 +1000

    drm: ignore EDID with really tiny modes.
    
    Some EDIDs lie and report tiny modes that aren't possible. Ignore
    these modes.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6c51d1cfa0a370b48a157163340190cf5fd2346b
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue May 26 10:35:52 2009 +1000

    drm: don't associate _DRM_DRIVER maps with a master
    
    A driver will use the _DRM_DRIVER map flag to indicate that it wants
    to be responsible for removing the map itself, bypassing the DRM's
    automagic cleanup code.
    
    Since the multi-master changes this has been broken, resulting in some
    drivers having their registers unmapped before it's finished with them.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 93c05f222413e3a16e8785f252db4726693abd71
Author: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date:   Thu Jun 4 09:41:19 2009 +1000

    drm/i915: intel_lvds.c fix section mismatch
    
    intel_no_lvds[] does not require __initdata as it is used only by
    
    void intel_lvds_init(struct drm_device *dev).
    
    Signed-off-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c9fb15f60eb517c958dec64dca9357bf62bf2201
Author: Keith Packard <keithp@keithp.com>
Date:   Sat May 30 20:42:28 2009 -0700

    drm: Hook up DPMS property handling in drm_crtc.c. Add drm_helper_connector_dpms.
    
    Making the drm_crtc.c code recognize the DPMS property and invoke the
    connector->dpms function doesn't remove any capability from the driver while
    reducing code duplication.
    
    That just highlighted the problem with the existing DPMS functions which
    could turn off the connector, but failed to turn off any relevant crtcs. The
    new drm_helper_connector_dpms function manages all of that, using the
    drm_helper-specific crtc and encoder dpms functions, automatically computing
    the appropriate DPMS level for each object in the system.
    
    This fixes the current troubles in the i915 driver which left PLLs, pipes
    and planes running while in DPMS_OFF mode or even while they were unused.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e36ebaf49274ffa78f17b62bcae4c92c33b5b391
Author: Keith Packard <keithp@keithp.com>
Date:   Sat May 30 20:42:26 2009 -0700

    drm: set permissions on edid file to 0444
    
    Without initializing the sysfs attributes for the edid file,
    it was created with mode 0, making it difficult for applications to use.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 75185c929ed241f5cf1aa28999b8012181e2c7cb
Author: Keith Packard <keithp@keithp.com>
Date:   Sat May 30 20:42:25 2009 -0700

    drm: add newlines to text sysfs files
    
    The contents of various simple text files in sysfs should end with
    a newline to make them easier to read from the console.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9863871bd1bbf218b921af5e0bc48ca4f6ea9f12
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Jun 4 07:08:13 2009 +1000

    drm/radeon: fix ring free alignment calculations
    
    fd.o bz#21849
    
    We were aligning to +16 dwords, instead of to the next 16dword
    boundary in the ring. Fix the calculation to go to the next 16dword
    boundary when space checking.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b8da7de56ca0ad34726478a50d138a29a9ff76cb
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Jun 2 16:50:35 2009 +1000

    drm: fix irq naming for kms drivers.
    
    allocating devname in the i915 driver was a hack originally and I
    forgot to figure out how to do this properly back then.
    
    So this is the cleaner version that just picks devname or driver name
    in the irq code.
    
    It removes the devname allocs from the i915 driver.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
