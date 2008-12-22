Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYLVU75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYLVU75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYLVU7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:59:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41288 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbYLVU7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:59:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 22 Dec 2008 21:59:03 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.4eee7cc37a8f564e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, more interesting is what's /not/ yet in linux1394-2.6.git but will
hopefully be ready for the post-2.6.28 merge window, and that's the
following changes to the <linux/firewire-cdev.h> ABI:
  - Add ioctls for isochronous resource management,
  - add ioctl for broadcast write requests,
  - add ioctl for iso context removal, allow more than one iso context
    per fd.  (This is the least important feature though.)

Jay Fenlason has had implementations of all of these for a while now, I
just need to bring them up-to-date with the latest fw-cdev changes,
notably the client resource idr change.

So, I hope to have some substantial additions ready soon, on top of what
/is/ in linux1394-2.6.git at the moment:

David Moore (1):
      firewire: Include iso timestamp in headers when header_size > 4

Frans Pop (1):
      ieee1394: ohci1394: don't leave interrupts enabled during suspend/resume

Harvey Harrison (7):
      ieee1394: consolidate uses of IEEE1934_BUSID_MAGIC
      ieee1394: pcilynx: trivial endian annotation
      ieee1394: replace CSR_SET_BUS_INFO_GENERATION macro
      ieee1394: mark bus_info_data as a __be32 array
      ieee1394: eth1394: trivial sparse annotations
      ieee1394: dv1394 annotate frame input/output structs as little endian
      ieee1934: dv1394: interrupt enabling/disabling broken on big-endian

Jay Fenlason (3):
      firewire: add a client_list_lock
      firewire: typo in comment
      firewire: improve refcounting of fw_card

Stefan Richter (12):
      firewire: convert client_list_lock to mutex
      firewire: fw-sbp2: remove unnecessary locking
      firewire: fix small memory leak at module removal
      ieee1394: replace a GFP_ATOMIC by GFP_KERNEL allocation
      ieee1394: mark all hpsb_address_ops instances as const
      ieee1394: ohci1394: pass error codes from request_irq through
      ieee1394: ohci1394: flush MMIO writes before delay in initialization
      firewire: fix resetting of bus manager retry counter
      firewire: reorder struct fw_card for better cache efficiency
      firewire: cdev: documentation fixlet
      firewire: cdev: tcodes input validation
      ieee1394: ignore nonzero Bus_Info_Block.max_rom, fetch config ROM in quadlets

 drivers/firewire/fw-card.c        |   20 ++++++--
 drivers/firewire/fw-cdev.c        |   63 ++++++++++++++++---------
 drivers/firewire/fw-device.c      |   11 +++--
 drivers/firewire/fw-device.h      |    6 ++
 drivers/firewire/fw-ohci.c        |   73 ++++++++++++++---------------
 drivers/firewire/fw-sbp2.c        |   21 ++------
 drivers/firewire/fw-topology.c    |   16 +++----
 drivers/firewire/fw-transaction.c |    2 +
 drivers/firewire/fw-transaction.h |   13 ++---
 drivers/ieee1394/csr.c            |   12 ++--
 drivers/ieee1394/csr.h            |   10 ++--
 drivers/ieee1394/csr1212.c        |   45 ++++++------------
 drivers/ieee1394/csr1212.h        |    9 +---
 drivers/ieee1394/dv1394-private.h |   44 +++++++++---------
 drivers/ieee1394/dv1394.c         |   12 ++--
 drivers/ieee1394/eth1394.c        |   28 ++++++------
 drivers/ieee1394/eth1394.h        |   16 +++---
 drivers/ieee1394/highlevel.c      |    9 ++--
 drivers/ieee1394/highlevel.h      |    7 ++-
 drivers/ieee1394/hosts.c          |    6 +-
 drivers/ieee1394/hosts.h          |    2 +-
 drivers/ieee1394/ieee1394.h       |    3 +
 drivers/ieee1394/nodemgr.c        |   20 ++------
 drivers/ieee1394/nodemgr.h        |    3 -
 drivers/ieee1394/ohci1394.c       |   26 ++++++++---
 drivers/ieee1394/pcilynx.c        |    2 +-
 drivers/ieee1394/pcilynx.h        |    2 +-
 drivers/ieee1394/raw1394.c        |    2 +-
 drivers/ieee1394/sbp2.c           |    4 +-
 include/linux/firewire-cdev.h     |    2 +-
 30 files changed, 246 insertions(+), 243 deletions(-)

Some further notes:
  - We still need to increment the ABI version number due to David's
    patch, and document the change appropriately.
  - There is still an old fw-topology patch in #master which is not yet
    merge-ready, my "insist on successive self ID complete events".
  - I really should stop messing around with drivers/ieee1394 and
    instead concentrate on drivers/firewire now.

But wait, there is one other thing sitting in linux1394-2.6.git:  The
firedtv driver which went from Greg's staging tree to linux1394-2.6.git
before it was decided to put several staging drivers into 2.6.28
mainline --- and so it happened that firedtv is still out of the
mainline.  I still want to do some mostly trivial updates to it before I
post a snapshot on LKML for review.  I hope to get this done during the
coming merge window, or slightly thereafter, and to get it finally into
mainline for 2.6.29.

There is one todo-item of this driver which is not trivial, and that's
its adaptation from drivers/ieee1394 to drivers/firewire.  But this
should not block its mainline submission.

Ben Backx (2):
      firesat: fix DVB-S2 device recognition
      firesat: add DVB-S support for DVB-S2 devices

Greg Kroah-Hartman (1):
      DVB: add firesat driver

Henrik Kurelid (5):
      firesat: update isochronous interface, add CI support
      firesat: avc resend
      firedtv: fix returned struct for ca_info
      firedtv: use length_field() of PMT as length
      firedtv: fix registration - adapter number could only be zero

Stefan Richter (29):
      firesat: add missing copyright notes
      firesat: rename to firedtv
      firedtv: nicer registration message and some initialization fixes
      firedtv: some header cleanups
      firedtv: replace semaphore by mutex
      firedtv: move some code back to ieee1394 core
      firedtv: replace tasklet by workqueue job
      firedtv: fix remote control input
      ieee1394: use correct barrier types between accesses of nodeid and generation
      ieee1394: add hpsb_node_read() and hpsb_node_lock()
      ieee1394: inherit ud vendor_id from node vendor_id
      firedtv: use hpsb_node_read(), _write(), _lock()
      firedtv: add vendor_id and version to driver match table
      firedtv: remove unused dual subunit code from initialization
      firedtv: fix initialization of dvb_frontend.ops
      firedtv: remove unused struct members
      firedtv: fix string comparison and a few sparse warnings
      firedtv: register input device as child of a FireWire device
      firedtv: remove various debug code
      firedtv: remove AV/C debug code
      firedtv: remove CA debug code
      firedtv: trivial cleanups in firesat-ci
      firedtv: trivial cleanups in cmp
      firedtv: remove bitfield typedefs from cmp, fix for big endian CPUs
      firedtv: don't retry oPCR updates endlessly
      firedtv: trivial cleanups in avc_api
      firedtv: trivial reorganization in avc_api
      firedtv: replace mdelay by msleep
      firedtv: increase FCP frame length for DVB-S2 tune QSPK

 drivers/ieee1394/dma.h                   |    1 +
 drivers/ieee1394/ieee1394_core.c         |    1 +
 drivers/ieee1394/ieee1394_transactions.c |   29 +
 drivers/ieee1394/ieee1394_transactions.h |    2 +
 drivers/ieee1394/iso.h                   |    1 +
 drivers/ieee1394/nodemgr.c               |   10 +-
 drivers/ieee1394/nodemgr.h               |   18 +
 drivers/media/dvb/Kconfig                |    2 +
 drivers/media/dvb/Makefile               |    2 +
 drivers/media/dvb/firesat/Kconfig        |   12 +
 drivers/media/dvb/firesat/Makefile       |   13 +
 drivers/media/dvb/firesat/avc_api.c      | 1051 ++++++++++++++++++++++
 drivers/media/dvb/firesat/avc_api.h      |  432 +++++++++
 drivers/media/dvb/firesat/cmp.c          |  171 ++++
 drivers/media/dvb/firesat/cmp.h          |    9 +
 drivers/media/dvb/firesat/firesat-ci.c   |  261 ++++++
 drivers/media/dvb/firesat/firesat-ci.h   |    9 +
 drivers/media/dvb/firesat/firesat-rc.c   |  191 ++++
 drivers/media/dvb/firesat/firesat-rc.h   |   11 +
 drivers/media/dvb/firesat/firesat.h      |  227 +++++
 drivers/media/dvb/firesat/firesat_1394.c |  291 ++++++
 drivers/media/dvb/firesat/firesat_dvb.c  |  276 ++++++
 drivers/media/dvb/firesat/firesat_fe.c   |  245 +++++
 drivers/media/dvb/firesat/firesat_iso.c  |  111 +++
 24 files changed, 3373 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/dvb/firesat/Kconfig
 create mode 100644 drivers/media/dvb/firesat/Makefile
 create mode 100644 drivers/media/dvb/firesat/avc_api.c
 create mode 100644 drivers/media/dvb/firesat/avc_api.h
 create mode 100644 drivers/media/dvb/firesat/cmp.c
 create mode 100644 drivers/media/dvb/firesat/cmp.h
 create mode 100644 drivers/media/dvb/firesat/firesat-ci.c
 create mode 100644 drivers/media/dvb/firesat/firesat-ci.h
 create mode 100644 drivers/media/dvb/firesat/firesat-rc.c
 create mode 100644 drivers/media/dvb/firesat/firesat-rc.h
 create mode 100644 drivers/media/dvb/firesat/firesat.h
 create mode 100644 drivers/media/dvb/firesat/firesat_1394.c
 create mode 100644 drivers/media/dvb/firesat/firesat_dvb.c
 create mode 100644 drivers/media/dvb/firesat/firesat_fe.c
 create mode 100644 drivers/media/dvb/firesat/firesat_iso.c

-- 
Stefan Richter
-=====-==--- ==-- =-==-
http://arcgraph.de/sr/

