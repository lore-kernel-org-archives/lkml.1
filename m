Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYDEBL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYDEBL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYDEBLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45127 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751685AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:00 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] cpumask: reduce stack pressure from local/passed cpumask variables v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify usage of cpumask_t variables to use pointers as much as possible.

Changes are:

	* Use an allocated array of cpumask_t's for cpumask_of_cpu().
	  This removes > 20,000 bytes of stack usage (see all changes
	  in the chart below),
	  as well as reduces the code generated for each usage.

	* Use set_cpus_allowed_ptr() to pass a pointer to the "newly allowed"
	  cpumask.  This removes > 10,000 bytes of stack usage.

	* Use node_to_cpumask_ptr that returns pointer to cpumask for the
	  specified node.  This removes > 10,000 bytes of stack usage.

	* Modify build_sched_domains and related sub-functions to pass
	  pointers to cpumask temp variables.  This consolidates stack
	  space that was spread over various functions.

	* Remove large array from numa_initmem_init() [> 8,000 bytes].

	* Optimize usages of {CPU,NODE}_MASK_{NONE,ALL} [> 9,000 bytes].

	* Various other changes to reduce stacksize and silence checkpatch
	  warnings [ > 7,000 bytes].

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Cliff Wickman <cpw@sgi.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Banks <gnb@melbourne.sgi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <len.brown@intel.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: William L. Irwin <wli@holomorphy.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
v3: rebased on x86/latest + sched-devel/latest
    collapsed many patches so same files don't appear in different
    patches (kernel/sched.c unfortunately still appears in about 5
    or 6 patches, and include/asm-x86/topology.h is in 2.)

v2: resubmitted based on x86/latest.
--- ---------------------------------------------------------
* Memory Usages Changes

Patch list summary of various memory usage changes using the akpm2
config file with NR_CPUS=4096 and MAX_NUMNODES=512.

====== Data (-l 500)
... files 13 vars 1855 all 0 lim 500 unch 0

    1 - initial
    2 - cpumask_of_cpu
    3 - add-CPUMASK_ALL_PTR
    5 - nr_cpus-in-kernel_sched
    7 - generic-set_cpus_allowed
   12 - kernel_sched_c
   13 - use-CPUMASK_ALL_PTR

    .1.   .2.   .3.     .5.   .7.  .12.  .13.    ..final..
  32768     .     .  -32768     .     .     .    .  -100%  sched_group_nodes_bycpu(.bss)
  32768     .     .  -32768     .     .     .    .  -100%  init_sched_rt_entity_p(.bss)
  32768     .     .  -32768     .     .     .    .  -100%  init_rt_rq_p(.bss)
   3550     .     .      +9     .  -842     . 2717   -23%  build_sched_domains(.text)
    674   -95     .       .  -579     .     .    .  -100%  acpi_processor_set_throttling(.text)
    533  -533     .       .     .     .     .    .  -100%  hpet_enable(.init.text)
    512     .     .       .     .     .  -512    .  -100%  C(.rodata)
      0     .  +512       .     .     .     .  512      .  cpu_mask_all(.data.read_mostly)
 103573  -628  +512  -98295  -579  -842  -512 3229   -96%  Totals

====== Sections (-l 500)
... files 13 vars 37 all 0 lim 500 unch 0

    1 - initial
    2 - cpumask_of_cpu
    3 - add-CPUMASK_ALL_PTR
    5 - nr_cpus-in-kernel_sched
    6 - x86-set_cpus_allowed
    7 - generic-set_cpus_allowed
    8 - cpuset_cpus_allowed
    9 - cpumask_affinity
   10 - numa_initmem_init
   11 - node_to_cpumask_ptr
   12 - kernel_sched_c
   13 - use-CPUMASK_ALL_PTR

       .1.     .2.   .3.     .5.    .6.    .7.   .8.   .9.   .10.  .11.   .12.   .13.    ..final..
  75833950  -13010  +260  -98051  -2972  -2295  +644  +122  +8174  -465   -698  +1349 75727008    <1%  Total
  42810838   -7428   +39    +225   -757   -431  +215  +182     -1  -366   +945   +591 42804052    <1%  .debug_info
   6808830    -404  -211    -116   -316   -243   +42  +113    -22   +95  +1950    +14  6809732    <1%  .debug_loc
   4805176     +16  +512       .      .      .     .     .      .     .      .      .  4805704    <1%  .data.read_mostly
   3475017    -528   -16     +48   -128   -496  -256  -112      .  -496    -32    -80  3472921    <1%  .text
   2720422    -895   -16     +26   -192   -146   -23    -4     -1  -164    +26    +81  2719114    <1%  .debug_line
   1775040       .     .  -98176      .      .     .     .      .     .      .      .  1676864    -5%  .bss
   1395188    -245    -9       .   -131    -95   -19   -17      .     .    +14   +103  1394789    <1%  .debug_abbrev
   1141392   -3104   -64       .  -1408   -848  +752   -16      .  +480   +208   +640  1138032    <1%  .debug_ranges
   1021159     +32  -512       .      .  -1152  -640     .      .     .  -1377   -512  1016998    <1%  .rodata
    982688       .     .       .      .      .     .     .  +8208     .      .      .   990896    <1%  .init.data
      8080     -80  +464       .      .  +1152  +640     .      .     .  -2720   +512     8048    <1%  __param
142777780 -25646 +447 -196044 -5904 -4554 +1355 +268 +16358 -916 -1684 +2698 142564158   +0%  Totals

====== Text/Data ()
... files 13 vars 6 all 0 lim 0 unch 0

    1 - initial
    2 - cpumask_of_cpu
    5 - nr_cpus-in-kernel_sched
    7 - generic-set_cpus_allowed
   10 - numa_initmem_init
   12 - kernel_sched_c

       .1.    .2.     .5.    .7.   .10.   .12.    ..final..
   3475456  -2048       .      .      .      . 3473408    <1%  TextSize
   1738752  +2048       .  -4096      .  -4096 1732608    <1%  DataSize
   1775616      .  -98304      .      .      . 1677312    -5%  BssSize
   1220608      .       .      .  +8192      . 1228800    <1%  InitSize
  10399744      .       .  -4096      .  +4096 10399744      .  OtherSize
 18610176     . -98304 -8192 +8192     . 18511872   +0%  Totals

====== PerCPU ()
... files 13 vars 10 all 0 lim 0 unch 0

    1 - initial

  .1.    ..final..
   0 .   +0%  Totals

====== Stack (-l 500)
... files 13 vars 166 all 0 lim 500 unch 0

    1 - initial
    2 - cpumask_of_cpu
    3 - add-CPUMASK_ALL_PTR
    5 - nr_cpus-in-kernel_sched
    6 - x86-set_cpus_allowed
    7 - generic-set_cpus_allowed
    8 - cpuset_cpus_allowed
    9 - cpumask_affinity
   10 - numa_initmem_init
   11 - node_to_cpumask_ptr
   12 - kernel_sched_c
   13 - use-CPUMASK_ALL_PTR

    .1.    .2.    .3.    .5.   .6.    .7.   .8.    .9.   .10.   .11.   .12.  .13.    ..final..
  11080      .      .      .     .      .     .      .      .   -512  -8336     . 2232   -79%  build_sched_domains
   8248      .      .      .     .      .     .      .  -8248      .      .     .    .  -100%  numa_initmem_init
   4648      .      .  -3840     .      .     .      .      .      .   -808     .    .  -100%  cpu_attach_domain
   3176      .    -16    +16     .      .     .      .      .  -1552  -1024     .  600   -81%  sched_domain_node_span
   3176   -512      .      .  -512      .     .      .      .      .      .     . 2152   -32%  centrino_target
   2584  -1024      .      .     .   -512     .      .      .      .      .     . 1048   -59%  acpi_processor_set_throttling
   2104      .      .      .     .  -1024     .      .      .      .      .     . 1080   -48%  _cpu_down
   2088  -1024      .      .  -512      .     .      .      .      .      .     .  552   -73%  powernowk8_cpu_init
   2072   -512      .      .     .      .     .      .      .      .      .     . 1560   -24%  tick_notify
   2056      .      .      .     .      .     .  -2056      .      .      .     .    .  -100%  affinity_set
   1784  -1024      .      .     .      .     .      .      .      .      .     .  760   -57%  cpufreq_add_dev
   1704      .      .      .     .      .     .      .      .  -1704      .     .    .  -100%  kswapd
   1608   -512      .      .  -512      .     .      .      .      .      .     .  584   -63%  powernowk8_target
   1608  -1608      .      .     .      .     .      .      .      .      .     .    .  -100%  disable_smp
   1608   -512      .      .  -512      .     .      .      .      .      .     .  584   -63%  cache_add_dev
   1592      .      .      .     .      .     .      .      .      .  -1592     .    .  -100%  do_tune_cpucache
   1576      .      .      .     .      .     .      .      .      .  -1576     .    .  -100%  init_sched_build_groups
   1560      .      .      .     .  -1040     .      .      .      .      .     .  520   -66%  pci_device_probe
   1560   -512      .      .  -512      .     .      .      .      .      .     .  536   -65%  check_supported_cpu
   1544      .      .      .     .      .  -512   +512      .      .   -512     . 1032   -33%  sched_setaffinity
   1544   -512      .      .  -520      .     .      .      .      .      .     .  512   -66%  powernowk8_get
   1544  -1008      .      .     .      .     .      .      .      .      .     .  536   -65%  alloc_ldt
   1536   -504      .      .     .      .     .      .      .      .      .     . 1032   -32%  smp_call_function_single
   1536  -1024      .      .     .      .     .      .      .      .      .     .  512   -66%  native_smp_send_reschedule
   1536   -512      .      .  -504      .     .      .      .      .      .     .  520   -66%  get_cur_freq
   1536   -512      .      .     .   -512     .      .      .      .      .     .  512   -66%  acpi_processor_get_throttling
   1536   -512      .      .  -504      .     .      .      .      .      .     .  520   -66%  acpi_processor_ffh_cstate_probe
   1176      .      .      .     .      .     .      .      .      .   -512     .  664   -43%  thread_return
   1176      .      .      .     .      .     .      .      .      .   -512     .  664   -43%  schedule
   1160      .      .      .     .      .     .      .      .      .   -512     .  648   -44%  run_rebalance_domains
   1160      .      .      .     .      .     .      .      .  -1160      .     .    .  -100%  __build_all_zonelists
   1152      .      .      .     .      .  -504      .      .      .      .     .  648   -43%  cpuset_attach
   1072      .      .      .     .      .  -512      .      .      .      .     .  560   -47%  pdflush
   1064      .      .      .     .      .     .      .      .  -1064      .     .    .  -100%  cpuup_canceled
   1064      .      .      .     .      .     .      .      .      .  -1064     .    .  -100%  cpuup_callback
   1032  -1032      .      .     .      .     .      .      .      .      .     .    .  -100%  uv_target_cpus
   1032      .      .      .     .   -520     .      .      .      .      .     .  512   -50%  system_kthread_notifier
   1032  -1032      .      .     .      .     .      .      .      .      .     .    .  -100%  setup_pit_timer
   1032      .      .      .     .      .     .      .      .      .   -512     .  520   -49%  sched_init_smp
   1032      .      .      .     .      .     .      .      .      .      .  -520  512   -50%  physflat_vector_allocation_domain
   1032      .  -1032      .     .      .     .      .      .      .      .     .    .  -100%  kernel_init
   1032  -1032      .      .     .      .     .      .      .      .      .     .    .  -100%  init_workqueues
   1032  -1032      .      .     .      .     .      .      .      .      .     .    .  -100%  init_idle
   1032      .      .      .     .      .     .      .      .      .      .  -512  520   -49%  destroy_irq
   1032      .      .      .     .  -1032     .      .      .      .      .     .    .  -100%  ____call_usermodehelper
   1024      .      .      .     .      .     .   -512      .      .      .     .  512   -50%  sys_sched_setaffinity
   1024   -504      .      .     .   -520     .      .      .      .      .     .    .  -100%  stopmachine
   1024  -1024      .      .     .      .     .      .      .      .      .     .    .  -100%  setup_APIC_timer
   1024  -1024      .      .     .      .     .      .      .      .      .     .    .  -100%  native_smp_prepare_cpus
   1024   -504      .      .  -520      .     .      .      .      .      .     .    .  -100%  native_machine_shutdown
   1024      .      .      .     .  -1024     .      .      .      .      .     .    .  -100%  kthreadd
   1024  -1024      .      .     .      .     .      .      .      .      .     .    .  -100%  kthread_bind
   1024  -1024      .      .     .      .     .      .      .      .      .     .    .  -100%  hpet_enable
   1024      .      .      .     .      .     .   -512      .      .      .     .  512   -50%  compat_sys_sched_setaffinity
   1024      .      .      .     .      .     .      .      .      .      .  -512  512   -50%  __percpu_populate_mask
    576      .      .      .     .      .  -576      .      .      .      .     .    .  -100%  cpuset_init
    576      .      .      .     .      .  -576      .      .      .      .     .    .  -100%  cpuset_create
    552      .      .      .     .      .     .      .      .      .   -552     .    .  -100%  migration_call
    520      .      .      .     .      .     .      .      .   -520      .     .    .  -100%  node_read_cpumap
    520      .      .      .     .      .     .      .      .      .      .  -520    .  -100%  dynamic_irq_init
    520      .      .      .     .      .  -520      .      .      .      .     .    .  -100%  cpuset_cpus_allowed
    520      .      .      .     .      .  -520      .      .      .      .     .    .  -100%  cpuset_change_cpumask
    520      .      .      .     .      .     .      .      .      .   -520     .    .  -100%  cpu_to_phys_group
    520      .      .      .     .      .     .      .      .      .   -520     .    .  -100%  cpu_to_core_group
    520      .      .      .     .      .     .   -520      .      .      .     .    .  -100%  affinity_restore
    512      .      .      .     .      .  -512      .      .      .      .     .    .  -100%  cpuset_cpus_allowed_locked
      0      .      .      .     .      .     .      .      .      .   +760     .  760      .  sd_init_SIBLING
      0      .      .      .     .      .     .      .      .      .   +760     .  760      .  sd_init_NODE
      0      .      .      .     .      .     .      .      .      .   +752     .  752      .  sd_init_MC
      0      .      .      .     .      .     .      .      .      .   +752     .  752      .  sd_init_CPU
      0      .      .      .     .      .     .      .      .      .   +752     .  752      .  sd_init_ALLNODES
      0      .      .      .     .      .     .      .      .      .   +512     .  512      .  detach_destroy_domains
103584 -21056 -1048 -3824 -4608 -6184 -4232 -3088 -8248 -6512 -14264 -2064 28456  -72%  Totals

-- 
