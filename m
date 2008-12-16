Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYLPUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYLPUL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYLPULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:11:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:12540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYLPULr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:11:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,232,1228118400"; 
   d="scan'208";a="650310698"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       Chris Mason <chris.mason@oracle.com>
Date: Tue, 16 Dec 2008 13:11:41 -0700
Subject: Linix mainline kernel OLTP performance 
Thread-Topic: Linix mainline kernel OLTP performance 
Thread-Index: AclfuoJWp/4yNfY2SJKRURWy+zPw1w==
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E80030A8B51A0@azsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an Online Transaction Processing workload performance report for 2.6 mainline kernels. We are sharing this data and hoping someone has idea of resolving the performance regression we found in 2.6.28-rc8.

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)

- All DBMS processes were set to SCHED_RR for higher throughput. Data writer and log writer have higher priority than the rest of DBMS processes.
- We found 2.7% OLTP performance regression going from 2.6.24.2 to 2.6.27.2 - My understanding is part of this regression came from the 2.6.25 rt scheduler changes for reducing rt-task scheduling latency. Adding partition i/o stats in the block layer also increased regression.
- There is 1% additional regression going from 2.6.27.2 to 2.6.28-rc8 which we don't know the cause.

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%    sys%   idle%  iowait%
------------------ ---------  -------- ------- ------ -----   -----  -----
2.6.24.2                1.000   21969   43425   76      24      0       0
2.6.27.2                0.973   30402   43523   74      25      0       1
2.6.28-rc8              0.966   30429   42608   74      25      0       0


======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.24.2                   Cycles% 2.6.27.2
------ --------------------------- ------ ---------------------------
1.0500 qla24xx_start_scsi          1.2125 qla24xx_start_scsi
0.8089 schedule                    0.6962 kmem_cache_alloc
0.5864 kmem_cache_alloc            0.6209 qla24xx_intr_handler
0.4989 __blockdev_direct_IO        0.4895 copy_user_generic_string
0.4152 copy_user_generic_string    0.4591 __blockdev_direct_IO
0.3953 qla24xx_intr_handler        0.4409 __end_that_request_first
0.3596 scsi_request_fn             0.3729 __switch_to
0.3188 __switch_to                 0.3716 try_to_wake_up
0.2889 lock_timer_base             0.3531 lock_timer_base
0.2519 task_rq_lock                0.3393 scsi_request_fn
0.2474 aio_complete                0.3038 aio_complete
0.2460 scsi_alloc_sgtable          0.2989 memset_c
0.2445 generic_make_request        0.2633 qla2x00_process_completed_re
0.2263 qla2x00_process_completed_re0.2583 pick_next_highest_task_rt
0.2118 blk_queue_end_tag           0.2578 generic_make_request
0.2085 dio_bio_complete            0.2510 __list_add
0.2021 e1000_xmit_frame            0.2459 task_rq_lock
0.2006 __end_that_request_first    0.2322 kmem_cache_free
0.1954 generic_file_aio_read       0.2206 blk_queue_end_tag
0.1949 kfree                       0.2205 __mod_timer
0.1915 tcp_sendmsg                 0.2179 update_curr_rt
0.1901 try_to_wake_up              0.2164 sd_prep_fn
0.1895 kref_get                    0.2130 kref_get
0.1864 __mod_timer                 0.2075 dio_bio_complete
0.1863 thread_return               0.2066 push_rt_task
0.1854 math_state_restore          0.1974 qla24xx_msix_default
0.1775 __list_add                  0.1935 generic_file_aio_read
0.1721 memset_c                    0.1870 scsi_device_unbusy
0.1706 find_vma                    0.1861 tcp_sendmsg
0.1688 read_tsc                    0.1843 e1000_xmit_frame


======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.27.2                   Cycles% 2.6.28-rc8
------ --------------------------- ------ ---------------------------
1.2125 qla24xx_start_scsi          1.5025 qla24xx_start_scsi
0.6962 kmem_cache_alloc            0.9586 kmem_cache_alloc
0.6209 qla24xx_intr_handler        0.8605 qla24xx_intr_handler
0.4895 copy_user_generic_string    0.6159 copy_user_generic_string
0.4591 __blockdev_direct_IO        0.5020 scsi_request_fn
0.4409 __end_that_request_first    0.4833 try_to_wake_up
0.3729 __switch_to                 0.4820 __blockdev_direct_IO
0.3716 try_to_wake_up              0.4060 aio_complete
0.3531 lock_timer_base             0.4024 __end_that_request_first
0.3393 scsi_request_fn             0.3566 memset_c
0.3038 aio_complete                0.3407 qla2x00_process_completed_re
0.2989 memset_c                    0.3371 __switch_to
0.2633 qla2x00_process_completed_re0.3240 __list_add
0.2583 pick_next_highest_task_rt   0.3196 blk_queue_end_tag
0.2578 generic_make_request        0.2980 task_rq_lock
0.2510 __list_add                  0.2911 generic_make_request
0.2459 task_rq_lock                0.2880 kmem_cache_free
0.2322 kmem_cache_free             0.2870 lock_timer_base
0.2206 blk_queue_end_tag           0.2780 scsi_device_unbusy
0.2205 __mod_timer                 0.2626 qla24xx_msix_default
0.2179 update_curr_rt              0.2559 disk_map_sector_rcu
0.2164 sd_prep_fn                  0.2513 scsi_dispatch_cmd
0.2130 kref_get                    0.2451 push_rt_task
0.2075 dio_bio_complete            0.2377 __aio_get_req
0.2066 push_rt_task                0.2338 kref_get
0.1974 qla24xx_msix_default        0.2333 __mod_timer
0.1935 generic_file_aio_read       0.2328 scsi_softirq_done
0.1870 scsi_device_unbusy          0.2264 e1000_irq_enable
0.1861 tcp_sendmsg                 0.2258 dio_bio_complete
0.1843 e1000_xmit_frame            0.2246 pick_next_highest_task_rt
