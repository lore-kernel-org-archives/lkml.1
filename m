Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZI2Dw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZI2Dw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 23:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbZI2Dw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 23:52:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54220 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbZI2DwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 23:52:25 -0400
Date: Tue, 29 Sep 2009 04:52:31 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Message-ID: <alpine.DEB.2.00.0909290444250.31099@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

This might seem a bit big and I did mean to get it to you last week,
but got distracted by X things. However its been fairly well tested.

The only new feature which I feel is important enough to let in now
as it shouldn't disrupt much, is to allow kms to resepct video= on the
cmdline and set the initial mode and turn individual connectors on/off.
(it contains one patch to fb to allow this, which I've sent past the
fbdev list already)
There are also some fixes for the EDID parser.

Otherwise its mostly radeon related:
radeon kms fixups and reogranising
r600 non-kms bug fixes.
radeon large kmalloc avoidance, we sometimes could try and do
a 64k kmalloc if the userspace submitted a large enough packet,
this could fail, I've avoided this by using 2 separate pages
to cache parts of the userspace buffer.

Dave.

 drivers/gpu/drm/drm_crtc.c                 |    1 +
 drivers/gpu/drm/drm_crtc_helper.c          |   88 ++++++-
 drivers/gpu/drm/drm_edid.c                 |   46 +++-
 drivers/gpu/drm/drm_fb_helper.c            |  235 +++++++++++++++++-
 drivers/gpu/drm/drm_modes.c                |    3 +-
 drivers/gpu/drm/i915/intel_fb.c            |    5 +-
 drivers/gpu/drm/radeon/.gitignore          |    3 +
 drivers/gpu/drm/radeon/avivod.h            |    9 -
 drivers/gpu/drm/radeon/r100.c              |  197 ++++++---------
 drivers/gpu/drm/radeon/r100_track.h        |   69 +++++-
 drivers/gpu/drm/radeon/r200.c              |   79 +++---
 drivers/gpu/drm/radeon/r300.c              |  137 ++++-------
 drivers/gpu/drm/radeon/r500_reg.h          |    3 +
 drivers/gpu/drm/radeon/r520.c              |  276 ++++++++++++--------
 drivers/gpu/drm/radeon/r520d.h             |  187 ++++++++++++++
 drivers/gpu/drm/radeon/r600.c              |   11 +-
 drivers/gpu/drm/radeon/r600_cs.c           |  186 +++++++++++---
 drivers/gpu/drm/radeon/radeon.h            |   76 ++++++-
 drivers/gpu/drm/radeon/radeon_asic.h       |   80 +++---
 drivers/gpu/drm/radeon/radeon_atombios.c   |    9 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |   79 +++++--
 drivers/gpu/drm/radeon/radeon_cs.c         |  103 +++++++-
 drivers/gpu/drm/radeon/radeon_device.c     |   11 +-
 drivers/gpu/drm/radeon/radeon_drv.c        |    5 -
 drivers/gpu/drm/radeon/radeon_fb.c         |   26 ++-
 drivers/gpu/drm/radeon/radeon_kms.c        |   49 ----
 drivers/gpu/drm/radeon/radeon_reg.h        |    1 +
 drivers/gpu/drm/radeon/radeon_ttm.c        |    7 +-
 drivers/gpu/drm/radeon/rs600.c             |   20 +--
 drivers/gpu/drm/radeon/rs690.c             |    3 +-
 drivers/gpu/drm/radeon/rv515.c             |  364 +++++++++++++++++++--------
 drivers/gpu/drm/radeon/rv515d.h            |  385 +++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/rv770.c             |   11 +-
 drivers/video/fbmem.c                      |    2 +-
 include/drm/drm_crtc.h                     |   14 +-
 include/drm/drm_crtc_helper.h              |    4 +-
 include/drm/drm_fb_helper.h                |   24 ++
 37 files changed, 2117 insertions(+), 691 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/.gitignore
 create mode 100644 drivers/gpu/drm/radeon/r520d.h

commit f0ed1f655aa0375e2abba84cc4e8e6c853d48555
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Sep 28 20:39:19 2009 +0200

    drm/radeon/kms: Convert R520 to new init path and associated cleanup
    
    Convert the r520 asic support to new init path, change are smaller than
    previous one as most of the architecture is now in place and more code
    sharing can happen btw various asics.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d39c3b895876427c5083a936e00f3f5b7f0fc1b3
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Sep 28 18:34:43 2009 +0200

    drm/radeon/kms: Convert RV515 to new init path and associated cleanup
    
    Convert the rv515 asic support to new init path also add an explanation
    in radeon.h about the new init path. There is also few cleanups
    associated with this change (others asic calling rv515 helper
    functions).
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f4e45d02e4135043fe98bc21be38527c516ad990
Author: Mikael Pettersson <mikpe@it.uu.se>
Date:   Mon Sep 28 18:27:23 2009 +0200

    drm: fix radeon DRM warnings when !CONFIG_DEBUG_FS
    
    Compiling the radeon DRM driver with !CONFIG_DEBUG_FS
    throws the following warnings:
    
    drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_debugfs_init':
    drivers/gpu/drm/radeon/radeon_ttm.c:714: warning: unused variable 'i'
    drivers/gpu/drm/radeon/radeon_ttm.c: At top level:
    drivers/gpu/drm/radeon/radeon_ttm.c:692: warning: 'radeon_mem_types_list' defined but not used
    drivers/gpu/drm/radeon/radeon_ttm.c:693: warning: 'radeon_mem_types_names' defined but not used
    
    Fix: move these variables inside the #if defined(CONFIG_DEBUG_FS)
    block in radeon_ttm_debugsfs_init(), which is the only place using them.
    
    Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit bea1d35b8e1533ac493305b3efe04a4b7def8a7f
Author: Mikael Pettersson <mikpe@it.uu.se>
Date:   Mon Sep 28 18:26:25 2009 +0200

    drm: fix drm_fb_helper warning when !CONFIG_MAGIC_SYSRQ
    
    Compiling DRM throws the following warning if MAGIC_SYSRQ is disabled:
    
    drivers/gpu/drm/drm_fb_helper.c:101: warning: 'sysrq_drm_fb_helper_restore_op' defined but not used
    
    Fix: place sysrq_drm_fb_helper_restore_op and associated
    definitions inside #ifdef CONFIG_MAGIC_SYSRQ.
    
    Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4c57edba4588ddba40017fbde3cd356e600bdf80
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Sep 28 15:37:25 2009 +1000

    drm/r600: fix memory leak introduced with 64k malloc avoidance fix.
    
    The legacy r600 path shares code, but doesn't share quite enough
    to get the freeing correct. Free the pages here also.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 74bf2ad508efa93db4254c9da9c7238da44e2c58
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Sep 28 15:31:10 2009 +1000

    drm/kms: make fb helper work for all drivers.
    
    This initialises the fb helper with the connector helper,
    so that the fb cmdline code works for intel as well.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 210bed8f827471e271f894fb99ee879a5d27cf30
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 25 18:33:08 2009 -0400

    drm/radeon/r600: fix offset handling in CS parser
    
    Need add reloc offset to the offset in the actual
    packet.  Fixes use of the DRAW_INDEX packet by the 3D
    driver.
    
    [airlied: modified first one where idx_value == ib[idx+0]
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2b5d6c538b48772ba3351b8a8eed096f7af8de5d
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 25 17:32:14 2009 -0400

    drm/radeon/kms/r600: fix forcing pci mode on agp cards
    
    All we need to do on r6xx/r7xx is clear the RADEON_IS_AGP
    flag; the rest is handled in r600.c
    
    fixes fdo bug 23990:
    http://bugs.freedesktop.org/show_bug.cgi?id=23990
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit c5e617e2f84225a28823a3e19951273b9f59eb27
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Sep 26 09:03:39 2009 +1000

    drm/radeon/kms: fix for the extra pages copying.
    
    Thanks to Michel for pointing this out to me, this is
    why I need to get more sleep, over complicate this a bit.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2f67c6e0220e5311bb14895d32852250b2d9652b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 25 16:35:11 2009 -0400

    drm/radeon/kms/r600: add support for vline relocs
    
    Provides support for anti-tearing functionality
    in the ddx.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 90ebd0655ac1a19e591f2fe8b9a871cc03cc3989
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 25 16:39:24 2009 -0400

    drm/radeon/kms: fix some bugs in vline reloc
    
    - fix offset of NOP packet for parsing
    - fix p->idx increments
    - fix bad mask when updating crtc vline info
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 974b16e33ea626c9854f0f34fa5455a18822e159
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 25 10:06:39 2009 -0400

    drm/radeon/kms/r600: clamp vram to aperture size
    
    r6xx and r7xx was missing this.  We don't support
    non-CPU accessible vram yet.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 8ef8678c8f6131ca5941fa387cd3939c68c4f36d
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Sep 26 06:39:00 2009 +1000

    drm/kms: protect against fb helper not being created.
    
    If drivers don't init the fb helper on the connector, the cmdline
    code won't work, but it shouldn't crash either.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit adea4796cfb9b74d340f9e32ba523fb61305d0b7
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 25 14:23:47 2009 +1000

    drm/r600: get values from the passed in IB not the copy.
    
    this avoids reading back the IB on AGP, also it avoids
    the race where since we haven't fetched the page from the main IB
    and written it to the gpu one, reading back fetches 0.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 31edd4824ec42e7cba26498fbd35df6c66b098ba
Author: Amerigo Wang <amwang@redhat.com>
Date:   Wed Sep 23 04:24:05 2009 -0400

    drm: create gitignore file for radeon
    
    Got lots of untracked files after compiling.
    These files are generated, thus should be ignored by git.
    
    Signed-off-by: WANG Cong <amwang@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e3590096f7563c6e75b77336ab8775f9a168b0f6
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Sep 23 15:49:20 2009 +1000

    drm/radeon/kms: remove unneeded master create/destroy functions.
    
    We shouldn't need these at all in radeon kms mode.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d50ba256b5f1478e15accfcfda9b72fd7a661364
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Sep 23 14:44:08 2009 +1000

    drm/kms: start adding command line interface using fb.
    
    [note this requires an fb patch posted to linux-fbdev-devel already]
    
    This uses the normal video= command line option to control the kms
    output setup at boot time. It is used to override the autodetection
    done by kms.
    
    video= normally takes a framebuffer as the first parameter, in kms
    it will take a connector name, DVI-I-1, or LVDS-1 etc. If no output
    connector is specified the mode string will apply to all connectors.
    
    The mode specification used will match down the probed modes, and if
    no mode is found it will add a CVT mode that matches.
    
    video=1024x768 - all connectors match a 1024x768 mode or add a CVT on
    video=VGA-1:1024x768, VGA-1 connector gets mode only.
    
    The same strings as used in current fb modedb.c are used, except I've
    added three more letters, e, D, d, e = enable, D = enable Digital,
    d = disable, which allow a connector to be forced into a certain state.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f80330357284c908e1f67cc8b4d8e56a3e2f6fc6
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Sep 16 20:45:09 2009 +1000

    fb: change rules for global rules match.
    
    Having a : should be enough 'fb:' isn't really useful
    if the fb wants to a kms output ID.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 513bcb4655e68706594e45dfa1d4b181500110ba
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Sep 23 16:56:27 2009 +1000

    drm/radeon/kms: don't require up to 64k allocations. (v2)
    
    This avoids needing to do a kmalloc > PAGE_SIZE for the main
    indirect buffer chunk, it adds an accessor for all reads from
    the chunk and caches a single page at a time for subsequent
    reads.
    
    changes since v1:
    Use a two page pool which should be the most common case
    a single packet spanning > PAGE_SIZE will be hit, but I'm
    having trouble seeing anywhere we currently generate anything like that.
    hopefully proper short page copying at end
    added parser_error flag to set deep errors instead of having to test
    every ib value fetch.
    fixed bug in patch that went to list.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 35e4b7af21d77933abda3d41d1672589eb6c960c
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 25 11:56:50 2009 +1000

    drm/radeon/kms: enable dac load detection by default.
    
    when I added the property I forgot to enable it.
    
    Thanks to soreau on #radeon for tracking it down.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4bbd4973703bf8a5f00f05eff30a99cd9814f37f
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 25 08:56:12 2009 +1000

    drm/radeon/kms: enable r600 tv outputs.
    
    I never changed this back when I wrote tv-out support.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f066a17d9f8d0a20d01d1aa9badce7f43c7bd6ad
Author: Adam Jackson <ajax@redhat.com>
Date:   Wed Sep 23 17:31:21 2009 -0400

    drm/edid: Fix standard timing parse for EDID <= 1.2
    
    Aspect ratio code of 0 means 1:1 before EDID 1.3.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 93dc6c2b0d97a55508144073838e041140b206cd
Author: Adam Jackson <ajax@redhat.com>
Date:   Wed Sep 23 17:31:09 2009 -0400

    drm/edid: Detailed standard timing blocks have six timings, not five.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 23425caeebc2e06629ef04f6197543cfe3f7d7b2
Author: Adam Jackson <ajax@redhat.com>
Date:   Wed Sep 23 17:30:58 2009 -0400

    drm/edid: Ignore bad standard timings.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 083ae0560ab53b039aaa897b77458cbadf19050d
Author: Adam Jackson <ajax@redhat.com>
Date:   Wed Sep 23 17:30:45 2009 -0400

    drm/edid: const cleanup
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
