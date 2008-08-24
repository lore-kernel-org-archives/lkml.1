Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYHXHSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYHXHSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 03:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYHXHSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 03:18:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53344 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYHXHSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 03:18:41 -0400
Date: Sun, 24 Aug 2008 08:18:38 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm patches for 2.6.27 final
Message-ID: <alpine.DEB.0.82.0808240809170.15834@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

I'm sorry this ended up so big at this point in the cycle, and I did read 
the LWN quote of the week last week, the re-org of the tree set me back a 
bit with lining up the patches. We are hopefully trying a more upstream 
oriented DRM development process quite soon, which may make things like 
this happen less often as the drm developers educate themselves on patch 
cycles.

So this has fixes for the SiS build with fbdev, a fix for a warning 
reported by Jiri Slaby in the irq locking code, a fix for debugging the X 
server startup sequence, r300/r500 radeon lockup fixes, Intel hw 
instability fixes in the irq and hw status pages, and the biggest 
bit is a fix for the backlight keys on a bunch of Intel laptops which is 
enabled using opregion support from Matthew Garrett.

Dave.

 drivers/gpu/drm/Kconfig              |    1 +
 drivers/gpu/drm/drm_irq.c            |   40 +-
 drivers/gpu/drm/drm_lock.c           |   33 +-
 drivers/gpu/drm/i915/Makefile        |    2 +-
 drivers/gpu/drm/i915/i915_dma.c      |  171 +++--
 drivers/gpu/drm/i915/i915_drv.c      |   58 +-
 drivers/gpu/drm/i915/i915_drv.h      |  860 ++--------------------
 drivers/gpu/drm/i915/i915_irq.c      |  189 ++++--
 drivers/gpu/drm/i915/i915_opregion.c |  371 +++++++++
 drivers/gpu/drm/i915/i915_reg.h      | 1406 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/r300_cmdbuf.c |  196 ++++-
 drivers/gpu/drm/radeon/r300_reg.h    |    5 +-
 drivers/gpu/drm/radeon/radeon_cp.c   |   38 +-
 drivers/gpu/drm/radeon/radeon_drv.h  |   19 +-
 drivers/gpu/drm/sis/sis_mm.c         |   10 +-
 include/drm/drm.h                    |   17 -
 16 files changed, 2333 insertions(+), 1083 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_opregion.c
 create mode 100644 drivers/gpu/drm/i915/i915_reg.h

commit 066d38b34b451605a35ed498cef89756f59dfdcc
Author: Adrian Bunk <bunk@kernel.org>
Date:   Sun Aug 24 17:11:22 2008 +1000

    FB_SIS=m, DRM_SIS=y is not a legal configuration.
    
    Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8ba0be53102f8d8509ee2958d15142bdd2fd433f
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Aug 24 17:02:26 2008 +1000

    drm: don't set the signal blocker on the master process.
    
    There is a problem with debugging the X server and gdb crashes in
    the xkb startup code.
    
    This avoids the problem by allowing the master process to get signals.
    It should be safe as the signal blocker is mainly so that you can
    Ctrl-Z a 3D application without locking up the whole box. Ctrl-Z the
    X server isn't something many people do.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8f812b6bea43866cd41a236596d64e41e93009fd
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Sun Aug 24 17:00:00 2008 +1000

    drm: don't call the vblank tasklet with irqs disabled.
    
    If a specific tasklet shares data with irq context,
    it needs to take a private irq-blocking spinlock within
    the tasklet itself.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 47465ec5599740b8b8fceb76305abaf1bf3e92b7
Author: Nicolai Haehnle <nhaehnle@gmail.com>
Date:   Wed Aug 13 09:50:12 2008 +1000

    r300: Fix cliprect emit
    
    This makes our handling of cliprects sane. drm_clip_rect always has exclusiv
    bottom-right corners, but the hardware expects inclusive bottom-right corner
    so we adjust this here.
    
    This complements Michel Daenzer's commit 57aea290e1e0a26d1e74df6cff777eb9f03
    to Mesa. See also http://bugs.freedesktop.org/show_bug.cgi?id=16123
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 185b013ed895b925b97db4cc71b53128379d838a
Author: Nicolai Haehnle <nhaehnle@gmail.com>
Date:   Wed Aug 13 09:49:15 2008 +1000

    drm/radeon: r300_cmdbuf: Always emit INDX_BUFFER immediately after DRAW_INDEX
    
    DRAW_INDEX writes a vertex count to VAP_VF_CNTL. Docs say that behaviour
    is undefined (i.e. lockups happen) when this write is not followed by the
    right number of vertex indices.
    
    Thus we used to do the wrong thing when drawing across many cliprects was
    necessary, because we emitted a sequence
    DRAW_INDEX, DRAW_INDEX, INDX_BUFFER, INDX_BUFFER
    instead of
    DRAW_INDEX, INDX_BUFFER, DRAW_INDEX, INDX_BUFFER
    The latter is what we're doing now and which ought to be correct.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a2f902c1d70ec106d2dc339e9f1df77c9d4ad81a
Author: Jerome Glisse <glisse@freedesktop.org>
Date:   Wed Aug 13 09:46:31 2008 +1000

    radeon: fix some hard lockups on r3/4/500s
    
    This patch should fix hard lockup and convert them in
    softlockup (ie you can ssh the box but the gpu is busted
    and we are waiting in loop for it to come back to reason).
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 997f17afbd6e081a82ea14a6ed4e3cf663a507c4
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Aug 5 19:37:25 2008 +0100

    Add Intel ACPI IGD OpRegion support
    
    This adds the support necessary for allowing ACPI backlight control to
    work on some newer Intel-based graphics systems. Tested on Thinkpad T61
    and HP 2510p hardware.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit cadb300542a0673c0526b0e1e008553fd9e6a1e6
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 13:03:43 2008 -0700

    i915: Initialize hardware status page at device load when possible.
    
    Some chips were unstable with repeated setup/teardown of the hardware status
    page.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 24f17e00e605629599424309743caf56bb0eecd7
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 12:21:20 2008 -0700

    i915: Track progress inside of batchbuffers for determining wedgedness.
    
    This avoids early termination for long-running commands.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit effcf8a598eb917fb45b640bfaffe133c6a071f5
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Jul 29 12:10:39 2008 -0700

    i915: Add support for MSI and interrupt mitigation.
    
    Previous attempts at interrupt mitigation had been foiled by i915_wait_irq's
    failure to update the sarea seqno value when the status page indicated that
    the seqno had already been passed.  MSI support has been seen to cut CPU
    costs by up to 40% in some workloads by avoiding other expensive interrupt
    handlers for frequent graphics interrupts.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c140b9e73669178e8560852642bba634ac0ae6e0
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Jul 29 11:54:06 2008 -0700

    i915: Use more consistent names for regs, and store them in a separate file.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6efc5380867417507e1b82c8e625b9da4a710073
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 12:36:08 2008 -0700

    i915: Ignore X server provided mmio address
    
    It is already correctly detected by the kernel for use in suspend/resume.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d88c85320dd0658683383f7c62cf25c196d5fa90
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 12:28:47 2008 -0700

    i915: remove settable use_mi_batchbuffer_start
    
    The driver can know what hardware requires MI_BATCH_BUFFER vs
    MI_BATCH_BUFFER_START; there's no reason to let user mode configure this.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 95e00aa789ab3afc6e3a987296d784bc2d49c6cd
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 30 12:29:38 2008 -0700

    SiS DRM: fix a pointer cast warning
    
    Fix a pointer cast warning in the SIS DRM code.
    
    This was introduced in patch ce65a44de07f73ceda1749812b75086b7add408d.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d324fcdb8de22d19d911793999bd7fb6819e50b0
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 30 12:29:37 2008 -0700

    SiS DRM: fix the memory allocator if the SIS FB is built as a module
    
    Fix the SIS DRM memory allocator if the SIS FB built as a module.  The SIS DRM
    code initialises the mm allocation hooks, but _only_ if the SIS FB is not
    built as a module because it depends on CONFIG_FB_SIS, and that's unset if the
    SIS FB is not built in.  It must check CONFIG_FB_SIS_MODULE as well.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 74d2f507880a3e63d60fbcb898fb1678d936b46d
Author: Carlos R. Mafra <crmafra2@gmail.com>
Date:   Wed Jul 30 12:29:37 2008 -0700

    drm: remove #define's for non-linux systems
    
    There is no point in considering FreeBSD et al.  in the linux kernel
    source code.
    
    Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
