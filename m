Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0BRK0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:26:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0BRK0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:26:45 -0500
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if
 available
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 11:25:42 +0100
Message-ID: <1266488742.26719.119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 12:42 +0100, Luca Barbieri wrote:
> +DEFINE_PER_CPU_ALIGNED(struct sse_atomic64_percpu, sse_atomic64_percpu);
> +
> +/* using the fpu/mmx looks infeasible due to the need to save the FPU environment, which is very slow
> + * SSE2 is slightly slower on Core 2 and less compatible, so avoid it for now
> + */
> +long long sse_atomic64_read_cx8call(long long dummy, const atomic64_t *v)
> +{
> +       long long res;
> +       unsigned long cr0 = 0;
> +       struct thread_info *me = current_thread_info();
> +       preempt_disable();
> +       if (!(me->status & TS_USEDFPU)) {
> +               cr0 = read_cr0();
> +               if (cr0 & X86_CR0_TS)
> +                       clts();
> +       }
> +       asm volatile(
> +                       "movlps %%xmm0, " __percpu_arg(0) "\n\t"
> +                       "movlps %3, %%xmm0\n\t"
> +                       "movlps %%xmm0, " __percpu_arg(1) "\n\t"
> +                       "movlps " __percpu_arg(0) ", %%xmm0\n\t"
> +                           : "+m" (per_cpu__sse_atomic64_percpu.xmm0_low), "=m" (per_cpu__sse_atomic64_percpu.low), "=m" (per_cpu__sse_atomic64_percpu.high)
> +                           : "m" (v->counter));
> +       if (cr0 & X86_CR0_TS)
> +               write_cr0(cr0);
> +       res = (long long)(unsigned)percpu_read(sse_atomic64_percpu.low) | ((long long)(unsigned)percpu_read(sse_atomic64_percpu.high) << 32);
> +       preempt_enable();
> +       return res;
> +}
> +EXPORT_SYMBOL(sse_atomic64_read_cx8call); 

Care to explain how this is IRQ and NMI safe?

