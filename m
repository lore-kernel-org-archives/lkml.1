Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZKXDKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZKXDKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 22:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZKXDKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 22:10:43 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49425 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZKXDKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 22:10:42 -0500
Date: Tue, 24 Nov 2009 03:10:44 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.0911240307550.25151@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

I've pulled the most required patches from the optional pull that you 
didn't take from last week. Granted this means the F12 kernel has now got 
a bunch of patches that should be in 2.6.32 but will have to wait for 
2.6.33, distros thinking of packaging radeon kms do take note.

Dave.

 drivers/gpu/drm/drm_edid.c                 |    6 ++++++
 drivers/gpu/drm/drm_fb_helper.c            |    6 +++---
 drivers/gpu/drm/drm_gem.c                  |    2 +-
 drivers/gpu/drm/drm_mm.c                   |    9 +++++++++
 drivers/gpu/drm/radeon/atom.c              |    1 +
 drivers/gpu/drm/radeon/radeon.h            |    1 +
 drivers/gpu/drm/radeon/radeon_agp.c        |   12 ++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c |   16 ++++++++++++----
 drivers/gpu/drm/radeon/radeon_device.c     |    2 ++
 drivers/gpu/drm/radeon/rv515.c             |    9 ++++-----
 10 files changed, 51 insertions(+), 13 deletions(-)

commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Wed Nov 4 09:42:52 2009 +0100

    drm/fb: fix FBIOGET/PUT_VSCREENINFO pixel clock handling
    
    When the framebuffer driver does not publish detailed timing information
    for the current video mode, the correct value for the pixclock field is
    zero, not -1.
    
    Since pixclock is actually unsigned, the value -1 would be interpreted
    as 4294967295 picoseconds (i.e., about 4 milliseconds) by
    register_framebuffer() and userspace programs.
    
    This patch allows X.org's fbdev driver to work.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Tested-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 79cc304f3e2fda202242036326afb2aeca486156
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Tue Nov 17 14:08:54 2009 -0800

    drm: make sure page protections are updated after changing vm_flags
    
    Some architectures compute ->vm_page_prot depending on ->vm_flags, so we
    need to update the protections after adjusting the flags.
    
    AFAIK this only affects running X under Xen; without this patch you get
    lots of coloured blobs on the screen, or maybe a complete lockup.  Or
    anything really.
    
    But that still depends on lots of out-of-tree stuff, so I don't think
    there are any consequences for anyone else.  But it is wrong in principle.
    
    Reported-by: Jan Beulich <JBeulich@novell.com>
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f82f5f3ac4de6c6b872fcbb3dec97f368e78ff58
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Nov 12 14:13:53 2009 +0100

    drm/radeon/kms: Report vga connector is connected according to ddc_probe
    
    On broken EDID we were reporting vga connector to be disconnected
    even if ddc probe did found a monitor. This patch report that the
    connector is connected on such case. This allow drm to add a fail
    safe mode (800x600 at the time of this patch) thus user can boot
    and later add a mode which match its monitor capabilities.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a698cf34ea867efef12fc29dd63d443f0c71a53c
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Nov 13 20:56:58 2009 +0100

    drm: mm always protect change to unused_nodes with unused_lock spinlock
    
    unused_nodes modification needs to be protected by unused_lock spinlock.
    Here is an example of an usage where there is no such protection without
    this patch.
    
      Process 1: 1-drm_mm_pre_get(this function modify unused_nodes list)
                 2-spin_lock(spinlock protecting mm struct)
                 3-drm_mm_put_block(this function might modify unused_nodes
                   list but doesn't protect modification with unused_lock)
                 4-spin_unlock(spinlock protecting mm struct)
      Process2:  1-drm_mm_pre_get(this function modify unused_nodes list)
    At this point Process1 & Process2 might both be doing modification to
    unused_nodes list. This patch add unused_lock protection into
    drm_mm_put_block to avoid such issue.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0beb81ab45c67de4b3aa85faad604cff8ed133a8
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Nov 13 20:56:35 2009 +0100

    drm/radeon/kms: Disable TV load detect on RS400,RC410,RS480
    
    RS400,RC410,RS480 chipset seems to report a lot of false positive
    with load detect on TV output. We haven't yet found a way to make
    load detect reliable on those chipset, thus just disable it for TV
    output. Would avoid user to experience phantom screen because X
    believe there is a monitor connected to the TV output.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 23115b0592bde5da249fcbdad7714c1f96a8e5f5
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Nov 12 15:53:44 2009 +1000

    drm/radeon/kms: read back register before writing in IIO.
    
    This fixes RH bugzilla #527874.
    
    On resume the atom posting wasn't working, however vbe posting was
    going fine, after 2 weeks over irc, and 8 hrs with the hardware,
    I tracked it down to the memory device table and it access the MC
    registers via IIO, it appears the rv515 atom iio table might not
    be fully functional, so adding a readback before doing a write
    either provides enough delay to make things resume correctly.
    
    Thanks to Peng Huang at Red Hat for coming to Brisbane.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ef63062716415d6e271815872b6c6654ffa9ac26
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Nov 12 09:37:39 2009 +1000

    drm/radeon/kms: fix handling of d1/d2 vga
    
    An rv515 laptop I got wouldn't startup with a montior plugged in,
    found the proper bug hopefully with us not turning off D2VGA
    here when we should.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7064fef56369c9e2c6e35ff6d6b4b63d42a859ce
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Nov 5 10:12:54 2009 -0800

    drm: work around EDIDs with bad htotal/vtotal values
    
    We did this on the userspace side, but we need a similar fix for the
    kernel.
    
    Fixes LP #460664.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0ebf17174b4bdd99ab81c476714c91ee335fdcbf
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 5 15:39:10 2009 +1000

    drm/radeon/kms: resume AGP by calling init.
    
    AGP resume was broken since we moved to the new init path,
    because we never re-enabled AGP on these systems at resume time.
    
    This patch just calls the AGP resume call which just does the reinit
    at resume time like the old path did.
    
    Since AGP is pretty much gpu independant I did it outside
    the gpu specific code.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
