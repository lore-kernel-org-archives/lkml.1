Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXHPHkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXHPHkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXHPHjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:39:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55651 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbXHPHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:39:54 -0400
Subject: Re: [BUG -rt] circular locking deadlock
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1187228393.6062.31.camel@localhost.localdomain>
References: <1187228393.6062.31.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 09:39:39 +0200
Message-Id: <1187249979.6114.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 18:39 -0700, john stultz wrote:
> Hey Ingo, Thomas,
> 
> I was playing with the latency tracer on 2.6.23-rc2-rt2 while a "make
> -j8" was going on in the background and the box hung with this on the
> console:

Hmm, this would have been me :-/

I'll go play...

> ============================================
> [ BUG: circular locking deadlock detected! ]
> --------------------------------------------
> cc1/7161 is deadlocking current task cc1/7164
> 
> 
> 1) cc1/7164 is trying to acquire this lock:
>  [ffff8101fa375250] {&list->lock}
> ... ->owner: ffff8101ef7f7162
> ... held by:               cc1: 7161 [ffff8101ef7f7160, 120]
> 
> 2) cc1/7161 is blocked on this lock:
>  [ffff8102118e5900] {&list->lock}
> ... ->owner: ffff8100ddb3ace2
> ... held by:               cc1: 7164 [ffff8100ddb3ace0, 120]
> 
> cc1/7161's [blocked] stackdump:
> 
>  ffff8101f9423c68 0000000000000086 0000000100000000 0000000000000002
>  ffffffff82205d00 0000000000000202 ffffffff82189280 ffff8101ef7f7160
>  ffff8100ddb3ace0 ffff8101f9423c10 0000000000000202 0000000000000000
> Call Trace:
>  [<ffffffff8100c58c>] mcount+0x2c/0x3a
>  [<ffffffff817e6e6b>] schedule+0x3b/0x130
>  [<ffffffff817e7feb>] rt_spin_lock_slowlock+0xdb/0x210
>  [<ffffffff817e8b4d>] __rt_spin_lock+0x3d/0x50
>  [<ffffffff817e8b6e>] rt_spin_lock+0xe/0x10
>  [<ffffffff81297a62>] __lock_list+0x42/0x70
>  [<ffffffff81297b43>] lock_list_splice_init+0x33/0xb0
>  [<ffffffff810bf9d8>] file_move+0xc8/0xd0
>  [<ffffffff810bc99e>] __dentry_open+0xae/0x1d0
>  [<ffffffff810bcb84>] nameidata_to_filp+0x44/0x60
>  [<ffffffff810bcbed>] do_filp_open+0x4d/0x60
>  [<ffffffff817e8ace>] __lock_text_start+0xe/0x10
>  [<ffffffff810bc8a3>] get_unused_fd_flags+0x103/0x130
>  [<ffffffff810bcc61>] do_sys_open+0x61/0x100
>  [<ffffffff810bcd40>] sys_open+0x20/0x30
>  [<ffffffff8100c9a5>] tracesys+0x151/0x1be
> 
> ---------------------------
> | preempt count: 00000002 ]
> | 2-level deep critical section nesting:
> ----------------------------------------
> ... [<ffffffff817e5e33>] .... __schedule+0x23/0x265
> ......[<ffffffff817e6e6b>] ..   ( <= schedule+0x3b/0x130)
> ... [<ffffffff817e9041>] .... __spin_lock_irq+0x21/0x40
> ......[<ffffffff817e5ec4>] ..   ( <= __schedule+0xb4/0x265)
> 
> 
> cc1/7164's [current] stackdump:
> 
> 
> Call Trace:
>  [<ffffffff8100e433>] show_stack+0x13/0x20
>  [<ffffffff8106c643>] debug_rt_mutex_print_deadlock+0x163/0x180
>  [<ffffffff817e7fe6>] rt_spin_lock_slowlock+0xd6/0x210
>  [<ffffffff817e8b4d>] __rt_spin_lock+0x3d/0x50
>  [<ffffffff817e8b6e>] rt_spin_lock+0xe/0x10
>  [<ffffffff81297a62>] __lock_list+0x42/0x70
>  [<ffffffff81297be6>] lock_list_del_init+0x26/0x70
>  [<ffffffff810bf8fa>] file_kill+0x4a/0x60
>  [<ffffffff810bfb8e>] __fput+0x12e/0x1d0
>  [<ffffffff810bfcc5>] fput+0x25/0x30
>  [<ffffffff810bc771>] filp_close+0x61/0x90
>  [<ffffffff810bded9>] sys_close+0xa9/0x100
>  [<ffffffff8100c9a5>] tracesys+0x151/0x1be
> 
> ---------------------------
> | preempt count: 00000000 ]
> | 0-level deep critical section nesting:
> ----------------------------------------
> 
> [ turning off deadlock detection.Please report this trace. ]


