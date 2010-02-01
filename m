Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0BACyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 21:54:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44829 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0BACyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 21:54:13 -0500
Date: Mon, 1 Feb 2010 02:53:59 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-771353356-1264992839=:15366"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-771353356-1264992839=:15366
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

> Hi Linus,
> 
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> 

I've also added an oops fix I seem to lose off my radar to this tree.

commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Fri Jan 22 09:20:00 2010 +0100

    drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
    
    If radeon_cs_parser_init() fails, radeon_cs_ioctl() calls
    radeon_cs_parser_fini() with the non-zero error value. The latter 
dereferenc
    parser->ib which hasn't been initialized yet -> boom. Add a test for 
parser-
    being non-NULL before dereferencing it.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>


> Major change is to move the radeon KMS enable out of staging and into 
> normal Kconfig land, its not perfect but its as good as userspace was for 
> most people.
> 
> others:
> drm core: just a bogus comment removal
> ttm: a few changes one fixes an error printf in reserve_ram_pages_type, 
> radeon: Displayport fixes, tested on all the displayport machines I own 
> (i.e. 2) but they both now work, r600 blit mutex, AGP warning fix.
> 
> vmwgfx: 3 patches for older version of vmware workstation, I think vmware 
> have one more patch but since this driver is staging it can wait until 
> merge window anyways.
> 
> Dave.
> 
>  drivers/gpu/drm/Kconfig                  |    2 +
>  drivers/gpu/drm/radeon/atombios_dp.c     |   27 ++---
>  drivers/gpu/drm/radeon/r600.c            |   54 +++++-----
>  drivers/gpu/drm/radeon/r600_blit_kms.c   |    7 +-
>  drivers/gpu/drm/radeon/radeon.h          |    1 +
>  drivers/gpu/drm/radeon/radeon_agp.c      |   18 ++--
>  drivers/gpu/drm/radeon/radeon_encoders.c |  165 ++++++++++++++++-------------
>  drivers/gpu/drm/radeon/radeon_mode.h     |    2 +-
>  drivers/gpu/drm/radeon/rv770.c           |   31 +++---
>  drivers/gpu/drm/ttm/ttm_bo_util.c        |    9 +--
>  drivers/gpu/drm/ttm/ttm_object.c         |    2 +-
>  drivers/gpu/drm/ttm/ttm_tt.c             |   23 +++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |   13 +++
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h      |    3 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c     |   19 ++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c    |    2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c      |   10 ++
>  drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   16 +++-
>  drivers/staging/Kconfig                  |    2 -
>  include/drm/drm_mode.h                   |    2 +-
>  20 files changed, 244 insertions(+), 164 deletions(-)
> 
> commit f71d0187987e691516cd10c2702f002c0e2f0edc
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Mon Feb 1 11:35:47 2010 +1000
> 
>     drm/radeon/kms: move radeon KMS on/off switch out of staging.
>     
>     We are happy enough that the KMS driver is stable enough for enough people
>     for the kms enable/disable to leave staging. Distros can now contemplate
>     turning this on.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit ff82f052d2a187dd0fa0e431ba70eb457c71a40e
> Author: Jerome Glisse <jglisse@redhat.com>
> Date:   Fri Jan 22 15:19:00 2010 +0100
> 
>     drm/radeon/kms: Bailout of blit if error happen & protect with mutex V3
>     
>     If an error happen in r600_blit_prepare_copy report it rather
>     than WARNING and keeping execution. For instance if ib allocation
>     failed we did just warn about but then latter tried to access
>     NULL ib ptr causing oops. This patch also protect r600_copy_blit
>     with a mutex as otherwise one process might overwrite blit temporary
>     data with new one possibly leading to GPU lockup.
>     
>     Should partialy or totaly fix:
>     https://bugzilla.redhat.com/show_bug.cgi?id=553279
>     
>     V2 failing blit initialization is not fatal, fallback to memcpy when
>     this happen
>     V3 init blit before startup as we pin in startup, remove duplicate
>     code (this one was actualy tested unlike V2)
>     
>     Signed-off-by: Jerome Glisse <jglisse@redhat.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 5ffdb658f605cbc420944e7c7eeec9fbb8a73772
> Author: Jakob Bornecrantz <jakob@vmware.com>
> Date:   Sat Jan 30 03:38:08 2010 +0000
> 
>     drm/vmwgfx: Don't send bad flags to the host
>     
>     Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit c188660f6dbb0df9febe1b841a16c66c28353c15
> Author: Peter Hanzel <hanzelpeter@gmail.com>
> Date:   Sat Jan 30 03:38:07 2010 +0000
> 
>     drm/vmwgfx: Request SVGA version 2 and bail if not found
>     
>     This fixes the driver not loading on older versions of VMware.
>     
>     Signed-off-by: Peter Hanzel <hanzelpeter@gmail.com>
>     Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 8e19a951774a16cf2626292ae06fd2b62630e67e
> Author: Jakob Bornecrantz <jakob@vmware.com>
> Date:   Sat Jan 30 03:38:06 2010 +0000
> 
>     drm/vmwgfx: Correctly detect 3D
>     
>     Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 110b20c3ddcfa98cc932aef3af2d59b4e0841f08
> Author: Austin Yuan <shengquan.yuan@gmail.com>
> Date:   Thu Jan 21 13:45:40 2010 +0800
> 
>     drm/ttm: remove unnecessary save_flags and ttm_flag_masked in ttm_bo_util.c
>     
>     Signed-off-by: Austin Yuan <shengquan.yuan@gmail.com>
>     Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit fa5829b36539067f3c675f5d437531dedcfc4ad8
> Author: Marcin Kościelnicki <koriakin@0x04.net>
> Date:   Sat Jan 23 10:25:28 2010 +1000
> 
>     drm/kms: Remove incorrect comment in struct drm_mode_modeinfo
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit dd5fde6041d7ea30fcfedcc159a4cec8b01f73b2
> Author: Richard Kennedy <richard@rsk.demon.co.uk>
> Date:   Tue Jan 26 17:10:48 2010 +0000
> 
>     drm/ttm: remove padding from ttm_ref_object on 64bit builds
>     
>     Re-order structure ttm_ref_object to remove 8 bytes of alignment padding
>     on 64 bit builds, so shrinking its size from 72 to 64 bytes allowing it
>     to fit into a smaller slab.
>     
>     Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
>     Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 4b866288be6ffaefaad9cec212cb09e3258a68ee
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Mon Feb 1 11:22:10 2010 +1000
> 
>     drm/radeon/kms: release agp on error.
>     
>     if we get an error, release the AGP if we've acquired it already.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 2dea2e29b9fad48c759aa406b5ea426bff4339af
> Author: John Kacur <jkacur@redhat.com>
> Date:   Sun Jan 31 20:38:03 2010 +0100
> 
>     drm/kms/radeon/agp: Move the check of the aper_size after drm_acp_acquire and drm_agp_info
>     
>     First call drm_agp_acquire to check if agp has been acquired.
>     Second call drm_agp_info to fill in the info data struct, including aper_size.
>     Finally do the check to see if the aper_size makes sense.
>     
>     Signed-off-by: John Kacur <jkacur@redhat.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit cdb6e375c3c84558ed2c13c5461b22e8f7b7980e
> Author: John Kacur <jkacur@redhat.com>
> Date:   Sun Jan 31 20:38:02 2010 +0100
> 
>     drm/kms/radeon/agp: Fix warning, format ‘%d’ expects type ‘int’, but argument 4 has type ‘size_t’
>     
>     - Fix warning by using %zu instead of %d for size_t
>     - Fix spelling mistake, "to" should be "too".
>     
>     Signed-off-by: John Kacur <jkacur@redhat.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit db78e27de7e29a6db6be7caf607cf803d84094aa
> Author: Francisco Jerez <currojerez@riseup.net>
> Date:   Tue Jan 12 18:49:43 2010 +0100
> 
>     drm/ttm: Avoid conflicting reserve_memtype during ttm_tt_set_page_caching.
>     
>     Fixes errors like:
>     > reserve_ram_pages_type failed 0x15b7a000-0x15b7b000, track 0x8, req 0x10
>     when a BO is moved between WC and UC areas.
>     
>     Reported-by: Xavier Chantry <shiningxc@gmail.com>
>     Signed-off-by: Francisco Jerez <currojerez@riseup.net>
>     Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit f28cf33945cc112f8ee835512b7440905dc29ad2
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Thu Jan 28 17:15:25 2010 +1000
> 
>     drm/kms/radeon: pick digitial encoders smarter. (v3)
>     
>     booting a Lenovo W500 with LVDS + DP outputs showed up a TODO we had
>     on our list, to pick a correct digital encoder block. The LVTMA
>     encoder requires the second digital encoder, all others can use any
>     encoder at all.
>     
>     This fixes the digital encoder selection logic to enable LVDS/DP combos
>     to work okay.
>     
>     V2: fix silly addition of connector dig_block and cleanup the other
>     places in the code that pick the encoder.
>     
>     V3: rename to dig_encoder and clean up further - also fix
>     the picking algorithm.
>     
>     tested on Lenovo W500 + desktop 3650 cards.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 43c33ed87d0f1b900a6a3014db556ecc7f4a989b
> Author: Dave Airlie <airlied@linux.ie>
> Date:   Fri Jan 29 15:55:30 2010 +1000
> 
>     drm/radeon/kms: use active device to pick connector for encoder
>     
>     On the W500 we have UNIPHY routed to both DVI and DP, this seems
>     to always pick the DVI connector which means link training fails.
>     
>     Switch to using active device to pick the connector, this seems
>     like it should be safe from a code review, and it fixes things
>     a bit more here.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> commit 97b94ccb9aa1b82ed7a9a045d0ae5b32c99b84a0
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Fri Jan 29 15:31:47 2010 +1000
> 
>     drm/radeon/kms: fix incorrect logic in DP vs eDP connector checking.
>     
>     This makes displayport work again here.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-771353356-1264992839=:15366--
