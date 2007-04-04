Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbXDDNqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbXDDNqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXDDNqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:46:35 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34947 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbXDDNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:46:34 -0400
Date: Wed, 4 Apr 2007 15:46:24 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
Message-Id: <20070404154624.826578b1.dada1@cosmosbay.com>
In-Reply-To: <4613A4FF.9030202@ru.mvista.com>
References: <46124E93.2000408@ru.mvista.com>
	<16797.1175641303@turing-police.cc.vt.edu>
	<4613A4FF.9030202@ru.mvista.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 17:15:43 +0400
Maxim Uvarov <muvarov@ru.mvista.com> wrote:

>
> --- linux-2.6.18.orig/arch/i386/kernel/entry.S
> +++ linux-2.6.18/arch/i386/kernel/entry.S
> @@ -394,6 +394,9 @@ syscall_exit:
>         cli                             # make sure we don't miss an 
> interrupt
>                                         # setting need_resched or sigpending
>                                         # between sampling and the iret
> +#ifdef CONFIG_THREAD_PERF_STAT_SYSC
> +       call inc_syscallcnt             # Increment syscalls counter 
> current->sysc_cnt
> +#endif /* CONFIG_THREAD_PERF_STAT_SYSC */

Please dont call a function to do one increment !

You are touching one of the most critical part of the kernel...

Also, dont do this while interrupts are masked, this is not necessary.

Maybe better to place sysc_cnt in 'struct thread_info' because %ebp point to it.

Also you missed the fact that syscalls on i386 can use sysenter (around line 343)

>         TRACE_IRQS_OFF
>         movl TI_flags(%ebp), %ecx
>         testw $_TIF_ALLWORK_MASK, %cx   # current->work
>
