Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZLIJyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZLIJyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZLIJyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:54:11 -0500
Received: from ozlabs.org ([203.10.76.45]:58306 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZLIJyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:54:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio & lguest
Date: Wed, 9 Dec 2009 20:24:06 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       Adam Litke <agl@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912092024.06777.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3ff6a468b45b5dfeb0e903e56f4eb27d34b2437c:
  Linus Torvalds (1):
        Merge branch 'x86-xen-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Adam Litke (1):
      virtio: Add memory statistics reporting to the balloon driver (V4)

Michael S. Tsirkin (3):
      tun: export underlying socket
      mm: export use_mm/unuse_mm to modules
      vhost_net: a kernel-level virtio server

Rusty Russell (1):
      lguest: remove unneeded zlib.h include in example launcher

 Documentation/lguest/lguest.c   |    1 -
 MAINTAINERS                     |    9 +
 arch/x86/kvm/Kconfig            |    1 +
 drivers/Makefile                |    1 +
 drivers/net/tun.c               |  101 ++++-
 drivers/vhost/Kconfig           |   11 +
 drivers/vhost/Makefile          |    2 +
 drivers/vhost/net.c             |  648 ++++++++++++++++++++++++++
 drivers/vhost/vhost.c           |  968 +++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h           |  159 +++++++
 drivers/virtio/virtio_balloon.c |   94 ++++-
 include/linux/Kbuild            |    1 +
 include/linux/if_tun.h          |   14 +
 include/linux/miscdevice.h      |    1 +
 include/linux/vhost.h           |  130 ++++++
 include/linux/virtio_balloon.h  |   15 +
 mm/mmu_context.c                |    3 +
 17 files changed, 2131 insertions(+), 28 deletions(-)
 create mode 100644 drivers/vhost/Kconfig
 create mode 100644 drivers/vhost/Makefile
 create mode 100644 drivers/vhost/net.c
 create mode 100644 drivers/vhost/vhost.c
 create mode 100644 drivers/vhost/vhost.h
 create mode 100644 include/linux/vhost.h

commit 263bdf09e82b7f67c9aee4bd78f65deefecd5d4a
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Wed Nov 4 17:55:02 2009 +0200

    tun: export underlying socket
    
    Tun device looks similar to a packet socket
    in that both pass complete frames from/to userspace.
    
    This patch fills in enough fields in the socket underlying tun driver
    to support sendmsg/recvmsg operations, and message flags
    MSG_TRUNC and MSG_DONTWAIT, and exports access to this socket
    to modules.  Regular read/write behaviour is unchanged.
    
    This way, code using raw sockets to inject packets
    into a physical device, can support injecting
    packets into host network stack almost without modification.
    
    First user of this interface will be vhost virtualization
    accelerator.
    
    Signed-off-by: "Michael S. Tsirkin" <mst@redhat.com>
    Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
    Acked-by: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/net/tun.c      |  101 +++++++++++++++++++++++++++++++++++++++---------
 include/linux/if_tun.h |   14 +++++++
 2 files changed, 96 insertions(+), 19 deletions(-)

commit f7223dc041362ff8c2e1eca559e5d412f83dec81
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Wed Nov 4 17:55:38 2009 +0200

    mm: export use_mm/unuse_mm to modules
    
    vhost net module wants to do copy to/from user from a kernel thread,
    which needs use_mm. Export it to modules.
    
    Acked-by: Andrea Arcangeli <aarcange@redhat.com>
    Signed-off-by: "Michael S. Tsirkin" <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 mm/mmu_context.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

commit 87190ae195562c4cd8efe09945765d497f4a6171
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Mon Nov 9 19:22:30 2009 +0200

    vhost_net: a kernel-level virtio server
    
    What it is: vhost net is a character device that can be used to reduce
    the number of system calls involved in virtio networking.
    Existing virtio net code is used in the guest without modification.
    
    There's similarity with vringfd, with some differences and reduced scope
    - uses eventfd for signalling
    - structures can be moved around in memory at any time (good for
      migration, bug work-arounds in userspace)
    - write logging is supported (good for migration)
    - support memory table and not just an offset (needed for kvm)
    
    common virtio related code has been put in a separate file vhost.c and
    can be made into a separate module if/when more backends appear.  I used
    Rusty's lguest.c as the source for developing this part : this supplied
    me with witty comments I wouldn't be able to write myself.
    
    What it is not: vhost net is not a bus, and not a generic new system
    call. No assumptions are made on how guest performs hypercalls.
    Userspace hypervisors are supported as well as kvm.
    
    How it works: Basically, we connect virtio frontend (configured by
    userspace) to a backend. The backend could be a network device, or a tap
    device.  Backend is also configured by userspace, including vlan/mac
    etc.
    
    Status: This works for me, and I haven't see any crashes.
    Compared to userspace, people reported improved latency (as I save up to
    4 system calls per packet), as well as better bandwidth and CPU
    utilization.
    
    Features that I plan to look at in the future:
    - mergeable buffers
    - zero copy
    - scalability tuning: figure out the best threading model to use
    
    Note on RCU usage (this is also documented in vhost.h, near
    private_pointer which is the value protected by this variant of RCU):
    what is happening is that the rcu_dereference() is being used in a
    workqueue item.  The role of rcu_read_lock() is taken on by the start of
    execution of the workqueue item, of rcu_read_unlock() by the end of
    execution of the workqueue item, and of synchronize_rcu() by
    flush_workqueue()/flush_work(). In the future we might need to apply
    some gcc attribute or sparse annotation to the function passed to
    INIT_WORK(). Paul's ack below is for this RCU usage.
    
    (Includes fixes by Alan Cox <alan@linux.intel.com>)
    
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Signed-off-by: "Michael S. Tsirkin" <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 MAINTAINERS                |    9 +
 arch/x86/kvm/Kconfig       |    1 +
 drivers/Makefile           |    1 +
 drivers/vhost/Kconfig      |   11 +
 drivers/vhost/Makefile     |    2 +
 drivers/vhost/net.c        |  648 +++++++++++++++++++++++++++++
 drivers/vhost/vhost.c      |  968 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h      |  159 ++++++++
 include/linux/Kbuild       |    1 +
 include/linux/miscdevice.h |    1 +
 include/linux/vhost.h      |  130 ++++++
 11 files changed, 1931 insertions(+), 0 deletions(-)

commit 7e280facc1c0ab91e20dbc93d8e8dd88ca6ebaad
Author: Adam Litke <agl@us.ibm.com>
Date:   Mon Nov 30 10:14:15 2009 -0600

    virtio: Add memory statistics reporting to the balloon driver (V4)
    
    Changes since V3:
     - Do not do endian conversions as they will be done in the host
     - Report stats that reference a quantity of memory in bytes
     - Minor coding style updates
    
    Changes since V2:
     - Increase stat field size to 64 bits
     - Report all sizes in kb (not pages)
     - Drop anon_pages stat and fix endianness conversion
    
    Changes since V1:
     - Use a virtqueue instead of the device config space
    
    When using ballooning to manage overcommitted memory on a host, a system for
    guests to communicate their memory usage to the host can provide information
    that will minimize the impact of ballooning on the guests.  The current method
    employs a daemon running in each guest that communicates memory statistics to a
    host daemon at a specified time interval.  The host daemon aggregates this
    information and inflates and/or deflates balloons according to the level of
    host memory pressure.  This approach is effective but overly complex since a
    daemon must be installed inside each guest and coordinated to communicate with
    the host.  A simpler approach is to collect memory statistics in the virtio
    balloon driver and communicate them directly to the hypervisor.
    
    This patch enables the guest-side support by adding stats collection and
    reporting to the virtio balloon driver.
    
    Signed-off-by: Adam Litke <agl@us.ibm.com>
    Cc: Anthony Liguori <anthony@codemonkey.ws>
    Cc: virtualization@lists.linux-foundation.org
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (minor fixes)

 drivers/virtio/virtio_balloon.c |   94 +++++++++++++++++++++++++++++++++++---
 include/linux/virtio_balloon.h  |   15 ++++++
 2 files changed, 101 insertions(+), 8 deletions(-)

commit add41851972501680c0a9a71228e3a7495d6bea3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Dec 9 11:48:11 2009 -0600

    lguest: remove unneeded zlib.h include in example launcher
    
    Two years ago 5bbf89fc2608 removed the horrible bzImage unpacking code.
    Now it's time to remove the unneeded zlib.h include, too.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 Documentation/lguest/lguest.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
