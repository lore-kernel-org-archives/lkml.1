Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZLYL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZLYL0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 06:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZLYL0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 06:26:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:11286 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbZLYL0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 06:26:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,453,1257148800"; 
   d="32'?scan'208";a="582053593"
Subject: tbench regression with 2.6.33-rc1
From: Lin Ming <ming.m.lin@intel.com>
To: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Content-Type: multipart/mixed; boundary="=-ZGSWARzYdHVMBeW6RhT6"
Date: Fri, 25 Dec 2009 19:11:07 +0800
Message-Id: <1261739467.10685.18.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZGSWARzYdHVMBeW6RhT6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Test machine: 16 cpus (4P/2Core/HT), 8G mem
tbench test command:
tbench_srv &
tbench 32

Compared with 2.6.32, tbench has ~4% regression in 2.6.33-rc1.

>From vmstat data, the context switch number also drop ~4%.
perf top data does not show much differences.

But lockstat data shows huge difference in rq->lock, as below.
See the attachment for the full lockstat data.

Any clue of this regression?

Thanks,
Lin Ming

2.6.32
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                               &rq->lock:           901            902           1.80          80.65        2402.48          27425       26037113           0.84        4278.44    27119526.04
                               ---------
                               &rq->lock              4          [<ffffffff81036a43>] __sched_setscheduler+0x1c8/0x393
                               &rq->lock            223          [<ffffffff814321c5>] schedule+0xe2/0x830
                               &rq->lock            657          [<ffffffff8103107d>] task_rq_lock+0x39/0x67
                               &rq->lock             16          [<ffffffff8103d2b6>] scheduler_tick+0x3d/0x206
                               ---------
                               &rq->lock            425          [<ffffffff814321c5>] schedule+0xe2/0x830
                               &rq->lock            427          [<ffffffff8103107d>] task_rq_lock+0x39/0x67
                               &rq->lock             20          [<ffffffff8103d2b6>] scheduler_tick+0x3d/0x206
                               &rq->lock              4          [<ffffffff81033292>] double_lock_balance+0x40/0x6a


2.6.33-rc1
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                               &rq->lock:          5987           6019           0.00          25.15       20551.87          37851       25873389           0.00        3819.73    29524592.69
                               ---------
                               &rq->lock           5254          [<ffffffff8102a6d9>] task_rq_lock+0x39/0x67
                               &rq->lock            410          [<ffffffff81439c75>] schedule+0xba/0x8ae
                               &rq->lock            336          [<ffffffff8103086f>] try_to_wake_up+0xe3/0x26f
                               &rq->lock             28          [<ffffffff8102c995>] double_lock_balance+0x40/0x6a
                               ---------
                               &rq->lock            468          [<ffffffff8102a6d9>] task_rq_lock+0x39/0x67
                               &rq->lock           5022          [<ffffffff81439c75>] schedule+0xba/0x8ae
                               &rq->lock             13          [<ffffffff81030555>] double_rq_lock+0x40/0x79
                               &rq->lock            477          [<ffffffff8103086f>] try_to_wake_up+0xe3/0x26f


--=-ZGSWARzYdHVMBeW6RhT6
Content-Disposition: attachment; filename="lockstat.tbench.2.6.32"
Content-Type: text/plain; name="lockstat.tbench.2.6.32"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

lock_stat version 0.3
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                             dcache_lock:          2218           2368           1.72         262.84        3603.74          18144         215600           0.95         733.15      194306.02
                             -----------
                             dcache_lock            553          [<ffffffff810de556>] d_alloc+0x173/0x1dc
                             dcache_lock            831          [<ffffffff811c0b01>] _atomic_dec_and_lock+0x39/0x5c
                             dcache_lock             81          [<ffffffff810dd621>] shrink_dcache_parent+0x46/0x133
                             dcache_lock             62          [<ffffffff810d6af9>] dentry_unhash+0x34/0x89
                             -----------
                             dcache_lock            227          [<ffffffff810dce3f>] d_rehash+0x1b/0x44
                             dcache_lock            447          [<ffffffff810de556>] d_alloc+0x173/0x1dc
                             dcache_lock            815          [<ffffffff811c0b01>] _atomic_dec_and_lock+0x39/0x5c
                             dcache_lock              1          [<ffffffff810f651d>] __fsnotify_update_child_dentry_flags+0x51/0x104

...............................................................................................................................................................................................

                               &rq->lock:           901            902           1.80          80.65        2402.48          27425       26037113           0.84        4278.44    27119526.04
                               ---------
                               &rq->lock              4          [<ffffffff81036a43>] __sched_setscheduler+0x1c8/0x393
                               &rq->lock            223          [<ffffffff814321c5>] schedule+0xe2/0x830
                               &rq->lock            657          [<ffffffff8103107d>] task_rq_lock+0x39/0x67
                               &rq->lock             16          [<ffffffff8103d2b6>] scheduler_tick+0x3d/0x206
                               ---------
                               &rq->lock            425          [<ffffffff814321c5>] schedule+0xe2/0x830
                               &rq->lock            427          [<ffffffff8103107d>] task_rq_lock+0x39/0x67
                               &rq->lock             20          [<ffffffff8103d2b6>] scheduler_tick+0x3d/0x206
                               &rq->lock              4          [<ffffffff81033292>] double_lock_balance+0x40/0x6a

...............................................................................................................................................................................................

                         &zone->lru_lock:           548            551           1.83          29.18         740.11          12635         102094           1.29          35.84       88587.95
                         ---------------
                         &zone->lru_lock            153          [<ffffffff810a19dd>] ____pagevec_lru_add+0x6b/0x122
                         &zone->lru_lock            386          [<ffffffff810a186e>] release_pages+0xc5/0x1c9
                         &zone->lru_lock             11          [<ffffffff810a1b47>] activate_page+0x40/0x130
                         &zone->lru_lock              1          [<ffffffff810a1e52>] put_page+0x66/0xee
                         ---------------
                         &zone->lru_lock            208          [<ffffffff810a19dd>] ____pagevec_lru_add+0x6b/0x122
                         &zone->lru_lock            334          [<ffffffff810a186e>] release_pages+0xc5/0x1c9
                         &zone->lru_lock              9          [<ffffffff810a1b47>] activate_page+0x40/0x130

...............................................................................................................................................................................................

              &inode->i_data.i_mmap_lock:           442            446           2.25          65.54         614.95          42732         210895           0.95         162.56      135276.67
              --------------------------
              &inode->i_data.i_mmap_lock            239          [<ffffffff810b5178>] unlink_file_vma+0x30/0x4f
              &inode->i_data.i_mmap_lock             26          [<ffffffff810b5cbc>] vma_link+0x49/0xb4
              &inode->i_data.i_mmap_lock            131          [<ffffffff8103f529>] dup_mm+0x26f/0x48e
              &inode->i_data.i_mmap_lock             50          [<ffffffff810b5376>] vma_adjust+0x15c/0x41d
              --------------------------
              &inode->i_data.i_mmap_lock            211          [<ffffffff810b5178>] unlink_file_vma+0x30/0x4f
              &inode->i_data.i_mmap_lock             38          [<ffffffff810b5cbc>] vma_link+0x49/0xb4
              &inode->i_data.i_mmap_lock            121          [<ffffffff8103f529>] dup_mm+0x26f/0x48e
              &inode->i_data.i_mmap_lock             76          [<ffffffff810b5376>] vma_adjust+0x15c/0x41d

...............................................................................................................................................................................................

                           vfsmount_lock:           337            340           1.75          40.43         288.69           9955          68402           1.17         133.85       32431.20
                           -------------
                           vfsmount_lock             18          [<ffffffff810dd78d>] __d_path+0x3c/0x159
                           vfsmount_lock            322          [<ffffffff810e2f43>] lookup_mnt+0x18/0x4c
                           -------------
                           vfsmount_lock            313          [<ffffffff810e2f43>] lookup_mnt+0x18/0x4c
                           vfsmount_lock             27          [<ffffffff810dd78d>] __d_path+0x3c/0x159

...............................................................................................................................................................................................

                         tasklist_lock-W:           155            155           2.80          83.86         706.18           7263          21950           1.19         113.03       68792.01
                         tasklist_lock-R:            86             86           2.73          54.95         359.63           2807           7521           1.33         459.36       17387.60
                         ---------------
                           tasklist_lock             15          [<ffffffff8104049b>] copy_process+0xd12/0x1176
                           tasklist_lock             53          [<ffffffff8104aa0b>] exit_ptrace+0x2a/0x10d
                           tasklist_lock             75          [<ffffffff8104428a>] do_wait+0xba/0x206
                           tasklist_lock             11          [<ffffffff810532fa>] sys_setpriority+0x61/0x1f9
                         ---------------
                           tasklist_lock             12          [<ffffffff8104049b>] copy_process+0xd12/0x1176
                           tasklist_lock             63          [<ffffffff810436b9>] release_task+0x31/0x332
                           tasklist_lock            109          [<ffffffff8104494e>] do_exit+0x4ac/0x636
                           tasklist_lock             16          [<ffffffff810446fd>] do_exit+0x25b/0x636

...............................................................................................................................................................................................

                              files_lock:           147            147           2.11          15.51         126.39          11578          66837           1.07         113.45       26348.61
                              ----------
                              files_lock             76          [<ffffffff810cedf5>] file_kill+0x1d/0x42
                              files_lock             71          [<ffffffff810cee38>] file_move+0x1e/0x50
                              ----------
                              files_lock             63          [<ffffffff810cedf5>] file_kill+0x1d/0x42
                              files_lock             83          [<ffffffff810cee38>] file_move+0x1e/0x50
                              files_lock              1          [<ffffffff81213212>] check_tty_count+0x22/0xac

...............................................................................................................................................................................................

                             &base->lock:           144            143           2.16           6.41         132.75          13848        8921284           1.12          33.07     3947909.21
                             -----------
                             &base->lock             37          [<ffffffff8104caaa>] get_next_timer_interrupt+0x2e/0x1f3
                             &base->lock             99          [<ffffffff8104c76b>] lock_timer_base+0x26/0x4a
                             &base->lock              2          [<ffffffff8104c3e8>] run_timer_softirq+0x49/0x284
                             &base->lock              1          [<ffffffff8104c9e1>] mod_timer+0x13f/0x191
                             -----------
                             &base->lock            100          [<ffffffff8104c76b>] lock_timer_base+0x26/0x4a
                             &base->lock             37          [<ffffffff8104caaa>] get_next_timer_interrupt+0x2e/0x1f3
                             &base->lock              4          [<ffffffff8104e996>] add_timer_on+0x45/0xca
                             &base->lock              2          [<ffffffff8104c5dd>] run_timer_softirq+0x23e/0x284

...............................................................................................................................................................................................

                              inode_lock:           137            142           1.90         188.18         358.03           7160          64779           1.02        3834.39       35521.94
                              ----------
                              inode_lock             34          [<ffffffff810dfc6e>] ifind_fast+0x22/0x91
                              inode_lock             16          [<ffffffff810e0e30>] new_inode+0x31/0xb3
                              inode_lock             40          [<ffffffff810e0b64>] iget_locked+0x65/0x162
                              inode_lock             17          [<ffffffff811c0b01>] _atomic_dec_and_lock+0x39/0x5c
                              ----------
                              inode_lock              1          [<ffffffff810dfe37>] ifind+0x2c/0xa7
                              inode_lock             30          [<ffffffff810dfc6e>] ifind_fast+0x22/0x91
                              inode_lock             35          [<ffffffff810e0e30>] new_inode+0x31/0xb3
                              inode_lock             11          [<ffffffff811c0b01>] _atomic_dec_and_lock+0x39/0x5c

...............................................................................................................................................................................................

                              xtime_lock:           122            122           8.90          22.64         384.02          12945          52976           1.91          34.45      106562.69
                              ----------
                              xtime_lock            122          [<ffffffff81064d8b>] tick_do_update_jiffies64+0x2f/0xb0
                              ----------
                              xtime_lock            122          [<ffffffff81064d8b>] tick_do_update_jiffies64+0x2f/0xb0

...............................................................................................................................................................................................

                             sysfs_mutex:           118            118          74.43       16015.90       82578.80           1275          31540           1.83        4283.95      129771.94
                             -----------
                             sysfs_mutex            103          [<ffffffff8111ac22>] sysfs_lookup+0x2e/0xb2
                             sysfs_mutex             14          [<ffffffff8111ad4c>] sysfs_follow_link+0x52/0x17d
                             sysfs_mutex              1          [<ffffffff81119d66>] sysfs_readdir+0xb8/0x141
                             -----------
                             sysfs_mutex            105          [<ffffffff8111ac22>] sysfs_lookup+0x2e/0xb2
                             sysfs_mutex             11          [<ffffffff8111ad4c>] sysfs_follow_link+0x52/0x17d
                             sysfs_mutex              2          [<ffffffff81119d66>] sysfs_readdir+0xb8/0x141

...............................................................................................................................................................................................

                         &dentry->d_lock:           113            113           2.58           6.37         110.26          55233         456953           0.92         206.87      192601.35
                         ---------------
                         &dentry->d_lock            109          [<ffffffff810de0ee>] __d_lookup+0x9e/0x14b
                         &dentry->d_lock              4          [<ffffffff810de6b5>] dput+0x41/0x15a
                         ---------------
                         &dentry->d_lock            110          [<ffffffff810de0ee>] __d_lookup+0x9e/0x14b
                         &dentry->d_lock              3          [<ffffffff810de6b5>] dput+0x41/0x15a

...............................................................................................................................................................................................

                             &zone->lock:           100             98           3.35          42.74         355.66           6651          56127           1.32         759.84       69470.69
                             -----------
                             &zone->lock             34          [<ffffffff8109d2a6>] free_one_page+0x22/0x191
                             &zone->lock             25          [<ffffffff8109e806>] get_page_from_freelist+0x369/0x64d
                             &zone->lock             15          [<ffffffff8109e6d2>] get_page_from_freelist+0x235/0x64d
                             &zone->lock             26          [<ffffffff8109d43c>] free_pcppages_bulk+0x27/0x24e
                             -----------
                             &zone->lock             16          [<ffffffff8109e806>] get_page_from_freelist+0x369/0x64d
                             &zone->lock             18          [<ffffffff8109d2a6>] free_one_page+0x22/0x191
                             &zone->lock             42          [<ffffffff8109e6d2>] get_page_from_freelist+0x235/0x64d
                             &zone->lock             24          [<ffffffff8109d43c>] free_pcppages_bulk+0x27/0x24e

...............................................................................................................................................................................................

                        &q->__queue_lock:            83             87           3.16         110.01         366.00           1881          82232           1.19         190.19      155349.92
                        ----------------
                        &q->__queue_lock              2          [<ffffffff811b064c>] blk_put_request+0x20/0x46
                        &q->__queue_lock              2          [<ffffffff811b7dfe>] blk_execute_rq_nowait+0x50/0x91
                        &q->__queue_lock             20          [<ffffffff811b0c3f>] blk_run_queue+0x16/0x35
                        &q->__queue_lock              4          [<ffffffff811bea9f>] cfq_set_request+0x1cf/0x30c
                        ----------------
                        &q->__queue_lock              3          [<ffffffff811bea9f>] cfq_set_request+0x1cf/0x30c
                        &q->__queue_lock             11          [<ffffffff811b064c>] blk_put_request+0x20/0x46
                        &q->__queue_lock              7          [<ffffffff811b0c3f>] blk_run_queue+0x16/0x35
                        &q->__queue_lock              3          [<ffffffff811b14f1>] blk_get_request+0x2a/0x71

...............................................................................................................................................................................................

                       &sighand->siglock:            82             60           4.13           9.91         101.50          13227          89229           1.09          98.59       94039.81
                       -----------------
                       &sighand->siglock             78          [<ffffffff81051e76>] get_signal_to_deliver+0x5e/0x389
                       &sighand->siglock              2          [<ffffffff8100aacd>] sys_rt_sigreturn+0x87/0x1fa
                       &sighand->siglock              1          [<ffffffff81051d72>] do_notify_parent+0x173/0x219
                       &sighand->siglock              1          [<ffffffff8100a8da>] do_notify_resume+0x57f/0x6d7
                       -----------------
                       &sighand->siglock             81          [<ffffffff81051d72>] do_notify_parent+0x173/0x219
                       &sighand->siglock              1          [<ffffffff8100aacd>] sys_rt_sigreturn+0x87/0x1fa

...............................................................................................................................................................................................

                         &anon_vma->lock:            54             55           2.09          23.82          63.73          59778         189404           0.96         177.99       97110.06
                         ---------------
                         &anon_vma->lock             26          [<ffffffff810b942c>] anon_vma_unlink+0x25/0x71
                         &anon_vma->lock              2          [<ffffffff810b53f0>] vma_adjust+0x1d6/0x41d
                         &anon_vma->lock             27          [<ffffffff810b87be>] anon_vma_link+0x1b/0x45
                         ---------------
                         &anon_vma->lock             34          [<ffffffff810b87be>] anon_vma_link+0x1b/0x45
                         &anon_vma->lock             19          [<ffffffff810b942c>] anon_vma_unlink+0x25/0x71
                         &anon_vma->lock              2          [<ffffffff810b53f0>] vma_adjust+0x1d6/0x41d

...............................................................................................................................................................................................

                             &rq->lock/1:            51             51           2.42          18.98         122.56            782           1190           2.71        3942.98        5631.17
                             -----------
                             &rq->lock/1             46          [<ffffffff810332b3>] double_lock_balance+0x61/0x6a
                             &rq->lock/1              5          [<ffffffff8103703d>] double_rq_lock+0x4d/0x79
                             -----------
                             &rq->lock/1             43          [<ffffffff814321c5>] schedule+0xe2/0x830
                             &rq->lock/1              4          [<ffffffff8103107d>] task_rq_lock+0x39/0x67
                             &rq->lock/1              1          [<ffffffff8103703d>] double_rq_lock+0x4d/0x79
                             &rq->lock/1              1          [<ffffffff810332b3>] double_lock_balance+0x61/0x6a

...............................................................................................................................................................................................

                &rcu_get_root(rsp)->lock:            45             44           2.05           8.23          42.27          50892          70729           1.01          23.15       33488.55
                ------------------------
                &rcu_get_root(rsp)->lock             45          [<ffffffff81081dec>] __rcu_process_callbacks+0x9d/0x289
                ------------------------
                &rcu_get_root(rsp)->lock             45          [<ffffffff81081dec>] __rcu_process_callbacks+0x9d/0x289

...............................................................................................................................................................................................

                  &type->i_mutex_dir_key:            22             40         294.74        9435.22       57617.42           2477          14682           1.43       18305.30      216589.28
                  ----------------------
                  &type->i_mutex_dir_key             40          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5
                  ----------------------
                  &type->i_mutex_dir_key             40          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5

...............................................................................................................................................................................................

                &inode->i_data.tree_lock:            40             40           0.84           2.35          30.63           1255          47890           1.11          70.50       25234.65
                ------------------------
                &inode->i_data.tree_lock             40          [<ffffffff810994fb>] add_to_page_cache_locked+0x55/0xcd
                ------------------------
                &inode->i_data.tree_lock             40          [<ffffffff810994fb>] add_to_page_cache_locked+0x55/0xcd

...............................................................................................................................................................................................

                           slock-AF_INET:            30             30           7.90          22.97          89.61           1487       56207244           0.99         205.36    20392707.02
                           -------------
                           slock-AF_INET             18          [<ffffffff813750eb>] lock_sock_nested+0x28/0xee
                           slock-AF_INET             10          [<ffffffff81375016>] release_sock+0x2f/0xdc
                           slock-AF_INET              2          [<ffffffff81375074>] release_sock+0x8d/0xdc
                           -------------
                           slock-AF_INET             30          [<ffffffff813b59ce>] tcp_v4_rcv+0x2c3/0x64d

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#1:            18             23        3377.99       65346.13      139804.02           1640          10094           1.94     1864137.65    10458177.24
              --------------------------
              &sb->s_type->i_mutex_key#1              4          [<ffffffff810db2ad>] vfs_readdir+0x44/0xa1
              &sb->s_type->i_mutex_key#1             19          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5
              --------------------------
              &sb->s_type->i_mutex_key#1              3          [<ffffffff810db2ad>] vfs_readdir+0x44/0xa1
              &sb->s_type->i_mutex_key#1             19          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5
              &sb->s_type->i_mutex_key#1              1          [<ffffffff810d868d>] do_unlinkat+0x64/0x17f

...............................................................................................................................................................................................

                      &parent->list_lock:            27             21           4.49          19.07          44.29          22768          73827           1.17          89.76       60459.52
                      ------------------
                      &parent->list_lock              8          [<ffffffff810c8338>] do_drain+0x39/0x6f
                      &parent->list_lock              6          [<ffffffff810c78d6>] cache_alloc_refill+0x7c/0x1f6
                      &parent->list_lock              4          [<ffffffff810c827e>] cache_flusharray+0x3f/0xc0
                      &parent->list_lock              4          [<ffffffff810c72ea>] cache_grow+0x4e/0x241
                      ------------------
                      &parent->list_lock              8          [<ffffffff810c8338>] do_drain+0x39/0x6f
                      &parent->list_lock              4          [<ffffffff810c827e>] cache_flusharray+0x3f/0xc0
                      &parent->list_lock             12          [<ffffffff810c78d6>] cache_alloc_refill+0x7c/0x1f6
                      &parent->list_lock              3          [<ffffffff810c745b>] cache_grow+0x1bf/0x241

...............................................................................................................................................................................................

                          &port_lock_key:            18             20          22.56        3867.11        5244.49            291           2189           0.91         176.63       11217.68
                          --------------
                          &port_lock_key             12          [<ffffffff81232ecd>] uart_write_room+0x1b/0x4a
                          &port_lock_key              2          [<ffffffff81237551>] serial8250_handle_port+0x19/0x2cd
                          &port_lock_key              3          [<ffffffff81232fb1>] uart_start+0x26/0x44
                          &port_lock_key              2          [<ffffffff81232e85>] uart_chars_in_buffer+0x1b/0x48
                          --------------
                          &port_lock_key             17          [<ffffffff81237551>] serial8250_handle_port+0x19/0x2cd
                          &port_lock_key              3          [<ffffffff81232fb1>] uart_start+0x26/0x44

...............................................................................................................................................................................................

                         &sem->wait_lock:            18             19           3.39           6.72          21.54           5263        1604101           1.11          26.09      520887.02
                         ---------------
                         &sem->wait_lock              7          [<ffffffff811c532a>] __up_read+0x1c/0x97
                         &sem->wait_lock             10          [<ffffffff811c5298>] __down_read_trylock+0x16/0x46
                         &sem->wait_lock              1          [<ffffffff811c53ce>] __up_write+0x29/0x11b
                         &sem->wait_lock              1          [<ffffffff81434567>] __down_write_nested+0x1a/0xab
                         ---------------
                         &sem->wait_lock              7          [<ffffffff811c5298>] __down_read_trylock+0x16/0x46
                         &sem->wait_lock              9          [<ffffffff811c532a>] __up_read+0x1c/0x97
                         &sem->wait_lock              2          [<ffffffff811c52de>] __down_write_trylock+0x16/0x46
                         &sem->wait_lock              1          [<ffffffff811c53ce>] __up_write+0x29/0x11b

...............................................................................................................................................................................................

                         slock-AF_INET/1:            18             18           3.99          17.56          31.22           1389        8782886           1.23         402.97    36828847.12
                         ---------------
                         slock-AF_INET/1             18          [<ffffffff813b59ce>] tcp_v4_rcv+0x2c3/0x64d
                         ---------------
                         slock-AF_INET/1              5          [<ffffffff813b59ce>] tcp_v4_rcv+0x2c3/0x64d
                         slock-AF_INET/1              5          [<ffffffff81375016>] release_sock+0x2f/0xdc
                         slock-AF_INET/1              8          [<ffffffff813750eb>] lock_sock_nested+0x28/0xee

...............................................................................................................................................................................................

                  &journal->j_state_lock:            14             14           5.85          28.71          47.84           1251          18120           1.20         237.03       32532.76
                  ----------------------
                  &journal->j_state_lock              1          [<ffffffff8116068a>] journal_errno+0x22/0x3f
                  &journal->j_state_lock              2          [<ffffffff811613ce>] journal_next_log_block+0x1d/0x75
                  &journal->j_state_lock              2          [<ffffffff8115c4f7>] start_this_handle+0xd3/0x3bb
                  &journal->j_state_lock              1          [<ffffffff81161687>] kjournald+0x9d/0x230
                  ----------------------
                  &journal->j_state_lock              1          [<ffffffff81161687>] kjournald+0x9d/0x230
                  &journal->j_state_lock              4          [<ffffffff8115bd73>] journal_stop+0x13b/0x265
                  &journal->j_state_lock              1          [<ffffffff8115e5d0>] journal_commit_transaction+0xdf2/0xf2e
                  &journal->j_state_lock              1          [<ffffffff81161798>] kjournald+0x1ae/0x230

...............................................................................................................................................................................................

                                   key#1:            12             12           4.69           6.99          17.51           2589          11910           1.26          72.33       26411.05
                                   -----
                                   key#1              1          [<ffffffff81059a53>] prepare_to_wait_exclusive+0x1e/0x65
                                   key#1              9          [<ffffffff81059a09>] finish_wait+0x3b/0x67
                                   key#1              2          [<ffffffff81030dc5>] __wake_up+0x22/0x4f
                                   -----
                                   key#1              1          [<ffffffff81059a53>] prepare_to_wait_exclusive+0x1e/0x65
                                   key#1              9          [<ffffffff81030dc5>] __wake_up+0x22/0x4f
                                   key#1              2          [<ffffffff81059a09>] finish_wait+0x3b/0x67

...............................................................................................................................................................................................

                                   key#2:            10             10           3.23           4.42           9.32           6254          13645           1.19          58.82        5891.12
                                   -----
                                   key#2             10          [<ffffffff811ceb1c>] __percpu_counter_add+0x47/0x66
                                   -----
                                   key#2             10          [<ffffffff811ceb1c>] __percpu_counter_add+0x47/0x66

...............................................................................................................................................................................................

            &sb->s_type->i_mutex_key#7/1:            10             10          93.86         871.12        1138.89            125           9683          17.76         762.70       89226.88
            ----------------------------
            &sb->s_type->i_mutex_key#7/1              5          [<ffffffff810d8834>] do_rmdir+0x79/0x10e
            &sb->s_type->i_mutex_key#7/1              4          [<ffffffff810d6273>] lookup_create+0x26/0x97
            &sb->s_type->i_mutex_key#7/1              1          [<ffffffff810d868d>] do_unlinkat+0x64/0x17f
            ----------------------------
            &sb->s_type->i_mutex_key#7/1              8          [<ffffffff810d6273>] lookup_create+0x26/0x97
            &sb->s_type->i_mutex_key#7/1              2          [<ffffffff810d868d>] do_unlinkat+0x64/0x17f

...............................................................................................................................................................................................

                         unix_table_lock:             9              9           3.66           4.46           9.42            893           7282           1.32          55.22        3261.72
                         ---------------
                         unix_table_lock              4          [<ffffffff813cd20a>] unix_release_sock+0x31/0x214
                         unix_table_lock              1          [<ffffffff813cc618>] unix_find_other+0x137/0x1d0
                         unix_table_lock              4          [<ffffffff813cd543>] unix_create1+0x133/0x183
                         ---------------
                         unix_table_lock              2          [<ffffffff813cc618>] unix_find_other+0x137/0x1d0
                         unix_table_lock              5          [<ffffffff813cd543>] unix_create1+0x133/0x183
                         unix_table_lock              2          [<ffffffff813cd20a>] unix_release_sock+0x31/0x214

...............................................................................................................................................................................................

                         &cpu_base->lock:             8              8           4.15           5.96          10.43           6065         370818           1.23          26.17      198783.46
                         ---------------
                         &cpu_base->lock              1          [<ffffffff8105cbad>] hrtimer_get_next_event+0x37/0xb2
                         &cpu_base->lock              5          [<ffffffff8105c566>] lock_hrtimer_base+0x25/0x4b
                         &cpu_base->lock              2          [<ffffffff8105c0e5>] __run_hrtimer+0xd7/0x105
                         ---------------
                         &cpu_base->lock              6          [<ffffffff8105c566>] lock_hrtimer_base+0x25/0x4b
                         &cpu_base->lock              2          [<ffffffff8105c0e5>] __run_hrtimer+0xd7/0x105

...............................................................................................................................................................................................

                                   key#2:            12              8           3.42           6.27           9.87            681           4060           1.20          25.35        2619.92
                                   -----
                                   key#2             11          [<ffffffff81059b15>] remove_wait_queue+0x12/0x45
                                   key#2              1          [<ffffffff81030dc5>] __wake_up+0x22/0x4f
                                   -----
                                   key#2             12          [<ffffffff81030dc5>] __wake_up+0x22/0x4f

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#8:             7              7          73.34        1038.79        1692.95            628          14295           2.29        1513.89       94980.97
              --------------------------
              &sb->s_type->i_mutex_key#8              6          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5
              &sb->s_type->i_mutex_key#8              1          [<ffffffff810d91b6>] do_filp_open+0x21e/0x922
              --------------------------
              &sb->s_type->i_mutex_key#8              1          [<ffffffff810d8834>] do_rmdir+0x79/0x10e
              &sb->s_type->i_mutex_key#8              2          [<ffffffff810d91b6>] do_filp_open+0x21e/0x922
              &sb->s_type->i_mutex_key#8              2          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5
              &sb->s_type->i_mutex_key#8              1          [<ffffffff810d6273>] lookup_create+0x26/0x97

...............................................................................................................................................................................................

                      (console_sem).lock:             6              6           2.24          15.15          22.01            172            786           1.28          23.24        1194.62
                      ------------------
                      (console_sem).lock              5          [<ffffffff8105d46f>] down+0xf/0x38
                      (console_sem).lock              1          [<ffffffff8105d3e6>] up+0xf/0x39
                      ------------------
                      (console_sem).lock              4          [<ffffffff8105d3e6>] up+0xf/0x39
                      (console_sem).lock              2          [<ffffffff8105d46f>] down+0xf/0x38

...............................................................................................................................................................................................

                   &journal->j_list_lock:             5              5           3.45           4.84           7.08            549          24983           1.15         203.65       22226.91
                   ---------------------
                   &journal->j_list_lock              2          [<ffffffff8115d686>] journal_file_buffer+0x44/0x86
                   &journal->j_list_lock              2          [<ffffffff8115d275>] journal_dirty_metadata+0xc8/0x104
                   &journal->j_list_lock              1          [<ffffffff8115c190>] do_get_write_access+0x2f3/0x41a
                   ---------------------
                   &journal->j_list_lock              1          [<ffffffff8115c190>] do_get_write_access+0x2f3/0x41a
                   &journal->j_list_lock              2          [<ffffffff8115d4c8>] journal_unfile_buffer+0x38/0x67
                   &journal->j_list_lock              1          [<ffffffff81161d7d>] journal_write_metadata_buffer+0x2f5/0x350
                   &journal->j_list_lock              1          [<ffffffff8115d686>] journal_file_buffer+0x44/0x86

...............................................................................................................................................................................................

                             &host->lock:             5              5           2.19        2687.26        2691.01             62           8623           1.66        4091.64       90909.84
                             -----------
                             &host->lock              1          [<ffffffff81286bf1>] ata_hsm_qc_complete+0x32/0xf9
                             &host->lock              1          [<ffffffff81282375>] ata_eh_reset+0xc34/0xc9b
                             &host->lock              1          [<ffffffff812854d5>] ata_scsi_error+0x3f1/0x6d0
                             &host->lock              1          [<ffffffff8127a717>] ata_exec_internal_sg+0x43d/0x4ef
                             -----------
                             &host->lock              1          [<ffffffff812813b7>] ata_eh_thaw_port+0x21/0x4b
                             &host->lock              1          [<ffffffff81286bf1>] ata_hsm_qc_complete+0x32/0xf9
                             &host->lock              1          [<ffffffff812862cc>] ata_sff_post_internal_cmd+0x1c/0x4f
                             &host->lock              1          [<ffffffff812854d5>] ata_scsi_error+0x3f1/0x6d0

...............................................................................................................................................................................................

               &sb->s_type->i_lock_key#8:             5              5           2.90           3.13           4.76           3768          10596           1.19          30.21        4714.76
               -------------------------
               &sb->s_type->i_lock_key#8              5          [<ffffffff810d5ca1>] deny_write_access+0x1e/0x4d
               -------------------------
               &sb->s_type->i_lock_key#8              5          [<ffffffff810d5ca1>] deny_write_access+0x1e/0x4d

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#5:             4              4       10690.25       13565.62       24205.44            891           4643           5.72        1263.87       65806.05
              --------------------------
              &sb->s_type->i_mutex_key#5              4          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5
              --------------------------
              &sb->s_type->i_mutex_key#5              4          [<ffffffff810d5fac>] do_lookup+0x84/0x1c5

...............................................................................................................................................................................................

                                pgd_lock:             4              4           2.07           2.52           4.81           5877           8598           1.36          30.74        9820.99
                                --------
                                pgd_lock              3          [<ffffffff81029749>] pgd_alloc+0x35/0xbb
                                pgd_lock              1          [<ffffffff810296a1>] pgd_free+0x16/0x77
                                --------
                                pgd_lock              2          [<ffffffff810296a1>] pgd_free+0x16/0x77
                                pgd_lock              2          [<ffffffff81029749>] pgd_alloc+0x35/0xbb

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#1:             4              4         116.03         116.03         116.03           1216           7750           1.94         134.45       24614.05
              --------------------------
              &sb->s_type->i_mutex_key#1              2          [<ffffffff810d545d>] pipe_read+0x7a/0x37d
              &sb->s_type->i_mutex_key#1              1          [<ffffffff810d4f62>] pipe_write+0x74/0x442
              &sb->s_type->i_mutex_key#1              1          [<ffffffff810d4a09>] pipe_release+0x2a/0x9b
              --------------------------
              &sb->s_type->i_mutex_key#1              2          [<ffffffff810d4a09>] pipe_release+0x2a/0x9b
              &sb->s_type->i_mutex_key#1              2          [<ffffffff810d545d>] pipe_read+0x7a/0x37d

...............................................................................................................................................................................................

                         &tty->ctrl_lock:             4              4           4.63           4.69           5.75            224            659           1.28           8.42         363.84
                         ---------------
                         &tty->ctrl_lock              1          [<ffffffff81214ed9>] tty_check_change+0x3b/0xe4
                         &tty->ctrl_lock              3          [<ffffffff81216193>] tty_ioctl+0x574/0x82d
                         ---------------
                         &tty->ctrl_lock              2          [<ffffffff81216193>] tty_ioctl+0x574/0x82d
                         &tty->ctrl_lock              2          [<ffffffff81214ed9>] tty_check_change+0x3b/0xe4

...............................................................................................................................................................................................

                                   key#3:             4              4           3.03           8.73          11.76            433           4704           1.25          45.15        6085.93
                                   -----
                                   key#3              1          [<ffffffff81030dc5>] __wake_up+0x22/0x4f
                                   key#3              1          [<ffffffff81059a09>] finish_wait+0x3b/0x67
                                   key#3              2          [<ffffffff81059ab8>] prepare_to_wait+0x1e/0x69
                                   -----
                                   key#3              1          [<ffffffff81059ab8>] prepare_to_wait+0x1e/0x69
                                   key#3              3          [<ffffffff81030dc5>] __wake_up+0x22/0x4f

...............................................................................................................................................................................................

                  &ioc->scsi_lookup_lock:             3              3           1.90           1.92           2.69           9401          14632           1.13          23.76        8615.81
                  ----------------------
                  &ioc->scsi_lookup_lock              2          [<ffffffff812f5d8d>] mptscsih_getclear_scsi_lookup+0x22/0x50
                  &ioc->scsi_lookup_lock              1          [<ffffffff812f723b>] mptscsih_qcmd+0x48d/0x4fa
                  ----------------------
                  &ioc->scsi_lookup_lock              2          [<ffffffff812f723b>] mptscsih_qcmd+0x48d/0x4fa
                  &ioc->scsi_lookup_lock              1          [<ffffffff812f5d8d>] mptscsih_getclear_scsi_lookup+0x22/0x50

...............................................................................................................................................................................................

                             &list->lock:             3              3           0.85           1.94           4.28            149           3663           1.19          16.01        1868.16
                             -----------
                             &list->lock              3          [<ffffffff81378c39>] skb_queue_tail+0x1f/0x4a
                             -----------
                             &list->lock              2          [<ffffffff8137c64c>] __skb_recv_datagram+0x58/0x235
                             &list->lock              1          [<ffffffff81378c39>] skb_queue_tail+0x1f/0x4a

...............................................................................................................................................................................................

                              rtnl_mutex:             2              2        4480.04        4480.04        4480.04             76            845           1.49      218054.84      266398.47
                              ----------
                              rtnl_mutex              2          [<ffffffff8138b2e0>] rtnl_lock+0x12/0x14
                              ----------
                              rtnl_mutex              2          [<ffffffff8138b2e0>] rtnl_lock+0x12/0x14

...............................................................................................................................................................................................

                         &mm->mmap_sem-W:             0              0           0.00           0.00           0.00            504          74899           3.79       42849.12     1208640.60
                         &mm->mmap_sem-R:             2              2          59.15          59.15          59.15           3208         721952           3.29      538023.55     6258670.73
                         ---------------
                           &mm->mmap_sem              2          [<ffffffff814371de>] do_page_fault+0x18d/0x2c8
                         ---------------
                           &mm->mmap_sem              1          [<ffffffff810b6979>] sys_munmap+0x32/0x59
                           &mm->mmap_sem              1          [<ffffffff810b7701>] sys_mprotect+0xb8/0x1f3

...............................................................................................................................................................................................

                      set_atomicity_lock:             2              2        2389.47        2389.47        2389.47              3             19        2285.50        2285.50        2285.50
                      ------------------
                      set_atomicity_lock              2          [<ffffffff8101b4df>] prepare_set+0x10/0x76
                      ------------------
                      set_atomicity_lock              2          [<ffffffff8101b4df>] prepare_set+0x10/0x76

...............................................................................................................................................................................................

                        &input_pool.lock:             2              2           2.51           2.51           2.51           1799           9655           1.31          46.78        8981.53
                        ----------------
                        &input_pool.lock              1          [<ffffffff812121ce>] account+0x29/0xee
                        &input_pool.lock              1          [<ffffffff81211fce>] credit_entropy_bits+0x20/0x94
                        ----------------
                        &input_pool.lock              1          [<ffffffff81211db5>] mix_pool_bytes_extract+0x5b/0x14f
                        &input_pool.lock              1          [<ffffffff812121ce>] account+0x29/0xee

...............................................................................................................................................................................................

                      &sbinfo->stat_lock:             2              2           2.46           2.46           2.46           1547           7478           1.20          15.40        2871.28
                      ------------------
                      &sbinfo->stat_lock              1          [<ffffffff810a588d>] shmem_reserve_inode+0x23/0x51
                      &sbinfo->stat_lock              1          [<ffffffff810a58ee>] shmem_free_blocks+0x33/0x58
                      ------------------
                      &sbinfo->stat_lock              1          [<ffffffff810a624c>] shmem_getpage+0x529/0x7b5
                      &sbinfo->stat_lock              1          [<ffffffff810a588d>] shmem_reserve_inode+0x23/0x51

...............................................................................................................................................................................................

                             logbuf_lock:             2              2           4.79           4.79           4.79            150          87471           2.62          28.71       28995.32
                             -----------
                             logbuf_lock              1          [<ffffffff81041e4b>] release_console_sem+0x44/0x1aa
                             logbuf_lock              1          [<ffffffff81042a99>] do_syslog+0x16e/0x3c1
                             -----------
                             logbuf_lock              1          [<ffffffff81042a99>] do_syslog+0x16e/0x3c1
                             logbuf_lock              1          [<ffffffff81041e4b>] release_console_sem+0x44/0x1aa

...............................................................................................................................................................................................

                          &ids->rw_mutex:             2              2           5.78           5.78           5.78             33             36          11.11          69.38         181.14
                          --------------
                          &ids->rw_mutex              2          [<ffffffff811a7645>] shm_close+0x2f/0xce
                          --------------
                          &ids->rw_mutex              2          [<ffffffff811a7645>] shm_close+0x2f/0xce

...............................................................................................................................................................................................

                              &vec->lock:             5              1           0.99           0.99           0.99           1747           4392           1.31          17.87        2253.78
                              ----------
                              &vec->lock              4          [<ffffffff81092e5c>] cpupri_set+0x5c/0xd6
                              &vec->lock              1          [<ffffffff81092e9c>] cpupri_set+0x9c/0xd6
                              ----------
                              &vec->lock              4          [<ffffffff81092e5c>] cpupri_set+0x5c/0xd6
                              &vec->lock              1          [<ffffffff81092e9c>] cpupri_set+0x9c/0xd6

...............................................................................................................................................................................................

                  &nonblocking_pool.lock:             1              1           0.97           0.97           0.97           1065           5970           1.30          19.62        4856.07
                  ----------------------
                  &nonblocking_pool.lock              1          [<ffffffff81211db5>] mix_pool_bytes_extract+0x5b/0x14f
                  ----------------------
                  &nonblocking_pool.lock              1          [<ffffffff81211db5>] mix_pool_bytes_extract+0x5b/0x14f

...............................................................................................................................................................................................

                          sysfs_ino_lock:             1              1           0.93           0.93           0.93             47          13313           1.57        3856.90       13014.23
                          --------------
                          sysfs_ino_lock              1          [<ffffffff8111a17f>] sysfs_new_dirent+0x67/0x10b
                          --------------
                          sysfs_ino_lock              1          [<ffffffff8111a17f>] sysfs_new_dirent+0x67/0x10b

...............................................................................................................................................................................................

                   &ent->pde_unload_lock:             1              1           1.02           1.02           1.02            510          22452           1.20          87.53        9412.06
                   ---------------------
                   &ent->pde_unload_lock              1          [<ffffffff8110e577>] proc_reg_read+0x38/0xa1
                   ---------------------
                   &ent->pde_unload_lock              1          [<ffffffff8110e577>] proc_reg_read+0x38/0xa1

...............................................................................................................................................................................................

                                   key#2:             1              1           2.24           2.24           2.24           2601        8613447           1.26          76.98    19511285.96
                                   -----
                                   key#2              1          [<ffffffff81059b15>] remove_wait_queue+0x12/0x45
                                   -----
                                   key#2              1          [<ffffffff81030d63>] __wake_up_sync_key+0x27/0x5a

...............................................................................................................................................................................................

                          tty_ldisc_lock:             1              1           0.89           0.89           0.89            564           3379           1.29          13.51        1642.24
                          --------------
                          tty_ldisc_lock              1          [<ffffffff81219e64>] tty_ldisc_try+0x18/0x4b
                          --------------
                          tty_ldisc_lock              1          [<ffffffff81219e64>] tty_ldisc_try+0x18/0x4b

...............................................................................................................................................................................................

                              &cwq->lock:             1              1           1.65           1.65           1.65           3140          40338           1.18         378.27       62982.79
                              ----------
                              &cwq->lock              1          [<ffffffff810560e4>] worker_thread+0x274/0x2ae
                              ----------
                              &cwq->lock              1          [<ffffffff810553bb>] flush_cpu_workqueue+0x3c/0x91

...............................................................................................................................................................................................

                         nl_table_lock-W:             1              1           1.03           1.03           1.03              5            642           1.41          29.40         417.04
                         nl_table_lock-R:             0              0           0.00           0.00           0.00            140           3017           1.29           8.48        1103.50
                         ---------------
                           nl_table_lock              1          [<ffffffff813935d6>] netlink_table_grab+0x19/0xad
                         ---------------
                           nl_table_lock              1          [<ffffffff813940c2>] netlink_create+0xcf/0x20f

...............................................................................................................................................................................................

                        shost->host_lock:             1              1           2.47           2.47           2.47           1048          35579           1.11          70.18       40990.73
                        ----------------
                        shost->host_lock              1          [<ffffffff8124d46a>] scsi_alloc_target+0x199/0x2bf
                        ----------------
                        shost->host_lock              1          [<ffffffff812469d5>] scsi_dispatch_cmd+0xfe/0x1bd

...............................................................................................................................................................................................

                        proc_subdir_lock:             1              1           1.51           1.51           1.51            841           5200           1.21          59.91        6535.98
                        ----------------
                        proc_subdir_lock              1          [<ffffffff81112ef6>] proc_lookup_de+0x20/0xce
                        ----------------
                        proc_subdir_lock              1          [<ffffffff81112ef6>] proc_lookup_de+0x20/0xce

...............................................................................................................................................................................................

                            module_mutex:             1              1          24.59          24.59          24.59             21             35           3.47          17.93          52.36
                            ------------
                            module_mutex              1          [<ffffffff81070222>] m_start+0x1a/0x2e
                            ------------
                            module_mutex              1          [<ffffffff81070222>] m_start+0x1a/0x2e

...............................................................................................................................................................................................

                             pidmap_lock:             1              1           0.85           0.85           0.85           5068           8877           1.40          17.86        4755.99
                             -----------
                             pidmap_lock              1          [<ffffffff81057166>] alloc_pid+0x2a3/0x39d
                             -----------
                             pidmap_lock              1          [<ffffffff8105727c>] free_pid+0x1c/0x95

...............................................................................................................................................................................................

                         &ioc->FreeQlock:             1              1           1.39           1.39           1.39           9410          17164           1.28          29.38        9641.60
                         ---------------
                         &ioc->FreeQlock              1          [<ffffffff812ed9cc>] mpt_free_msg_frame+0x22/0x5f
                         ---------------
                         &ioc->FreeQlock              1          [<ffffffff812eda39>] mpt_get_msg_frame+0x30/0xbc

...............................................................................................................................................................................................

                          init_fs.lock-W:             0              0           0.00           0.00           0.00             60            196           1.53           6.93          89.91
                          init_fs.lock-R:             0              0           0.00           0.00           0.00            103           5260           1.81           9.89        2394.65
                             pin_fs_lock:             0              0           0.00           0.00           0.00              6            722           1.48          26.20         202.29
                 &type->s_umount_key#2/1:             0              0           0.00           0.00           0.00              0              1          23.86          23.86          23.86
                   thermal_cdev_idr.lock:             0              0           0.00           0.00           0.00              1             14           0.30           7.34          11.32
                      sysfs_ino_ida.lock:             0              0           0.00           0.00           0.00              4            351           1.11          13.62         116.89
                                vga_lock:             0              0           0.00           0.00           0.00              2           1552           4.69          56.67         697.59
                      perf_resource_lock:             0              0           0.00           0.00           0.00              0              4           0.43           0.44           0.87
                           binfmt_lock-W:             0              0           0.00           0.00           0.00              1              4           1.00           1.00           1.00
                           binfmt_lock-R:             0              0           0.00           0.00           0.00           1043           2662           1.29          56.36        1446.50
                                nls_lock:             0              0           0.00           0.00           0.00              1              5           0.32           5.28           6.60
                     sysdev_drivers_lock:             0              0           0.00           0.00           0.00              2             35           1.50       11133.54       11159.52
              running_helpers_waitq.lock:             0              0           0.00           0.00           0.00             33           1363           1.48           3.43         415.50
                                   key#2:             0              0           0.00           0.00           0.00              8             27          15.99          56.25         113.82
                      fsnotify_grp_mutex:             0              0           0.00           0.00           0.00              3              6           4.57          11.33          15.36
                &sb->s_type->i_mutex_key:             0              0           0.00           0.00           0.00            164           2601           5.00         236.36       34686.77
                             ioapic_lock:             0              0           0.00           0.00           0.00             13            634           6.95          23.97         973.64
                    &p->cred_guard_mutex:             0              0           0.00           0.00           0.00           2429           2642          46.08      982738.43     5882580.63
                         &sub_info->work:             0              0           0.00           0.00           0.00              0           1376         208.39       11328.80      143055.84
                        unnamed_dev_lock:             0              0           0.00           0.00           0.00              5             21           3.32          11.98          33.99
                    unnamed_dev_ida.lock:             0              0           0.00           0.00           0.00              5             56           0.95           6.50          22.89
                           sequence_lock:             0              0           0.00           0.00           0.00             31           2468           1.29          12.47         838.94
                       cache_chain_mutex:             0              0           0.00           0.00           0.00              2           2398          59.06         800.16       88579.58
                               pcpu_lock:             0              0           0.00           0.00           0.00             20            487           3.11          29.84         684.04
                   &type->s_umount_key/1:             0              0           0.00           0.00           0.00              0              1         130.89         130.89         130.89
                                 sb_lock:             0              0           0.00           0.00           0.00            211            474           1.29         290.59        1075.80
                           vmlist_lock-W:             0              0           0.00           0.00           0.00             15            252           1.94          20.40         234.47
                           vmlist_lock-R:             0              0           0.00           0.00           0.00            150            201           5.27          35.11         587.33
                             sysctl_lock:             0              0           0.00           0.00           0.00            103          58858           1.02          58.86       19768.68
                     sched_domains_mutex:             0              0           0.00           0.00           0.00              0              1        1693.97        1693.97        1693.97
                    pending_packets_lock:             0              0           0.00           0.00           0.00              1              2           0.39           5.62           6.01
                      call_function.lock:             0              0           0.00           0.00           0.00            263            265           3.20           6.89         185.25
                         mnt_id_ida.lock:             0              0           0.00           0.00           0.00             12             82           0.94           6.58          35.80
                          vmap_area_lock:             0              0           0.00           0.00           0.00             17            255           1.79         120.74         736.58
                  cpufreq_governor_mutex:             0              0           0.00           0.00           0.00              2              3           7.81           8.60           9.59
                          workqueue_lock:             0              0           0.00           0.00           0.00              2             10           1.22           4.85           8.67
                                   key#4:             0              0           0.00           0.00           0.00           2601          22545           1.28         373.60       44772.34
                 &type->s_umount_key#5/1:             0              0           0.00           0.00           0.00              0              3          77.58          77.58          77.58
                           &k->list_lock:             0              0           0.00           0.00           0.00             42           1580           1.29          27.51         672.81
                            dpm_list_mtx:             0              0           0.00           0.00           0.00             23           1047           1.89          10.95         501.09
                         cache_list_lock:             0              0           0.00           0.00           0.00              1             48           0.30           8.53          73.08
                     svc_xprt_class_lock:             0              0           0.00           0.00           0.00              1              2           0.39           4.70           5.09
                                   key#5:             0              0           0.00           0.00           0.00           2496           4127           1.33          57.54        7875.85
                                 khelper:             0              0           0.00           0.00           0.00              0           1376         210.15       11331.16      143647.73
            &sb->s_type->i_alloc_sem_key:             0              0           0.00           0.00           0.00              0             36           1.34           8.72          60.54
                                   key#6:             0              0           0.00           0.00           0.00           2664           4005           1.42         119.10        6786.29
                    struct class mutex#8:             0              0           0.00           0.00           0.00              0              4           1.79           9.20          14.62
                             &fs->lock-W:             0              0           0.00           0.00           0.00           2402           7269           1.34          29.32        4629.41
                             &fs->lock-R:             0              0           0.00           0.00           0.00           3683         104214           1.44         116.09       50112.29
                             &barr->work:             0              0           0.00           0.00           0.00              0              9          51.57          65.93         101.55
                                   key#7:             0              0           0.00           0.00           0.00           4471          14156           1.20          55.40       14704.58
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          31.60          31.60          31.60
              &sb->s_type->i_mutex_key#3:             0              0           0.00           0.00           0.00              0              2          33.45          92.24         125.69
        &(kretprobe_table_locks[i].lock):             0              0           0.00           0.00           0.00           1869           3743           1.39          13.34        1835.59
                          async_new.lock:             0              0           0.00           0.00           0.00             11             14           8.69          18.72          43.72
                       &drv->dynids.lock:             0              0           0.00           0.00           0.00              1           2074           0.49          35.93         727.02
                 &type->s_umount_key#6/1:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                         proto_list_lock:             0              0           0.00           0.00           0.00              2             11           1.06           2.70           8.30
                         net_family_lock:             0              0           0.00           0.00           0.00              2              5           0.75           1.52           2.27
                       &tty->hangup_work:             0              0           0.00           0.00           0.00              0             24           6.12          14.15          49.37
                      nl_table_wait.lock:             0              0           0.00           0.00           0.00            145           3378           1.25          12.91        1199.85
                              async_lock:             0              0           0.00           0.00           0.00             13             20           2.18          10.83          23.23
                 &type->s_umount_key#7/1:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
              &sb->s_type->i_mutex_key#2:             0              0           0.00           0.00           0.00              6            717          33.36         126.14        6445.90
                        sysfs_assoc_lock:             0              0           0.00           0.00           0.00             35           2732           1.31          12.20         844.24
                        pcpu_alloc_mutex:             0              0           0.00           0.00           0.00             19            379          14.03         594.50        3962.82
                         index_init_lock:             0              0           0.00           0.00           0.00              0             16           0.00           0.00           0.00
                                   key#3:             0              0           0.00           0.00           0.00           2361           2398           1.77          11.28        1587.47
                                   key#2:             0              0           0.00           0.00           0.00              0              3           0.38           5.58           6.34
                     file_systems_lock-W:             0              0           0.00           0.00           0.00              2             28           2.76          17.07          68.06
                     file_systems_lock-R:             0              0           0.00           0.00           0.00             36            103          12.94          86.07        1165.38
                        &newf->file_lock:             0              0           0.00           0.00           0.00           4441         453615           1.16         172.64      161840.74
                          die_chain.lock:             0              0           0.00           0.00           0.00              1              2           1.13           1.13           1.13
                shrinker_rwsem.wait_lock:             0              0           0.00           0.00           0.00              1             10           0.64           4.51           8.53
                         &ptr->list_lock:             0              0           0.00           0.00           0.00              4            113           0.60           2.49          27.94
                        trace_types_lock:             0              0           0.00           0.00           0.00              1              2           1.81           1.81           1.81
                panic_notifier_list.lock:             0              0           0.00           0.00           0.00              1              3           1.13           1.13           1.13
                          shrinker_rwsem:             0              0           0.00           0.00           0.00              1              5           3.89          11.55          17.32
                    &(&work.work)->timer:             0              0           0.00           0.00           0.00              0              4          22.90          22.90          22.90
                      &mousedev->mutex/3:             0              0           0.00           0.00           0.00              1              2          88.47          88.47          88.47
                                &q->lock:             0              0           0.00           0.00           0.00          10699          10702           2.07          12.01        7226.94
                 &rt_rq->rt_runtime_lock:             0              0           0.00           0.00           0.00            238           2383           1.26          10.06         984.32
                    percpu_counters_lock:             0              0           0.00           0.00           0.00              6            292           1.82          14.13         162.27
                         dev_base_lock-W:             0              0           0.00           0.00           0.00              5             14           1.60           2.66           9.04
                         dev_base_lock-R:             0              0           0.00           0.00           0.00             55            844           1.39         170.25        3403.40
                  &rt_b->rt_runtime_lock:             0              0           0.00           0.00           0.00             43             73           6.40          17.16         179.18
                           watchdog_lock:             0              0           0.00           0.00           0.00           2274           2279           9.70          25.68        7548.06
                             &p->pi_lock:             0              0           0.00           0.00           0.00             30            186           1.41          14.32         149.40
                                     key:             0              0           0.00           0.00           0.00            147            259           1.52          44.88         547.94
                       clocksource_mutex:             0              0           0.00           0.00           0.00              1              6           4.05        3157.67        3161.71
                                rtc_lock:             0              0           0.00           0.00           0.00              0          76041           0.30          21.31      864540.80
                      netlink_chain.lock:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                          &p->alloc_lock:             0              0           0.00           0.00           0.00           5918          40827           1.16          39.75       24183.38
                  old_style_seqlock_init:             0              0           0.00           0.00           0.00          12814          52850           1.29           9.21       24188.74
                     kthread_create_lock:             0              0           0.00           0.00           0.00             55            243           1.89           8.35          81.96
                          acpi_link_lock:             0              0           0.00           0.00           0.00              0              8        6428.78        8737.00       59537.35
                           acpi_prt_lock:             0              0           0.00           0.00           0.00              2             61           1.23          13.24          49.26
                             vector_lock:             0              0           0.00           0.00           0.00             13             98           2.30          13.54          72.04
                     tick_broadcast_lock:             0              0           0.00           0.00           0.00             12             16           3.34           6.87          13.90
                    &irq_desc_lock_class:             0              0           0.00           0.00           0.00           5637         171696           1.20         118.24       82391.05
                             kclist_lock:             0              0           0.00           0.00           0.00              1              5           0.30           1.00           2.53
                            chrdevs_lock:             0              0           0.00           0.00           0.00             34          22054           1.70          61.91       10574.37
                                misc_mtx:             0              0           0.00           0.00           0.00             17             72           3.00         464.88        2272.08
                    struct class mutex#5:             0              0           0.00           0.00           0.00              2             11           3.41           9.95          24.61
                              vga_lock#2:             0              0           0.00           0.00           0.00              0              1        3705.70        3705.70        3705.70
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          24.58          24.58          24.58
                            scsi_nl_lock:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                          hub_event_lock:             0              0           0.00           0.00           0.00              6             16           0.74           8.86          26.28
                         khubd_wait.lock:             0              0           0.00           0.00           0.00              6             13           0.81           7.35          17.95
                             serio_mutex:             0              0           0.00           0.00           0.00              2              5       83182.75      331880.61      415063.37
                        serio_event_lock:             0              0           0.00           0.00           0.00              8             13           0.65          10.93          33.41
                         serio_wait.lock:             0              0           0.00           0.00           0.00              8             14           0.76           9.70          27.60
                    struct class mutex#6:             0              0           0.00           0.00           0.00              2              5           4.17           4.78           8.34
               &(&hub->init_work)->timer:             0              0           0.00           0.00           0.00              0              8           5.14          17.45          58.65
                              genl_mutex:             0              0           0.00           0.00           0.00              1              5           2.48           8.01          10.49
                 init_mm.page_table_lock:             0              0           0.00           0.00           0.00              4          57593           1.61           2.66          54.89
                                   key#9:             0              0           0.00           0.00           0.00              6             12           6.11          12.57          18.87
                      &ps2dev->cmd_mutex:             0              0           0.00           0.00           0.00              0              5      165309.74      165556.62      413251.34
                                  events:             0              0           0.00           0.00           0.00              0           8850           0.81       15456.59      187763.25
                     &(&work.work)->work:             0              0           0.00           0.00           0.00              0              4          19.27          19.27          19.27
                              setup_lock:             0              0           0.00           0.00           0.00              1              4         350.12         540.57         800.60
                                    lock:             0              0           0.00           0.00           0.00              1              2        3356.64        3356.64        3356.64
                                   kstop:             0              0           0.00           0.00           0.00              0             18           1.02       11888.47       11889.70
                                 sm_work:             0              0           0.00           0.00           0.00              0              8       11885.03       11885.03       11885.03
                       trace_event_mutex:             0              0           0.00           0.00           0.00              1             90           1.07           6.34          96.73
             trace_event_mutex.wait_lock:             0              0           0.00           0.00           0.00              1            180           0.30           0.66          48.16
                 &type->s_umount_key#8/1:             0              0           0.00           0.00           0.00              0              1          33.52          33.52          33.52
                               bdev_lock:             0              0           0.00           0.00           0.00            215            699           1.36          26.80         682.02
                 &type->s_umount_key#9/1:             0              0           0.00           0.00           0.00              0              1          15.24          15.24          15.24
                                pnp_lock:             0              0           0.00           0.00           0.00              1             17           0.32           4.35          10.78
                    struct class mutex#7:             0              0           0.00           0.00           0.00              0              9           1.73           9.87          24.09
                         &tty->read_lock:             0              0           0.00           0.00           0.00            374           1519           1.22          19.95         740.99
                          hl_drivers_sem:             0              0           0.00           0.00           0.00              2              3           7.37          22.35          23.66
                hl_drivers_sem.wait_lock:             0              0           0.00           0.00           0.00              2              6           0.78           6.02           7.64
                            hl_irqs_lock:             0              0           0.00           0.00           0.00              2              3           1.14           5.34           5.74
                                &i->lock:             0              0           0.00           0.00           0.00              7            388           1.29          55.69       10669.20
                             buses_mutex:             0              0           0.00           0.00           0.00              1              1           6.43           6.43           6.43
                         inet_proto_lock:             0              0           0.00           0.00           0.00              2              7           0.79           5.97           8.21
                             inetsw_lock:             0              0           0.00           0.00           0.00              2              5           1.14           5.05           6.44
                           redirect_lock:             0              0           0.00           0.00           0.00             88            317           1.24           7.66         153.18
                 &tty->atomic_write_lock:             0              0           0.00           0.00           0.00              0            673          17.65        6466.61       38226.05
                  random_write_wait.lock:             0              0           0.00           0.00           0.00           1065           1366           1.17           7.79         660.69
                          neigh_tbl_lock:             0              0           0.00           0.00           0.00              2              2           5.65           5.65           5.65
                              ptype_lock:             0              0           0.00           0.00           0.00              3              7           1.05           5.61           9.42
                            &tbl->lock-W:             0              0           0.00           0.00           0.00             74            750           2.44         102.27         995.35
                            &tbl->lock-R:             0              0           0.00           0.00           0.00             90            663           1.92           8.05         408.85
                  raw_v4_hashinfo.lock-W:             0              0           0.00           0.00           0.00              1             34           0.33           6.44          18.37
                  raw_v4_hashinfo.lock-R:             0              0           0.00           0.00           0.00              2             19           1.16           1.83           9.47
                      tcp_cong_list_lock:             0              0           0.00           0.00           0.00              2              3        2230.05        4536.22        4536.98
                               uts_sem-W:             0              0           0.00           0.00           0.00              1              1           1.96           1.96           1.96
                               uts_sem-R:             0              0           0.00           0.00           0.00            483            660           4.22          75.53        1630.16
                    (cache_cleaner).work:             0              0           0.00           0.00           0.00              0             43           2.43          17.32         158.93
                       &bdev->bd_mutex/1:             0              0           0.00           0.00           0.00             10            113           6.16          18.15         263.09
                          xprt_list_lock:             0              0           0.00           0.00           0.00              1              3        3800.12        5532.75       13134.89
              &sb->s_type->i_mutex_key/1:             0              0           0.00           0.00           0.00              0            204          17.25         207.16        2469.46
               &sb->s_type->i_lock_key#5:             0              0           0.00           0.00           0.00           1040          15595           1.20          64.80        5624.54
                 &sb->s_type->i_lock_key:             0              0           0.00           0.00           0.00            120            321           1.23           9.81         116.10
                              &f->f_lock:             0              0           0.00           0.00           0.00            133           2981           1.17          29.19        2464.39
                         &mm->mmap_sem/1:             0              0           0.00           0.00           0.00              0           2953         304.59       18139.97      672380.73
                  net/sunrpc/cache.c:306:             0              0           0.00           0.00           0.00              0             42           1.54          16.75         215.80
               &sb->s_type->i_lock_key#6:             0              0           0.00           0.00           0.00             97           2628           1.22           8.45         944.03
                          therm_cpu_lock:             0              0           0.00           0.00           0.00              1              1          44.36          44.36          44.36
                          &dio->bio_lock:             0              0           0.00           0.00           0.00              0           1664           0.31           6.45        1461.33
                    struct class mutex#9:             0              0           0.00           0.00           0.00              0              4           1.80           8.96          14.41
                            uidhash_lock:             0              0           0.00           0.00           0.00             12             55           1.70           8.59          43.17
                                   key#1:             0              0           0.00           0.00           0.00              1              1           6.96           6.96           6.96
                         &watchdog_timer:             0              0           0.00           0.00           0.00              0           2274          14.61          39.59        9690.84
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          20.08          20.08          20.08
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          32.88          32.88          32.88
                       mb_cache_spinlock:             0              0           0.00           0.00           0.00             51            447           1.36          11.74         276.36
                                kdmflush:             0              0           0.00           0.00           0.00              0              4           5.76          68.22          73.97
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1         129.08         129.08         129.08
                      &md->deferred_lock:             0              0           0.00           0.00           0.00              2              2           0.42           5.46           5.88
            &sb->s_type->i_mutex_key#3/1:             0              0           0.00           0.00           0.00              0              1          58.90          58.90          58.90
                     old_style_spin_init:             0              0           0.00           0.00           0.00              0             76           0.30           0.52          24.48
                     &journal->j_barrier:             0              0           0.00           0.00           0.00              0              2          61.12          61.12          61.12
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          36.07          36.07          36.07
                           elv_list_lock:             0              0           0.00           0.00           0.00              4             36           4.67          10.12          32.05
                                   key#3:             0              0           0.00           0.00           0.00           1326           9059           1.21          59.19        9015.67
         &(&priv->bus_notifier)->rwsem-R:             0              0           0.00           0.00           0.00              2             43           2.16       38929.87       45967.76
                       &dev->devres_lock:             0              0           0.00           0.00           0.00              9             54           1.02           9.30          29.56
                            cm_sbs_mutex:             0              0           0.00           0.00           0.00              2              2          66.34          66.34          66.34
                    struct class mutex#1:             0              0           0.00           0.00           0.00              2              8          10.80          12.29          20.78
                             input_mutex:             0              0           0.00           0.00           0.00              3              8          25.27         283.78         637.50
            input_devices_poll_wait.lock:             0              0           0.00           0.00           0.00              2              6           0.77           6.67           8.16
                     cpuidle_driver_lock:             0              0           0.00           0.00           0.00              1              1           4.52           4.52           4.52
                                   key#3:             0              0           0.00           0.00           0.00              3             10           0.80           9.79          13.83
                        thermal_idr_lock:             0              0           0.00           0.00           0.00              1             16           0.69           8.11          19.34
                    struct class mutex#1:             0              0           0.00           0.00           0.00              1             16           1.78          10.49          39.08
                       thermal_list_lock:             0              0           0.00           0.00           0.00              1             16           0.54           7.91          16.22
                                &u->lock:             0              0           0.00           0.00           0.00            269          10216           1.26          42.51        8699.40
                     &blocking_pool.lock:             0              0           0.00           0.00           0.00              3             17           1.19           6.27          24.32
                    struct class mutex#1:             0              0           0.00           0.00           0.00              1            587           1.52           9.61        1056.71
                         async_done.lock:             0              0           0.00           0.00           0.00              6              8           1.40          14.22          16.77
                    struct class mutex#1:             0              0           0.00           0.00           0.00              4             14           2.78          13.81          36.35
                               tty_mutex:             0              0           0.00           0.00           0.00            203            661           3.77         310.98        2900.62
                             &dev->mutex:             0              0           0.00           0.00           0.00              4             11           2.27          63.77          75.73
                        &dev->event_lock:             0              0           0.00           0.00           0.00              0             14          24.62          26.15          32.87
                    init_sighand.siglock:             0              0           0.00           0.00           0.00              1              8           0.73           9.07          11.97
                                pci_lock:             0              0           0.00           0.00           0.00              6           8647           4.28          22.22       22468.25
                         &q->unplug_work:             0              0           0.00           0.00           0.00              0             99          16.56         152.32         853.01
                    struct class mutex#4:             0              0           0.00           0.00           0.00              0             13           0.00           0.00           0.00
                              i8253_lock:             0              0           0.00           0.00           0.00              0              4           0.00           0.00           0.00
                   pci_bus_sem.wait_lock:             0              0           0.00           0.00           0.00              2           1588           0.59           7.85         497.54
                    struct class mutex#2:             0              0           0.00           0.00           0.00              1              2           1.64          14.73          16.37
                           pci_bus_sem-W:             0              0           0.00           0.00           0.00              0             89           0.88           1.32          84.61
                           pci_bus_sem-R:             0              0           0.00           0.00           0.00              2            705           1.95         743.90        1641.47
                    probe_waitqueue.lock:             0              0           0.00           0.00           0.00              6             90           1.02           8.44          40.02
                       semaphore->lock#2:             0              0           0.00           0.00           0.00             67            958           0.87           2.20         189.83
                     init_task.file_lock:             0              0           0.00           0.00           0.00             19           1377           4.91          27.73        1366.28
                        tick_device_lock:             0              0           0.00           0.00           0.00              4              7           8.16           8.16           8.16
                             i8259A_lock:             0              0           0.00           0.00           0.00              7            143           4.15         134.55         396.09
                        acpi_device_lock:             0              0           0.00           0.00           0.00              0            126           2.28          11.31          57.36
                                pm_mutex:             0              0           0.00           0.00           0.00              0              1           6.05           6.05           6.05
                         semaphore->lock:             0              0           0.00           0.00           0.00              7         134310           0.59          10.56       25925.59
                           acpi_res_lock:             0              0           0.00           0.00           0.00              0             11           0.39          11.17          15.90
                       acpi_gbl_gpe_lock:             0              0           0.00           0.00           0.00              0              4           0.33           5.41           9.12
                                cpa_lock:             0              0           0.00           0.00           0.00              3          65690           0.62          31.81       21106.38
                    init_task.alloc_lock:             0              0           0.00           0.00           0.00              0              6           0.36           1.14           3.95
                  acpi_gbl_hardware_lock:             0              0           0.00           0.00           0.00              1             13           5.66          14.65          43.96
                           kacpi_hotplug:             0              0           0.00           0.00           0.00              0              1        8211.59        8211.59        8211.59
                              purge_lock:             0              0           0.00           0.00           0.00              3             26           2.39         122.12         186.56
                            kacpi_notify:             0              0           0.00           0.00           0.00              0              1        8254.79        8254.79        8254.79
                             pm_qos_lock:             0              0           0.00           0.00           0.00              2              4           1.69           7.76           9.45
                                   key#8:             0              0           0.00           0.00           0.00           1056           2114           1.34           8.38        1232.28
                                 smp_alt:             0              0           0.00           0.00           0.00              0              4           0.61           5.45           8.11
                         &on_slab_l3_key:             0              0           0.00           0.00           0.00           3960           6062           1.19          34.85        7015.74
                 &rcu_bh_state.onofflock:             0              0           0.00           0.00           0.00              0              4           0.91           1.21           2.11
                   (linkwatch_work).work:             0              0           0.00           0.00           0.00              0              2        7300.09        7300.09        7300.09
                                   key#4:             0              0           0.00           0.00           0.00              0             12           0.86           9.34          24.95
                        lweventlist_lock:             0              0           0.00           0.00           0.00              2              4           0.77           9.48          10.25
                &adapter->phy_info_timer:             0              0           0.00           0.00           0.00              0              1           9.20           9.20           9.20
                      &tp->indirect_lock:             0              0           0.00           0.00           0.00              0             14           3.54          12.45          59.29
                   &(vmstat_work)->timer:             0              0           0.00           0.00           0.00              0           3577           6.60          45.58       18000.34
                     &(reap_work)->timer:             0              0           0.00           0.00           0.00              0           2272           6.02          22.61        7427.46
                    &(vmstat_work)->work:             0              0           0.00           0.00           0.00              0           3577           7.80          51.75       10793.06
                      &(reap_work)->work:             0              0           0.00           0.00           0.00              0           2272          77.53         809.14       90978.09
                             cdrom_mutex:             0              0           0.00           0.00           0.00              0              1           9.35           9.35           9.35
                       sg_index_idr.lock:             0              0           0.00           0.00           0.00              0             14           0.35           8.31          13.27
                           sg_index_lock:             0              0           0.00           0.00           0.00              2              5           4.93          22.68          29.58
                    struct class mutex#1:             0              0           0.00           0.00           0.00              3              5           3.03          15.14          20.49
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00              1              2           0.91          13.26          14.17
                     &ioc->taskmgmt_lock:             0              0           0.00           0.00           0.00              9           1235          10.22          18.97        1838.65
                &ioc->mptbase_cmds.mutex:             0              0           0.00           0.00           0.00              5             98         114.05       17963.05       56645.74
                                   key#1:             0              0           0.00           0.00           0.00              8            300           9.67          18.67         443.36
                    struct class mutex#1:             0              0           0.00           0.00           0.00              4              6           4.18          15.63          23.33
               &ioc->taskmgmt_cmds.mutex:             0              0           0.00           0.00           0.00              1              2      635071.25      635192.45     1270263.70
                          &sbi->wq_mutex:             0              0           0.00           0.00           0.00              0              2           0.84           8.27           9.11
                  &spi_dv_mutex(starget):             0              0           0.00           0.00           0.00              0              4       19920.00       49895.99      113803.62
                       sd_index_ida.lock:             0              0           0.00           0.00           0.00              0             20           0.35          12.93          19.74
                           sd_index_lock:             0              0           0.00           0.00           0.00              0              2           1.66          14.09          15.75
                    &client->packet_lock:             0              0           0.00           0.00           0.00              0              7           0.31           4.20           6.68
                       &sdev->event_work:             0              0           0.00           0.00           0.00              0             26           0.25          12.57          18.73
                        &q->unplug_timer:             0              0           0.00           0.00           0.00              0             94          15.17          35.46         292.15
                             &q->timeout:             0              0           0.00           0.00           0.00              0            143           4.78          15.82         148.07
                               &ep->lock:             0              0           0.00           0.00           0.00              0              7           0.31           3.67           6.14
                          &q->sysfs_lock:             0              0           0.00           0.00           0.00              0             26           0.52          16.36          40.24
                         &eq->sysfs_lock:             0              0           0.00           0.00           0.00              0             26           5.74          49.00         197.76
                 &cfqd->idle_slice_timer:             0              0           0.00           0.00           0.00              0            489           3.36          53.52        1618.84
                      &cfqd->unplug_work:             0              0           0.00           0.00           0.00              0           1775           3.21         498.47        7590.90
        &(&ioc->fault_reset_work)->timer:             0              0           0.00           0.00           0.00              0           1133           8.55          26.65        5666.46
                (ioc->reset_work_q_name):             0              0           0.00           0.00           0.00              0           1133           6.65          31.94        4278.30
         &(&ioc->fault_reset_work)->work:             0              0           0.00           0.00           0.00              0           1133           5.38          15.18        3564.19
                         &bdev->bd_mutex:             0              0           0.00           0.00           0.00             60            510           3.78      525203.14     1321857.88
                            sd_ref_mutex:             0              0           0.00           0.00           0.00             24            261           2.72          16.51         232.42
                      &sync_supers_timer:             0              0           0.00           0.00           0.00              0            189           3.69          14.67         795.22
             &inode->i_data.private_lock:             0              0           0.00           0.00           0.00           1234          14788           1.26          52.97        7437.89
                   &(&hh->hh_lock)->lock:             0              0           0.00           0.00           0.00              1              6           0.88          13.63          15.65
               &sb->s_type->i_lock_key#2:             0              0           0.00           0.00           0.00              1              2           0.60           6.67           7.27
                    struct class mutex#2:             0              0           0.00           0.00           0.00              1              1          33.30          33.30          33.30
                    struct class mutex#2:             0              0           0.00           0.00           0.00              0              5           1.58           9.50          15.85
                       usb_bus_list_lock:             0              0           0.00           0.00           0.00              0              9           0.56       11575.01       45706.01
                              pools_lock:             0              0           0.00           0.00           0.00              0             26           0.45          15.24          40.65
             (usb_notifier_list).rwsem-R:             0              0           0.00           0.00           0.00              0             10          13.78         430.49        1359.58
     (usb_notifier_list).rwsem.wait_lock:             0              0           0.00           0.00           0.00              0             20           0.30           7.08          13.93
                              &new->lock:             0              0           0.00           0.00           0.00             32             70           2.46          11.76          58.77
              &sb->s_type->i_mutex_key#4:             0              0           0.00           0.00           0.00             10             52           3.11          36.28         254.76
                   deviceconndiscwq.lock:             0              0           0.00           0.00           0.00              0             10           0.36           7.97          11.58
                                mon_lock:             0              0           0.00           0.00           0.00              0              8           0.51           9.72          14.01
                           &retval->lock:             0              0           0.00           0.00           0.00             15           1124           1.12          33.13         578.36
              ehci_cf_port_reset_rwsem-W:             0              0           0.00           0.00           0.00              0              1        6655.91        6655.91        6655.91
              ehci_cf_port_reset_rwsem-R:             0              0           0.00           0.00           0.00              2              5      164086.43      221684.48      496021.90
      ehci_cf_port_reset_rwsem.wait_lock:             0              0           0.00           0.00           0.00              2             12           0.74           7.47          11.63
                             &ehci->lock:             0              0           0.00           0.00           0.00             20            103           9.32         322.28        1009.92
                       device_state_lock:             0              0           0.00           0.00           0.00              4             32           0.73           8.02          22.55
                       hcd_root_hub_lock:             0              0           0.00           0.00           0.00              6            319           0.60          28.71         273.67
                       hcd_urb_list_lock:             0              0           0.00           0.00           0.00             15            296           1.47          10.57         116.94
                                   key#1:             0              0           0.00           0.00           0.00              8            310           0.63           9.36         255.42
                         set_config_lock:             0              0           0.00           0.00           0.00              0              6           0.36           9.31          11.29
                &new_driver->dynids.lock:             0              0           0.00           0.00           0.00              2             25           1.17          13.07          21.81
                      &hub->status_mutex:             0              0           0.00           0.00           0.00              3             34          30.22         448.97        1424.86
                             &uhci->lock:             0              0           0.00           0.00           0.00              2           4702          16.41          66.06       26908.73
                           sr_index_lock:             0              0           0.00           0.00           0.00              0              1           9.31           9.31           9.31
                &(&hub->init_work)->work:             0              0           0.00           0.00           0.00              0              8           5.98         411.30         620.50
                              i8042_lock:             0              0           0.00           0.00           0.00              4             41           6.40         321.96        4011.45
                                   key#1:             0              0           0.00           0.00           0.00              0              3           0.38           6.92          10.84
                             io_tlb_lock:             0              0           0.00           0.00           0.00             10            132           0.71          18.10          98.88
                                    work:             0              0           0.00           0.00           0.00              0              3          36.57        8254.29       16502.02
                       &serio->drv_mutex:             0              0           0.00           0.00           0.00              1              3       82936.46      165951.46      414357.93
                            &serio->lock:             0              0           0.00           0.00           0.00              4             32           0.65          17.24          54.24
                       hierarchy_id_lock:             0              0           0.00           0.00           0.00              0              1           8.66           8.66           8.66
                             i8042_mutex:             0              0           0.00           0.00           0.00              2              5      165292.09      165538.22      413229.48
                                   key#1:             0              0           0.00           0.00           0.00              3             22           0.72          13.80          38.12
                                 _lock-W:             0              0           0.00           0.00           0.00              0              3           1.25          18.54          21.35
                                 _lock-R:             0              0           0.00           0.00           0.00              2              9           3.06           7.20          18.01
                         _lock.wait_lock:             0              0           0.00           0.00           0.00              2             24           0.89           6.40          13.32
                     cpufreq_driver_lock:             0              0           0.00           0.00           0.00              1             86           0.60           7.32          35.22
                            cpuidle_lock:             0              0           0.00           0.00           0.00              0              2        3022.02        3199.03        6221.05
                   inet_diag_table_mutex:             0              0           0.00           0.00           0.00              0              1           5.64           5.64           5.64
                            inetsw6_lock:             0              0           0.00           0.00           0.00              0              4           0.30           4.61           5.78
                    raw_v6_hashinfo.lock:             0              0           0.00           0.00           0.00              0             38           0.33           6.74          19.26
                        inet6_proto_lock:             0              0           0.00           0.00           0.00              0              8           0.31           3.85           7.22
                  &ip6addrlbl_table.lock:             0              0           0.00           0.00           0.00              0              8           0.31           5.22           7.84
                           &ndev->lock-W:             0              0           0.00           0.00           0.00              0             14           1.11           6.79          21.92
                           &ndev->lock-R:             0              0           0.00           0.00           0.00            267            456           1.44          32.02         423.40
                          &idev->mc_lock:             0              0           0.00           0.00           0.00              1             11           0.88           5.23           9.55
                           &mc->mca_lock:             0              0           0.00           0.00           0.00              3             19           0.97         341.51         399.80
                             _xmit_ETHER:             0              0           0.00           0.00           0.00              9             14         332.90         698.30        1718.61
                    addrconf_verify_lock:             0              0           0.00           0.00           0.00              0             10          12.35          28.20         144.63
                    addrconf_hash_lock-W:             0              0           0.00           0.00           0.00              2              2          36.50          36.50          36.50
                    addrconf_hash_lock-R:             0              0           0.00           0.00           0.00              7            181           2.37          27.96         117.43
                           tunnel4_mutex:             0              0           0.00           0.00           0.00              0              1           5.87           5.87           5.87
                    net_generic_ids.lock:             0              0           0.00           0.00           0.00              0             18           0.30           5.85          11.42
                      usb_address0_mutex:             0              0           0.00           0.00           0.00              2              3       55452.56      295820.45      595960.37
              &net->packet.sklist_lock-W:             0              0           0.00           0.00           0.00              3              5           1.16           2.50           4.30
              &net->packet.sklist_lock-R:             0              0           0.00           0.00           0.00              6             17           1.62           7.76          15.84
                        vlan_ioctl_mutex:             0              0           0.00           0.00           0.00              0              1           5.06           5.06           5.06
                       performance_mutex:             0              0           0.00           0.00           0.00              0              1          58.43          58.43          58.43
                  disable_ratelimit_lock:             0              0           0.00           0.00           0.00              0             16           0.30           4.72           9.29
         &per_cpu(cpu_policy_rwsem, cpu):             0              0           0.00           0.00           0.00              0              8           1.19       11084.21       11099.67
                          &hcd->rh_timer:             0              0           0.00           0.00           0.00              0           4546           6.52          18.72       33506.43
                               cdev_lock:             0              0           0.00           0.00           0.00            598            992           1.31          13.41         798.74
                  &shost->free_list_lock:             0              0           0.00           0.00           0.00            813           7904           1.22          14.11        3095.26
                         &tty->echo_lock:             0              0           0.00           0.00           0.00              9             99           1.78          10.59          65.37
                     &tty->termios_mutex:             0              0           0.00           0.00           0.00            325            766           1.81          46.26        1083.63
                      ata_scsi_rbuf_lock:             0              0           0.00           0.00           0.00              0              2           1.89          19.33          21.22
                                   key#2:             0              0           0.00           0.00           0.00            377           1783           1.22          36.92        2064.54
                     tty_ldisc_wait.lock:             0              0           0.00           0.00           0.00             28             46           1.28           8.30          25.87
                             &port->lock:             0              0           0.00           0.00           0.00             95            140           1.66           9.10          86.48
                              hash_mutex:             0              0           0.00           0.00           0.00              6             21           3.74          38.59         164.63
                                  kacpid:             0              0           0.00           0.00           0.00              0              1          37.25          37.25          37.25
                                   key#2:             0              0           0.00           0.00           0.00             95            268           1.26           9.00         119.38
                                   key#1:             0              0           0.00           0.00           0.00             78           2298           1.02          22.78        3881.62
                    &mm->page_table_lock:             0              0           0.00           0.00           0.00           2738          82389           0.96         129.24       29174.69
                        &sdev->list_lock:             0              0           0.00           0.00           0.00           1032          15808           1.03          21.20        6586.04
                     __pte_lockptr(page):             0              0           0.00           0.00           0.00          39525        1060060           1.20        1090.88     1213057.28
                   __pte_lockptr(page)/1:             0              0           0.00           0.00           0.00           4717          55824           1.21         478.41      161283.82
                        block_class_lock:             0              0           0.00           0.00           0.00             42          17534           1.70          56.92        8549.26
                      hierarchy_ida.lock:             0              0           0.00           0.00           0.00              0             16           0.30           9.66          14.28
                        cpu_hotplug.lock:             0              0           0.00           0.00           0.00              5            267           1.85      108005.96      320915.94
                              &ret->lock:             0              0           0.00           0.00           0.00            108           1204           1.21          39.15        2643.51
                       &tty->output_lock:             0              0           0.00           0.00           0.00            116            787           3.61        5813.14       29367.09
                 &type->s_umount_key#1-W:             0              0           0.00           0.00           0.00              3              3           5.89          11.37          13.89
                 &type->s_umount_key#1-R:             0              0           0.00           0.00           0.00              1              2           0.89           1.68           2.56
                        &namespace_sem-W:             0              0           0.00           0.00           0.00              4             25          15.69          78.61         223.05
                        &namespace_sem-R:             0              0           0.00           0.00           0.00            128            450           4.65         307.85       10406.31
                                   key#2:             0              0           0.00           0.00           0.00             21            324           1.20           9.91         118.81
                       clock-AF_PACKET-W:             0              0           0.00           0.00           0.00              0              2          10.20          10.20          10.20
                       clock-AF_PACKET-R:             0              0           0.00           0.00           0.00              1              3           1.94           7.46          12.22
                                &p->lock:             0              0           0.00           0.00           0.00              3           7494           1.96      285651.62     1903373.65
               &sb->s_type->i_lock_key#3:             0              0           0.00           0.00           0.00            504           4120           1.20          12.61        1524.76
                 &type->s_umount_key#1-W:             0              0           0.00           0.00           0.00              2              2        1941.95        1941.95        1941.95
                 &type->s_umount_key#1-R:             0              0           0.00           0.00           0.00              0              2           0.96           1.87           2.82
                  sysfs_open_dirent_lock:             0              0           0.00           0.00           0.00            167          18318           1.12          13.02        7134.83
                          &buffer->mutex:             0              0           0.00           0.00           0.00              2           6164           1.92        7991.78       65018.81
               &sb->s_type->i_lock_key#4:             0              0           0.00           0.00           0.00           1425           2780           1.31           6.62        1141.62
                           bio_slab_lock:             0              0           0.00           0.00           0.00              1              3        2987.78        2988.26        2989.74
                            sr_ref_mutex:             0              0           0.00           0.00           0.00              6            150           3.47          12.13         144.92
                      &shost->scan_mutex:             0              0           0.00           0.00           0.00              1              3      124697.48     3378497.51     6879124.52
                       uts_sem.wait_lock:             0              0           0.00           0.00           0.00            484           1322           1.17           6.54         586.27
              &sb->s_type->i_mutex_key#6:             0              0           0.00           0.00           0.00             47           1197           2.06          33.72         830.98
                         &ehci->watchdog:             0              0           0.00           0.00           0.00              0              7          26.82          38.36          70.96
                                   key#1:             0              0           0.00           0.00           0.00              3            447           0.66           7.81         177.20
                                 kblockd:             0              0           0.00           0.00           0.00              0           1770           5.46         501.77        9574.86
                           &bdi->wb_lock:             0              0           0.00           0.00           0.00             13             18           2.13           3.27          10.62
                      clock-AF_NETLINK-W:             0              0           0.00           0.00           0.00              2            155           1.38           2.22          59.51
                      clock-AF_NETLINK-R:             0              0           0.00           0.00           0.00             15           1471           1.23          33.43         604.27
                                   key#2:             0              0           0.00           0.00           0.00             11           1596           1.24          13.67         636.05
                               net_mutex:             0              0           0.00           0.00           0.00              2             50           5.15        4115.70        8220.41
                                     ata:             0              0           0.00           0.00           0.00              0           1051          52.50       10930.16       41683.31
                                   key#1:             0              0           0.00           0.00           0.00              2           1347           0.64          16.30        2027.73
                                bdi_lock:             0              0           0.00           0.00           0.00             12            265           2.31          10.51         430.68
                 &type->s_umount_key#1-W:             0              0           0.00           0.00           0.00              1              2          10.08          13.67          23.74
                 &type->s_umount_key#1-R:             0              0           0.00           0.00           0.00              0              2           0.89           1.49           2.38
                    &ap->fastdrain_timer:             0              0           0.00           0.00           0.00              0            447           0.44           4.17         114.71
          &sb->s_type->i_alloc_sem_key#2:             0              0           0.00           0.00           0.00             12             49           7.89          16.16         114.19
                          sysfs_bin_lock:             0              0           0.00           0.00           0.00              1            304           0.47           8.65         180.65
           &flush_state[i].tlbstate_lock:             0              0           0.00           0.00           0.00              3           1551           8.61        3647.46        7883.66
                 &sysfs_inode_imutex_key:             0              0           0.00           0.00           0.00              0             15           2.06          49.56          58.52
          &sb->s_type->i_alloc_sem_key#3:             0              0           0.00           0.00           0.00              0              3          21.93          21.93          21.93
                 &(&ap->port_task)->work:             0              0           0.00           0.00           0.00              0           1947          17.49       10924.22       41363.67
                           psmouse_mutex:             0              0           0.00           0.00           0.00              0              1       82918.90       82918.90       82918.90
              &sb->s_type->i_mutex_key#9:             0              0           0.00           0.00           0.00              2              4           5.16          16.41          21.57
               &sb->s_type->i_lock_key#7:             0              0           0.00           0.00           0.00              2              3           0.98           3.97           4.60
                    struct class mutex#3:             0              0           0.00           0.00           0.00              4             30           9.15          10.25          55.98
                             fasync_lock:             0              0           0.00           0.00           0.00            238           1535           1.20           9.11         700.92
                             rename_lock:             0              0           0.00           0.00           0.00             14             66          10.81          26.59         231.90
                       &dentry->d_lock/1:             0              0           0.00           0.00           0.00              0             66           1.62           4.39          41.34
                   &inode->inotify_mutex:             0              0           0.00           0.00           0.00            253           1462           1.80           9.75         907.70
                            _hash_lock-W:             0              0           0.00           0.00           0.00              2              9           8.88          14.78          25.73
                            _hash_lock-R:             0              0           0.00           0.00           0.00              9             92          12.26          49.77         262.29
                    _hash_lock.wait_lock:             0              0           0.00           0.00           0.00             11            202           1.30           8.94          90.46
                                  work#2:             0              0           0.00           0.00           0.00              0              8           1.72         102.28         104.00
                          proc_inum_lock:             0              0           0.00           0.00           0.00             16            453           4.14          21.89         519.39
              &rcu_sched_state.onofflock:             0              0           0.00           0.00           0.00              0              4           0.94           1.25           2.19
                         _minor_idr.lock:             0              0           0.00           0.00           0.00              1             14           0.31           9.96          14.28
                             _minor_lock:             0              0           0.00           0.00           0.00              9             24           3.31          14.39          31.85
                         &md->map_lock-W:             0              0           0.00           0.00           0.00              0              2           0.96           0.98           1.94
                         &md->map_lock-R:             0              0           0.00           0.00           0.00             13            142           1.28           9.73          62.66
                       &md->suspend_lock:             0              0           0.00           0.00           0.00              0              6          10.46          87.22         169.82
                &bdev->bd_fsfreeze_mutex:             0              0           0.00           0.00           0.00              1              6          47.70          58.05          65.49
                          &md->io_lock-W:             0              0           0.00           0.00           0.00              2              6           3.53          26.82          32.52
                          &md->io_lock-R:             0              0           0.00           0.00           0.00              3             68          13.13          28.84         283.13
                                   key#1:             0              0           0.00           0.00           0.00              5            449           1.71          13.49         200.03
                                   key#2:             0              0           0.00           0.00           0.00              2             10           0.75           5.64           9.66
                             _event_lock:             0              0           0.00           0.00           0.00              1              2           0.81           5.60           6.40
                               &md->work:             0              0           0.00           0.00           0.00              0              2           4.67          30.12          34.78
                &(&tty->buf.work)->timer:             0              0           0.00           0.00           0.00              0           2153           1.06          32.46        1935.60
                   random_read_wait.lock:             0              0           0.00           0.00           0.00            313           1044           1.33          12.91         542.12
                                   key#2:             0              0           0.00           0.00           0.00              0              4           0.36           8.70          13.63
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              2       25887.31       25887.31       25887.31
                    sysrq_key_table_lock:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                    struct class mutex#1:             0              0           0.00           0.00           0.00              2              4           3.28          13.85          17.12
                     host_cmd_pool_mutex:             0              0           0.00           0.00           0.00              2              4           1.56          82.51          84.07
                &rcu_sched_state.fqslock:             0              0           0.00           0.00           0.00              0           1856           8.57          30.60        7329.19
                       &type->s_lock_key:             0              0           0.00           0.00           0.00             90            506           2.09         366.46        2079.78
                                   key#3:             0              0           0.00           0.00           0.00             16            956           1.28           7.51         377.54
                      proc_inum_ida.lock:             0              0           0.00           0.00           0.00             15            882           1.24           6.21         251.48
                                   key#3:             0              0           0.00           0.00           0.00            365           2836           1.28          44.72        5561.55
                                  lock#2:             0              0           0.00           0.00           0.00              1              1          11.85          11.85          11.85
                                  &timer:             0              0           0.00           0.00           0.00              0           2388           0.87          26.73        3306.86
                       &tty->ldisc_mutex:             0              0           0.00           0.00           0.00            101            157           1.88          66.61         347.23
                         pci_config_lock:             0              0           0.00           0.00           0.00              6           8853           5.19          13.22       17329.66
               &sb->s_type->i_lock_key#9:             0              0           0.00           0.00           0.00            686            917           1.29          37.30         494.65
                         &hdrv->dyn_lock:             0              0           0.00           0.00           0.00              0             56           0.30          11.13          29.93
                         dquirks_rwsem-R:             0              0           0.00           0.00           0.00              0              2           1.48          33.63          35.10
                 dquirks_rwsem.wait_lock:             0              0           0.00           0.00           0.00              0              4           0.30          10.90          11.92
                           &usbhid->lock:             0              0           0.00           0.00           0.00              1              6          22.00          32.35          48.94
                                   key#3:             0              0           0.00           0.00           0.00              0              9           0.32          10.00          12.70
                            hid_open_mut:             0              0           0.00           0.00           0.00              1              2          45.59          45.59          45.59
                                   key#3:             0              0           0.00           0.00           0.00              0              1          17.01          17.01          17.01
                                   key#3:             0              0           0.00           0.00           0.00            120            192           1.48          14.29         239.35
                                   key#3:             0              0           0.00           0.00           0.00            119            188           1.66           7.42         104.87
                       vt_spawn_con.lock:             0              0           0.00           0.00           0.00              1              1           5.78           5.78           5.78
                 &(&tty->buf.work)->work:             0              0           0.00           0.00           0.00              0            289           0.86         107.62        3138.17
             &transaction->t_handle_lock:             0              0           0.00           0.00           0.00            475           5295           1.22          58.12        4363.55
                 &type->s_umount_key#2-W:             0              0           0.00           0.00           0.00              0              1        1363.46        1363.46        1363.46
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              2             31          16.61       34981.46       50992.48
                              &up->timer:             0              0           0.00           0.00           0.00              0             10           0.49           4.81           6.91
                          &tty->buf.lock:             0              0           0.00           0.00           0.00             45           1356           1.22          20.97         593.82
                    struct class mutex#1:             0              0           0.00           0.00           0.00              4              6        1204.16       20326.29       26366.94
                               swap_lock:             0              0           0.00           0.00           0.00            153            202           1.59          26.83         153.76
                    struct class mutex#2:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                         clock-AF_UNIX-W:             0              0           0.00           0.00           0.00              6           3051           1.20           3.94        1183.76
                         clock-AF_UNIX-R:             0              0           0.00           0.00           0.00            230           4856           1.00         105.53        9430.62
                         rcu_read_lock-R:             0              0           0.00           0.00           0.00              0       88361764           0.85         491.94   213780818.50
                                   key#3:             0              0           0.00           0.00           0.00             90           4040           1.09           6.16        1567.67
      &af_unix_sk_receive_queue_lock_key:             0              0           0.00           0.00           0.00            243           9464           1.20           5.94        3256.10
            &sb->s_type->i_mutex_key#1/1:             0              0           0.00           0.00           0.00            137            651           3.01          89.91        1582.54
                 &type->s_umount_key#2-W:             0              0           0.00           0.00           0.00              1              1          38.75          38.75          38.75
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           0.91           1.88           2.79
            &sb->s_type->i_mutex_key#4/1:             0              0           0.00           0.00           0.00              1              1          16.68          16.68          16.68
                                   key#4:             0              0           0.00           0.00           0.00            112            136           1.47          12.14          82.73
                           slock-AF_UNIX:             0              0           0.00           0.00           0.00              0            102           1.44           7.39          51.37
                         sk_lock-AF_UNIX:             0              0           0.00           0.00           0.00              0             51           1.43           6.78          31.47
                   &futex_queues[i].lock:             0              0           0.00           0.00           0.00            389           4118           1.29         141.23        3822.47
                            &u->readlock:             0              0           0.00           0.00           0.00            126           1601           7.35       29634.95       38039.51
                        slock-AF_NETLINK:             0              0           0.00           0.00           0.00              0            108           1.18           5.12          40.52
                      sk_lock-AF_NETLINK:             0              0           0.00           0.00           0.00              0             54           1.32           9.81          50.85
                             &info->lock:             0              0           0.00           0.00           0.00             10           4557           1.36         122.35        5662.45
                              &idp->lock:             0              0           0.00           0.00           0.00              3            102           0.61          10.59          44.51
           &group->inotify_data.idr_lock:             0              0           0.00           0.00           0.00              1             76           0.93           7.43          52.14
               attribute_container_mutex:             0              0           0.00           0.00           0.00              9            157           1.96         555.12        2160.50
                    struct class mutex#1:             0              0           0.00           0.00           0.00              5             35           7.92          15.88          58.60
                  bus_type_sem.wait_lock:             0              0           0.00           0.00           0.00             23           2088           1.24           7.33         675.69
                        target_list_lock:             0              0           0.00           0.00           0.00              4              7           1.69           7.69           9.70
                       klist_remove_lock:             0              0           0.00           0.00           0.00              2             34           0.64          10.40          24.17
                      sysfs_rename_mutex:             0              0           0.00           0.00           0.00              4              7          76.34          90.06         198.44
            &sb->s_type->i_mutex_key#8/2:             0              0           0.00           0.00           0.00              0              2           0.33           0.43           0.76
                            serial_mutex:             0              0           0.00           0.00           0.00              1              2        5604.18        5649.07       11253.25
                          bus_type_sem-W:             0              0           0.00           0.00           0.00              0              3          14.72          14.73          15.76
                          bus_type_sem-R:             0              0           0.00           0.00           0.00             23           1041           4.35          17.70        1230.92
                 &type->s_umount_key#4/1:             0              0           0.00           0.00           0.00              0              1          32.45          32.45          32.45
                  &s->s_vfs_rename_mutex:             0              0           0.00           0.00           0.00              1              2          18.08          47.22          65.30
                            &port->mutex:             0              0           0.00           0.00           0.00            249            539           1.98       17447.91       75949.97
                         sk_lock-AF_INET:             0              0           0.00           0.00           0.00              0       27941977           1.06      249470.11   248072723.03
                         clock-AF_INET-W:             0              0           0.00           0.00           0.00             28            360           1.40           6.67         158.29
                         clock-AF_INET-R:             0              0           0.00           0.00           0.00            237        8069534           1.17          81.90     2955166.06
            &sb->s_type->i_mutex_key#1/1:             0              0           0.00           0.00           0.00             72            398          16.98       52550.05      104317.32
                            swapon_mutex:             0              0           0.00           0.00           0.00              2              5           1.10          30.69          33.85
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00            633           1283           1.29           9.17         594.81
          &sb->s_type->i_alloc_sem_key#5:             0              0           0.00           0.00           0.00             11             22          95.88      104095.92      120167.24
          &sb->s_type->i_alloc_sem_key#4:             0              0           0.00           0.00           0.00              8           1122          40.75         106.75       14274.64
                              jbd_handle:             0              0           0.00           0.00           0.00              0           2170          10.33      251488.11      911042.37
                 &journal->j_revoke_lock:             0              0           0.00           0.00           0.00             64            151           1.46          10.34         124.62
                                   key#4:             0              0           0.00           0.00           0.00            308           2126           1.25          13.57         977.73
                     &ei->truncate_mutex:             0              0           0.00           0.00           0.00            150            734           2.29       48989.40      101933.80
                     &bgl->locks[i].lock:             0              0           0.00           0.00           0.00            163            787           1.23          18.87         322.22
                   &sbi->s_next_gen_lock:             0              0           0.00           0.00           0.00            107            202           1.26          16.48         142.99
                        &ei->xattr_sem-W:             0              0           0.00           0.00           0.00              1              7        8152.80       15056.90       15062.56
                        &ei->xattr_sem-R:             0              0           0.00           0.00           0.00             73            246           4.65      149247.49      555226.42
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00              2             20           0.71           5.83          12.64
                 &sbi->s_rsv_window_lock:             0              0           0.00           0.00           0.00             89            759           1.36          45.77         664.44
                              port_mutex:             0              0           0.00           0.00           0.00              1              8         233.71        5479.55       22628.19
                &journal->j_commit_timer:             0              0           0.00           0.00           0.00              0            978           0.84          26.26         335.04
                                   key#4:             0              0           0.00           0.00           0.00             27             86           2.16          11.24          58.56
                                   key#4:             0              0           0.00           0.00           0.00             17             23           1.57           7.55          19.86
                              &k->k_lock:             0              0           0.00           0.00           0.00            108          14684           1.28          30.78        5557.57
                              &bb->mutex:             0              0           0.00           0.00           0.00              0            152          43.61          73.77        7262.94
                          _xmit_LOOPBACK:             0              0           0.00           0.00           0.00              1              3           0.43           8.51           9.39
                (inetaddr_chain).rwsem-R:             0              0           0.00           0.00           0.00              2              2         237.24         237.24         237.24
        (inetaddr_chain).rwsem.wait_lock:             0              0           0.00           0.00           0.00              2              4           0.64           7.66           8.30
                         fib_hash_lock-W:             0              0           0.00           0.00           0.00              3             15           0.65           8.95          14.89
                         fib_hash_lock-R:             0              0           0.00           0.00           0.00             11           1304           3.44           8.77         796.26
                           fib_info_lock:             0              0           0.00           0.00           0.00              3             15           0.72           9.87          17.97
                 &in_dev->mc_list_lock-W:             0              0           0.00           0.00           0.00              3              3           1.17           6.72           7.29
                 &in_dev->mc_list_lock-R:             0              0           0.00           0.00           0.00              1             13           0.86          69.21          89.59
                   &in_dev->mc_tomb_lock:             0              0           0.00           0.00           0.00              3              6           1.11           6.55           9.07
                              &ifa->lock:             0              0           0.00           0.00           0.00              0             10           0.67          10.32          19.63
                         &tb->tb6_lock-W:             0              0           0.00           0.00           0.00              4             15          52.86          83.52         182.85
                         &tb->tb6_lock-R:             0              0           0.00           0.00           0.00              1              2           6.34           6.34           6.34
                        fib6_walker_lock:             0              0           0.00           0.00           0.00              4             28           0.94          10.09          18.84
              &group->notification_mutex:             0              0           0.00           0.00           0.00             34           2500           1.72          17.01        1640.98
                       ipv6_sk_mc_lock-W:             0              0           0.00           0.00           0.00             46             52           1.57           8.24          36.46
                       ipv6_sk_mc_lock-R:             0              0           0.00           0.00           0.00              1              1           0.82           0.82           0.82
                         ipv6_sk_ac_lock:             0              0           0.00           0.00           0.00             46             51           1.47           6.64          31.85
                          slock-AF_INET6:             0              0           0.00           0.00           0.00             15           1786           1.19          69.55         942.68
                        sk_lock-AF_INET6:             0              0           0.00           0.00           0.00              0            748           1.50         461.79        7422.08
                        clock-AF_INET6-W:             0              0           0.00           0.00           0.00              0             52           1.32           5.03          22.90
                        clock-AF_INET6-R:             0              0           0.00           0.00           0.00             39            240           5.35          32.37        1375.48
                &adapter->watchdog_timer:             0              0           0.00           0.00           0.00              0            555           1.67          18.01        1321.83
                 &adapter->watchdog_task:             0              0           0.00           0.00           0.00              0            555          68.81        1063.46       42351.12
                     &idev->mc_ifc_timer:             0              0           0.00           0.00           0.00              0              4          89.60         207.39         296.99
                          icmp6_dst_lock:             0              0           0.00           0.00           0.00              4              9           1.14          12.55          22.74
                              &n->lock-W:             0              0           0.00           0.00           0.00            124            458           2.23          88.32         541.52
                              &n->lock-R:             0              0           0.00           0.00           0.00             57            126           2.15          47.99         279.11
                           &list->lock#2:             0              0           0.00           0.00           0.00            119            941           1.45          15.23         524.96
                           _xmit_ETHER#2:             0              0           0.00           0.00           0.00            212            581          12.53          58.89        2224.82
                         slock-AF_PACKET:             0              0           0.00           0.00           0.00              0              4           0.36           6.76           8.10
                       sk_lock-AF_PACKET:             0              0           0.00           0.00           0.00              0              2           4.55       13739.87       13744.42
                          &po->bind_lock:             0              0           0.00           0.00           0.00              0              2           1.88           3.59           5.47
                                   key#4:             0              0           0.00           0.00           0.00             33           3171           1.04          16.42        1059.21
                             &ifa->timer:             0              0           0.00           0.00           0.00              0              5           9.57          56.26         155.88
                    &table->hash[i].lock:             0              0           0.00           0.00           0.00            154            333           1.49          29.98         571.11
                      &sk->sk_dst_lock-W:             0              0           0.00           0.00           0.00              0            239           1.34           5.25          99.88
                      &sk->sk_dst_lock-R:             0              0           0.00           0.00           0.00              0            104           1.45           6.77          46.91
                    struct class mutex#1:             0              0           0.00           0.00           0.00              0              1           9.69           9.69           9.69
               &adapter->update_phy_task:             0              0           0.00           0.00           0.00              0              1         968.64         968.64         968.64
                    &dev->watchdog_timer:             0              0           0.00           0.00           0.00              0            221           2.90          35.60         843.44
                    &dev->tx_global_lock:             0              0           0.00           0.00           0.00              1            221           2.25          10.81         662.23
                 &futex_queues[i].lock/1:             0              0           0.00           0.00           0.00            164            191           9.14          43.21        1306.77
             &tcp_hashinfo.bhash[i].lock:             0              0           0.00           0.00           0.00            132            288           1.47          97.18         409.21
                   &queue->syn_wait_lock:             0              0           0.00           0.00           0.00             32            110           1.41           5.01          47.97
              &h->listening_hash[i].lock:             0              0           0.00           0.00           0.00              6              6           2.04           5.15           7.19
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              2             11          44.51         526.97         550.43
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              0             22           7.14         935.85        6673.73
                                   key#4:             0              0           0.00           0.00           0.00             12             43           1.61          13.46          39.10
                                   mutex:             0              0           0.00           0.00           0.00              0              2       47940.03       47940.03       47940.03
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              0              2           0.89          15.86          16.74
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              0              2           0.89           4.40           5.28
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              0              2           0.89           4.02           4.91
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           0.89           4.01           4.90
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           0.89           4.26           5.14
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           0.89           4.01           4.89
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00              1              2           0.89           3.98           4.87
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00              1              2           0.89           4.14           5.03
                       &group->mark_lock:             0              0           0.00           0.00           0.00              2             83           1.13           7.58          87.55
                       &rt_hash_locks[i]:             0              0           0.00           0.00           0.00             51             88           2.66          65.60         189.32
                             usbfs_mutex:             0              0           0.00           0.00           0.00              2             48           0.98          27.37         124.99
                               &ps->lock:             0              0           0.00           0.00           0.00              0             48           0.63           4.09          18.96
                               &n->timer:             0              0           0.00           0.00           0.00              0             48          49.33         109.85         565.38
                           &list->lock#3:             0              0           0.00           0.00           0.00              2              8           1.66          13.07          16.03
                                   key#4:             0              0           0.00           0.00           0.00             13            929           1.52          17.25         457.21
                              &u->lock/1:             0              0           0.00           0.00           0.00             47             98           1.08           4.72          44.43
                           log_wait.lock:             0              0           0.00           0.00           0.00              3              9           0.73          14.63          23.30
                      dnotify_mark_mutex:             0              0           0.00           0.00           0.00              0              1          55.65          55.65          55.65
                        &f->f_owner.lock:             0              0           0.00           0.00           0.00              0              1           4.33           4.33           4.33
                 &type->s_umount_key#3/1:             0              0           0.00           0.00           0.00              0              3          53.83          62.46          79.94
                            &entry->lock:             0              0           0.00           0.00           0.00              0             78           6.58          48.03         177.95
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00              0              2           0.36           3.05           3.41
                   &type->s_umount_key#3:             0              0           0.00           0.00           0.00              0              1          59.06          59.06          59.06
                              iprune_sem:             0              0           0.00           0.00           0.00              1              2           2.19          25.73          27.92
                    iprune_sem.wait_lock:             0              0           0.00           0.00           0.00              1              4           0.32           4.90           5.86
                    mousedev_table_mutex:             0              0           0.00           0.00           0.00              1              1          11.23          11.23          11.23
                  &mousedev->client_lock:             0              0           0.00           0.00           0.00              1              1           6.09           6.09           6.09
                      &mousedev->mutex#2:             0              0           0.00           0.00           0.00              1              1          38.88          38.88          38.88
                            console_work:             0              0           0.00           0.00           0.00              0              2          15.71        7800.15        7815.85
                                   key#4:             0              0           0.00           0.00           0.00              1              4           0.32           3.50           4.70
                   &in_dev->mr_ifc_timer:             0              0           0.00           0.00           0.00              0              3           5.72         102.02         136.83
                               &im->lock:             0              0           0.00           0.00           0.00              1              6           0.43          48.22          57.10
                   &rcu_bh_state.fqslock:             0              0           0.00           0.00           0.00              0             11           3.23          12.77          54.38
                 &(&tbl->gc_work)->timer:             0              0           0.00           0.00           0.00              0            146           3.04          20.69         444.45
                  &(&tbl->gc_work)->work:             0              0           0.00           0.00           0.00              0            146          13.45         114.47        1325.70
                                &ep->mtx:             0              0           0.00           0.00           0.00              0              4           3.24          40.28          50.53
                      struct class mutex:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                       evdev_table_mutex:             0              0           0.00           0.00           0.00              1              2           1.09          12.14          13.23
                     &evdev->client_lock:             0              0           0.00           0.00           0.00              2              2           0.56           5.47           6.03
                           &evdev->mutex:             0              0           0.00           0.00           0.00              2              2           3.05           9.89          12.94
                                   key#4:             0              0           0.00           0.00           0.00              2              2           0.59           8.68           9.27
                  acpi_system_event_lock:             0              0           0.00           0.00           0.00              1              1          10.17          10.17          10.17
               acpi_bus_event_queue.lock:             0              0           0.00           0.00           0.00              1              1           5.07           5.07           5.07
                                   key#5:             0              0           0.00           0.00           0.00             29             68           1.32          40.05         160.13
                  &tty->atomic_read_lock:             0              0           0.00           0.00           0.00              6            258          28.03    45298179.38    51300264.94
                                   key#5:             0              0           0.00           0.00           0.00              2              2           9.91           9.91           9.91
                                   key#5:             0              0           0.00           0.00           0.00              2              2           5.58           5.58           5.58
               &hashinfo->ehash_locks[i]:             0              0           0.00           0.00           0.00            128            223           1.49          12.24         134.74
                 &type->s_umount_key#3/1:             0              0           0.00           0.00           0.00              0              1          27.55          27.55          27.55
                        slock-AF_INET6/1:             0              0           0.00           0.00           0.00             48            479          37.31         182.52        3890.28
                &icsk->icsk_delack_timer:             0              0           0.00           0.00           0.00              0          84557           3.38          76.57      225046.67
                tcp_death_row.death_lock:             0              0           0.00           0.00           0.00             33            212           1.83          43.04         304.80
                        peer_pool_lock-W:             0              0           0.00           0.00           0.00              0              1           1.17           1.17           1.17
                        peer_pool_lock-R:             0              0           0.00           0.00           0.00              0              2           0.84          16.69          17.53
                            rt_peer_lock:             0              0           0.00           0.00           0.00              0              2           0.41          12.62          13.02
                        inet_peer_idlock:             0              0           0.00           0.00           0.00              1             19           1.07          13.44          20.74
                &net->ipv6.ip6_fib_timer:             0              0           0.00           0.00           0.00              0              1          60.88          60.88          60.88
                            fib6_gc_lock:             0              0           0.00           0.00           0.00              0              1          35.41          35.41          35.41
             net/ipv4/tcp_minisocks.c:46:             0              0           0.00           0.00           0.00              0            143           4.01          20.17         399.25
                 &(&expires_work)->timer:             0              0           0.00           0.00           0.00              0             18           1.76          10.78          45.56
                  &(&expires_work)->work:             0              0           0.00           0.00           0.00              0             18         513.89        1833.64       17027.39
                           printing_lock:             0              0           0.00           0.00           0.00              0            301           0.00           0.00           0.00
                 net/ipv6/addrconf.c:134:             0              0           0.00           0.00           0.00              0              9          13.69          23.49         135.42
                  net/ipv4/inetpeer.c:99:             0              0           0.00           0.00           0.00              0              8           2.74          36.85          57.86
                   inet_peer_unused_lock:             0              0           0.00           0.00           0.00              3             10           1.28           9.52          14.46
                                       t:             0              0           0.00           0.00           0.00              0             12          22.23          40.86          87.76
              drivers/char/random.c:1483:             0              0           0.00           0.00           0.00              0              3           1.75          10.40          14.05
                       (rekey_work).work:             0              0           0.00           0.00           0.00              0              3          20.85          29.66          74.33
                        &f->secret_timer:             0              0           0.00           0.00           0.00              0              2          64.69          64.69          64.69
                                &f->lock:             0              0           0.00           0.00           0.00              0              2          33.04          33.04          33.04
                   drivers/char/vt.c:218:             0              0           0.00           0.00           0.00              0              2           0.25          12.00          12.25
                           vt_event_lock:             0              0           0.00           0.00           0.00              1              1           5.81           5.81           5.81
                     allocated_ptys_lock:             0              0           0.00           0.00           0.00              1              1          15.11          15.11          15.11
                     &newsk->sk_dst_lock:             0              0           0.00           0.00           0.00              0              1           7.23           7.23           7.23
            &icsk->icsk_retransmit_timer:             0              0           0.00           0.00           0.00              0            117           5.78          14.72         171.79
              &net->ipv4.rt_secret_timer:             0              0           0.00           0.00           0.00              0              1          18.27          18.27          18.27
                     cpu_add_remove_lock:             0              0           0.00           0.00           0.00              2             51           2.47      108412.81      322460.65
                         resource_lock-W:             0              0           0.00           0.00           0.00              2            583           0.66          11.54         147.33
                         resource_lock-R:             0              0           0.00           0.00           0.00              0             30           3.72          20.52          69.84
                        clockevents_lock:             0              0           0.00           0.00           0.00              8             26          14.62      312216.26      312223.77

--=-ZGSWARzYdHVMBeW6RhT6
Content-Disposition: attachment; filename="lockstat.tbench.2.6.33-rc1"
Content-Type: text/plain; name="lockstat.tbench.2.6.33-rc1"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

lock_stat version 0.3
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                               &rq->lock:          5987           6019           0.00          25.15       20551.87          37851       25873389           0.00        3819.73    29524592.69
                               ---------
                               &rq->lock           5254          [<ffffffff8102a6d9>] task_rq_lock+0x39/0x67
                               &rq->lock            410          [<ffffffff81439c75>] schedule+0xba/0x8ae
                               &rq->lock            336          [<ffffffff8103086f>] try_to_wake_up+0xe3/0x26f
                               &rq->lock             28          [<ffffffff8102c995>] double_lock_balance+0x40/0x6a
                               ---------
                               &rq->lock            468          [<ffffffff8102a6d9>] task_rq_lock+0x39/0x67
                               &rq->lock           5022          [<ffffffff81439c75>] schedule+0xba/0x8ae
                               &rq->lock             13          [<ffffffff81030555>] double_rq_lock+0x40/0x79
                               &rq->lock            477          [<ffffffff8103086f>] try_to_wake_up+0xe3/0x26f

...............................................................................................................................................................................................

                             sysfs_mutex:          2103           2103          12.75       15800.03     1851284.97           4812         216283           0.00         153.21      260344.01
                             -----------
                             sysfs_mutex            426          [<ffffffff8111515f>] sysfs_dentry_revalidate+0x25/0xfc
                             sysfs_mutex           1515          [<ffffffff81113e75>] sysfs_permission+0x28/0x54
                             sysfs_mutex             69          [<ffffffff81115ba7>] sysfs_lookup+0x2e/0xd4
                             sysfs_mutex             21          [<ffffffff81115d1c>] sysfs_follow_link+0x52/0x17d
                             -----------
                             sysfs_mutex            192          [<ffffffff81115ba7>] sysfs_lookup+0x2e/0xd4
                             sysfs_mutex           1240          [<ffffffff81113e75>] sysfs_permission+0x28/0x54
                             sysfs_mutex             74          [<ffffffff811140ce>] sysfs_getattr+0x29/0x55
                             sysfs_mutex            548          [<ffffffff8111515f>] sysfs_dentry_revalidate+0x25/0xfc

...............................................................................................................................................................................................

                             dcache_lock:          1758           1835           0.44          35.86        2738.66          17611         191058           0.00         349.00      168236.95
                             -----------
                             dcache_lock            669          [<ffffffff811bc8c1>] _atomic_dec_and_lock+0x49/0x6c
                             dcache_lock             55          [<ffffffff810daa97>] d_path+0x95/0xe0
                             dcache_lock             67          [<ffffffff810d8f77>] shrink_dcache_parent+0x46/0x133
                             dcache_lock            297          [<ffffffff810d9392>] d_instantiate+0x2d/0x49
                             -----------
                             dcache_lock            676          [<ffffffff811bc8c1>] _atomic_dec_and_lock+0x49/0x6c
                             dcache_lock              1          [<ffffffff810f1e81>] __fsnotify_update_child_dentry_flags+0x51/0x104
                             dcache_lock            191          [<ffffffff810d87d0>] d_rehash+0x1b/0x44
                             dcache_lock             19          [<ffffffff810dad7e>] d_delete+0x23/0xd2

...............................................................................................................................................................................................

               &(&zone->lru_lock)->rlock:           542            543           0.44           8.81         739.41          11850          85761           0.00          11.85       72475.57
               -------------------------
               &(&zone->lru_lock)->rlock            158          [<ffffffff8109cdfd>] ____pagevec_lru_add+0x6b/0x11e
               &(&zone->lru_lock)->rlock            376          [<ffffffff8109cc8e>] release_pages+0xc5/0x1c9
               &(&zone->lru_lock)->rlock              6          [<ffffffff8109cade>] activate_page+0x40/0x12b
               &(&zone->lru_lock)->rlock              3          [<ffffffff8109d12e>] put_page+0x66/0xee
               -------------------------
               &(&zone->lru_lock)->rlock            206          [<ffffffff8109cdfd>] ____pagevec_lru_add+0x6b/0x11e
               &(&zone->lru_lock)->rlock            329          [<ffffffff8109cc8e>] release_pages+0xc5/0x1c9
               &(&zone->lru_lock)->rlock              5          [<ffffffff8109cade>] activate_page+0x40/0x12b
               &(&zone->lru_lock)->rlock              3          [<ffffffff8109d12e>] put_page+0x66/0xee

...............................................................................................................................................................................................

                            chrdevs_lock:           444            444          15.83         201.99        9792.77            486          22054           0.00          46.38       12304.07
                            ------------
                            chrdevs_lock            444          [<ffffffff810cc627>] chrdev_show+0x24/0x5f
                            ------------
                            chrdevs_lock            444          [<ffffffff810cc627>] chrdev_show+0x24/0x5f

...............................................................................................................................................................................................

    &(&inode->i_data.i_mmap_lock)->rlock:           411            418           0.55           8.31         518.36          42332         187977           0.00          46.14      120911.49
    ------------------------------------
    &(&inode->i_data.i_mmap_lock)->rlock            241          [<ffffffff810af9e6>] unlink_file_vma+0x30/0x4f
    &(&inode->i_data.i_mmap_lock)->rlock             21          [<ffffffff810b055d>] vma_link+0x49/0xb4
    &(&inode->i_data.i_mmap_lock)->rlock            119          [<ffffffff81036a7d>] dup_mm+0x26f/0x48b
    &(&inode->i_data.i_mmap_lock)->rlock             37          [<ffffffff810afbdd>] vma_adjust+0x155/0x41e
    ------------------------------------
    &(&inode->i_data.i_mmap_lock)->rlock             52          [<ffffffff810afbdd>] vma_adjust+0x155/0x41e
    &(&inode->i_data.i_mmap_lock)->rlock            140          [<ffffffff81036a7d>] dup_mm+0x26f/0x48b
    &(&inode->i_data.i_mmap_lock)->rlock            201          [<ffffffff810af9e6>] unlink_file_vma+0x30/0x4f
    &(&inode->i_data.i_mmap_lock)->rlock             25          [<ffffffff810b055d>] vma_link+0x49/0xb4

...............................................................................................................................................................................................

                        block_class_lock:           409            409          16.32         839.00        9411.63            446          17471           0.43          38.36       10071.40
                        ----------------
                        block_class_lock            409          [<ffffffff811b4f8e>] blkdev_show+0x24/0x5f
                        ----------------
                        block_class_lock            409          [<ffffffff811b4f8e>] blkdev_show+0x24/0x5f

...............................................................................................................................................................................................

                           vfsmount_lock:           201            203           0.42          20.40         175.95           8766          58649           0.00          40.18       26426.45
                           -------------
                           vfsmount_lock            194          [<ffffffff810e0948>] lookup_mnt+0x18/0x4b
                           vfsmount_lock              9          [<ffffffff810d90e3>] __d_path+0x3c/0x159
                           -------------
                           vfsmount_lock            186          [<ffffffff810e0948>] lookup_mnt+0x18/0x4b
                           vfsmount_lock             17          [<ffffffff810d90e3>] __d_path+0x3c/0x159

...............................................................................................................................................................................................

                         tasklist_lock-W:           130            129           0.61          23.92         614.36           7095          21045           0.00          28.09       67743.11
                         tasklist_lock-R:            60             60           0.68          17.56         245.44           3433           7110           0.35         436.17       21461.18
                         ---------------
                           tasklist_lock             41          [<ffffffff810426da>] exit_ptrace+0x2a/0x10d
                           tasklist_lock             15          [<ffffffff81037a23>] copy_process+0xd49/0x11b3
                           tasklist_lock             20          [<ffffffff8103c139>] do_exit+0x4cb/0x658
                           tasklist_lock             42          [<ffffffff8103ae90>] release_task+0x34/0x31a
                         ---------------
                           tasklist_lock             46          [<ffffffff8103ae90>] release_task+0x34/0x31a
                           tasklist_lock             11          [<ffffffff810426da>] exit_ptrace+0x2a/0x10d
                           tasklist_lock             81          [<ffffffff8103c139>] do_exit+0x4cb/0x658
                           tasklist_lock              9          [<ffffffff8103becc>] do_exit+0x25e/0x658

...............................................................................................................................................................................................

                                   key#4:           151            151           0.60           7.80         276.00            920           3753           0.32          11.74        3774.22
                                   -----
                                   key#4             64          [<ffffffff8102a3ff>] __wake_up_sync_key+0x27/0x5b
                                   key#4             87          [<ffffffff8105286d>] finish_wait+0x3b/0x67
                                   -----
                                   key#4             59          [<ffffffff810528b7>] prepare_to_wait_exclusive+0x1e/0x75
                                   key#4             87          [<ffffffff8102a3ff>] __wake_up_sync_key+0x27/0x5b
                                   key#4              5          [<ffffffff8105286d>] finish_wait+0x3b/0x67

...............................................................................................................................................................................................

              &(&q->__queue_lock)->rlock:           149            151           0.57          21.61         601.84           1840          69908           0.00          52.85      150826.45
              --------------------------
              &(&q->__queue_lock)->rlock              4          [<ffffffff811af6a2>] blk_get_request+0x2a/0x71
              &(&q->__queue_lock)->rlock             30          [<ffffffff811afcdc>] blk_run_queue+0x16/0x35
              &(&q->__queue_lock)->rlock              6          [<ffffffff8124b1bd>] scsi_device_unbusy+0x90/0xb0
              &(&q->__queue_lock)->rlock             11          [<ffffffff811b00d4>] __make_request+0x350/0x410
              --------------------------
              &(&q->__queue_lock)->rlock              9          [<ffffffff811afcdc>] blk_run_queue+0x16/0x35
              &(&q->__queue_lock)->rlock             16          [<ffffffff811af6a2>] blk_get_request+0x2a/0x71
              &(&q->__queue_lock)->rlock              4          [<ffffffff811ae90b>] blk_put_request+0x20/0x46
              &(&q->__queue_lock)->rlock              2          [<ffffffff811b2be6>] blk_execute_rq_nowait+0x50/0x91

...............................................................................................................................................................................................

                   &(&base->lock)->rlock:           137            133           0.47           1.62         113.46          10433        8772937           0.00           9.33     4120004.44
                   ---------------------
                   &(&base->lock)->rlock              7          [<ffffffff81045f9f>] get_next_timer_interrupt+0x2e/0x1f3
                   &(&base->lock)->rlock            123          [<ffffffff81045c60>] lock_timer_base+0x26/0x4a
                   &(&base->lock)->rlock              3          [<ffffffff81045ed6>] mod_timer+0x13f/0x191
                   &(&base->lock)->rlock              2          [<ffffffff810458d9>] run_timer_softirq+0x49/0x284
                   ---------------------
                   &(&base->lock)->rlock            114          [<ffffffff81045c60>] lock_timer_base+0x26/0x4a
                   &(&base->lock)->rlock             15          [<ffffffff81045f9f>] get_next_timer_interrupt+0x2e/0x1f3
                   &(&base->lock)->rlock              1          [<ffffffff81045ed6>] mod_timer+0x13f/0x191
                   &(&base->lock)->rlock              1          [<ffffffff81045ace>] run_timer_softirq+0x23e/0x284

...............................................................................................................................................................................................

                              files_lock:           125            124           0.53           2.60         104.84          10775          52109           0.00          48.06       20427.20
                              ----------
                              files_lock             63          [<ffffffff810ca8bc>] file_move+0x1e/0x50
                              files_lock             62          [<ffffffff810ca2f6>] file_kill+0x1d/0x42
                              ----------
                              files_lock             74          [<ffffffff810ca8bc>] file_move+0x1e/0x50
                              files_lock             49          [<ffffffff810ca2f6>] file_kill+0x1d/0x42
                              files_lock              2          [<ffffffff81211618>] check_tty_count+0x22/0xac

...............................................................................................................................................................................................

                              inode_lock:           103            102           0.49         161.99         266.31           6331          43720           0.00         178.34       24041.30
                              ----------
                              inode_lock             26          [<ffffffff810dc0e8>] iget_locked+0x65/0x162
                              inode_lock             20          [<ffffffff810db3cc>] ifind_fast+0x22/0x90
                              inode_lock             20          [<ffffffff810dc6dd>] new_inode+0x31/0xb3
                              inode_lock             17          [<ffffffff811bc8c1>] _atomic_dec_and_lock+0x49/0x6c
                              ----------
                              inode_lock             28          [<ffffffff810dc0e8>] iget_locked+0x65/0x162
                              inode_lock             25          [<ffffffff810dc6dd>] new_inode+0x31/0xb3
                              inode_lock             13          [<ffffffff811bc8c1>] _atomic_dec_and_lock+0x49/0x6c
                              inode_lock             21          [<ffffffff810db3cc>] ifind_fast+0x22/0x90

...............................................................................................................................................................................................

                   &(&zone->lock)->rlock:            89             88           0.71           8.93         309.78           6280          54245           0.00         710.59       53587.76
                   ---------------------
                   &(&zone->lock)->rlock             23          [<ffffffff8109861a>] free_one_page+0x22/0x191
                   &(&zone->lock)->rlock             29          [<ffffffff81099b40>] get_page_from_freelist+0x36c/0x654
                   &(&zone->lock)->rlock             29          [<ffffffff810987b0>] free_pcppages_bulk+0x27/0x24e
                   &(&zone->lock)->rlock              8          [<ffffffff81099a06>] get_page_from_freelist+0x232/0x654
                   ---------------------
                   &(&zone->lock)->rlock             11          [<ffffffff81099b40>] get_page_from_freelist+0x36c/0x654
                   &(&zone->lock)->rlock              7          [<ffffffff8109861a>] free_one_page+0x22/0x191
                   &(&zone->lock)->rlock             26          [<ffffffff81099a06>] get_page_from_freelist+0x232/0x654
                   &(&zone->lock)->rlock             45          [<ffffffff810987b0>] free_pcppages_bulk+0x27/0x24e

...............................................................................................................................................................................................

                      &(&u->lock)->rlock:            86             86           0.73          10.45         101.36           2122           8459           0.00          30.25        9625.40
                      ------------------
                      &(&u->lock)->rlock             56          [<ffffffff813d2ec9>] unix_peer_get+0x19/0x39
                      &(&u->lock)->rlock             20          [<ffffffff813d39b0>] unix_dgram_sendmsg+0x265/0x47c
                      &(&u->lock)->rlock              5          [<ffffffff813d4e96>] unix_stream_sendmsg+0x203/0x2f9
                      &(&u->lock)->rlock              4          [<ffffffff813d45b8>] unix_stream_recvmsg+0x132/0x554
                      ------------------
                      &(&u->lock)->rlock             56          [<ffffffff813d39b0>] unix_dgram_sendmsg+0x265/0x47c
                      &(&u->lock)->rlock             20          [<ffffffff813d2ec9>] unix_peer_get+0x19/0x39
                      &(&u->lock)->rlock              4          [<ffffffff813d45b8>] unix_stream_recvmsg+0x132/0x554
                      &(&u->lock)->rlock              5          [<ffffffff813d4e96>] unix_stream_sendmsg+0x203/0x2f9

...............................................................................................................................................................................................

             &(&sighand->siglock)->rlock:           111             76           0.01           3.35         135.82          13801          82118           0.00          37.17       94569.97
             ---------------------------
             &(&sighand->siglock)->rlock            109          [<ffffffff8104a858>] get_signal_to_deliver+0x5e/0x3b6
             &(&sighand->siglock)->rlock              1          [<ffffffff8104a44f>] do_notify_parent+0x173/0x219
             &(&sighand->siglock)->rlock              1          [<ffffffff81001bc4>] sys_rt_sigreturn+0x87/0x203
             ---------------------------
             &(&sighand->siglock)->rlock            110          [<ffffffff8104a44f>] do_notify_parent+0x173/0x219
             &(&sighand->siglock)->rlock              1          [<ffffffff8104a858>] get_signal_to_deliver+0x5e/0x3b6

...............................................................................................................................................................................................

               &(&dentry->d_lock)->rlock:            70             70           0.56           1.76          74.05          44768         392955           0.00          64.71      164772.83
               -------------------------
               &(&dentry->d_lock)->rlock             67          [<ffffffff810d9a44>] __d_lookup+0x9e/0x14b
               &(&dentry->d_lock)->rlock              1          [<ffffffff810d2089>] dentry_unhash+0x3c/0x89
               &(&dentry->d_lock)->rlock              2          [<ffffffff810d8e18>] dput+0x41/0x15a
               -------------------------
               &(&dentry->d_lock)->rlock              1          [<ffffffff810d8e18>] dput+0x41/0x15a
               &(&dentry->d_lock)->rlock             69          [<ffffffff810d9a44>] __d_lookup+0x9e/0x14b

...............................................................................................................................................................................................

                           slock-AF_INET:            53             53           0.61          20.11         177.74           2228       55874456           0.00          97.33    19854955.02
                           -------------
                           slock-AF_INET             32          [<ffffffff8137b1b3>] lock_sock_nested+0x28/0xee
                           slock-AF_INET             21          [<ffffffff8137b0de>] release_sock+0x2f/0xdc
                           -------------
                           slock-AF_INET             51          [<ffffffff813bc966>] tcp_v4_rcv+0x29c/0x5fe
                           slock-AF_INET              1          [<ffffffff8137b0de>] release_sock+0x2f/0xdc
                           slock-AF_INET              1          [<ffffffff8137b1b3>] lock_sock_nested+0x28/0xee

...............................................................................................................................................................................................

               &(&anon_vma->lock)->rlock:            44             44           0.49          97.52         136.23          59917         165662           0.00         112.38       87016.60
               -------------------------
               &(&anon_vma->lock)->rlock             24          [<ffffffff810b423d>] anon_vma_unlink+0x1b/0x6a
               &(&anon_vma->lock)->rlock             20          [<ffffffff810b41f8>] anon_vma_link+0x1b/0x45
               -------------------------
               &(&anon_vma->lock)->rlock             30          [<ffffffff810b41f8>] anon_vma_link+0x1b/0x45
               &(&anon_vma->lock)->rlock             12          [<ffffffff810b423d>] anon_vma_unlink+0x1b/0x6a
               &(&anon_vma->lock)->rlock              2          [<ffffffff810afc57>] vma_adjust+0x1cf/0x41e

...............................................................................................................................................................................................

                         slock-AF_INET/1:            30             30           0.60          23.23          89.65           2147        8731118           0.00          99.20    38841287.81
                         ---------------
                         slock-AF_INET/1             30          [<ffffffff813bc966>] tcp_v4_rcv+0x29c/0x5fe
                         ---------------
                         slock-AF_INET/1              7          [<ffffffff813bc966>] tcp_v4_rcv+0x29c/0x5fe
                         slock-AF_INET/1              9          [<ffffffff8137b1b3>] lock_sock_nested+0x28/0xee
                         slock-AF_INET/1             14          [<ffffffff8137b0de>] release_sock+0x2f/0xdc

...............................................................................................................................................................................................

                                   key#2:            28             28           0.81           3.23          52.26           4159        8558909           0.00          28.20    21438836.79
                                   -----
                                   key#2             24          [<ffffffff81052998>] remove_wait_queue+0x12/0x45
                                   key#2              4          [<ffffffff8102a3ff>] __wake_up_sync_key+0x27/0x5b
                                   -----
                                   key#2             24          [<ffffffff8102a3ff>] __wake_up_sync_key+0x27/0x5b
                                   key#2              4          [<ffffffff81052998>] remove_wait_queue+0x12/0x45

...............................................................................................................................................................................................

                             &rq->lock/1:            23             26           0.56          14.61          61.28            711           1039           0.24        3605.68        5040.48
                             -----------
                             &rq->lock/1             20          [<ffffffff8102c9b6>] double_lock_balance+0x61/0x6a
                             &rq->lock/1              6          [<ffffffff81030562>] double_rq_lock+0x4d/0x79
                             -----------
                             &rq->lock/1              1          [<ffffffff81034451>] scheduler_tick+0x3d/0x204
                             &rq->lock/1              4          [<ffffffff8103086f>] try_to_wake_up+0xe3/0x26f
                             &rq->lock/1              8          [<ffffffff8102a6d9>] task_rq_lock+0x39/0x67
                             &rq->lock/1             12          [<ffffffff81439c75>] schedule+0xba/0x8ae

...............................................................................................................................................................................................

                          &port_lock_key:            21             21           0.93        3742.31        4057.17            280           2189           0.00         104.87       11213.94
                          --------------
                          &port_lock_key              9          [<ffffffff81233b50>] uart_write_room+0x1b/0x4a
                          &port_lock_key              2          [<ffffffff81233b9a>] uart_chars_in_buffer+0x1b/0x48
                          &port_lock_key              3          [<ffffffff81236284>] serial8250_handle_port+0x19/0x2cd
                          &port_lock_key              4          [<ffffffff81231dc3>] uart_start+0x26/0x44
                          --------------
                          &port_lock_key             17          [<ffffffff81236284>] serial8250_handle_port+0x19/0x2cd
                          &port_lock_key              2          [<ffffffff81233b9a>] uart_chars_in_buffer+0x1b/0x48
                          &port_lock_key              1          [<ffffffff81231dc3>] uart_start+0x26/0x44
                          &port_lock_key              1          [<ffffffff81233abe>] uart_write+0x66/0xdd

...............................................................................................................................................................................................

      &af_unix_sk_receive_queue_lock_key:            16             16           0.77           1.40          14.41           2103           7808           0.00           6.06        3690.42
      ----------------------------------
      &af_unix_sk_receive_queue_lock_key             15          [<ffffffff8137ed98>] skb_queue_tail+0x1f/0x4a
      &af_unix_sk_receive_queue_lock_key              1          [<ffffffff8138292d>] __skb_recv_datagram+0x58/0x231
      ----------------------------------
      &af_unix_sk_receive_queue_lock_key             15          [<ffffffff8138292d>] __skb_recv_datagram+0x58/0x231
      &af_unix_sk_receive_queue_lock_key              1          [<ffffffff8137ed98>] skb_queue_tail+0x1f/0x4a

...............................................................................................................................................................................................

                              xtime_lock:            16             16           2.29           4.08          46.69           1298          25942           0.00           8.55       55153.34
                              ----------
                              xtime_lock             16          [<ffffffff8105db87>] tick_do_update_jiffies64+0x2f/0xb0
                              ----------
                              xtime_lock             16          [<ffffffff8105db87>] tick_do_update_jiffies64+0x2f/0xb0

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#1:            13             14          25.72       20187.84       94029.92           1092           8407           0.48     1261493.43    14355178.79
              --------------------------
              &sb->s_type->i_mutex_key#1              6          [<ffffffff810d6976>] vfs_readdir+0x44/0xa1
              &sb->s_type->i_mutex_key#1              8          [<ffffffff810d172a>] do_lookup+0xab/0x1e7
              --------------------------
              &sb->s_type->i_mutex_key#1              4          [<ffffffff810d6976>] vfs_readdir+0x44/0xa1
              &sb->s_type->i_mutex_key#1              9          [<ffffffff810d172a>] do_lookup+0xab/0x1e7
              &sb->s_type->i_mutex_key#1              1          [<ffffffff810d39e5>] do_unlinkat+0x64/0x17f

...............................................................................................................................................................................................

                                   key#2:            12             11           0.50           3.31          13.18            358           2482           0.00           7.97        1361.33
                                   -----
                                   key#2              8          [<ffffffff81052998>] remove_wait_queue+0x12/0x45
                                   key#2              4          [<ffffffff810329cb>] __wake_up+0x22/0x50
                                   -----
                                   key#2             11          [<ffffffff810329cb>] __wake_up+0x22/0x50
                                   key#2              1          [<ffffffff81052998>] remove_wait_queue+0x12/0x45

...............................................................................................................................................................................................

        &(&journal->j_state_lock)->rlock:            11             11           0.79          13.40          44.51            774          11651           0.30         107.38       21234.56
        --------------------------------
        &(&journal->j_state_lock)->rlock              1          [<ffffffff8115ddef>] journal_errno+0x22/0x3f
        &(&journal->j_state_lock)->rlock              2          [<ffffffff8115cb7e>] log_wait_commit+0xbe/0xfe
        &(&journal->j_state_lock)->rlock              2          [<ffffffff81159f27>] journal_commit_transaction+0x6e9/0xf2e
        &(&journal->j_state_lock)->rlock              1          [<ffffffff81157dcd>] journal_stop+0x159/0x278
        --------------------------------
        &(&journal->j_state_lock)->rlock              1          [<ffffffff8115d45b>] kjournald+0x9d/0x230
        &(&journal->j_state_lock)->rlock              3          [<ffffffff811598a6>] journal_commit_transaction+0x68/0xf2e
        &(&journal->j_state_lock)->rlock              2          [<ffffffff8115cb7e>] log_wait_commit+0xbe/0xfe
        &(&journal->j_state_lock)->rlock              1          [<ffffffff8115995c>] journal_commit_transaction+0x11e/0xf2e

...............................................................................................................................................................................................

                                   key#2:            10             10           0.79           1.08           9.19           6543          12734           0.00          20.57        4808.59
                                   -----
                                   key#2             10          [<ffffffff811cc0be>] __percpu_counter_add+0x47/0x69
                                   -----
                                   key#2             10          [<ffffffff811cc0be>] __percpu_counter_add+0x47/0x69

...............................................................................................................................................................................................

               &(&sem->wait_lock)->rlock:             9              9           0.90           7.42          19.72           4439        1405147           0.00          16.83      470228.36
               -------------------------
               &(&sem->wait_lock)->rlock              4          [<ffffffff811c11ed>] __up_read+0x1c/0x97
               &(&sem->wait_lock)->rlock              1          [<ffffffff8143c11e>] __down_read+0x1c/0xcb
               &(&sem->wait_lock)->rlock              4          [<ffffffff811c115b>] __down_read_trylock+0x16/0x46
               -------------------------
               &(&sem->wait_lock)->rlock              7          [<ffffffff811c115b>] __down_read_trylock+0x16/0x46
               &(&sem->wait_lock)->rlock              1          [<ffffffff811c1291>] __up_write+0x29/0x11c
               &(&sem->wait_lock)->rlock              1          [<ffffffff811c11ed>] __up_read+0x1c/0x97

...............................................................................................................................................................................................

                      &rcu_node_class[i]:             7              8           0.89           3.45          13.57           7609          22524           0.00           6.05       10648.99
                      ------------------
                      &rcu_node_class[i]              2          [<ffffffff8107aa71>] __call_rcu+0x73/0x10b
                      &rcu_node_class[i]              4          [<ffffffff8107ac77>] __rcu_process_callbacks+0x9a/0x27f
                      &rcu_node_class[i]              2          [<ffffffff8107a8aa>] force_quiescent_state+0xf4/0x17a
                      &rcu_node_class[i]              1          [<ffffffff8107a82e>] force_quiescent_state+0x78/0x17a
                      ------------------
                      &rcu_node_class[i]              2          [<ffffffff8107a3c0>] rcu_start_gp+0x57/0x15c
                      &rcu_node_class[i]              1          [<ffffffff8107aa71>] __call_rcu+0x73/0x10b
                      &rcu_node_class[i]              1          [<ffffffff8107a82e>] force_quiescent_state+0x78/0x17a
                      &rcu_node_class[i]              2          [<ffffffff8107a604>] rcu_process_dyntick+0x31/0xf2

...............................................................................................................................................................................................

            &(&parent->list_lock)->rlock:            14              7           0.76           1.76           7.99           8589          51066           0.00          24.72       33408.27
            ----------------------------
            &(&parent->list_lock)->rlock              7          [<ffffffff810c389d>] do_drain+0x39/0x6f
            &(&parent->list_lock)->rlock              3          [<ffffffff810c37e3>] cache_flusharray+0x3f/0xc0
            &(&parent->list_lock)->rlock              3          [<ffffffff810c29f1>] cache_alloc_refill+0x7c/0x1f6
            &(&parent->list_lock)->rlock              1          [<ffffffff810c2575>] cache_grow+0x1bf/0x241
            ----------------------------
            &(&parent->list_lock)->rlock              6          [<ffffffff810c389d>] do_drain+0x39/0x6f
            &(&parent->list_lock)->rlock              4          [<ffffffff810c37e3>] cache_flusharray+0x3f/0xc0
            &(&parent->list_lock)->rlock              4          [<ffffffff810c29f1>] cache_alloc_refill+0x7c/0x1f6

...............................................................................................................................................................................................

          &(&mm->page_table_lock)->rlock:             7              7           1.11           4.15          11.50           4118        1022931           0.00         332.99     1106753.75
          ------------------------------
          &(&mm->page_table_lock)->rlock              2          [<ffffffff810ac1c7>] handle_mm_fault+0x60a/0x69f
          &(&mm->page_table_lock)->rlock              3          [<ffffffff810aa0f4>] __do_fault+0x23c/0x3be
          &(&mm->page_table_lock)->rlock              2          [<ffffffff810aacc4>] follow_page+0x17a/0x2a9
          ------------------------------
          &(&mm->page_table_lock)->rlock              1          [<ffffffff810aa98c>] do_wp_page+0x499/0x657
          &(&mm->page_table_lock)->rlock              1          [<ffffffff810abe9f>] handle_mm_fault+0x2e2/0x69f
          &(&mm->page_table_lock)->rlock              2          [<ffffffff810aa0f4>] __do_fault+0x23c/0x3be
          &(&mm->page_table_lock)->rlock              3          [<ffffffff810ac1c7>] handle_mm_fault+0x60a/0x69f

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#5:             7              7          23.81         683.58        1134.34            447           3361           1.06         713.74       47654.06
              --------------------------
              &sb->s_type->i_mutex_key#5              7          [<ffffffff810d172a>] do_lookup+0xab/0x1e7
              --------------------------
              &sb->s_type->i_mutex_key#5              7          [<ffffffff810d172a>] do_lookup+0xab/0x1e7

...............................................................................................................................................................................................

                                   key#3:             6              6           1.10           5.36          23.34            174           3206           0.29          22.64        3814.96
                                   -----
                                   key#3              1          [<ffffffff810329cb>] __wake_up+0x22/0x50
                                   key#3              1          [<ffffffff8105286d>] finish_wait+0x3b/0x67
                                   key#3              4          [<ffffffff8105292c>] prepare_to_wait+0x1e/0x78
                                   -----
                                   key#3              1          [<ffffffff8105292c>] prepare_to_wait+0x1e/0x78
                                   key#3              5          [<ffffffff810329cb>] __wake_up+0x22/0x50

...............................................................................................................................................................................................

                                pgd_lock:             6              6           1.07           1.90           7.76           6074           8396           0.00          10.80        9154.96
                                --------
                                pgd_lock              3          [<ffffffff81021ddd>] pgd_alloc+0x35/0xbb
                                pgd_lock              3          [<ffffffff81021d35>] pgd_free+0x16/0x77
                                --------
                                pgd_lock              4          [<ffffffff81021ddd>] pgd_alloc+0x35/0xbb
                                pgd_lock              2          [<ffffffff81021d35>] pgd_free+0x16/0x77

...............................................................................................................................................................................................

               &(&tty->ctrl_lock)->rlock:             6              6           0.81           1.17           5.95            208            644           0.33           6.42         388.70
               -------------------------
               &(&tty->ctrl_lock)->rlock              4          [<ffffffff81214817>] tty_ioctl+0x57c/0x81d
               &(&tty->ctrl_lock)->rlock              2          [<ffffffff81212fdb>] tty_check_change+0x3b/0xe4
               -------------------------
               &(&tty->ctrl_lock)->rlock              3          [<ffffffff81212fdb>] tty_check_change+0x3b/0xe4
               &(&tty->ctrl_lock)->rlock              3          [<ffffffff81214817>] tty_ioctl+0x57c/0x81d

...............................................................................................................................................................................................

                         &cpu_base->lock:             5              5           0.85           1.22           5.39           4359         218225           0.00           6.39      125020.05
                         ---------------
                         &cpu_base->lock              3          [<ffffffff81055455>] lock_hrtimer_base+0x25/0x4b
                         &cpu_base->lock              1          [<ffffffff81055165>] hrtimer_interrupt+0x70/0x197
                         &cpu_base->lock              1          [<ffffffff81054f8d>] __run_hrtimer+0xd7/0x105
                         ---------------
                         &cpu_base->lock              3          [<ffffffff81054f8d>] __run_hrtimer+0xd7/0x105
                         &cpu_base->lock              2          [<ffffffff81055455>] lock_hrtimer_base+0x25/0x4b

...............................................................................................................................................................................................

                         &mm->mmap_sem-W:             1              2          24.74          29.15          53.89            303          59401           0.00       96414.90     1232675.04
                         &mm->mmap_sem-R:             3              3           3.72          32.68          67.16           2642         638170           0.00      223843.49     5217419.91
                         ---------------
                           &mm->mmap_sem              1          [<ffffffff8110bea5>] get_mm_exe_file+0x16/0x37
                           &mm->mmap_sem              1          [<ffffffff810a6c0b>] sys_mmap_pgoff+0x194/0x1e0
                           &mm->mmap_sem              1          [<ffffffff810b1f51>] sys_mprotect+0xb8/0x1f3
                           &mm->mmap_sem              2          [<ffffffff8143f358>] do_page_fault+0x18d/0x2c8
                         ---------------
                           &mm->mmap_sem              3          [<ffffffff810b1f51>] sys_mprotect+0xb8/0x1f3
                           &mm->mmap_sem              1          [<ffffffff810ac6a2>] access_process_vm+0x4d/0x1c3
                           &mm->mmap_sem              1          [<ffffffff810b156d>] sys_munmap+0x32/0x59

...............................................................................................................................................................................................

                         unix_table_lock:             5              5           0.74           0.93           4.26            760           5879           0.00           4.50        2768.61
                         ---------------
                         unix_table_lock              2          [<ffffffff813d3f93>] unix_create1+0x133/0x183
                         unix_table_lock              1          [<ffffffff813d3c56>] unix_release_sock+0x31/0x218
                         unix_table_lock              2          [<ffffffff813d36b2>] unix_find_other+0x137/0x1d0
                         ---------------
                         unix_table_lock              2          [<ffffffff813d3f93>] unix_create1+0x133/0x183
                         unix_table_lock              3          [<ffffffff813d3c56>] unix_release_sock+0x31/0x218

...............................................................................................................................................................................................

                               tty_mutex:             5              5         342.18        1257.52        3286.01            163            634           0.52         253.65        3385.76
                               ---------
                               tty_mutex              2          [<ffffffff81213339>] tty_release+0x287/0x562
                               tty_mutex              2          [<ffffffff81214124>] tty_open+0x43e/0x521
                               tty_mutex              1          [<ffffffff81213d31>] tty_open+0x4b/0x521
                               ---------
                               tty_mutex              3          [<ffffffff81213339>] tty_release+0x287/0x562
                               tty_mutex              1          [<ffffffff81214124>] tty_open+0x43e/0x521
                               tty_mutex              1          [<ffffffff81213d31>] tty_open+0x4b/0x521

...............................................................................................................................................................................................

                                   key#1:             4              4           1.21           1.77           6.04           2222           9726           0.30          15.48       19182.28
                                   -----
                                   key#1              1          [<ffffffff810329cb>] __wake_up+0x22/0x50
                                   key#1              2          [<ffffffff8105286d>] finish_wait+0x3b/0x67
                                   key#1              1          [<ffffffff810528b7>] prepare_to_wait_exclusive+0x1e/0x75
                                   -----
                                   key#1              2          [<ffffffff810528b7>] prepare_to_wait_exclusive+0x1e/0x75
                                   key#1              2          [<ffffffff810329cb>] __wake_up+0x22/0x50

...............................................................................................................................................................................................

                      (console_sem).lock:             4              4           1.07           5.29          12.22            121            700           0.00          20.99         711.30
                      ------------------
                      (console_sem).lock              3          [<ffffffff81056397>] down+0xf/0x38
                      (console_sem).lock              1          [<ffffffff810562db>] up+0xf/0x39
                      ------------------
                      (console_sem).lock              2          [<ffffffff81056397>] down+0xf/0x38
                      (console_sem).lock              2          [<ffffffff810562db>] up+0xf/0x39

...............................................................................................................................................................................................

                                 sb_lock:             4              4           0.76          39.70          42.64             37            169           0.00         173.99         468.66
                                 -------
                                 sb_lock              1          [<ffffffff810e7e68>] sync_filesystems+0x2a/0x101
                                 sb_lock              2          [<ffffffff810e7efc>] sync_filesystems+0xbe/0x101
                                 sb_lock              1          [<ffffffff810e475f>] writeback_inodes_wb+0x26f/0x363
                                 -------
                                 sb_lock              2          [<ffffffff810e475f>] writeback_inodes_wb+0x26f/0x363
                                 sb_lock              1          [<ffffffff810cadcc>] put_super+0x18/0x30
                                 sb_lock              1          [<ffffffff810e7efc>] sync_filesystems+0xbe/0x101

...............................................................................................................................................................................................

                              rtnl_mutex:             0              4       44350.66      577865.82     1551536.41             37            481           0.00      363841.77     1325996.27
                              ----------
                              rtnl_mutex              4          [<ffffffff81391968>] rtnl_lock+0x12/0x14
                              ----------
                              rtnl_mutex              4          [<ffffffff81391968>] rtnl_lock+0x12/0x14

...............................................................................................................................................................................................

         &(&ent->pde_unload_lock)->rlock:             4              4           0.99           2.41           6.64            290          15746           0.00          38.40        6496.86
         -------------------------------
         &(&ent->pde_unload_lock)->rlock              2          [<ffffffff81109dec>] proc_reg_release+0x27/0x12f
         &(&ent->pde_unload_lock)->rlock              2          [<ffffffff81109785>] pde_users_dec+0x16/0x2b
         -------------------------------
         &(&ent->pde_unload_lock)->rlock              2          [<ffffffff81109785>] pde_users_dec+0x16/0x2b
         &(&ent->pde_unload_lock)->rlock              2          [<ffffffff81109dec>] proc_reg_release+0x27/0x12f

...............................................................................................................................................................................................

                   &(&host->lock)->rlock:             4              4           1.81        3965.04        3980.80            143           1378           0.00        3967.33       18785.50
                   ---------------------
                   &(&host->lock)->rlock              1          [<ffffffff812814bf>] ata_eh_thaw_port+0x21/0x4b
                   &(&host->lock)->rlock              2          [<ffffffff8128247d>] ata_eh_reset+0xc34/0xc9b
                   &(&host->lock)->rlock              1          [<ffffffff81285a59>] ata_port_wait_eh+0x63/0xba
                   ---------------------
                   &(&host->lock)->rlock              2          [<ffffffff812814bf>] ata_eh_thaw_port+0x21/0x4b
                   &(&host->lock)->rlock              1          [<ffffffff8128593c>] ata_scsi_error+0x613/0x6cd
                   &(&host->lock)->rlock              1          [<ffffffff8127a101>] ata_exec_internal_sg+0x9c/0x4ef

...............................................................................................................................................................................................

                             pidmap_lock:             3              3           0.81           1.19           2.90           4542           8716           0.00           7.18        4863.38
                             -----------
                             pidmap_lock              3          [<ffffffff810500a2>] alloc_pid+0x2cc/0x3b0
                             -----------
                             pidmap_lock              2          [<ffffffff810501a2>] free_pid+0x1c/0x95
                             pidmap_lock              1          [<ffffffff810500a2>] alloc_pid+0x2cc/0x3b0

...............................................................................................................................................................................................

              &(shost->host_lock)->rlock:             3              3           0.96           2.60           4.56           1064          25037           0.00          24.53       30810.90
              --------------------------
              &(shost->host_lock)->rlock              1          [<ffffffff812460d4>] scsi_dispatch_cmd+0xfe/0x1bd
              &(shost->host_lock)->rlock              1          [<ffffffff8124a2f7>] scsi_run_queue+0x122/0x371
              &(shost->host_lock)->rlock              1          [<ffffffff8124b156>] scsi_device_unbusy+0x29/0xb0
              --------------------------
              &(shost->host_lock)->rlock              1          [<ffffffff81245709>] __scsi_iterate_devices+0x31/0x80
              &(shost->host_lock)->rlock              1          [<ffffffff8124b156>] scsi_device_unbusy+0x29/0xb0
              &(shost->host_lock)->rlock              1          [<ffffffff812460d4>] scsi_dispatch_cmd+0xfe/0x1bd

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#1:             3              3          25.67          48.54         110.18           1266           6321           0.00          49.92       23184.76
              --------------------------
              &sb->s_type->i_mutex_key#1              1          [<ffffffff810cff69>] pipe_release+0x2a/0x9b
              &sb->s_type->i_mutex_key#1              2          [<ffffffff810d04eb>] pipe_write+0x74/0x442
              --------------------------
              &sb->s_type->i_mutex_key#1              3          [<ffffffff810d09e6>] pipe_read+0x7a/0x398

...............................................................................................................................................................................................

                                   key#5:             2              2           1.02           3.62           4.64              2              3           0.93          10.12          14.21
                                   -----
                                   key#5              1          [<ffffffff810329cb>] __wake_up+0x22/0x50
                                   key#5              1          [<ffffffff8105286d>] finish_wait+0x3b/0x67
                                   -----
                                   key#5              1          [<ffffffff8105292c>] prepare_to_wait+0x1e/0x78
                                   key#5              1          [<ffffffff810329cb>] __wake_up+0x22/0x50

...............................................................................................................................................................................................

                      set_atomicity_lock:             2              2         837.55        1576.40        2413.95              3             19           0.00         836.22        2307.87
                      ------------------
                      set_atomicity_lock              2          [<ffffffff81013993>] prepare_set+0x10/0x76
                      ------------------
                      set_atomicity_lock              2          [<ffffffff81013993>] prepare_set+0x10/0x76

...............................................................................................................................................................................................

            &sb->s_type->i_mutex_key#8/1:             2              2          76.87         609.14         686.01            116           9691           3.76        4018.22       92496.91
            ----------------------------
            &sb->s_type->i_mutex_key#8/1              1          [<ffffffff810d2690>] lock_rename+0x30/0xc1
            &sb->s_type->i_mutex_key#8/1              1          [<ffffffff810d3b8c>] do_rmdir+0x79/0x10e
            ----------------------------
            &sb->s_type->i_mutex_key#8/1              1          [<ffffffff810d3b8c>] do_rmdir+0x79/0x10e
            &sb->s_type->i_mutex_key#8/1              1          [<ffffffff810d2690>] lock_rename+0x30/0xc1

...............................................................................................................................................................................................

                  sysfs_open_dirent_lock:             2              2           0.93           1.92           2.85            177           9237           0.00           4.93        3599.18
                  ----------------------
                  sysfs_open_dirent_lock              1          [<ffffffff811145e9>] sysfs_open_file+0x1a5/0x2d9
                  sysfs_open_dirent_lock              1          [<ffffffff8111433b>] sysfs_release+0x2f/0xae
                  ----------------------
                  sysfs_open_dirent_lock              1          [<ffffffff8111433b>] sysfs_release+0x2f/0xae
                  sysfs_open_dirent_lock              1          [<ffffffff811145e9>] sysfs_open_file+0x1a5/0x2d9

...............................................................................................................................................................................................

            &(&sbinfo->stat_lock)->rlock:             2              2           1.00           1.19           2.19           1514           7484           0.00          22.12        2931.94
            ----------------------------
            &(&sbinfo->stat_lock)->rlock              2          [<ffffffff810a0dbd>] shmem_reserve_inode+0x23/0x51
            ----------------------------
            &(&sbinfo->stat_lock)->rlock              1          [<ffffffff810a0e1e>] shmem_free_blocks+0x33/0x58
            &(&sbinfo->stat_lock)->rlock              1          [<ffffffff810a159a>] shmem_getpage+0x517/0x7a3

...............................................................................................................................................................................................

            &sb->s_type->i_mutex_key#1/1:             2              2          19.75          19.95          39.70            606            690           0.66          41.89        1795.13
            ----------------------------
            &sb->s_type->i_mutex_key#1/1              2          [<ffffffff810cfa2f>] pipe_lock_nested+0x1c/0x1e
            ----------------------------
            &sb->s_type->i_mutex_key#1/1              2          [<ffffffff810cff69>] pipe_release+0x2a/0x9b

...............................................................................................................................................................................................

   &(&inode->i_data.private_lock)->rlock:             2              2           1.02           1.16           2.17            847          12151           0.00          42.44        6037.64
   -------------------------------------
   &(&inode->i_data.private_lock)->rlock              1          [<ffffffff810e90c0>] __find_get_block_slow+0x53/0xf2
   &(&inode->i_data.private_lock)->rlock              1          [<ffffffff810e975d>] __getblk+0x19e/0x22c
   -------------------------------------
   &(&inode->i_data.private_lock)->rlock              2          [<ffffffff810e90c0>] __find_get_block_slow+0x53/0xf2

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#6:             2              2          17.29        1844.52        1861.81           2596          13595           0.46        3615.93      153315.91
              --------------------------
              &sb->s_type->i_mutex_key#6              2          [<ffffffff810d172a>] do_lookup+0xab/0x1e7
              --------------------------
              &sb->s_type->i_mutex_key#6              2          [<ffffffff810d172a>] do_lookup+0xab/0x1e7

...............................................................................................................................................................................................

              &sb->s_type->i_mutex_key#9:             2              2          32.91         226.26         259.16            618          14294           0.00         789.51       94404.78
              --------------------------
              &sb->s_type->i_mutex_key#9              2          [<ffffffff810d172a>] do_lookup+0xab/0x1e7
              --------------------------
              &sb->s_type->i_mutex_key#9              2          [<ffffffff810d3b8c>] do_rmdir+0x79/0x10e

...............................................................................................................................................................................................

      &(&inode->i_data.tree_lock)->rlock:             1              1           1.12           1.12           1.12           1015          44622           0.00         115.58       22174.88
      ----------------------------------
      &(&inode->i_data.tree_lock)->rlock              1          [<ffffffff8109be0c>] test_set_page_writeback+0x53/0x112
      ----------------------------------
      &(&inode->i_data.tree_lock)->rlock              1          [<ffffffff8109bf6d>] test_clear_page_writeback+0x53/0x107

...............................................................................................................................................................................................

                   &(&uhci->lock)->rlock:             1              1          34.35          34.35          34.35              6            675           0.31          60.84        4352.58
                   ---------------------
                   &(&uhci->lock)->rlock              1          [<ffffffff8133a1a8>] uhci_irq+0x122/0x144
                   ---------------------
                   &(&uhci->lock)->rlock              1          [<ffffffff8133b0ab>] uhci_hub_status_data+0x2d/0x176

...............................................................................................................................................................................................

                 &tty->atomic_write_lock:             1              1          43.86          43.86          43.86              1            495           2.31        4015.02       21990.19
                 -----------------------
                 &tty->atomic_write_lock              1          [<ffffffff81212c3c>] tty_write_lock+0x31/0x43
                   &(&list->lock)->rlock:             1              1           1.08           1.08           1.08            265           2891           0.00           8.61        1744.06
                   ---------------------
                   &(&list->lock)->rlock              1          [<ffffffff8137ed98>] skb_queue_tail+0x1f/0x4a
                   ---------------------
                   &(&list->lock)->rlock              1          [<ffffffff8138292d>] __skb_recv_datagram+0x58/0x231

...............................................................................................................................................................................................

            &sb->s_type->i_mutex_key#1/1:             1              1     1261514.46     1261514.46     1261514.46             50            144           3.27       14757.15       78532.14
            ----------------------------
            &sb->s_type->i_mutex_key#1/1              1          [<ffffffff810d39e5>] do_unlinkat+0x64/0x17f
            ----------------------------
            &sb->s_type->i_mutex_key#1/1              1          [<ffffffff810d6976>] vfs_readdir+0x44/0xa1

...............................................................................................................................................................................................

        &(&ioc->scsi_lookup_lock)->rlock:             1              1           1.03           1.03           1.03           7117          11944           0.00          11.63        6960.72
        --------------------------------
        &(&ioc->scsi_lookup_lock)->rlock              1          [<ffffffff812f8295>] mptscsih_getclear_scsi_lookup+0x22/0x50
        --------------------------------
        &(&ioc->scsi_lookup_lock)->rlock              1          [<ffffffff812f98a7>] mptscsih_qcmd+0x48d/0x4fa

...............................................................................................................................................................................................

                          &ids->rw_mutex:             1              1           2.03           2.03           2.03             33             36           2.20          54.87         186.31
                          --------------
                          &ids->rw_mutex              1          [<ffffffff811a41f4>] shm_close+0x2f/0xcf
                          --------------
                          &ids->rw_mutex              1          [<ffffffff811a41f4>] shm_close+0x2f/0xcf

...............................................................................................................................................................................................

                             logbuf_lock:             1              1           2.02           2.02           2.02            111          83559           0.00          22.55       28042.04
                             -----------
                             logbuf_lock              1          [<ffffffff81039d88>] do_syslog+0x16e/0x3c1
                             -----------
                             logbuf_lock              1          [<ffffffff810393ee>] release_console_sem+0x44/0x1aa

...............................................................................................................................................................................................

                              &vec->lock:             4              1           1.39           1.39           1.39           1131           3940           0.00           1.18        1870.94
                              ----------
                              &vec->lock              3          [<ffffffff8108d6e4>] cpupri_set+0x5c/0xd6
                              &vec->lock              1          [<ffffffff8108d724>] cpupri_set+0x9c/0xd6
                              ----------
                              &vec->lock              3          [<ffffffff8108d6e4>] cpupri_set+0x5c/0xd6
                              &vec->lock              1          [<ffffffff8108d724>] cpupri_set+0x9c/0xd6

...............................................................................................................................................................................................

                          init_fs.lock-W:             0              0           0.00           0.00           0.00             45            145           0.00           4.46          71.30
                          init_fs.lock-R:             0              0           0.00           0.00           0.00             44           4817           0.00          53.27        2371.88
                 &type->s_umount_key#2/1:             0              0           0.00           0.00           0.00              0              1          24.24          24.24          24.24
                                vga_lock:             0              0           0.00           0.00           0.00              2           1540           0.00          31.13         669.24
                      sysfs_ino_ida.lock:             0              0           0.00           0.00           0.00              2            378           0.00           7.66         123.32
                            cm_sbs_mutex:             0              0           0.00           0.00           0.00              0              2           6.49          14.95          21.43
                         proto_list_lock:             0              0           0.00           0.00           0.00              1             11           0.54           4.81          12.05
                          sysfs_ino_lock:             0              0           0.00           0.00           0.00             28          13686           0.00          16.81        6127.72
                           binfmt_lock-W:             0              0           0.00           0.00           0.00              0              4           0.00           1.03           1.03
                           binfmt_lock-R:             0              0           0.00           0.00           0.00            736           2465           0.32           5.86        1314.38
                     &journal->j_barrier:             0              0           0.00           0.00           0.00              0              2           9.07          60.67          69.74
            &sb->s_type->i_mutex_key#3/1:             0              0           0.00           0.00           0.00              0              1          58.26          58.26          58.26
              running_helpers_waitq.lock:             0              0           0.00           0.00           0.00             25           1349           0.00           1.09         411.78
                             &fs->lock-W:             0              0           0.00           0.00           0.00           2223           6967           0.00          25.23        4364.18
                             &fs->lock-R:             0              0           0.00           0.00           0.00           3093          87897           0.00          46.80       44339.17
                          tty_ldisc_lock:             0              0           0.00           0.00           0.00            310           1493           0.00           5.34         739.73
                               pcpu_lock:             0              0           0.00           0.00           0.00             17            487           0.00           7.83         695.71
                             ioapic_lock:             0              0           0.00           0.00           0.00             13            636           0.00           8.61         978.41
                        unnamed_dev_lock:             0              0           0.00           0.00           0.00              4             21           0.00           7.53          38.36
                    unnamed_dev_ida.lock:             0              0           0.00           0.00           0.00              4             56           0.00           5.73          26.52
                       cache_chain_mutex:             0              0           0.00           0.00           0.00              1            403           0.00       22115.11       41070.72
                    &(&cwq->lock)->rlock:             0              0           0.00           0.00           0.00            550          26391           0.00          16.19       42764.56
                   &type->s_umount_key/1:             0              0           0.00           0.00           0.00              0              1         135.67         135.67         135.67
                           vmlist_lock-W:             0              0           0.00           0.00           0.00             14            254           0.00           8.21         239.09
                           vmlist_lock-R:             0              0           0.00           0.00           0.00            121            172           0.51           9.34         487.83
                        pcpu_alloc_mutex:             0              0           0.00           0.00           0.00             17            379           0.00         446.25        3887.12
                 &type->s_umount_key#5/1:             0              0           0.00           0.00           0.00              0              3          18.47          54.11         114.46
                          workqueue_lock:             0              0           0.00           0.00           0.00              1             10           0.32           3.75           8.69
                          vmap_area_lock:             0              0           0.00           0.00           0.00             14            257           0.00          36.61         734.39
                             sysctl_lock:             0              0           0.00           0.00           0.00             28          53140           0.00          20.41       17676.32
                     sched_domains_mutex:             0              0           0.00           0.00           0.00              0              1         223.40         223.40         223.40
                         mnt_id_ida.lock:             0              0           0.00           0.00           0.00              9             82           0.00           4.79          36.74
                      call_function.lock:             0              0           0.00           0.00           0.00            262            267           0.00           3.52         168.91
                        &input_pool.lock:             0              0           0.00           0.00           0.00           1478           8386           0.00          36.01        7818.03
                                   key#4:             0              0           0.00           0.00           0.00            345          16807           0.00          14.19       31665.65
                              ptype_lock:             0              0           0.00           0.00           0.00              1              7           0.40           3.70           7.79
                 &(&k->list_lock)->rlock:             0              0           0.00           0.00           0.00             26           1585           0.00          10.32         618.13
                            dpm_list_mtx:             0              0           0.00           0.00           0.00             16           1047           0.00           5.48         512.00
                           sequence_lock:             0              0           0.00           0.00           0.00             45           2472           0.00          13.04         948.50
              &sb->s_type->i_mutex_key/1:             0              0           0.00           0.00           0.00              0            204           1.74          74.89        2461.10
                                   key#5:             0              0           0.00           0.00           0.00            292           4062           0.00          10.56        5304.82
                                 khelper:             0              0           0.00           0.00           0.00              0           1354           0.00        3842.91      138747.12
                       (&sub_info->work):             0              0           0.00           0.00           0.00              0           1354           0.00        3842.60      138099.20
                                   key#6:             0              0           0.00           0.00           0.00           2676           4014           0.00        3819.73       11139.70
                    &p->cred_guard_mutex:             0              0           0.00           0.00           0.00           2359           2532           0.00      222875.79     4601536.12
                                   key#1:             0              0           0.00           0.00           0.00              1              3           0.41           7.37           8.53
                &sb->s_type->i_mutex_key:             0              0           0.00           0.00           0.00            133           2604           0.00         124.82       34471.57
                       mb_cache_spinlock:             0              0           0.00           0.00           0.00             43            447           0.32           4.60         268.33
                                   key#7:             0              0           0.00           0.00           0.00           5063          13435           0.00          16.69       12988.25
                                nls_lock:             0              0           0.00           0.00           0.00              0              5           0.31           3.77           5.07
                     sysdev_drivers_lock:             0              0           0.00           0.00           0.00              1             35           0.00       20383.14       20415.13
                           elv_list_lock:             0              0           0.00           0.00           0.00              2             36           0.57           6.79          37.31
                 &type->s_umount_key#6/1:             0              0           0.00           0.00           0.00              0              1          30.90          30.90          30.90
                 &(&usbhid->lock)->rlock:             0              0           0.00           0.00           0.00              1              6           0.38          20.83          50.50
                         net_family_lock:             0              0           0.00           0.00           0.00              1              5           0.33           4.00           6.06
                         nl_table_lock-W:             0              0           0.00           0.00           0.00              1            322           0.00          16.48         243.65
                         nl_table_lock-R:             0              0           0.00           0.00           0.00             85           2762           0.00           5.26        1034.06
                      nl_table_wait.lock:             0              0           0.00           0.00           0.00             86           2940           0.00           5.49        1019.96
                          async_new.lock:             0              0           0.00           0.00           0.00              5             14           0.32           6.81          35.09
                             pin_fs_lock:             0              0           0.00           0.00           0.00              4            766           0.00           1.23         257.40
                 &type->s_umount_key#7/1:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
              &sb->s_type->i_mutex_key#2:             0              0           0.00           0.00           0.00              6            761           0.00          39.19        9187.87
         &per_cpu(cpu_policy_rwsem, cpu):             0              0           0.00           0.00           0.00              4              8           1.23       20333.85       20349.66
                    pending_packets_lock:             0              0           0.00           0.00           0.00              0              2           0.48           4.52           5.00
                                   key#3:             0              0           0.00           0.00           0.00           2347           2372           0.00           8.01        1566.82
                     file_systems_lock-W:             0              0           0.00           0.00           0.00              1             28           0.00          13.45          68.88
                     file_systems_lock-R:             0              0           0.00           0.00           0.00             19             58           0.58          22.32         611.54
               &(&ptr->list_lock)->rlock:             0              0           0.00           0.00           0.00            148            630           0.00           5.51         462.74
                         index_init_lock:             0              0           0.00           0.00           0.00              0             16           0.00           0.00           0.00
                                   key#2:             0              0           0.00           0.00           0.00              0              3           0.38           4.89           5.65
              &(&newf->file_lock)->rlock:             0              0           0.00           0.00           0.00           3746         319676           0.00          55.24      118878.38
                         &on_slab_l3_key:             0              0           0.00           0.00           0.00             97            534           0.00           7.40         382.29
                          die_chain.lock:             0              0           0.00           0.00           0.00              0              3           0.00           0.99           0.99
                               (sm_work):             0              0           0.00           0.00           0.00              0              8           0.00        3045.03       11931.94
                        trace_types_lock:             0              0           0.00           0.00           0.00              0              2           0.00           1.54           1.54
                shrinker_rwsem.wait_lock:             0              0           0.00           0.00           0.00              0             10           0.32           3.93           8.16
                panic_notifier_list.lock:             0              0           0.00           0.00           0.00              0              3           0.00           0.75           0.75
                   (&(&work.work)->work):             0              0           0.00           0.00           0.00              0              4           0.00           9.98          28.58
                          shrinker_rwsem:             0              0           0.00           0.00           0.00              0              5           1.02           9.97          17.58
                 &rt_rq->rt_runtime_lock:             0              0           0.00           0.00           0.00            176           2111           0.00           5.44         837.99
                              genl_mutex:             0              0           0.00           0.00           0.00              0              5           0.00           5.73           7.09
                    percpu_counters_lock:             0              0           0.00           0.00           0.00              4            292           0.00           4.87         157.55
                                rtc_lock:             0              0           0.00           0.00           0.00              1          29577           0.00          21.78      333388.79
                             kclist_lock:             0              0           0.00           0.00           0.00              0              5           0.00           1.24           2.54
                  &rt_b->rt_runtime_lock:             0              0           0.00           0.00           0.00             27             55           0.00           4.23         128.80
                             &p->pi_lock:             0              0           0.00           0.00           0.00             12            186           0.00           6.83         159.70
                           watchdog_lock:             0              0           0.00           0.00           0.00            276            282           0.00          11.25         969.63
                                     key:             0              0           0.00           0.00           0.00             33            269           0.00          13.20         415.75
                     kthread_create_lock:             0              0           0.00           0.00           0.00             18            243           0.00           4.69          86.86
                       clocksource_mutex:             0              0           0.00           0.00           0.00              0              6           0.00        2364.81        2367.16
                    &irq_desc_lock_class:             0              0           0.00           0.00           0.00           2698          31649           0.00          42.20       17809.24
                             vector_lock:             0              0           0.00           0.00           0.00             11             98           0.00           5.39          69.19
                                misc_mtx:             0              0           0.00           0.00           0.00             11             72           0.00         317.98        2316.86
                  old_style_seqlock_init:             0              0           0.00           0.00           0.00           1281          25922           0.00           4.51       10514.60
                      &sync_supers_timer:             0              0           0.00           0.00           0.00              0             23           4.22          14.83         149.67
                          acpi_link_lock:             0              0           0.00           0.00           0.00              0              8        6542.24        8023.44       57489.51
                &(&p->alloc_lock)->rlock:             0              0           0.00           0.00           0.00           4666          39489           0.00          26.40       24135.40
                           acpi_prt_lock:             0              0           0.00           0.00           0.00              1             61           0.30           6.88          40.56
                         &bdev->bd_mutex:             0              0           0.00           0.00           0.00             58            384           0.56      304068.31      707310.32
                    struct class mutex#2:             0              0           0.00           0.00           0.00              0              5           1.58           9.20          15.86
                    struct class mutex#5:             0              0           0.00           0.00           0.00              1             11           0.00           3.64          21.46
                              vga_lock#2:             0              0           0.00           0.00           0.00              0              1        1962.89        1962.89        1962.89
                      netlink_chain.lock:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                            scsi_nl_lock:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                          hub_event_lock:             0              0           0.00           0.00           0.00              8             18           0.33           7.49          38.79
                         khubd_wait.lock:             0              0           0.00           0.00           0.00              8             17           0.38           5.97          29.19
                             serio_mutex:             0              0           0.00           0.00           0.00              0              5          15.41      332346.20      415869.11
                        serio_event_lock:             0              0           0.00           0.00           0.00              8             13           0.33           8.42          33.81
                         serio_wait.lock:             0              0           0.00           0.00           0.00              8             14           0.37           6.47          28.30
                    struct class mutex#6:             0              0           0.00           0.00           0.00              1              5           0.00           2.78           9.04
                         dev_base_lock-W:             0              0           0.00           0.00           0.00              6             21           0.00           1.11          14.69
                         dev_base_lock-R:             0              0           0.00           0.00           0.00             11             65           1.05           4.66         137.77
                              i8042_lock:             0              0           0.00           0.00           0.00              4             41           2.14         317.07        4105.28
                                   key#9:             0              0           0.00           0.00           0.00              6             12           0.00           7.70          26.32
                    &(&work.work)->timer:             0              0           0.00           0.00           0.00              0              4           0.00          15.31          44.23
                                  events:             0              0           0.00           0.00           0.00              0           1502           0.00        3407.67       34554.10
                                   key#2:             0              0           0.00           0.00           0.00              0             22           0.32           5.87          29.94
                              setup_lock:             0              0           0.00           0.00           0.00              0              4          78.56         298.27         912.01
                                    lock:             0              0           0.00           0.00           0.00              0              2          95.25        3108.65        3203.90
                                   kstop:             0              0           0.00           0.00           0.00              0             19           0.00        3046.26       11985.39
                        inet6_proto_lock:             0              0           0.00           0.00           0.00              1              8           0.31           4.10           7.50
                       trace_event_mutex:             0              0           0.00           0.00           0.00              0             96           1.07          15.50         128.13
             trace_event_mutex.wait_lock:             0              0           0.00           0.00           0.00              0            192           0.29           4.69          65.15
                 &type->s_umount_key#8/1:             0              0           0.00           0.00           0.00              0              1          16.85          16.85          16.85
                               bdev_lock:             0              0           0.00           0.00           0.00            150            480           0.31           6.71         518.18
                 &type->s_umount_key#9/1:             0              0           0.00           0.00           0.00              0              1          15.42          15.42          15.42
                                pnp_lock:             0              0           0.00           0.00           0.00              0             17           0.31           4.84          11.95
                    struct class mutex#7:             0              0           0.00           0.00           0.00              0              9           1.68          10.80          24.50
                               cdev_lock:             0              0           0.00           0.00           0.00            480            880           0.32           7.88         671.61
                          hl_drivers_sem:             0              0           0.00           0.00           0.00              1              3           1.29          16.16          20.16
                hl_drivers_sem.wait_lock:             0              0           0.00           0.00           0.00              1              6           0.37           5.38           8.22
                            hl_irqs_lock:             0              0           0.00           0.00           0.00              1              3           0.43           4.29           5.43
                  cpufreq_governor_mutex:             0              0           0.00           0.00           0.00              1              3           0.99           6.91          10.06
                             buses_mutex:             0              0           0.00           0.00           0.00              0              1           6.16           6.16           6.16
                         inet_proto_lock:             0              0           0.00           0.00           0.00              1              7           0.30           4.61           8.29
                             inetsw_lock:             0              0           0.00           0.00           0.00              1              5           0.30           3.70           5.90
                           redirect_lock:             0              0           0.00           0.00           0.00             58            317           0.32           5.45         163.16
                  &nonblocking_pool.lock:             0              0           0.00           0.00           0.00            757           5551           0.00          11.47        4663.36
                  random_write_wait.lock:             0              0           0.00           0.00           0.00            760           1265           0.23           5.46         768.93
                          neigh_tbl_lock:             0              0           0.00           0.00           0.00              1              2           1.14           4.48           5.62
                                &p->lock:             0              0           0.00           0.00           0.00              4           5699           0.00       99070.29     1401199.38
                            &tbl->lock-W:             0              0           0.00           0.00           0.00              8            111           0.00         126.39         317.38
                            &tbl->lock-R:             0              0           0.00           0.00           0.00             23             92           0.40           1.84          77.36
                  raw_v4_hashinfo.lock-W:             0              0           0.00           0.00           0.00              0             34           0.33           6.92          19.10
                  raw_v4_hashinfo.lock-R:             0              0           0.00           0.00           0.00              2              2           1.03           1.11           2.13
                      tcp_cong_list_lock:             0              0           0.00           0.00           0.00              1              3           0.98        2312.66        4546.62
                         cache_list_lock:             0              0           0.00           0.00           0.00              0             15           0.32           8.51          47.53
                     svc_xprt_class_lock:             0              0           0.00           0.00           0.00              0              2           0.42           4.17           4.59
                          xprt_list_lock:             0              0           0.00           0.00           0.00              0              3        3802.03        5540.39       13148.20
                    (cache_cleaner).work:             0              0           0.00           0.00           0.00              0             10           2.82          15.75          70.34
                                   key#2:             0              0           0.00           0.00           0.00             11           1350           0.00           7.05         606.77
                         &watchdog_timer:             0              0           0.00           0.00           0.00              0            277           3.53          17.41        1213.34
                 &sb->s_type->i_lock_key:             0              0           0.00           0.00           0.00            116            321           0.30          31.98         151.74
                    &(&f->f_lock)->rlock:             0              0           0.00           0.00           0.00             33           1148           0.00          23.65         838.41
            &sb->s_type->i_alloc_sem_key:             0              0           0.00           0.00           0.00              0             36           1.35           8.88          61.05
          &sb->s_type->i_alloc_sem_key#3:             0              0           0.00           0.00           0.00              0              3           4.65          12.02          23.57
                  net/sunrpc/cache.c:306:             0              0           0.00           0.00           0.00              0              9           1.81          18.59          55.18
                                &q->lock:             0              0           0.00           0.00           0.00           7591           7594           0.43          10.52        5150.60
                          therm_cpu_lock:             0              0           0.00           0.00           0.00              0              1          28.24          28.24          28.24
                    struct class mutex#8:             0              0           0.00           0.00           0.00              0              4           1.65           8.98          13.93
                    struct class mutex#9:             0              0           0.00           0.00           0.00              0              4           1.62           9.00          13.93
                            uidhash_lock:             0              0           0.00           0.00           0.00             16             37           0.35           4.37          32.22
                         _minor_idr.lock:             0              0           0.00           0.00           0.00              0             14           0.30          11.49          15.87
                      fsnotify_grp_mutex:             0              0           0.00           0.00           0.00              3              6           1.04           6.13          14.84
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          35.08          35.08          35.08
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          20.99          20.99          20.99
                                   key#2:             0              0           0.00           0.00           0.00              3             10           0.34           5.47          10.27
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          31.27          31.27          31.27
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1         129.53         129.53         129.53
              &sb->s_type->i_mutex_key#3:             0              0           0.00           0.00           0.00              0              2          32.73          91.86         124.59
                    init_sighand.siglock:             0              0           0.00           0.00           0.00              2              8           0.41           8.00          12.55
         &(&journal->j_list_lock)->rlock:             0              0           0.00           0.00           0.00            277          12341           0.14         117.07       12731.85
   &(&(kretprobe_table_locks[i].lock))->:             0              0           0.00           0.00           0.00           1508           3545           0.00           6.00        1715.93
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          34.18          34.18          34.18
                                   key#3:             0              0           0.00           0.00           0.00           1501           6396           0.00          18.63        7475.32
             &(&drv->dynids.lock)->rlock:             0              0           0.00           0.00           0.00              1           2150           0.29           7.41         718.49
         &(&priv->bus_notifier)->rwsem-R:             0              0           0.00           0.00           0.00              3             43           0.98       37932.24       46011.41
             &(&dev->devres_lock)->rlock:             0              0           0.00           0.00           0.00              3             54           0.31           6.29          28.10
                                   key#3:             0              0           0.00           0.00           0.00              0              1          11.31          11.31          11.31
                    struct class mutex#1:             0              0           0.00           0.00           0.00              2              8           1.25          10.01          22.48
                             input_mutex:             0              0           0.00           0.00           0.00              3              8           0.86         209.99         633.38
            input_devices_poll_wait.lock:             0              0           0.00           0.00           0.00              2              6           0.35           5.61           8.30
                     cpuidle_driver_lock:             0              0           0.00           0.00           0.00              0              1           5.09           5.09           5.09
                   thermal_cdev_idr.lock:             0              0           0.00           0.00           0.00              0             14           0.30           6.76          10.82
                        thermal_idr_lock:             0              0           0.00           0.00           0.00              0             16           0.76           8.28          20.73
                    struct class mutex#1:             0              0           0.00           0.00           0.00              0             16           1.63          10.71          37.11
                       thermal_list_lock:             0              0           0.00           0.00           0.00              0             16           0.54           7.98          16.26
                              async_lock:             0              0           0.00           0.00           0.00              8             20           0.32           6.94          19.70
                     &blocking_pool.lock:             0              0           0.00           0.00           0.00              3             17           0.39           4.73          24.90
                    struct class mutex#1:             0              0           0.00           0.00           0.00              0            587           1.55           7.52        1008.75
                         async_done.lock:             0              0           0.00           0.00           0.00              5              8           0.39           5.48          13.49
                    struct class mutex#1:             0              0           0.00           0.00           0.00              4             14           1.32           8.86          38.27
                        slock-AF_NETLINK:             0              0           0.00           0.00           0.00              0            108           0.30           3.83          42.99
                             &dev->mutex:             0              0           0.00           0.00           0.00              4             11           0.52          36.34          77.60
                     tick_broadcast_lock:             0              0           0.00           0.00           0.00             11             13           0.00           3.42          13.61
                             i8259A_lock:             0              0           0.00           0.00           0.00              6            151           0.00         130.26         398.82
                 init_mm.page_table_lock:             0              0           0.00           0.00           0.00              2          57592           0.00           1.09          55.15
                 resource_alignment_lock:             0              0           0.00           0.00           0.00              0             76           0.31           8.03          31.69
                    (&cfqd->unplug_work):             0              0           0.00           0.00           0.00              0           5863           0.00         202.66       24314.02
                                pci_lock:             0              0           0.00           0.00           0.00              4           8206           0.00           9.96       21465.99
                    struct class mutex#4:             0              0           0.00           0.00           0.00              0             13           0.00           0.00           0.00
                       (&q->unplug_work):             0              0           0.00           0.00           0.00              0             70           0.20          28.99         285.58
                   pci_bus_sem.wait_lock:             0              0           0.00           0.00           0.00              0           1588           0.29           6.87         499.70
                              i8253_lock:             0              0           0.00           0.00           0.00              0              4           0.00           0.00           0.00
                           pci_bus_sem-W:             0              0           0.00           0.00           0.00              0             89           0.89           1.27          84.67
                           pci_bus_sem-R:             0              0           0.00           0.00           0.00              0            705           0.88          18.99         764.39
                    probe_waitqueue.lock:             0              0           0.00           0.00           0.00              6             90           0.00           8.09          43.37
                     init_task.file_lock:             0              0           0.00           0.00           0.00              5           1355           0.00          14.69        1381.79
                       semaphore->lock#2:             0              0           0.00           0.00           0.00             22            960           0.00           0.75         194.80
                        acpi_device_lock:             0              0           0.00           0.00           0.00              0            126           0.00          11.80          81.35
                            memtype_lock:             0              0           0.00           0.00           0.00              1             23           0.00           5.74          36.18
                        tick_device_lock:             0              0           0.00           0.00           0.00              4              7           0.00          13.92          31.47
                 &rcu_bh_state.onofflock:             0              0           0.00           0.00           0.00              0              4           0.00           1.40           2.47
                                pm_mutex:             0              0           0.00           0.00           0.00              0              1           5.91           5.91           5.91
                           acpi_res_lock:             0              0           0.00           0.00           0.00              0             11           0.41          11.91          16.56
                         semaphore->lock:             0              0           0.00           0.00           0.00              1         202866           0.00           5.26       45298.77
           &(&_acpi_gbl_gpe_lock)->rlock:             0              0           0.00           0.00           0.00              0              4           0.33           4.98           8.69
      &(&_acpi_gbl_hardware_lock)->rlock:             0              0           0.00           0.00           0.00              0             13           1.44           9.53          43.66
                                cpa_lock:             0              0           0.00           0.00           0.00              2          65690           0.00          23.10       21088.35
                    init_task.alloc_lock:             0              0           0.00           0.00           0.00              0              6           0.00           1.11           4.19
                                   key#8:             0              0           0.00           0.00           0.00            945           1889           0.00          11.49        1120.82
                    struct class mutex#1:             0              0           0.00           0.00           0.00              2              5           1.61          12.57          20.07
                              purge_lock:             0              0           0.00           0.00           0.00              2             26           0.00         113.14         183.28
                       sg_index_idr.lock:             0              0           0.00           0.00           0.00              2             14           0.35           8.69          13.72
                           kacpi_hotplug:             0              0           0.00           0.00           0.00              0              1        4309.31        4309.31        4309.31
                             cdrom_mutex:             0              0           0.00           0.00           0.00              1              1           9.82           9.82           9.82
                   (linkwatch_work).work:             0              0           0.00           0.00           0.00              0              2          10.12        3406.48        3416.60
                            kacpi_notify:             0              0           0.00           0.00           0.00              0              1           5.79           5.79           5.79
                                 smp_alt:             0              0           0.00           0.00           0.00              0              4           0.61           5.20           7.71
                        cpu_hotplug.lock:             0              0           0.00           0.00           0.00              2            261           0.00       96217.76      288296.42
                           sg_index_lock:             0              0           0.00           0.00           0.00              2              5           1.84          10.05          19.45
       &(&futex_queues[i].lock)->rlock/1:             0              0           0.00           0.00           0.00             16             23           0.31          14.79          61.56
            &(&tp->indirect_lock)->rlock:             0              0           0.00           0.00           0.00              0             14           3.51          12.79          59.70
                          &(work)->timer:             0              0           0.00           0.00           0.00              0            530           1.55          16.74        2972.11
                     &(reap_work)->timer:             0              0           0.00           0.00           0.00              0            276           1.47           6.99         552.61
                         (&(work)->work):             0              0           0.00           0.00           0.00              0            530           2.04          13.91        2382.20
                    (&(reap_work)->work):             0              0           0.00           0.00           0.00              0            276          18.60         324.19       16943.80
               &(&ioc->FreeQlock)->rlock:             0              0           0.00           0.00           0.00           7113          13980           0.00          12.30        7697.11
           &(&ioc->taskmgmt_lock)->rlock:             0              0           0.00           0.00           0.00              2            237           0.32           8.65         315.67
                &ioc->mptbase_cmds.mutex:             0              0           0.00           0.00           0.00              0             98          44.51       17893.51       70246.17
                                   key#1:             0              0           0.00           0.00           0.00              1            300           0.32           8.37         388.16
                    struct class mutex#1:             0              0           0.00           0.00           0.00              0              6           1.65          11.80          20.32
               &ioc->taskmgmt_cmds.mutex:             0              0           0.00           0.00           0.00              0              2      635170.88      639255.09     1274425.97
                                   key#4:             0              0           0.00           0.00           0.00             13            633           0.31          15.57         310.83
                  &spi_dv_mutex(starget):             0              0           0.00           0.00           0.00              0              4       19310.07       22193.64       83517.92
                       sd_index_ida.lock:             0              0           0.00           0.00           0.00              0             20           0.30          13.62          20.40
                           sd_index_lock:             0              0           0.00           0.00           0.00              0              2           2.02          19.18          21.20
                    struct class mutex#2:             0              0           0.00           0.00           0.00              0              2           1.66          14.47          16.13
                     (&sdev->event_work):             0              0           0.00           0.00           0.00              0             26           0.25          14.02          20.25
                        &q->unplug_timer:             0              0           0.00           0.00           0.00              0             66           0.21          13.03         117.99
                             &q->timeout:             0              0           0.00           0.00           0.00              0             68           0.20           9.70          49.88
                   &in_dev->mr_ifc_timer:             0              0           0.00           0.00           0.00              0              3           4.57         105.03         133.74
                          &q->sysfs_lock:             0              0           0.00           0.00           0.00              0             26           0.51           9.83          23.97
                         &eq->sysfs_lock:             0              0           0.00           0.00           0.00              0             26           6.06          56.87         288.29
                 &cfqd->idle_slice_timer:             0              0           0.00           0.00           0.00              0           1426           0.20          13.29        8199.01
                           &evdev->mutex:             0              0           0.00           0.00           0.00              2              2           3.07          10.59          13.66
        &(&ioc->fault_reset_work)->timer:             0              0           0.00           0.00           0.00              0            135           4.35          17.84         843.07
                (ioc->reset_work_q_name):             0              0           0.00           0.00           0.00              0            135           3.42          21.77         627.39
       (&(&ioc->fault_reset_work)->work):             0              0           0.00           0.00           0.00              0            135           2.67           9.38         518.20
                        slock-AF_INET6/1:             0              0           0.00           0.00           0.00             84            143           0.34         153.36        1130.21
                            sd_ref_mutex:             0              0           0.00           0.00           0.00             17            261           0.54           6.18         229.97
                     &newsk->sk_dst_lock:             0              0           0.00           0.00           0.00              0              1           7.70           7.70           7.70
                    &(&new->lock)->rlock:             0              0           0.00           0.00           0.00             34             70           0.41           6.97          61.25
                                 kblockd:             0              0           0.00           0.00           0.00              0           5829           0.00         203.35       28165.29
               &sb->s_type->i_lock_key#2:             0              0           0.00           0.00           0.00              1              2           0.53           5.92           6.45
                 &(&expires_work)->timer:             0              0           0.00           0.00           0.00              0              1          20.08          20.08          20.08
                    struct class mutex#2:             0              0           0.00           0.00           0.00              1              1          11.43          11.43          11.43
              &rcu_sched_state.onofflock:             0              0           0.00           0.00           0.00              0              4           0.00           1.59           2.69
                       usb_bus_list_lock:             0              0           0.00           0.00           0.00              1              9           0.55        6705.33       20979.08
                              pools_lock:             0              0           0.00           0.00           0.00              1             26           0.47          12.42          41.50
             (usb_notifier_list).rwsem-R:             0              0           0.00           0.00           0.00              2             10          12.32         891.02        1779.72
     (usb_notifier_list).rwsem.wait_lock:             0              0           0.00           0.00           0.00              2             20           0.29           6.93          14.33
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              1          41.39          41.39          41.39
              &sb->s_type->i_mutex_key#4:             0              0           0.00           0.00           0.00             10             52           0.45          23.84         239.66
                   deviceconndiscwq.lock:             0              0           0.00           0.00           0.00              2             10           0.35           7.74          11.52
                                mon_lock:             0              0           0.00           0.00           0.00              1              8           0.57           8.46          12.79
                 &(&retval->lock)->rlock:             0              0           0.00           0.00           0.00             10           1118           0.29          27.83         543.42
              ehci_cf_port_reset_rwsem-W:             0              0           0.00           0.00           0.00              1              1        8062.82        8062.82        8062.82
              ehci_cf_port_reset_rwsem-R:             0              0           0.00           0.00           0.00              1              5       55853.26      116034.35      499772.92
      ehci_cf_port_reset_rwsem.wait_lock:             0              0           0.00           0.00           0.00              2             12           0.33           6.81          11.74
                       device_state_lock:             0              0           0.00           0.00           0.00              3             32           0.34           7.97          23.71
                       hcd_root_hub_lock:             0              0           0.00           0.00           0.00             10            320           0.30          33.31         289.56
                       hcd_urb_list_lock:             0              0           0.00           0.00           0.00              9            294           0.30           9.10         117.46
                                   key#1:             0              0           0.00           0.00           0.00              0            310           0.30           8.55         224.48
                   &hcd->bandwidth_mutex:             0              0           0.00           0.00           0.00              2              7           8.61        2659.12        2940.81
                         set_config_lock:             0              0           0.00           0.00           0.00              2              6           0.37           9.68          12.31
                   &(&ehci->lock)->rlock:             0              0           0.00           0.00           0.00             15            105           0.35         281.47         920.36
      &(&new_driver->dynids.lock)->rlock:             0              0           0.00           0.00           0.00              4             25           0.30          12.35          21.85
                      &hub->status_mutex:             0              0           0.00           0.00           0.00              2             34           6.73         290.05        1377.35
                     cpu_add_remove_lock:             0              0           0.00           0.00           0.00              1             51           0.00       96218.27      290894.44
               &(&hub->init_work)->timer:             0              0           0.00           0.00           0.00              0              8           5.52          23.41          64.84
              (&(&hub->init_work)->work):             0              0           0.00           0.00           0.00              0              8           5.16         432.96         647.95
                           sr_index_lock:             0              0           0.00           0.00           0.00              1              1          12.17          12.17          12.17
                                   key#1:             0              0           0.00           0.00           0.00              2              3           0.80           6.83          13.89
                        lweventlist_lock:             0              0           0.00           0.00           0.00              0              6           0.34           7.99          10.80
                      &mousedev->mutex/3:             0              0           0.00           0.00           0.00              2              2          16.61         133.55         150.16
                       &serio->drv_mutex:             0              0           0.00           0.00           0.00              2              3       82988.29      166756.70      415253.17
                            &serio->lock:             0              0           0.00           0.00           0.00              2             32           0.31           6.47          43.09
                      &ps2dev->cmd_mutex:             0              0           0.00           0.00           0.00              0              5       82562.94       83624.88      414119.53
                             i8042_mutex:             0              0           0.00           0.00           0.00              0              5       82561.70       83623.65      414100.41
                                  (work):             0              0           0.00           0.00           0.00              0              3           1.60        4308.84        4315.44
                                 _lock-W:             0              0           0.00           0.00           0.00              1              3           1.34          18.07          20.99
                                 _lock-R:             0              0           0.00           0.00           0.00              2              9           1.21           3.91          19.28
                         _lock.wait_lock:             0              0           0.00           0.00           0.00              3             24           0.30           4.60          13.47
                     cpufreq_driver_lock:             0              0           0.00           0.00           0.00              4             86           0.30           6.89          38.56
                            cpuidle_lock:             0              0           0.00           0.00           0.00              1              2        3024.43        3181.23        6205.66
                   inet_diag_table_mutex:             0              0           0.00           0.00           0.00              1              1           5.18           5.18           5.18
                            inetsw6_lock:             0              0           0.00           0.00           0.00              1              4           0.32           4.88           6.11
                    raw_v6_hashinfo.lock:             0              0           0.00           0.00           0.00              1             38           0.33           7.41          20.48
                             io_tlb_lock:             0              0           0.00           0.00           0.00              2            133           0.34          10.85          81.77
        &(&ip6addrlbl_table.lock)->rlock:             0              0           0.00           0.00           0.00              0              8           0.31           5.48           8.06
                           &ndev->lock-W:             0              0           0.00           0.00           0.00              0             14           0.58           4.77          18.37
                           &ndev->lock-R:             0              0           0.00           0.00           0.00             69            181           0.30          16.11         209.52
                          &idev->mc_lock:             0              0           0.00           0.00           0.00              2             11           0.32           4.36           9.41
                 &(&mc->mca_lock)->rlock:             0              0           0.00           0.00           0.00              4             19           0.48         172.86         400.38
                             _xmit_ETHER:             0              0           0.00           0.00           0.00              7             14           0.79         176.63        1707.45
                    addrconf_verify_lock:             0              0           0.00           0.00           0.00              1              2          13.14          29.12          42.26
                    addrconf_hash_lock-W:             0              0           0.00           0.00           0.00              1              2           6.34          27.75          34.09
                    addrconf_hash_lock-R:             0              0           0.00           0.00           0.00              3             44           0.28           8.44          47.16
                           tunnel4_mutex:             0              0           0.00           0.00           0.00              1              1           5.75           5.75           5.75
                    net_generic_ids.lock:             0              0           0.00           0.00           0.00              1             18           0.30           5.80          11.67
                      usb_address0_mutex:             0              0           0.00           0.00           0.00              0              3       55864.45      300178.46      601078.78
                          &hcd->rh_timer:             0              0           0.00           0.00           0.00              0            522           6.83          62.87        4306.82
              &net->packet.sklist_lock-W:             0              0           0.00           0.00           0.00              3              5           0.57           1.28           4.42
              &net->packet.sklist_lock-R:             0              0           0.00           0.00           0.00              5             17           0.30           4.98          14.20
                        vlan_ioctl_mutex:             0              0           0.00           0.00           0.00              1              1           5.39           5.39           5.39
                       performance_mutex:             0              0           0.00           0.00           0.00              1              1          75.65          75.65          75.65
                  disable_ratelimit_lock:             0              0           0.00           0.00           0.00              1             16           0.30           6.24          10.78
        &(&shost->free_list_lock)->rlock:             0              0           0.00           0.00           0.00            672           6056           0.30           6.61        2446.95
                                  kacpid:             0              0           0.00           0.00           0.00              0              1          13.04          13.04          13.04
               &(&tty->read_lock)->rlock:             0              0           0.00           0.00           0.00             67            617           0.00           6.88         271.70
                         &tty->echo_lock:             0              0           0.00           0.00           0.00             10             99           0.00           6.61          64.72
                     &tty->termios_mutex:             0              0           0.00           0.00           0.00            116            499           0.00          28.70         610.71
                       hierarchy_id_lock:             0              0           0.00           0.00           0.00              0              1           5.75           5.75           5.75
                                   key#2:             0              0           0.00           0.00           0.00             68            605           0.00          10.46         720.35
                     tty_ldisc_wait.lock:             0              0           0.00           0.00           0.00             22             46           0.00           6.38          26.82
                   &(&port->lock)->rlock:             0              0           0.00           0.00           0.00             79            140           0.38           6.58          82.23
                              hash_mutex:             0              0           0.00           0.00           0.00              6             21           0.88          20.90         172.83
                      &(&i->lock)->rlock:             0              0           0.00           0.00           0.00             11            389           0.35          53.35       10693.42
                                   key#2:             0              0           0.00           0.00           0.00             79            268           0.32           6.24         116.73
                      ata_scsi_rbuf_lock:             0              0           0.00           0.00           0.00              0              2           1.93          20.70          22.63
                &adapter->watchdog_timer:             0              0           0.00           0.00           0.00              0             55           1.77          16.17         128.50
                                   key#1:             0              0           0.00           0.00           0.00            144            786           0.33          10.62        1358.88
              &(&sdev->list_lock)->rlock:             0              0           0.00           0.00           0.00           1035          12112           0.00           8.55        5188.45
                         ipv6_sk_ac_lock:             0              0           0.00           0.00           0.00              9             14           0.35           3.95          10.94
                    &(&ret->lock)->rlock:             0              0           0.00           0.00           0.00             58            976           0.30          10.69        1981.46
                 &(&bdi->wb_lock)->rlock:             0              0           0.00           0.00           0.00             10             17           0.31           4.67          13.35
                       &tty->output_lock:             0              0           0.00           0.00           0.00             79            681           0.00        4007.47       16898.23
                 &type->s_umount_key#1-W:             0              0           0.00           0.00           0.00              2              3           2.39           8.22          13.63
                 &type->s_umount_key#1-R:             0              0           0.00           0.00           0.00              0              2           1.04           1.56           2.60
                        &namespace_sem-W:             0              0           0.00           0.00           0.00              3             25           1.18          36.47         215.22
                        &namespace_sem-R:             0              0           0.00           0.00           0.00             70            298           1.22          74.44        6499.72
                                   key#2:             0              0           0.00           0.00           0.00             12            268           0.30           4.78          99.33
                      hierarchy_ida.lock:             0              0           0.00           0.00           0.00              0             16           0.30           4.73           9.37
                       clock-AF_PACKET-W:             0              0           0.00           0.00           0.00              0              2           0.50           7.28           7.78
                       clock-AF_PACKET-R:             0              0           0.00           0.00           0.00              1              3           2.37           7.06          12.90
               &sb->s_type->i_lock_key#3:             0              0           0.00           0.00           0.00            628           2887           0.00           4.73        1149.32
                 &type->s_umount_key#1-W:             0              0           0.00           0.00           0.00              1              2          11.48        1709.45        1720.93
                 &type->s_umount_key#1-R:             0              0           0.00           0.00           0.00              1              2           1.10           2.24           3.34
                      &shost->scan_mutex:             0              0           0.00           0.00           0.00              0              3       63949.48     3362332.91     6786068.22
                           bio_slab_lock:             0              0           0.00           0.00           0.00              0              3           1.60        3736.82        3740.17
                          &buffer->mutex:             0              0           0.00           0.00           0.00              2           3139           0.48       16599.19       49302.54
               &sb->s_type->i_lock_key#4:             0              0           0.00           0.00           0.00            895           2700           0.00           4.68        1043.28
                                   key#1:             0              0           0.00           0.00           0.00             20            213           0.33           7.91         389.09
                            sr_ref_mutex:             0              0           0.00           0.00           0.00              3             24           0.66           8.56          37.49
                               uts_sem-W:             0              0           0.00           0.00           0.00              1              1           1.98           1.98           1.98
                               uts_sem-R:             0              0           0.00           0.00           0.00            341            535           1.00         624.31        1979.99
                       uts_sem.wait_lock:             0              0           0.00           0.00           0.00            342           1072           0.30           3.78         488.93
              &sb->s_type->i_mutex_key#7:             0              0           0.00           0.00           0.00             44           1195           0.00           6.28         838.78
                         &ehci->watchdog:             0              0           0.00           0.00           0.00              0              7           2.49          21.15          66.96
                       &bdev->bd_mutex/1:             0              0           0.00           0.00           0.00              4            113           1.64           8.74         271.59
                                     ata:             0              0           0.00           0.00           0.00              0            169          17.45        8109.80       23253.45
                      clock-AF_NETLINK-W:             0              0           0.00           0.00           0.00              1             75           0.35           0.72          28.99
                      clock-AF_NETLINK-R:             0              0           0.00           0.00           0.00             32           1307           0.00          10.77         532.28
                                bdi_lock:             0              0           0.00           0.00           0.00              5             66           0.00           8.36         119.45
                               net_mutex:             0              0           0.00           0.00           0.00              1             50           0.00        3350.59        7354.84
                                   key#1:             0              0           0.00           0.00           0.00              4             69           0.32          10.14          35.16
                    &ap->fastdrain_timer:             0              0           0.00           0.00           0.00              0             69           0.00           3.72          21.33
               &sb->s_type->i_lock_key#5:             0              0           0.00           0.00           0.00            640           7278           0.00          22.21        2682.58
                 &type->s_umount_key#1-W:             0              0           0.00           0.00           0.00              2              2          11.51          13.66          25.17
                 &type->s_umount_key#1-R:             0              0           0.00           0.00           0.00              1              2           1.05           1.88           2.93
                    struct class mutex#3:             0              0           0.00           0.00           0.00              2             30           0.00           2.60          52.38
          &sb->s_type->i_alloc_sem_key#2:             0              0           0.00           0.00           0.00             11             49           1.41           6.44         114.18
                         &mm->mmap_sem/1:             0              0           0.00           0.00           0.00              0           2947          57.32       20470.52      704090.07
        &(&mm->page_table_lock)->rlock/1:             0              0           0.00           0.00           0.00             13          50537           0.00         127.84      155673.41
               (&(&ap->port_task)->work):             0              0           0.00           0.00           0.00              0            309           0.22        8109.22       23186.26
                           psmouse_mutex:             0              0           0.00           0.00           0.00              0              1       82973.51       82973.51       82973.51
               &sb->s_type->i_lock_key#6:             0              0           0.00           0.00           0.00             55           2042           0.00           6.24         739.91
   &(&flush_state[i].tlbstate_lock)->rlo:             0              0           0.00           0.00           0.00              3            814           2.02          12.89        2208.01
              &sb->s_type->i_mutex_key#1:             0              0           0.00           0.00           0.00              0              4           1.17           8.10          20.34
               &sb->s_type->i_lock_key#7:             0              0           0.00           0.00           0.00              1              3           0.34           3.44           4.57
                &(&dio->bio_lock)->rlock:             0              0           0.00           0.00           0.00              0           1664           0.30           7.03        1342.77
                             fasync_lock:             0              0           0.00           0.00           0.00            123            428           0.00           6.95         214.06
                             rename_lock:             0              0           0.00           0.00           0.00             15             45           1.89          16.06         163.97
             &(&dentry->d_lock)->rlock/1:             0              0           0.00           0.00           0.00              3             45           0.00           1.40          30.51
                   &inode->inotify_mutex:             0              0           0.00           0.00           0.00            216           1332           0.43           4.61         781.36
                            _hash_lock-W:             0              0           0.00           0.00           0.00              2              9           1.28          20.31          46.45
                            _hash_lock-R:             0              0           0.00           0.00           0.00              6             92           1.15          25.48         225.26
                    _hash_lock.wait_lock:             0              0           0.00           0.00           0.00              8            202           0.30           6.65          85.14
                                (work)#2:             0              0           0.00           0.00           0.00              0              8           0.35          16.88          48.71
                                   key#4:             0              0           0.00           0.00           0.00              4              7           0.35           6.14           9.71
                             _minor_lock:             0              0           0.00           0.00           0.00              8             24           0.37           9.42          30.62
                     dm_hash_cells_mutex:             0              0           0.00           0.00           0.00              0              2           1.07           6.65           7.71
                         &md->map_lock-W:             0              0           0.00           0.00           0.00              0              2           0.67           0.68           1.35
                         &md->map_lock-R:             0              0           0.00           0.00           0.00             10            142           0.30           5.93          64.91
                       &md->suspend_lock:             0              0           0.00           0.00           0.00              0              6           9.07          88.52         170.81
                &bdev->bd_fsfreeze_mutex:             0              0           0.00           0.00           0.00              1              6           0.63          52.06          81.15
                          &md->io_lock-W:             0              0           0.00           0.00           0.00              2              6           0.92          23.08          35.80
                          &md->io_lock-R:             0              0           0.00           0.00           0.00              3             68           3.31          18.12         283.65
                                kdmflush:             0              0           0.00           0.00           0.00              0              4           0.22          47.05          58.22
                                   key#1:             0              0           0.00           0.00           0.00              4             71           0.37          11.01          48.52
                             _event_lock:             0              0           0.00           0.00           0.00              0              2           0.88           6.42           7.30
                             (&md->work):             0              0           0.00           0.00           0.00              0              2           5.52          31.26          36.78
            &(&md->deferred_lock)->rlock:             0              0           0.00           0.00           0.00              2              2           0.50           5.37           5.86
                   random_read_wait.lock:             0              0           0.00           0.00           0.00            261           1223           0.34          11.93         610.11
                                   key#2:             0              0           0.00           0.00           0.00              1              4           0.40          12.79          16.87
                 &type->s_umount_key#1/1:             0              0           0.00           0.00           0.00              0              2       11912.18       19007.72       30919.89
                    sysrq_key_table_lock:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
                          proc_inum_lock:             0              0           0.00           0.00           0.00              9            453           0.00           7.46         572.88
                         rcu_read_lock-R:             0              0           0.00           0.00           0.00              0       83242458           0.00         167.20   218149558.62
                &journal->j_commit_timer:             0              0           0.00           0.00           0.00              0            647           0.00          14.74         189.96
                       &type->s_lock_key:             0              0           0.00           0.00           0.00             26            157           0.52         302.92         887.68
                                   key#3:             0              0           0.00           0.00           0.00             13            645           0.32           5.29         256.49
                    struct class mutex#1:             0              0           0.00           0.00           0.00              0              4           1.68          11.61          16.82
                                   key#3:             0              0           0.00           0.00           0.00            155           1919           0.32          15.30        3247.03
                &rcu_sched_state.fqslock:             0              0           0.00           0.00           0.00              0           1005           1.67          10.05        3855.59
                     host_cmd_pool_mutex:             0              0           0.00           0.00           0.00              0              4           0.63          73.70          76.02
                                   key#3:             0              0           0.00           0.00           0.00             59             71           0.35           4.48          41.38
                       &tty->ldisc_mutex:             0              0           0.00           0.00           0.00             81            157           0.47          27.03         352.78
               &(&hdrv->dyn_lock)->rlock:             0              0           0.00           0.00           0.00             27             56           0.30          11.47          32.36
                         dquirks_rwsem-R:             0              0           0.00           0.00           0.00              0              2           1.54          34.18          35.72
                 dquirks_rwsem.wait_lock:             0              0           0.00           0.00           0.00              0              4           0.31          11.16          12.15
               &sb->s_type->i_lock_key#8:             0              0           0.00           0.00           0.00           3110           9000           0.00          13.79        4124.51
               &sb->s_type->i_lock_key#9:             0              0           0.00           0.00           0.00            441            798           0.33           9.89         457.11
                                  lock#2:             0              0           0.00           0.00           0.00              0              1          12.34          12.34          12.34
                         pci_config_lock:             0              0           0.00           0.00           0.00              4           8416           0.00           7.92       16505.83
              &(&dev->event_lock)->rlock:             0              0           0.00           0.00           0.00              0              4           0.78          16.15          19.43
                            hid_open_mut:             0              0           0.00           0.00           0.00              1              2          23.53          23.66          47.19
                                   key#3:             0              0           0.00           0.00           0.00              0              1          16.98          16.98          16.98
                                   key#3:             0              0           0.00           0.00           0.00             61            145           0.51          23.40         186.51
                                   key#3:             0              0           0.00           0.00           0.00             61            145           0.37           5.17          82.82
                            reboot_mutex:             0              0           0.00           0.00           0.00              1              1           5.98           5.98           5.98
                       vt_spawn_con.lock:             0              0           0.00           0.00           0.00              1              1           5.44           5.44           5.44
               (&(&tty->buf.work)->work):             0              0           0.00           0.00           0.00              0            133           0.22          18.31        1130.97
                     (&tty->hangup_work):             0              0           0.00           0.00           0.00              0             24           1.27           6.17          48.09
                                   key#3:             0              0           0.00           0.00           0.00              3             10           0.33           5.87          10.66
                              &up->timer:             0              0           0.00           0.00           0.00              0             10           0.22           4.77           7.13
                &(&tty->buf.lock)->rlock:             0              0           0.00           0.00           0.00             35            683           0.30           5.04         283.21
                      proc_inum_ida.lock:             0              0           0.00           0.00           0.00              9            882           0.00           5.32         291.43
                               swap_lock:             0              0           0.00           0.00           0.00            122            172           0.38          11.46         131.82
                                   key#4:             0              0           0.00           0.00           0.00            149           1194           0.33           9.39         627.69
                         clock-AF_UNIX-W:             0              0           0.00           0.00           0.00             28           2368           0.00           5.18         997.01
                         clock-AF_UNIX-R:             0              0           0.00           0.00           0.00            186           4263           0.00          56.36        6812.80
                    struct class mutex#1:             0              0           0.00           0.00           0.00              2              6           7.80        4857.94       24028.62
                    struct class mutex#2:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
               attribute_container_mutex:             0              0           0.00           0.00           0.00              3            157           0.45         247.16        2065.75
                    struct class mutex#1:             0              0           0.00           0.00           0.00              4             35           1.20           7.44          65.31
                 &type->s_umount_key#2-W:             0              0           0.00           0.00           0.00              0              1          36.78          36.78          36.78
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           1.05           2.05           3.10
            &sb->s_type->i_mutex_key#4/1:             0              0           0.00           0.00           0.00              0              1          14.71          14.71          14.71
                           slock-AF_UNIX:             0              0           0.00           0.00           0.00              0            102           0.34           5.88          52.13
                         sk_lock-AF_UNIX:             0              0           0.00           0.00           0.00              0             51           0.28           4.03          26.80
         &(&futex_queues[i].lock)->rlock:             0              0           0.00           0.00           0.00            103            473           0.36          54.97         559.07
                            &u->readlock:             0              0           0.00           0.00           0.00             70           1448           2.00       14766.25       34299.04
                  bus_type_sem.wait_lock:             0              0           0.00           0.00           0.00             16           2088           0.00           5.37         733.76
                      sk_lock-AF_NETLINK:             0              0           0.00           0.00           0.00              0             54           0.25           4.66          54.72
                   &(&info->lock)->rlock:             0              0           0.00           0.00           0.00             12           4561           0.00          33.62        5741.51
                    &(&idp->lock)->rlock:             0              0           0.00           0.00           0.00              2            102           0.30           5.17          39.66
                        proc_subdir_lock:             0              0           0.00           0.00           0.00            412           4048           0.00         348.65        4677.95
                           printing_lock:             0              0           0.00           0.00           0.00              0            299           0.00           0.00           0.00
                       klist_remove_lock:             0              0           0.00           0.00           0.00              1             34           0.30           8.21          23.47
                            serial_mutex:             0              0           0.00           0.00           0.00              0              2        5585.38        5635.54       11220.92
                          bus_type_sem-W:             0              0           0.00           0.00           0.00              0              3           0.00           1.03           2.06
                          bus_type_sem-R:             0              0           0.00           0.00           0.00             16           1041           0.00           6.27        1247.23
                        target_list_lock:             0              0           0.00           0.00           0.00              4              7           0.38           9.16          12.74
                                   key#4:             0              0           0.00           0.00           0.00              1             33           0.40          11.37          69.63
                            &port->mutex:             0              0           0.00           0.00           0.00            199            539           0.44       11699.72       80269.97
            &sb->s_type->i_mutex_key#9/2:             0              0           0.00           0.00           0.00              0              2           0.35           0.37           0.71
                  &s->s_vfs_rename_mutex:             0              0           0.00           0.00           0.00              0              2          18.52          50.11          68.63
                              port_mutex:             0              0           0.00           0.00           0.00              0              8         229.78        5469.52       22564.19
                    &(&k->k_lock)->rlock:             0              0           0.00           0.00           0.00             66          14059           0.00          20.79        5335.12
                 &type->s_umount_key#4/1:             0              0           0.00           0.00           0.00              0              1          31.81          31.81          31.81
                         sk_lock-AF_INET:             0              0           0.00           0.00           0.00              0       27776643           0.00       63204.21   244723610.75
                         clock-AF_INET-W:             0              0           0.00           0.00           0.00             51            236           0.36           4.32         122.34
                         clock-AF_INET-R:             0              0           0.00           0.00           0.00            207        8022031           0.00          21.32     3101034.42
                            module_mutex:             0              0           0.00           0.00           0.00             19             35           0.66           8.15          45.40
                            swapon_mutex:             0              0           0.00           0.00           0.00              2              5           0.58          13.68          25.17
                 &type->s_umount_key#2-W:             0              0           0.00           0.00           0.00              1              1        1363.21        1363.21        1363.21
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              0             10           8.83       25078.71       40403.06
          &sb->s_type->i_alloc_sem_key#5:             0              0           0.00           0.00           0.00             12             19           7.60        9742.34       18932.71
   &(&transaction->t_handle_lock)->rlock:             0              0           0.00           0.00           0.00            210           3048           0.31          20.00        2707.18
                              jbd_handle:             0              0           0.00           0.00           0.00              0           1202           2.81      114246.06      778520.92
       &(&journal->j_revoke_lock)->rlock:             0              0           0.00           0.00           0.00             31             93           0.32           7.20          70.29
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00            880           1399           0.00           5.82         751.46
                     &ei->truncate_mutex:             0              0           0.00           0.00           0.00             57            315           0.51        9576.34       55496.30
           &(&bgl->locks[i].lock)->rlock:             0              0           0.00           0.00           0.00             95            295           0.30           8.34         121.16
         &(&sbi->s_next_gen_lock)->rlock:             0              0           0.00           0.00           0.00             53             90           0.32           7.46          61.92
                        &ei->xattr_sem-W:             0              0           0.00           0.00           0.00              0              4           3.16        6900.92       12796.14
                        &ei->xattr_sem-R:             0              0           0.00           0.00           0.00             69            242           1.08       88053.41      524431.05
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00             12             20           0.34           5.36          13.08
       &(&sbi->s_rsv_window_lock)->rlock:             0              0           0.00           0.00           0.00             31            222           0.33          12.87         195.99
                &(&tty->buf.work)->timer:             0              0           0.00           0.00           0.00              0            546           0.20           9.22         680.99
                           (&barr->work):             0              0           0.00           0.00           0.00              0              3           4.39          11.94          21.59
                                   key#4:             0              0           0.00           0.00           0.00             13             50           0.30          12.54          38.66
          &sb->s_type->i_alloc_sem_key#4:             0              0           0.00           0.00           0.00             10           1123           9.56         786.87       15426.87
             printk_ratelimit_state.lock:             0              0           0.00           0.00           0.00              0              1           6.79           6.79           6.79
                          sysfs_bin_lock:             0              0           0.00           0.00           0.00              1            304           0.46           7.22         177.55
                              &bb->mutex:             0              0           0.00           0.00           0.00              0            152          43.91          68.08        7337.15
                          _xmit_LOOPBACK:             0              0           0.00           0.00           0.00              0              3           0.44           8.46           9.36
                (inetaddr_chain).rwsem-R:             0              0           0.00           0.00           0.00              1              2          86.59         150.94         237.53
        (inetaddr_chain).rwsem.wait_lock:             0              0           0.00           0.00           0.00              1              4           0.33           6.04           7.44
                         fib_hash_lock-W:             0              0           0.00           0.00           0.00              2             15           0.32           7.15          13.82
                         fib_hash_lock-R:             0              0           0.00           0.00           0.00             15            190           0.34           2.76         158.70
                           fib_info_lock:             0              0           0.00           0.00           0.00              2             15           0.30           8.08          18.00
                 &in_dev->mc_list_lock-W:             0              0           0.00           0.00           0.00              2              3           0.57           6.31           7.49
                 &in_dev->mc_list_lock-R:             0              0           0.00           0.00           0.00              1             10           0.32          59.47          77.18
         &(&in_dev->mc_tomb_lock)->rlock:             0              0           0.00           0.00           0.00              2              6           0.44           6.24           9.67
                    &(&ifa->lock)->rlock:             0              0           0.00           0.00           0.00              0             10           0.34          36.75          49.86
                         &tb->tb6_lock-W:             0              0           0.00           0.00           0.00              2             15           1.15          46.14         174.17
                         &tb->tb6_lock-R:             0              0           0.00           0.00           0.00              1              2           2.71           3.64           6.35
                        fib6_walker_lock:             0              0           0.00           0.00           0.00              0             28           0.31           8.45          18.12
              &group->notification_mutex:             0              0           0.00           0.00           0.00             22           2077           0.00           9.13        1422.25
                       ipv6_sk_mc_lock-W:             0              0           0.00           0.00           0.00              8             15           0.35           5.78          14.27
                       ipv6_sk_mc_lock-R:             0              0           0.00           0.00           0.00              1              1           0.70           0.70           0.70
                                   key#1:             0              0           0.00           0.00           0.00              2              9           0.44           6.89          23.41
                          slock-AF_INET6:             0              0           0.00           0.00           0.00             89            534           0.30          84.80         421.68
                        sk_lock-AF_INET6:             0              0           0.00           0.00           0.00              0            212           0.34         183.52        2549.30
                        clock-AF_INET6-W:             0              0           0.00           0.00           0.00              1             15           0.32           3.80           9.39
                        clock-AF_INET6-R:             0              0           0.00           0.00           0.00             10             45           0.42          15.81         215.33
                      struct class mutex:             0              0           0.00           0.00           0.00              0              1           0.00           0.00           0.00
               (&adapter->watchdog_task):             0              0           0.00           0.00           0.00              0             55          69.38        1068.02        4977.11
                     &idev->mc_ifc_timer:             0              0           0.00           0.00           0.00              0              4          23.86         143.48         274.77
                          icmp6_dst_lock:             0              0           0.00           0.00           0.00              4              9           0.38          12.82          25.21
                              &n->lock-W:             0              0           0.00           0.00           0.00             24             93           0.32          65.47         191.50
                              &n->lock-R:             0              0           0.00           0.00           0.00              1             15           0.55          29.08          53.50
                 &(&list->lock)->rlock#2:             0              0           0.00           0.00           0.00             50            425           0.34           7.62         261.20
                           _xmit_ETHER#2:             0              0           0.00           0.00           0.00             85            223           0.68          17.19        1194.47
                             &ifa->timer:             0              0           0.00           0.00           0.00              0              5          13.14          55.16         171.26
                         slock-AF_PACKET:             0              0           0.00           0.00           0.00              0              4           0.40           8.55           9.92
                       sk_lock-AF_PACKET:             0              0           0.00           0.00           0.00              0              2           4.61       19261.38       19265.99
                &(&po->bind_lock)->rlock:             0              0           0.00           0.00           0.00              0              2           1.34           4.04           5.38
          &(&table->hash[i].lock)->rlock:             0              0           0.00           0.00           0.00             58            157           0.36          26.34         288.86
         &(&table->hash2[i].lock)->rlock:             0              0           0.00           0.00           0.00             39            130           0.33           4.31          69.44
                      &sk->sk_dst_lock-W:             0              0           0.00           0.00           0.00              0            116           0.33           3.28          52.11
                      &sk->sk_dst_lock-R:             0              0           0.00           0.00           0.00              0             36           0.36           0.50          14.86
                &adapter->phy_info_timer:             0              0           0.00           0.00           0.00              0              1          11.41          11.41          11.41
             (&adapter->update_phy_task):             0              0           0.00           0.00           0.00              0              1         966.45         966.45         966.45
                 &(&tbl->gc_work)->timer:             0              0           0.00           0.00           0.00              0             14           4.61          11.80          84.90
                (&(&tbl->gc_work)->work):             0              0           0.00           0.00           0.00              0             14           5.12         133.69         309.72
                    &dev->watchdog_timer:             0              0           0.00           0.00           0.00              0             21           3.80          39.62         128.06
          &(&dev->tx_global_lock)->rlock:             0              0           0.00           0.00           0.00              0             21           3.12          11.37          84.79
                                   key#4:             0              0           0.00           0.00           0.00             22           2903           0.00           9.75        1058.84
   &(&tcp_hashinfo.bhash[i].lock)->rlock:             0              0           0.00           0.00           0.00            113            186           0.36          12.94         241.19
                   &queue->syn_wait_lock:             0              0           0.00           0.00           0.00             39             76           0.35           3.67          41.39
    &(&h->listening_hash[i].lock)->rlock:             0              0           0.00           0.00           0.00              4              6           0.66           3.69           7.46
                                   mutex:             0              0           0.00           0.00           0.00              1              2        1036.43       38141.73       39178.16
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              2             11           1.03         876.43         944.93
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           1.04           5.00           6.04
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              5           1.78         612.03         848.12
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           1.05           3.92           4.97
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           1.05           3.90           4.95
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           1.05           4.12           5.17
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           1.05           4.23           5.27
                 &type->s_umount_key#2-R:             0              0           0.00           0.00           0.00              1              2           1.12           4.17           5.29
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00              1              2           1.05           4.40           5.45
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00              1              2           1.09           4.24           5.32
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00              1              2           1.05           4.22           5.27
                                   key#4:             0              0           0.00           0.00           0.00              7             25           0.32          11.97          25.47
             &(&rt_hash_locks[i])->rlock:             0              0           0.00           0.00           0.00             22             37           0.35          25.79         119.24
                 &(&list->lock)->rlock#3:             0              0           0.00           0.00           0.00              4              5           0.52          12.00          14.78
                        peer_pool_lock-W:             0              0           0.00           0.00           0.00              0              2           1.07           1.30           2.37
                        peer_pool_lock-R:             0              0           0.00           0.00           0.00              1              3           1.19          13.16          15.63
                            rt_peer_lock:             0              0           0.00           0.00           0.00              1              3           0.45          10.09          11.30
                             usbfs_mutex:             0              0           0.00           0.00           0.00              1             48           0.50          25.51         122.70
                     &(&ps->lock)->rlock:             0              0           0.00           0.00           0.00              0             48           0.31           3.90          19.09
                               &n->timer:             0              0           0.00           0.00           0.00              0              7           2.88          38.61         113.27
             &(&group->mark_lock)->rlock:             0              0           0.00           0.00           0.00              2             83           0.37           5.26          90.83
                    &(&u->lock)->rlock/1:             0              0           0.00           0.00           0.00             17             58           0.25           5.85          45.31
                           log_wait.lock:             0              0           0.00           0.00           0.00              5              9           0.38           7.23          24.73
                      dnotify_mark_mutex:             0              0           0.00           0.00           0.00              1              1          56.14          56.14          56.14
                        &f->f_owner.lock:             0              0           0.00           0.00           0.00              0              1           3.93           3.93           3.93
                 &type->s_umount_key#3/1:             0              0           0.00           0.00           0.00              0              3          19.06          31.86          77.56
                          &sbi->wq_mutex:             0              0           0.00           0.00           0.00              0              2           0.63           8.26           8.89
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00              0              2           0.39           2.84           3.23
                   &type->s_umount_key#3:             0              0           0.00           0.00           0.00              0              1          58.90          58.90          58.90
                              iprune_sem:             0              0           0.00           0.00           0.00              1              2           2.21          25.87          28.08
                    iprune_sem.wait_lock:             0              0           0.00           0.00           0.00              1              4           0.30           4.87           5.79
                    mousedev_table_mutex:             0              0           0.00           0.00           0.00              0              1          43.33          43.33          43.33
        &(&mousedev->client_lock)->rlock:             0              0           0.00           0.00           0.00              1              1           5.56           5.56           5.56
                      &mousedev->mutex#2:             0              0           0.00           0.00           0.00              1              1          41.43          41.43          41.43
          &(&client->packet_lock)->rlock:             0              0           0.00           0.00           0.00              1              7           0.32           4.65           7.17
                                   key#4:             0              0           0.00           0.00           0.00              0              4           0.32           3.80           4.81
                    struct class mutex#1:             0              0           0.00           0.00           0.00              0              1           9.07           9.07           9.07
                     &(&im->lock)->rlock:             0              0           0.00           0.00           0.00              1              6           0.41          38.33          45.38
                   &rcu_bh_state.fqslock:             0              0           0.00           0.00           0.00              0              2           3.68          13.98          17.66
                   inet_peer_unused_lock:             0              0           0.00           0.00           0.00              2              2           0.78          10.27          11.04
                                &ep->mtx:             0              0           0.00           0.00           0.00              0              4           3.59          44.19          56.09
                     &(&ep->lock)->rlock:             0              0           0.00           0.00           0.00              0              7           0.32           3.28           6.46
                       evdev_table_mutex:             0              0           0.00           0.00           0.00              1              2           0.96          12.72          13.68
           &(&evdev->client_lock)->rlock:             0              0           0.00           0.00           0.00              2              2           0.58           5.58           6.15
                  &(&entry->lock)->rlock:             0              0           0.00           0.00           0.00              0             78           1.63          23.59         178.09
                                   key#4:             0              0           0.00           0.00           0.00              2              2           0.52           9.67          10.19
                  acpi_system_event_lock:             0              0           0.00           0.00           0.00              1              1           7.20           7.20           7.20
               acpi_bus_event_queue.lock:             0              0           0.00           0.00           0.00              1              1           5.52           5.52           5.52
   &(&group->inotify_data.idr_lock)->rlo:             0              0           0.00           0.00           0.00              1             76           0.45           4.66          53.42
                  &tty->atomic_read_lock:             0              0           0.00           0.00           0.00              5            103           8.62      446550.14     2400262.82
                &net->ipv6.ip6_fib_timer:             0              0           0.00           0.00           0.00              0              1          62.99          62.99          62.99
                            fib6_gc_lock:             0              0           0.00           0.00           0.00              0              1          36.50          36.50          36.50
                                  &timer:             0              0           0.00           0.00           0.00              0           1125           0.19          11.25        1442.08
     &(&hashinfo->ehash_locks[i])->rlock:             0              0           0.00           0.00           0.00             85            138           0.39          14.90          96.18
                &icsk->icsk_delack_timer:             0              0           0.00           0.00           0.00              0          85268           0.83          46.28      229856.73
                     allocated_ptys_lock:             0              0           0.00           0.00           0.00              0              1          12.04          12.04          12.04
                        sysfs_assoc_lock:             0              0           0.00           0.00           0.00             24           2748           0.00           5.63         849.83
            &icsk->icsk_retransmit_timer:             0              0           0.00           0.00           0.00              0             76           1.11          10.65         152.37
                 &type->s_umount_key#3/1:             0              0           0.00           0.00           0.00              0              1          28.22          28.22          28.22
                      perf_resource_lock:             0              0           0.00           0.00           0.00              0              4           0.00           0.47           0.79
              x86_mce_decoder_chain.lock:             0              0           0.00           0.00           0.00              0             16           0.00           0.00           0.00
                tcp_death_row.death_lock:             0              0           0.00           0.00           0.00             33             45           0.56          21.22          69.56
             net/ipv4/tcp_minisocks.c:40:             0              0           0.00           0.00           0.00              0              9           2.17           9.66          35.29
         &(&(&hh->hh_lock)->lock)->rlock:             0              0           0.00           0.00           0.00              3              3           0.37          10.59          11.37
                         resource_lock-W:             0              0           0.00           0.00           0.00              1            583           0.00           7.52         142.68
                         resource_lock-R:             0              0           0.00           0.00           0.00              0             30           0.00          14.36          77.12
                (&(&expires_work)->work):             0              0           0.00           0.00           0.00              0              1        2563.36        2563.36        2563.36
                 net/ipv6/addrconf.c:134:             0              0           0.00           0.00           0.00              0              1          22.58          22.58          22.58
                        clockevents_lock:             0              0           0.00           0.00           0.00              8             26           0.00          14.89          58.16

--=-ZGSWARzYdHVMBeW6RhT6--

