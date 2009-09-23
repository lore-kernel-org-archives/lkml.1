Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZIWMPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZIWMPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZIWMPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:15:04 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:50362 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZIWMPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hwelPp6gClw/T6YxwKep3+TBPTAExxJH2KcvHnApSsrzLT9N7AGi5/SmVpxevt5B/y
         GbvzzR13odPi1Vjb33+DE/wm2Gs3SWDCfGsTKY43Uh0z0ad35XKOs3xF6wYSgLJrWN3l
         tM1NXXr9v70YyuETysNl7ly7mXAAFoCfrInJw=
MIME-Version: 1.0
In-Reply-To: <tip-7d42896628202a551ad1107697cd215dc5fca099@git.kernel.org>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <tip-7d42896628202a551ad1107697cd215dc5fca099@git.kernel.org>
Date: Wed, 23 Sep 2009 13:15:03 +0100
X-Google-Sender-Auth: 60512cc7aa0befcb
Message-ID: <7863dc4c0909230515t6f0effd4x7e14e0720d99aa1b@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf_event, x86: Fix 'perf sched record' 
	crashing the machine
From: Chris Malley <mail@chrismalley.co.uk>
To: mail@chrismalley.co.uk, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, gorcunov@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/23 tip-bot for Peter Zijlstra <peterz@infradead.org>:
> Commit-ID:  7d42896628202a551ad1107697cd215dc5fca099
> Gitweb:     http://git.kernel.org/tip/7d42896628202a551ad1107697cd215dc5fca099
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Wed, 23 Sep 2009 11:03:37 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 23 Sep 2009 11:25:56 +0200
>
> perf_event, x86: Fix 'perf sched record' crashing the machine
>
> Chris Malley reported that 'perf sched record' sometimes
> crashes his box with:
>
> [  389.272175] BUG: unable to handle kernel paging request at ffffb300
> [  389.272294] IP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50
> [  389.272366] *pde = 0073f067 *pte = 00000000
> [  389.274708] Call Trace:
> [  389.274752]  [<c010e3b4>] ?  set_perf_event_pending+0x14/0x20
> [  389.274801]  [<c01b9751>] ?  perf_output_unlock+0x121/0x1a0
> [  389.274848]  [<c01b981a>] ? perf_output_end+0x4a/0x70
> [  389.274893]  [<c01ba690>] ?  __perf_event_overflow+0x240/0x2f0
> [  389.274942]  [<c030963e>] ? atomic64_cmpxchg+0x1e/0x30
> [  389.274988]  [<c01ba8f4>] ?  perf_swevent_ctx_event+0x1b4/0x1c0
> [  389.275035]  [<c01ba773>] ?  perf_swevent_ctx_event+0x33/0x1c0
> [  389.275081]  [<c01ba9a7>] ? do_perf_sw_event+0xa7/0x160
> [  389.275127]  [<c01baae2>] ? perf_tp_event+0x82/0xa0
> [  389.275174]  [<c012e9c6>] ?  ftrace_profile_sched_stat_runtime+0xe6/0x120
> [  389.275224]  [<c012e8e0>] ?  ftrace_profile_sched_stat_runtime+0x0/0x120
> [  389.275273]  [<c013c85a>] ? update_curr+0x18a/0x230
> [  389.275318]  [<c013cdc5>] ?  put_prev_task_fair+0x155/0x160
> [  389.275366]  [<c01618b5>] ? sched_clock_cpu+0xd5/0x110
> [  389.275413]  [<c04e7525>] ? _spin_lock_irq+0x45/0x50
> [  389.275458]  [<c04e424e>] ? schedule+0x20e/0xb10
>
> The problem is that the box has no lapic enabled:
>
>  [    0.042445] Local APIC not detected. Using dummy APIC emulation.
>
> The below seems like the best fix. We disabled all lapic bits, except
> the self-IPI-resend logic.
>
> Reported-by: Chris Malley <mail@chrismalley.co.uk>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index a3c7adb..b5801c3 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1790,6 +1790,9 @@ void smp_perf_pending_interrupt(struct pt_regs *regs)
>  void set_perf_event_pending(void)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> +       if (!x86_pmu.apic || !x86_pmu_initialized())
> +               return;
> +
>        apic->send_IPI_self(LOCAL_PENDING_VECTOR);
>  #endif
>  }
>

Confirmed, this fixes the problem, so FWIW:

Tested-by: Chris Malley <mail@chrismalley.co.uk>
