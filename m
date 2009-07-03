Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZGCJn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZGCJn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZGCJnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:43:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZGCJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:43:19 -0400
Date: Fri, 3 Jul 2009 11:43:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kmemtrace: print binary output only if 'bin' option
	is set
Message-ID: <20090703094301.GL3902@elte.hu>
References: <4A4DD0A0.5060500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4DD0A0.5060500@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Currently by default the output of kmemtrace is binary format 
> instead of human-readable output.
> 
> This patch makes the following changes:
>   - We'll see human-readable output by default
>   - We'll see binary output if 'bin' option is set
> 
> Note: you may probably need to explicitly disable context-info binary
>       output:
> 
> 	# echo 0 > options/context-info
> 	# echo 1 > options/bin
> 	# cat trace_pipe
> 
> v2:
> - use %pF to print call_site
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  kernel/trace/kmemtrace.c |  120 ++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 90 insertions(+), 30 deletions(-)

Applied to tip:tracing/core (for .32), thanks guys!

Btw., any progress on turning kmemtrace into a 'perf kmemtrace' kind 
of tool? It would be really cool: mixing it with PMU events would 
enhance it to a large degree and there's various good output modes 
implemented in tools/perf/ that would make analysis rather 
expressive and flexible.

For that we'd have to extend PERF_TYPE_TRACEPOINT to do samples as 
well. See kernel/perf_counter.c, include/linux/perf_counter.h, etc.

For example, using call-graphs one can get output like the one 
attached below. (it shows the SLAB profile details from a hackbench 
run, a graph form.)

	Ingo

#
# (39812 samples)
#
# Overhead  Symbol
# ........  ......
#
    23.58%  [k] _spin_lock
                |          
                |--9.77%-- get_partial_node
                |          |          
                |          |--8.76%-- __slab_alloc
                |          |          |          
                |          |          |--5.22%-- kmem_cache_alloc_node
                |          |          |          __alloc_skb
                |          |          |          sock_alloc_send_pskb
                |          |          |          __sk_free
                |          |          |          unix_stream_sendmsg
                |          |          |          __sock_recvmsg
                |          |          |          sock_aio_read
                |          |          |          do_sync_write
                |          |          |          vfs_write
                |          |          |          sys_write
                |          |          |          sysenter_dispatch
                |          |          |          0xf7f07430
                |          |          |          0xffe8255000000014
                |          |          |          
                |          |           --3.54%-- __kmalloc_node_track_caller
                |          |                     __alloc_skb
                |          |                     sock_alloc_send_pskb
                |          |                     __sk_free
                |          |                     unix_stream_sendmsg
                |          |                     __sock_recvmsg
                |          |                     sock_aio_read
                |          |                     do_sync_write
                |          |                     vfs_write
                |          |                     sys_write
                |          |                     sysenter_dispatch
                |          |                     0xf7f07430
                |          |                     0xffe8255000000014
                |          |          
                |           --1.00%-- get_any_partial
                |                     __slab_alloc
                |                     |          
                |                     |--0.56%-- kmem_cache_alloc_node
                |                     |          __alloc_skb
                |                     |          sock_alloc_send_pskb
                |                     |          __sk_free
                |                     |          unix_stream_sendmsg
                |                     |          __sock_recvmsg
                |                     |          sock_aio_read
                |                     |          do_sync_write
                |                     |          vfs_write
                |                     |          sys_write
                |                     |          sysenter_dispatch
                |                     |          0xf7f07430
                |                     |          0xffe8255000000014
                |                     |          
                |                      --0.44%-- __kmalloc_node_track_caller
                |                                __alloc_skb
                |                                sock_alloc_send_pskb
                |                                __sk_free
                |                                unix_stream_sendmsg
                |                                __sock_recvmsg
                |                                sock_aio_read
                |                                do_sync_write
                |                                vfs_write
                |                                sys_write
                |                                sysenter_dispatch
                |                                0xf7f07430
                |                                0xffe8255000000014
                |          
                |--9.51%-- add_partial
                |          __slab_free
                |          |          
                |          |--5.60%-- kmem_cache_free
                |          |          |          
                |          |          |--5.60%-- skb_tstamp_tx
                |          |          |          skb_tstamp_tx
                |          |          |          unix_stream_recvmsg
                |          |          |          sock_aio_read
                |          |          |          sys_getsockopt
                |          |          |          do_sync_read
                |          |          |          vfs_read
                |          |          |          sys_read
                |          |          |          sysenter_dispatch
                |          |          |          0xf7f07430
                |          |          |          0x9000007d0
                |          |          |          
                |          |           --0.00%-- __d_free
                |          |                     d_free
                |          |                     d_kill
                |          |                     dput
                |          |                     __fput
                |          |                     fput
                |          |                     filp_close
                |          |                     put_files_struct
                |          |                     exit_files
                |          |                     do_exit
                |          |                     do_group_exit
                |          |                     sys_exit_group
                |          |                     sysenter_dispatch
                |          |          
                |           --3.91%-- kfree
                |                     |          
                |                     |--3.91%-- pskb_expand_head
                |                     |          __pskb_pull_tail
                |                     |          kfree_skb
                |                     |          skb_tstamp_tx
                |                     |          unix_stream_recvmsg
                |                     |          sock_aio_read
                |                     |          sys_getsockopt
                |                     |          do_sync_read
                |                     |          vfs_read
                |                     |          sys_read
                |                     |          sysenter_dispatch
                |                     |          0xf7f07430
                |                     |          0x9000007d0
                |                     |          
                |                      --0.00%-- free_counter_rcu
                |                                __rcu_process_callbacks
                |                                rcu_process_callbacks
                |                                __do_softirq
                |                                call_softirq
                |                                do_softirq
                |                                irq_exit
                |                                smp_apic_timer_interrupt
                |                                apic_timer_interrupt
                |                                0xf7f07430
                |                                0x9000007d0
                |          
                |--2.04%-- unix_stream_sendmsg
                |          __sock_recvmsg
                |          sock_aio_read
                |          do_sync_write
                |          vfs_write
                |          sys_write
                |          sysenter_dispatch
                |          0xf7f07430
                |          |          
                |          |--2.03%-- 0xffe8255000000014
                |          |          
                |           --0.01%-- 0x700000006
                |          
                |--1.26%-- task_rq_lock
                |          try_to_wake_up
                |          default_wake_function
                |          |          
                |          |--1.26%-- autoremove_wake_function
                |          |          __wake_up_common
                |          |          __wake_up_sync_key
                |          |          |          
[...]
