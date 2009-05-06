Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZEFPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZEFPyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZEFPyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:54:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:14631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZEFPyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:54:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,303,1239001200"; 
   d="scan'208";a="513044969"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Date: Wed, 6 May 2009 09:53:58 -0600
Subject: RE: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnM0E+Nwe+14GGkR56q7IVjkGSrWwBQ8EPlABOLQUA=
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F1247AB7A80EC@rrsmsx505.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345BCC195@azsmsx501.amr.corp.intel.com>
 <C6267C73.F240%anirban.chakraborty@qlogic.com>
In-Reply-To: <C6267C73.F240%anirban.chakraborty@qlogic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n46FsVqu017852

I'm not sure that Orion is going to give useful results in your hardware setup.  I suspect you don't have enough spindles to get the IO rates that are required to see the problem.  How about doing lots of contiguous I/O instead?  Something as simple as:

for i in sda sdb sdc (repeat ad nauseam); do \
	dd if=/dev/$i of=/dev/null bs=4k iflag=direct & \
done

might be enough to get I/O rates high enough to see problems in the interrupt handler.

> -----Original Message-----
> From: Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com]
> Sent: Tuesday, May 05, 2009 11:30 PM
> To: Styner, Douglas W; linux-kernel@vger.kernel.org
> Cc: Tripathi, Sharad C; arjan@linux.intel.com; Wilcox, Matthew R; Kleen,
> Andi; Siddha, Suresh B; Ma, Chinang; Wang, Peter Xihong; Nueckel, Hubert;
> Recalde, Luis F; Nelson, Doug; Cheng, Wu-sun; Prickett, Terry O;
> Shunmuganathan, Rajalakshmi; Garg, Anil K; Chilukuri, Harita;
> chris.mason@oracle.com
> Subject: Re: Mainline kernel OLTP performance update
> 
> 
> 
> 
> On 5/4/09 8:54 AM, "Styner, Douglas W" <douglas.w.styner@intel.com> wrote:
> 
> > <this time with subject line>
> > Summary: Measured the mainline kernel from kernel.org (2.6.30-rc4).
> >
> > The regression for 2.6.30-rc4 against the baseline, 2.6.24.2 is 2.15%
> > (2.6.30-rc3 regression was 1.91%).  Oprofile reports 70.1204% user,
> 29.874%
> > system.
> >
> > Linux OLTP Performance summary
> > Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%
> > iowait%
> > 2.6.24.2                1.000   22106   43709   75      24      0
> 0
> > 2.6.30-rc4              0.978   30581   43034   75      25      0
> 0
> >
> > Server configurations:
> > Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
> > 64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)
> >
> >
> > ======oprofile CPU_CLK_UNHALTED for top 30 functions
> > Cycles% 2.6.24.2                   Cycles% 2.6.30-rc4
> > 74.8578 <database>                 67.8732 <database>
> > 1.0500 qla24xx_start_scsi          1.1162 qla24xx_start_scsi
> > 0.8089 schedule                    0.9888 qla24xx_intr_handler
> > 0.5864 kmem_cache_alloc            0.8776 __schedule
> > 0.4989 __blockdev_direct_IO        0.7401 kmem_cache_alloc
> > 0.4357 __sigsetjmp                 0.4914 read_hpet
> > 0.4152 copy_user_generic_string    0.4792 __sigsetjmp
> > 0.3953 qla24xx_intr_handler        0.4368 __blockdev_direct_IO
> > 0.3850 memcpy                      0.3822 task_rq_lock
> > 0.3596 scsi_request_fn             0.3781 __switch_to
> > 0.3188 __switch_to                 0.3620 __list_add
> > 0.2889 lock_timer_base             0.3377 rb_get_reader_page
> > 0.2750 memmove                     0.3336 copy_user_generic_string
> > 0.2519 task_rq_lock                0.3195 try_to_wake_up
> > 0.2474 aio_complete                0.3114 scsi_request_fn
> > 0.2460 scsi_alloc_sgtable          0.3114 ring_buffer_consume
> > 0.2445 generic_make_request        0.2932 aio_complete
> > 0.2263 qla2x00_process_completed_re0.2730 lock_timer_base
> > 0.2118 blk_queue_end_tag           0.2588 memset_c
> > 0.2085 dio_bio_complete            0.2588 mod_timer
> > 0.2021 e1000_xmit_frame            0.2447 generic_make_request
> > 0.2006 __end_that_request_first    0.2426 qla2x00_process_completed_re
> > 0.1954 generic_file_aio_read       0.2265 tcp_sendmsg
> > 0.1949 kfree                       0.2184 memmove
> > 0.1915 tcp_sendmsg                 0.2184 kfree
> > 0.1901 try_to_wake_up              0.2103 scsi_device_unbusy
> > 0.1895 kref_get                    0.2083 mempool_free
> > 0.1864 __mod_timer                 0.1961 blk_queue_end_tag
> > 0.1863 thread_return               0.1941 kmem_cache_free
> > 0.1854 math_state_restore          0.1921 kref_get
> 
> I tried to replicate the scenario. I have used Orion (a database load
> generator from Oracle) with following settings. The results do not show
> significant difference in cycles.
> 
> Setup:
> Xeon Quad core (7350), 4 sockets with 16GB memory, 1 qle2462 directly
> connected to SanBlaze target with 255 luns.
> 
> ORION VERSION 11.1.0.7.0
> -run advanced -testname test -num_disks 255 -num_streamIO 16 -write 100
> -type seq -matrix point -size_large 1 -num_small 0 -num_large 16 -simulate
> raid0 -cache_size 0
> 
> CPU: Core 2, speed 2933.45 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit
> mask of 0x00 (Unhalted core cycles) count 80000
> Counted L2_RQSTS events (number of L2 cache requests) with a unit mask of
> 0x41 (multiple flags) count 6000
> 
> 2.6.30-rc4                      2.6.24.7
> 12.4062 tg_shares_up         11.4415 tg_shares_up
> 6.6774 cache_free_debugcheck  6.3950 check_poison_obj
> 5.2861 kernel_text_address    6.1896 pick_next_task_fair
> 4.2201 kernel_map_pages       4.4998 mwait_idle
> 3.9626 __module_address       3.1111 dequeue_entity
> 3.7923 _raw_spin_lock         2.8842 mwait_idle
> 3.1965  kmem_cache_free       2.2679 find_busiest_group
> 3.1494 __module_text_address  1.7949 _raw_spin_lock
> 2.5449 find_busiest_group     1.7488 qla24xx_start_scsi
> 2.4670 mwait_idle             1.5948 find_next_bit
> 2.2321 qla24xx_start_scsi     1.5433 memset_c
> 2.1065 kernel_map_pages       1.5265 find_busiest_group
> 1.9261 is_module_text_address 1.4750 compat_blkdev_ioctl
> 1.5905 _raw_spin_lock         1.1865 _raw_spin_lock
> 1.5206 find_next_bit          1.0938 qla24xx_intr_handler
> 1.2963  cache_alloc_debugcheck_after 0.9805 cache_free_debugcheck
> 1.2785 memset.c               0.9306 kernel_map_pages
> 0.9918 __aio_put_req          0.9104 kmem_cache_free
> 0.9916 check_poison_obj       0.9085 __setscheduler
> 0.9413 qla24xx_intr_handler   0.8982 sched_rt_handler
> 0.9081 kmem_cache_alloc       0.8847 kernel_text_address
> 0.7647 cache_flusharray       0.8634 run_rebalance_domains
> 0.7213 trace_hardirqs_off     0.8041 _raw_spin_lock
> 0.6836 __change_page_attr_set_clr 0.7301 cache_alloc_debugcheck_after
> 0.6450 aio_complete           0.6905 __module_address
> 0.6365 qla2x00_process_completed_request 0.6630 kmem_cache_alloc
> 0.6330 delay_tsc              0.6240 memset_c
> 0.6248 blk_queue_end_tag      0.5501 rwbase_run_test
> 0.5568 delay_tsc              0.5146 __module_text_address
> 0.5279 trace_hardirqs_off     0.5064 apic_timer_interrupt
> 0.5215 scsi_softirq_done      0.4919 cache_free_debugcheck
> 
> However, I do notice that profiling report generated is not consistent all
> the time. Not sure, if I am missing something in my setup. Sometimes, I do
> see following type of error messages popping up while running opreport.
> warning: [vdso] (tgid:30873 range:0x7fff6a9fe000-0x7fff6a9ff000) could not
> be found.
> 
> I was wondering if your kernel config is quite different from mine. I have
> attached my kernel config file.
> 
> Thanks,
> Anirban
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
