Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYC2WJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYC2WJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYC2WJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:09:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58740 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbYC2WJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:09:03 -0400
Date: Sat, 29 Mar 2008 22:09:00 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm fixes for 2.6.25 final
Message-ID: <alpine.DEB.0.82.0803292203590.16871@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This contains a bug fix for hangs in the r300 3D system due to a really 
badly defined hardware wait interface, I've had to do some workarounds as 
its a userspace exposed interface and I want to fix it for old and new 
users. I've also included an oops fixer, a sparse cleanup, and patch to 
support non-coherent DMA for powerpc that I was going to hold but since 
I'm pushing stuff it may as well go now..

Dave.

 drivers/char/drm/ati_pcigart.c |    6 ++++
 drivers/char/drm/drm_scatter.c |   11 +++++++-
 drivers/char/drm/drm_vm.c      |   20 +++++++++++---
 drivers/char/drm/i915_dma.c    |    3 ++
 drivers/char/drm/r300_cmdbuf.c |   54 +++++++++++++++++++++++++++++++---------
 drivers/char/drm/radeon_drm.h  |   12 +++++++++
 drivers/char/drm/radeon_mem.c  |    8 +++---
 7 files changed, 92 insertions(+), 22 deletions(-)

commit 6876b3bacaaa4c73fb8752b47c84b2b7fad5422a
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Fri Mar 28 14:23:07 2008 -0700

    drm: fix for non-coherent DMA PowerPC
    
    This patch fixes bits of the DRM so to make the radeon DRI work on
    non-cache coherent PCI DMA variants of the PowerPC processors.
    
    It moves the few places that needs change to wrappers to that
    other architectures with similar issues can easily add their
    own changes to those wrappers, at least until we have more useful
    generic kernel API.
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: "Luck, Tony" <tony.luck@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2b46278b6af0a4df43016f01a0741d8e0a76bfd4
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Fri Mar 28 14:23:06 2008 -0700

    drm: radeon: fix sparse integer as NULL pointer warnings in radeon_mem.c
    
    drivers/char/drm/radeon_mem.c:91:23: warning: Using plain integer as NULL pointer
    drivers/char/drm/radeon_mem.c:116:28: warning: Using plain integer as NULL pointer
    drivers/char/drm/radeon_mem.c:124:28: warning: Using plain integer as NULL pointer
    drivers/char/drm/radeon_mem.c:177:26: warning: Using plain integer as NULL pointer
    drivers/char/drm/radeon_mem.c:177:53: warning: Using plain integer as NULL pointer
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 144a75fa1faa4a81530bded2e59872ef80d496b6
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Mar 30 07:53:58 2008 +1000

    drm/i915: fix oops on agp=off
    
    From Kernel BZ 10289 - not sure why anyone would boot an intel with no agp
    but it shouldn't crash.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0c76be35194563f56e02fc1775d0fe29281e84d4
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Mar 30 07:51:49 2008 +1000

    drm/r300: fix bug in r300 userspace hardware wait emission
    
    This interface was originally designed wrong, confusing bit-fields and
    integers, major brown paper bag going back many years...
    
    But userspace only ever used 4 values so fix the interface for new
    users and fix the implementation to deal with the 4 values userspace
    has ever emitted (0x1, 0x2, 0x3, 0x6).
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
