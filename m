Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbZBYE46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbZBYE46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZBYE4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:56:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56921 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbZBYE4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:56:48 -0500
Date: Wed, 25 Feb 2009 04:56:45 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0902250455330.804@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1301037077-1235537805=:804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1301037077-1235537805=:804
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

A bunch of KMS fixes from you and F11 testing. Still waiting on some 
resolution to the mtrr vs _wc remaps pain.

Dave.

 drivers/gpu/drm/drm_crtc_helper.c    |   76 ++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/drm_edid.c           |    6 +-
 drivers/gpu/drm/drm_irq.c            |   14 ++++--
 drivers/gpu/drm/i915/i915_dma.c      |    2 +-
 drivers/gpu/drm/i915/i915_gem.c      |    2 +-
 drivers/gpu/drm/i915/intel_bios.c    |    6 +++
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 include/drm/drm_crtc_helper.h        |    1 +
 include/drm/drm_edid.h               |    4 +-
 9 files changed, 97 insertions(+), 16 deletions(-)

commit e08fb4f6d1dc95eff5b3fc1d0412bcb5afcae7f2
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Feb 25 14:52:30 2009 +1000

    drm/i915: convert DRM_ERROR to DRM_DEBUG in phys object pwrite path
    
    This snuck in when I wrote phys object support.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dd0910b3c71b253c08111110f0399b924a8d5853
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Feb 25 14:49:21 2009 +1000

    drm/i915: make hw page ioremap use ioremap_wc
    
    However we still have another issue with ioremap_wc not falling back
    properly or somehow doing something else stupid, this probably needs
    to be tracked down.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d61e7380b402a481ab1fa8027068a24918f701c8
Author: Kyle McMartin <kyle@redhat.com>
Date:   Tue Feb 24 20:31:53 2009 -0500

    drm: edid revision 0 is valid
    
    edid->revision == 0 should be valid (at least, so the error message
    indicates. :) and wikipedia seems to indicate that EDID 1.0 existed.
    
    We can dump the entire check, since edid->revision is a u8, so
    it can't ever be less than 0.
    
    Marko reports in RH bz#476735 that his monitor claims to be
    EDID 1.0, and therefore hits the check and is stuck at 800x600 because
    of it.
    
    Reported-by: Marko Ristola <marko.ristola@kolumbus.fi>
    Signed-off-by: Kyle McMartin <kyle@redhat.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b3f5e7329df1a508ac58ebe7509fb7a47b9eab6a
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Feb 19 14:48:22 2009 +0000

    drm: Correct unbalanced drm_vblank_put() during mode setting.
    
    The first time we install a mode, the vblank will be disabled for a pipe
    and so drm_vblank_get() in drm_vblank_pre_modeset() will fail. As we
    unconditionally call drm_vblank_put() afterwards, the vblank reference
    counter becomes unbalanced.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7bec756c74b1a5079d5074144bb77a6b3e7d7783
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 23 16:09:34 2009 -0800

    drm: disable encoders before re-routing them
    
    In some cases we may receive a mode config that has a different
    CRTC<->encoder map that the current configuration.  In that case, we
    need to disable any re-routed encoders before setting the mode,
    otherwise they may not pick up the new CRTC (if the output types are
    incompatible for example).
    
    Tested-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit fe56cf45f951b3810313584605c1d8a4f20b33a4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 23 15:36:41 2009 -0800

    drm: Fix ordering of bit fields in EDID structure leading huge vsync values.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Reviewed-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit c8766ac5933d6ee75e7ce379a1eb5ceb451fcb83
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Feb 23 08:44:33 2009 -0800

    drm: Fix shifts of EDID vsync offset/width fields.
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Reviewed-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 37df96736bfe6f5fd9a141d62946e1083d73e712
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 23 15:36:42 2009 -0800

    drm/i915: handle bogus VBT panel timing
    
    We've seen cases in the wild where the VBT sync data is wrong, so add
    some code to fix it up in that case, taking care to make sure that the
    total is greater than the sync end.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7c04d1d97a8d918b7ae2ef478229862b71a65f06
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 23 15:36:40 2009 -0800

    drm/i915: remove PLL debugging messages
    
    These are normal; we walk through different values looking for the right
    one, so why flood the screen with messages?
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Reviewed-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-1301037077-1235537805=:804--
