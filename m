Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbZATLF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbZATLF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbZATLFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:05:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779AbZATLFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:05:48 -0500
Date: Tue, 20 Jan 2009 12:05:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au
Subject: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120110542.GE19505@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at regressions since 2.6.16, and one is lat_mmap has slowed
down. On further investigation, a large part of this is not due to a
_regression_ as such, but the introduction of CONFIG_PARAVIRT=y.

Now, it is true that lat_mmap is basically a microbenchmark, however it
is exercising the memory mapping and page fault handler paths, so we're
talking about pretty important paths here. So I think it should be of
interest.

I've run the tests on a 2s8c AMD Barcelona system, binding the test to
CPU0, and running 100 times (stddev is a bit hard to bring down, and
my scripts needed 100 runs in order to pick up much smaller changes in
the results -- for CONFIG_PARAVIRT, just a couple of runs should show
up the problem).

Times I believe are in nanoseconds for lmbench, anyway lower is better.

non pv   AVG=464.22 STD=5.56
paravirt AVG=502.87 STD=7.36

Nearly 10% performance drop here, which is quite a bit... hopefully people
are testing the speed of their PV implementations against non-PV bare
metal :)


CPU: AMD64 family10, speed 2000 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 10000
samples  %        symbol name
BASE
49749    32.6336  read_tsc
10151     6.6587  __up_read
7363      4.8299  unmap_vmas
7072      4.6390  mnt_drop_write
4107      2.6941  do_page_fault
4090      2.6829  rb_get_reader_page
3601      2.3621  apic_timer_interrupt
3537      2.3202  set_page_dirty
3435      2.2532  mnt_want_write
3302      2.1660  default_idle
2990      1.9613  idle_cpu
2904      1.9049  file_update_time
2789      1.8295  set_page_dirty_balance
2712      1.7790  retint_swapgs
2455      1.6104  __do_fault
2231      1.4635  release_pages
1989      1.3047  rb_buffer_peek
1895      1.2431  ring_buffer_consume
1572      1.0312  handle_mm_fault
1554      1.0194  put_page
1461      0.9584  sync_buffer
1196      0.7845  clear_page_c
1145      0.7511  rb_advance_reader
1144      0.7504  hweight64
1084      0.7111  getnstimeofday
1076      0.7058  __set_page_dirty_no_writeback
1020      0.6691  mark_page_accessed
751       0.4926  tick_do_update_jiffies64

CONFIG_PARAVIRT
8924      7.8849  native_safe_halt
8823      7.7957  native_read_tsc
6201      5.4790  default_spin_lock_flags
5806      5.1300  unmap_vmas
3996      3.5307  handle_mm_fault
3954      3.4936  rb_get_reader_page
3752      3.3151  __do_fault
2908      2.5694  getnstimeofday
2303      2.0348  apic_timer_interrupt
2183      1.9288  find_busiest_group
2057      1.8175  do_page_fault
2057      1.8175  hweight64
2017      1.7821  set_page_dirty
1926      1.7017  get_next_timer_interrupt
1781      1.5736  release_pages
1702      1.5038  native_pte_val
1620      1.4314  native_sched_clock
1588      1.4031  rebalance_domains
1558      1.3766  run_timer_softirq
1531      1.3527  __down_read_trylock
1505      1.3298  native_pmd_val
1445      1.2767  find_get_page
1369      1.2096  find_next_bit
1356      1.1981  __ticket_spin_lock
1225      1.0824  shmem_getpage
1169      1.0329  radix_tree_lookup_slot
1166      1.0302  vm_normal_page
987       0.8721  scheduler_tick
