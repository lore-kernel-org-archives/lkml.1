Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0CHHRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:17:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:21812 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0CHHRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:17:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,601,1262592000"; 
   d="scan'208";a="498669660"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 0/7][v7] PV extension of HVM (Hybrid) for Xen
Date: Mon,  8 Mar 2010 15:18:45 +0800
Message-Id: <1268032732-8025-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jeremy

Here is the seventh version of patchset to enable PV extension of HVM support
in Linux kernel of Xen.

The patch based on upstream 2.6.33 with pv_ops domU support.

The PV extension of HVM is started from real mode like HVM guest, but also with a
a range of PV features(e.g. PV timer, event channel, and PV
drivers in the future). So guest with this feature can takes the advantages of
both H/W virtualization and Para-Virtualization.

The first two of the patchset imported several header file from Jeremy's tree
and Xen tree, respect to Jeremy and Keir's works.

The whole patchset based on Linux upstream.

You need a line like:

cpuid = [ '0x40000002:edx=0x7' ]

in HVM configuration file to expose all PV feature to guest, and

CONFIG_XEN

in the guest kernel configuration file to enable the PV extension support. It
would implicit enable CONFIG_XEN_HVM_PV if CONFIG_X86_64 is selected as well.

And the compiled image can be used as native/pv domU/hvm guest/pv feature hvm kernel.

Change from v6:
1. Make PV clocksource as a separate feature rather than default one.
Notice PV evtchn still depends on it.
2. Some comments update.

Change from v5:
Update the comments from Jeremy.

Change from v4:
1. Add a new CONFIG_XEN_HVM_PV to enable the feature in kernel
2. Separate the related code form enlighted.c to hvmpv.c
3. Separate the feature "PV clocksource" from evtchn. Now we can support HVM
guest with PV clocksource. This would be enabled by default.
4. Drop PV halt and pv drivers in this edition. We can work on that
later.
5. Update the patchset following Jeremy's comments.

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

 arch/x86/include/asm/xen/cpuid.h      |   75 +++++++++++
 arch/x86/include/asm/xen/hypercall.h  |    6 +
 arch/x86/include/asm/xen/hypervisor.h |    6 +
 arch/x86/kernel/setup.c               |    4 +
 arch/x86/xen/Kconfig                  |    4 +
 arch/x86/xen/Makefile                 |    1 +
 arch/x86/xen/enlighten.c              |    6 +-
 arch/x86/xen/hvmpv.c                  |  229 +++++++++++++++++++++++++++++++++
 arch/x86/xen/irq.c                    |   28 ++++
 arch/x86/xen/smp.c                    |   76 ++++++++++-
 arch/x86/xen/time.c                   |   12 ++-
 arch/x86/xen/xen-ops.h                |   17 +++
 drivers/block/xen-blkfront.c          |    2 +-
 drivers/input/xen-kbdfront.c          |    2 +-
 drivers/net/xen-netfront.c            |    2 +-
 drivers/video/xen-fbfront.c           |    2 +-
 drivers/xen/events.c                  |   74 ++++++++++-
 drivers/xen/grant-table.c             |    2 +-
 drivers/xen/xenbus/xenbus_probe.c     |    4 +-
 include/xen/events.h                  |    4 +
 include/xen/hvm.h                     |   28 ++++
 include/xen/interface/hvm/hvm_op.h    |   82 ++++++++++++
 include/xen/interface/hvm/params.h    |  111 ++++++++++++++++
 include/xen/interface/xen.h           |    6 +-
 include/xen/xen.h                     |   15 ++
 25 files changed, 776 insertions(+), 22 deletions(-)
