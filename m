Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZFOIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZFOIKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZFOIJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:09:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46897 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZFOIJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:09:43 -0400
Message-ID: <4A3601BF.2000201@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:09:35 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 00/16] last-minute patches for MCE .31
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 16 patches for bugfixes and cleanups etc.
These are against tip/x86/mce3, but today I confirmed that these
can be applied on Linus's latest, with no errors.

Please consider applying these for .31

[1] Bugfix
      x86, mce: don't init timer if !mce_available
      x86, mce: call-in should be after updating global_nwo

 These bugs are not serious, but should be fixed asap.

[2] Misc (requested by Ingo)
      x86, mce: add __read_mostly
      x86, mce: rename static variables around trigger
      x86, mce: sysfs entries for new options

 Minor improvements (cleanups), and an enhancement for a feature
 newly introduced in this merge window (i.e. run-time disablement
 of cmci).

[3] Cleanups
      x86, mce: unify mce.h
      x86, mce: make mce_disabled boolean
      x86, mce: unify smp_thermal_interrupt, prepare p4
      x86, mce: unify smp_thermal_interrupt, prepare mce_intel_64
      x86, mce: unify smp_thermal_interrupt, prepare
      x86, mce: unify smp_thermal_interrupt
      x86, mce: squash mce_intel.c into therm_throt.c
      x86, mce: remove intel_set_thermal_handler()
      x86, mce: remove therm_throt.h
      x86, mce: mce.h cleanup
      x86, mce: rename

 There are 3 goals:

 [3-1] unify mce.h
   There are 2 files named mce.h:
        arch/x86/include/asm/mce.h
        arch/x86/kernel/cpu/mcheck/mce.h
   The latter is small, and in it:
        #include <asm/mce.h>
   so we can have a unified one.

 [3-2] finish unifying thermal codes
   Now codes for thermal interrupt is distributed for multiple
   files.  We can gather them in one therm_throt.c file. 

 arch/x86/include/asm/mce.h                |   53 +++++++++------
 arch/x86/include/asm/therm_throt.h        |    9 ---
 arch/x86/kernel/cpu/mcheck/Makefile       |    7 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   73 --------------------
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   21 ------
 arch/x86/kernel/cpu/mcheck/p4.c           |   45 ------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c  |  106 +++++++++++++++++++++++++++-
 7 files changed, 137 insertions(+), 177 deletions(-)
 delete mode 100644 arch/x86/include/asm/therm_throt.h
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c

   This makes Makefile clean & simple:
   before:
     obj-y                            =  mce.o therm_throt.o
     obj-$(CONFIG_X86_MCE_P4THERMAL)  += mce_intel.o
     obj-$(CONFIG_X86_MCE_INTEL)      += mce_intel_64.o mce_intel.o
   after:
     obj-y                            =  mce.o
     obj-$(CONFIG_X86_MCE_INTEL)      += mce_intel_64.o
     obj-$(CONFIG_X86_THERMAL_VECTOR) += therm_throt.o

 [3-3] rename
   Rename files that are no longer 64bit specific:
        mce_amd_64.c    => mce_amd.c
        mce_intel_64.c  => mce_intel.c

Thanks,
H.Seto

===

Hidetoshi Seto (16):
      x86, mce: don't init timer if !mce_available
      x86, mce: call-in should be after updating global_nwo
      x86, mce: add __read_mostly
      x86, mce: rename static variables around trigger
      x86, mce: sysfs entries for new options
      x86, mce: unify mce.h
      x86, mce: make mce_disabled boolean
      x86, mce: unify smp_thermal_interrupt, prepare p4
      x86, mce: unify smp_thermal_interrupt, prepare mce_intel_64
      x86, mce: unify smp_thermal_interrupt, prepare
      x86, mce: unify smp_thermal_interrupt
      x86, mce: squash mce_intel.c into therm_throt.c
      x86, mce: remove intel_set_thermal_handler()
      x86, mce: remove therm_throt.h
      x86, mce: mce.h cleanup
      x86, mce: rename

 arch/x86/include/asm/mce.h                |   63 ++-
 arch/x86/include/asm/therm_throt.h        |    9 -
 arch/x86/kernel/cpu/mcheck/Makefile       |    9 +-
 arch/x86/kernel/cpu/mcheck/k7.c           |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |  216 ++++++---
 arch/x86/kernel/cpu/mcheck/mce.h          |   38 --
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |  703 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |  703 -----------------------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |  249 ++++++++--
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |  248 ----------
 arch/x86/kernel/cpu/mcheck/non-fatal.c    |    3 +-
 arch/x86/kernel/cpu/mcheck/p4.c           |   48 +--
 arch/x86/kernel/cpu/mcheck/p5.c           |   15 +-
 arch/x86/kernel/cpu/mcheck/p6.c           |    3 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c  |  106 +++++-
 arch/x86/kernel/cpu/mcheck/winchip.c      |    3 +-
 arch/x86/kernel/traps.c                   |    3 +-
 17 files changed, 1220 insertions(+), 1202 deletions(-)
 delete mode 100644 arch/x86/include/asm/therm_throt.h
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce.h
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce_amd.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_amd_64.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel_64.c

