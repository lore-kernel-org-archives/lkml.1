Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZBWAPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZBWAPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZBWAPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:15:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58357 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbZBWAPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:15:21 -0500
Date: Mon, 23 Feb 2009 00:15:19 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0902230014080.30665@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Another bunch of KMS/GEM related fixes for the Intel driver, should fix 
the oops you saw. Also enable suspend/resume on KMS which is a regression
for anyone who wanted to use it.

Dave.

 drivers/gpu/drm/i915/i915_dma.c      |    2 +-
 drivers/gpu/drm/i915/i915_drv.c      |   23 +++++++++++-
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/i915_gem.c      |   67 +++++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_display.c |    1 +
 5 files changed, 67 insertions(+), 27 deletions(-)

commit 5004417d840e6dcb0052061fd04569b9c9f037a8
Author: Pierre Willenbrock <pierre@pirsoft.de>
Date:   Mon Feb 23 10:12:15 2009 +1000

    drm/i915: Add missing mutex_lock(&dev->struct_mutex)
    
    there might be a nicer way to fix this but this is the simplest for now.
    
    Signed-off-by: Pierre Willenbrock <pierre@pirsoft.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6fb88588555a18792a27f483887fe1f2af5f9c9b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 23 10:08:21 2009 +1000

    drm/i915: fix WC mapping in non-GEM i915 code.
    
    [airlied - taken from mailing list posting]
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bab2d1f6531657e37dc84f26184f3f64e1e73ecd
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Feb 20 17:52:20 2009 +0000

    drm/i915: Fix regression in 95ca9d
    
    The object is dereferenced before the NULL check. Oops.
    
    Fixes http://bugs.freedesktop.org/show_bug.cgi?id=20235
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f21289b355cee8738d80c2ae5cbd272c3f7b5689
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Feb 18 09:44:56 2009 -0800

    drm/i915: Retire requests from i915_gem_busy_ioctl.
    
    This ensures that the user gets the latest information from the hardware
    on whether the buffer is busy, potentially reducing the working set of objects
    that the user chooses.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5669fcacc58bf3a7386057addffd280d75380858
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Feb 17 15:13:31 2009 -0800

    drm/i915: suspend/resume GEM when KMS is active
    
    In the KMS case, we need to suspend/resume GEM as well.  So on suspend, make
    sure we idle GEM and stop any new rendering from coming in, and on resume,
    re-init the framebuffer and clear the suspended flag.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit efbeed96f7e20783b22d9529ef536b61f7ea8637
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Feb 19 14:54:51 2009 -0800

    drm/i915: Don't let a device flush to prepare buffers clear new write_domains.
    
    The problem was that object_set_to_gpu_domain would set the new write_domains
    that are getting set by this batchbuffer, then the accumulated flushes required
    for all the objects in preparation for this batchbuffer were posted, and the
    brand new write domain would get cleared by the flush being posted.  Instead,
    hang on to the new (or old if we're not changing it) value and set it after
    the flush is queued.
    
    Results from this noticably included conformance test failures from reads
    shortly after writes (where the new write domain had been lost and thus not
    flushed and waited on), but is a suspected cause of hangs in some apps when
    a write domain is lost on a buffer that gets reused for instruction or
    commmand state.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8b0e378a20e48c691d374f39d8b0596e63598cfc
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Feb 19 14:40:50 2009 -0800

    drm/i915: Cut two args to set_to_gpu_domain that confused this tricky path.
    
    While not strictly required, it helped while thinking about the following
    change.  This change should be invariant.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
