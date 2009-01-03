Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbZACU6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbZACU6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759650AbZACU63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:58:29 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50281 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758651AbZACU62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:58:28 -0500
Message-ID: <495FD171.4030502@sgi.com>
Date: Sat, 03 Jan 2009 12:58:25 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Re: [git pull] cpus4096 tree, part 3
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu> <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 3 Jan 2009, Ingo Molnar wrote:
>> ok. The pending regressions are all fixed now, and i've just finished my 
>> standard tests on the latest tree and all the tests passed fine.
> 
> Ok, pulled and pushed out.
> 
> Has anybody looked at what the stack size is with MAXSMP set with an 
> allyesconfig? And what areas are still problematic, if any? Are we going 
> to have some code-paths that still essentially have 1kB+ of stack space 
> just because they haven't been converted and still have the cpu mask on 
> stack?
> 
> 			Linus

Hi Linus,

Yes, I do periodically collect stats for memory and stack usage.  Here is
a recent stack summary (not "allyes", but most all trace/debug options
turned on).  It shows the stack growth from a 128 NR_CPUS config to a
MAXSMP (4096 NR_CPUS) config.  Most of the changes to correct these "stack
hogs" have been sitting in a queue until the changes affecting non-x86
architectures have been accepted (which you just did), though some are
because of new code from the merge activity.

Rusty has introduced a config option that disables the old cpumask_t
which really highlights where the offenders still are.  Ultimately,
that should prevent any new stack hogs from being introduced, but it
won't be settable until 2.6.30 time frame.

====== Stack (-l 500)
    1 - 128-defconfig
    2 - 4k-defconfig

  .1.    .2.    ..final..
    0  +1640 1640      .  acpi_cpufreq_target
    0  +1368 1368      .  cpufreq_add_dev
    0  +1344 1344      .  store_scaling_governor
    0  +1328 1328      .  store_scaling_min_freq
    0  +1328 1328      .  store_scaling_max_freq
    0  +1328 1328      .  cpufreq_update_policy
    0  +1328 1328      .  cpu_has_cpufreq
    0  +1048 1048      .  get_cur_val
    0  +1032 1032      .  local_cpus_show
    0  +1032 1032      .  local_cpulist_show
    0  +1024 1024      .  pci_bus_show_cpuaffinity
    0   +808 808      .  cpuset_write_resmask
    0   +736 736      .  update_flag
    0   +648 648      .  init_intel_cacheinfo
    0   +640 640      .  cpuset_attach
    0   +584 584      .  shmem_getpage
    0   +584 584      .  __percpu_alloc_mask
    0   +552 552      .  smp_call_function_many
    0   +536 536      .  pci_device_probe
    0   +536 536      .  native_flush_tlb_others
    0   +536 536      .  cpuset_common_file_read
    0   +520 520      .  show_related_cpus
    0   +520 520      .  show_affected_cpus
    0   +520 520      .  get_measured_perf
    0   +520 520      .  flush_tlb_page
    0   +520 520      .  cpuset_can_attach
    0   +512 512      .  flush_tlb_mm
    0   +512 512      .  flush_tlb_current_task
    0   +512 512      .  find_lowest_rq
    0   +512 512      .  acpi_processor_ffh_cstate_probe

====== Text/Data ()

Overall memory reservation looks like this:

      .1.       .2.    ..final..
  5799936     +4096   5804032 +0.07%  TextSize
  3772416   +139264   3911680 +3.69%  DataSize
  8822784  +1234944  10057728   +13%  BssSize
  2445312   +794624   3239936   +32%  InitSize
  1884160     +4096   1888256 +0.22%  PerCPU
   143360   +708608    851968  +494%  OtherSize
 22867968  +2885632  25753600  +112%  Totals


I will update these with the latest changes (and use a
allyesconfig config) and post them again soon.

Thanks,
Mike
