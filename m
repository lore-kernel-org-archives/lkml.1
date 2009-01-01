Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZAABTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZAABTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 20:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZAABTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 20:19:25 -0500
Received: from ozlabs.org ([203.10.76.45]:36984 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZAABTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 20:19:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] cpumask tree
Date: Thu, 1 Jan 2009 11:49:18 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901011149.18401.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this is the bulk of the conversion to the new cpumask operators.
The x86-specific parts (the most aggressive large-NR_CPUS arch) are going
via Ingo's tree.

Goals:
1) Get cpumasks off the stack when CONFIG_CPUMASK_OFFSTACK.  This should
   be achieved for core & x86 by 2.6.29.  cpumask_var_t is struct cpumask[1]
   for CONFIG_CPUMASK_OFFSTACK=n (and alloc_cpumask_var et al. a noop).
2) Convert to new cpumask functions which only go to nr_cpu_ids for large
   NR_CPUS, so booting huge configured kernels on small machines doesn't suck.
3) Allocate smaller cpumasks when nr_cpu_ids < NR_CPUS, when
   CONFIG_CPUMASK_OFFSTACK=y.  This requires (2) to be completed.
4) Use cpumask_var_t for static cpumasks as well, or raw bitmaps if we
   really have to.  The former will aave space for nr_cpu_ids << NR_CPUS.
5) Ban on-stack cpumasks (to ensure (1) doesn't get reverted) and cpumask
   assignment (for (3)) by making struct cpumask undefined when
   CONFIG_CPUMASK_OFFSTACK=y.  This means (4) needs to be finished.

Between this and Ingo's tree, we achieve (1) and part of (2) and (4).
Completing the work is expected by 2.6.30.

Note that we can't stop people creating bitmaps of NR_CPUS on the stack
and using to_cpumask() on them.  But at least it should stand out.

Cheers,
Rusty.

The following changes since commit 6a94cb73064c952255336cc57731904174b2c58f:             
  Linus Torvalds (1):                                                                    
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs                            

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask.git master

Li Zefan (1):
      cpumask: fix bogus kernel-doc

Mike Travis (4):
      cpumask: Add alloc_cpumask_var_node()
      cpumask: documentation for cpumask_var_t
      cpumask: add sysfs displays for configured and disabled cpu maps
      sysfs: add documentation to cputopology.txt for system cpumasks 

Rusty Russell (64):
      cpumask: centralize cpu_online_map and cpu_possible_map
      cpumask: change cpumask_scnprintf, cpumask_parse_user, cpulist_parse, and cpulist_scnprintf to take pointers.                                                                                                           
      cpumask: make irq_set_affinity() take a const struct cpumask                                             
      cpumask: convert struct clock_event_device to cpumask pointers.                                          
      cpumask: Add CONFIG_CPUMASK_OFFSTACK                                                                     
      cpumask: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                          
      cpumask: Use all NR_CPUS bits unless CONFIG_CPUMASK_OFFSTACK                                             
      cpumask: x86: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                     
      cpumask: sparc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                   
      cpumask: sh: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                      
      cpumask: powerpc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                 
      cpumask: IA64: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                    
      cpumask: Mips: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                    
      cpumask: alpha: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask                   
      cpumask: cpu_coregroup_mask(): x86                                                                       
      cpumask: cpu_coregroup_mask(): sparc                                                                     
      cpumask: cpu_coregroup_mask(): s390                                                                      
      cpumask: Replace cpu_coregroup_map with cpu_coregroup_mask                                               
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6                                     
      cpumask: make CONFIG_NR_CPUS always valid.                                                               
      bitmap: test for constant as well as small size for inline versions                                      
      bitmap: fix seq_bitmap and seq_cpumask to take const pointer                                             
      cpumask: switch over to cpu_online/possible/active/present_mask: core                                    
      cpumask: make cpumask.h eat its own dogfood.                                                             
      cpumask: make set_cpu_*/init_cpu_* out-of-line                                                           
      cpumask: smp_call_function_many()                                                                        
      cpumask: arch_send_call_function_ipi_mask: core                                                          
      cpumask: use for_each_online_cpu() in drivers/infiniband/hw/ehca/ehca_irq.c                              
      cpumask: use new cpumask API in drivers/infiniband/hw/ehca                                               
      cpumask: use new cpumask API in drivers/infiniband/hw/ipath                                              
      cpumask: Use nr_cpu_ids in seq_cpumask                                                                   
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6                                     
      cpumask: Remove IA64 definition of total_cpus now it's in core code                                      
      percpu: fix percpu accessors to potentially !cpu_possible() cpus: pnpbios                                
      percpu: fix percpu accessors to potentially !cpu_possible() cpus: m32r                                   
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: core                           
      cpumask: Use accessors code in core                                                                      
      parisc: remove gratuitous cpu_online_map declaration.                                                    
      avr32: define __fls                                                                                      
      blackfin: define __fls                                                                                   
      m68k: define __fls                                                                                       
      m68knommu: define __fls                                                                                  
      bitmap: find_last_bit()                                                                                  
      cpumask: Use find_last_bit()                                                                             
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): sparc                              
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): s390                               
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): powerpc                            
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): ia64                               
      cpumask: convert kernel trace functions                                                                  
      cpumask: convert kernel trace functions further                                                          
      cpumask: remove any_online_cpu() users: kernel/                                                          
      cpumask: remove any_online_cpu() users: mm/                                                              
      cpumask: convert kernel/compat.c                                                                         
      cpumask: convert kernel/workqueue.c                                                                      
      cpumask: convert kernel time functions                                                                   
      cpumask: convert kernel/irq                                                                              
      cpumask: convert RCU implementations                                                                     
      cpumask: convert kernel/profile.c                                                                        
      cpumask: convert kernel/cpu.c                                                                            
      cpumask: convert rest of files in kernel/                                                                
      cpumask: convert mm/                                                                                     
      cpumask: replace for_each_cpu_mask_nr with for_each_cpu in kernel/time/                                  
      cpumask: zero extra bits in alloc_cpumask_var_node                                                       
      cpumask: CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS                                                       

 Documentation/cputopology.txt                |   48 ++++
 arch/alpha/include/asm/smp.h                 |    1 -   
 arch/alpha/include/asm/topology.h            |   17 ++  
 arch/alpha/kernel/irq.c                      |    5 +-  
 arch/alpha/kernel/process.c                  |    2 +   
 arch/alpha/kernel/setup.c                    |    5 +   
 arch/alpha/kernel/smp.c                      |    7 +-  
 arch/alpha/kernel/sys_dp264.c                |    8 +-  
 arch/alpha/kernel/sys_titan.c                |    4 +-  
 arch/arm/common/gic.c                        |    4 +-  
 arch/arm/kernel/irq.c                        |    2 +-  
 arch/arm/kernel/smp.c                        |   10 -   
 arch/arm/mach-at91/at91rm9200_time.c         |    3 +-  
 arch/arm/mach-at91/at91sam926x_time.c        |    2 +-  
 arch/arm/mach-davinci/time.c                 |    2 +-  
 arch/arm/mach-imx/time.c                     |    2 +-  
 arch/arm/mach-ixp4xx/common.c                |    2 +-  
 arch/arm/mach-msm/timer.c                    |    2 +-  
 arch/arm/mach-ns9xxx/time-ns9360.c           |    2 +-  
 arch/arm/mach-omap1/time.c                   |    2 +-  
 arch/arm/mach-omap1/timer32k.c               |    2 +-  
 arch/arm/mach-omap2/timer-gp.c               |    2 +-  
 arch/arm/mach-pxa/time.c                     |    2 +-  
 arch/arm/mach-realview/core.c                |    2 +-  
 arch/arm/mach-realview/localtimer.c          |    4 +-  
 arch/arm/mach-sa1100/time.c                  |    2 +-  
 arch/arm/mach-versatile/core.c               |    2 +-  
 arch/arm/oprofile/op_model_mpcore.c          |    4 +-  
 arch/arm/plat-mxc/time.c                     |    2 +-  
 arch/arm/plat-orion/time.c                   |    2 +-  
 arch/avr32/include/asm/bitops.h              |    5 +   
 arch/avr32/kernel/time.c                     |    2 +-  
 arch/blackfin/include/asm/bitops.h           |    1 +   
 arch/blackfin/kernel/time-ts.c               |    2 +-  
 arch/cris/arch-v32/kernel/irq.c              |    4 +-  
 arch/cris/arch-v32/kernel/smp.c              |    4 -   
 arch/cris/include/asm/smp.h                  |    1 -   
 arch/ia64/hp/sim/hpsim_irq.c                 |    2 +-  
 arch/ia64/include/asm/smp.h                  |    1 -   
 arch/ia64/include/asm/topology.h             |    9 +-  
 arch/ia64/kernel/acpi.c                      |    3 +-  
 arch/ia64/kernel/iosapic.c                   |   35 ++--
 arch/ia64/kernel/irq.c                       |    9 +-  
 arch/ia64/kernel/msi_ia64.c                  |   12 +-  
 arch/ia64/kernel/smpboot.c                   |   10 +-  
 arch/ia64/kernel/topology.c                  |    2 +-  
 arch/ia64/sn/kernel/irq.c                    |    6 +-  
 arch/ia64/sn/kernel/msi_sn.c                 |    7 +-  
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |   27 +-- 
 arch/m32r/Kconfig                            |    1 +   
 arch/m32r/kernel/smpboot.c                   |    8 +-  
 arch/m68knommu/include/asm/bitops.h          |    1 +   
 arch/m68knommu/platform/coldfire/pit.c       |    2 +-  
 arch/mips/include/asm/irq.h                  |    3 +-  
 arch/mips/include/asm/mach-ip27/topology.h   |    4 +-  
 arch/mips/include/asm/smp.h                  |    3 -   
 arch/mips/jazz/irq.c                         |    2 +-  
 arch/mips/kernel/cevt-bcm1480.c              |    4 +-  
 arch/mips/kernel/cevt-ds1287.c               |    2 +-  
 arch/mips/kernel/cevt-gt641xx.c              |    2 +-  
 arch/mips/kernel/cevt-r4k.c                  |    2 +-  
 arch/mips/kernel/cevt-sb1250.c               |    4 +-  
 arch/mips/kernel/cevt-smtc.c                 |    2 +-  
 arch/mips/kernel/cevt-txx9.c                 |    2 +-  
 arch/mips/kernel/i8253.c                     |    2 +-  
 arch/mips/kernel/irq-gic.c                   |    6 +-  
 arch/mips/kernel/smp-cmp.c                   |    6 +-  
 arch/mips/kernel/smp-mt.c                    |    2 +-  
 arch/mips/kernel/smp.c                       |    7 +-  
 arch/mips/kernel/smtc.c                      |    6 +-  
 arch/mips/mti-malta/malta-smtc.c             |    6 +-  
 arch/mips/nxp/pnx8550/common/time.c          |    1 +   
 arch/mips/pmc-sierra/yosemite/smp.c          |    6 +-  
 arch/mips/sgi-ip27/ip27-smp.c                |    2 +-  
 arch/mips/sgi-ip27/ip27-timer.c              |    2 +-  
 arch/mips/sibyte/bcm1480/irq.c               |    8 +-  
 arch/mips/sibyte/bcm1480/smp.c               |    8 +-  
 arch/mips/sibyte/sb1250/irq.c                |    8 +-  
 arch/mips/sibyte/sb1250/smp.c                |    8 +-  
 arch/mips/sni/time.c                         |    2 +-  
 arch/parisc/Kconfig                          |    1 +   
 arch/parisc/include/asm/smp.h                |    2 -   
 arch/parisc/kernel/irq.c                     |    6 +-  
 arch/parisc/kernel/smp.c                     |   15 --  
 arch/powerpc/include/asm/topology.h          |   12 +-  
 arch/powerpc/kernel/irq.c                    |    2 +-  
 arch/powerpc/kernel/smp.c                    |    4 -   
 arch/powerpc/kernel/time.c                   |    2 +-  
 arch/powerpc/platforms/cell/spu_priv1_mmio.c |    6 +-  
 arch/powerpc/platforms/cell/spufs/sched.c    |    4 +-  
 arch/powerpc/platforms/pseries/xics.c        |    4 +-  
 arch/powerpc/sysdev/mpic.c                   |    4 +-  
 arch/powerpc/sysdev/mpic.h                   |    2 +-  
 arch/s390/Kconfig                            |    1 +   
 arch/s390/include/asm/topology.h             |    2 +   
 arch/s390/kernel/smp.c                       |    6 -   
 arch/s390/kernel/time.c                      |    2 +-  
 arch/s390/kernel/topology.c                  |    5 +   
 arch/sh/include/asm/smp.h                    |    2 +-  
 arch/sh/include/asm/topology.h               |    1 +   
 arch/sh/kernel/smp.c                         |   10 +-  
 arch/sh/kernel/timers/timer-broadcast.c      |    2 +-  
 arch/sh/kernel/timers/timer-tmu.c            |    2 +-  
 arch/sparc/include/asm/smp_32.h              |    2 -   
 arch/sparc/include/asm/topology_64.h         |   13 +-  
 arch/sparc/kernel/irq_64.c                   |   11 +-  
 arch/sparc/kernel/of_device_64.c             |    4 +-  
 arch/sparc/kernel/pci_msi.c                  |    4 +-  
 arch/sparc/kernel/smp_32.c                   |    6 +-  
 arch/sparc/kernel/smp_64.c                   |    4 -   
 arch/sparc/kernel/sparc_ksyms_32.c           |    4 -   
 arch/sparc/kernel/time_64.c                  |    2 +-  
 arch/um/kernel/smp.c                         |    7 -   
 arch/um/kernel/time.c                        |    2 +-  
 arch/x86/include/asm/pci.h                   |   10 +-  
 arch/x86/include/asm/topology.h              |   36 ++- 
 arch/x86/kernel/apic.c                       |    8 +-  
 arch/x86/kernel/cpu/intel_cacheinfo.c        |    4 +-  
 arch/x86/kernel/hpet.c                       |    8 +-  
 arch/x86/kernel/i8253.c                      |    2 +-  
 arch/x86/kernel/io_apic.c                    |   78 ++++----
 arch/x86/kernel/irq_32.c                     |    2 +-      
 arch/x86/kernel/irq_64.c                     |    2 +-      
 arch/x86/kernel/mfgpt_32.c                   |    2 +-      
 arch/x86/kernel/setup_percpu.c               |   10 +-      
 arch/x86/kernel/smpboot.c                    |   17 +-      
 arch/x86/kernel/vmiclock_32.c                |    2 +-      
 arch/x86/lguest/boot.c                       |    2 +-      
 arch/x86/mach-voyager/voyager_smp.c          |    7 -       
 arch/x86/xen/time.c                          |    2 +-      
 block/blk.h                                  |    4 +-      
 drivers/base/cpu.c                           |   46 ++++-   
 drivers/base/node.c                          |    4 +-      
 drivers/base/topology.c                      |    4 +-      
 drivers/clocksource/tcb_clksrc.c             |    2 +-      
 drivers/infiniband/hw/ehca/ehca_irq.c        |   17 +-      
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    8 +-      
 drivers/parisc/iosapic.c                     |    7 +-      
 drivers/pci/pci-sysfs.c                      |    4 +-      
 drivers/pci/probe.c                          |    4 +-      
 drivers/pnp/pnpbios/bioscalls.c              |    2 +-      
 drivers/xen/events.c                         |    6 +-      
 fs/seq_file.c                                |    3 +-      
 include/asm-generic/topology.h               |   14 ++-     
 include/asm-m32r/smp.h                       |    2 -       
 include/asm-m68k/bitops.h                    |    5 +       
 include/linux/bitmap.h                       |   35 ++--    
 include/linux/bitops.h                       |   13 +-      
 include/linux/clockchips.h                   |    4 +-      
 include/linux/cpumask.h                      |  295 +++++++++++++-------------
 include/linux/interrupt.h                    |    6 +-                        
 include/linux/irq.h                          |    3 +-                        
 include/linux/rcuclassic.h                   |    4 +-                        
 include/linux/seq_file.h                     |    7 +-                        
 include/linux/smp.h                          |   18 +-                        
 include/linux/stop_machine.h                 |    6 +-                        
 include/linux/threads.h                      |   16 +-                        
 include/linux/tick.h                         |    4 +-                        
 init/Kconfig                                 |    9 +                         
 init/main.c                                  |   13 +-                        
 kernel/compat.c                              |   49 +++--                     
 kernel/cpu.c                                 |  145 +++++++++----             
 kernel/cpuset.c                              |    4 +-                        
 kernel/irq/chip.c                            |    2 +-                        
 kernel/irq/manage.c                          |   31 ++--                      
 kernel/irq/migration.c                       |   14 +-                        
 kernel/irq/proc.c                            |   59 ++++--                    
 kernel/kexec.c                               |    2 +-                        
 kernel/power/poweroff.c                      |    2 +-                        
 kernel/profile.c                             |   38 +++--                     
 kernel/rcuclassic.c                          |   32 ++--                      
 kernel/rcupreempt.c                          |   19 +-                        
 kernel/rcutorture.c                          |   27 ++-                       
 kernel/sched.c                               |   10 +-
 kernel/sched_stats.h                         |    2 +-
 kernel/smp.c                                 |  145 +++++--------
 kernel/softirq.c                             |    2 +-
 kernel/softlockup.c                          |   10 +-
 kernel/stop_machine.c                        |    8 +-
 kernel/taskstats.c                           |   41 +++--
 kernel/time/clockevents.c                    |    2 +
 kernel/time/clocksource.c                    |    9 +-
 kernel/time/tick-broadcast.c                 |  113 +++++-----
 kernel/time/tick-common.c                    |   18 +-
 kernel/trace/ring_buffer.c                   |   42 +++--
 kernel/trace/trace.c                         |   68 ++++---
 kernel/trace/trace.h                         |    2 +-
 kernel/trace/trace_boot.c                    |    2 +-
 kernel/trace/trace_functions_graph.c         |    2 +-
 kernel/trace/trace_hw_branches.c             |    6 +-
 kernel/trace/trace_power.c                   |    2 +-
 kernel/trace/trace_sysprof.c                 |   13 +-
 kernel/workqueue.c                           |   26 ++-
 lib/Kconfig                                  |   15 ++
 lib/Makefile                                 |    1 +
 lib/cpumask.c                                |   62 +++++-
 lib/find_last_bit.c                          |   45 ++++
 mm/pdflush.c                                 |   16 ++-
 mm/slab.c                                    |    2 +-
 mm/slub.c                                    |   20 +-
 mm/vmscan.c                                  |    4 +-
 mm/vmstat.c                                  |    4 +-
 security/selinux/selinuxfs.c                 |    2 +-
 203 files changed, 1393 insertions(+), 1056 deletions(-)
 create mode 100644 lib/find_last_bit.c

commit 98a79d6a50181ca1ecf7400eda01d5dc1bc0dbf0
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:19:41 2008 +1030

    cpumask: centralize cpu_online_map and cpu_possible_map
    
    Impact: cleanup
    
    Each SMP arch defines these themselves.  Move them to a central
    location.
    
    Twists:
    1) Some archs (m32, parisc, s390) set possible_map to all 1, so we add a
       CONFIG_INIT_ALL_POSSIBLE for this rather than break them.
    
    2) mips and sparc32 '#define cpu_possible_map phys_cpu_present_map'.
       Those archs simply have phys_cpu_present_map replaced everywhere.
    
    3) Alpha defined cpu_possible_map to cpu_present_map; this is tricky
       so I just manipulate them both in sync.
    
    4) IA64, cris and m32r have gratuitous 'extern cpumask_t cpu_possible_map'
       declarations.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
    Tested-by: Tony Luck <tony.luck@intel.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Cc: Mike Travis <travis@sgi.com>
    Cc: ink@jurassic.park.msu.ru
    Cc: rmk@arm.linux.org.uk
    Cc: starvik@axis.com
    Cc: tony.luck@intel.com
    Cc: takata@linux-m32r.org
    Cc: ralf@linux-mips.org
    Cc: grundler@parisc-linux.org
    Cc: paulus@samba.org
    Cc: schwidefsky@de.ibm.com
    Cc: lethal@linux-sh.org
    Cc: wli@holomorphy.com
    Cc: davem@davemloft.net
    Cc: jdike@addtoit.com
    Cc: mingo@redhat.com

commit 29c0177e6a4ac094302bed54a1d4bbb6b740a9ef
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:20:25 2008 +1030

    cpumask: change cpumask_scnprintf, cpumask_parse_user, cpulist_parse, and cpulist_scnprintf to take pointers.
    
    Impact: change calling convention of existing cpumask APIs
    
    Most cpumask functions started with cpus_: these have been replaced by
    cpumask_ ones which take struct cpumask pointers as expected.
    
    These four functions don't have good replacement names; fortunately
    they're rarely used, so we just change them over.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Cc: paulus@samba.org
    Cc: mingo@redhat.com
    Cc: tony.luck@intel.com
    Cc: ralf@linux-mips.org
    Cc: Greg Kroah-Hartman <gregkh@suse.de>
    Cc: cl@linux-foundation.org
    Cc: srostedt@redhat.com

commit 0de26520c7cabf36e1de090ea8092f011a6106ce
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:20:26 2008 +1030

    cpumask: make irq_set_affinity() take a const struct cpumask
    
    Impact: change existing irq_chip API
    
    Not much point with gentle transition here: the struct irq_chip's
    setaffinity method signature needs to change.
    
    Fortunately, not widely used code, but hits a few architectures.
    
    Note: In irq_select_affinity() I save a temporary in by mangling
    irq_desc[irq].affinity directly.  Ingo, does this break anything?
    
    (Folded in fix from KOSAKI Motohiro)
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
    Acked-by: Ingo Molnar <mingo@redhat.com>
    Cc: ralf@linux-mips.org
    Cc: grundler@parisc-linux.org
    Cc: jeremy@xensource.com
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 320ab2b0b1e08e3805a3e1084a2f0eb1938d5d67
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:20:26 2008 +1030

    cpumask: convert struct clock_event_device to cpumask pointers.
    
    Impact: change calling convention of existing clock_event APIs
    
    struct clock_event_timer's cpumask field gets changed to take pointer,
    as does the ->broadcast function.
    
    Another single-patch change.  For safety, we BUG_ON() in
    clockevents_register_device() if it's not set.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Ingo Molnar <mingo@elte.hu>

commit aab46da0520af9c99b7802cebe4f14a81ff39415
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:20:27 2008 +1030

    cpumask: Add CONFIG_CPUMASK_OFFSTACK
    
    Impact: Add config option to enable code in cpumask.h
    
    Currently it can be set if DEBUG_PER_CPU_MAPS, or set specifically by
    an arch.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit f0b848ce6fe9062d504d997e9e97fe0f87d57217
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:20:27 2008 +1030

    cpumask: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    This defines them in the generic non-NUMA case.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Cc: Richard Henderson <rth@twiddle.net>

commit 7be7585393d311866653564fbcd10a3232773c0b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:20:28 2008 +1030

    cpumask: Use all NR_CPUS bits unless CONFIG_CPUMASK_OFFSTACK
    
    Impact: futureproof as we convert more code to new APIs
    
    The old cpumask operators treat all NR_CPUS bits as relevent, the new
    ones use nr_cpumask_bits.  For large NR_CPUS and small nr_cpu_ids, this
    makes a difference.
    
    However, mixing the two can cause problems with undefined bits.  An
    arch which sets CONFIG_CPUMASK_OFFSTACK should have converted across
    to the new operators, so it's safe in that case.
    
    (Thanks to Stephen Rothwell for bisecting the initial unused-bits bug,
    and Mike Travis for this solution).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Mike Travis <travis@sgi.com>

commit 7b4967c532045a1983d6d4af5c69cc7c5109f62b
Author: Mike Travis <travis@sgi.com>
Date:   Fri Dec 19 16:56:37 2008 +1030

    cpumask: Add alloc_cpumask_var_node()
    
    Impact: New API
    
    This will be needed in x86 code to allocate the domain and old_domain
    cpumasks on the same node as where the containing irq_cfg struct is
    allocated.
    
    (Also fixes double-dump_stack on rare CONFIG_DEBUG_PER_CPU_MAPS case)
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (re-impl alloc_cpumask_var)

commit ec26b805879c7e77865b39ee91b737985e80006d
Author: Mike Travis <travis@sgi.com>
Date:   Fri Dec 19 16:56:52 2008 +1030

    cpumask: documentation for cpumask_var_t
    
    Impact: New kerneldoc comments
    
    Additional documentation added to all the alloc_cpumask and free_cpumask
    functions.
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (minor additions)

commit e057d7aea9d8f2a46cd440d8bfb72245d4e72d79
Author: Mike Travis <travis@sgi.com>
Date:   Mon Dec 15 20:26:48 2008 -0800

    cpumask: add sysfs displays for configured and disabled cpu maps
    
    Impact: add new sysfs files.
    
    Add sysfs files "kernel_max" and "offline" to display the max CPU index
    allowed (NR_CPUS-1), and the map of cpus that are offline.
    
    Cpus can be offlined via HOTPLUG, disabled by the BIOS ACPI tables, or
    if they exceed the number of cpus allowed by the NR_CPUS config option,
    or the "maxcpus=NUM" kernel start parameter.
    
    The "possible_cpus=NUM" parameter can also extend the number of possible
    cpus allowed, in which case the cpus not present at startup will be
    in the offline state.  (These cpus can be HOTPLUGGED ON after system
    startup [pending a follow-on patch to provide the capability via the
    /sys/devices/sys/cpu/cpuN/online mechanism to bring them online.])
    
    By design, the "offlined cpus > possible cpus" display will always
    use the following formats:
    
      * all possible cpus online:   "x$"    or "x-y$"
      * some possible cpus offline: ".*,x$" or ".*,x-y$"
    
    where:
      x == number of possible cpus (nr_cpu_ids); and
      y == number of cpus >= NR_CPUS or maxcpus (if y > x).
    
    One use of this feature is for distros to select (or configure) the
    appropriate kernel to install for the resident system.
    
    Notes:
      * cpus offlined <= possible cpus will be printed for all architectures.
      * cpus offlined >  possible cpus will only be printed for arches that
      	set 'total_cpus' [X86 only in this patch].
    
    Based on tip/cpus4096 + .../rusty/linux-2.6-for-ingo.git/master +
    	 x86-only-patches sent 12/15.
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit d62720ade82c5e5b8f9585e5ed02c89573ebf111
Author: Mike Travis <travis@sgi.com>
Date:   Wed Dec 17 14:14:30 2008 -0800

    sysfs: add documentation to cputopology.txt for system cpumasks
    
    Add information to cputopology.txt explaining the output of various
    system cpumask's.
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

commit 393d68fb9929817cde7ab31c82d66fcb28ad35fc
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:38 2008 +1030

    cpumask: x86: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    Also makes __pcibus_to_node take a const pointer.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Ingo Molnar <mingo@elte.hu>

commit 96d76a74870d5f11ce2abdd09a8dcdc401d714d1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:38 2008 +1030

    cpumask: sparc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: David S. Miller <davem@davemloft.net>

commit 7479a2939df4957ba794cce814379b6d10914bdc
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:39 2008 +1030

    cpumask: sh: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Paul Mundt <lethal@linux-sh.org>

commit 86c6f274f52c3e991d429869780945c0790e7b65
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:39 2008 +1030

    cpumask: powerpc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    (Also replaces powerpc internal uses of node_to_cpumask).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit fbb776c3ca4501d5a2821bf1e9bceefcaec7ae47
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:40 2008 +1030

    cpumask: IA64: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    We can also use the new for_each_cpu_and() to avoid a temporary cpumask,
    and a gratuitous test in sn_topology_show.
    
    (Includes fix from KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>)
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit b4a2f916a8326065816a0743dd1b0ca2ffd18f5f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:40 2008 +1030

    cpumask: Mips: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Ralf Baechle <ralf@linux-mips.org>

commit 2258a5bb1064351b552aceaff29393967d694fa3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:41 2008 +1030

    cpumask: alpha: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
    
    Impact: New APIs
    
    The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
    return a pointer to a struct cpumask.  Part of removing cpumasks from
    the stack.
    
    I'm not sure the existing code even compiles, but new version is
    straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Richard Henderson <rth@twiddle.net>

commit 030bb203e01db12e3f2866799f4f03a114d06349
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:41 2008 +1030

    cpumask: cpu_coregroup_mask(): x86
    
    Impact: New API
    
    Like cpu_coregroup_map, but returns a (const) pointer.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Cc: Ingo Molnar <mingo@redhat.com>

commit a0ae09b46a516f05ea76e3419ad43c46f52c1165
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:42 2008 +1030

    cpumask: cpu_coregroup_mask(): sparc
    
    Like cpu_coregroup_map, but returns a (const) pointer.
    
    Compile-tested on sparc64 (defconfig).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 9be3eec2c83848a1ca57ebad13c63c95d0df01e2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:42 2008 +1030

    cpumask: cpu_coregroup_mask(): s390
    
    Like cpu_coregroup_map, but returns a (const) pointer.
    
    Compile-tested on s390 (defconfig).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit be4d638c1597580ed2294d899d9f1a2cd10e462c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 26 22:23:43 2008 +1030

    cpumask: Replace cpu_coregroup_map with cpu_coregroup_mask
    
    cpu_coregroup_map returned a cpumask_t: it's going away.
    
    (Note, the sched part of this patch won't apply meaningfully to the
    sched tree, but I'm posting it to show the goal).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Ingo Molnar <mingo@redhat.com>

commit 33edcf133ba93ecba2e4b6472e97b689895d805c
Merge: be4d638... 3c92ec8...
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 08:02:35 2008 +1030

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

commit 278d1ed65e25d80af7c3a112d707b3f70516ddb4
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:12 2008 +1030

    cpumask: make CONFIG_NR_CPUS always valid.
    
    Impact: cleanup
    
    Currently we have NR_CPUS, which is 1 on UP, and CONFIG_NR_CPUS on
    SMP.  If we make CONFIG_NR_CPUS always valid (and always 1 on !SMP),
    we can skip the middleman.
    
    This also allows us to find and check all the unaudited NR_CPUS usage
    as we prepare for v. large NR_CPUS.
    
    To avoid breaking every arch, we cheat and do this for the moment
    in the header if the arch doesn't.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 4b0bc0bca83f3fb7cf920e2ec80684c15d2269c0
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:13 2008 +1030

    bitmap: test for constant as well as small size for inline versions
    
    Impact: reduce text size
    
    bitmap_zero et al have a fastpath for nbits <= BITS_PER_LONG, but this
    should really only apply where the nbits is known at compile time.
    
    This only saves about 1200 bytes on an allyesconfig kernel, but with
    cpumasks going variable that number will increase.
    
       text		data	bss	dec		hex	filename
    35327852        5035607 6782976 47146435        2cf65c3 vmlinux-before
    35326640        5035607 6782976 47145223        2cf6107 vmlinux-after
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit cb78a0ce69fad2026825f957e24e2d9cda1ec9f1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:14 2008 +1030

    bitmap: fix seq_bitmap and seq_cpumask to take const pointer
    
    Impact: cleanup
    
    seq_bitmap just calls bitmap_scnprintf on the bits: that arg can be const.
    Similarly, seq_cpumask just calls seq_bitmap.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit b3199c025d1646e25e7d1d640dd605db251dccf8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:14 2008 +1030

    cpumask: switch over to cpu_online/possible/active/present_mask: core
    
    Impact: cleanup
    
    This implements the obsolescent cpu_online_map in terms of
    cpu_online_mask, rather than the other way around.  Same for the other
    maps.
    
    The documentation comments are also updated to refer to _mask rather
    than _map.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit ae7a47e72e1a0b5e2b46d1596bc2c22942a73023
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:15 2008 +1030

    cpumask: make cpumask.h eat its own dogfood.
    
    Changes:
    1) cpumask_t to struct cpumask,
    2) cpus_weight_nr to cpumask_weight,
    3) cpu_isset to cpumask_test_cpu,
    4) ->bits to cpumask_bits()
    5) cpu_*_map to cpu_*_mask.
    6) for_each_cpu_mask_nr to for_each_cpu
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 3fa41520696fec2815e2d88fbcccdda77ba4d693
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:16 2008 +1030

    cpumask: make set_cpu_*/init_cpu_* out-of-line
    
    They're only for use in boot/cpu hotplug code anyway, and this avoids
    the use of deprecated cpu_*_map.
    
    Stephen Rothwell points out that gcc 4.2.4 (on powerpc at least)
    didn't like the cast away of const anyway:
    
      include/linux/cpumask.h: In function 'set_cpu_possible':
      include/linux/cpumask.h:1052: warning: passing argument 2 of 'cpumask_set_cpu' discards qualifiers from pointer target type
    
    So this kills two birds with one stone.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 54b11e6d57a10aa9d0009efd93873e17bffd5d30
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:16 2008 +1030

    cpumask: smp_call_function_many()
    
    Impact: Implementation change to remove cpumask_t from stack.
    
    Actually change smp_call_function_mask() to smp_call_function_many().
    We avoid cpumasks on the stack in this version.
    
    (S390 has its own version, but that's going away apparently).
    
    We have to do some dancing to figure out if 0 or 1 other cpus are in
    the mask supplied and the online mask without allocating a tmp
    cpumask.  It's still fairly cheap.
    
    We allocate the cpumask at the end of the call_function_data
    structure: if allocation fails we fallback to smp_call_function_single
    rather than using the baroque quiescing code (which needs a cpumask on
    stack).
    
    (Thanks to Hiroshi Shimamoto for spotting several bugs in previous versions!)
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
    Cc: npiggin@suse.de
    Cc: axboe@kernel.dk

commit ce47d974f71af26d00832e83a43ac79bec272d99
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:17 2008 +1030

    cpumask: arch_send_call_function_ipi_mask: core
    
    Impact: new API to reduce stack usage
    
    We're weaning the core code off handing cpumask's around on-stack.
    This introduces arch_send_call_function_ipi_mask().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 259c4ddd00237e5072921afa15a900839643fd98
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:17 2008 +1030

    cpumask: use for_each_online_cpu() in drivers/infiniband/hw/ehca/ehca_irq.c
    
    Impact: cleanup
    
    In future, accessing cpu numbers beyond nr_cpu_ids (the runtime limit)
    will be undefined.  We can avoid future problems by using
    for_each_online_cpu() here.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
    Tested-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
    Cc: Christoph Raisch <raisch@de.ibm.com>

commit b29179c3d32021d79c11ece7199a1da41d31b1b7
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:18 2008 +1030

    cpumask: use new cpumask API in drivers/infiniband/hw/ehca
    
    Impact: cleanup
    
    We're moving from handing around cpumask_t's to handing around struct
    cpumask *'s.  cpus_*, cpumask_t and cpu_*_map are deprecated: convert
    to cpumask_*, cpu_*_mask.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
    Tested-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
    Cc: Christoph Raisch <raisch@de.ibm.com>

commit cbe31f02f5b5536f17dd978118e25052af528071
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:18 2008 +1030

    cpumask: use new cpumask API in drivers/infiniband/hw/ipath
    
    Impact: cleanup
    
    We're moving from handing around cpumask_t's to handing around struct
    cpumask *'s.  cpus_*, cpumask_t and cpu_*_map are deprecated: convert
    to cpumask_*, cpu_*_mask.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Ralph Campbell <infinipath@qlogic.com>

commit e12f0102ac81d660c9f801d0a0e10ccf4537a9de
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 30 09:05:19 2008 +1030

    cpumask: Use nr_cpu_ids in seq_cpumask
    
    Impact: cleanup, futureproof
    
    nr_cpu_ids is the (badly named) runtime limit on possible CPU numbers;
    ie. the variable version of NR_CPUS.
    
    With the new cpumask operators, only bits less than this are defined.
    So we should use it everywhere, rather than NR_CPUS.  Eventually this
    will make it possible to allocate cpumasks of the minimal length at runtime.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

commit 2ca1a615835d9f4990f42102ab1f2ef434e7e89c
Merge: e12f010... 6a94cb7...
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Dec 31 23:05:57 2008 +1030

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
    
    Conflicts:
    
    	arch/x86/kernel/io_apic.c

commit f320786063a9d1f885d2cf34ab44aa69c1d88f43
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:13 2009 +1030

    cpumask: Remove IA64 definition of total_cpus now it's in core code
    
    Impact: fix IA64 compile
    
    Fortunately, they have exactly the same semantics.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit e9690a6e4b1615cb0102e425e04b7ce29e7858e2
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Wed Dec 31 16:45:50 2008 +0800

    cpumask: fix bogus kernel-doc
    
    Impact: fix kernel-doc
    
    alloc_bootmem_cpumask_var() returns avoid.
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 6aaa8ce523c7ce954b81b8c0b3e32c8be599af8d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:14 2009 +1030

    percpu: fix percpu accessors to potentially !cpu_possible() cpus: pnpbios
    
    Impact: CPU iterator bugfixes
    
    Percpu areas are only allocated for possible cpus.  In general, you
    shouldn't access random cpu's percpu areas.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Cc: Adam Belay <ambx1@neo.rr.com>

commit 9e2f913df70b378379a358a44e7d286f7b765e8e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:14 2009 +1030

    percpu: fix percpu accessors to potentially !cpu_possible() cpus: m32r
    
    Impact: CPU iterator bugfixes
    
    Percpu areas are only allocated for possible cpus.  In general, you
    shouldn't access random cpu's percpu areas.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: Hirokazu Takata <takata@linux-m32r.org>

commit 4f4b6c1a94a8735bbdc030a2911cf395495645b6
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:15 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: core
    
    Impact: cleanup
    
    In future, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in iterators
    and other comparisons.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: James Morris <jmorris@namei.org>
    Cc: Eric Biederman <ebiederm@xmission.com>

commit 915441b601e6662e79f6c958e7be307967a96977
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:15 2009 +1030

    cpumask: Use accessors code in core
    
    Impact: use new API
    
    cpu_*_map are going away in favour of cpu_*_mask, but const pointers.
    So we have accessors where we really do want to frob them.  Archs
    will also need the (trivial) conversion before we can finally remove
    cpu_*_map.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 165ac433fa3f01ba99b29972f3adc283d03b0f17
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:16 2009 +1030

    parisc: remove gratuitous cpu_online_map declaration.
    
    This is defined in linux/cpumask.h (included in this file already),
    and this is now defined differently.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: linux-parisc@vger.kernel.org

commit 96b8d4c19d797200b973caab57ca842531184c13
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:16 2009 +1030

    avr32: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    (I broke this arch in linux-next by using __fls in generic code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit ccec25ff69d5f48c7a088c16fe2dc7e11d9e87fe
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:17 2009 +1030

    blackfin: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    (I broke this arch in linux-next by using __fls in generic code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Mike Frysinger <vapier@gentoo.org>

commit 434ae514c23047db87a8bbf39cebc9e1767aea44
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:18 2009 +1030

    m68k: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    (I broke this arch in linux-next by using __fls in generic code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 0db5d3d2f58804edb394e8008c7d9744110338a2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:18 2009 +1030

    m68knommu: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    (I broke this arch in linux-next by using __fls in generic code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit ab53d472e785e51fdfc08fc1d66252c1153e6c0f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:19 2009 +1030

    bitmap: find_last_bit()
    
    Impact: New API
    
    As the name suggests.  For the moment everyone uses the generic one.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit e0c0ba736547e81c4f986ce192307c549d214167
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:19 2009 +1030

    cpumask: Use find_last_bit()
    
    Impact: cleanup
    
    There's one obvious place to use it: to find the highest possible cpu.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 78fd744f827586615da5b387fa9f0af1888601b6
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:20 2009 +1030

    cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): sparc
    
    Impact: New API
    
    The old topology_core_siblings() and topology_thread_siblings() return
    a cpumask_t; these new ones return a (const) struct cpumask *.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 2bb23a63f22f0e2d91fee93ff5ca9c29e180b146
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:20 2009 +1030

    cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): s390
    
    Impact: New API
    
    The old topology_core_siblings() and topology_thread_siblings() return
    a cpumask_t; these new ones return a (const) struct cpumask *.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 9150641dd17fe9e213ab3391c8ebfc228daa2d9d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:21 2009 +1030

    cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): powerpc
    
    Impact: New API
    
    The old topology_core_siblings() and topology_thread_siblings() return
    a cpumask_t; these new ones return a (const) struct cpumask *.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 333af15341b2f6cd813c054e1b441d7b6d8e9318
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:21 2009 +1030

    cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): ia64
    
    Impact: New API
    
    The old topology_core_siblings() and topology_thread_siblings() return
    a cpumask_t; these new ones return a (const) struct cpumask *.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 9e01c1b74c9531e301c900edaa92a99fcb7738f2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:22 2009 +1030

    cpumask: convert kernel trace functions
    
    Impact: Reduce future memory usage, use new cpumask API.
    
    (Eventually, cpumask_var_t will be allocated based on nr_cpu_ids, not NR_CPUS).
    
    Convert kernel trace functions to use struct cpumask API:
    1) Use cpumask_copy/cpumask_test_cpu/for_each_cpu.
    2) Use cpumask_var_t and alloc_cpumask_var/free_cpumask_var everywhere.
    3) Use on_each_cpu instead of playing with current->cpus_allowed.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Steven Rostedt <rostedt@goodmis.org>

commit 4462344ee9ea9224d026801b877887f2f39774a3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:23 2009 +1030

    cpumask: convert kernel trace functions further
    
    Impact: Reduce future memory usage, use new cpumask API.
    
    Since the last patch was created and acked, more old cpumask users
    slipped into kernel/trace.
    
    Mostly trivial conversions, except struct trace_iterator's "started"
    member becomes a cpumask_var_t.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit f1fc057c79cb2d27602fb3ad08a031f13459ef27
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:23 2009 +1030

    cpumask: remove any_online_cpu() users: kernel/
    
    Impact: Remove obsolete API usage
    
    any_online_cpu() is a good name, but it takes a cpumask_t, not a
    pointer.
    
    There are several places where any_online_cpu() doesn't really want a
    mask arg at all.  Replace all callers with cpumask_any() and
    cpumask_any_and().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit 3e597945384dee1457240158eb81e3afb90b68c2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:24 2009 +1030

    cpumask: remove any_online_cpu() users: mm/
    
    Impact: Remove obsolete API usage
    
    any_online_cpu() is a good name, but it takes a cpumask_t, not a
    pointer.
    
    There are several places where any_online_cpu() doesn't really want a
    mask arg at all.  Replace all callers with cpumask_any() and
    cpumask_any_and().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit a45185d2d7108b01b90b9e0293377be4d6346dde
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:24 2009 +1030

    cpumask: convert kernel/compat.c
    
    Impact: Reduce stack usage, use new cpumask API.
    
    Straightforward conversion; cpumasks' size is given by cpumask_size() (now
    a variable rather than fixed) and on-stack cpu masks use cpumask_var_t.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit e7577c50f2fb2d1c167e2c04a4b4c2cc042acb82
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:25 2009 +1030

    cpumask: convert kernel/workqueue.c
    
    Impact: Reduce memory usage, use new cpumask API.
    
    cpu_populated_map becomes a cpumask_var_t, and cpu_singlethread_map is
    simply a cpumask pointer: it's simply the cpumask containing the first
    possible CPU anyway.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 6b954823c24f04ed026a8517f6bab5abda279db8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:25 2009 +1030

    cpumask: convert kernel time functions
    
    Impact: Use new APIs
    
    Convert kernel/time functions to use struct cpumask *.
    
    Note the ugly bitmap declarations in tick-broadcast.c.  These should
    be cpumask_var_t, but there was no obvious initialization function to
    put the alloc_cpumask_var() calls in.  This was safe.
    
    (Eventually 'struct cpumask' will be undefined for CONFIG_CPUMASK_OFFSTACK,
    so we use a bitmap here to show we really mean it).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

commit d036e67b40f52bdd95392390108defbac7e53837
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:26 2009 +1030

    cpumask: convert kernel/irq
    
    Impact: Reduce stack usage, use new cpumask API.  ALPHA mod!
    
    Main change is that irq_default_affinity becomes a cpumask_var_t, so
    treat it as a pointer (this effects alpha).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit bd232f97b30f6bb630efa136a777647545db3039
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:26 2009 +1030

    cpumask: convert RCU implementations
    
    Impact: use new cpumask API.
    
    rcu_ctrlblk contains a cpumask, and it's highly optimized so I don't want
    a cpumask_var_t (ie. a pointer) for the CONFIG_CPUMASK_OFFSTACK case.  It
    could use a dangling bitmap, and be allocated in __rcu_init to save memory,
    but for the moment we use a bitmap.
    
    (Eventually 'struct cpumask' will be undefined for CONFIG_CPUMASK_OFFSTACK,
    so we use a bitmap here to show we really mean it).
    
    We remove on-stack cpumasks, using cpumask_var_t for
    rcu_torture_shuffle_tasks() and for_each_cpu_and in force_quiescent_state().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit c309b917cab55799ea489d7b5f1b77025d9f8462
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:27 2009 +1030

    cpumask: convert kernel/profile.c
    
    Impact: Reduce kernel memory usage, use new cpumask API.
    
    Avoid a static cpumask_t for prof_cpu_mask, and an on-stack cpumask_t
    in prof_cpu_mask_write_proc.  Both become cpumask_var_t.
    
    prof_cpu_mask is only allocated when profiling is on, but the NULL
    checks are optimized out by gcc for the !CPUMASK_OFFSTACK case.
    
    Also removed some strange and unnecessary casts.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit e0b582ec56f1a1d8b30ebf340a7b91fb09f26c8c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:28 2009 +1030

    cpumask: convert kernel/cpu.c
    
    Impact: Reduce kernel stack and memory usage, use new cpumask API.
    
    Use cpumask_var_t for take_cpu_down() stack var, and frozen_cpus.
    
    Note that notify_cpu_starting() can be called before core_initcall
    allocates frozen_cpus, but the NULL check is optimized out by gcc for
    the CONFIG_CPUMASK_OFFSTACK=n case.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 41c7bb9588904eb060a95bcad47bd3804a1ece25
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:28 2009 +1030

    cpumask: convert rest of files in kernel/
    
    Impact: Reduce stack usage, use new cpumask API.
    
    Mainly changing cpumask_t to 'struct cpumask' and similar simple API
    conversion.  Two conversions worth mentioning:
    
    1) we use cpumask_any_but to avoid a temporary in kernel/softlockup.c,
    2) Use cpumask_var_t in taskstats_user_cmd().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
    Cc: Ingo Molnar <mingo@redhat.com>

commit 174596a0b9f21e8844d70566a6bb29bf48a87750
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:29 2009 +1030

    cpumask: convert mm/
    
    Impact: Use new API
    
    Convert kernel mm functions to use struct cpumask.
    
    We skip include/linux/percpu.h and mm/allocpercpu.c, which are in flux.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

commit 5db0e1e9e0f30f160b832a0b5cd1131954bf4f6e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:29 2009 +1030

    cpumask: replace for_each_cpu_mask_nr with for_each_cpu in kernel/time/
    
    Impact: cleanup
    
    Simple replacement, now the _nr is redundant.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Cc: Ingo Molnar <mingo@redhat.com>

commit 2a53008033189ed09bfe241c6b33811ba4ce980d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:30 2009 +1030

    cpumask: zero extra bits in alloc_cpumask_var_node
    
    Impact: extra safety checks during transition
    
    When CONFIG_CPUMASKS_OFFSTACK is set, the new cpumask_ operators only
    use bits up to nr_cpu_ids, not NR_CPUS.  Using the old cpus_ operators
    on these masks can mean accessing undefined bits.
    
    After some discussion, Mike and I decided to err on the side of caution;
    we zero the "undefined" bits in alloc_cpumask_var_node() until all the
    old cpumask functions are removed.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 8c384cdee3e04d6194a2c2b192b624754f990835
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 1 10:12:30 2009 +1030

    cpumask: CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
    
    Impact: new debug CONFIG options
    
    This helps find unconverted code.  It currently breaks compile horribly,
    but we never wanted a flag day so that's expected.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
