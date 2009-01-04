Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZADNSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZADNSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZADNSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:10 -0500
Received: from relay3.sgi.com ([192.48.171.31]:38600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750889AbZADNSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:08 -0500
Message-Id: <20090104131759.865331000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:17:59 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] x86: cpumask: some more cpumask cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's some more cpumask cleanups.

    ia64: cpumask fix for is_affinity_mask_valid()
    cpumask: update local_cpus_show to use new cpumask API
    cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
    x86: cleanup remaining cpumask_t ops in smpboot code
    x86: clean up speedstep-centrino and reduce cpumask_t usage
    cpumask: Replace CPUMASK_ALLOC etc with cpumask_var_t.
    cpumask: convert struct cpufreq_policy to cpumask_var_t.
    cpumask: use work_on_cpu in acpi/cstate.c
    cpumask: use cpumask_var_t in acpi-cpufreq.c
    cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
    cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs

This version basically splits out the changes to make it more
bisectable, and has been patch-wise compile/boot tested.  Updated
stats are below.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <len.brown@intel.com>

---

The number of stack hogs have been significantly reduced:

====== Stack (-l 500)
    1 - allyesconfig-128
    2 - allyesconfig-4k

  .1.    .2.    ..final..
    0  +1032   1032      .  flush_tlb_page
    0  +1024   1024      .  kvm_reload_remote_mmus
    0  +1024   1024      .  kvm_flush_remote_tlbs
    0  +1024   1024      .  flush_tlb_mm
    0  +1024   1024      .  flush_tlb_current_task
    0   +824    824      .  efx_pci_probe_main
    0   +800    800      .  cpuset_write_resmask
    0   +736    736      .  update_flag
    0   +696    696      .  init_intel_cacheinfo
    0   +640    640      .  cpuset_attach
    0   +600    600      .  shmem_getpage
    0   +600    600      .  powernowk8_target
    0   +584    584      .  powernowk8_cpu_init
    0   +584    584      .  __percpu_alloc_mask
    0   +552    552      .  xen_flush_tlb_others
    0   +552    552      .  smp_call_function_many
    0   +536    536      .  reload_store
    0   +536    536      .  native_flush_tlb_others
    0   +536    536      .  cpuset_common_file_read
    0   +528    528      .  get_cur_freq
    0   +528    528      .  check_supported_cpu
    0   +520    520      .  powernowk8_get
    0   +520    520      .  microcode_write
    0   +520    520      .  microcode_init_cpu
    0   +520    520      .  cpuset_can_attach
    0   +512    512      .  smi_request
    0   +512    512      .  pci_device_probe
    0   +512    512      .  find_lowest_rq


And the overall memory usage is becoming quite less affected by changing
NR_CPUS from 128 to 4096:

====== Text/Data ()
    1 - allyesconfig-128
    2 - allyesconfig-4k

       .1.       .2.    ..final..
  32950272    +10240   32960512 +0.03%  TextSize
  45082624    +77824   45160448 +0.17%  DataSize
  11436032  +4167680   15603712   +36%  BssSize
   3514368   +794624    4308992   +22%  InitSize
   1904640     +4096    1908736 +0.22%  PerCPU
    360448   +722944    1083392  +200%  OtherSize
  95248384  +5777408  101025792  +106%  Totals


Detailing it by section shows there still are a few areas to examine more
closely.  Note init.data is "give back" memory, but data.cacheline_aligned
indicates there are still many lists sized by NR_CPUS.


====== Sections (-l 500)
    1 - allyesconfig-128
    2 - allyesconfig-4k

        .1.       .2.    ..final..
  563607471  +6217546   569825017 +1.10%  Total
  362852723   +357693   363210416 +0.10%  .debug_info
   43002053    +10004    43012057 +0.02%  .debug_loc
   32949913    +10464    32960377 +0.03%  .text
   25793792     +4848    25798640 +0.02%  .debug_ranges
   22693731    +39360    22733091 +0.17%  .rodata
   21157048    +33968    21191016 +0.16%  .data
   19190023      +983    19191006 +0.01%  .debug_line
   11436936  +4167424    15604360   +36%  .bss
    7205306    +85021     7290327 +1.18%  .debug_abbrev
    1904160     +5504     1909664 +0.29%  .data.percpu
     829999      +709      830708 +0.09%  .init.text
     595328   +783920     1379248  +131%  .init.data
     150400     +1456      151856 +0.97%  __param
     101464   +239632      341096  +236%  .data.read_mostly
      32384   +475648      508032 +1468%  .data.cacheline_aligned

