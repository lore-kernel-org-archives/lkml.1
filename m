Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZCBX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZCBX5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZCBX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:57:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48030 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbZCBX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:57:22 -0500
Date: Mon, 2 Mar 2009 23:57:20 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.0903022356050.28485@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This contains an intel oops fix, and some fixups to the lock code since
it got split into the per-master code.

Dave.

 drivers/gpu/drm/drm_bufs.c      |    2 +-
 drivers/gpu/drm/drm_fops.c      |   14 ++++++++++++++
 drivers/gpu/drm/drm_lock.c      |    3 ++-
 drivers/gpu/drm/drm_stub.c      |    8 --------
 drivers/gpu/drm/i915/i915_irq.c |    5 +++--
 5 files changed, 20 insertions(+), 12 deletions(-)

commit 299eb93c5f651b2bc368ada67d8471e4c575fa21
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Feb 24 22:14:12 2009 -0800

    drm/i915: Fix use-before-null-check in i915_irq_emit().
    
    This could be triggered by a client asking to emit an irq when the device
    wasn't initialized.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit fda714c29cdf360464059044b221450decb4b913
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Mar 2 11:10:56 2009 +0100

    drm: Avoid client deadlocks when the master disappears.
    
    This is done by
    1) Wake up lock waiters when we close the master file descriptor.
       Not when the master structure is removed, since the latter
       requires the waiters themselves to release the refcount on the
       master structure -> Deadlock.
    2) Send a SIGTERM to all clients waiting for the lock.
       Normally these clients will get a SIGPIPE when the X server dies,
       but clients may also spin trying to grab the DRM lock, without
       getting any sort of notification.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 171901d15deeef61aa8e1b0d0772404f39691b73
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Mar 2 11:10:55 2009 +0100

    drm: Wake up all lock waiters when the master disappears.
    
    Currently only one waiter is woken up, leaving other waiters
    hanging waiting for the DRM lock.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4d77c88e912e5eb9480432af09e950ca8995c253
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Mar 2 11:10:54 2009 +0100

    drm: Don't return ERESTARTSYS to user-space.
    
    That return code is for in-kernel use only.
    Use EINTR instead.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

