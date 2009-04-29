Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbZD2Hkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbZD2Hkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZD2Hkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:40:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757137AbZD2Hkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:40:31 -0400
Date: Wed, 29 Apr 2009 00:29:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
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
Subject: Re: Mainline kernel OLTP performance update
Message-Id: <20090429002930.b786348b.akpm@linux-foundation.org>
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 10:08:22 -0700 "Styner, Douglas W" <douglas.w.styner@intel.com> wrote:

> Summary: Measured the mainline kernel from kernel.org (2.6.30-rc3). 
> 
> The regression for 2.6.30-rc3 against the baseline, 2.6.24.2 is 1.91%.  Oprofile reports 71.1626% user, 28.8295% system.  
> 
> Linux OLTP Performance summary
> Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
> 2.6.24.2                1.000   22106   43709   75      24      0       0
> 2.6.30-rc3              0.981   30645   43027   75      25      0       0

The main difference there is the interrupt frequency.  Do we know which
interrupt source(s) caused this?

> Server configurations:
> Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
> 64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)
> 
> 
> ======oprofile CPU_CLK_UNHALTED for top 30 functions
> Cycles% 2.6.24.2                   Cycles% 2.6.30-rc3
> 74.8578 <database>                 69.1925 <database>

ouch, that's a large drop in userspace CPU occupancy.  It seems
inconsistent with the 1.91% above.

> 1.0500 qla24xx_start_scsi          1.1314 qla24xx_intr_handler
> 0.8089 schedule                    1.0031 qla24xx_start_scsi
> 0.5864 kmem_cache_alloc            0.8476 __schedule
> 0.4989 __blockdev_direct_IO        0.6532 kmem_cache_alloc
> 0.4357 __sigsetjmp                 0.4490 __blockdev_direct_IO
> 0.4152 copy_user_generic_string    0.4199 __sigsetjmp
> 0.3953 qla24xx_intr_handler        0.3946 __switch_to
> 0.3850 memcpy                      0.3538 __list_add
> 0.3596 scsi_request_fn             0.3499 task_rq_lock
> 0.3188 __switch_to                 0.3402 scsi_request_fn
> 0.2889 lock_timer_base             0.3382 rb_get_reader_page
> 0.2750 memmove                     0.3363 copy_user_generic_string
> 0.2519 task_rq_lock                0.3324 aio_complete
> 0.2474 aio_complete                0.3110 try_to_wake_up
> 0.2460 scsi_alloc_sgtable          0.2877 ring_buffer_consume
> 0.2445 generic_make_request        0.2683 mod_timer
> 0.2263 qla2x00_process_completed_re0.2605 qla2x00_process_completed_re
> 0.2118 blk_queue_end_tag           0.2566 blk_queue_end_tag
> 0.2085 dio_bio_complete            0.2566 generic_make_request
> 0.2021 e1000_xmit_frame            0.2547 tcp_sendmsg
> 0.2006 __end_that_request_first    0.2372 lock_timer_base
> 0.1954 generic_file_aio_read       0.2333 memmove
> 0.1949 kfree                       0.2294 memset_c
> 0.1915 tcp_sendmsg                 0.2080 mempool_free
> 0.1901 try_to_wake_up              0.2022 generic_file_aio_read
> 0.1895 kref_get                    0.1963 scsi_device_unbusy
> 0.1864 __mod_timer                 0.1963 plist_del
> 0.1863 thread_return               0.1944 dequeue_rt_stack
> 0.1854 math_state_restore          0.1924 e1000_xmit_frame

