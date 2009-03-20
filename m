Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZCTNIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZCTNIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZCTNH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:07:59 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:38957 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZCTNH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:07:58 -0400
Date: Fri, 20 Mar 2009 14:07:53 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       "lkml," <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockdep: fix deadlock in lockdep_trace_alloc
Message-ID: <20090320140753.307a3c7d@osiris.boeblingen.de.ibm.com>
In-Reply-To: <1237544798.24626.54.camel@twins>
References: <1237544000.24626.52.camel@twins>
	<1237544798.24626.54.camel@twins>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 11:26:38 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Heiko pointed out that checking for irqs_disabled() after we disable
> them is quite pointless..
> 
> New patch below.
> 
> ---
> Subject: lockdep: fix deadlock in lockdep_trace_alloc
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Mar 20 11:24:21 CET 2009
> 
> Heiko reported that we grab the graph lock with irqs enabled.
> 
> Fix this by providing the same wrapper as all other lockdep entry
> functions have.
> 
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/lockdep.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -2258,7 +2258,7 @@ void trace_softirqs_off(unsigned long ip
>  		debug_atomic_inc(&redundant_softirqs_off);
>  }
> 
> -void lockdep_trace_alloc(gfp_t gfp_mask)
> +static void __lockdep_trace_alloc(gfp_t gfp_mask)
>  {
>  	struct task_struct *curr = current;
> 
> @@ -2277,10 +2277,27 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
>  	if (!(gfp_mask & __GFP_FS))
>  		return;
> 
> +	mark_held_locks(curr, RECLAIM_FS);
> +}
> +
> +static void check_flags(unsigned long flags);
> +
> +void lockdep_trace_alloc(gfp_t gfp_mask)
> +{
> +	unsigned long flags;
> +
> +	if (unlikely(current->lockdep_recursion))
> +		return;
> +
>  	if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
>  		return;
> 
> -	mark_held_locks(curr, RECLAIM_FS);
> +	raw_local_irq_save(flags);
> +	check_flags(flags);
> +	current->lockdep_recursion = 1;
> +	__lockdep_trace_alloc(gfp_mask);
> +	current->lockdep_recursion = 0;
> +	raw_local_irq_restore(flags);

Hmm... still not working:

------------[ cut here ]------------
Badness at kernel/lockdep.c:2292
Modules linked in:
CPU: 0 Not tainted 2.6.29-rc8-next-20090320-dirty #19
Process swapper (pid: 0, task: 000000000061ddf0, ksp: 0000000000678000)
Krnl PSW : 0400000180000000 000000000007c784 (lockdep_trace_alloc+0xc0/0xf8)
           R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:0 CC:0 PM:0 EA:3
Krnl GPRS: 0000000000000003 0000000000fe0f18 0000000000000000 000000000000000f
           0000000000667800 0000000000000000 0000000000000000 0000000000000000
           000000003fe09f00 0000000000000020 000000003fe0fc00 0000000000677910
           0000000000000020 0000000000432538 000000000007c76c 0000000000677910
Krnl Code: 000000000007c778: bf2f1000           icm     %rr2,15,0(%rr1)
           000000000007c77c: a774ffe8           brc     7,7c74c
           000000000007c780: a7f40001           brc     15,7c782
          >000000000007c784: a7f4ffe4           brc     15,7c74c
           000000000007c788: a7c10010           tmll    %rr12,16
           000000000007c78c: a784ffd4           brc     8,7c734
           000000000007c790: e32002e00004       lg      %rr2,736
           000000000007c796: 91082016           tm      22(%rr2),8
Call Trace:
([<0000000000677928>] init_thread_union+0x3928/0x4000)
 [<00000000000aaa48>] __alloc_pages_internal+0x354/0x570
 [<00000000000db184>] cache_alloc_refill+0x41c/0x7ac
 [<00000000000db7fa>] kmem_cache_alloc+0x11a/0x150
 [<00000000001fae3e>] idr_pre_get+0x92/0xcc
 [<00000000001faeac>] ida_pre_get+0x34/0xb4
 [<00000000000e399a>] set_anon_super+0x3e/0x108
 [<00000000000e46a8>] sget+0x3a4/0x47c
 [<00000000000e4fe8>] get_sb_single+0x48/0xec
 [<0000000000151d4c>] sysfs_get_sb+0x30/0x44
 [<00000000000e3764>] vfs_kern_mount+0x68/0xfc
 [<00000000000e382c>] kern_mount_data+0x34/0x44
 [<000000000068be74>] sysfs_init+0xb4/0xf4
 [<000000000068aa82>] mnt_init+0xbe/0x264
 [<000000000068a0f0>] vfs_caches_init+0xec/0x1a4
 [<0000000000678dd4>] start_kernel+0x4dc/0x6dc
 [<0000000000012020>] _ehead+0x20/0x80
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<000000000007c780>] lockdep_trace_alloc+0xbc/0xf8
