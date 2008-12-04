Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYLDBje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYLDBje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYLDBj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:39:26 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55130 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYLDBjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:39:25 -0500
Date: Thu, 4 Dec 2008 01:39:22 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [optional git pull request] Intel GEM updates for 2.6.28 final
Message-ID: <alpine.DEB.2.00.0812040134150.27607@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Since we just introduced GEM in this kernel, and this patch series only 
touches GEM and fixes some problems discovered in it since it went 
upstream, Intel would like for these fixes to go in ASAP. They fix a host 
of general bugs founds by running OpenGL conformance tests and using GEM 
from the userspace 2D driver. If you don't want them now, they can wait 
until stable.

Please pull the 'drm-gem-update' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-gem-update

Dave.

 drivers/gpu/drm/i915/i915_drv.h        |   15 +-
 drivers/gpu/drm/i915/i915_gem.c        |  637 ++++++++++++++++++++------------
 drivers/gpu/drm/i915/i915_gem_proc.c   |    5 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c |    7 +-
 drivers/gpu/drm/i915/i915_reg.h        |    1 +
 5 files changed, 420 insertions(+), 245 deletions(-)

commit 0235439232cb6f8a54f8976aa8330c1c98ebad0b
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Nov 26 13:58:13 2008 -0800

    drm/i915: Return error in i915_gem_set_to_gtt_domain if we're not in the GTT.
    
    It's only for flushing caches appropriately for GTT access, not for actually
    getting it there.  Prevents potential smashing of cpu read/write domains on
    unbound objects.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ac94a962b24a88ea5d00f4697550d9982f300751
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Nov 20 23:30:27 2008 -0800

    drm/i915: Retry execbuffer pinning after clearing the GTT
    
    If we fail to pin all of the buffers in an execbuffer request, go through
    and clear the GTT and try again to see if its just a matter of fragmentation
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 646f0f6e43bf6628b1f0f8ca6c0227ce72e8ef3c
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Nov 20 23:23:03 2008 -0800

    drm/i915: Move the execbuffer domain computations together
    
    This eliminates the dev_set_domain function and just in-lines it
    where its used, with the goal of moving the manipulation and use of
    invalidate_domains and flush_domains closer together. This also
    avoids calling add_request unless some domain has been flushed.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c0d90829288942fa06d7483f9e84059a64605da5
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Nov 20 23:11:08 2008 -0800

    drm/i915: Rename object_set_domain to object_set_to_gpu_domain
    
    Now that the CPU and GTT domain operations are isolated to their own
    functions, the previously general-purpose set_domain function is now used
    only to set GPU domains. It also has no failure cases, which is important as
    this eliminates any possible interruption of the computation of new object
    domains and subsequent emmission of the flushing instructions into the ring.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e47c68e9c5d71e2faab8c2b82f57c6c73e6456fd
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Nov 14 13:35:19 2008 -0800

    drm/i915: Make a single set-to-cpu-domain path and use it wherever needed.
    
    This fixes several domain management bugs, including potential lack of cache
    invalidation for pread, potential failure to wait for set_domain(CPU, 0),
    and more, along with producing more intelligible code.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2ef7eeaa553d88e78d9a4520271f26a7bc0e2968
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Nov 10 10:53:25 2008 -0800

    drm/i915: Make a single set-to-gtt-domain path.
    
    This fixes failure to flush caches in the relocation update path, and
    failure to wait in the set_domain ioctl, each of which could lead to incorrect
    rendering.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b670d8158283c35842ae1c650f75c375d8710607
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Nov 14 16:27:47 2008 -0800

    drm/i915: If interrupted while setting object domains, still emit the flush.
    
    Otherwise, we would leave the objects in an inconsistent state, such as
    write_domain == 0 but on the flushing list.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ce44b0ea3dc04236d852d78a06f850d1f7b03f3d
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Nov 6 16:00:31 2008 -0800

    drm/i915: Move flushing list cleanup from flush request retire to request emit.
    
    obj_priv->write_domain is "write domain if the GPU went idle now", not
    "write domain at this moment."  By postponing the clear, we confused the
    concept, required more storage, and potentially emitted more flushes than
    are required.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a7f014f2de04893f95cfe40fe35f15c8dae4b36e
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Nov 25 14:02:05 2008 -0800

    drm/i915: Respect GM965/GM45 bit-17-instead-of-bit-11 option for swizzling.
    
    This fixes readpixels and buffer corruption when swapped out and in by
    disabling tiling on them.
    
    Now that we know that the bit 17 mode isn't just a mistake of older chipsets,
    we'll need to work on a clever fix so that we can get the performance of
    tiling on these chipsets, but that will require intrusive changes targeted
    at the next kernel release, not this one.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
