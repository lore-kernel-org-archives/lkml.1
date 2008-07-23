Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYGWH2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYGWH2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYGWH1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:27:51 -0400
Received: from ozlabs.org ([203.10.76.45]:34953 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYGWH1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:27:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest and virtio patches
Date: Wed, 23 Jul 2008 17:27:34 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Mark McLoughlin <markmc@redhat.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807231727.35138.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note the arch/s390 bit is from virtio console on KVM/s390)

The following changes since commit 0988c37c248e824953d95a11412696c348dbca91:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Andrew Morton (1):
      lguest: use cpu capability accessors

Christian Borntraeger (5):
      virtio_blk: check for hardsector size from host
      hvc_console: rework setup to replace irq functions with callbacks
      virtio_console: use virtqueue notification for hvc_console
      virtio: console as a config option
      s390: use virtio_console for KVM on s390

Herbert Xu (2):
      virtio net: Add ethtool ops for SG/GSO
      virtio net: Allow receiving SG packets

Johannes Weiner (1):
      lguest: fix switcher_page leak on unload

Mark McLoughlin (4):
      virtio: fix virtio_net xmit of freed skb bug
      lguest: Don't leak /dev/zero fd
      lguest: Support assigning a MAC address
      virtio: Use bus_type probe and remove methods

Rusty Russell (19):
      virtio: Recycle unused recv buffer pages for large skbs in net driver
      lguest: set max_pfn_mapped, growl loudly at Yinghai Lu
      lguest: Guest int3 fix
      lguest: Debugging patch for lguest network performance
      lguest: fix verbose printing of device features.
      lguest: virtio-rng support
      virtio: clarify that ABI is usable by any implementations
      virtio: don't always force a notification when ring is full
      lguest: wrap last_avail accesses.
      lguest: net block unneeded receive queue update notifications
      lguest: Tell Guest net not to notify us on every packet xmit
      lguest: Adaptive timeout
      virtio: Formally reserve bits 28-31 to be 'transport' features.
      virtio: Rename set_features to finalize_features
      virtio: Add transport feature handling stub for virtio_ring.
      lguest: Remove 'network: no dma buffer!' warning
      lguest: Use GSO/IFF_VNET_HDR extensions on tun/tap
      lguest: Enlarge virtio rings
      lguest: turn Waker into a thread, not a process

 Documentation/lguest/lguest.c         |  531 ++++++++++++++++++++++++--------
 arch/s390/Kconfig                     |    1 +
 arch/s390/kernel/setup.c              |    4 +-
 arch/x86/lguest/boot.c                |    3 +
 drivers/block/virtio_blk.c            |   10 +-
 drivers/char/Kconfig                  |   11 +-
 drivers/char/Makefile                 |    1 +
 drivers/char/hvc_console.c            |   85 ++----
 drivers/char/hvc_console.h            |   35 ++-
 drivers/char/hvc_irq.c                |   44 +++
 drivers/char/hvc_iseries.c            |    2 +
 drivers/char/hvc_vio.c                |    2 +
 drivers/char/hvc_xen.c                |    2 +
 drivers/char/virtio_console.c         |   40 ++-
 drivers/lguest/core.c                 |    1 +
 drivers/lguest/interrupts_and_traps.c |   24 +-
 drivers/lguest/lguest_device.c        |   14 +-
 drivers/lguest/x86/core.c             |    4 +-
 drivers/net/virtio_net.c              |  114 ++++++-
 drivers/s390/kvm/kvm_virtio.c         |   34 ++-
 drivers/virtio/virtio.c               |   26 +-
 drivers/virtio/virtio_pci.c           |   13 +-
 drivers/virtio/virtio_ring.c          |   22 ++-
 include/asm-s390/kvm_virtio.h         |   10 +
 include/linux/virtio_9p.h             |    2 +
 include/linux/virtio_balloon.h        |    2 +
 include/linux/virtio_blk.h            |    5 +
 include/linux/virtio_config.h         |   16 +-
 include/linux/virtio_console.h        |    2 +
 include/linux/virtio_net.h            |    2 +
 include/linux/virtio_pci.h            |    5 +-
 include/linux/virtio_ring.h           |    2 +
 include/linux/virtio_rng.h            |    2 +
 33 files changed, 805 insertions(+), 266 deletions(-)
 create mode 100644 drivers/char/hvc_irq.c
