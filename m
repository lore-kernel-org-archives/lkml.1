Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZAKAPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZAKAPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZAKAPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:15:34 -0500
Received: from relay3.sgi.com ([192.48.171.31]:58528 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753028AbZAKAPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:15:33 -0500
Message-ID: <49693A18.5090802@sgi.com>
Date: Sat, 10 Jan 2009 16:15:20 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] irq: change irq_desc and kstat_irq_legacy to	variable
 sized arrays
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110224323.GA17917@elte.hu>
In-Reply-To: <20090110224323.GA17917@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> The following patches change irq_desc and kstat_irq_legacy into
>> variable sized arrays based on nr_cpu_ids when CONFIG_SPARSE_IRQS=y.
>>
>>     irq: change references from NR_IRQS to nr_irqs
>>     irq: allocate irq_desc_ptrs array based on nr_irqs
>>     irq: initialize nr_irqs based on nr_cpu_ids
>>     kstat: modify kstat_irqs_legacy to be variable sized
>>
>> Based on: tip/cpus4096 @ v2.6.28-6140-g36c401a
>>
>> (Ingo - I will push these to your tip/cpus4096 branch via my cpus4096-for-ingo
>> 	git tree.)
> 
> Thanks - please send a pull request when you feel good about them.
> 
> The changes look good to me.
> 
>> Affects of the SPARSE changes on NR_CPUS values.
>>
>>     1 - 128-defconfig (non-SPARSE)
>>     2 - 4k-defconfig (non-SPARSE)
>>     3 - 4k-defconfig (SPARSE)
>>
>> ====== Data
>>
>>       .1.        .2.        .3.    ..final..
>>   1114112          .   -1114112      .  -100%  irq_desc(.data.cacheline_aligned)
>>    208896     -69632    -138752    512   -99%  irq_cfgx(.data)
>>     34816          .     -34816      .  -100%  irq_timer_state(.bss)
>>     17480          .     -17480      .  -100%  per_cpu__kstat(.data.percpu)
>>         0          .      +4096   4096      .  irq_desc_legacy(.data.cacheline_aligned)
> 
> Impressive!
> 
> If i remember your previous figures correctly we've got about +4MB of 
> memory bloat at 4K CPUs, that is now down to 3MB total?
> 
> 	Ingo

Here's my latest stats:

====== Text/Data ()

    1 - 128-defconfig
    2 - 4k-defconfig

      .1.       .2.    ..final..
  5935104     -6144   5928960 -0.10%  TextSize
  3833856    +43008   3876864 +1.12%  DataSize
  9734144   -219136   9515008 -2.25%  BssSize
  2449408   +790528   3239936   +32%  InitSize
  1884160     +6144   1890304 +0.33%  PerCPU
   110592   +462848    573440  +418%  OtherSize


====== Sections (-l 500)

    1 - 128-defconfig
    2 - 4k-defconfig

        .1.       .2.    ..final..
  118246380  +1109486   119355866 +0.94%  Total
   74327135    +46083    74373218 +0.06%  .debug_info
   10590059    -14760    10575299 -0.14%  .debug_loc
    9734104   -219904     9514200 -2.26%  .bss
    5934961     -5744     5929217 -0.10%  .text
    4387075     -6047     4381028 -0.14%  .debug_line
    2369795    +25072     2394867 +1.06%  .rodata
    1938985    +21033     1960018 +1.08%  .debug_abbrev
    1883808     +5760     1889568 +0.31%  .data.percpu
    1691216     -7952     1683264 -0.47%  .debug_ranges
    1481593      -920     1480673 -0.06%  .debug_str
    1316320     -1864     1314456 -0.14%  .debug_frame
    1195280    +20408     1215688 +1.71%  .data
      34440     +6784       41224   +19%  .data.read_mostly
      30016   +459264      489280 +1530%  .data.cacheline_aligned
      23352     -1692       21660 -7.25%  __bug_table
      13760     +1312       15072 +9.53%  __param
====== Data (-l 500)

    1 - 128-defconfig
    2 - 4k-defconfig

      .1.        .2.    ..final..
  1179648   -1179648        .  -100%  obj_hash(.bss)
    23816    +459264   483080 +1928%  kmalloc_caches(.data.cacheline_aligned)
    20480     -20480        .  -100%  obj_static_pool(.bss)
    16384    +507904   524288 +3100%  boot_pageset(.bss)
     9576     +15032    24608  +156%  def_root_domain(.bss)
     6404     +26880    33284  +419%  e820_saved(.bss)
     6404     +26880    33284  +419%  e820(.bss)
     5216     +31736    36952  +608%  iter(.bss)
     5120     +35840    40960  +700%  node_devices(.bss)
     4976       +552     5528   +11%  init_task(.data)
     3776     +25088    28864  +664%  hstates(.bss)
     3072     +95232    98304 +3100%  ucode_cpu_info(.bss)
     1145      -1145        .  -100%  centrino_target(.text)
     1064     +31744    32808 +2983%  max_tr(.bss)
     1064     +31744    32808 +2983%  global_trace(.bss)
     1040     +32240    33280 +3100%  cpu_bit_bitmap(.rodata)
     1024      +1024     2048  +100%  pxm_to_node_map(.data)
     1024      +7168     8192  +700%  nodes_add(.bss)
     1020    +130052   131072 +12750%  apic_version(.bss)
      945       -945        .  -100%  debug_objects_mem_init(.init.text)
      835       -835        .  -100%  speedstep_get_processor_frequency(.text)
      752       -752        .  -100%  __debug_object_init(.text)
      541       -541        .  -100%  cpufreq_p4_target(.text)
      525       -525        .  -100%  speedstep_detect_processor(.text)
      514       -514        .  -100%  page_mkclean(.text)
      512       -512        .  -100%  speedstep_get_freqs(.text)
      512      +3584     4096  +700%  node_data(.data.read_mostly)
      512     +15872    16384 +3100%  last_pid(.data)
      512       -512        .  -100%  has_N44_O17_errata(.bss)


====== Stack (-l 500)

    1 - 128-defconfig
    2 - 4k-defconfig

(Note the cpuset bumps have been addressed by Li Zefan's changes.)

  .1.   .2.    ..final..
    0  +808   808      .  cpuset_write_resmask
    0  +736   736      .  update_flag
    0  +640   640      .  cpuset_attach
    0  +600   600      .  powernowk8_target
    0  +584   584      .  shmem_getpage
    0  +584   584      .  __percpu_alloc_mask
    0  +568   568      .  powernowk8_cpu_init
    0  +552   552      .  smp_call_function_many
    0  +536   536      .  pci_device_probe
    0  +536   536      .  cpuset_common_file_read
    0  +528   528      .  check_supported_cpu
    0  +520   520      .  cpuset_can_attach
    0  +512   512      .  powernowk8_get


