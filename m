Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0BHIF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:05:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:57492 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0BHIF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:05:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,427,1262592000"; 
   d="scan'208";a="490500356"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7][v3] PV featured HVM(Hybrid) for Xen
Date: Mon,  8 Feb 2010 16:05:47 +0800
Message-Id: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jeremy & Keir & Ian

Here is the third version of patchset to enable Xen Hybrid extension support
in Linux kernel.

The Hybrid Extension is started from real mode like HVM guest, but also with a
a range of PV features(e.g. PV halt, PV timer, event channel, as well as PV
drivers). So guest with Hybrid extension feature can takes the advantages of
both H/W virtualization and Para-Virtualization.

The first two of the patchset imported several header file from Jeremy's tree
and Xen tree, respect to Jeremy and Keir's works.

The whole patchset based on Linux upstream.

You need a line like:

cpuid = [ '0x40000002:edx=0x3' ]

in HVM configuration file to expose hybrid feature to guest, and

CONFIG_XEN

in the guest kernel configuration file to enable the hybrid support.

And the compiled image can be used as native/pv domU/hvm guest/pv feature hvm kernel.

Current the patchset support x86_64 only.

Change from v2:
1. change the name "hybrid" to "PV featured HVM".
2. Unified the PV driver's judgement of xen_domain() to xen_evtchn_enabled().
3. Move the function(evtchn) initialize hypercall near the real enabling place,
rather than a unified place before function enabled.
4. Remove the reserved E820 region for grant table. Use QEmu Xen platform
device's MMIO instead.

But the item 4 introduce another issue: the gnttab_init() is listed as a
core_initcall, but the QEmu's Xen platform device is a device, the
initialization would be much later(and we need more code to probe that
device). Currently I just hardcode the MMIO address of platform device in the
gnttab_init() for HVM initialization, but don't think it's a good idea. And
since HVM's P2M is different from PV's address translate mechanism, we can't
use PV code to initialize grant table. So I think we may still need to reserve
several pages for it? The pages may be known by hypervisor, and use some way
to notify guest, like Ian purposed earlier. But seems it still looks like we
need E820... And more ideas?

The major change from v1:
1. SMP support.
2. Modify the entrance point to avoid most of genernic kernel modification.
3. Binding PV timer with event channel mechanism.

--
regards
Yang, Sheng

 arch/x86/include/asm/xen/cpuid.h     |   73 +++++++++++++
 arch/x86/include/asm/xen/hypercall.h |    6 +
 arch/x86/kernel/setup.c              |    8 ++
 arch/x86/xen/enlighten.c             |  188 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/irq.c                   |   54 ++++++++++
 arch/x86/xen/smp.c                   |  144 ++++++++++++++++++++++++++-
 arch/x86/xen/xen-head.S              |    6 +
 arch/x86/xen/xen-ops.h               |    4 +
 drivers/block/xen-blkfront.c         |    3 -
 drivers/input/xen-kbdfront.c         |    6 +-
 drivers/net/xen-netfront.c           |    5 -
 drivers/video/xen-fbfront.c          |    6 +-
 drivers/xen/events.c                 |   66 +++++++++++-
 drivers/xen/grant-table.c            |   59 ++++++++++-
 drivers/xen/xenbus/xenbus_probe.c    |   22 +++-
 include/xen/events.h                 |    1 +
 include/xen/hvm.h                    |   28 +++++
 include/xen/interface/hvm/hvm_op.h   |   79 ++++++++++++++
 include/xen/interface/hvm/params.h   |  111 ++++++++++++++++++++
 include/xen/interface/xen.h          |    6 +-
 include/xen/xen.h                    |   11 ++
 include/xen/xenbus.h                 |    3 +
 22 files changed, 861 insertions(+), 28 deletions(-)

