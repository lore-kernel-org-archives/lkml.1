Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbZGOHhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbZGOHhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZGOHhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:37:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58886 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbZGOHhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:37:05 -0400
Date: Wed, 15 Jul 2009 08:37:03 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git] drm-fixes
Message-ID: <alpine.DEB.2.00.0907150834110.16612@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This is just the simplest bug fixes that have showed up since rc1. It has 
one non-drm change to hide the old intelfb driver under CONFIG_EMBEDDED
and have it conflict with i915 kms code.

I've got an update for the radeon kms+ttm staging driver, that I'll
send a pull request for separately. I'm just confirming it doesn't touch 
anything outside the staging code.

Dave.

 drivers/gpu/drm/drm_debugfs.c   |    4 ++++
 drivers/gpu/drm/drm_gem.c       |   17 ++++++++++-------
 drivers/gpu/drm/drm_stub.c      |    3 ++-
 drivers/gpu/drm/ttm/ttm_bo_vm.c |    4 ++--
 drivers/gpu/drm/via/via_irq.c   |    6 +++++-
 drivers/video/Kconfig           |    3 ++-
 include/drm/drm_pciids.h        |    6 ++++--
 7 files changed, 29 insertions(+), 14 deletions(-)

commit ecca0683230b83e8f830ff157911fad20bc43015
Author: Julia Lawall <julia@diku.dk>
Date:   Sat Jul 11 09:50:09 2009 +0200

    drm: Move a dereference below a NULL test
    
    If the NULL test is necessary, then the dereference should be moved below
    the NULL test.
    
    The semantic patch that makes this change is as follows:
    (http://www.emn.fr/x-info/coccinelle/)
    
    // <smpl>
    @@
    type T;
    expression E;
    identifier i,fld;
    statement S;
    @@
    
    - T i = E->fld;
    + T i;
      ... when != E
          when != i
      if (E == NULL) S
    + i = E->fld;
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ba0ab82358a12e7a7f2872d6b65c437157c6888f
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Jul 3 11:24:46 2009 -0700

    fb/intelfb: conflict with DRM_I915 and hide by default
    
    Users get confused by this driver.  It's really a special purpose
    embedded driver, and causes a lot of problems if enabled.  So hide it
    under EMBEDDED by default, and make sure it doesn't get enabled with
    the i915 DRM driver.
    
    Dave, I'm hoping you can feed this to Linus through your tree.  It's
    appropriate for 2.6.31 I think.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 916635bfcae5fec170ccd36f4b451cf7c5d23b9d
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Wed Jul 15 16:00:37 2009 +1000

    drm/ttm: fix misplaced parentheses
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 42dd8619940a153e950c4d2301cd5e49f7342f99
Author: Simon Farnsworth <simon.farnsworth@onelan.com>
Date:   Fri Jul 10 11:25:16 2009 +0100

    drm/via: Fix vblank IRQ on VIA hardware.
    
    via_enable_vblank wasn't setting the VBlank enable bit - instead, it
    was masking out the rest of the register.
    
    At the same time, fix via_disable_vblank to clear the VBlank enable
    bit.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 845792d940f5755b7a7837c450a71d9e831a13e2
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Mon Jul 13 23:20:21 2009 +0200

    drm: drm_gem, check kzalloc retval
    
    Check kzalloc retval against NULL in drm_gem_object_alloc and bail out
    appropriately.
    
    While at it merge the fail paths and jump to them by gotos at the end
    of the function.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d25e3a6faa82eeaa6e5487c2d2e27cfd938ed108
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Mon Jul 13 23:20:20 2009 +0200

    drm: drm_debugfs, check kmalloc retval
    
    Check kmalloc return value in drm_debugfs_create_files and bail out
    appropriately if the pointer is NULL.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 069a9dce384e211784ce6fdfaf1f13921327480d
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Jul 1 13:03:52 2009 -0400

    drm/radeon: add some missing pci ids
    
    Also, fix ordering for a couple others
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
