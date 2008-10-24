Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYJXVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYJXVUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYJXVUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:20:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYJXVUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:20:35 -0400
Date: Fri, 24 Oct 2008 14:20:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: [pull request] getting rid of __cpuinit
Message-ID: <20081024142056.6a2d082a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is one of those pull requests for which the best timing is likely at the 
end of the merge window due to touching a large number of files in a trivial way.
In fact, 6 of the 8 patches were done via regexps:

find -name "*.c" | xargs sed -i "s/^__cpuinit //g"
find arch/ -name "*.h" | xargs sed -i "s/ __cpuinit//g"
find -name "*.c" | xargs sed -i "s/ __cpuinit$//g"
find -name "*.c" | xargs sed -i "s/ __cpuinitdata//g"
find -name "*.c" | xargs sed -i "s/ __cpuexit / /g"
find -name "*.c" | xargs sed -i "s/ __cpuinit / /g"

(I suppose asking for a "git sed" is too much to do...)

The point of this series is to get rid of __cpuinit. (I'll be working on other __XXXXinit after this)
__cpuinit is a NOOP for CONFIG_HOTPLUG_CPU, which on for just about anybody in practice 
(in fact I had to disable 6 common options to even be ABLE to turn it off for size testing) 
and all distros also ship with it enabled.

Yet it's a rather error prone construct since the rules of this sort of __XXXXinit thing are
rather complex and convoluted.. better to just get rid of it entirely.

As for the code size effect, after I spent a bunch of time cursing and trying to find out
how to disable HOTPLUG_CPU, I managed to get an x86-64 build that actually shows how much space 
we ACTUALLY save with all the __cpuinit's in the tree... it's less than 2Kb. That is, if you manage
to turn it actually off.

   text	   data	    bss	    dec	    hex	filename
4618096	1358684	 848588	6825368	 682598	vmlinux.before
4619965	1356908	 848716	6825589  682675	vmlinux.after

Please consider pulling; or if you think another time is more appropriate just let me know;
re-running the regexps isn't all that much work.

Note: the patch leaves the __cpuinit macro still existent so that in-flight code that might 
use it won't immediately break, but over time I want to kill that as well. (just not right now,
because it could break various people's workflow and a few empty defines don't hurt all that much)


The following changes since commit e013e13bf605b9e6b702adffbe2853cfc60e7806:
  Jens Axboe (1):
        libata: fix bug with non-ncq devices

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-init.git ..BRANCH.NOT.VERIFIED..

Arjan van de Ven (8):
      cpuinit: get rid of __cpuinit, first regexp
      cpuinit: get rid of __cpuinit, second regexp
      cpuinit: get rid of __cpuinit, third regexp
      cpuinit: get rid of __cpuinit, fourth regexp
      cpuinit: get rid of __cpuinit, fifth regexp
      cpuinit: get rid of __cpuinit, sixth regexp
      cpuinit: get rid of __cpuinit, manual fixups
      cpuinit: turn __cpuinit into nops

 Documentation/cpu-hotplug.txt              |    4 +-
 arch/alpha/kernel/smp.c                    |    4 +-
 arch/arm/common/gic.c                      |    2 +-
 arch/arm/kernel/smp.c                      |   12 ++--
 arch/arm/mach-realview/localtimer.c        |    8 ++--
 arch/arm/mach-realview/platsmp.c           |    6 +-
 arch/cris/arch-v32/kernel/smp.c            |    2 +-
 arch/frv/kernel/setup.c                    |    2 +-
 arch/ia64/kernel/err_inject.c              |    8 ++--
 arch/ia64/kernel/mca.c                     |   12 ++--
 arch/ia64/kernel/numa.c                    |    4 +-
 arch/ia64/kernel/palinfo.c                 |    4 +-
 arch/ia64/kernel/salinfo.c                 |    4 +-
 arch/ia64/kernel/setup.c                   |   10 ++--
 arch/ia64/kernel/smpboot.c                 |   12 ++--
 arch/ia64/kernel/topology.c                |   18 ++++----
 arch/ia64/mm/contig.c                      |    2 +-
 arch/ia64/mm/discontig.c                   |    2 +-
 arch/ia64/sn/kernel/setup.c                |    4 +-
 arch/ia64/xen/hypervisor.c                 |    2 +-
 arch/m32r/kernel/smpboot.c                 |    2 +-
 arch/mips/kernel/cevt-bcm1480.c            |    2 +-
 arch/mips/kernel/cevt-r4k.c                |    2 +-
 arch/mips/kernel/cevt-sb1250.c             |    2 +-
 arch/mips/kernel/cevt-smtc.c               |    2 +-
 arch/mips/kernel/cpu-bugs64.c              |    4 +-
 arch/mips/kernel/cpu-probe.c               |   10 ++--
 arch/mips/kernel/smp-mt.c                  |    6 +-
 arch/mips/kernel/smp-up.c                  |    6 +-
 arch/mips/kernel/smp.c                     |    6 +-
 arch/mips/kernel/smtc.c                    |    2 +-
 arch/mips/kernel/spram.c                   |   14 +++---
 arch/mips/kernel/time.c                    |    2 +-
 arch/mips/kernel/traps.c                   |    8 ++--
 arch/mips/kernel/watch.c                   |    2 +-
 arch/mips/lib/uncached.c                   |    2 +-
 arch/mips/mipssim/sim_smtc.c               |    6 +-
 arch/mips/mipssim/sim_time.c               |    2 +-
 arch/mips/mm/c-r3k.c                       |    8 ++--
 arch/mips/mm/c-r4k.c                       |   34 +++++++-------
 arch/mips/mm/c-tx39.c                      |    2 +-
 arch/mips/mm/page.c                        |   40 ++++++++--------
 arch/mips/mm/sc-ip22.c                     |    2 +-
 arch/mips/mm/sc-mips.c                     |    2 +-
 arch/mips/mm/sc-r5k.c                      |    2 +-
 arch/mips/mm/sc-rm7k.c                     |    6 +-
 arch/mips/mm/tlb-r3k.c                     |    2 +-
 arch/mips/mm/tlb-r4k.c                     |    8 ++--
 arch/mips/mm/tlb-r8k.c                     |    4 +-
 arch/mips/mm/tlbex.c                       |   70 ++++++++++++++--------------
 arch/mips/mm/uasm.c                        |   70 ++++++++++++++--------------
 arch/mips/mm/uasm.h                        |   24 +++++-----
 arch/mips/mti-malta/malta-smtc.c           |    6 +-
 arch/mips/mti-malta/malta-time.c           |    2 +-
 arch/mips/pci/pci-ip27.c                   |    2 +-
 arch/mips/pmc-sierra/yosemite/smp.c        |   12 ++--
 arch/mips/sgi-ip27/ip27-init.c             |    4 +-
 arch/mips/sgi-ip27/ip27-smp.c              |    6 +-
 arch/mips/sgi-ip27/ip27-timer.c            |    6 +-
 arch/mips/sgi-ip27/ip27-xtalk.c            |    6 +-
 arch/mips/sibyte/bcm1480/smp.c             |    8 ++--
 arch/mips/sibyte/sb1250/smp.c              |    8 ++--
 arch/parisc/kernel/hardware.c              |    2 +-
 arch/parisc/kernel/processor.c             |    2 +-
 arch/parisc/kernel/smp.c                   |    4 +-
 arch/powerpc/kernel/smp.c                  |    2 +-
 arch/powerpc/kernel/sysfs.c                |   12 ++--
 arch/powerpc/mm/numa.c                     |   12 ++--
 arch/s390/appldata/appldata_base.c         |    8 ++--
 arch/s390/kernel/entry.h                   |    2 +-
 arch/s390/kernel/setup.c                   |    4 +-
 arch/s390/kernel/smp.c                     |   10 ++--
 arch/sh/kernel/setup.c                     |    2 +-
 arch/sh/kernel/smp.c                       |    4 +-
 arch/sh/kernel/timers/timer-broadcast.c    |    2 +-
 arch/sh/kernel/traps_32.c                  |    2 +-
 arch/sparc/kernel/smp.c                    |    8 ++--
 arch/sparc/kernel/sun4d_smp.c              |    2 +-
 arch/sparc/kernel/sun4m_smp.c              |    4 +-
 arch/sparc64/kernel/ds.c                   |    4 +-
 arch/sparc64/kernel/entry.h                |    2 +-
 arch/sparc64/kernel/irq.c                  |    4 +-
 arch/sparc64/kernel/mdesc.c                |    2 +-
 arch/sparc64/kernel/smp.c                  |    4 +-
 arch/sparc64/kernel/sysfs.c                |    4 +-
 arch/sparc64/mm/init.c                     |    2 +-
 arch/x86/include/asm/ds.h                  |    2 +-
 arch/x86/include/asm/mmconfig.h            |    4 +-
 arch/x86/include/asm/mpspec.h              |    2 +-
 arch/x86/include/asm/numa_64.h             |    8 ++--
 arch/x86/include/asm/ptrace.h              |    2 +-
 arch/x86/include/asm/smp.h                 |    4 +-
 arch/x86/kernel/acpi/boot.c                |    4 +-
 arch/x86/kernel/apic.c                     |   20 ++++----
 arch/x86/kernel/cpu/addon_cpuid_features.c |    6 +-
 arch/x86/kernel/cpu/amd.c                  |   22 ++++----
 arch/x86/kernel/cpu/centaur.c              |   26 +++++-----
 arch/x86/kernel/cpu/centaur_64.c           |    6 +-
 arch/x86/kernel/cpu/common.c               |   58 +++++++++++-----------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    4 +-
 arch/x86/kernel/cpu/cyrix.c                |   40 ++++++++--------
 arch/x86/kernel/cpu/intel.c                |   22 ++++----
 arch/x86/kernel/cpu/intel_cacheinfo.c      |   44 +++++++++---------
 arch/x86/kernel/cpu/mcheck/mce_64.c        |   16 +++---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c    |   10 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c  |    4 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |    8 ++--
 arch/x86/kernel/cpu/transmeta.c            |    6 +-
 arch/x86/kernel/cpu/umc.c                  |    2 +-
 arch/x86/kernel/cpuid.c                    |    4 +-
 arch/x86/kernel/ds.c                       |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c           |    4 +-
 arch/x86/kernel/i387.c                     |    6 +-
 arch/x86/kernel/irq_32.c                   |    2 +-
 arch/x86/kernel/microcode_core.c           |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c         |   14 +++---
 arch/x86/kernel/msr.c                      |    4 +-
 arch/x86/kernel/numaq_32.c                 |    4 +-
 arch/x86/kernel/process.c                  |    8 ++--
 arch/x86/kernel/ptrace.c                   |    2 +-
 arch/x86/kernel/setup.c                    |    2 +-
 arch/x86/kernel/setup_percpu.c             |   16 +++---
 arch/x86/kernel/smpboot.c                  |   28 ++++++------
 arch/x86/kernel/smpcommon.c                |    2 +-
 arch/x86/kernel/tlb_64.c                   |    2 +-
 arch/x86/kernel/tsc.c                      |    2 +-
 arch/x86/kernel/tsc_sync.c                 |   18 ++++----
 arch/x86/kernel/vsyscall_64.c              |    6 +-
 arch/x86/kernel/xsave.c                    |    2 +-
 arch/x86/mach-voyager/voyager_smp.c        |    4 +-
 arch/x86/mm/init_64.c                      |    4 +-
 arch/x86/mm/numa_64.c                      |    2 +-
 arch/x86/mm/pat.c                          |    2 +-
 arch/x86/pci/amd_bus.c                     |    4 +-
 arch/x86/xen/setup.c                       |    6 +-
 arch/x86/xen/smp.c                         |    8 ++--
 arch/x86/xen/spinlock.c                    |    2 +-
 arch/x86/xen/xen-ops.h                     |    2 +-
 arch/xtensa/kernel/time.c                  |    2 +-
 block/blk-softirq.c                        |    4 +-
 drivers/acpi/bus.c                         |    2 +-
 drivers/acpi/ec.c                          |    2 +-
 drivers/acpi/numa.c                        |    2 +-
 drivers/acpi/processor_core.c              |    4 +-
 drivers/acpi/processor_idle.c              |    6 +-
 drivers/base/cpu.c                         |    4 +-
 drivers/base/topology.c                    |    8 ++--
 drivers/cpufreq/cpufreq.c                  |    2 +-
 drivers/cpufreq/cpufreq_stats.c            |    2 +-
 drivers/hwmon/coretemp.c                   |    4 +-
 drivers/infiniband/hw/ehca/ehca_irq.c      |    6 +-
 drivers/s390/sysinfo.c                     |    2 +-
 include/linux/cpu.h                        |    2 +-
 include/linux/init.h                       |   12 ++--
 init/calibrate.c                           |    6 +-
 kernel/cpu.c                               |    6 +-
 kernel/fork.c                              |    4 +-
 kernel/hrtimer.c                           |    6 +-
 kernel/rcuclassic.c                        |    6 +-
 kernel/rcupreempt.c                        |    6 +-
 kernel/relay.c                             |    2 +-
 kernel/sched.c                             |    8 ++--
 kernel/smp.c                               |    2 +-
 kernel/softirq.c                           |    8 ++--
 kernel/softlockup.c                        |    4 +-
 kernel/timer.c                             |   10 ++--
 lib/percpu_counter.c                       |    2 +-
 mm/page-writeback.c                        |    4 +-
 mm/page_alloc.c                            |    6 +-
 mm/slab.c                                  |   10 ++--
 mm/slub.c                                  |    4 +-
 mm/vmstat.c                                |    6 +-
 net/iucv/iucv.c                            |    2 +-
 173 files changed, 645 insertions(+), 645 deletions(-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
