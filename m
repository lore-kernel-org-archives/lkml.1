Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0BEEPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 23:15:32 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42114 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0BEEPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 23:15:30 -0500
Date: Fri, 5 Feb 2010 04:15:17 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: mingo@elte.hu, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1002050411100.22568@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

All radeon related: 2 warning fixes
2 r600/700 regression fixes
1 r100/r200 rendering fix (always broken with KMS)
1 HDMI audio regression work around - turn off audioon that hw for now
1 oops fix seen on Ingo's machine in the failure path
2 rs480 fixes from my laptop - one fixes scary MC idling messages
1 r300 vram width calc fix.

I'm sort of hoping the vram width fix will help on Ingo's machine
Ingo, 5ff55717674470b96562f931f778c878080755b7 is the commit id if you 
want to try it out, its definitely wrong when I compared it to the docs.
I'm still code-reviewing more of r300.c.

Dave.

 drivers/gpu/drm/ati_pcigart.c              |    2 +-
 drivers/gpu/drm/radeon/r100.c              |   14 +++++---
 drivers/gpu/drm/radeon/r300.c              |   16 +++++----
 drivers/gpu/drm/radeon/r420.c              |    3 +-
 drivers/gpu/drm/radeon/r520.c              |    3 +-
 drivers/gpu/drm/radeon/r600.c              |   48 +++++++++++++++++++--------
 drivers/gpu/drm/radeon/r600_audio.c        |    2 +-
 drivers/gpu/drm/radeon/radeon.h            |    8 +++++
 drivers/gpu/drm/radeon/radeon_asic.h       |   11 ++++++
 drivers/gpu/drm/radeon/radeon_combios.c    |    3 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 drivers/gpu/drm/radeon/radeon_gem.c        |    3 ++
 drivers/gpu/drm/radeon/rs400.c             |   28 ++++++++++++----
 drivers/gpu/drm/radeon/rs600.c             |    2 -
 drivers/gpu/drm/radeon/rs690.c             |    2 -
 drivers/gpu/drm/radeon/rv515.c             |    4 +--
 drivers/gpu/drm/radeon/rv770.c             |   24 +++++++-------
 17 files changed, 114 insertions(+), 61 deletions(-)

commit 5ff55717674470b96562f931f778c878080755b7
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Feb 5 13:57:03 2010 +1000

    drm/radeon/kms: fix r300 vram width calculations
    
    This was incorrect according to the docs and the UMS driver does
    it like this.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a17538f93c16f0e15e35dc31eedad87e2d9c5c26
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Feb 5 13:41:54 2010 +1000

    drm/radeon/kms: rs400/480 MC setup is different than r300.
    
    Boot testing on my rs480 laptop found the MC idle never happened
    on startup, a quick check with AMD found the idle bit is in a different
    place on the rs4xx than r300.
    
    Implement a new rs400 mc idle function to fix this.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 624ab4f87e99f10ea3b45e76039c477fd4d7a7e6
Author: Dave Airlie <airlied@davers480.(none)>
Date:   Wed Jan 27 16:07:15 2010 +1000

    drm/radeon/kms: make initial state of load detect property correct.
    
    this was incorrect on my rs480.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 23fff28a9b0529869bffef8aab0d3f350dd3b5a4
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Feb 5 11:57:42 2010 +1000

    drm/radeon/kms: disable HDMI audio for now on rv710/rv730
    
    Support isn't correct yet and we are getting green tinges on the
    displays.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 655efd3dc92cd0d37292157178d33deb0430aeaa
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Feb 2 11:51:45 2010 +0100

    drm/radeon/kms: don't call suspend path before cleaning up GPU
    
    In suspend path we unmap the GART table while in cleaning up
    path we will unbind buffer and thus try to write to unmapped
    GART leading to oops. In order to avoid this we don't call the
    suspend path in cleanup path. Cleanup path is clever enough
    to desactive GPU like the suspend path is doing, thus this was
    redondant.
    
    Tested on: RV370, R420, RV515, RV570, RV610, RV770 (all PCIE)
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 94cf6434a1bc5958d5da3be62f1272792dada2bf
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Feb 2 14:40:29 2010 -0800

    drivers/gpu/drm/radeon/radeon_combios.c: fix warning
    
    drivers/gpu/drm/radeon/radeon_combios.c: In function 'radeon_combios_get_lvds_info':
    drivers/gpu/drm/radeon/radeon_combios.c:893: warning: comparison is always false due to limited range of data type
    
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d7748bacbbee80b2cc4b690a74d5db2cd84acd7b
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Tue Feb 2 14:40:33 2010 -0800

    ati_pcigart: fix printk format warning
    
    Fix ati_pcigart printk format warning:
    
    drivers/gpu/drm/ati_pcigart.c:115: warning: format '%Lx' expects type 'long long unsigned int', but argument 3 has type 'dma_addr_t'
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9e5b2af75abc67c13005c706cf95bbbb78f7fddc
Author: Pauli Nieminen <suokkos@gmail.com>
Date:   Thu Feb 4 19:20:53 2010 +0200

    drm/r100/kms: Emit cache flush to the end of command buffer. (v2)
    
    Cache flush is required in case CPU is accessing rendered data.
    
    This fixes glean/readPixSanity test case and random rendering
    errors in sauerbraten and warzone2100.
    
    v2 Fix comment ordering in r100_fence_ring_emit and remove extra
       defines added in first version.
    
    Signed-off-by: Pauli Nieminen <suokkos@gmail.com>
    Reviewed-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 062b389c8704e539e234cfd67c7e034a514f50bf
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Feb 4 20:36:39 2010 +0100

    drm/radeon/kms: fix regression rendering issue on R6XX/R7XX
    
    It seems that some R6XX/R7XX silently ignore HDP flush when
    programmed through ring, this patch addback an ioctl callback
    to allow R6XX/R7XX hw to perform such flush through MMIO in
    order to fix a regression. For more details see:
    
    http://bugzilla.kernel.org/show_bug.cgi?id=15186
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c38c7b64a2747a211c3a6e8e5919ee25ccd474e7
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Feb 4 17:27:27 2010 +0100

    drm/radeon/kms: move blit initialization after we disabled VGA
    
    VGA might be overwritting VRAM and corrupt our blit shader leading
    to corruption, it likely won't happen if you load fbcon right after
    radeon. Thanks to Shawn Starr and Andre Maasikas for tracking down
    this issue.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
