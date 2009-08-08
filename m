Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbZHHMaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbZHHMaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934062AbZHHMaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:30:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934061AbZHHMaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:30:19 -0400
Date: Sat, 8 Aug 2009 14:29:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf tools: callchain: Fix sum of
	percentages to be 100% by displaying amount of ignored chains in
	fractal mode
Message-ID: <20090808122923.GA20064@elte.hu>
References: <1249690585-9145-4-git-send-email-fweisbec@gmail.com> <tip-84fce09c6b21ef675de079a724c13a205c89520b@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-84fce09c6b21ef675de079a724c13a205c89520b@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Commit-ID:  84fce09c6b21ef675de079a724c13a205c89520b
> Gitweb:     http://git.kernel.org/tip/84fce09c6b21ef675de079a724c13a205c89520b
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Sat, 8 Aug 2009 02:16:25 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 8 Aug 2009 13:49:21 +0200
> 
> perf tools: callchain: Fix sum of percentages to be 100% by displaying amount of ignored chains in fractal mode
> 
> When we filter the callchains below a given percentage, we
> ignore them and the end result only shows entries that have an
> upper percentage than the filter threshold.
> 
> It seems to users then that we have an imbalance in the
> percentage, as if the sum inside a profiled branch doesn't
> reach 100%.
> 
> Since in the past there have been real perf report bugs that
> showed the same sypmtom, it would be nice to assure the user
> that the data is perfect and trustable and it all sums up to
> 100.00%.
> 
> So fix this by displaying the remaining hits that have been
> filtered but without more detail than their amount in each
> branches. Example while filtering below 50%:
> 
> 7.73%  [k] delay_tsc
>                 |
>                 |--98.22%-- __const_udelay
>                 |          |
>                 |          |--86.37%-- ath5k_hw_register_timeout
>                 |          |          ath5k_hw_noise_floor_calibration
>                 |          |          ath5k_hw_reset
>                 |          |          ath5k_reset
>                 |          |          ath5k_config
>                 |          |          ieee80211_hw_config
>                 |          |          |
>                 |          |          |--88.53%-- ieee80211_scan_work
>                 |          |          |          worker_thread
>                 |          |          |          kthread
>                 |          |          |          child_rip
>                 |          |           --11.47%-- [...]
>                 |           --13.63%-- [...]
>                  --1.78%-- [...]

i dont seem to be able to get the bracketed numbers. I only get:

  titan:~> perf record -f -g -a ./hackbench 10
  titan:~> perf report -g fractal,10.0

# Samples: 26832
#
# Overhead         Command             Shared Object  Symbol
# ........  ..............  ........................  ......
#
     8.69%       hackbench  [kernel]                  [k] copy_user_generic_string

     6.84%       hackbench  [kernel]                  [k] unix_stream_recvmsg

     6.07%       hackbench  [kernel]                  [k] sock_alloc_send_pskb

     4.33%       hackbench  [kernel]                  [k] _spin_lock

     3.77%       hackbench  [kernel]                  [k] __kmalloc_node_track_caller

     3.74%       hackbench  [kernel]                  [k] __alloc_skb
                |          
                |--80.00%-- sock_alloc_send_pskb
                |          sock_alloc_send_skb
                |          unix_stream_sendmsg
                |          __sock_sendmsg
                |          sock_aio_write
                |          do_sync_write
                |          vfs_write
                |          sys_write
                |          sysenter_dispatch
                |          0xf7ffa430
                |          0xffadeb0000000014
                |          
                 --20.00%-- sock_alloc_send_skb
                           unix_stream_sendmsg
                           __sock_sendmsg
                           sock_aio_write
                           do_sync_write
                           vfs_write
                           sys_write
                           sysenter_dispatch
                           0xf7ffa430
                           0xffadeb0000000014

     3.53%       hackbench  [kernel]                  [k] ia32_sysenter_target

     2.92%       hackbench  [vdso]                    [.] 0x000000f7ffa430
                |          
                |--66.67%-- 0xf7ffa430
                |          0xffadeb0000000014
                |          
                 --33.33%-- 0xf7ffa431
                           0xffadeb0000000014

     2.56%       hackbench  [kernel]                  [k] virt_to_head_page

     2.37%       hackbench  [kernel]                  [k] kmem_cache_alloc_node

     2.33%       hackbench  [kernel]                  [k] _spin_lock_irqsave
                |          
                |--78.57%-- remove_wait_queue
                |          poll_freewait
                |          do_sys_poll
                |          sys_poll
                |          sysenter_dispatch
                |          0xf7ffa430
                |          0x1ffadea3c
                |          
                |--7.14%-- __up_read
                |          up_read
                |          do_page_fault
                |          page_fault
                |          0xf7ffa430
                |          0xa0df710000000a
                |          
                |--7.14%-- unix_stream_sendmsg
                |          __sock_sendmsg
                |          sock_aio_write
                |          do_sync_write
                |          vfs_write
                |          sys_write
                |          sysenter_dispatch
                |          0xf7ffa430
                |          0xffadeb0000000014
                |          
                 --7.14%-- skb_queue_tail
                           unix_stream_sendmsg
                           __sock_sendmsg
                           sock_aio_write
                           do_sync_write
                           vfs_write
                           sys_write
                           sysenter_dispatch
                           0xf7ffa430
                           0xffadeb0000000014


I dont see the brackets anymore, nor does the 10% limit seem to have 
been listened to for the 7.14% result above, right?

	Ingo
