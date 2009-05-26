Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZEZVvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZEZVvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZEZVvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:51:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZEZVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:51:45 -0400
Subject: Re: [PATCH] trace: disable preemption before taking raw spinlocks
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090526172802.6377e33f@osiris.boeblingen.de.ibm.com>
References: <20090526172802.6377e33f@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 23:51:40 +0200
Message-Id: <1243374700.6600.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 17:28 +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> s390 code uses smp_processor_id() in __raw_spin_lock() code which
> reveals that a (raw) spinlock is taken without preemption disabled.
> This can potentially deadlock.
> 
> To fix this explicitly disable and enable preemption.
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: cat/2278
> caller is trace_find_cmdline+0x40/0xfc
> CPU: 0 Not tainted 2.6.30-rc7-dirty #39
> Process cat (pid: 2278, task: 000000003faedb68, ksp: 000000003b33b988)
> 000000003b33b988 000000003b33bae0 0000000000000002 0000000000000000 
>        000000003b33bb80 000000003b33baf8 000000003b33baf8 00000000000175d6 
>        0000000000000001 000000003b33b988 000000003f9b0000 000000000000000b 
>        000000000000000c 000000003b33bb40 000000003b33bae0 0000000000000000 
>        0000000000000000 00000000000175d6 000000003b33bae0 000000003b33bb28 
> Call Trace:
> ([<00000000000174b2>] show_trace+0x112/0x170)
>  [<0000000000017582>] show_stack+0x72/0x100
>  [<0000000000441538>] dump_stack+0xc8/0xd8
>  [<000000000025c350>] debug_smp_processor_id+0x114/0x130
>  [<00000000000bf0e4>] trace_find_cmdline+0x40/0xfc
>  [<00000000000c35d4>] trace_print_context+0x58/0xac
>  [<00000000000bb676>] print_trace_line+0x416/0x470
>  [<00000000000bc8fe>] s_show+0x4e/0x428
>  [<000000000013834e>] seq_read+0x36a/0x5d4
>  [<0000000000112a78>] vfs_read+0xc8/0x174
>  [<0000000000112c58>] SyS_read+0x74/0xc4
>  [<000000000002c7ae>] sysc_noemu+0x10/0x16
>  [<000002000012436c>] 0x2000012436c
> 1 lock held by cat/2278:
>  #0:  (&p->lock){+.+.+.}, at: [<0000000000138056>] seq_read+0x72/0x5d4

Shouldn't that be preempt_disable_notrace() and co to avoid tracer
recursion?


