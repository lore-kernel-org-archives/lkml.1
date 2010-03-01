Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab0CAJiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:38:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:48267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0CAJh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:37:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,559,1262592000"; 
   d="scan'208";a="600066028"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7][v4] PV extension of HVM (Hybrid) for Xen
Date: Mon,  1 Mar 2010 17:38:28 +0800
Message-Id: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jeremy & Ian

Here is the forth version of patchset to enable PV extension of HVM support
in Linux kernel of Xen.

I'd like to have your comments on this patch series. We think the patches are
prepared for check in pv_ops domU tree.

The PV extension of HVM is started from real mode like HVM guest, but also with a
a range of PV features(e.g. PV halt, PV timer, event channel, as well as PV
drivers). So guest with this feature can takes the advantages of both H/W
virtualization and Para-Virtualization.

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

I've discussed the vector-evtchn mapping with Stefano, and we agreed on that
it's more complex than we thought, and can't brought much benefit for
pvops domU. So there is no major change in this update.

Change from v3:
1. Rebase to Linux 2.6.33 release.
2. change the name to "PV extension of HVM"
3. Some minor coding polishing.

Change from v2:
1. change the name "hybrid" to "PV featured HVM".
2. Unified the PV driver's judgement of xen_domain() to xen_evtchn_enabled().
3. Move the function(evtchn) initialize hypercall near the real enabling place,
rather than a unified place before function enabled.
4. Remove the reserved E820 region for grant table. Use QEmu Xen platform
device's MMIO instead.

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
