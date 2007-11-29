Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbXK2CoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbXK2CoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbXK2CoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:44:15 -0500
Received: from www.poetrypoetry.com ([64.135.207.42]:33335 "EHLO
	www.poetrypoetry.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXK2CoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:44:08 -0500
Message-ID: <46738.67.173.156.207.1196304247.squirrel@www.techfinesse.net>
Date: Wed, 28 Nov 2007 20:44:07 -0600 (CST)
Subject: Dynticks Causing High Context Switch Rate in ksoftirqd
From: bdupree@techfinesse.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20071128204407_68906"
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20071128204407_68906
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

I built the same dynticks-enabled 2.6.23.9 kernel on a nearly identical
system with minor changes to reflect the slightly different hardware.
These two systems have identical MSI E7210 MasterX FA6R motherboards (same
model and revision.) The differences are as follows:

behemoth (using Slackware 10.2)
-----------------------------------------------------------------
dual 2.4 GHz Xeons 400 MHz FSB
LSI 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI
Newer SATA/PATA Intel PIIX drivers

titan (using Slackware 11.0)
-----------------------------------------------------------------
dual 2.0 GHz Xeons 533 MHz FSB
Creative Labs SB Audigy LS (using ALSA driver)
Older IDE PATA Intel PIIX drivers

The result is that "behemoth" continues to exhibit 155,000 context
switches per second at idle while "titan" shows about 25 - 30 context
switches per second. Note that motherboard BIOS'es are at the same
revision and configured identically.

I guess (ugh) it's time for me to pull the MPT-Fusion U320 HBA and the
SATA disks out of "behemoth" and configure it with old style IDE drives to
be as close as possible to "titan." Then I can add parts back and see when
the problem occurs.

Best regards,

--Bill DuPree

P.S. See attachment for config details and other data.



------=_20071128204407_68906
Content-Type: text/plain; name="config_info.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="config_info.txt"

Question: Why is ksoftirqd eating about 5 to 10 percent of my CPU on an idle 
system? The problem goes away if I config the kernel without tickless
support (i.e. CONFIG_TICK_ONESHOT=n).  (Thanks to "oprofile" for putting me
onto this.)

I have noted this same problem on (vanilla) kernel versions: 2.6.23.1, 2.6.23.8 
and 2.6.23.9

**************************************************************************
*** Output from "vmstat -n 1 10" -- Note very high context switch rate *** 
*** This is on a idle machine!                                         ***
**************************************************************************

procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0      0 1925556   4768 116104    0    0   124     2    6  7538  1  2 96  1
 0  0      0 1925556   4768 116104    0    0     0     0    2 147329  0  1 99  0
 0  0      0 1925548   4768 116104    0    0     0     0    0 154515  0  1 99  0
 0  0      0 1925548   4768 116104    0    0     0     0    1 153898  0  2 98  0
 0  0      0 1925548   4780 116104    0    0     0    16    3 155216  0  1 99  0
 0  0      0 1925548   4780 116104    0    0     0     0    1 161718  0  1 99  0
 0  0      0 1925548   4780 116104    0    0     0     0    0 147587  0  2 98  0
 0  0      0 1925548   4780 116104    0    0     0     0    1 153524  0  2 98  0
 0  0      0 1925448   4780 116104    0    0     0     0    0 153434  0  1 99  0
 0  0      0 1925448   4792 116092    0    0     0    16    4 153527  0  2 98  0

****************************
*** Output from PowerTop ***
****************************

     PowerTOP version 1.9       (C) 2007 Intel Corporation

                                      P-states (frequencies)
                                        2.40 Ghz   100.0%
                                         900 Mhz     0.0%
                                         600 Mhz     0.0%
                                         300 Mhz     0.0%
< Detailed C-state information is only available on Mobile CPUs (laptops) >

Wakeups-from-idle per second : 29.1     interval: 3.0s


Top causes for wakeups:
  50.6% ( 26.0)          ifconfig : br_stp_enable_bridge (br_hello_timer_expired)
  15.6% (  8.0)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func)
  11.0% (  5.7)          postgres : schedule_timeout (process_timeout)
   3.9% (  2.0)     <kernel core> : br_transmit_config (br_hold_timer_expired)
   3.9% (  2.0)     <kernel core> : clocksource_check_watchdog (clocksource_watchdog)
   1.9% (  1.0)          ifconfig : br_stp_enable_bridge (br_fdb_cleanup)
   1.9% (  1.0)          sshutout : do_nanosleep (hrtimer_wakeup)
   1.9% (  1.0)             httpd : schedule_timeout (process_timeout)
   1.9% (  1.0)     <kernel core> : edac_pci_add_device (delayed_work_timer_fn)
   1.9% (  1.0)     <kernel core> : edac_mc_add_mc (delayed_work_timer_fn)
   1.3% (  0.7)       <interrupt> : libata, eth0
   0.6% (  0.3)   <kernel module> : neigh_table_init_no_netlink (neigh_periodic_timer)
   0.6% (  0.3)     <kernel core> : e1000_intr (e1000_watchdog)
   0.6% (  0.3)     <kernel core> : page_writeback_init (wb_timer_fn)
   0.6% (  0.3)     <kernel core> : init_nonfatal_mce_checker (delayed_work_timer_fn)


*******************************************************************
*** Yes, I am using network bridging as I oftem run one or more ***
*** User Mode Linux virtual hosts on the server. No virtual     ***
*** hosts were running at the time, though.  My network config  ***
*** is as follows:                                              ***
*******************************************************************

br0       Link encap:Ethernet  HWaddr 00:11:09:3D:96:BF  
          inet addr:10.10.224.24  Bcast:10.10.224.255  Mask:255.255.255.0
          inet6 addr: fe80::211:9ff:fe3d:96bf/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3954 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3701 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:376810 (367.9 Kb)  TX bytes:787818 (769.3 Kb)

br0:0     Link encap:Ethernet  HWaddr 00:11:09:3D:96:BF  
          inet addr:10.10.224.25  Bcast:10.10.224.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

br0:1     Link encap:Ethernet  HWaddr 00:11:09:3D:96:BF  
          inet addr:10.10.224.26  Bcast:10.10.224.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

br0:2     Link encap:Ethernet  HWaddr 00:11:09:3D:96:BF  
          inet addr:10.10.224.27  Bcast:10.10.224.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

eth0      Link encap:Ethernet  HWaddr 00:11:09:3D:96:BF  
          inet6 addr: fe80::211:9ff:fe3d:96bf/64 Scope:Link
          UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
          RX packets:3952 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3706 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100 
          RX bytes:447794 (437.2 Kb)  TX bytes:803086 (784.2 Kb)
          Base address:0xb000 Memory:fa800000-fa820000 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:1 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:29 (29.0 b)  TX bytes:29 (29.0 b)

tap0      Link encap:Ethernet  HWaddr 00:FF:62:45:A1:57  
          inet6 addr: fe80::2ff:62ff:fe45:a157/64 Scope:Link
          UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:75 overruns:0 carrier:0
          collisions:0 txqueuelen:500 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)


*******************************************************
*** oprofile output (60 sec. at idle) - global view ***
*** detail shown below                              ***
*******************************************************

CPU: P4 / Xeon with 2 hyper-threads, speed 2400 MHz (estimated)
Counted GLOBAL_POWER_EVENTS events (time during which processor is not stopped) with a unit mask of 0x01 (mandatory) count 100000
GLOBAL_POWER_E...|
  samples|      %|
------------------
   203826 98.3583 vmlinux-2.6.23.9
     1633  0.7880 oprofiled
      690  0.3330 oprofile
      353  0.1703 libc-2.3.5.so
      340  0.1641 bash
       85  0.0410 jfs
       79  0.0381 ld-2.3.5.so
       66  0.0318 ISO8859-1.so
       39  0.0188 postgres
       35  0.0169 e1000
       35  0.0169 uhci_hcd
       19  0.0092 bridge
        5  0.0024 libcrypto.so.0.9.7
        5  0.0024 sendmail
        4  0.0019 httpd
        3  0.0014 gawk-3.1.5
        3  0.0014 init
        3  0.0014 sshd
        2 9.7e-04 grep
        2 9.7e-04 sshutout
        1 4.8e-04 crond


*******************************************************
*** oprofile output (60 sec. at idle) - detail view ***
*******************************************************

CPU: P4 / Xeon with 2 hyper-threads, speed 2400 MHz (estimated)
Counted GLOBAL_POWER_EVENTS events (time during which processor is not stopped) with a unit mask of 0x01 (mandatory) count 100000
samples  %        linenr info                 image name               app name                 symbol name
27164    13.1083  sched.c:2312                vmlinux-2.6.23.9         vmlinux-2.6.23.9         find_busiest_group
9714      4.6876  bitops.h:246                vmlinux-2.6.23.9         vmlinux-2.6.23.9         unsynchronized_tsc
9626      4.6451  process.c:850               vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_set_thread_area
5988      2.8896  sched_rt.c:40               vmlinux-2.6.23.9         vmlinux-2.6.23.9         dequeue_task_rt
5410      2.6107  sched_rt.c:109              vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance_start_rt
5302      2.5585  sched_rt.c:135              vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance_next_rt
5296      2.5556  current.h:12                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_getuid
5152      2.4862  softirq.c:121               vmlinux-2.6.23.9         vmlinux-2.6.23.9         _local_bh_enable
5093      2.4577  sched_rt.c:77               vmlinux-2.6.23.9         vmlinux-2.6.23.9         pick_next_task_rt
4961      2.3940  sched.c:676                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         calc_delta_mine
4492      2.1677  sched.c:1220                vmlinux-2.6.23.9         vmlinux-2.6.23.9         find_idlest_group
4300      2.0750  (no location information)   vmlinux-2.6.23.9         vmlinux-2.6.23.9         csum_partial_copy_generic
4046      1.9524  common.c:89                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_model_name
3840      1.8530  sched_rt.c:178              vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance_rt
3813      1.8400  common.c:66                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         default_init
3590      1.7324  softirq.c:319               vmlinux-2.6.23.9         vmlinux-2.6.23.9         raise_softirq_irqoff
3504      1.6909  idr.c:119                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         sub_alloc
3497      1.6875  tick-sched.c:315            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_nohz_restart_sched_tick
3445      1.6624  timekeeping.c:153           vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_settimeofday
3342      1.6127  timekeeping.c:192           vmlinux-2.6.23.9         vmlinux-2.6.23.9         change_clocksource
3332      1.6079  softirq.c:423               vmlinux-2.6.23.9         vmlinux-2.6.23.9         tasklet_hi_action
3217      1.5524  common.c:181                vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_cpu_vendor
3207      1.5476  tick-sched.c:493            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_sched_timer
2840      1.3705  sched.c:3109                vmlinux-2.6.23.9         vmlinux-2.6.23.9         run_rebalance_domains
2692      1.2991  sched.c:630                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         resched_cpu
2630      1.2691  hrtimer.c:417               vmlinux-2.6.23.9         vmlinux-2.6.23.9         retrigger_next_event
2596      1.2527  sched_fair.c:658            vmlinux-2.6.23.9         vmlinux-2.6.23.9         enqueue_entity
2395      1.1557  sched_fair.c:501            vmlinux-2.6.23.9         vmlinux-2.6.23.9         update_stats_wait_end
2310      1.1147  sched.c:1943                vmlinux-2.6.23.9         vmlinux-2.6.23.9         nr_context_switches
2146      1.0356  sched_fair.c:697            vmlinux-2.6.23.9         vmlinux-2.6.23.9         __check_preempt_curr_fair
2028      0.9786  sched.c:1075                vmlinux-2.6.23.9         vmlinux-2.6.23.9         wait_task_inactive
1987      0.9588  tick-sched.c:382            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_nohz_reprogram
1834      0.8850  softirq.c:390               vmlinux-2.6.23.9         vmlinux-2.6.23.9         tasklet_action
1756      0.8474  sched_idletask.c:29         vmlinux-2.6.23.9         vmlinux-2.6.23.9         dequeue_task_idle
1628      0.7856  sched_fair.c:559            vmlinux-2.6.23.9         vmlinux-2.6.23.9         __enqueue_sleeper
1599      0.7716  sched_fair.c:673            vmlinux-2.6.23.9         vmlinux-2.6.23.9         dequeue_entity
1587      0.7658  params.c:54                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         parse_one
1543      0.7446  hrtimer.c:457               vmlinux-2.6.23.9         vmlinux-2.6.23.9         clock_was_set
1519      0.7330  sched_fair.c:923            vmlinux-2.6.23.9         vmlinux-2.6.23.9         yield_task_fair
1482      0.7152  sched.c:648                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         div64_likely32
1482      0.7152  timer.c:885                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         run_timer_softirq
1457      0.7031  sched.c:2983                vmlinux-2.6.23.9         vmlinux-2.6.23.9         select_nohz_load_balancer
1404      0.6775  delay.c:31                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         delay_loop
1319      0.6365  sched_debug.c:88            vmlinux-2.6.23.9         vmlinux-2.6.23.9         print_cfs_rq_runtime_sum
1301      0.6278  sched_fair.c:598            vmlinux-2.6.23.9         vmlinux-2.6.23.9         enqueue_sleeper
1295      0.6249  sched_debug.c:60            vmlinux-2.6.23.9         vmlinux-2.6.23.9         print_rq
1208      0.5829  sched.c:2637                vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance
1189      0.5738  sched_fair.c:1164           vmlinux-2.6.23.9         vmlinux-2.6.23.9         task_new_fair
1113      0.5371  resource.c:281              vmlinux-2.6.23.9         vmlinux-2.6.23.9         find_resource
1095      0.5284  sched_fair.c:755            vmlinux-2.6.23.9         vmlinux-2.6.23.9         put_prev_entity
1086      0.5241  sched.c:2598                vmlinux-2.6.23.9         vmlinux-2.6.23.9         find_busiest_queue
983       0.4744  sched.c:4181                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sched_setscheduler
982       0.4739  sched_fair.c:1093           vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance_fair
947       0.4570  process.c:301               vmlinux-2.6.23.9         vmlinux-2.6.23.9         show_regs
928       0.4478  timer.c:1110                vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_sysinfo
923       0.4454  sched.c:1983                vmlinux-2.6.23.9         vmlinux-2.6.23.9         update_cpu_load
916       0.4420  list.h:31                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         __sched_fork
900       0.4343  sched_fair.c:771            vmlinux-2.6.23.9         vmlinux-2.6.23.9         entity_tick
860       0.4150  sched_rt.c:29               vmlinux-2.6.23.9         vmlinux-2.6.23.9         enqueue_task_rt
825       0.3981  sched.c:609                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         resched_task
806       0.3889  softirq.c:588               vmlinux-2.6.23.9         vmlinux-2.6.23.9         cpu_callback
803       0.3875  sched_fair.c:980            vmlinux-2.6.23.9         vmlinux-2.6.23.9         check_preempt_curr_fair
716       0.3455  softirq.c:651               vmlinux-2.6.23.9         vmlinux-2.6.23.9         on_each_cpu
690       0.3330  (no location information)   oprofile                 oprofile                 (no symbols)
652       0.3146  sched_fair.c:886            vmlinux-2.6.23.9         vmlinux-2.6.23.9         enqueue_task_fair
583       0.2813  sched_fair.c:904            vmlinux-2.6.23.9         vmlinux-2.6.23.9         dequeue_task_fair
562       0.2712  sched.c:1159                vmlinux-2.6.23.9         vmlinux-2.6.23.9         kick_process
542       0.2615  params.c:78                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         next_arg
534       0.2577  kthread.c:222               vmlinux-2.6.23.9         vmlinux-2.6.23.9         kthreadd
530       0.2558  thread_info.h:93            vmlinux-2.6.23.9         vmlinux-2.6.23.9         irq_exit
488       0.2355  rwsem.c:152                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         rwsem_down_failed_common
442       0.2133  sched_fair.c:389            vmlinux-2.6.23.9         vmlinux-2.6.23.9         update_curr
420       0.2027  hrtimer.c:465               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hres_timers_resume
418       0.2017  tick-sched.c:391            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_nohz_handler
410       0.1978  rwsem.c:220                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         rwsem_wake
398       0.1921  sched.c:1926                vmlinux-2.6.23.9         vmlinux-2.6.23.9         nr_uninterruptible
397       0.1916  sched_fair.c:1004           vmlinux-2.6.23.9         vmlinux-2.6.23.9         pick_next_task_fair
345       0.1665  rbtree.c:354                vmlinux-2.6.23.9         vmlinux-2.6.23.9         rb_prev
340       0.1641  (no location information)   bash                     bash                     (no symbols)
333       0.1607  opd_trans.c:52              oprofiled                oprofiled                pop_buffer_value
332       0.1602  sched.c:1426                vmlinux-2.6.23.9         vmlinux-2.6.23.9         try_to_wake_up
278       0.1342  sched_fair.c:746            vmlinux-2.6.23.9         vmlinux-2.6.23.9         pick_next_entity
270       0.1303  process.c:836               vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_free_idx
259       0.1250  sched_idletask.c:37         vmlinux-2.6.23.9         vmlinux-2.6.23.9         put_prev_task_idle
254       0.1226  sched.c:1045                vmlinux-2.6.23.9         vmlinux-2.6.23.9         migrate_task
241       0.1163  fork.c:484                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         dup_mm
238       0.1148  rbtree.c:225                vmlinux-2.6.23.9         vmlinux-2.6.23.9         rb_erase
227       0.1095  div64.c:63                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         div64_64
222       0.1071  db_insert.c:53              oprofiled                oprofiled                odb_update_node
198       0.0955  sched.c:1916                vmlinux-2.6.23.9         vmlinux-2.6.23.9         nr_running
192       0.0927  string.c:223                vmlinux-2.6.23.9         vmlinux-2.6.23.9         memscan
183       0.0883  current.h:12                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_getppid
181       0.0873  hrtimer.c:1331              vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_nanosleep
179       0.0864  sched_fair.c:333            vmlinux-2.6.23.9         vmlinux-2.6.23.9         add_wait_runtime
177       0.0854  opd_kernel.c:209            oprofiled                oprofiled                find_kernel_image
174       0.0840  sched_fair.c:1066           vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance_next_fair
158       0.0762  timer.c:1212                vmlinux-2.6.23.9         vmlinux-2.6.23.9         init_timers_cpu
155       0.0748  timer.c:920                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_timer
142       0.0685  sched_debug.c:33            vmlinux-2.6.23.9         vmlinux-2.6.23.9         print_task
141       0.0680  tick-sched.c:558            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_setup_sched_timer
129       0.0623  softirq.c:102               vmlinux-2.6.23.9         vmlinux-2.6.23.9         __local_bh_enable
127       0.0613  hrtimer.c:1412              vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_cpu_notify
124       0.0598  opd_trans.c:86              oprofiled                oprofiled                opd_put_sample
117       0.0565  opd_sfile.c:215             oprofiled                oprofiled                sfile_find
109       0.0526  opd_trans.c:281             oprofiled                oprofiled                opd_process_samples
107       0.0516  sched.c:518                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         task_rq_lock
99        0.0478  current.h:12                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_geteuid
98        0.0473  opd_sfile.c:419             oprofiled                oprofiled                sfile_log_sample
98        0.0473  memory.c:1958               vmlinux-2.6.23.9         vmlinux-2.6.23.9         unmap_mapping_range
97        0.0468  sched_rt.c:71               vmlinux-2.6.23.9         vmlinux-2.6.23.9         check_preempt_curr_rt
85        0.0410  (no location information)   jfs                      jfs                      (no symbols)
84        0.0405  opd_sfile.c:290             oprofiled                oprofiled                get_file
82        0.0396  traps.c:236                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         show_trace_log_lvl
80        0.0386  thread_info.h:93            vmlinux-2.6.23.9         vmlinux-2.6.23.9         irq_enter
79        0.0381  current.h:12                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_getgid
73        0.0352  iomap.c:217                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         iowrite16_rep
72        0.0347  db_manage.c:284             oprofiled                oprofiled                odb_open_count
64        0.0309  softirq.c:347               vmlinux-2.6.23.9         vmlinux-2.6.23.9         open_softirq
63        0.0304  (no location information)   ISO8859-1.so             ISO8859-1.so             gconv
62        0.0299  opd_sfile.c:42              oprofiled                oprofiled                sfile_hash
61        0.0294  sched_idletask.c:50         vmlinux-2.6.23.9         vmlinux-2.6.23.9         task_tick_idle
60        0.0290  (no location information)   libc-2.3.5.so            libc-2.3.5.so            mbrtowc
60        0.0290  softirq.c:338               vmlinux-2.6.23.9         vmlinux-2.6.23.9         raise_softirq
52        0.0251  (no location information)   vmlinux-2.6.23.9         vmlinux-2.6.23.9         irq_entries_start
49        0.0236  tick-sched.c:152            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_nohz_stop_sched_tick
48        0.0232  opd_trans.c:143             oprofiled                oprofiled                code_ctx_switch
47        0.0227  opd_sfile.c:84              oprofiled                oprofiled                do_match
44        0.0212  iomap.c:258                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         pci_iomap
41        0.0198  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strcmp
39        0.0188  hrtimer.c:1193              vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_run_queues
38        0.0183  opd_sfile.c:123             oprofiled                oprofiled                trans_match
37        0.0179  slub.c:1964                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         calculate_sizes
35        0.0169  (no location information)   e1000                    e1000                    (no symbols)
35        0.0169  (no location information)   uhci_hcd                 uhci_hcd                 (no symbols)
32        0.0154  page_alloc.c:781            vmlinux-2.6.23.9         vmlinux-2.6.23.9         free_hot_cold_page
31        0.0150  opd_trans.c:45              oprofiled                oprofiled                clear_trans_current
31        0.0150  sched.c:4293                vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_sched_setscheduler
29        0.0140  opd_trans.c:75              oprofiled                oprofiled                enough_remaining
26        0.0125  timer.c:681                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __next_timer_interrupt
25        0.0121  (no location information)   ld-2.3.5.so              ld-2.3.5.so              do_lookup_x
24        0.0116  (no location information)   postgres                 postgres                 SyncOneBuffer
24        0.0116  memory.c:813                vmlinux-2.6.23.9         vmlinux-2.6.23.9         unmap_vmas
24        0.0116  memory.c:623                vmlinux-2.6.23.9         vmlinux-2.6.23.9         zap_pte_range
22        0.0106  filemap.c:867               vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_generic_mapping_read
22        0.0106  timer_stats.c:346           vmlinux-2.6.23.9         vmlinux-2.6.23.9         sync_access
22        0.0106  clocksource.c:424           vmlinux-2.6.23.9         vmlinux-2.6.23.9         sysfs_show_available_clocksources
20        0.0097  rmap.c:769                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         try_to_unmap_cluster
18        0.0087  page_alloc.c:1238           vmlinux-2.6.23.9         vmlinux-2.6.23.9         __alloc_pages
18        0.0087  hrtimer.c:556               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_switch_to_hres
18        0.0087  sched.c:3947                vmlinux-2.6.23.9         vmlinux-2.6.23.9         rt_mutex_setprio
17        0.0082  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strlen
17        0.0082  opd_sfile.c:607             oprofiled                oprofiled                sfile_put
17        0.0082  sched.c:327                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __update_rq_clock
17        0.0082  memory.c:2638               vmlinux-2.6.23.9         vmlinux-2.6.23.9         handle_mm_fault
17        0.0082  posix-cpu-timers.c:49       vmlinux-2.6.23.9         vmlinux-2.6.23.9         sample_to_timespec
16        0.0077  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __i686.get_pc_thunk.bx
16        0.0077  (no location information)   libc-2.3.5.so            libc-2.3.5.so            memcpy
16        0.0077  opd_sfile.c:600             oprofiled                oprofiled                sfile_get
16        0.0077  hrtimer.c:1008              vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_interrupt
16        0.0077  hrtimer.c:1092              vmlinux-2.6.23.9         vmlinux-2.6.23.9         run_hrtimer_softirq
16        0.0077  scsi_lib.c:1710             vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_mode_select
15        0.0072  handle.c:30                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         handle_bad_irq
15        0.0072  idr.c:185                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         idr_get_empty_slot
15        0.0072  smp.c:554                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         native_smp_call_function_mask
15        0.0072  apic.c:853                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         setup_local_APIC
14        0.0068  namei.c:812                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __link_path_walk
14        0.0068  filemap.c:711               vmlinux-2.6.23.9         vmlinux-2.6.23.9         find_get_pages
14        0.0068  filemap.c:667               vmlinux-2.6.23.9         vmlinux-2.6.23.9         find_or_create_page
14        0.0068  filemap.c:801               vmlinux-2.6.23.9         vmlinux-2.6.23.9         grab_cache_page_nowait
14        0.0068  mmap.c:1734                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         unmap_region
14        0.0068  latency.c:265               vmlinux-2.6.23.9         vmlinux-2.6.23.9         unregister_latency_notifier
13        0.0063  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _dl_mcount_wrapper_check
13        0.0063  nsproxy.c:63                vmlinux-2.6.23.9         vmlinux-2.6.23.9         create_new_namespaces
13        0.0063  hrtimer.c:636               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_forward
13        0.0063  dcache.c:1474               vmlinux-2.6.23.9         vmlinux-2.6.23.9         switch_names
12        0.0058  (no location information)   ld-2.3.5.so              ld-2.3.5.so              strcmp
12        0.0058  memory.c:2823               vmlinux-2.6.23.9         vmlinux-2.6.23.9         access_process_vm
12        0.0058  sched.c:4045                vmlinux-2.6.23.9         vmlinux-2.6.23.9         can_nice
12        0.0058  sched.c:3708                vmlinux-2.6.23.9         vmlinux-2.6.23.9         complete
12        0.0058  dcache.c:1530               vmlinux-2.6.23.9         vmlinux-2.6.23.9         d_move_locked
12        0.0058  tick-common.c:103           vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_setup_periodic
11        0.0053  (no location information)   libc-2.3.5.so            libc-2.3.5.so            insert_module
11        0.0053  (no location information)   libc-2.3.5.so            libc-2.3.5.so            memset
11        0.0053  timer.c:753                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         cmp_next_hrtimer_event
11        0.0053  fault.c:303                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_page_fault
10        0.0048  memory.c:2500               vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_no_pfn
10        0.0048  oom_kill.c:209              vmlinux-2.6.23.9         vmlinux-2.6.23.9         select_bad_process
10        0.0048  timer_stats.c:168           vmlinux-2.6.23.9         vmlinux-2.6.23.9         tstat_lookup
9         0.0043  namei.c:1106                vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_path_lookup
9         0.0043  hrtimer.c:921               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_get_next_event
9         0.0043  tick-common.c:78            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_handle_periodic
8         0.0039  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_elf_hash
8         0.0039  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _dl_addr
8         0.0039  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _int_malloc
8         0.0039  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strcpy
8         0.0039  swap.c:441                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         pagevec_lookup
8         0.0039  scsi_lib.c:656              vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_end_request
8         0.0039  sched.c:3989                vmlinux-2.6.23.9         vmlinux-2.6.23.9         set_user_nice
8         0.0039  filemap.c:1644              vmlinux-2.6.23.9         vmlinux-2.6.23.9         should_remove_suid
8         0.0039  vmstat.c:539                vmlinux-2.6.23.9         vmlinux-2.6.23.9         zoneinfo_show
7         0.0034  (no location information)   libc-2.3.5.so            libc-2.3.5.so            memchr
7         0.0034  (no location information)   libc-2.3.5.so            libc-2.3.5.so            vfprintf
7         0.0034  exit.c:77                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         __exit_signal
7         0.0034  fork.c:966                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         copy_process
7         0.0034  select.c:308                vmlinux-2.6.23.9         vmlinux-2.6.23.9         core_sys_select
7         0.0034  softirq.c:491               vmlinux-2.6.23.9         vmlinux-2.6.23.9         ksoftirqd
7         0.0034  prio_tree.c:265             vmlinux-2.6.23.9         vmlinux-2.6.23.9         prio_tree_remove
7         0.0034  scsi_lib.c:818              vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_io_completion
7         0.0034  workqueue.c:441             vmlinux-2.6.23.9         vmlinux-2.6.23.9         wait_on_work
6         0.0029  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_relocate_object
6         0.0029  (no location information)   libc-2.3.5.so            libc-2.3.5.so            ___newselect_nocancel
6         0.0029  (no location information)   libc-2.3.5.so            libc-2.3.5.so            add_alias
6         0.0029  (no location information)   libc-2.3.5.so            libc-2.3.5.so            add_module
6         0.0029  (no location information)   libc-2.3.5.so            libc-2.3.5.so            sigprocmask
6         0.0029  (no location information)   postgres                 postgres                 BgBufferSync
6         0.0029  mmap.c:461                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __insert_vm_struct
6         0.0029  kfifo.c:121                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __kfifo_put
6         0.0029  filemap.c:1498              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __read_cache_page
6         0.0029  posix-cpu-timers.c:1418     vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_cpu_nanosleep
6         0.0029  memory.c:1638               vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_wp_page
6         0.0029  hrtimer.c:804               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_start
6         0.0029  ll_rw_blk.c:1461            vmlinux-2.6.23.9         vmlinux-2.6.23.9         ll_front_merge_fn
6         0.0029  namei.c:1362                vmlinux-2.6.23.9         vmlinux-2.6.23.9         lookup_one_len
6         0.0029  filemap.c:837               vmlinux-2.6.23.9         vmlinux-2.6.23.9         shrink_readahead_size_eio
6         0.0029  softirq.c:469               vmlinux-2.6.23.9         vmlinux-2.6.23.9         tasklet_kill
6         0.0029  memory.c:752                vmlinux-2.6.23.9         vmlinux-2.6.23.9         unmap_page_range
6         0.0029  workqueue.c:281             vmlinux-2.6.23.9         vmlinux-2.6.23.9         worker_thread
5         0.0024  br_stp.c:318                bridge.ko                bridge                   br_config_bpdu_generation
5         0.0024  (no location information)   libc-2.3.5.so            libc-2.3.5.so            mempcpy
5         0.0024  (no location information)   libcrypto.so.0.9.7       libcrypto.so.0.9.7       (no symbols)
5         0.0024  (no location information)   sendmail                 sendmail                 (no symbols)
5         0.0024  usercopy.c:718              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __copy_to_user_ll
5         0.0024  fork.c:639                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         alloc_files
5         0.0024  timer.c:594                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         cascade
5         0.0024  memory.c:586                vmlinux-2.6.23.9         vmlinux-2.6.23.9         copy_page_range
5         0.0024  sched.c:389                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         cpu_clock
5         0.0024  ll_rw_blk.c:3634            vmlinux-2.6.23.9         vmlinux-2.6.23.9         end_that_request_last
5         0.0024  workqueue.c:374             vmlinux-2.6.23.9         vmlinux-2.6.23.9         flush_workqueue
5         0.0024  hrtimer.c:858               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_try_to_cancel
5         0.0024  buffer.c:2426               vmlinux-2.6.23.9         vmlinux-2.6.23.9         nobh_writepage
5         0.0024  swap.c:257                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         release_pages
5         0.0024  scsi.c:469                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_dispatch_cmd
5         0.0024  ntp.c:92                    vmlinux-2.6.23.9         vmlinux-2.6.23.9         second_overflow
5         0.0024  workqueue.c:425             vmlinux-2.6.23.9         vmlinux-2.6.23.9         wait_on_cpu_work
4         0.0019  br_fdb.c:121                bridge.ko                bridge                   br_fdb_cleanup
4         0.0019  (no location information)   httpd                    httpd                    (no symbols)
4         0.0019  (no location information)   ld-2.3.5.so              ld-2.3.5.so              dl_main
4         0.0019  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __gconv_alias_compare
4         0.0019  (no location information)   libc-2.3.5.so            libc-2.3.5.so            anonymous symbol from section .plt
4         0.0019  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strchr
4         0.0019  (no location information)   libc-2.3.5.so            libc-2.3.5.so            tsearch
4         0.0019  (no location information)   postgres                 postgres                 BackgroundWriterMain
4         0.0019  memory.c:2319               vmlinux-2.6.23.9         vmlinux-2.6.23.9         __do_fault
4         0.0019  swap.c:352                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __pagevec_lru_add
4         0.0019  swap.c:379                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __pagevec_lru_add_active
4         0.0019  sched.c:3637                vmlinux-2.6.23.9         vmlinux-2.6.23.9         __wake_up_common
4         0.0019  sched.c:3672                vmlinux-2.6.23.9         vmlinux-2.6.23.9         __wake_up_locked
4         0.0019  slub_def.h:174              vmlinux-2.6.23.9         vmlinux-2.6.23.9         alloc_super
4         0.0019  clocksource.c:156           vmlinux-2.6.23.9         vmlinux-2.6.23.9         clocksource_check_watchdog
4         0.0019  slub.c:2653                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         find_mergeable
4         0.0019  open.c:1174                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         generic_file_open
4         0.0019  hrtimer.c:900               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_get_remaining
4         0.0019  hrtimer.c:961               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_init
4         0.0019  kfifo.c:69                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         kfifo_alloc
4         0.0019  madvise.c:109               vmlinux-2.6.23.9         vmlinux-2.6.23.9         madvise_willneed
4         0.0019  mincore.c:28                vmlinux-2.6.23.9         vmlinux-2.6.23.9         mincore_page
4         0.0019  namei.c:1680                vmlinux-2.6.23.9         vmlinux-2.6.23.9         open_namei
4         0.0019  filemap.c:1587              vmlinux-2.6.23.9         vmlinux-2.6.23.9         read_cache_page
4         0.0019  workqueue.c:528             vmlinux-2.6.23.9         vmlinux-2.6.23.9         schedule_work
4         0.0019  sched.c:3341                vmlinux-2.6.23.9         vmlinux-2.6.23.9         scheduler_tick
4         0.0019  traps.c:243                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         show_trace
4         0.0019  open.c:140                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_statfs64
4         0.0019  open.c:1159                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_vhangup
4         0.0019  sched.c:3242                vmlinux-2.6.23.9         vmlinux-2.6.23.9         task_sched_runtime
4         0.0019  tick-sched.c:443            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_nohz_switch_to_nohz
4         0.0019  tick-common.c:60            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_periodic
4         0.0019  truncate.c:159              vmlinux-2.6.23.9         vmlinux-2.6.23.9         truncate_inode_pages_range
4         0.0019  sched.c:708                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         update_load_sub
3         0.0014  (no location information)   ISO8859-1.so             ISO8859-1.so             __i686.get_pc_thunk.bx
3         0.0014  br_stp_timer.c:37           bridge.ko                bridge                   br_hello_timer_expired
3         0.0014  br_stp_timer.c:134          bridge.ko                bridge                   br_hold_timer_expired
3         0.0014  (no location information)   gawk-3.1.5               gawk-3.1.5               (no symbols)
3         0.0014  (no location information)   init                     init                     (no symbols)
3         0.0014  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_fini
3         0.0014  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __ctype_b_loc
3         0.0014  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _nl_intern_locale_data
3         0.0014  (no location information)   libc-2.3.5.so            libc-2.3.5.so            getenv
3         0.0014  (no location information)   libc-2.3.5.so            libc-2.3.5.so            maybe_split_for_insert
3         0.0014  (no location information)   libc-2.3.5.so            libc-2.3.5.so            mkdir
3         0.0014  opd_trans.c:170             oprofiled                oprofiled                code_cpu_switch
3         0.0014  (no location information)   sshd                     sshd                     (no symbols)
3         0.0014  radix-tree.c:719            vmlinux-2.6.23.9         vmlinux-2.6.23.9         __lookup_tag
3         0.0014  list.h:299                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __put_super_and_need_restart
3         0.0014  scsi.c:923                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __scsi_device_lookup_by_target
3         0.0014  fs-writeback.c:154          vmlinux-2.6.23.9         vmlinux-2.6.23.9         __sync_single_inode
3         0.0014  libata-core.c:5881          vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_flush_cache
3         0.0014  oom_kill.c:52               vmlinux-2.6.23.9         vmlinux-2.6.23.9         badness
3         0.0014  ll_rw_blk.c:3613            vmlinux-2.6.23.9         vmlinux-2.6.23.9         blk_complete_request
3         0.0014  namespace.c:233             vmlinux-2.6.23.9         vmlinux-2.6.23.9         clone_mnt
3         0.0014  signal.c:2055               vmlinux-2.6.23.9         vmlinux-2.6.23.9         copy_siginfo_to_user
3         0.0014  dcache.c:1123               vmlinux-2.6.23.9         vmlinux-2.6.23.9         d_alloc_anon
3         0.0014  timer.c:509                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         del_timer
3         0.0014  dmaengine.c:164             vmlinux-2.6.23.9         vmlinux-2.6.23.9         dma_client_chan_alloc
3         0.0014  namei.c:771                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_lookup
3         0.0014  ll_rw_blk.c:3671            vmlinux-2.6.23.9         vmlinux-2.6.23.9         end_request
3         0.0014  filemap.c:1833              vmlinux-2.6.23.9         vmlinux-2.6.23.9         generic_file_buffered_write
3         0.0014  fs-writeback.c:631          vmlinux-2.6.23.9         vmlinux-2.6.23.9         generic_osync_inode
3         0.0014  swapfile.c:175              vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_swap_page
3         0.0014  super.c:204                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         grab_super
3         0.0014  hrtimer.c:991               vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_get_res
3         0.0014  hrtimer.c:1236              vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_init_sleeper
3         0.0014  workqueue.c:322             vmlinux-2.6.23.9         vmlinux-2.6.23.9         insert_wq_barrier
3         0.0014  binfmt_elf.c:540            vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_elf_binary
3         0.0014  timer_stats.c:155           vmlinux-2.6.23.9         vmlinux-2.6.23.9         match_entries
3         0.0014  sched.c:2265                vmlinux-2.6.23.9         vmlinux-2.6.23.9         move_tasks
3         0.0014  ntp.c:51                    vmlinux-2.6.23.9         vmlinux-2.6.23.9         ntp_update_frequency
3         0.0014  rmap.c:335                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         page_referenced_file
3         0.0014  traps.c:200                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         print_trace_warning_symbol
3         0.0014  prio_tree.c:189             vmlinux-2.6.23.9         vmlinux-2.6.23.9         prio_tree_insert
3         0.0014  rbtree.c:325                vmlinux-2.6.23.9         vmlinux-2.6.23.9         rb_next
3         0.0014  workqueue.c:576             vmlinux-2.6.23.9         vmlinux-2.6.23.9         schedule_on_each_cpu
3         0.0014  sd.c:521                    vmlinux-2.6.23.9         vmlinux-2.6.23.9         sd_open
3         0.0014  irq.c:249                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         show_interrupts
3         0.0014  argv_split.c:10             vmlinux-2.6.23.9         vmlinux-2.6.23.9         skip_sep
3         0.0014  smpboot.c:212               vmlinux-2.6.23.9         vmlinux-2.6.23.9         smp_callin
3         0.0014  open.c:159                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_fstatfs
3         0.0014  ioport.c:59                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_ioperm
3         0.0014  sys.c:667                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_setpriority
3         0.0014  tick-sched.c:128            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tick_nohz_update_jiffies
3         0.0014  mmap.c:490                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         vma_adjust
2        9.7e-04  (no location information)   grep                     grep                     (no symbols)
2        9.7e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_map_object_deps
2        9.7e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_map_object_from_fd
2        9.7e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              uname
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_list_unlock
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __fxstat
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __mpn_lshift
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _int_free
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _nl_expand_alias
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _nl_find_locale
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            brk
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            detect_conflict
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            malloc
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            read
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            read_alias_file
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            read_conf_file
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            stpcpy
2        9.7e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            time
2        9.7e-04  db_manage.c:64              oprofiled                oprofiled                odb_grow_hashtable
2        9.7e-04  (no location information)   postgres                 postgres                 PostmasterIsAlive
2        9.7e-04  (no location information)   sshutout                 sshutout                 (no symbols)
2        9.7e-04  usercopy.c:809              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __copy_from_user_ll_nocache
2        9.7e-04  dcache.c:1630               vmlinux-2.6.23.9         vmlinux-2.6.23.9         __d_unalias
2        9.7e-04  readahead.c:142             vmlinux-2.6.23.9         vmlinux-2.6.23.9         __do_page_cache_readahead
2        9.7e-04  namei.c:678                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __follow_mount
2        9.7e-04  oom_kill.c:278              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __oom_kill_task
2        9.7e-04  rcupdate.c:476              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __rcu_pending
2        9.7e-04  filemap.c:1667              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __remove_suid
2        9.7e-04  fs-writeback.c:523          vmlinux-2.6.23.9         vmlinux-2.6.23.9         __sync_inodes
2        9.7e-04  sched.c:3659                vmlinux-2.6.23.9         vmlinux-2.6.23.9         __wake_up
2        9.7e-04  dcache.c:1097               vmlinux-2.6.23.9         vmlinux-2.6.23.9         _d_rehash
2        9.7e-04  msr-on-cpu.c:68             vmlinux-2.6.23.9         vmlinux-2.6.23.9         _wrmsr_on_cpu
2        9.7e-04  sched.c:3318                vmlinux-2.6.23.9         vmlinux-2.6.23.9         account_steal_time
2        9.7e-04  sched.c:3267                vmlinux-2.6.23.9         vmlinux-2.6.23.9         account_user_time
2        9.7e-04  timer_stats.c:148           vmlinux-2.6.23.9         vmlinux-2.6.23.9         alloc_entry
2        9.7e-04  argv_split.c:70             vmlinux-2.6.23.9         vmlinux-2.6.23.9         argv_split
2        9.7e-04  posix-cpu-timers.c:570      vmlinux-2.6.23.9         vmlinux-2.6.23.9         arm_timer
2        9.7e-04  libata-core.c:5714          vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_interrupt
2        9.7e-04  libata-core.c:5419          vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_qc_issue
2        9.7e-04  libata-scsi.c:3033          vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_scsi_offline_dev
2        9.7e-04  posix-cpu-timers.c:11       vmlinux-2.6.23.9         vmlinux-2.6.23.9         check_clock
2        9.7e-04  timekeeping.c:425           vmlinux-2.6.23.9         vmlinux-2.6.23.9         clocksource_adjust
2        9.7e-04  sched.c:3720                vmlinux-2.6.23.9         vmlinux-2.6.23.9         complete_all
2        9.7e-04  stat.c:189                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         cp_new_stat
2        9.7e-04  api.c:169                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         crypto_alg_lookup
2        9.7e-04  truncate.c:37               vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_invalidatepage
2        9.7e-04  mincore.c:57                vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_mincore
2        9.7e-04  select.c:190                vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_select
2        9.7e-04  read_write.c:456            vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_sync_readv_writev
2        9.7e-04  elevator.c:963              vmlinux-2.6.23.9         vmlinux-2.6.23.9         elv_register
2        9.7e-04  namei.c:434                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         exec_permission_lite
2        9.7e-04  file_table.c:214            vmlinux-2.6.23.9         vmlinux-2.6.23.9         fget_light
2        9.7e-04  memory.c:903                vmlinux-2.6.23.9         vmlinux-2.6.23.9         follow_page
2        9.7e-04  exec.c:1450                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         format_corename
2        9.7e-04  filemap.c:1475              vmlinux-2.6.23.9         vmlinux-2.6.23.9         generic_file_readonly_mmap
2        9.7e-04  page_alloc.c:1152           vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_page_from_freelist
2        9.7e-04  mmu.c:35                    vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_vmalloc_info
2        9.7e-04  hrtimer.c:1295              vmlinux-2.6.23.9         vmlinux-2.6.23.9         hrtimer_nanosleep
2        9.7e-04  ll_rw_blk.c:2891            vmlinux-2.6.23.9         vmlinux-2.6.23.9         init_request_from_bio
2        9.7e-04  inode.c:1413                vmlinux-2.6.23.9         vmlinux-2.6.23.9         init_special_inode
2        9.7e-04  kobject_uevent.c:58         vmlinux-2.6.23.9         vmlinux-2.6.23.9         kobject_uevent_env
2        9.7e-04  timer.c:1270                vmlinux-2.6.23.9         vmlinux-2.6.23.9         migrate_timer_list
2        9.7e-04  posix-cpu-timers.c:1484     vmlinux-2.6.23.9         vmlinux-2.6.23.9         posix_cpu_nsleep
2        9.7e-04  posix-cpu-timers.c:1520     vmlinux-2.6.23.9         vmlinux-2.6.23.9         posix_cpu_nsleep_restart
2        9.7e-04  generic.c:562               vmlinux-2.6.23.9         vmlinux-2.6.23.9         proc_kill_inodes
2        9.7e-04  generic.c:525               vmlinux-2.6.23.9         vmlinux-2.6.23.9         proc_register
2        9.7e-04  pnode.c:172                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         propagate_mnt
2        9.7e-04  sched_rt.c:96               vmlinux-2.6.23.9         vmlinux-2.6.23.9         put_prev_task_rt
2        9.7e-04  namei.c:471                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         real_lookup
2        9.7e-04  file.c:178                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         reiserfs_allocate_blocks_for_region
2        9.7e-04  read_write.c:62             vmlinux-2.6.23.9         vmlinux-2.6.23.9         remote_llseek
2        9.7e-04  timer.c:899                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         run_local_timers
2        9.7e-04  exec.c:1234                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         search_binary_handler
2        9.7e-04  io_apic.c:2506              vmlinux-2.6.23.9         vmlinux-2.6.23.9         set_msi_irq_affinity
2        9.7e-04  page_alloc.c:828            vmlinux-2.6.23.9         vmlinux-2.6.23.9         split_page
2        9.7e-04  mprotect.c:219              vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_mprotect
2        9.7e-04  sys_ni.c:13                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_ni_syscall
2        9.7e-04  select.c:437                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_pselect7
2        9.7e-04  fremap.c:120                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_remap_file_pages
2        9.7e-04  exec.c:128                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_uselib
2        9.7e-04  softirq.c:564               vmlinux-2.6.23.9         vmlinux-2.6.23.9         takeover_tasklets
2        9.7e-04  timekeeping.c:296           vmlinux-2.6.23.9         vmlinux-2.6.23.9         timekeeping_resume
2        9.7e-04  inode.c:1175                vmlinux-2.6.23.9         vmlinux-2.6.23.9         touch_atime
2        9.7e-04  workqueue.c:389             vmlinux-2.6.23.9         vmlinux-2.6.23.9         try_to_grab_pending
2        9.7e-04  rmap.c:657                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         try_to_unmap_one
2        9.7e-04  timer_stats.c:359           vmlinux-2.6.23.9         vmlinux-2.6.23.9         tstats_write
2        9.7e-04  mmap.c:743                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         vma_merge
2        9.7e-04  vsprintf.c:377              vmlinux-2.6.23.9         vmlinux-2.6.23.9         vsnprintf
2        9.7e-04  exit.c:1168                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         wait_task_zombie
1        4.8e-04  br_forward.c:36             bridge.ko                bridge                   br_dev_queue_push_xmit
1        4.8e-04  br_input.c:123              bridge.ko                bridge                   br_handle_frame
1        4.8e-04  br_netfilter.c:510          bridge.ko                bridge                   br_nf_pre_routing
1        4.8e-04  br_stp.c:146                bridge.ko                bridge                   br_transmit_config
1        4.8e-04  (no location information)   crond                    crond                    (no symbols)
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              __i686.get_pc_thunk.bx
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_cache_libcmp
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_catch_error
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_load_cache_lookup
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_map_object
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_new_object
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_runtime_resolve
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_start
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              _dl_sysdep_read_whole_file
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              fixup
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              index
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              match_symbol
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              rtld_lock_default_lock_recursive
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              strlen
1        4.8e-04  (no location information)   ld-2.3.5.so              ld-2.3.5.so              version_check_doit
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_file_fopen@@GLIBC_2.1
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_file_open
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_file_stat
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_file_underflow@@GLIBC_2.1
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_file_xsputn@@GLIBC_2.1
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_flush_all_lockp
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_getline
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_getline_info
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_list_resetlock
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_setb
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _IO_un_link
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            ____strtod_l_internal
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            ____strtol_l_internal
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __close_nocancel
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __ctype_get_mb_cur_max
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __i686.get_pc_thunk.cx
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __libc_sigaction
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __new_exitfn
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __read_nocancel
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            __uflow
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            _getopt_internal_r
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            alias_compare
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            argz_stringify
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            bsearch
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            calloc
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            exit
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            fclose@@GLIBC_2.1
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            ferror
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            fork
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            free
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            getdelim
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            getppid
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            mmap
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            mremap
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            msort_with_tmp
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            parse_bracket_element
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            sigaction
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strcasecmp
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strdup
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strncmp
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            strncpy
1        4.8e-04  (no location information)   libc-2.3.5.so            libc-2.3.5.so            tfind
1        4.8e-04  opd_trans.c:203             oprofiled                oprofiled                code_kernel_enter
1        4.8e-04  init.c:89                   oprofiled                oprofiled                complete_dump
1        4.8e-04  op_mangle.c:39              oprofiled                oprofiled                op_mangle_filename
1        4.8e-04  op_deviceio.c:29            oprofiled                oprofiled                op_read_device
1        4.8e-04  (no location information)   postgres                 postgres                 LWLockAcquire
1        4.8e-04  (no location information)   postgres                 postgres                 LWLockRelease
1        4.8e-04  (no location information)   postgres                 postgres                 StrategySyncStart
1        4.8e-04  bio.c:321                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         __bio_add_page
1        4.8e-04  usercopy.c:786              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __copy_from_user_ll
1        4.8e-04  usercopy.c:230              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __copy_user_intel
1        4.8e-04  usercopy.c:534              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __copy_user_intel_nocache
1        4.8e-04  usercopy.c:337              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __copy_user_zeroing_intel
1        4.8e-04  elevator.c:645              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __elv_add_request
1        4.8e-04  filemap.c:1997              vmlinux-2.6.23.9         vmlinux-2.6.23.9         __generic_file_aio_write_nolock
1        4.8e-04  gfp.h:147                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         __get_free_pages
1        4.8e-04  fault.c:143                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __is_prefetch
1        4.8e-04  extable.c:56                vmlinux-2.6.23.9         vmlinux-2.6.23.9         __kernel_text_address
1        4.8e-04  kfifo.c:167                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __kfifo_get
1        4.8e-04  ll_rw_blk.c:2925            vmlinux-2.6.23.9         vmlinux-2.6.23.9         __make_request
1        4.8e-04  mpage.c:466                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __mpage_writepage
1        4.8e-04  swap.c:331                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __pagevec_release_nonlru
1        4.8e-04  pdflush.c:93                vmlinux-2.6.23.9         vmlinux-2.6.23.9         __pdflush
1        4.8e-04  super.c:121                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __put_super
1        4.8e-04  scsi.c:863                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __scsi_iterate_devices
1        4.8e-04  chip.c:537                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __set_irq_handler
1        4.8e-04  slub.c:1467                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __slab_alloc
1        4.8e-04  slub.c:1583                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         __slab_free
1        4.8e-04  mmap.c:422                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         __vma_link
1        4.8e-04  sched.c:3691                vmlinux-2.6.23.9         vmlinux-2.6.23.9         __wake_up_sync
1        4.8e-04  random.c:730                vmlinux-2.6.23.9         vmlinux-2.6.23.9         account
1        4.8e-04  mmap.c:1511                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         acct_stack_growth
1        4.8e-04  random.c:636                vmlinux-2.6.23.9         vmlinux-2.6.23.9         add_input_randomness
1        4.8e-04  random.c:572                vmlinux-2.6.23.9         vmlinux-2.6.23.9         add_timer_randomness
1        4.8e-04  pid.c:207                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         alloc_pid
1        4.8e-04  pipe.c:858                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         alloc_pipe_info
1        4.8e-04  mmap.c:1238                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         arch_get_unmapped_area
1        4.8e-04  libata-core.c:4893          vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_hsm_move
1        4.8e-04  libata-sff.c:574            vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_pci_init_bmdma
1        4.8e-04  libata-sff.c:635            vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_pci_init_sff_host
1        4.8e-04  libata-scsi.c:1783          vmlinux-2.6.23.9         vmlinux-2.6.23.9         ata_scsiop_inq_83
1        4.8e-04  bio.c:460                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         bio_set_map_data
1        4.8e-04  ll_rw_blk.c:1958            vmlinux-2.6.23.9         vmlinux-2.6.23.9         blk_get_queue
1        4.8e-04  ll_rw_blk.c:1901            vmlinux-2.6.23.9         vmlinux-2.6.23.9         blk_init_queue
1        4.8e-04  ll_rw_blk.c:3373            vmlinux-2.6.23.9         vmlinux-2.6.23.9         blk_recalc_rq_sectors
1        4.8e-04  ll_rw_blk.c:3331            vmlinux-2.6.23.9         vmlinux-2.6.23.9         blk_recalc_rq_segments
1        4.8e-04  posix-cpu-timers.c:109      vmlinux-2.6.23.9         vmlinux-2.6.23.9         bump_cpu_timer
1        4.8e-04  namei.c:407                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         cached_lookup
1        4.8e-04  truncate.c:70               vmlinux-2.6.23.9         vmlinux-2.6.23.9         cancel_dirty_page
1        4.8e-04  inode.c:243                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         clear_inode
1        4.8e-04  signal.c:304                vmlinux-2.6.23.9         vmlinux-2.6.23.9         collect_signal
1        4.8e-04  file.c:115                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         copy_fdtable
1        4.8e-04  fork.c:533                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         copy_mm
1        4.8e-04  memory.c:493                vmlinux-2.6.23.9         vmlinux-2.6.23.9         copy_pte_range
1        4.8e-04  exec.c:413                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         copy_strings
1        4.8e-04  extable.c:45                vmlinux-2.6.23.9         vmlinux-2.6.23.9         core_kernel_text
1        4.8e-04  crc32.c:171                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         crc32_be
1        4.8e-04  api.c:152                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         crypto_larval_wait
1        4.8e-04  ll_rw_blk.c:3802            vmlinux-2.6.23.9         vmlinux-2.6.23.9         current_io_context
1        4.8e-04  timekeeping.c:543           vmlinux-2.6.23.9         vmlinux-2.6.23.9         current_kernel_time
1        4.8e-04  dcookies.c:202              vmlinux-2.6.23.9         vmlinux-2.6.23.9         dcookie_init
1        4.8e-04  slub.c:1387                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         deactivate_slab
1        4.8e-04  slub_def.h:174              vmlinux-2.6.23.9         vmlinux-2.6.23.9         deadline_init_queue
1        4.8e-04  read_write.c:93             vmlinux-2.6.23.9         vmlinux-2.6.23.9         default_llseek
1        4.8e-04  devres.c:25                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         devm_ioremap
1        4.8e-04  devres.c:47                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         devm_request_irq
1        4.8e-04  ntp.c:241                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_adjtimex
1        4.8e-04  mmap.c:1923                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_brk
1        4.8e-04  exec.c:1341                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_execve
1        4.8e-04  fork.c:1371                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_fork
1        4.8e-04  exit.c:1057                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_group_exit
1        4.8e-04  memory.c:2471               vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_linear_fault
1        4.8e-04  pipe.c:1032                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_pipe
1        4.8e-04  namei.c:2090                vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_rmdir
1        4.8e-04  memory.c:2149               vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_swap_page
1        4.8e-04  read_write.c:232            vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_sync_read
1        4.8e-04  open.c:292                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         do_sys_ftruncate
1        4.8e-04  early_printk.c:24           vmlinux-2.6.23.9         vmlinux-2.6.23.9         early_vga_write
1        4.8e-04  elevator.c:929              vmlinux-2.6.23.9         vmlinux-2.6.23.9         elv_register_queue
1        4.8e-04  current.h:12                vmlinux-2.6.23.9         vmlinux-2.6.23.9         exit_io_context
1        4.8e-04  inode.c:1231                vmlinux-2.6.23.9         vmlinux-2.6.23.9         file_update_time
1        4.8e-04  filemap.c:1302              vmlinux-2.6.23.9         vmlinux-2.6.23.9         filemap_fault
1        4.8e-04  workqueue.c:332             vmlinux-2.6.23.9         vmlinux-2.6.23.9         flush_cpu_workqueue
1        4.8e-04  smp.c:430                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         flush_tlb_page
1        4.8e-04  namei.c:711                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         follow_down
1        4.8e-04  rcupdate.c:82               vmlinux-2.6.23.9         vmlinux-2.6.23.9         force_quiescent_state
1        4.8e-04  exit.c:682                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         forget_original_parent
1        4.8e-04  buffer.c:779                vmlinux-2.6.23.9         vmlinux-2.6.23.9         fsync_buffers_list
1        4.8e-04  namei.c:185                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         generic_permission
1        4.8e-04  mm.h:318                    vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_object_page
1        4.8e-04  ll_rw_blk.c:2076            vmlinux-2.6.23.9         vmlinux-2.6.23.9         get_request
1        4.8e-04  signal.c:519                vmlinux-2.6.23.9         vmlinux-2.6.23.9         handle_signal
1        4.8e-04  inode.c:726                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         igrab
1        4.8e-04  tty_io.c:2002               vmlinux-2.6.23.9         vmlinux-2.6.23.9         init_dev
1        4.8e-04  attr.c:22                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         inode_change_ok
1        4.8e-04  inode.c:302                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         invalidate_list
1        4.8e-04  ioremap.c:161               vmlinux-2.6.23.9         vmlinux-2.6.23.9         iounmap
1        4.8e-04  route.c:2143                vmlinux-2.6.23.9         vmlinux-2.6.23.9         ip_route_output_slow
1        4.8e-04  exit.c:240                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         is_current_pgrp_orphaned
1        4.8e-04  dcache.c:1988               vmlinux-2.6.23.9         vmlinux-2.6.23.9         is_subdir
1        4.8e-04  itimer.c:27                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         itimer_get_remtime
1        4.8e-04  inode.c:700                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         iunique
1        4.8e-04  slub.c:992                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         kmem_cache_flags
1        4.8e-04  sched.c:2789                vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance_newidle
1        4.8e-04  sched_fair.c:1059           vmlinux-2.6.23.9         vmlinux-2.6.23.9         load_balance_start_fair
1        4.8e-04  locks.c:2077                vmlinux-2.6.23.9         vmlinux-2.6.23.9         lock_get_status
1        4.8e-04  namei.c:1335                vmlinux-2.6.23.9         vmlinux-2.6.23.9         lookup_hash
1        4.8e-04  namei.c:1373                vmlinux-2.6.23.9         vmlinux-2.6.23.9         lookup_one_len_kern
1        4.8e-04  madvise.c:40                vmlinux-2.6.23.9         vmlinux-2.6.23.9         madvise_behavior
1        4.8e-04  madvise.c:153               vmlinux-2.6.23.9         vmlinux-2.6.23.9         madvise_dontneed
1        4.8e-04  memory.c:2715               vmlinux-2.6.23.9         vmlinux-2.6.23.9         make_pages_present
1        4.8e-04  super.c:569                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         mark_files_ro
1        4.8e-04  sched.c:5144                vmlinux-2.6.23.9         vmlinux-2.6.23.9         migrate_nr_uninterruptible
1        4.8e-04  mmap.c:1070                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         mmap_region
1        4.8e-04  locks.c:2144                vmlinux-2.6.23.9         vmlinux-2.6.23.9         move_lock_status
1        4.8e-04  sched.c:2290                vmlinux-2.6.23.9         vmlinux-2.6.23.9         move_one_task
1        4.8e-04  mremap.c:72                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         move_ptes
1        4.8e-04  mremap.c:160                vmlinux-2.6.23.9         vmlinux-2.6.23.9         move_vma
1        4.8e-04  neighbour.c:728             vmlinux-2.6.23.9         vmlinux-2.6.23.9         neigh_timer_handler
1        4.8e-04  dev.c:1923                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         netif_receive_skb
1        4.8e-04  nf_log.c:23                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         nf_log_register
1        4.8e-04  attr.c:104                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         notify_change
1        4.8e-04  filemap.c:1264              vmlinux-2.6.23.9         vmlinux-2.6.23.9         page_cache_read
1        4.8e-04  rmap.c:302                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         page_referenced_anon
1        4.8e-04  rmap.c:271                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         page_referenced_one
1        4.8e-04  swap.c:409                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         pagevec_strip
1        4.8e-04  pdflush.c:173               vmlinux-2.6.23.9         vmlinux-2.6.23.9         pdflush
1        4.8e-04  pipe.c:284                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         pipe_read
1        4.8e-04  prio_tree.c:349             vmlinux-2.6.23.9         vmlinux-2.6.23.9         prio_tree_right
1        4.8e-04  task_mmu.c:76               vmlinux-2.6.23.9         vmlinux-2.6.23.9         proc_exe_link
1        4.8e-04  generic.c:387               vmlinux-2.6.23.9         vmlinux-2.6.23.9         proc_lookup
1        4.8e-04  base.c:2290                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         proc_pid_fill_cache
1        4.8e-04  inode.c:333                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         proc_reg_open
1        4.8e-04  signal.c:1589               vmlinux-2.6.23.9         vmlinux-2.6.23.9         ptrace_stop
1        4.8e-04  sched_fair.c:1027           vmlinux-2.6.23.9         vmlinux-2.6.23.9         put_prev_task_fair
1        4.8e-04  radix-tree.c:884            vmlinux-2.6.23.9         vmlinux-2.6.23.9         radix_tree_delete
1        4.8e-04  radix-tree.c:673            vmlinux-2.6.23.9         vmlinux-2.6.23.9         radix_tree_gang_lookup
1        4.8e-04  radix-tree.c:797            vmlinux-2.6.23.9         vmlinux-2.6.23.9         radix_tree_gang_lookup_tag
1        4.8e-04  rcupdate.c:522              vmlinux-2.6.23.9         vmlinux-2.6.23.9         rcu_check_callbacks
1        4.8e-04  rcupdate.c:398              vmlinux-2.6.23.9         vmlinux-2.6.23.9         rcu_offline_cpu
1        4.8e-04  readahead.c:66              vmlinux-2.6.23.9         vmlinux-2.6.23.9         read_cache_pages
1        4.8e-04  reciprocal_div.c:5          vmlinux-2.6.23.9         vmlinux-2.6.23.9         reciprocal_value
1        4.8e-04  tty_io.c:1918               vmlinux-2.6.23.9         vmlinux-2.6.23.9         redirected_tty_write
1        4.8e-04  latency.c:259               vmlinux-2.6.23.9         vmlinux-2.6.23.9         register_latency_notifier
1        4.8e-04  sys.c:619                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         register_reboot_notifier
1        4.8e-04  buffer.c:858                vmlinux-2.6.23.9         vmlinux-2.6.23.9         remove_inode_buffers
1        4.8e-04  memory.c:1829               vmlinux-2.6.23.9         vmlinux-2.6.23.9         reset_vma_truncate_counts
1        4.8e-04  route.c:715                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         rt_garbage_collect
1        4.8e-04  rwsem.c:240                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         rwsem_downgrade_wake
1        4.8e-04  sched.c:1308                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sched_balance_self
1        4.8e-04  workqueue.c:542             vmlinux-2.6.23.9         vmlinux-2.6.23.9         schedule_delayed_work
1        4.8e-04  scsi_error.c:1517           vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_error_handler
1        4.8e-04  scsi_lib.c:1407             vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_request_fn
1        4.8e-04  scsi_lib.c:1361             vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_softirq_done
1        4.8e-04  scsi_error.c:474            vmlinux-2.6.23.9         vmlinux-2.6.23.9         scsi_try_host_reset
1        4.8e-04  sd.c:656                    vmlinux-2.6.23.9         vmlinux-2.6.23.9         sd_ioctl
1        4.8e-04  signal.c:1375               vmlinux-2.6.23.9         vmlinux-2.6.23.9         send_group_sigqueue
1        4.8e-04  smpboot.c:312               vmlinux-2.6.23.9         vmlinux-2.6.23.9         set_cpu_sibling_map
1        4.8e-04  sys.c:642                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         set_one_prio
1        4.8e-04  shm.c:114                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         shm_exit_ns
1        4.8e-04  page_alloc.c:1553           vmlinux-2.6.23.9         vmlinux-2.6.23.9         show_free_areas
1        4.8e-04  signal.c:1959               vmlinux-2.6.23.9         vmlinux-2.6.23.9         sigprocmask
1        4.8e-04  stream.c:268                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sk_stream_kill_queues
1        4.8e-04  argv_split.c:18             vmlinux-2.6.23.9         vmlinux-2.6.23.9         skip_arg
1        4.8e-04  vsprintf.c:656              vmlinux-2.6.23.9         vmlinux-2.6.23.9         snprintf
1        4.8e-04  sys.c:597                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         srcu_init_notifier_head
1        4.8e-04  pdflush.c:228               vmlinux-2.6.23.9         vmlinux-2.6.23.9         start_one_pdflush_thread
1        4.8e-04  ll_rw_blk.c:3303            vmlinux-2.6.23.9         vmlinux-2.6.23.9         submit_bio
1        4.8e-04  fs-writeback.c:471          vmlinux-2.6.23.9         vmlinux-2.6.23.9         sync_inodes_sb
1        4.8e-04  latency.c:241               vmlinux-2.6.23.9         vmlinux-2.6.23.9         synchronize_acceptable_latency
1        4.8e-04  stat.c:176                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_fstat
1        4.8e-04  current.h:12                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_getegid
1        4.8e-04  current.h:12                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_getpid
1        4.8e-04  ioprio.c:58                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_ioprio_set
1        4.8e-04  ldt.c:232                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_modify_ldt
1        4.8e-04  mmap.c:1895                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_munmap
1        4.8e-04  read_write.c:394            vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_pread64
1        4.8e-04  signal.c:1988               vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_rt_sigprocmask
1        4.8e-04  select.c:383                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_select
1        4.8e-04  signal.c:56                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_sigaction
1        4.8e-04  signal.c:2428               vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_sigprocmask
1        4.8e-04  timer.c:1193                vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_sysinfo
1        4.8e-04  exit.c:1679                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         sys_waitid
1        4.8e-04  sched_rt.c:198              vmlinux-2.6.23.9         vmlinux-2.6.23.9         task_tick_rt
1        4.8e-04  tcp_input.c:2626            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tcp_ack_update_window
1        4.8e-04  tcp_input.c:3451            vmlinux-2.6.23.9         vmlinux-2.6.23.9         tcp_data_queue
1        4.8e-04  tcp_output.c:1627           vmlinux-2.6.23.9         vmlinux-2.6.23.9         tcp_retrans_try_collapse
1        4.8e-04  tcp_input.c:679             vmlinux-2.6.23.9         vmlinux-2.6.23.9         tcp_update_metrics
1        4.8e-04  page-writeback.c:975        vmlinux-2.6.23.9         vmlinux-2.6.23.9         test_clear_page_writeback
1        4.8e-04  page-writeback.c:998        vmlinux-2.6.23.9         vmlinux-2.6.23.9         test_set_page_writeback
1        4.8e-04  timer.c:540                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         try_to_del_timer_sync
1        4.8e-04  tty_io.c:405                vmlinux-2.6.23.9         vmlinux-2.6.23.9         tty_buffer_flush
1        4.8e-04  sort.c:13                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         u32_swap
1        4.8e-04  udp.c:1573                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         udp_proc_unregister
1        4.8e-04  signal.c:293                vmlinux-2.6.23.9         vmlinux-2.6.23.9         unblock_all_signals
1        4.8e-04  fork.c:790                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         unshare_files
1        4.8e-04  swapfile.c:528              vmlinux-2.6.23.9         vmlinux-2.6.23.9         unuse_pte_range
1        4.8e-04  sched.c:364                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         update_rq_clock
1        4.8e-04  sched_fair.c:445            vmlinux-2.6.23.9         vmlinux-2.6.23.9         update_stats_enqueue
1        4.8e-04  timekeeping.c:460           vmlinux-2.6.23.9         vmlinux-2.6.23.9         update_wall_time
1        4.8e-04  hcd.c:771                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         usb_deregister_bus
1        4.8e-04  ioctl.c:86                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         vfs_ioctl
1        4.8e-04  namei.c:2137                vmlinux-2.6.23.9         vmlinux-2.6.23.9         vfs_unlink
1        4.8e-04  mmap.c:431                  vmlinux-2.6.23.9         vmlinux-2.6.23.9         vma_link
1        4.8e-04  memory.c:2768               vmlinux-2.6.23.9         vmlinux-2.6.23.9         vmalloc_to_pfn
1        4.8e-04  memory.c:2008               vmlinux-2.6.23.9         vmlinux-2.6.23.9         vmtruncate
1        4.8e-04  fifo.c:19                   vmlinux-2.6.23.9         vmlinux-2.6.23.9         wait_for_partner
1        4.8e-04  exit.c:1138                 vmlinux-2.6.23.9         vmlinux-2.6.23.9         wait_noreap_copyout
1        4.8e-04  sched.c:1673                vmlinux-2.6.23.9         vmlinux-2.6.23.9         wake_up_new_task
1        4.8e-04  sched.c:1567                vmlinux-2.6.23.9         vmlinux-2.6.23.9         wake_up_process
1        4.8e-04  generic.c:280               vmlinux-2.6.23.9         vmlinux-2.6.23.9         xlate_proc_name
1        4.8e-04  page_alloc.c:999            vmlinux-2.6.23.9         vmlinux-2.6.23.9         zone_watermark_ok


         
********************
*** System Stats ***
********************

 Distro: Slackware 10.2
 Mobo:   MSI MasterX FA6R E7210
 CPUs:   Dual 2.4 GHz P4 Xeons 400 MHz FSB - Hyperthreading enabled
 Mem:    2 GB ECC DDR PC 266


******************
*** PCI Config ***
******************

00:00.0 Host bridge: Intel Corporation 82875P/E7210 Memory Controller Hub (rev 02)
00:03.0 PCI bridge: Intel Corporation 82875P/E7210 Processor to PCI to CSA Bridge (rev 02)
00:06.0 System peripheral: Intel Corporation 82875P/E7210 Processor to I/O Memory Interface (rev 02)
00:1c.0 PCI bridge: Intel Corporation 6300ESB 64-bit PCI-X Bridge (rev 02)
00:1d.0 USB Controller: Intel Corporation 6300ESB USB Universal Host Controller (rev 02)
00:1d.1 USB Controller: Intel Corporation 6300ESB USB Universal Host Controller (rev 02)
00:1d.4 System peripheral: Intel Corporation 6300ESB Watchdog Timer (rev 02)
00:1d.5 PIC: Intel Corporation 6300ESB I/O Advanced Programmable Interrupt Controller (rev 02)
00:1d.7 USB Controller: Intel Corporation 6300ESB USB2 Enhanced Host Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 0a)
00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface Controller (rev 02)
00:1f.1 IDE interface: Intel Corporation 6300ESB PATA Storage Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 6300ESB SATA Storage Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 6300ESB SMBus Controller (rev 02)
01:01.0 Ethernet controller: Intel Corporation 82547GI Gigabit Ethernet Controller
02:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
03:09.0 Mass storage controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
03:0a.0 Ethernet controller: Intel Corporation 82541GI/PI Gigabit Ethernet Controller
03:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)



**********************
*** Kernel config: ***
**********************

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23.9
# Tue Nov 27 10:41:38 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=m
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=4
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_SAME=m
# CONFIG_NF_NAT_SNMP_BASIC is not set
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_FTP=m
# CONFIG_NF_NAT_IRC is not set
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_PPTP=m
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_OWNER=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_FIFO=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RR=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_CLS_POLICE is not set
CONFIG_NET_CLS_IND=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_CONCAT is not set
# CONFIG_MTD_PARTITIONS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
# CONFIG_MTD_BLKDEVS is not set
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_XD is not set
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
# CONFIG_PARIDE_PG is not set

#
# Parallel IDE protocol modules
#
# CONFIG_PARIDE_ATEN is not set
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_BPCK6=m
# CONFIG_PARIDE_COMM is not set
# CONFIG_PARIDE_DSTR is not set
# CONFIG_PARIDE_FIT2 is not set
# CONFIG_PARIDE_FIT3 is not set
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
# CONFIG_PARIDE_EPIA is not set
# CONFIG_PARIDE_FRIQ is not set
# CONFIG_PARIDE_FRPW is not set
# CONFIG_PARIDE_KBIC is not set
# CONFIG_PARIDE_KTTI is not set
# CONFIG_PARIDE_ON20 is not set
# CONFIG_PARIDE_ON26 is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_SCSI_OMIT_FLASHPOINT is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=m
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SEAGATE is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=m
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_ISAPNP is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_RAID5_RESHAPE is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set

#
# Fusion MPT device support
#
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_OHCI1394=m

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_IFB is not set
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
# CONFIG_ELPLUS is not set
# CONFIG_EL16 is not set
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
# CONFIG_PCNET32_NAPI is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
CONFIG_CS89x0=m
# CONFIG_DGRS is not set
CONFIG_EEPRO100=m
# CONFIG_E100 is not set
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_SIS900=m
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=m
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
# CONFIG_E1000_NAPI is not set
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
# CONFIG_R8169_NAPI is not set
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKY2 is not set
CONFIG_SK98LIN=m
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1024
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_TIPAR=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
# CONFIG_ITCO_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_AGP=m
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=m
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_MWAVE=m
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=m
CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL=y
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_USS720=m

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_DEBUG is not set
CONFIG_USB_EZUSB=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_SECURITY is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="cp437"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_CRAMFS is not set
CONFIG_VXFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set

#
# Network File Systems
#
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFS_DIRECTIO is not set
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_SUNRPC_BIND34 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
CONFIG_FORCED_INLINING=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ABLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y


****************
*** Boot Log ***
****************

Linux version 2.6.23.9 (bdupree@behemoth) (gcc version 3.3.6) #1 SMP Tue Nov 27 10:53:46 CST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f5540
Entering add_active_range(0, 0, 524272) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524272
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524272
On node 0 totalpages: 524272
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2303 pages used for memmap
  HighMem zone: 292593 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F72C0, 0014 (r0 IntelR)
ACPI: RSDT 7FFF3000, 0030 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FFF3040, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FFF30C0, 3C30 (r1 INTELR AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 7FFF0000, 0040
ACPI: ASF! 7FFF6DC0, 00C6 (r32 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FFF6D00, 0090 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 5, version 32, address 0xfec10000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 520177
Kernel command line: auto BOOT_IMAGE=Slack10.2 ro root=802
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec10000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2394.142 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2075156k/2097088k available (1912k kernel code, 20780k reserved, 909k data, 192k init, 1179584k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff81000 - 0xfffff000   ( 504 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03c8000 - 0xc03f8000   ( 192 kB)
      .data : 0xc02de237 - 0xc03c16a0   ( 909 kB)
      .text : 0xc0100000 - 0xc02de237   (1912 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 4791.35 BogoMIPS (lpj=23956797)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4788.14 BogoMIPS (lpj=23940700)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 2/6 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4788.18 BogoMIPS (lpj=23940944)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 3/7 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4788.21 BogoMIPS (lpj=23941053)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Total of 4 processors activated (19155.89 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbad0, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HRB_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: 00:0c: ioport range 0x400-0x4bf could not be reserved
pnp: 00:0e: iomem range 0xc8000-0xcbfff has been reserved
pnp: 00:0e: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0e: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0e: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:03.0
  IO window: b000-bfff
  MEM window: fa800000-fa8fffff
  PREFETCH window: 88400000-884fffff
PCI: Bridge: 0000:00:1c.0
  IO window: a000-afff
  MEM window: fa000000-fa7fffff
  PREFETCH window: 88000000-883fffff
PCI: Bridge: 0000:00:1e.0
  IO window: 8000-9fff
  MEM window: f8000000-f9ffffff
  PREFETCH window: 88500000-885fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
io scheduler noop registered
io scheduler deadline registered (default)
Boot video device is 0000:03:0c.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
ata1.00: ATA-7: WDC WD2000JB-00REA0, 20.00K20, max UDMA/100
ata1.00: 390721968 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2.00: ATAPI: HL-DT-ST RW/DVD GCC-4120B, 2.02, max MWDMA2
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JB-00R 20.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 sda15 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4120B 2.02 PQ: 0 ANSI: 5
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0001c800 ctl 0x0001cc02 bmdma 0x0001d800 irq 16
ata4: SATA max UDMA/133 cmd 0x0001d000 ctl 0x0001d402 bmdma 0x0001d808 irq 16
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.05
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 24 (level, low) -> IRQ 17
mptbase: Initiating ioc0 bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator}
scsi4 : ioc0: LSI53C1030 C0, FwRev=01033010h, Ports=1, MaxQ=222, IRQ=17
scsi 4:0:15:0: Direct-Access     FUJITSU  MAP3367NP        0108 PQ: 0 ANSI: 3
 target4:0:15: Beginning Domain Validation
 target4:0:15: Ending Domain Validation
 target4:0:15: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
sd 4:0:15:0: [sdb] 71775284 512-byte hardware sectors (36749 MB)
sd 4:0:15:0: [sdb] Write Protect is off
sd 4:0:15:0: [sdb] Mode Sense: b3 00 00 08
sd 4:0:15:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:15:0: [sdb] 71775284 512-byte hardware sectors (36749 MB)
sd 4:0:15:0: [sdb] Write Protect is off
sd 4:0:15:0: [sdb] Mode Sense: b3 00 00 08
sd 4:0:15:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 4:0:15:0: [sdb] Attached SCSI disk
usbmon: debugfs is not available
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 18
input: AT Translated Set 2 keyboard as /class/input/input0
EDAC MC: Ver: 2.1.0 Nov 27 2007
EDAC i82875p: i82875p init one
PCI: Unable to reserve mem region #1:1000@fecf0000 for device 0000:00:06.0
EDAC MC0: Giving out device to 'i82875p_edac' 'i82875p': DEV 0000:00:00.0
EDAC PCI0: Giving out device to module 'i82875p_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
Using IPI No-Shortcut mode
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 192k freed
Adding 995988k swap on /dev/sda14.  Priority:-1 extents:1 across:995988k
Linux agpgart interface v0.102
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:01.0 to 64
e1000: 0000:01:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:11:09:3d:96:bf
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:03:0a.0[A] -> GSI 23 (level, low) -> IRQ 19
e1000: 0000:03:0a.0: e1000_probe: (PCI:33MHz:32-bit) 00:11:09:3d:96:be
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
JFS: nTxBlock = 8192, nTxLock = 65536
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sda5: found reiserfs format "3.6" with standard journal
ReiserFS: sda5: using ordered data mode
ReiserFS: sda5: journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda5: checking transaction log (sda5)
ReiserFS: sda5: Using r5 hash to sort names
ReiserFS: sda13: found reiserfs format "3.6" with standard journal
ReiserFS: sda13: using ordered data mode
ReiserFS: sda13: journal params: device sda13, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda13: checking transaction log (sda13)
ReiserFS: sda13: Using r5 hash to sort names
ReiserFS: sda10: found reiserfs format "3.6" with standard journal
ReiserFS: sda10: using ordered data mode
ReiserFS: sda10: journal params: device sda10, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda10: checking transaction log (sda10)
ReiserFS: sda10: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sda15: found reiserfs format "3.6" with standard journal
ReiserFS: sda15: using ordered data mode
ReiserFS: sda15: journal params: device sda15, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda15: checking transaction log (sda15)
ReiserFS: sda15: Using r5 hash to sort names
device eth0 entered promiscuous mode
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
Bridge firewalling registered
br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
device tap0 entered promiscuous mode
br0: port 2(tap0) entering learning state
br0: topology change detected, propagating
br0: port 2(tap0) entering forwarding state
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfa900000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
i6300ESB timer: initialized (0xf9224000). heartbeat=30 sec (nowayout=0)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000c400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000c000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:03 failed with error -16
FDC 0 is a National Semiconductor PC87306
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
NET: Registered protocol family 10
br0: no IPv6 routers present
eth0: no IPv6 routers present
tap0: no IPv6 routers present
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
oprofile: using NMI interrupt.
------=_20071128204407_68906--


