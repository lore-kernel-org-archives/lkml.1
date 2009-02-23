Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZBWAyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZBWAyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZBWAyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:54:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:41871 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZBWAyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LEALdLW08lvVbnrHrqzhy+Qu2YkbscLt1kLzmrlieKKVdvSiT3R3wQ3WixOkiwrAsx
         nxnpBFvI6mJM8w0qrw86kalA7Xd3U8ibEtfQMB9fjOqspXwot7PEnNwOc9GSJjbUtrxJ
         4QXwPi6gFl6fSFiGH1ri8pWmg+1S7u0mk+KyU=
MIME-Version: 1.0
Date: Mon, 23 Feb 2009 00:54:20 +0000
Message-ID: <6278d2220902221654q1ea3a78cl323031f21b05bd72@mail.gmail.com>
Subject: (un)likely profiling....
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A developer's desktop workload (NFS, GCC, UXA+compiz) and
likely/unlikely macro profiling shows some interesting results [1]
(line numbers against 2.6.29-rc5).

It's clear many are false-positives due to other kernel debug
mechanisms, some are due to IS_ERR() macro assumptions being used
along error paths and others are insignificant, but a quick check show
there are a few dubious/potentially mislabeled (~workload dependent?)
ones, eg filemap.c:grab_cache_page_write_begin,
nfs4xdr.c:decode_attr_*, timer.c:timer_stats_account_timer perhaps?

I guess the hot/cold path partitioning costs may have been considered
for important cases, making things less obvious on some too...

Daniel

--- [1]

# sort -nbk3 /sys/kernel/debug/tracing/profile_annotated_branch | tail -n60
 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
 8968248  5267043  36 __switch_to                    process_64.c         561
    1815     1112  37 need_resched                   sched.h              2157
  827587   491835  37 net_rx_action                  dev.c                2741
 8912232  5323142  37 __switch_to                    process_64.c         641
 8968128  5267012  37 __switch_to                    process_64.c         557
  479719   318359  39 tcp_write_xmit                 tcp_output.c         1592
    8830     5844  39 load_balance                   sched.c              3524
 8592950  5973868  41 pick_next_task                 sched.c              4524
164982384 155024719  48 read_seqbegin                  seqlock.h            93
148893156 145236077  49 read_seqbegin                  seqlock.h            93
      36       36  50 compound_head                  mm.h                 289
  746777   760049  50 copy_stack_frame               trace_sysprof.c      45
  245273   257959  51 copy_pte_range                 memory.c             617
   14487    18674  56 unmap_mapping_range            memory.c             2300
  481759   984637  67 tcp_transmit_skb               tcp_output.c         617
   47846   111579  69 syscall_get_error              syscall.h            51
     132      311  70 inotify_find_update_watch      inotify.c            726
  177097   420276  70 grab_cache_page_write_begin    filemap.c            2159
   15541    39878  71 next_pidmap                    pid.c                194
    4606    13746  74 pmd_alloc                      mm.h                 930
      56      164  74 ioremap_pte_range              ioremap.c            22
      11       34  75 grab_swap_token                thrash.c             51
 3506556 10728943  75 __switch_to                    process_64.c         591
      38      127  76 clocksource_adjust             timekeeping.c        453
       2        8  80 usb_alloc_dev                  usb.c                376
 1443919  7833307  84 page_mapping                   mm.h                 647
   69498   456086  86 timer_stats_account_timer      timer.c              381
17420569 128401540  88 __slab_free                    slub.c               1665
     239     2001  89 remap_pte_range                memory.c             1577
   20496   318913  93 fput_light                     file.h               29
   23329   439767  94 queue_delayed_work_on          workqueue.c          252
  415199  7833291  94 mapping_unevictable            pagemap.h            50
     443     6992  94 sys_inotify_add_watch          inotify_user.c       702
     365     7138  95 fput_light                     file.h               29
       1       32  96 __cancel_work_timer            workqueue.c          560
    2054    75222  97 tcp_mss_split_point            tcp_output.c         1122
  192744 88289793  99 debug_mutex_unlock             mutex-debug.c        79
    6345  8060994  99 pick_next_task_rt              sched_rt.c           889
     880  5982195  99 clocksource_adjust             timekeeping.c        459
       0        1 100 hpet_rtc_timer_reinit          hpet.c               1066
       0        1 100 srcu_notifier_chain_register   notifier.c           427
       0     1135 100 rt_mutex_slowlock              rtmutex.c            648
       0      117 100 verify_export_symbols          module.c             1521
       0       12 100 signal_pending                 sched.h              2135
       0 12490918 100 sched_info_queued              sched_stats.h        223
       0 14235223 100 sched_info_switch              sched_stats.h        270
       0 145827757 100 slab_free                      slub.c               1728
       0 145831331 100 __slab_free                    slub.c               1657
       0 146192625 100 slab_alloc                     slub.c               1607
       0 146199943 100 __slab_alloc                   slub.c               1529
       0       15 100 signal_pending                 sched.h              2135
       0   195578 100 __free_slab                    slub.c               1161
       0        2 100 ehci_irq                       ehci-hcd.c           678
       0   213591 100 new_slab                       slub.c               1138
       0    21482 100 sched_move_task                sched.c              8899
       0    21482 100 sched_move_task                sched.c              8909
       0       22 100 blocking_notifier_chain_regist notifier.c           220
       0     3473 100 IS_ERR                         err.h                34
       0   372096 100 decode_attr_fs_locations       nfs4xdr.c            2432
       0   372097 100 decode_attr_mounted_on_fileid  nfs4xdr.c            2320
       0        4 100 clear_page_mlock               internal.h           130
       0        4 100 scan_async                     ehci-q.c             1123
       0     6347 100 pre_schedule_rt                sched_rt.c           1263
       0  9595216 100 sched_info_dequeued            sched_stats.h        178
-- 
Daniel J Blueman
