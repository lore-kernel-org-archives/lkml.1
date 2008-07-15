Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYGOCd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYGOCd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbYGOCdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:33:47 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:48136 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYGOCdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:33:46 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 00/14] Introduce cpu_enabled_map and friends
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Date: Mon, 14 Jul 2008 20:33:44 -0600
Message-ID: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series presents cpu_enabled_map, which captures
the concept of a physically present and enabled CPU.

The complement of this map gives us present but disabled CPUs.
Perhaps the CPU was disabled by firmware for whatever reason.

For the most part, cpu_enabled_map will follow cpu_present_map.
On x86 and ia64, ACPI can tell us if a CPU is present, enabled,
or both. On those two archs, cpu_enabled_map is a subset of
cpu_present_map. All CPUs described in the MADT are now added
to cpu_present_map, but only ones with ACPI_MADT_ENABLED are
added to cpu_enabled_map.

Other archs may wish to do something similar, so some minimum
levels of support are included with this patch series, enabling
others to fill things in as desired. I certainly acknowledge
that a better job could be done.

Patch 01 introduces the actual map and interface.

Patches 02 -- 12 modify arch code in an attempt to populate the
map correctly.

Patch 12 is the most interesting one, in that we actually
demonstrate how an arch [ia64] would actually use cpu_enabled_map
to control calling cpu_up() on a given CPU.

Patch 13 fixes a potential overflow bug in ia64 ACPI code.

Patch 14 is the money patch. It demonstrates why we might
want to go through all these gyrations. Now that ia64 presents
*all* physically present CPUs in sysfs, even if they have been
disabled by firmware, we give userspace a way to poke at those
CPUs.

This is possible because present CPUs are in the ACPI namespace.
Even though we might not have a valid per_cpu pointer for a
disabled CPU (because we never called cpu_up() on it), we can
still obtain a valid ACPI handle for that CPU by walking the
namespace and executing methods underneath it.

The big picture implication is that we can allow userspace
to interact with disabled CPUs. In this particular example,
we provide a knob that lets a sysadmin schedule any present
CPU for firmware deconfiguration or enablement.

I have compile tested on:

	- arm, sparc, powerpc, alpha, x86, and ia64

I have boot tested on x86 and ia64

None of my x86 platforms have firmware support for disabling
CPUs, but my ia64 ones do, so that's where I've done my most
extensive testing.

Thanks.

/ac

---

Alex Chiang (14):
      ACPI: Provide /sys/devices/system/cpu/cpuN/deconfigure
      [IA64] Avoid overflowing ia64_cpu_to_sapicid in acpi_map_lsapic()
      [IA64] Populate and use cpu_enabled_map
      x86: Populate cpu_enabled_map
      [SPARC] Populate cpu_enabled_map
      [SH] Populate cpu_enabled_map
      [S390] Populate cpu_enabled_map
      [POWERPC] Populate cpu_enabled_map
      [PARISC] Populate cpu_enabled_map
      [MIPS] Populate cpu_enabled_map
      [ARM] Populate cpu_enabled_map
      [ALPHA] Populate cpu_enabled_map
      [M32R] Populate cpu_enabled_map
      Introduce cpu_enabled_map and friends


 arch/alpha/kernel/process.c                  |    2 
 arch/alpha/kernel/smp.c                      |    2 
 arch/arm/mach-realview/platsmp.c             |    4 
 arch/ia64/kernel/acpi.c                      |   21 +-
 arch/ia64/kernel/smpboot.c                   |    7 +
 arch/m32r/kernel/smpboot.c                   |    1 
 arch/mips/kernel/smp.c                       |    1 
 arch/mips/kernel/smtc.c                      |    1 
 arch/parisc/kernel/processor.c               |    1 
 arch/parisc/kernel/smp.c                     |    3 
 arch/powerpc/kernel/setup-common.c           |    1 
 arch/powerpc/platforms/powermac/smp.c        |    1 
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    2 
 arch/s390/kernel/smp.c                       |    7 +
 arch/sh/kernel/smp.c                         |    1 
 arch/sparc/kernel/smp.c                      |    1 
 arch/sparc64/kernel/mdesc.c                  |    1 
 arch/sparc64/kernel/smp.c                    |    1 
 arch/x86/kernel/acpi/boot.c                  |    7 -
 arch/x86/kernel/apic_32.c                    |    1 
 arch/x86/kernel/apic_64.c                    |    1 
 arch/x86/kernel/smpboot.c                    |    2 
 arch/x86/mach-voyager/voyager_smp.c          |    2 
 arch/x86/xen/smp.c                           |    1 
 drivers/acpi/Kconfig                         |   18 ++
 drivers/acpi/Makefile                        |    4 
 drivers/acpi/processor_core.c                |    8 +
 drivers/acpi/processor_deconfigure.c         |  275 ++++++++++++++++++++++++++
 drivers/base/cpu.c                           |    9 +
 include/acpi/processor.h                     |    6 +
 include/asm-ia64/smp.h                       |    1 
 include/asm-m32r/smp.h                       |    1 
 include/linux/cpumask.h                      |   31 ++-
 init/main.c                                  |    1 
 kernel/sched.c                               |   16 +-
 35 files changed, 415 insertions(+), 27 deletions(-)
 create mode 100644 drivers/acpi/processor_deconfigure.c

