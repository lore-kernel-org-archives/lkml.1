Return-Path: <linux-kernel-owner+w=401wt.eu-S937726AbZDJHL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937726AbZDJHL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763285AbZDJHLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:11:46 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:18091 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbZDJHLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nZaQXmK+KJTgeKqAchR13gqCrufChIDUmy8EtzfSIA5N/bU3IH4WahkzgyaFwgH1z9
         2UXvon4QEVW2s2u9dBA8MS+cIk/p8VZiurHg9N31dC/PTo8NCDf7+XXLpV7RTe3K0hzI
         iQkRsmcSko7eLqaBNzOI75a+dLH0gbk69HBJ0=
MIME-Version: 1.0
In-Reply-To: <tip-044d408409cc4e1bc75c886e27ca85c270db104c@git.kernel.org>
References: <1236006812.5330.632.camel@laptop>
	 <tip-044d408409cc4e1bc75c886e27ca85c270db104c@git.kernel.org>
Date: Fri, 10 Apr 2009 15:11:43 +0800
Message-ID: <f17812d70904100011g65c582bcg32a530afd8e9a82d@mail.gmail.com>
Subject: Re: [tip:irq/genirq] genirq: assert that irq handlers are indeed 
	running in hardirq context
From: Eric Miao <eric.y.miao@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 7:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Commit-ID:  044d408409cc4e1bc75c886e27ca85c270db104c
> Gitweb:     http://git.kernel.org/tip/044d408409cc4e1bc75c886e27ca85c270db104c
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 2 Mar 2009 16:13:32 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 3 Mar 2009 00:05:45 +0100
>
> genirq: assert that irq handlers are indeed running in hardirq context
>
> Make sure the genirq layer handlers are indeed running handlers
> in hardirq context. That is the genirq expectation and doing
> anything else is broken.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> LKML-Reference: <1236006812.5330.632.camel@laptop>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>

OK, now this gave me the warning below and it looks resend_irqs()
and resend_tasklet are somehow found guilty and doing wrong, as
the comment of this commit suggested, yet I'm not sure if this makes
sense:


[   34.728943] ------------[ cut here ]------------
[   34.733573] WARNING: at
/home/ycmiao/work/linux-2.6/kernel/irq/handle.c:366
handle_IRQ_event+0x48/0x160()
[   34.743088] BUG: IRQ[82] handler called from non-hardirq
context!Modules linked in:
[   34.750729] [<c002e958>] (unwind_backtrace+0x0/0xdc) from
[<c00438d0>] (warn_slowpath+0x68/0x8c)
[   34.759520] [<c00438d0>] (warn_slowpath+0x68/0x8c) from
[<c006d100>] (handle_IRQ_event+0x48/0x160)
[   34.768461] [<c006d100>] (handle_IRQ_event+0x48/0x160) from
[<c006eb8c>] (handle_edge_irq+0x14c/0x1c4)
[   34.777747] [<c006eb8c>] (handle_edge_irq+0x14c/0x1c4) from
[<c006e440>] (resend_irqs+0x44/0x78)
[   34.786517] [<c006e440>] (resend_irqs+0x44/0x78) from [<c0048658>]
(tasklet_action+0x7c/0xdc)
[   34.795039] [<c0048658>] (tasklet_action+0x7c/0xdc) from
[<c0048b18>] (__do_softirq+0x60/0xe8)
[   34.803638] [<c0048b18>] (__do_softirq+0x60/0xe8) from [<c0048c88>]
(do_softirq+0x44/0x60)
[   34.811881] [<c0048c88>] (do_softirq+0x44/0x60) from [<c0048d1c>]
(ksoftirqd+0x78/0x168)
[   34.819953] [<c0048d1c>] (ksoftirqd+0x78/0x168) from [<c0058d38>]
(kthread+0x54/0x80)
[   34.827786] [<c0058d38>] (kthread+0x54/0x80) from [<c0046780>]
(do_exit+0x0/0x658)
[   34.835342] [<c0046780>] (do_exit+0x0/0x658) from [<00000000>] (0x0)
[   34.841687] ---[ end trace 26b21608484430d3 ]---



>
> ---
>  kernel/irq/handle.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 3aba8d1..a2ee682 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -328,6 +328,8 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>        irqreturn_t ret, retval = IRQ_NONE;
>        unsigned int status = 0;
>
> +       WARN_ONCE(!in_irq(), "BUG: IRQ handler called from non-hardirq context!");
> +
>        if (!(action->flags & IRQF_DISABLED))
>                local_irq_enable_in_hardirq();
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
