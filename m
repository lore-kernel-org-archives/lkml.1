Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZAGQvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZAGQvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZAGQu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:50:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbZAGQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:50:56 -0500
Date: Wed, 7 Jan 2009 08:50:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: linux-next: Tree for December 11
In-Reply-To: <f19298770901070830q71cc7604nf55e1d5b70a22f37@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901070840240.3057@localhost.localdomain>
References: <20081211200459.14d18d7a.sfr@canb.auug.org.au>  <f19298770812110440s7e3781eex4a16b961ad6847b2@mail.gmail.com>  <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com> <f19298770901070830q71cc7604nf55e1d5b70a22f37@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Alexey Zaytsev wrote:
>
> Almost a month later, the warning is still there, and now also in Linus' git.
> Am I the only one who sees it?

Possibly. But that may be because most people don't have DEBUG_PREEMPT.

> [    0.004150] WARNING: at kernel/sched.c:4435 sub_preempt_count+0xae/0xc0()
> [    0.004247] Hardware name: HP Compaq nx7300 (GB848ES#ACB)
> [    0.004342] Modules linked in:
> [    0.004477] Pid: 0, comm: swapper Not tainted 2.6.28-06859-gede6f5a #179
> [    0.004575] Call Trace:
> [    0.004672]  [<c012fbe6>] warn_slowpath+0x86/0xa0
> [    0.004770]  [<c014e99b>] ? tick_check_oneshot_change+0x4b/0x100
> [    0.004868]  [<c046dc00>] ? _spin_unlock_irq+0x10/0x30
> [    0.004963]  [<c047045e>] sub_preempt_count+0xae/0xc0
> [    0.005060]  [<c0134787>] _local_bh_enable+0x27/0xa0

Hmm. _local_bh_enable() would make the preempt_count go negative or fall 
below 1 (with kernel lock held).

> [    0.005155]  [<c0134ac7>] __do_softirq+0xf7/0x150
> [    0.005250]  [<c01349d0>] ? __do_softirq+0x0/0x150
> [    0.005345]  <IRQ>  [<c014ec2e>] ? tick_nohz_update_jiffies+0xe/0x50
> [    0.005488]  [<c013494f>] ? irq_exit+0x7f/0x90
> [    0.005584]  [<c0104f23>] ? do_IRQ+0xa3/0x120
> [    0.005678]  [<c01038a7>] ? common_interrupt+0x27/0x2c
> [    0.005773]  [<c013007b>] ? try_acquire_console_sem+0x1b/0x30
> [    0.005872]  [<c05f7378>] ? check_bugs+0xb8/0xe0
> [    0.005967]  [<c05ef98a>] ? start_kernel+0x25a/0x2f0

.. and it happens early on, when we take an interrupt in check_bugs.

Are we ready to enable interrupts there? Maybe the page fault we took (on 
purpose) enabled interrupts and we now take the irq much too early.

Or maybe the initial kernel lock didn't set preempt_count to 1.

Ingo, any ideas?

		Linus
