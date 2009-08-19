Return-Path: <linux-kernel-owner+w=401wt.eu-S1750941AbZHSEPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941AbZHSEPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 00:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZHSEPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 00:15:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52431 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZHSEPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 00:15:53 -0400
Date: Wed, 19 Aug 2009 05:15:55 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes for -final
Message-ID: <alpine.DEB.2.00.0908190513050.20449@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2027893726-1250655355=:20449"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2027893726-1250655355=:20449
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

two non-staging kms fixes in this, one for a possible oops when destroying 
a framebuffer, one for reading EDID incorrectly on some monitors.

Some staging radeon kms fixes as well, rs690 vsync, r300 occlusion query 
support, and buffer idle api.

Dave.

 drivers/gpu/drm/drm_crtc.c                      |   40 +++-------
 drivers/gpu/drm/drm_edid.c                      |   72 +++++++++----------
 drivers/gpu/drm/radeon/r100.c                   |   86 +++++++++++++++++-----
 drivers/gpu/drm/radeon/r300.c                   |   38 ++++------
 drivers/gpu/drm/radeon/r500_reg.h               |   16 +++-
 drivers/gpu/drm/radeon/radeon.h                 |   54 ++++++++++++--
 drivers/gpu/drm/radeon/radeon_asic.h            |   26 +++++--
 drivers/gpu/drm/radeon/radeon_combios.c         |   48 +++++--------
 drivers/gpu/drm/radeon/radeon_device.c          |   13 +---
 drivers/gpu/drm/radeon/radeon_fb.c              |    2 +
 drivers/gpu/drm/radeon/radeon_gem.c             |   22 ++++++-
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |   54 --------------
 drivers/gpu/drm/radeon/radeon_kms.c             |   33 +++++++--
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |    7 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 drivers/gpu/drm/radeon/radeon_object.c          |   19 +++++
 drivers/gpu/drm/radeon/radeon_reg.h             |   11 ++-
 drivers/gpu/drm/radeon/rs600.c                  |   82 +++++++++++++++++++++
 drivers/gpu/drm/radeon/rs690.c                  |   65 +++++++++++++++++
 drivers/gpu/drm/radeon/rv515.c                  |   19 -----
 include/drm/radeon_drm.h                        |    2 +-
 21 files changed, 456 insertions(+), 254 deletions(-)

commit 5ef5f72febfea420ce58f670bad83830a5e5e3de
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 17 13:11:23 2009 +1000

    drm/kms: teardown crtc correctly when fb is destroyed.
    
    If userspace destroys a framebuffer that is in use on a crtc,
    don't just null it out, tear down the crtc properly so the
    hw gets turned off.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6a719e05330ef19acd9392dbbfb95a774776dee5
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 17 10:19:51 2009 +1000

    drm/kms/radeon: cleanup combios TV table like DDX.
    
    The fallback case wasn't getting executed properly if there
    was no TV table, which my T42 M7 hasn't got.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bf8e828b00a5b6a0fea16f452be578c060d57d64
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 17 10:20:47 2009 +1000

    drm/radeon/kms: memset the allocated framebuffer before using it.
    
    This gets rid of some ugliness, we shuold probably find a way
    for the GPU to zero this.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 80e6914db18e702549a15dea36fa7ace17f25c50
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 17 10:22:37 2009 +1000

    drm/radeon/kms: although LVDS might be possible on crtc 1 don't do it.
    
    LVDS always requests RMX_FULL, we need to fix it so that doesn't happen
    before we can enable LVDS on crtc 1.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cefb87efc9aa0288849149484870d5ab989fbd59
Author: Dave Airlie <airlied@redhat.com>
Date:   Sun Aug 16 21:05:45 2009 +1000

    drm/radeon/kms: implement bo busy check + current domain
    
    This implements the busy ioctl along with a current domain check.
    returns 0 or -EBUSY
    puts the current domain no matter what the answer.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit de1b28989edff519d0548ebaa3f94fd3d1524cf2
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Aug 12 18:43:14 2009 +1000

    drm/radeon/kms: cut down indirects in register accesses.
    
    We really don't want to be doing all these indirects, updating
    the GPU gart table is something we do often so the less overhead the
    better.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7ed220d738cf16adff6bc3b31ad25b8848a2fa9c
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Thu Aug 13 11:10:51 2009 +0200

    drm/radeon/kms: Fix up vertical blank interrupt support.
    
    Fixes 3D apps timing out in the WAIT_VBLANK ioctl.
    
    AVIVO bits compile-tested only.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3f8befec95d5c1bbc6e247e1a5dafa82519530f9
Author: Dave Airlie <airlied@redhat.com>
Date:   Sat Aug 15 20:54:13 2009 +1000

    drm/radeon/kms: add rv530 R300_SU_REG_DEST + reloc for ZPASS_ADDR
    
    These are needed for Occulsion Query support.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ebb177d2afb8532a8a316489aed545ed0c170802
Author: Dave Airlie <airlied@redhat.com>
Date:   Sat Aug 15 12:25:08 2009 +1000

    drm/edid: fixup detailed timings like the X server.
    
    this syncs the versioning check with the code the X server uses.
    
    Reported-by: Anssi Hannula <anssi.hannula@iki.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 616b8434688aa08bd6f019cc60c8dfe121e9e5ae
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Aug 6 17:47:24 2009 +0200

    drm/radeon/kms: Add specific rs690 authorized register table
    
    rs690 is r3xx 3D engine with AVIVO modesetting so we need to allow
    AVIVO register for vline synchronization. This add a specific table
    to rs690 to handle that. Thanks to Marc (marvin24) for debugging
    this and kudos to Andre (taiu1) for spotting the origin of the bugs.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

--29444707-2027893726-1250655355=:20449--
