Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYHNN1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYHNN1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNN1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:27:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45945 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYHNN1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:27:10 -0400
Date: Thu, 14 Aug 2008 15:26:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Message-ID: <20080814132638.GA18743@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(lkml Cc:-ed)

* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> v10: make the x86 32 bit support sparse_irq too.
>     also make remove irqbalance in kernel for 32 bit
>     and make 32 bit support per_cpu vector. so start merging or io_apic_xx.c
> 
>     01-03 is some fix for current tree
>     04: is revert for one patch hide in sched/ and tip/master
> 
> based on tip/master
> 
> to do:
>     merge io_apic_xx.c

ok, i've created a new tip/irq/sparseirq topic branch for this.

Could you please send future updates against:

   git-checkout tip/master
   git-merge tip/irq/sparseirq

Not yet integrated into tip/master, i've still got some other backlog.

A couple of observations about the general structure of the sparse irqs 
code:

- the new APIs should probably live in mm/bootmem.c not in init/main.c, 
  and in bootmem.h. Also, it should be outlined clearly why this new API 
  is needed as a wrapper ontop of existing bootmem mechanisms.

- the #ifdef complications, while fine for migration, should be 
  eliminated. Could we introduce some compatible form for the 
  definition/allocation APIs that work even if an architecture still
  uses a flat irq array? That would remove most of the uglinesses.

- some of the irq < 16 checks in x86 look a bit ugly, can we do anything 
  about them?

- i think as a final-ish commit we should just remove the dyn-array 
  define and make all architectures use this facility. You converted 
  most of them - how many are still missing? Sparse-irq is more 
  intrusive so that should probably stay a Kconfig knob.

- there was one aspect of NR_IRQS that was nice and useful: it acted as 
  a sanity check against BIOS bugs and driver bugs that pass in some 
  irrealistically high irq number. Now we'll just try to allocate some 
  really high IRQ and accept it. I _think_ there should be a single,
  simple 'absolute maximum IRQ number' define which should set the 
  maximum possible IRQ number. Lets call it NR_IRQS_MAX or so, and set 
  it to NR_CPUS*NR_IO_APICS*224 or so?

- i'm a bit worried about linecount increase in general:

     247 files changed, 3671 insertions(+), 2052 deletions(-)

  could we work on reducing that somewhat? The new infrastructure bits 
  in mm/* and kernel/irq/* will be unavoidable, what we should 
  concentrate on is to make usage of the new facility just as 
  straightforward, easy and compact as the old irq_desc[] usages.

  A worst-case example is drivers/char/random.c: the 
  CONFIG_HAVE_SPARSE_IRQ and CONFIG_HAVE_DYN_ARRAY #ifdef jungle is not 
  acceptable. I think the best way out is to convert the whole kernel to 
  the new facilities (as safely as possible, without breaking other
  architectures), and making sure that the end result is easy to 
  understand and intuitive.

so i dont mind the current code as long as the extra complications are 
temporary during a safe conversion - but we should work on eliminating 
all those complications before thinking about upstream merging.

	Ingo

-------------------->
the irq/sparseirq git tree can be picked up from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/sparseirq

[ note, the diffstat has x86/core and some other topics that your 
  patches had dependencies on. Patch not included as vger would choke on 
  its 700K size. ]

------------------>
Alan Cox (1):
      serial, 8250: remove NR_IRQ usage

Alexander van Heukelum (1):
      x86, 64-bit, dwarf2: push pushes 8 bytes and popf pops 8

Andreas Herrmann (2):
      x86: pda_init(): fix memory leak when using CPU hotplug
      x86: cpu_init(): fix memory leak when using CPU hotplug

Cyrill Gorcunov (3):
      x86: apic unification - merge down lapic_get_maxlvt
      x86: apic unification - merge down enable_NMI_through_LVT0
      x86: apic interrupts - move assignments to irqinit_32.c, v2

David Brownell (2):
      hpet: /dev/hpet - fixes and cleanup
      hpet: /dev/hpet - fixes and cleanup, fix

Eric W. Biederman (1):
      genirq: enable polling for disabled screaming irqs

Hiroshi Shimamoto (1):
      x86_32: use apic_ops at print_local_APIC()

Huang Weiyi (1):
      arch/x86/kernel/genx2apic_uv_x.c: Removed duplicated include

Ingo Molnar (2):
      x86, xen: fix apic_ops build on UP
      x86, lguest: fix apic_ops build on UP

Jaswinder Singh (27):
      x86: Introducing asm/syscalls.h
      x86: process_32.c declare cpu_number before they get used
      x86: signal_XX.c declare do_notify_resume before they get used
      x86: time_XX.c declare functions before they get used
      x86: setup.c declare saved_video_mode before they get used
      x86: e820.c declare pci_mem_start before they get used
      x86: pci-dma.c declare iommu_bio_merge before they get used
      x86: pci-nommu.c declare nommu_dma_ops before they get used
      x86: i387.c declare dump_fpu() before they get used
      x86: ptrace.c declare functions before they get used
      x86: proc.c declare cpuinfo_op before they get used
      x86: common.c declare idle_regs before they get used
      x86: mtrr/main.c declare range_state as static
      x86: apic_XX.c declare functions before they get used
      x86: vm86_32.c declare functions before they get used
      x86: mm/init_XX.c declare functions before they get used
      x86: mm/fault.c declare do_page_fault before they get used
      x86: mm/ioremap.c declare early_ioremap_debug and early_ioremap_nested as static
      x86: mm/pageattr.c declare arch_report_meminfo before they get used
      x86: mm/pgtable_32.c declare set_pmd_pfn before they get used
      x86: mach-default/setup.c declare no_broadcast before they get used
      x86_64: Declare new_utsname in asm-x86/syscalls.h
      X86_32: declare pt_regs_access as unsigned long
      X86_SMP: smp.c declare functions before they get used
      X86_SMP: smpboot.c declare idle_thread_array and smp_b_stepping as static
      X86_SMP: ipi.c declare functions before they get used
      X86_SMP: tlb_XX.c declare smp_invalidate_interrupt before they get used

Joe Buehler (1):
      x86: add PCI ID for 6300ESB force hpet

Kevin Hao (1):
      x86: get irq for hpet timer

Krzysztof Oledzki (1):
      x86: add another PCI ID for ICH6 force-hpet

Maciej W. Rozycki (1):
      x86: PIC, L-APIC and I/O APIC debug information

Randy Dunlap (1):
      documentation: move hpet.txt to timers/ subdirectory

Suresh Siddha (36):
      x64, x2apic/intr-remap: Intel vt-d, IOMMU code reorganization
      x64, x2apic/intr-remap: fix the need for sequential array allocation of iommus
      x64, x2apic/intr-remap: code re-structuring, to be used by both DMA and Interrupt remapping
      x64, x2apic/intr-remap: use CONFIG_DMAR for DMA-remapping specific code
      x64, x2apic/intr-remap: Fix the need for RMRR in the DMA-remapping detection
      x64, x2apic/intr-remap: parse ioapic scope under vt-d structures
      x64, x2apic/intr-remap: move IOMMU_WAIT_OP() macro to intel-iommu.h
      x64, x2apic/intr-remap: Queued invalidation infrastructure (part of VT-d)
      x64, x2apic/intr-remap: Interrupt remapping infrastructure
      x64, x2apic/intr-remap: routines managing Interrupt remapping table entries.
      x64, x2apic/intr-remap: generic irq migration support from process context
      x64, x2apic/intr-remap: 8259 specific mask/unmask routines
      x64, x2apic/intr-remap: ioapic routines which deal with initial io-apic RTE setup
      x64, x2apic/intr-remap: introduce read_apic_id() to genapic routines
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support, fix
      x64, x2apic/intr-remap: basic apic ops support
      x64, x2apic/intr-remap: cpuid bits for x2apic feature
      x64, x2apic/intr-remap: disable DMA-remapping if Interrupt-remapping is detected (temporary quirk)
      x64, x2apic/intr-remap: x2apic ops for x2apic mode support
      x64, x2apic/intr-remap: introcude self IPI to genapic routines
      x64, x2apic/intr-remap: x2apic cluster mode support
      x64, x2apic/intr-remap: setup init_apic_ldr for UV
      x64, x2apic/intr-remap: IO-APIC support for interrupt-remapping
      x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
      x64, x2apic/intr-remap: add x2apic support, including enabling interrupt-remapping
      x64, x2apic/intr-remap: support for x2apic physical mode support
      x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
      x2apic: uninline uv_init_apic_ldr()
      x2apic: xen64 paravirt basic apic ops
      x2apic: kernel-parameter documentation for "x2apic_phys"
      x86: let 32bit use apic_ops too - fix
      x86: apic_ops for lguest
      x86: APIC: Remove apic_write_around(); use alternatives, merge fix
      x64, apic: use generic apic_write() for ack_APIC_irq()
      x64, fpu: fix possible FPU leakage in error conditions

Thomas Gleixner (1):
      genirq: remove last NO_IDLE_HZ leftovers

Vegard Nossum (3):
      x86: fix spurious '#' in kvm header
      x86: consolidate header guards
      x86: consolidate header guards

Yinghai Lu (62):
      x86: let 32bit use apic_ops too
      x86: mach_apicdef.h need to include before smp.h
      x86: make read_apic_id return final apicid
      x86: make 64bit have get_apic_id
      x86: let 32bit use apic_ops too - fix
      x86: add apic probe for genapic 64bit, v2
      x86: move declaring x2apic_extra_bits
      x86: add setup_ioapic_ids for numaq in x86_quirks
      x86: mach-bigsmp to bigsmp
      x86: mach_es7000 to es7000
      x86: mach_summit to summit
      x86: mach-numaq to numaq
      x86: add apic probe for genapic 64bit - fix
      x86: print per_cpu data address
      x86: add after_bootmem flag for 32bit
      x86: remove irq_vectors_limits
      generic: add dyn_array support
      add per_cpu_dyn_array support
      x86: alloc dyn_array all together
      x86: enable dyn_array support
      irq: introduce nr_irqs
      x86: use nr_irqs
      drivers/char: use nr_irqs
      drivers/net: use nr_irqs
      drivers/pci/ intr remapping: use nr_irqs
      drivers/pcmcia: use nr_irqs
      drivers/rtc: use nr_irqs
      drivers/scsi: use nr_irqs
      drivers/serial: use nr_irqs
      fs/proc: use nr_irqs
      drivers/xen: use nr_irqs
      irqs: make irq_timer_state to use dyn_array
      irq: make irq2_iommu to use dyn_array
      irq: make irq_desc to use dyn_array
      irq: make irqs in kernel stat use per_cpu_dyn_array
      x86: use dyn_array in io_apic_xx.c
      x86, irq: get nr_irqs from madt
      x86: remove nr_irq_vectors
      generic: sparse irqs: use irq_desc() together with dyn_array, instead of irq_desc[]
      x86: add irq_cfg in io_apic_64.c
      x86: put irq_2_pin pointer into irq_cfg
      x86: put timer_rand_state pointer into irq_desc
      x86: move kstat_irqs from kstat to irq_desc
      irq: add irq_desc_without_new
      irq: replace loop with nr_irqs with for_each_irq_desc
      irq, fs/proc: replace loop with nr_irqs for proc/stat
      x86, ioapic: replace loop with nr_irqs with for_each_irq_icfg
      irq: remove >= nr_irqs checking with config_have_sparse_irq
      generic: add irq_desc in function in paramater
      x86: check with without_new in show_interrupts
      x86_64: rename irq_desc/irq_desc_with_new
      irq: separate irq_descX from irq_descX_free
      x86_64: separate irq_cfgx from irq_cfgx_free
      x86_64: make /proc/interrupts work with dyn irq_desc
      x86: put irq_2_iommu pointer into irq_desc
      x86: use 28 bits irq NR for pci msi/msix and ht
      x86: remove irqbalance in kernel for 32 bit
      x86: add irq_cfg for 32bit
      x86: make 32bit use irq_cfg_with_new, etc
      x86: make 32bit to use irq_2_pin in irq_cfg
      x86: make 32 bit to use sparse_irq
      x86: make 32bit support per_cpu vector


 Documentation/00-INDEX                             |    2 -
 Documentation/kernel-parameters.txt                |    6 +
 Documentation/timers/00-INDEX                      |   10 +
 Documentation/{ => timers}/hpet.txt                |   43 +-
 arch/Kconfig                                       |    6 +
 arch/alpha/kernel/irq.c                            |   23 +-
 arch/alpha/kernel/irq_alpha.c                      |    7 +-
 arch/alpha/kernel/irq_i8259.c                      |    8 +-
 arch/alpha/kernel/irq_pyxis.c                      |    9 +-
 arch/alpha/kernel/irq_srm.c                        |    9 +-
 arch/alpha/kernel/sys_alcor.c                      |    9 +-
 arch/alpha/kernel/sys_cabriolet.c                  |    8 +-
 arch/alpha/kernel/sys_dp264.c                      |    9 +-
 arch/alpha/kernel/sys_eb64p.c                      |    8 +-
 arch/alpha/kernel/sys_eiger.c                      |    7 +-
 arch/alpha/kernel/sys_jensen.c                     |   50 +-
 arch/alpha/kernel/sys_marvel.c                     |   20 +-
 arch/alpha/kernel/sys_mikasa.c                     |    8 +-
 arch/alpha/kernel/sys_noritake.c                   |    8 +-
 arch/alpha/kernel/sys_rawhide.c                    |    8 +-
 arch/alpha/kernel/sys_rx164.c                      |    8 +-
 arch/alpha/kernel/sys_sable.c                      |    8 +-
 arch/alpha/kernel/sys_takara.c                     |    8 +-
 arch/alpha/kernel/sys_titan.c                      |    8 +-
 arch/alpha/kernel/sys_wildfire.c                   |   19 +-
 arch/arm/common/gic.c                              |    2 +-
 arch/arm/common/it8152.c                           |    2 +-
 arch/arm/common/locomo.c                           |   16 +-
 arch/arm/common/sa1111.c                           |    4 +-
 arch/arm/kernel/ecard.c                            |    4 +-
 arch/arm/kernel/irq.c                              |   20 +-
 arch/arm/mach-at91/gpio.c                          |    4 +-
 arch/arm/mach-davinci/gpio.c                       |   13 +-
 arch/arm/mach-ep93xx/core.c                        |   12 +-
 arch/arm/mach-footbridge/isa-irq.c                 |    2 +-
 arch/arm/mach-h720x/common.c                       |    2 +-
 arch/arm/mach-h720x/cpu-h7202.c                    |    2 +-
 arch/arm/mach-imx/irq.c                            |    2 +-
 arch/arm/mach-integrator/integrator_cp.c           |    2 +-
 arch/arm/mach-iop13xx/msi.c                        |    6 +-
 arch/arm/mach-ixp2000/core.c                       |    4 +-
 arch/arm/mach-ixp2000/ixdp2x00.c                   |    2 +-
 arch/arm/mach-ixp2000/ixdp2x01.c                   |    2 +-
 arch/arm/mach-ixp23xx/core.c                       |    2 +-
 arch/arm/mach-ixp23xx/ixdp2351.c                   |    4 +-
 arch/arm/mach-lh7a40x/common.h                     |    2 +-
 arch/arm/mach-netx/generic.c                       |    2 +-
 arch/arm/mach-ns9xxx/board-a9m9750dev.c            |    2 +-
 arch/arm/mach-ns9xxx/irq.c                         |    3 +-
 arch/arm/mach-omap1/fpga.c                         |    2 +-
 arch/arm/mach-orion5x/irq.c                        |   12 +-
 arch/arm/mach-pxa/gpio.c                           |    2 +-
 arch/arm/mach-pxa/lpd270.c                         |    2 +-
 arch/arm/mach-pxa/lubbock.c                        |    2 +-
 arch/arm/mach-pxa/mainstone.c                      |    2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c               |    2 +-
 arch/arm/mach-s3c2410/bast-irq.c                   |    6 +-
 arch/arm/mach-s3c2412/irq.c                        |    4 +-
 arch/arm/mach-s3c2440/irq.c                        |    4 +-
 arch/arm/mach-s3c2443/irq.c                        |    4 +-
 arch/arm/mach-sa1100/h3600.c                       |   14 +-
 arch/arm/mach-sa1100/irq.c                         |    2 +-
 arch/arm/mach-sa1100/neponset.c                    |    6 +-
 arch/arm/mach-versatile/core.c                     |    2 +-
 arch/arm/oprofile/op_model_mpcore.c                |    2 +-
 arch/arm/plat-mxc/gpio.c                           |    7 +-
 arch/arm/plat-omap/gpio.c                          |   12 +-
 arch/arm/plat-orion/irq.c                          |    2 +-
 arch/arm/plat-s3c24xx/irq.c                        |   14 +-
 arch/arm/plat-s3c24xx/s3c244x-irq.c                |    4 +-
 arch/avr32/kernel/irq.c                            |   12 +-
 arch/avr32/mach-at32ap/extint.c                    |    7 +-
 arch/avr32/mach-at32ap/intc.c                      |    2 +-
 arch/avr32/mach-at32ap/pio.c                       |    2 +-
 arch/blackfin/kernel/irqchip.c                     |   12 +-
 arch/blackfin/kernel/traps.c                       |    8 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c    |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-common/ints-priority.c          |    8 +-
 arch/cris/arch-v10/kernel/irq.c                    |    2 +-
 arch/cris/arch-v32/kernel/irq.c                    |    6 +-
 arch/cris/kernel/irq.c                             |   14 +-
 arch/frv/kernel/irq.c                              |   12 +-
 arch/h8300/kernel/irq.c                            |   26 +-
 arch/ia64/hp/sim/hpsim_irq.c                       |    2 +-
 arch/ia64/include/asm/hw_irq.h                     |    2 +-
 arch/ia64/kernel/iosapic.c                         |   27 +-
 arch/ia64/kernel/irq.c                             |   18 +-
 arch/ia64/kernel/irq_ia64.c                        |   14 +-
 arch/ia64/kernel/mca.c                             |    2 +-
 arch/ia64/kernel/msi_ia64.c                        |    6 +-
 arch/ia64/kernel/smpboot.c                         |    2 +-
 arch/ia64/sn/kernel/irq.c                          |   11 +-
 arch/ia64/sn/kernel/msi_sn.c                       |    6 +-
 arch/m32r/kernel/irq.c                             |   14 +-
 arch/m32r/platforms/m32104ut/setup.c               |   37 +-
 arch/m32r/platforms/m32700ut/setup.c               |  133 ++-
 arch/m32r/platforms/mappi/setup.c                  |   84 +-
 arch/m32r/platforms/mappi2/setup.c                 |  103 +-
 arch/m32r/platforms/mappi3/setup.c                 |  103 +-
 arch/m32r/platforms/oaks32r/setup.c                |   62 +-
 arch/m32r/platforms/opsput/setup.c                 |  149 ++-
 arch/m32r/platforms/usrv/setup.c                   |   92 +-
 arch/m68k/kernel/ints.c                            |    2 +
 arch/m68knommu/kernel/irq.c                        |   18 +-
 arch/mips/au1000/common/irq.c                      |    2 +-
 arch/mips/dec/ioasic-irq.c                         |    2 +-
 arch/mips/emma2rh/markeins/irq_markeins.c          |    2 +-
 arch/mips/kernel/irq-gic.c                         |    2 +-
 arch/mips/kernel/irq-msc01.c                       |    2 +-
 arch/mips/kernel/irq.c                             |   12 +-
 arch/mips/kernel/smtc.c                            |    2 +-
 arch/mips/mti-malta/malta-smtc.c                   |    2 +-
 arch/mips/sgi-ip22/ip22-int.c                      |    2 +-
 arch/mips/sgi-ip22/ip22-time.c                     |    2 +-
 arch/mips/sgi-ip32/ip32-irq.c                      |   10 +-
 arch/mips/sibyte/bcm1480/irq.c                     |    5 +-
 arch/mips/sibyte/bcm1480/smp.c                     |    2 +-
 arch/mips/sibyte/sb1250/irq.c                      |    5 +-
 arch/mips/sibyte/sb1250/smp.c                      |    2 +-
 arch/mips/sni/a20r.c                               |    2 +-
 arch/mips/sni/pcimt.c                              |    2 +-
 arch/mips/sni/pcit.c                               |    2 +-
 arch/mips/sni/rm200.c                              |    2 +-
 arch/mips/vr41xx/common/icu.c                      |   44 +-
 arch/mips/vr41xx/common/irq.c                      |    2 +-
 arch/mn10300/kernel/irq.c                          |   14 +-
 arch/parisc/kernel/irq.c                           |   45 +-
 arch/powerpc/include/asm/irq.h                     |    2 +-
 arch/powerpc/kernel/crash.c                        |    2 +-
 arch/powerpc/kernel/irq.c                          |   17 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c            |    2 +-
 arch/powerpc/platforms/cell/interrupt.c            |    2 +-
 arch/powerpc/platforms/powermac/pic.c              |    4 +-
 arch/powerpc/platforms/pseries/eeh_driver.c        |    2 +-
 arch/powerpc/platforms/pseries/xics.c              |    4 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |    5 +-
 arch/powerpc/sysdev/mpic.c                         |   16 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    2 +-
 arch/s390/kernel/irq.c                             |    2 +
 arch/sh/boards/mach-cayman/irq.c                   |    4 +-
 arch/sh/boards/mach-dreamcast/irq.c                |    2 +-
 arch/sh/boards/mach-dreamcast/setup.c              |    2 +-
 arch/sh/boards/mach-microdev/irq.c                 |    4 +-
 arch/sh/boards/mach-se/7206/irq.c                  |    2 +-
 arch/sh/boards/mach-se/7343/irq.c                  |    2 +-
 arch/sh/boards/mach-se/7722/irq.c                  |    2 +-
 arch/sh/boards/mach-systemh/irq.c                  |    4 +-
 arch/sh/cchips/hd6446x/hd64461.c                   |    4 +-
 arch/sh/cchips/hd6446x/hd64465/setup.c             |    4 +-
 arch/sh/kernel/cpu/irq/imask.c                     |    4 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c                  |    4 +-
 arch/sh/kernel/irq.c                               |   14 +-
 arch/sparc/kernel/irq.c                            |    3 +
 arch/sparc64/kernel/irq.c                          |   45 +-
 arch/sparc64/kernel/pci_msi.c                      |    2 +-
 arch/sparc64/kernel/time.c                         |    3 +-
 arch/um/kernel/irq.c                               |   33 +-
 arch/x86/Kconfig                                   |   18 +-
 arch/x86/boot/compressed/misc.c                    |    2 +-
 arch/x86/configs/i386_defconfig                    |    1 -
 arch/x86/{mach-es7000 => es7000}/Makefile          |    0
 arch/x86/{mach-es7000 => es7000}/es7000.h          |   18 +-
 arch/x86/{mach-es7000 => es7000}/es7000plat.c      |    2 +-
 arch/x86/kernel/Makefile                           |    2 +
 arch/x86/kernel/acpi/boot.c                        |   34 +-
 arch/x86/kernel/apic_32.c                          |  105 +-
 arch/x86/kernel/apic_64.c                          |  251 ++++-
 arch/x86/kernel/asm-offsets_64.c                   |    2 +-
 arch/x86/kernel/cpu/common_64.c                    |   40 +-
 arch/x86/kernel/cpu/feature_names.c                |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |    2 +-
 arch/x86/kernel/entry_32.S                         |    2 +-
 arch/x86/kernel/entry_64.S                         |    4 +-
 arch/x86/kernel/genapic_64.c                       |   88 +-
 arch/x86/kernel/genapic_flat_64.c                  |   62 +-
 arch/x86/kernel/genx2apic_cluster.c                |  164 +++
 arch/x86/kernel/genx2apic_phys.c                   |  159 +++
 arch/x86/kernel/genx2apic_uv_x.c                   |   70 +-
 arch/x86/kernel/hpet.c                             |    6 +-
 arch/x86/kernel/i8259.c                            |   24 +
 arch/x86/kernel/io_apic_32.c                       | 1346 +++++++++++---------
 arch/x86/kernel/io_apic_64.c                       | 1163 +++++++++++++++---
 arch/x86/kernel/ioport.c                           |    1 +
 arch/x86/kernel/ipi.c                              |    3 +-
 arch/x86/kernel/irq_32.c                           |   71 +-
 arch/x86/kernel/irq_64.c                           |   74 +-
 arch/x86/kernel/irqinit_32.c                       |   85 ++-
 arch/x86/kernel/irqinit_64.c                       |   28 +-
 arch/x86/kernel/ldt.c                              |    1 +
 arch/x86/kernel/mpparse.c                          |    2 +
 arch/x86/kernel/numaq_32.c                         |    7 +
 arch/x86/kernel/paravirt.c                         |    2 -
 arch/x86/kernel/process_32.c                       |    2 +
 arch/x86/kernel/process_64.c                       |    1 +
 arch/x86/kernel/ptrace.c                           |    2 +-
 arch/x86/kernel/quirks.c                           |    3 -
 arch/x86/kernel/setup.c                            |    8 +
 arch/x86/kernel/setup_percpu.c                     |   28 +-
 arch/x86/kernel/signal_32.c                        |    1 +
 arch/x86/kernel/signal_64.c                        |   12 +-
 arch/x86/kernel/smpboot.c                          |   42 +-
 arch/x86/kernel/summit_32.c                        |    2 +-
 arch/x86/kernel/sys_i386_32.c                      |    2 +
 arch/x86/kernel/sys_x86_64.c                       |    1 +
 arch/x86/kernel/syscall_64.c                       |    4 +-
 arch/x86/kernel/time_32.c                          |    1 +
 arch/x86/kernel/tls.c                              |    1 +
 arch/x86/kernel/traps_64.c                         |    9 +-
 arch/x86/kernel/visws_quirks.c                     |   32 +-
 arch/x86/kernel/vm86_32.c                          |    1 +
 arch/x86/kernel/vmi_32.c                           |    4 +-
 arch/x86/kernel/vmlinux_32.lds.S                   |    1 +
 arch/x86/kernel/vmlinux_64.lds.S                   |    3 +
 arch/x86/lguest/boot.c                             |   40 +-
 arch/x86/mach-default/setup.c                      |   19 +-
 arch/x86/mach-generic/Makefile                     |    2 +-
 arch/x86/mach-generic/bigsmp.c                     |   13 +-
 arch/x86/mach-generic/es7000.c                     |   27 +-
 arch/x86/mach-generic/numaq.c                      |   26 +-
 arch/x86/mach-generic/summit.c                     |   25 +-
 arch/x86/mach-voyager/voyager_smp.c                |    4 +-
 arch/x86/mm/fault.c                                |    3 +-
 arch/x86/mm/init_32.c                              |    4 +
 arch/x86/mm/ioremap.c                              |    4 +-
 arch/x86/pci/acpi.c                                |    5 -
 arch/x86/xen/enlighten.c                           |   45 +-
 arch/xtensa/kernel/irq.c                           |   14 +-
 drivers/char/hpet.c                                |  155 ++-
 drivers/char/random.c                              |   72 +-
 drivers/char/vr41xx_giu.c                          |    2 +-
 drivers/gpio/gpiolib.c                             |    2 +-
 drivers/mfd/asic3.c                                |    4 +-
 drivers/mfd/htc-egpio.c                            |    2 +-
 drivers/mfd/tc6393xb.c                             |    3 +-
 drivers/net/3c59x.c                                |    4 +-
 drivers/net/hamradio/baycom_ser_fdx.c              |    4 +-
 drivers/net/hamradio/scc.c                         |    6 +-
 drivers/net/wan/sbni.c                             |    2 +-
 drivers/parisc/dino.c                              |    9 +-
 drivers/parisc/eisa.c                              |    8 +-
 drivers/parisc/gsc.c                               |   15 +-
 drivers/parisc/iosapic.c                           |    4 +-
 drivers/parisc/superio.c                           |    8 +-
 drivers/pci/Makefile                               |    2 +
 drivers/pci/dma_remapping.h                        |  157 +++
 drivers/pci/dmar.c                                 |  397 ++++++-
 drivers/pci/htirq.c                                |   20 +-
 drivers/pci/intel-iommu.c                          |  164 +--
 drivers/pci/intel-iommu.h                          |  233 ++--
 drivers/pci/intr_remapping.c                       |  596 +++++++++
 drivers/pci/intr_remapping.h                       |    8 +
 drivers/pcmcia/at91_cf.c                           |    2 +-
 drivers/pcmcia/hd64465_ss.c                        |   12 +-
 drivers/pcmcia/vrc4171_card.c                      |    2 +-
 drivers/rtc/rtc-vr41xx.c                           |    4 +-
 drivers/scsi/aha152x.c                             |    2 +-
 drivers/serial/68328serial.c                       |   11 +-
 drivers/serial/8250.c                              |   69 +-
 drivers/serial/amba-pl010.c                        |    2 +-
 drivers/serial/amba-pl011.c                        |    2 +-
 drivers/serial/cpm_uart/cpm_uart_core.c            |    2 +-
 drivers/serial/m32r_sio.c                          |    4 +-
 drivers/serial/serial_core.c                       |    2 +-
 drivers/serial/serial_lh7a40x.c                    |    2 +-
 drivers/serial/sh-sci.c                            |    2 +-
 drivers/serial/ucc_uart.c                          |    2 +-
 drivers/xen/events.c                               |   20 +-
 fs/proc/proc_misc.c                                |   72 +-
 include/asm-generic/vmlinux.lds.h                  |   13 +
 include/asm-mips/irq.h                             |    2 +-
 include/asm-x86/a.out-core.h                       |    6 +-
 include/asm-x86/a.out.h                            |    6 +-
 include/asm-x86/acpi.h                             |    6 +-
 include/asm-x86/agp.h                              |    6 +-
 include/asm-x86/alternative.h                      |    6 +-
 include/asm-x86/amd_iommu.h                        |    6 +-
 include/asm-x86/amd_iommu_types.h                  |    6 +-
 include/asm-x86/apic.h                             |   76 +-
 include/asm-x86/apicdef.h                          |    9 +-
 include/asm-x86/arch_hooks.h                       |    8 +-
 include/asm-x86/asm.h                              |    6 +-
 include/asm-x86/atomic_32.h                        |    6 +-
 include/asm-x86/atomic_64.h                        |    6 +-
 include/asm-x86/auxvec.h                           |    6 +-
 .../{mach-bigsmp/mach_apic.h => bigsmp/apic.h}     |    4 +-
 .../mach_apicdef.h => bigsmp/apicdef.h}            |    6 +-
 .../{mach-bigsmp/mach_ipi.h => bigsmp/ipi.h}       |    0
 include/asm-x86/bios_ebda.h                        |    6 +-
 include/asm-x86/bitops.h                           |    6 +-
 include/asm-x86/boot.h                             |    6 +-
 include/asm-x86/bootparam.h                        |    6 +-
 include/asm-x86/bug.h                              |    6 +-
 include/asm-x86/bugs.h                             |    6 +-
 include/asm-x86/byteorder.h                        |    6 +-
 include/asm-x86/cache.h                            |    6 +-
 include/asm-x86/cacheflush.h                       |    6 +-
 include/asm-x86/calgary.h                          |    6 +-
 include/asm-x86/checksum_32.h                      |    6 +-
 include/asm-x86/checksum_64.h                      |    6 +-
 include/asm-x86/cmpxchg_32.h                       |    6 +-
 include/asm-x86/cmpxchg_64.h                       |    6 +-
 include/asm-x86/compat.h                           |    6 +-
 include/asm-x86/cpu.h                              |    6 +-
 include/asm-x86/cpufeature.h                       |    8 +-
 include/asm-x86/current.h                          |    6 +-
 include/asm-x86/debugreg.h                         |    6 +-
 include/asm-x86/delay.h                            |    6 +-
 include/asm-x86/desc.h                             |    6 +-
 include/asm-x86/desc_defs.h                        |    6 +-
 include/asm-x86/device.h                           |    6 +-
 include/asm-x86/div64.h                            |    6 +-
 include/asm-x86/dma-mapping.h                      |    6 +-
 include/asm-x86/dma.h                              |    6 +-
 include/asm-x86/dmi.h                              |    6 +-
 include/asm-x86/ds.h                               |    6 +-
 include/asm-x86/dwarf2.h                           |    6 +-
 include/asm-x86/e820.h                             |    7 +-
 include/asm-x86/edac.h                             |    6 +-
 include/asm-x86/efi.h                              |    6 +-
 include/asm-x86/elf.h                              |    6 +-
 include/asm-x86/emergency-restart.h                |    6 +-
 .../{mach-es7000/mach_apic.h => es7000/apic.h}     |   32 +-
 include/asm-x86/es7000/apicdef.h                   |   13 +
 .../{mach-es7000/mach_ipi.h => es7000/ipi.h}       |    6 +-
 .../mach_mpparse.h => es7000/mpparse.h}            |    4 +-
 .../mach_wakecpu.h => es7000/wakecpu.h}            |    6 +-
 include/asm-x86/fb.h                               |    6 +-
 include/asm-x86/fixmap.h                           |    6 +-
 include/asm-x86/fixmap_32.h                        |    6 +-
 include/asm-x86/fixmap_64.h                        |    6 +-
 include/asm-x86/floppy.h                           |    6 +-
 include/asm-x86/ftrace.h                           |    6 +-
 include/asm-x86/futex.h                            |    6 +-
 include/asm-x86/gart.h                             |    6 +-
 include/asm-x86/genapic_32.h                       |    8 +-
 include/asm-x86/genapic_64.h                       |   14 +-
 include/asm-x86/geode.h                            |    6 +-
 include/asm-x86/gpio.h                             |    2 +-
 include/asm-x86/hardirq_32.h                       |    6 +-
 include/asm-x86/hardirq_64.h                       |    6 +-
 include/asm-x86/highmem.h                          |    6 +-
 include/asm-x86/hpet.h                             |    6 +-
 include/asm-x86/hugetlb.h                          |    6 +-
 include/asm-x86/hw_irq.h                           |   35 +-
 include/asm-x86/hypertransport.h                   |    6 +-
 include/asm-x86/i387.h                             |    9 +-
 include/asm-x86/i8253.h                            |    6 +-
 include/asm-x86/i8259.h                            |    9 +-
 include/asm-x86/ia32.h                             |    6 +-
 include/asm-x86/ia32_unistd.h                      |    6 +-
 include/asm-x86/idle.h                             |    6 +-
 include/asm-x86/intel_arch_perfmon.h               |    6 +-
 include/asm-x86/io.h                               |    8 +-
 include/asm-x86/io_32.h                            |    6 +-
 include/asm-x86/io_64.h                            |    7 +-
 include/asm-x86/io_apic.h                          |   26 +-
 include/asm-x86/ioctls.h                           |    6 +-
 include/asm-x86/iommu.h                            |    6 +-
 include/asm-x86/ipcbuf.h                           |    6 +-
 include/asm-x86/ipi.h                              |   22 +-
 include/asm-x86/irq.h                              |    9 +-
 include/asm-x86/irq_regs_32.h                      |    6 +-
 include/asm-x86/irq_remapping.h                    |    8 +
 include/asm-x86/irq_vectors.h                      |   30 +-
 include/asm-x86/ist.h                              |    6 +-
 include/asm-x86/k8.h                               |    6 +-
 include/asm-x86/kdebug.h                           |    6 +-
 include/asm-x86/kexec.h                            |    6 +-
 include/asm-x86/kgdb.h                             |    6 +-
 include/asm-x86/kmap_types.h                       |    6 +-
 include/asm-x86/kprobes.h                          |    6 +-
 include/asm-x86/kvm.h                              |    6 +-
 include/asm-x86/kvm_host.h                         |    8 +-
 include/asm-x86/kvm_para.h                         |    6 +-
 include/asm-x86/kvm_x86_emulate.h                  |    6 +-
 include/asm-x86/ldt.h                              |    6 +-
 include/asm-x86/lguest.h                           |    6 +-
 include/asm-x86/lguest_hcall.h                     |    6 +-
 include/asm-x86/linkage.h                          |    6 +-
 include/asm-x86/local.h                            |    6 +-
 include/asm-x86/mach-default/apm.h                 |    6 +-
 include/asm-x86/mach-default/entry_arch.h          |    1 +
 include/asm-x86/mach-default/mach_apic.h           |   23 +-
 include/asm-x86/mach-default/mach_apicdef.h        |   12 +-
 include/asm-x86/mach-default/mach_ipi.h            |    6 +-
 include/asm-x86/mach-default/mach_mpparse.h        |    6 +-
 include/asm-x86/mach-default/mach_mpspec.h         |    6 +-
 include/asm-x86/mach-default/mach_timer.h          |    6 +-
 include/asm-x86/mach-default/mach_traps.h          |    6 +-
 include/asm-x86/mach-default/mach_wakecpu.h        |    6 +-
 include/asm-x86/mach-es7000/mach_apicdef.h         |   13 -
 include/asm-x86/mach-generic/gpio.h                |    6 +-
 include/asm-x86/mach-generic/irq_vectors_limits.h  |   14 -
 include/asm-x86/mach-generic/mach_apic.h           |    7 +-
 include/asm-x86/mach-generic/mach_apicdef.h        |    6 +-
 include/asm-x86/mach-generic/mach_ipi.h            |    6 +-
 include/asm-x86/mach-generic/mach_mpparse.h        |    6 +-
 include/asm-x86/mach-generic/mach_mpspec.h         |    6 +-
 include/asm-x86/mach-rdc321x/gpio.h                |    6 +-
 include/asm-x86/mach-summit/irq_vectors_limits.h   |   14 -
 include/asm-x86/mach-summit/mach_apicdef.h         |   13 -
 include/asm-x86/math_emu.h                         |    6 +-
 include/asm-x86/mc146818rtc.h                      |    6 +-
 include/asm-x86/mca.h                              |    6 +-
 include/asm-x86/mca_dma.h                          |    6 +-
 include/asm-x86/mce.h                              |    6 +-
 include/asm-x86/mman.h                             |    6 +-
 include/asm-x86/mmconfig.h                         |    6 +-
 include/asm-x86/mmu.h                              |    6 +-
 include/asm-x86/mmu_context.h                      |    6 +-
 include/asm-x86/mmu_context_32.h                   |    6 +-
 include/asm-x86/mmu_context_64.h                   |    6 +-
 include/asm-x86/mmx.h                              |    6 +-
 include/asm-x86/mmzone_32.h                        |    6 +-
 include/asm-x86/mmzone_64.h                        |    6 +-
 include/asm-x86/module.h                           |    6 +-
 include/asm-x86/mpspec.h                           |    7 +-
 include/asm-x86/mpspec_def.h                       |    6 +-
 include/asm-x86/msgbuf.h                           |    6 +-
 include/asm-x86/msidef.h                           |   10 +-
 include/asm-x86/msr-index.h                        |    6 +-
 include/asm-x86/msr.h                              |    6 +-
 include/asm-x86/mtrr.h                             |    6 +-
 include/asm-x86/mutex_32.h                         |    6 +-
 include/asm-x86/mutex_64.h                         |    6 +-
 include/asm-x86/nmi.h                              |    6 +-
 include/asm-x86/nops.h                             |    6 +-
 include/asm-x86/numa_32.h                          |    6 +-
 include/asm-x86/numa_64.h                          |    6 +-
 include/asm-x86/numaq.h                            |    6 +-
 .../{mach-numaq/mach_apic.h => numaq/apic.h}       |    6 +-
 .../{mach-numaq/mach_apicdef.h => numaq/apicdef.h} |    4 +-
 .../asm-x86/{mach-numaq/mach_ipi.h => numaq/ipi.h} |    6 +-
 .../{mach-numaq/mach_mpparse.h => numaq/mpparse.h} |    6 +-
 .../{mach-numaq/mach_wakecpu.h => numaq/wakecpu.h} |    6 +-
 include/asm-x86/olpc.h                             |    6 +-
 include/asm-x86/page.h                             |    6 +-
 include/asm-x86/page_32.h                          |    7 +-
 include/asm-x86/page_64.h                          |    7 +-
 include/asm-x86/param.h                            |    6 +-
 include/asm-x86/paravirt.h                         |   25 +-
 include/asm-x86/parport.h                          |    6 +-
 include/asm-x86/pat.h                              |    6 +-
 include/asm-x86/pci-direct.h                       |    6 +-
 include/asm-x86/pci.h                              |    6 +-
 include/asm-x86/pci_32.h                           |    6 +-
 include/asm-x86/pci_64.h                           |    6 +-
 include/asm-x86/pda.h                              |    6 +-
 include/asm-x86/percpu.h                           |    6 +-
 include/asm-x86/pgalloc.h                          |    6 +-
 include/asm-x86/pgtable-2level-defs.h              |    6 +-
 include/asm-x86/pgtable-2level.h                   |    6 +-
 include/asm-x86/pgtable-3level-defs.h              |    6 +-
 include/asm-x86/pgtable-3level.h                   |    6 +-
 include/asm-x86/pgtable.h                          |    8 +-
 include/asm-x86/pgtable_32.h                       |    7 +-
 include/asm-x86/pgtable_64.h                       |    6 +-
 include/asm-x86/posix_types_32.h                   |    6 +-
 include/asm-x86/posix_types_64.h                   |    6 +-
 include/asm-x86/prctl.h                            |    6 +-
 include/asm-x86/processor-flags.h                  |    6 +-
 include/asm-x86/processor.h                        |   10 +-
 include/asm-x86/proto.h                            |    6 +-
 include/asm-x86/ptrace-abi.h                       |    6 +-
 include/asm-x86/ptrace.h                           |    9 +-
 include/asm-x86/pvclock-abi.h                      |    6 +-
 include/asm-x86/pvclock.h                          |    6 +-
 include/asm-x86/reboot.h                           |    6 +-
 include/asm-x86/reboot_fixups.h                    |    6 +-
 include/asm-x86/required-features.h                |    6 +-
 include/asm-x86/resume-trace.h                     |    6 +-
 include/asm-x86/rio.h                              |    6 +-
 include/asm-x86/rwlock.h                           |    6 +-
 include/asm-x86/rwsem.h                            |    6 +-
 include/asm-x86/scatterlist.h                      |    6 +-
 include/asm-x86/seccomp_32.h                       |    6 +-
 include/asm-x86/seccomp_64.h                       |    6 +-
 include/asm-x86/segment.h                          |    6 +-
 include/asm-x86/sembuf.h                           |    6 +-
 include/asm-x86/serial.h                           |    6 +-
 include/asm-x86/setup.h                            |    8 +-
 include/asm-x86/shmbuf.h                           |    6 +-
 include/asm-x86/shmparam.h                         |    6 +-
 include/asm-x86/sigcontext.h                       |    6 +-
 include/asm-x86/sigcontext32.h                     |    6 +-
 include/asm-x86/siginfo.h                          |    6 +-
 include/asm-x86/signal.h                           |    9 +-
 include/asm-x86/smp.h                              |   27 +-
 include/asm-x86/socket.h                           |    6 +-
 include/asm-x86/sockios.h                          |    6 +-
 include/asm-x86/sparsemem.h                        |    6 +-
 include/asm-x86/spinlock.h                         |    6 +-
 include/asm-x86/spinlock_types.h                   |    6 +-
 include/asm-x86/srat.h                             |    6 +-
 include/asm-x86/stacktrace.h                       |    6 +-
 include/asm-x86/stat.h                             |    6 +-
 include/asm-x86/statfs.h                           |    6 +-
 include/asm-x86/string_32.h                        |    6 +-
 include/asm-x86/string_64.h                        |    6 +-
 .../{mach-summit/mach_apic.h => summit/apic.h}     |   24 +-
 include/asm-x86/summit/apicdef.h                   |   13 +
 .../{mach-summit/mach_ipi.h => summit/ipi.h}       |    6 +-
 .../mach_mpparse.h => summit/mpparse.h}            |   13 +-
 include/asm-x86/suspend_32.h                       |    6 +-
 include/asm-x86/suspend_64.h                       |    6 +-
 include/asm-x86/swiotlb.h                          |    6 +-
 include/asm-x86/sync_bitops.h                      |    6 +-
 include/asm-x86/syscalls.h                         |   93 ++
 include/asm-x86/system.h                           |    6 +-
 include/asm-x86/system_64.h                        |    6 +-
 include/asm-x86/tce.h                              |    6 +-
 include/asm-x86/termbits.h                         |    6 +-
 include/asm-x86/termios.h                          |    6 +-
 include/asm-x86/therm_throt.h                      |    6 +-
 include/asm-x86/thread_info.h                      |    6 +-
 include/asm-x86/time.h                             |    8 +-
 include/asm-x86/timer.h                            |   11 +-
 include/asm-x86/timex.h                            |    6 +-
 include/asm-x86/tlb.h                              |    6 +-
 include/asm-x86/tlbflush.h                         |    6 +-
 include/asm-x86/topology.h                         |    6 +-
 include/asm-x86/trampoline.h                       |    6 +-
 include/asm-x86/traps.h                            |   10 +-
 include/asm-x86/tsc.h                              |    6 +-
 include/asm-x86/types.h                            |    6 +-
 include/asm-x86/uaccess.h                          |    6 +-
 include/asm-x86/uaccess_32.h                       |    6 +-
 include/asm-x86/uaccess_64.h                       |    6 +-
 include/asm-x86/ucontext.h                         |    6 +-
 include/asm-x86/unaligned.h                        |    6 +-
 include/asm-x86/unistd_32.h                        |    6 +-
 include/asm-x86/unistd_64.h                        |    6 +-
 include/asm-x86/unwind.h                           |    6 +-
 include/asm-x86/user32.h                           |    6 +-
 include/asm-x86/user_32.h                          |    6 +-
 include/asm-x86/user_64.h                          |    6 +-
 include/asm-x86/uv/bios.h                          |    6 +-
 include/asm-x86/uv/uv_bau.h                        |    6 +-
 include/asm-x86/uv/uv_hub.h                        |    6 +-
 include/asm-x86/uv/uv_mmrs.h                       |    6 +-
 include/asm-x86/vdso.h                             |    6 +-
 include/asm-x86/vga.h                              |    6 +-
 include/asm-x86/vgtod.h                            |    6 +-
 include/asm-x86/visws/cobalt.h                     |    6 +-
 include/asm-x86/visws/lithium.h                    |    6 +-
 include/asm-x86/visws/piix4.h                      |    6 +-
 include/asm-x86/vm86.h                             |    6 +-
 include/asm-x86/vmi_time.h                         |    6 +-
 include/asm-x86/vsyscall.h                         |    6 +-
 include/asm-x86/xen/events.h                       |    6 +-
 include/asm-x86/xen/grant_table.h                  |    6 +-
 include/asm-x86/xen/hypercall.h                    |    6 +-
 include/asm-x86/xen/hypervisor.h                   |    6 +-
 include/asm-x86/xen/interface.h                    |    6 +-
 include/asm-x86/xen/interface_32.h                 |    6 +-
 include/asm-x86/xen/interface_64.h                 |    6 +-
 include/asm-x86/xen/page.h                         |    6 +-
 include/linux/dmar.h                               |  127 ++-
 include/linux/hpet.h                               |   14 +-
 include/linux/init.h                               |   44 +
 include/linux/interrupt.h                          |    7 +
 include/linux/irq.h                                |  121 ++-
 include/linux/kernel_stat.h                        |   20 +-
 init/main.c                                        |  129 ++-
 kernel/irq/autoprobe.c                             |   20 +-
 kernel/irq/chip.c                                  |  105 +-
 kernel/irq/handle.c                                |  297 ++++-
 kernel/irq/internals.h                             |    4 +-
 kernel/irq/manage.c                                |   82 +-
 kernel/irq/migration.c                             |   25 +-
 kernel/irq/proc.c                                  |   44 +-
 kernel/irq/resend.c                                |    6 +-
 kernel/irq/spurious.c                              |  147 ++-
 582 files changed, 7920 insertions(+), 3696 deletions(-)
 create mode 100644 Documentation/timers/00-INDEX
 rename Documentation/{ => timers}/hpet.txt (81%)
 rename arch/x86/{mach-es7000 => es7000}/Makefile (100%)
 rename arch/x86/{mach-es7000 => es7000}/es7000.h (89%)
 rename arch/x86/{mach-es7000 => es7000}/es7000plat.c (99%)
 create mode 100644 arch/x86/kernel/genx2apic_cluster.c
 create mode 100644 arch/x86/kernel/genx2apic_phys.c
 create mode 100644 drivers/pci/dma_remapping.h
 create mode 100644 drivers/pci/intr_remapping.c
 create mode 100644 drivers/pci/intr_remapping.h
 rename include/asm-x86/{mach-bigsmp/mach_apic.h => bigsmp/apic.h} (98%)
 rename include/asm-x86/{mach-bigsmp/mach_apicdef.h => bigsmp/apicdef.h} (74%)
 rename include/asm-x86/{mach-bigsmp/mach_ipi.h => bigsmp/ipi.h} (100%)
 rename include/asm-x86/{mach-es7000/mach_apic.h => es7000/apic.h} (92%)
 create mode 100644 include/asm-x86/es7000/apicdef.h
 rename include/asm-x86/{mach-es7000/mach_ipi.h => es7000/ipi.h} (83%)
 rename include/asm-x86/{mach-es7000/mach_mpparse.h => es7000/mpparse.h} (91%)
 rename include/asm-x86/{mach-es7000/mach_wakecpu.h => es7000/wakecpu.h} (95%)
 create mode 100644 include/asm-x86/irq_remapping.h
 delete mode 100644 include/asm-x86/mach-es7000/mach_apicdef.h
 delete mode 100644 include/asm-x86/mach-generic/irq_vectors_limits.h
 delete mode 100644 include/asm-x86/mach-summit/irq_vectors_limits.h
 delete mode 100644 include/asm-x86/mach-summit/mach_apicdef.h
 rename include/asm-x86/{mach-numaq/mach_apic.h => numaq/apic.h} (97%)
 rename include/asm-x86/{mach-numaq/mach_apicdef.h => numaq/apicdef.h} (75%)
 rename include/asm-x86/{mach-numaq/mach_ipi.h => numaq/ipi.h} (83%)
 rename include/asm-x86/{mach-numaq/mach_mpparse.h => numaq/mpparse.h} (50%)
 rename include/asm-x86/{mach-numaq/mach_wakecpu.h => numaq/wakecpu.h} (91%)
 rename include/asm-x86/{mach-summit/mach_apic.h => summit/apic.h} (94%)
 create mode 100644 include/asm-x86/summit/apicdef.h
 rename include/asm-x86/{mach-summit/mach_ipi.h => summit/ipi.h} (83%)
 rename include/asm-x86/{mach-summit/mach_mpparse.h => summit/mpparse.h} (96%)
 create mode 100644 include/asm-x86/syscalls.h

