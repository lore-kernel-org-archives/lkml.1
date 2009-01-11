Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZAKXTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZAKXTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 18:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZAKXTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 18:19:31 -0500
Received: from relay3.sgi.com ([192.48.171.31]:56440 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751821AbZAKXTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 18:19:30 -0500
Message-ID: <496A7E76.2050507@sgi.com>
Date: Sun, 11 Jan 2009 15:19:18 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <20090111190218.GA18651@elte.hu> <496A451C.5030400@sgi.com>
In-Reply-To: <496A451C.5030400@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
...
>> Mike, most of the work_on_cpu() patches you did so far were rather 
>> problematic. Especially something like cpufreq can run rather early during 
>> bootup or during suspend/resume, so i'm not sure it's correct to rely on 
>> keventd for it.
>>
>> I dont see anything particularly wrong in the commit itself - but 
>> obviously it causes this boot hang - if the bug is not found we'll revert 
>> it .
> 
> All of these are low use functions, primarily used when bringing up
> cpus.  So reverting the patches does not have a big effect on the stack
> size problem.

Btw, we're looking great with stack space.  This is using the 'allyesconfig'
config with NR_CPUS=4096, MAX_NUMNODES=512, and 128-allyesconfig having
NR_CPUS=128, MAX_NUMNODES=64.

====== Stack (-l 500)

    1 - 128-allyesconfig
    2 - allyesconfig

  .1.   .2.  .delta.
    0   600   600      .  shmem_getpage
    0   600   600      .  powernowk8_target
    0   584   584      .  powernowk8_cpu_init
    0   584   584      .  __percpu_alloc_mask
    0   552   552      .  smp_call_function_many
    0   536   536      .  reload_store
    0   528   528      .  get_cur_freq
    0   528   528      .  check_supported_cpu
    0   520   520      .  powernowk8_get
    0   520   520      .  microcode_write
    0   520   520      .  microcode_init_cpu

In Data space we've still got a couple of memory hogs:

====== Data (-l 500)

    1 - 128-allyesconfig
    2 - allyesconfig

    .1.      .2.  .delta.
  16384   524288  +507904 +3100%  boot_pageset(.bss)	[1]
  23816   483080  +459264 +1928%  kmalloc_caches(.data.cacheline_aligned) [2]
  17408   132096  +114688  +658%  irq_info(.bss)	[3]
  17408   132096  +114688  +658%  irq_bindcount(.bss)	[3]
   1020   131072  +130052 +12750%  apic_version(.bss)	[4]
   3072    98304   +95232 +3100%  ucode_cpu_info(.bss)	[5]
   2048    65536   +63488 +3100%  kgdb_info(.bss)	[5]
   5120    40960   +35840  +700%  node_devices(.bss)	[6]
   5216    36952   +31736  +608%  iter(.bss)		[???]
   6404    33284   +26880  +419%  e820_saved(.bss)	[7]
   6404    33284   +26880  +419%  e820(.bss)		[7]
   1040    33280   +32240 +3100%  cpu_bit_bitmap(.rodata) [8]
   1064    32808   +31744 +2983%  max_tr(.bss)		[9]
   1064    32808   +31744 +2983%  global_trace(.bss)	[9]
   1024    32768   +31744 +3100%  fcoe_percpu(.bss)	[10]

[1]: very hard to fix, might be able to use early per_cpu_alloc when available
[2]: can be fixed when early per_cpu_alloc available
[3]: sized by NR_IRQS which can be fixed now
[4]: currently apic_version[MAX_APICS] which is a very sparsely filled array
[5]: sized by NR_CPUS, can be dynamically allocated
[6]: sized by MAX_NUMNODES, also can be dynamically allocated
[7]: sized by MAX_NUMNODES, not so easily modified
[8]: will fix when cpumask_size() is sized by nr_cpu_ids instead of NR_CPUS
[9]: struct trace_array has an NR_CPUS array component
[10]: pointer list sized by NR_CPUS


Overall, the percentages are good:

====== Text/Data ()

    1 - 128-allyesconfig
    2 - allyesconfig

       .1.       .2.  .delta.
  33490944  33499136      +8192 +0.02%  TextSize
  45527040  45598720     +71680 +0.16%  DataSize
  11315200  12685312   +1370112   +12%  BssSize
   3436544   4231168    +794624   +23%  InitSize [1]
   1904640   1910784      +6144 +0.32%  PerCPU
    333824    794624    +460800  +138%  OtherSize

[1]: remember, this space is "given back" after system initializes.

Here the section detail:

====== Sections (-l 500)

    1 - 128-allyesconfig
    2 - allyesconfig

        .1.       .2.  .delta.
   11316152  12685496    +1369344   +12%  .bss
      32384    491648     +459264 +1418%  .data.cacheline_aligned
  370195151 370555424     +360273 +0.10%  .debug_info
    7358485   7445195      +86710 +1.18%  .debug_abbrev
   23003987  23045427      +41440 +0.18%  .rodata
   21248744  21281904      +33160 +0.16%  .data
   43877348  43890141      +12793 +0.03%  .debug_loc
      66728     76984      +10256   +15%  .data.read_mostly
   33491529  33498553       +7024 +0.02%  .text
   26088048  26094032       +5984 +0.02%  .debug_ranges
    1904288   1910176       +5888 +0.31%  .data.percpu
   19530974  19532151       +1177 +0.01%  .debug_line
     153072    152432        -640 -0.42%  __param
     836911    837706        +795 +0.09%  .init.text
