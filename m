Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZJSCbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZJSCbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 22:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZJSCbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 22:31:32 -0400
Received: from ozlabs.org ([203.10.76.45]:54338 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbZJSCbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 22:31:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio fixes
Date: Mon, 19 Oct 2009 13:01:23 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910191301.24726.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for delay, recent absences, but all been in linux-next a week now)

The following changes since commit 2fdc246aaf9a7fa088451ad2a72e9119b5f7f029:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Christian Borntraeger (1):
      virtio: let header files include virtio_ids.h

Christoph Hellwig (1):
      virtio_blk: revert QUEUE_FLAG_VIRT addition

Rusty Russell (1):
      virtio_blk: Revert serial number support

Uwe Kleine-König (2):
      move virtballoon_remove to .devexit.text
      move virtrng_remove to .devexit.text

 Documentation/lguest/lguest.c       |    1 -
 drivers/block/virtio_blk.c          |   39 ++--------------------------------
 drivers/char/hw_random/virtio-rng.c |    3 +-
 drivers/char/virtio_console.c       |    1 -
 drivers/net/virtio_net.c            |    1 -
 drivers/virtio/virtio_balloon.c     |    3 +-
 include/linux/Kbuild                |    1 +
 include/linux/virtio_9p.h           |    1 +
 include/linux/virtio_balloon.h      |    1 +
 include/linux/virtio_blk.h          |    5 +---
 include/linux/virtio_console.h      |    1 +
 include/linux/virtio_net.h          |    1 +
 include/linux/virtio_rng.h          |    1 +
 net/9p/trans_virtio.c               |    1 -
 14 files changed, 12 insertions(+), 48 deletions(-)


commit d5a01175aa25ef30a99545f09e0a2828a226d3cd
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Sep 4 22:44:42 2009 +0200

    virtio_blk: revert QUEUE_FLAG_VIRT addition
    
    It seems like the addition of QUEUE_FLAG_VIRT caueses major performance
    regressions for Fedora users:
    
    	https://bugzilla.redhat.com/show_bug.cgi?id=509383
    	https://bugzilla.redhat.com/show_bug.cgi?id=505695
    
    while I can't reproduce those extreme regressions myself I think the flag
    is wrong.
    
    Rationale:
    
      QUEUE_FLAG_VIRT expands to QUEUE_FLAG_NONROT which casus the queue
      unplugged immediately.  This is not a good behaviour for at least
      qemu and kvm where we do have significant overhead for every
      I/O operations.  Even with all the latested speeups (native AIO,
      MSI support, zero copy) we can only get native speed for up to 128kb
      I/O requests we already are down to 66% of native performance for 4kb
      requests even on my laptop running the Intel X25-M SSD for which the
      QUEUE_FLAG_NONROT was designed.
      If we ever get virtio-blk overhead low enough that this flag makes
      sense it should only be set based on a feature flag set by the host.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/block/virtio_blk.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

commit 6ff87d1f188f65a51c28595e9ad16183cbd58d94
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Wed Sep 30 11:17:21 2009 +0200

    virtio: let header files include virtio_ids.h
    
    Rusty,
    
    commit 3ca4f5ca73057a617f9444a91022d7127041970a
        virtio: add virtio IDs file
    moved all device IDs into a single file. While the change itself is
    a very good one, it can break userspace applications. For example
    if a userspace tool wanted to get the ID of virtio_net it used to
    include virtio_net.h. This does no longer work, since virtio_net.h
    does not include virtio_ids.h.
    This patch moves all "#include <linux/virtio_ids.h>" from the C
    files into the header files, making the header files compatible with
    the old ones.
    
    In addition, this patch exports virtio_ids.h to userspace.
    
    CC: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 Documentation/lguest/lguest.c       |    1 -
 drivers/block/virtio_blk.c          |    1 -
 drivers/char/hw_random/virtio-rng.c |    1 -
 drivers/char/virtio_console.c       |    1 -
 drivers/net/virtio_net.c            |    1 -
 drivers/virtio/virtio_balloon.c     |    1 -
 include/linux/Kbuild                |    1 +
 include/linux/virtio_9p.h           |    1 +
 include/linux/virtio_balloon.h      |    1 +
 include/linux/virtio_blk.h          |    1 +
 include/linux/virtio_console.h      |    1 +
 include/linux/virtio_net.h          |    1 +
 include/linux/virtio_rng.h          |    1 +
 net/9p/trans_virtio.c               |    1 -
 14 files changed, 7 insertions(+), 7 deletions(-)

commit ef728ac6296b8ae36791c7644e92b7bc75c0fd88
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Oct 19 12:58:28 2009 -0600

    virtio_blk: Revert serial number support
    
    This reverts "Add serial number support for virtio_blk, V4a".
    
    Turns out that virtio_pci, lguest and s/390 all have an 8 bit limit
    on virtio config space, so noone could ever use this.
    
    This is coming back later in a cleaner form.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: john cooper <john.cooper@redhat.com>
    Cc: Jens Axboe <jens.axboe@oracle.com>

 drivers/block/virtio_blk.c |   37 +++----------------------------------
 include/linux/virtio_blk.h |    4 ----
 2 files changed, 3 insertions(+), 38 deletions(-)

commit 22b4b8fe00398cb66cb9a95d3f0c21b0155e5421
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Thu Oct 1 10:28:33 2009 +0200

    move virtballoon_remove to .devexit.text
    
    The function virtballoon_remove is used only wrapped by __devexit_p so
    define it using __devexit.
    
    Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Acked-by: Sam Ravnborg <sam@ravnborg.org>
    Acked-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/virtio/virtio_balloon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 360390725dce2961ac35be5f59640f9d44f03d25
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Thu Oct 1 10:28:35 2009 +0200

    move virtrng_remove to .devexit.text
    
    The function virtrng_remove is used only wrapped by __devexit_p so define
    it using __devexit.
    
    Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Acked-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Michael S. Tsirkin <mst@redhat.com>
    Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Cc: linux-kernel@vger.kernel.org
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/char/hw_random/virtio-rng.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
