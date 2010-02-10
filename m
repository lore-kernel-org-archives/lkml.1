Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0BJPSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:18:14 -0500
Received: from borg.medozas.de ([188.40.89.202]:54378 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab0BJPSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:18:11 -0500
Date: Wed, 10 Feb 2010 16:18:10 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: jens.axboe@oracle.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd continuously active
In-Reply-To: <20100208140837.GN1025@kernel.dk>
Message-ID: <alpine.LSU.2.01.1002101600480.14152@obet.zrqbmnf.qr>
References: <20100208140837.GN1025@kernel.dk>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


the perf top -a dumps:


Light fs activity (/bin/rm old build roots)
------------------------------------------------------------------------------
   PerfTop:    4800 irqs/sec  kernel:94.1% [100000 cycles],  (all, 24 CPUs)
------------------------------------------------------------------------------
            12352.00 - 17.7% : __lock_acquire
             4975.00 -  7.1% : lock_release_holdtime
             4793.00 -  6.9% : lock_release
             3586.00 -  5.1% : lock_acquired
             3544.00 -  5.1% : stick_get_tick
             2245.00 -  3.2% : sched_clock
             1938.00 -  2.8% : sched_clock_cpu
             1851.00 -  2.7% : lock_acquire
             1800.00 -  2.6% : tl0_linux64
             1475.00 -  2.1% : ext4_mark_iloc_dirty
             1041.00 -  1.5% : fget_light
             1035.00 -  1.5% : find_busiest_group
              977.00 -  1.4% : getnstimeofday
              939.00 -  1.3% : do_sys_poll
              926.00 -  1.3% : perf_poll

(Starting real work - file creation etc - now)

Calling sync a minute later when Dirty > 200MB in /proc/meminfo:
------------------------------------------------------------------------------
   PerfTop:   28822 irqs/sec  kernel:22.2% [100000 cycles],  (all, 24 CPUs)
------------------------------------------------------------------------------
             samples    pcnt   kernel function
             _______   _____   _______________

            22952.00 - 14.9% : __lock_acquire
             9142.00 -  5.9% : lock_release_holdtime
             8881.00 -  5.8% : stick_get_tick
             8375.00 -  5.4% : lock_release
             7401.00 -  4.8% : lock_acquired
             5522.00 -  3.6% : tl0_linux64
             4325.00 -  2.8% : sched_clock
             3634.00 -  2.4% : ext4_rec_len_from_disk
             3600.00 -  2.3% : sched_clock_cpu
             3261.00 -  2.1% : lock_acquire
             3012.00 -  2.0% : NGcopy_to_user
             2988.00 -  1.9% : ext4_check_dir_entry
             2909.00 -  1.9% : getnstimeofday
             2010.00 -  1.3% : __delay
             1915.00 -  1.2% : cpu_clock

Stopping all write processes so that sync can complete:

------------------------------------------------------------------------------
   PerfTop:    2679 irqs/sec  kernel:92.6% [100000 cycles],  (all, 24 CPUs)
------------------------------------------------------------------------------
             samples    pcnt   kernel function
             _______   _____   _______________

             6102.00 - 19.7% : __lock_acquire
             2504.00 -  8.1% : lock_release_holdtime
             2346.00 -  7.6% : lock_release
             1685.00 -  5.5% : stick_get_tick
             1532.00 -  5.0% : lock_acquired
             1135.00 -  3.7% : sched_clock
             1068.00 -  3.5% : find_busiest_group
             1034.00 -  3.3% : sched_clock_cpu
             1023.00 -  3.3% : tl0_linux64
              832.00 -  2.7% : lock_acquire
              658.00 -  2.1% : fget_light
              656.00 -  2.1% : perf_poll
              629.00 -  2.0% : journal_clean_one_cp_list
              572.00 -  1.9% : find_next_bit
              525.00 -  1.7% : getnstimeofday
------------------------------------------------------------------------------
   PerfTop:    3182 irqs/sec  kernel:90.5% [100000 cycles],  (all, 24 CPUs)
------------------------------------------------------------------------------
             samples    pcnt   kernel function
             _______   _____   _______________

             9076.00 - 19.9% : __lock_acquire
             3702.00 -  8.1% : lock_release_holdtime
             3420.00 -  7.5% : lock_release
             2522.00 -  5.5% : stick_get_tick
             2198.00 -  4.8% : lock_acquired
             1700.00 -  3.7% : sched_clock
             1539.00 -  3.4% : find_busiest_group
             1507.00 -  3.3% : sched_clock_cpu
             1402.00 -  3.1% : tl0_linux64
             1277.00 -  2.8% : lock_acquire
             1089.00 -  2.4% : journal_clean_one_cp_list
             1085.00 -  2.4% : fget_light
             1004.00 -  2.2% : perf_poll
              860.00 -  1.9% : do_sys_poll
              782.00 -  1.7% : find_next_bit

There's that journal_clean_one_cp_list thing ..


I have a gut feeling that sys_sync just waits until all data has been
flushed. That however won't fly, because there's always new dirty data
arriving when the box is not idle.

Of course I am not calling /bin/sync on purpose, but some software
packages do; rrdtool for example has an autoconf runtime
check for fsync(2), so it's inevitable that sync is called at some
point by something.


I also did

# perf top -a -k vmlinux-... -p $(that pid of jbd2-sda6)
------------------------------------------------------------------------------
   PerfTop:     105 irqs/sec  kernel:100.0% [100000 cycles],  (target_pid: 574)
------------------------------------------------------------------------------
             samples    pcnt   kernel function
             _______   _____   _______________

               42.00 - 12.8% : journal_clean_one_cp_list
               34.00 - 10.4% : __lock_acquire
               33.00 - 10.1% : __jbd2_journal_clean_checkpoint_list
               28.00 -  8.5% : find_busiest_group
               20.00 -  6.1% : clear_bit
               16.00 -  4.9% : lock_release
               16.00 -  4.9% : stick_get_tick
               14.00 -  4.3% : test_and_set_bit
               13.00 -  4.0% : lock_release_holdtime
               12.00 -  3.7% : lock_acquired
                9.00 -  2.7% : find_next_bit
                7.00 -  2.1% : lock_acquire
                7.00 -  2.1% : jbd2_journal_write_revoke_records
                6.00 -  1.8% : jbd2_journal_switch_revoke_table
                6.00 -  1.8% : cpu_clock
