Return-Path: <linux-kernel-owner+w=401wt.eu-S1161523AbXD2XD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161523AbXD2XD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161532AbXD2XD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:03:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42122 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161523AbXD2XDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:03:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 30 Apr 2007 01:03:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 updates post 2.6.21
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.1171a59b9de88f9c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive IEEE 1394 subsystem updates as listed further below.
They are mostly cleanups in ieee1394 core and in eth1394 and two
more or less visible bugfixes:

  - eth1394 was always loaded by hotplug event as soon as a FireWire
    controller was initialized.  This irritated and frustrated a lot
    of users and distributors, since it influenced the order in which
    networking interfaces were added, and since a few users had
    difficulties to capture video if eth1394 was loaded.

    From now on, eth1394 is only loaded by hotplug if an external
    IP over 1394 capable device is plugged in.  The old behaviour can
    be emulated by these lines in /etc/modprobe.conf:
    install ohci1394 /sbin/modprobe eth1394; \
                     /sbin/modprobe --ignore-install ohci1394

  - eth1394 did not work over S100B...S400B (as opposed to S100A...
    S400A and S800B)

All of the patches have been in -mm for a while, just this 2nd small
bugfix and some trivial changes like in Kconfig help texts are quite
new.  All of the patches have been seen on the linux1394-devel
mailinglist, some also on lkml or netdev or linux-scsi.

I built the for-linus branch upon commit
b9099ff63c75216d6ca10bce5a1abcd9293c27e6 "Merge branch 'upstream-linus'
of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6" from
Sat, 28 Apr 2007 00:49:50 +0000 (17:49 -0700) to simplify the merge.

The stat and the shortlog:

 drivers/ieee1394/Kconfig                 |   52 +--
 drivers/ieee1394/config_roms.c           |   93 +---
 drivers/ieee1394/config_roms.h           |   20 +-
 drivers/ieee1394/csr1212.c               |  870 ++++++++++++------------------
 drivers/ieee1394/csr1212.h               |  483 +++--------------
 drivers/ieee1394/dma.c                   |   24 +
 drivers/ieee1394/dma.h                   |   22 +-
 drivers/ieee1394/eth1394.c               |  798 ++++++++++++---------------
 drivers/ieee1394/eth1394.h               |   25 +-
 drivers/ieee1394/highlevel.c             |   89 +++-
 drivers/ieee1394/highlevel.h             |   55 +--
 drivers/ieee1394/hosts.c                 |   23 +-
 drivers/ieee1394/hosts.h                 |   10 +-
 drivers/ieee1394/ieee1394_core.c         |  461 +++++++++-------
 drivers/ieee1394/ieee1394_core.h         |  100 +---
 drivers/ieee1394/ieee1394_transactions.c |   43 ++-
 drivers/ieee1394/ieee1394_transactions.h |   20 -
 drivers/ieee1394/iso.c                   |   85 +++-
 drivers/ieee1394/iso.h                   |   35 +--
 drivers/ieee1394/nodemgr.c               |   61 ++-
 drivers/ieee1394/nodemgr.h               |   24 +-
 drivers/ieee1394/ohci1394.c              |   12 +-
 drivers/ieee1394/ohci1394.h              |    4 +-
 drivers/ieee1394/raw1394.c               |    3 +-
 drivers/ieee1394/sbp2.c                  |   39 +-
 drivers/ieee1394/sbp2.h                  |    8 +-
 26 files changed, 1446 insertions(+), 2013 deletions(-)


Adrian Bunk (1):
      ieee1394: unexport highlevel_host_reset

Akinobu Mita (1):
      ieee1394: eth1394: fix error path in module_init

Andrew Morton (2):
      ieee1394: sbp2: include fixes
      ieee1394: iso.c needs sched.h

Bernhard Kauer (1):
      ieee1394: ohci1394: remove unnecessary rcvPhyPkt bit flipping in LinkControl register

Jean Delvare (1):
      ieee1394: eth1394: Move common recv_init code to helper function

Milind Arun Choudhary (1):
      ieee1394: SPIN_LOCK_UNLOCKED cleanup

Randy Dunlap (1):
      ieee1394: ieee1394_core printk format

Simon Arlott (1):
      ieee1394: ohci1394: Fix mistake in printk message.

Stefan Richter (46):
      ieee1394: sbp2: remove unnecessary alignments of struct members
      ieee1394: sbp2: enforce 32bit DMA mapping
      ieee1394: sbp2: optimize DMA direction of s/g tables
      ieee1394: sbp2: move some memory allocations into non-atomic context
      ieee1394: remove declarations of nonexisting functions
      ieee1394: move some comments from declaration to definition
      ieee1394: small header cleanup
      ieee1394: remove unused csr1212 code
      ieee1394: drop csr1212's support for external compilation
      ieee1394: csr1212: rename some types
      ieee1394: stricter error checks in csr1212
      ieee1394: de-inline some functions
      ieee1394: replace vmalloc by kmalloc in csr1212
      ieee1394: csr1212: coding style
      ieee1394: shrink csr1212_new_string_descriptor_leaf
      ieee1394: csr1212: warn on unreachable code
      ieee1394: csr1212: more sensible names for jump targets
      ieee1394: csr1212: log if devices have CRC errors in their ROM
      ieee1394: remove usage of skb_queue as packet queue
      ieee1394: some more includes
      ieee1394: unroll a weird macro
      ieee1394: nodemgr: less noise in dmesg
      ieee1394: nodemgr: unify some error messages
      ieee1394: send async streams at S100
      ieee1394: eth1394: unregister address space in failure case
      ieee1394: eth1394: clean up host removal
      ieee1394: eth1394: reduce excessive function inlining
      ieee1394: eth1394: don't autoload by hotplug when ohci1394 starts
      ieee1394: eth1394: coding style
      ieee1394: eth1394: .probe and .update may sleep
      ieee1394: eth1394: refactor .probe and .update
      ieee1394: eth1394: correct a memset argument
      ieee1394: eth1394: shorter error messages
      ieee1394: eth1394: contain host reset
      ieee1394: eth1394: allow MTU bigger than 1500
      ieee1394: eth1394: CONFIG_INET is always defined
      ieee1394: eth1394: omit useless set_mac_address callback
      ieee1394: eth1394: don't use alloc_etherdev
      ieee1394: eth1394: clean up fragment_overlap
      ieee1394: eth1394: some conditions are unlikely
      ieee1394: eth1394: hard_start_xmit is called in atomic context
      ieee1394: eth1394: correct return codes in hard_start_xmit
      ieee1394: eth1394: send async streams at S100 on 1394b buses
      ieee1394: ohci1394: fix cosmetic problem in error logging
      ieee1394: more help in Kconfig
      ieee1394: remove garbage from Kconfig

Torsten Kaiser (1):
      ieee1394: ieee1394_transactions needs sched.h

-- 
Stefan Richter
-=====-=-=== -=-- ====-
http://arcgraph.de/sr/

