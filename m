Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZJEBTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZJEBTC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 21:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbZJEBTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 21:19:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1813 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041AbZJEBTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 21:19:00 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: iommu@lists.linux-foundation.org, amd64-microcode@amd64.org,
       kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       kexec@lists.infradead.org, linux-pm@lists.linux-foundation.org
Subject: [PATCH 00/21] pr_dbg, pr_fmt
Date: Sun,  4 Oct 2009 18:18:14 -0700
Message-Id: <cover.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One possible long term goal is to stop adding
    #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
to source files to prefix modulename to logging output.

It might be useful to eventually have kernel.h
use a standard #define pr_fmt which includes KBUILD_MODNAME
instead of a blank or empty define.

Perhaps over time, the source modules that use pr_<level>
with prefixes can be converted to use pr_fmt.

If all modules are converted, that will allow the printk
routine to add module/filename/line/offset to the logging
lines using some function similar to dynamic_debug and
substantially reduct object string use by removing the
repeated prefixes.

This patchset does not get to that result.  The patches
right now uses _more_ string space because all logging
messages have unshared prefixes but it may be a useful start.

The patchset strips prefixes from printks and adds pr_fmt to
arch/x86, crypto, kernel, and a few drivers.

It also converts printk(KERN_<level> to pr_<level> in a few files
that already had some pr_<level> uses.

The conversion also generally used long length format strings
in the place of multiple short strings to ease any grep/search.
 
Joe Perches (21):
  include/linux/ dynamic_debug.h kernel.h: Remove KBUILD_MODNAME from dynamic_pr_debug, add #define pr_dbg
  ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
  mtrr: use pr_<level> and pr_fmt
  microcode: use pr_<level> and add pr_fmt
  amd_iommu.c: use pr_<level> and add pr_fmt(fmt)
  es7000_32.c: use pr_<level> and add pr_fmt(fmt)
  arch/x86/kernel/apic/: use pr_<level> and add pr_fmt(fmt)
  mcheck/: use pr_<level> and add pr_fmt(fmt)
  arch/x86/kernel/setup_percpu.c: use pr_<level> and add pr_fmt(fmt)
  arch/x86/kernel/cpu/: use pr_<level> and add pr_fmt(fmt)
  i8254.c: Add pr_fmt(fmt)
  kmmio.c: Add and use pr_fmt(fmt)
  testmmiotrace.c: Add and use pr_fmt(fmt)
  crypto/: use pr_<level> and add pr_fmt(fmt)
  kernel/power/: use pr_<level> and add pr_fmt(fmt)
  kernel/kexec.c: use pr_<level> and add pr_fmt(fmt)
  crypto/async_tx/raid6test.c: use pr_<level> and add pr_fmt(fmt)
  arch/x86/mm/mmio-mod.c: use pr_fmt
  drivers/net/bonding/: : use pr_fmt
  drivers/net/tlan: use pr_<level> and add pr_fmt(fmt)
  drivers/net/tlan.h: Convert printk(KERN_DEBUG to pr_dbg(

 arch/x86/kernel/amd_iommu.c                |   71 ++--
 arch/x86/kernel/apic/apic.c                |   48 ++--
 arch/x86/kernel/apic/apic_flat_64.c        |    5 +-
 arch/x86/kernel/apic/bigsmp_32.c           |    8 +-
 arch/x86/kernel/apic/es7000_32.c           |   12 +-
 arch/x86/kernel/apic/io_apic.c             |  239 ++++++------
 arch/x86/kernel/apic/nmi.c                 |   29 +-
 arch/x86/kernel/apic/numaq_32.c            |   53 ++--
 arch/x86/kernel/apic/probe_32.c            |   18 +-
 arch/x86/kernel/apic/probe_64.c            |    8 +-
 arch/x86/kernel/apic/summit_32.c           |   23 +-
 arch/x86/kernel/apic/x2apic_uv_x.c         |   26 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |    9 +-
 arch/x86/kernel/cpu/amd.c                  |   26 +-
 arch/x86/kernel/cpu/bugs.c                 |   23 +-
 arch/x86/kernel/cpu/bugs_64.c              |    4 +-
 arch/x86/kernel/cpu/centaur.c              |   12 +-
 arch/x86/kernel/cpu/common.c               |   54 ++--
 arch/x86/kernel/cpu/cpu_debug.c            |    4 +-
 arch/x86/kernel/cpu/cyrix.c                |   12 +-
 arch/x86/kernel/cpu/intel.c                |   14 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c      |   14 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c    |   20 +-
 arch/x86/kernel/cpu/mcheck/mce.c           |   59 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c     |    8 +-
 arch/x86/kernel/cpu/mcheck/p5.c            |   21 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |   21 +-
 arch/x86/kernel/cpu/mcheck/threshold.c     |    7 +-
 arch/x86/kernel/cpu/mcheck/winchip.c       |    8 +-
 arch/x86/kernel/cpu/mtrr/centaur.c         |    4 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c         |   59 ++--
 arch/x86/kernel/cpu/mtrr/generic.c         |   39 +-
 arch/x86/kernel/cpu/mtrr/main.c            |   32 +-
 arch/x86/kernel/cpu/perf_event.c           |   10 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c     |   11 +-
 arch/x86/kernel/cpu/transmeta.c            |   20 +-
 arch/x86/kernel/cpu/vmware.c               |   11 +-
 arch/x86/kernel/ftrace.c                   |    8 +-
 arch/x86/kernel/microcode_amd.c            |    5 +-
 arch/x86/kernel/microcode_core.c           |   23 +-
 arch/x86/kernel/microcode_intel.c          |   47 +--
 arch/x86/kernel/setup_percpu.c             |   13 +-
 arch/x86/kvm/i8254.c                       |   12 +-
 arch/x86/mm/kmmio.c                        |   40 +-
 arch/x86/mm/mmio-mod.c                     |   71 ++--
 arch/x86/mm/testmmiotrace.c                |   29 +-
 crypto/algapi.c                            |    4 +-
 crypto/ansi_cprng.c                        |   39 +-
 crypto/async_tx/async_tx.c                 |    5 +-
 crypto/async_tx/raid6test.c                |   30 +-
 crypto/fips.c                              |    4 +-
 crypto/tcrypt.c                            |   75 ++--
 crypto/testmgr.c                           |  286 ++++++--------
 crypto/xor.c                               |   17 +-
 drivers/net/bonding/bond_3ad.c             |  171 +++++----
 drivers/net/bonding/bond_alb.c             |   38 +--
 drivers/net/bonding/bond_ipv6.c            |   12 +-
 drivers/net/bonding/bond_main.c            |  608 +++++++++++-----------------
 drivers/net/bonding/bond_sysfs.c           |  322 ++++++---------
 drivers/net/tlan.c                         |  135 +++---
 drivers/net/tlan.h                         |    2 +-
 include/linux/dynamic_debug.h              |   13 +-
 include/linux/kernel.h                     |    7 +-
 kernel/kexec.c                             |   21 +-
 kernel/power/hibernate.c                   |   46 +--
 kernel/power/hibernate_nvs.c               |    6 +-
 kernel/power/process.c                     |   29 +-
 kernel/power/snapshot.c                    |   36 +-
 kernel/power/suspend.c                     |   18 +-
 kernel/power/suspend_test.c                |   18 +-
 kernel/power/swap.c                        |   42 +-
 kernel/power/swsusp.c                      |   10 +-
 kernel/power/user.c                        |    8 +-
 73 files changed, 1543 insertions(+), 1749 deletions(-)

