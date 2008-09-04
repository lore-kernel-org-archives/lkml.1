Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYIDU6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYIDU6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYIDU6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:58:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbYIDU6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:58:40 -0400
Date: Thu, 4 Sep 2008 22:58:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: order functions in cpu/common.c and
	cpu/common_64.c
Message-ID: <20080904205821.GA8348@elte.hu>
References: <1220331936-15100-1-git-send-email-yhlu.kernel@gmail.com> <20080904191205.GC24990@elte.hu> <20080904193733.GA25136@elte.hu> <20080904194127.GA2542@elte.hu> <20080904200421.GA24295@elte.hu> <86802c440809041307i24cce782u4937d6fd2311c6f@mail.gmail.com> <86802c440809041332w197c2b88w95eda369dbb7761e@mail.gmail.com> <86802c440809041337l5ae10298od1c38dd43863e0ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809041337l5ae10298od1c38dd43863e0ea@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Thu, Sep 4, 2008 at 1:32 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Thu, Sep 4, 2008 at 1:07 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> On Thu, Sep 4, 2008 at 1:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>>
> >>> * Ingo Molnar <mingo@elte.hu> wrote:
> >>>
> >>>> > i've pushed out the broken tree into tip/tmp.master.broken (havent
> >>>> > updated tip/master with the breakage). I've removed the broken
> >>>> > printk in kernel/resource.c that Andrew found, see commit
> >>>> > 06e44f6af324 - so that's not the cause.
> >>>>
> >>>> i've double checked that 06e44f6af324 is applied. I'll bisect this.
> >>>
> >>> bisection came up with:
> >>>
> >>>  # good: [8bfd9710] Merge branch 'x86/xsave'
> >>>  # bad:  [06e44f6a] IO resources: fix/remove printk
> >>>  # good: [282a5f84] Merge branch 'irq/sparseirq'
> >>>  # bad:  [a0854a46] x86: make 32bit support show_msr like 64 bit
> >>>  # good: [5031088d] x86: delay early cpu initialization until cpuid is
> >>>  # good: [9d31d35b] x86: order functions in cpu/common.c and cpu/commo
> >>>  # bad:  [10a434fc] x86: remove cpu_vendor_dev
> >>>
> >>> | 10a434fcb23a57c385177a0086955fae01003f64 is first bad commit
> >>> | commit 10a434fcb23a57c385177a0086955fae01003f64
> >>> | Author: Yinghai Lu <yhlu.kernel@gmail.com>
> >>> | Date:   Thu Sep 4 21:09:45 2008 +0200
> >>> |
> >>> |     x86: remove cpu_vendor_dev
> >>>
> >>> and the thing is, 10a434fc is way too big:
> >>>
> >>> | 15 files changed, 106 insertions(+), 106 deletions(-)
> >>>
> >>> and it's not obvious at first (neither at second) sight what the problem
> >>> is. You really need to start doing much smaller patches for such
> >>> critical/hard-to-debug code areas.
> >>>
> >> could be alignment again...
> >
> > ffffffff80d86c20 d __cpu_dev_amd_cpu_dev
> > ffffffff80d86c20 A __x86_cpu_dev_start
> > ffffffff80d86c28 d __dyn_array_ptr_irq_2_pin_head
> > ffffffff80d86c28 D __dyn_array_start
> > ffffffff80d86c30 d __dyn_array_ptr_irq_cfgx
> > ffffffff80d86c38 d __dyn_array_ptr_sparse_irqs
> > ffffffff80d86c40 D __dyn_array_end
> > ffffffff80d86c40 d __initcall_selinux_init
> > ffffffff80d86c40 D __per_cpu_dyn_array_end
> > ffffffff80d86c40 D __per_cpu_dyn_array_start
> > ffffffff80d86c40 D __security_initcall_start
> > ffffffff80d86c48 R __parainstructions
> > ffffffff80d86c48 D __security_initcall_end
> > ffffffff80d86c48 A __x86_cpu_dev_end
> >
> > don't know how could the linker squash others tables into cpu_dev
> > pointer array..
> 
> it seems there is some merging problem.. please check
> 
> index 192f6d8..30973db 100644
> --- a/arch/x86/kernel/vmlinux_64.lds.S
> +++ b/arch/x86/kernel/vmlinux_64.lds.S
> @@ -172,11 +172,11 @@ SECTIONS
>    .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
>         *(.x86_cpu_dev.init)
>    }
> +  __x86_cpu_dev_end = .;
> 
>    DYN_ARRAY_INIT(8)
> 
>    SECURITY_INIT
> -  __x86_cpu_dev_end = .;
> 
>    . = ALIGN(8);
>    .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {

indeed, that was my fault and it probably explains the crash i was 
seeing - thanks!

	Ingo
