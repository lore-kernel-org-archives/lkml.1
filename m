Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbXEVGhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbXEVGhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbXEVGhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:37:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756392AbXEVGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:37:42 -0400
Date: Mon, 21 May 2007 23:32:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Stable Team <stable@kernel.org>,
       Anant Nitya <kernel@prachanda.info>
Subject: Re: [PATCH] Prevent going idle with softirq pending
Message-Id: <20070521233214.42ba9f12.akpm@linux-foundation.org>
In-Reply-To: <1179783264.12708.70.camel@chaos>
References: <1179783264.12708.70.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 23:34:24 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> The NOHZ patch contains a check for softirqs pending when a CPU goes
> idle. The BUG is unrelated to NOHZ, it just was made visible by the NOHZ
> patch. The BUG showed up mainly on P4 / hyperthreading enabled machines
> which lead the investigations into the wrong direction in the first
> place. The real cause is in cond_resched_softirq():
> 
> cond_resched_softirq() is enabling softirqs without invoking the softirq
> daemon when softirqs are pending. This leads to the warning message in
> the NOHZ idle code:
> 
> t1 runs softirq disabled code on CPU#0
> interrupt happens, softirq is raised, but deferred (softirqs disabled)
> t1 calls cond_resched_softirq()
> 	enables softirqs via _local_bh_enable()
> 	calls schedule()
> t2 runs
> t1 is migrated to CPU#1
> t2 is done and invokes idle()
> NOHZ detects the pending softirq
> 
> Fix: change _local_bh_enable() to local_bh_enable() so the softirq
> daemon is invoked.
> 
> Thanks to Anant Nitya for debugging this with great patience !
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4776,7 +4776,7 @@ int __sched cond_resched_softirq(void)
>  
>  	if (need_resched() && system_state == SYSTEM_RUNNING) {
>  		raw_local_irq_disable();
> -		_local_bh_enable();
> +		local_bh_enable();
>  		raw_local_irq_enable();
>  		__cond_resched();
>  		local_bh_disable();
> 

[  550.280860] BUG: at kernel/softirq.c:138 local_bh_enable()
[  550.281019]  [<c011d565>] local_bh_enable+0x3c/0x79
[  550.281153]  [<c02df6fa>] cond_resched_softirq+0x2d/0x43
[  550.281291]  [<c0286920>] release_sock+0x38/0x74
[  550.281414]  [<c02aefbf>] tcp_sendmsg+0x8e4/0x9d2
[  550.281565]  [<c02c5dc4>] inet_sendmsg+0x3b/0x45
[  550.281692]  [<c0285089>] sock_sendmsg+0xcf/0xea
[  550.281826]  [<c01272d1>] autoremove_wake_function+0x0/0x35
[  550.281974]  [<c0299c0a>] __qdisc_run+0x9a/0x12b
[  550.282095]  [<c028fc91>] dev_queue_xmit+0x1e7/0x206
[  550.282225]  [<c02a9d7c>] ip_output+0x23b/0x277
[  550.282341]  [<f8d029fa>] __nf_ct_refresh_acct+0xcf/0x102 [nf_conntrack]
[  550.282528]  [<f8d05fff>] tcp_packet+0x9c7/0x9f0 [nf_conntrack]
[  550.282693]  [<f8d36d70>] xdr_skb_read_bits+0x21/0x35 [sunrpc]
[  550.282872]  [<f8d36bee>] xdr_partial_copy_from_skb+0x12a/0x172 [sunrpc]
[  550.283067]  [<c0285f45>] kernel_sendmsg+0x27/0x35
[  550.283192]  [<f8d371d2>] xs_send_kvec+0x98/0xa0 [sunrpc]
[  550.283376]  [<f8d3724f>] xs_sendpages+0x75/0x1b4 [sunrpc]
[  550.283554]  [<f8d3747d>] xs_tcp_send_request+0x5a/0x11c [sunrpc]
[  550.283739]  [<f8d365ca>] xprt_transmit+0xc2/0x1a4 [sunrpc]
[  550.283901]  [<f8d39b63>] rpcauth_wrap_req+0x6c/0x74 [sunrpc]
[  550.284070]  [<f8d39c08>] rpcauth_marshcred+0x4b/0x52 [sunrpc]
[  550.284239]  [<f8d3682d>] xprt_prepare_transmit+0x6a/0x73 [sunrpc]
[  550.284423]  [<f8e16215>] nfs3_xdr_readargs+0x0/0x88 [nfs]
[  550.284595]  [<f8d34442>] call_transmit+0x1c0/0x1f3 [sunrpc]
[  550.284766]  [<f8d34171>] call_reserve+0x3c/0x65 [sunrpc]
[  550.284933]  [<f8d3920d>] __rpc_execute+0x6f/0x1fc [sunrpc]
[  550.285095]  [<c01202bf>] sigprocmask+0x86/0x8d
[  550.285222]  [<f8e10876>] nfs_execute_read+0x30/0x3f [nfs]
[  550.285396]  [<f8e109f4>] nfs_pagein_one+0x9d/0xda [nfs]
[  550.285563]  [<f8e0eba8>] nfs_pageio_doio+0x2c/0x52 [nfs]
[  550.285731]  [<f8e0ec70>] nfs_pageio_add_request+0xa2/0xb3 [nfs]
[  550.285912]  [<f8e10d2d>] readpage_async_filler+0x102/0x11f [nfs]
[  550.286102]  [<f8e10c2b>] readpage_async_filler+0x0/0x11f [nfs]
[  550.286274]  [<c01468ff>] read_cache_pages+0x72/0xd4
[  550.286426]  [<f8e10e56>] nfs_readpages+0x10c/0x14d [nfs]
[  550.286595]  [<c02a86b8>] ip_finish_output+0x0/0x1e7
[  550.286727]  [<f8e10957>] nfs_pagein_one+0x0/0xda [nfs]
[  550.286893]  [<f8e10d4a>] nfs_readpages+0x0/0x14d [nfs]
[  550.287054]  [<c0146444>] __do_page_cache_readahead+0xe3/0x19c
[  550.287204]  [<f8d36bee>] xdr_partial_copy_from_skb+0x12a/0x172 [sunrpc]
[  550.291280]  [<f8d37e63>] xs_tcp_data_recv+0x3cd/0x401 [sunrpc]
[  550.295331]  [<f8d36d4f>] xdr_skb_read_bits+0x0/0x35 [sunrpc]
[  550.299385]  [<c0146549>] blockable_page_cache_readahead+0x4c/0x9f
[  550.303465]  [<c0146618>] make_ahead_window+0x7c/0x99
[  550.307499]  [<c01467af>] page_cache_readahead+0x17a/0x1a4
[  550.311532]  [<c01419ce>] do_generic_mapping_read+0x13b/0x432
[  550.315583]  [<c0143595>] generic_file_aio_read+0x130/0x157
[  550.319512]  [<c0141384>] file_read_actor+0x0/0xd1
[  550.323492]  [<c0159fb5>] do_sync_read+0xc6/0x109
[  550.327471]  [<c02a4a78>] ip_rcv_finish+0x0/0x235
[  550.331524]  [<c01272d1>] autoremove_wake_function+0x0/0x35
[  550.335629]  [<c0159eef>] do_sync_read+0x0/0x109
[  550.339532]  [<c015a83c>] vfs_read+0xa6/0x150
[  550.343513]  [<c015abb3>] sys_read+0x41/0x67
[  550.347385]  [<c0103b00>] syscall_call+0x7/0xb
[  550.351321]  =======================

That's

	WARN_ON_ONCE(irqs_disabled());

