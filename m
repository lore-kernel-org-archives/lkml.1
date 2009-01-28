Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZA1Xnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZA1Xnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZA1XnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:37320 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995AbZA1XnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:13 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: x86: unify genapic code, unify subarchitectures, remove old subarchitecture code
Date: Wed, 28 Jan 2009 23:41:06 +0000
Message-Id: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series of 114 patches implements a long desired restructuring,
unification and cleanup of the x86 APIC/SMP/subarch code:

  - unifies the 32-bit and 64-bit genapic code

  - sorts out all the subarch details into standalone and boot-time
    probable quirk modules

  - removes the build-time subarch hacks that we had on 32-bit.

This inevitably touches an awful lot of x86 code, and rather intrusively
so:

    112 files changed, 3277 insertions(+), 3209 deletions(-)

So breakages are to be expected. The commits are queued up in
tip/x86/apic and are in tip/master as well:

    http://people.redhat.com/mingo/tip.git/README

I ported the NUMAQ / Summit / bigsmp and ES7000 subarchitectures to the
new setup. They build and boot on regular hardware but are otherwise
untested. The x86/Voyager subarch is not fully ported yet (i cleaned up
its Kconfig impact) and hence disabled it for the time being. It
ought to be relatively straightforward to port it to the new code.

	Ingo

----------------------->

 arch/x86/Kconfig                                  |  203 ++++-----
 arch/x86/Kconfig.debug                            |    2 +-
 arch/x86/Makefile                                 |   26 --
 arch/x86/include/asm/apic.h                       |   33 ++
 arch/x86/include/asm/apm.h                        |   73 ++++
 arch/x86/include/asm/bigsmp/apic.h                |   71 ++--
 arch/x86/include/asm/bigsmp/apicdef.h             |    8 +-
 arch/x86/include/asm/bigsmp/ipi.h                 |   16 +-
 arch/x86/include/asm/cpu.h                        |    6 +-
 arch/x86/include/asm/do_timer.h                   |   16 +
 arch/x86/include/asm/entry_arch.h                 |   57 +++
 arch/x86/include/asm/es7000/apic.h                |  242 -----------
 arch/x86/include/asm/es7000/apicdef.h             |   13 -
 arch/x86/include/asm/es7000/ipi.h                 |   22 -
 arch/x86/include/asm/es7000/mpparse.h             |   29 --
 arch/x86/include/asm/es7000/wakecpu.h             |   37 --
 arch/x86/include/asm/genapic.h                    |  262 ++++++++++++-
 arch/x86/include/asm/genapic_32.h                 |  141 ------
 arch/x86/include/asm/genapic_64.h                 |   60 ---
 arch/x86/include/asm/hw_irq.h                     |    6 +-
 arch/x86/include/asm/ipi.h                        |   95 ++++-
 arch/x86/include/asm/mach-default/apm.h           |   73 ----
 arch/x86/include/asm/mach-default/do_timer.h      |   16 -
 arch/x86/include/asm/mach-default/entry_arch.h    |   52 ---
 arch/x86/include/asm/mach-default/mach_apic.h     |  168 --------
 arch/x86/include/asm/mach-default/mach_apicdef.h  |   24 -
 arch/x86/include/asm/mach-default/mach_ipi.h      |   64 ---
 arch/x86/include/asm/mach-default/mach_mpparse.h  |   17 -
 arch/x86/include/asm/mach-default/mach_mpspec.h   |   12 -
 arch/x86/include/asm/mach-default/mach_timer.h    |   48 ---
 arch/x86/include/asm/mach-default/mach_traps.h    |   33 --
 arch/x86/include/asm/mach-default/mach_wakecpu.h  |   41 --
 arch/x86/include/asm/mach-default/pci-functions.h |   19 -
 arch/x86/include/asm/mach-default/setup_arch.h    |    3 -
 arch/x86/include/asm/mach-default/smpboot_hooks.h |   61 ---
 arch/x86/include/asm/mach-generic/gpio.h          |   15 -
 arch/x86/include/asm/mach-generic/mach_apic.h     |   35 --
 arch/x86/include/asm/mach-generic/mach_apicdef.h  |   11 -
 arch/x86/include/asm/mach-generic/mach_ipi.h      |   10 -
 arch/x86/include/asm/mach-generic/mach_mpparse.h  |    9 -
 arch/x86/include/asm/mach-generic/mach_mpspec.h   |   12 -
 arch/x86/include/asm/mach-generic/mach_wakecpu.h  |   12 -
 arch/x86/include/asm/mach_timer.h                 |   48 +++
 arch/x86/include/asm/mach_traps.h                 |   33 ++
 arch/x86/include/asm/mpspec.h                     |   33 ++-
 arch/x86/include/asm/numaq/apic.h                 |  142 -------
 arch/x86/include/asm/numaq/apicdef.h              |   14 -
 arch/x86/include/asm/numaq/ipi.h                  |   22 -
 arch/x86/include/asm/numaq/mpparse.h              |    6 -
 arch/x86/include/asm/numaq/wakecpu.h              |   45 --
 arch/x86/include/asm/pci-functions.h              |   19 +
 arch/x86/include/asm/proto.h                      |    4 -
 arch/x86/include/asm/setup_arch.h                 |    3 +
 arch/x86/include/asm/smp.h                        |   19 -
 arch/x86/include/asm/smpboot_hooks.h              |   61 +++
 arch/x86/include/asm/summit/apic.h                |  202 ---------
 arch/x86/include/asm/summit/apicdef.h             |   13 -
 arch/x86/include/asm/summit/ipi.h                 |   26 --
 arch/x86/include/asm/summit/mpparse.h             |  109 -----
 arch/x86/kernel/Makefile                          |   11 +-
 arch/x86/kernel/acpi/boot.c                       |   25 +-
 arch/x86/kernel/apic.c                            |   46 ++-
 arch/x86/kernel/apm_32.c                          |    2 +-
 arch/x86/kernel/bigsmp_32.c                       |  268 ++++++++++++
 arch/x86/kernel/cpu/addon_cpuid_features.c        |   20 +-
 arch/x86/kernel/cpu/amd.c                         |    2 +-
 arch/x86/kernel/cpu/common.c                      |   19 +-
 arch/x86/kernel/cpu/intel.c                       |    2 +-
 arch/x86/kernel/crash.c                           |    2 +-
 arch/x86/kernel/entry_32.S                        |    2 +-
 arch/x86/kernel/es7000_32.c                       |  468 ++++++++++++++++++++-
 arch/x86/kernel/genapic_64.c                      |   22 +-
 arch/x86/kernel/genapic_flat_64.c                 |  176 ++++++---
 arch/x86/kernel/genx2apic_cluster.c               |  133 ++++--
 arch/x86/kernel/genx2apic_phys.c                  |  125 ++++---
 arch/x86/kernel/genx2apic_uv_x.c                  |  111 ++++--
 arch/x86/kernel/io_apic.c                         |  197 ++++-----
 arch/x86/kernel/ipi.c                             |   33 +-
 arch/x86/kernel/irq_32.c                          |    2 +-
 arch/x86/kernel/kgdb.c                            |    4 +-
 arch/x86/kernel/mpparse.c                         |   26 +-
 arch/x86/kernel/nmi.c                             |    2 +-
 arch/x86/kernel/numaq_32.c                        |  280 ++++++++++++-
 arch/x86/kernel/probe_32.c                        |  411 ++++++++++++++++++
 arch/x86/kernel/probe_roms_32.c                   |    2 +-
 arch/x86/kernel/process.c                         |    2 +-
 arch/x86/kernel/reboot.c                          |    4 +-
 arch/x86/kernel/setup.c                           |   30 +-
 arch/x86/kernel/smp.c                             |   13 +-
 arch/x86/kernel/smpboot.c                         |   37 +-
 arch/x86/kernel/summit_32.c                       |  417 ++++++++++++++++++-
 arch/x86/kernel/time_32.c                         |    2 +-
 arch/x86/kernel/tlb_uv.c                          |    2 +-
 arch/x86/kernel/traps.c                           |    2 +-
 arch/x86/kernel/tsc.c                             |    2 +-
 arch/x86/kernel/visws_quirks.c                    |    6 +-
 arch/x86/kernel/vmiclock_32.c                     |    2 +-
 arch/x86/mach-default/setup.c                     |  162 -------
 arch/x86/mach-generic/Makefile                    |   11 -
 arch/x86/mach-generic/bigsmp.c                    |   60 ---
 arch/x86/mach-generic/default.c                   |   27 --
 arch/x86/mach-generic/es7000.c                    |  103 -----
 arch/x86/mach-generic/numaq.c                     |   53 ---
 arch/x86/mach-generic/probe.c                     |  152 -------
 arch/x86/mach-generic/summit.c                    |   40 --
 arch/x86/mm/Makefile                              |    2 +-
 arch/x86/mm/tlb.c                                 |    4 +-
 arch/x86/pci/numaq_32.c                           |    2 +-
 arch/x86/pci/pcbios.c                             |    2 +-
 drivers/clocksource/acpi_pm.c                     |    2 +-
 drivers/clocksource/cyclone.c                     |    2 +-
 drivers/mtd/nand/Kconfig                          |    2 +-
 112 files changed, 3277 insertions(+), 3209 deletions(-)

Ingo Molnar (114):
      x86, genapic: refactor genapic_64.h
      x86, genapic: refactor genapic_32.h
      x86, genapic: unify struct genapic
      x86, genapic: finish unification
      x86, genapic: cleanups
      x86, genapic: provide IPI callbacks unconditionally
      x86: rename 'genapic' to 'apic'
      x86: clean up genapic_flat
      x86: clean up genapic_phys_flat
      x86: clean up apic_x2apic_uv_x
      x86: clean up apic_x2apic_phys
      x86: clean up apic_x2apic_cluster
      x86, genapic: cleanup 32-bit apic_default template
      x86, genapic: cleanup 32-bit apic_bigsmp template
      x86, genapic: cleanup 32-bit apic_numaq template
      x86, genapic: cleanup 32-bit apic_es7000 template
      x86, genapic: cleanup 32-bit apic_summit template
      x86: remove APIC_INIT / APICFUNC / IPIFUNC
      x86: clean up apic->acpi_madt_oem_check methods
      x86: clean up apic->apic_id_registered() methods
      x86, genapic: rename int_delivery_mode, et. al.
      x86, apic: remove IRQ_DEST_MODE / IRQ_DELIVERY_MODE
      x86, apic: remove DEFAULT_IRQ_DELIVERY_MODE and DEFAULT_IRQ_DEST_MODE
      x86, apic: remove SUMMIT_IRQ_DELIVERY_MODE and SUMMIT_IRQ_DEST_MODE
      x86, apic: remove NUMAQ_IRQ_DELIVERY_MODE and NUMAQ_IRQ_DEST_MODE
      x86, apic: remove BIGSMP_IRQ_DELIVERY_MODE and BIGSMP_IRQ_DEST_MODE
      x86, apic: remove ES7000_IRQ_DELIVERY_MODE and ES7000_IRQ_DEST_MODE
      x86, apic: remove IRQ_DEST_MODE
      x86, apic: clean up target_cpus methods
      x86, apic: clean up / remove TARGET_CPUS
      x86: clean up esr_disable() methods
      x86: rename ->ESR_DISABLE to ->disable_esr
      x86: clean up the APIC_DEST_LOGICAL logic
      x86, apic: rename genapic::apic_destination_logical to genapic::dest_logical
      x86, apic: clean up check_apicid*() callbacks
      x86, apic: remove no_balance_irq and no_ioapic_check flags
      x86, apic: clean up ->vector_allocation_domain()
      x86, apic: clean up ->init_apic_ldr()
      x86, apic: clean up ->ioapic_phys_id_map()
      x86, apic: clean up ->setup_apic_routing()
      x86, apic: streamline the ->multi_timer_check() quirk
      x86, apic: clean up ->apicid_to_node()
      x86, apic: clean up ->cpu_to_logical_apicid()
      x86, apic: clean up ->cpu_present_to_apicid()
      x86, apic: clean up ->apicid_to_cpu_present()
      x86: refactor ->setup_portio_remap() subarch methods
      x86: refactor ->check_phys_apicid_present() subarch methods
      x86: refactor ->enable_apic_mode() subarch methods
      x86, es7000: clean up es7000_enable_apic_mode()
      x86, apic: unify phys_pkg_id()
      x86, apic: refactor ->phys_pkg_id()
      x86, smp: clean up mps_oem_check()
      x86, mpparse: call the generic quirk handlers early
      x86: consolidate the ->mps_oem_check() code
      x86, apic: refactor ->get_apic_id() & GET_APIC_ID()
      x86, apic: refactor ->apic_id_mask & APIC_ID_MASK
      x86, apic: get rid of *_APIC_ID_MASK definitions
      x86, apic: refactor ->cpu_mask_to_apicid*()
      x86, apic: untangle the send_IPI_*() jungle
      x86, smp: clean up ->trampoline_phys_low/high handling
      x86: set ->trampoline_phys_low/high on 64-bit too
      x86, smp: refactor ->wait_for_init_deassert()
      x86, smp: refactor ->smp_callin_clear_local_apic() methods
      x86, smp: refactor ->store/restore_NMI_vector() methods
      x86, smp: remove ->restore_NMI_vector()
      x86, smp: refactor ->inquire_remote_apic() methods
      x86, ES7000: consolidate the APIC code
      x86, smp: eliminate asm/mach-default/mach_wakecpu.h
      x86: eliminate asm/mach-*/mach_mpparse.h
      x86: remove mach_mpspec.h
      x86: remove mach_apicdef.h
      x86, smp: refactor ->wake_cpu
      x86, numaq: consolidate code
      x86, summit: consolidate code
      x86: remove mach_apic.h
      x86, ES7000: Consolidate code
      x86, NUMAQ: Consolidate code
      x86, bigsmp: consolidate code
      x86, bigsmp: consolidate header code
      x86, smp: remove mach_ipi.h
      x86: remove subarchitecture support code
      x86: move mach-default/*.h files to asm/
      x86: remove subarchitecture support
      x86/Voyager: clean up BROKEN Kconfig reference
      x86: disable Voyager temporarily
      x86/Voyager: remove MCA Kconfig quirk
      x86/Voyager: remove NATSEMI Kconfig quirk
      x86/Voyager: remove KVM Kconfig quirk
      x86/Voyager: remove KGDB Kconfig quirk
      x86/Voyager: remove HIBERNATION Kconfig quirk
      x86/Voyager: remove ARCH_SUSPEND_POSSIBLE Kconfig quirk
      x86: replace CONFIG_X86_SMP with CONFIG_SMP
      x86: generalize boot_cpu_id
      x86/Voyager: remove X86_HT Kconfig quirk
      x86/Voyager: remove X86_BIOS_REBOOT Kconfig quirk
      x86/Voyager: remove X86_FIND_SMP_CONFIG Kconfig quirk
      x86/VisWS: remove Kconfig quirk
      x86/Voyager: remove VMI Kconfig quirk
      x86/Voyager: remove KVM_CLOCK quirk
      x86/Voyager: remove KVM_GUEST quirk
      x86/Voyager: remove PARAVIRT Kconfig quirk
      x86/Voyager: remove APIC/IO-APIC Kbuild quirk
      x86/Voyager: remove MCE quirk
      x86/Voyager: remove HOTPLUG_CPU Kconfig quirk
      x86/Voyager: remove power management Kconfig quirk
      x86/Voyager: remove ISA quirk
      x86: cleanup, introduce CONFIG_NON_STANDARD_PLATFORMS
      x86: move ELAN to the NON_STANDARD_PLATFORM section
      x86: move VOYAGER to the NON_STANDARD_PLATFORM section
      x86: move non-standard 32-bit platform Kconfig entries
      x86: move X86_VSMP from subarch menu
      x86: remove the subarch menu
      x86: rename X86_GENERICARCH to X86_32_NON_STANDARD
      x86/Voyager: move to the X86_32_NON_STANDARD code section


