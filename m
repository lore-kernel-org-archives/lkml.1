Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYHXVA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYHXVA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYHXVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:00:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40487 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbYHXVAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:00:19 -0400
Date: Sun, 24 Aug 2008 22:00:17 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm tree this time only the major issues.
Message-ID: <alpine.DEB.0.82.0808242158150.15834@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

This fixes a number of chip lockups under 3D load in the radeon driver, 
a locking bug reported on lkml (hits a WARN_ON), and a problem where the 
X server can't be debugged through startup.

Dave.

 drivers/gpu/drm/drm_irq.c            |   20 ++--
 drivers/gpu/drm/drm_lock.c           |   33 +++---
 drivers/gpu/drm/radeon/r300_cmdbuf.c |  196 ++++++++++++++++++++++++++++------
 drivers/gpu/drm/radeon/r300_reg.h    |    5 +-
 drivers/gpu/drm/radeon/radeon_cp.c   |   38 +++----
 drivers/gpu/drm/radeon/radeon_drv.h  |   19 ++--
 6 files changed, 225 insertions(+), 86 deletions(-)

commit 3e5fc80a404a24c858468030b63555cccfb3e79c
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

commit e5b4f19417b75a2d7c1e36934f60a3e836c4337e
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Sun Aug 24 17:00:00 2008 +1000

    drm: don't call the vblank tasklet with irqs disabled.
    
    If a specific tasklet shares data with irq context,
    it needs to take a private irq-blocking spinlock within
    the tasklet itself.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 649ffc06a62bf487b78440669bdfeb637f1d675b
Author: Nicolai Haehnle <nhaehnle@gmail.com>
Date:   Wed Aug 13 09:50:12 2008 +1000

    r300: Fix cliprect emit
    
    This makes our handling of cliprects sane. drm_clip_rect always has exclusiv
    bottom-right corners, but the hardware expects inclusive bottom-right corner
    so we adjust this here.
    
    This complements Michel Daenzer's commit 57aea290e1e0a26d1e74df6cff777eb9f03
    to Mesa. See also http://bugs.freedesktop.org/show_bug.cgi?id=16123
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e2898c5fdd91f54c9c84fbf7d32edb8e4dfda574
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

commit 54f961a628b737f66710eca0b0d95346645dd33e
Author: Jerome Glisse <glisse@freedesktop.org>
Date:   Wed Aug 13 09:46:31 2008 +1000

    radeon: fix some hard lockups on r3/4/500s
    
    This patch should fix hard lockup and convert them in
    softlockup (ie you can ssh the box but the gpu is busted
    and we are waiting in loop for it to come back to reason).
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
