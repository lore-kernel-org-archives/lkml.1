Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZDRHAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZDRHAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZDRHAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:00:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZDRHAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:00:45 -0400
Date: Sat, 18 Apr 2009 09:00:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlsta <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] lockdep,x86: account for irqs enabled in
	paranoid_exit
Message-ID: <20090418070015.GA7678@elte.hu>
References: <20090417211135.408179566@goodmis.org> <20090417211231.649674806@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417211231.649674806@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> I hit the check_flags error of lockdep:
> 
> WARNING: at kernel/lockdep.c:2893 check_flags+0x1a7/0x1d0()
> [...]
> hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
> hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
> softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
> softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0
> 
> The check_flags warning of lockdep tells me that lockdep thought interrupts
> were disabled, but they were really enabled.
> 
> The numbers in the above parenthesis show the order of events:
> 
> 12566: softirqs last enabled:  lock_sock_nested
> 12567: hardirqs last enabled:  local_bh_enable
> 12568: softirqs last disabled: tcp_prequeue_process
> 12566: hardirqs last disabled: int3
> 
> int3 is a breakpoint!
> 
> Examining this further, I have CONFIG_NET_TCPPROBE enabled which adds
> break points into the kernel.
> 
> The paranoid_exit of the return of int3 does not account for enabling
> interrupts on return to kernel. This code is a bit tricky since it
> is also used by the nmi handler (when lockdep is off), and we must be
> careful about the swapgs. We can not call kernel code after the swapgs
> has been performed.
> 
> [ Impact: fix lockdep check_flags warning ]
> 
> Acked-by: Peter Zijlsta <a.p.zijlstra@chello.nl>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/entry_64.S |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1ac9986..987f91f 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1397,7 +1397,10 @@ ENTRY(paranoid_exit)
>  paranoid_swapgs:
>  	TRACE_IRQS_IRETQ 0
>  	SWAPGS_UNSAFE_STACK
> +	RESTORE_ALL 8
> +	jmp irq_return
>  paranoid_restore:
> +	TRACE_IRQS_IRETQ 0
>  	RESTORE_ALL 8
>  	jmp irq_return
>  paranoid_userspace:

Nice catch! This is also for upstream really - i'll cherry-pick it 
into the lockdep urgent queue as well.

	Ingo
