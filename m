Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0BRKuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:50:23 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:63525 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab0BRKuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:50:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iL3t6ZJPk9Wh2HcH9uPcYHfEEFPy1nVshP34PBlogCLIEqbBnzk/8mX0eCHgk722ou
         KI8N4WEwrRoa2QUgtWj1WKIDW5KNt/4/N4TTmRwY8bXiWKw/9DpFyq/BCbjzOEEGXUKs
         JI+q98XNSBWDFb4via/Kz0YGUCDIXWIYj0ayA=
MIME-Version: 1.0
In-Reply-To: <1266488742.26719.119.camel@laptop>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <1266488742.26719.119.camel@laptop>
Date: Thu, 18 Feb 2010 11:50:15 +0100
X-Google-Sender-Auth: e82e883ea87248c9
Message-ID: <ff13bc9a1002180250t5c9acb54ib8609b4e752520c5@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-17 at 12:42 +0100, Luca Barbieri wrote:
>> +DEFINE_PER_CPU_ALIGNED(struct sse_atomic64_percpu, sse_atomic64_percpu);
>> +
>> +/* using the fpu/mmx looks infeasible due to the need to save the FPU environment, which is very slow
>> + * SSE2 is slightly slower on Core 2 and less compatible, so avoid it for now
>> + */
>> +long long sse_atomic64_read_cx8call(long long dummy, const atomic64_t *v)
>> +{
>> +       long long res;
>> +       unsigned long cr0 = 0;
>> +       struct thread_info *me = current_thread_info();
>> +       preempt_disable();
>> +       if (!(me->status & TS_USEDFPU)) {
>> +               cr0 = read_cr0();
>> +               if (cr0 & X86_CR0_TS)
>> +                       clts();
>> +       }
>> +       asm volatile(
>> +                       "movlps %%xmm0, " __percpu_arg(0) "\n\t"
>> +                       "movlps %3, %%xmm0\n\t"
>> +                       "movlps %%xmm0, " __percpu_arg(1) "\n\t"
>> +                       "movlps " __percpu_arg(0) ", %%xmm0\n\t"
>> +                           : "+m" (per_cpu__sse_atomic64_percpu.xmm0_low), "=m" (per_cpu__sse_atomic64_percpu.low), "=m" (per_cpu__sse_atomic64_percpu.high)
>> +                           : "m" (v->counter));
>> +       if (cr0 & X86_CR0_TS)
>> +               write_cr0(cr0);
>> +       res = (long long)(unsigned)percpu_read(sse_atomic64_percpu.low) | ((long long)(unsigned)percpu_read(sse_atomic64_percpu.high) << 32);
>> +       preempt_enable();
>> +       return res;
>> +}
>> +EXPORT_SYMBOL(sse_atomic64_read_cx8call);
>
> Care to explain how this is IRQ and NMI safe?

Unfortunately it isn't, due to the per-CPU variables, and thus needs
to be fixed to align the stack and use it instead
(__attribute__((force_align_arg_pointer)) should do the job).
Sorry for this, I initially used the stack and later changed it to
guarantee alignment without rechecking the IRQ/NMI safety.

If we use the stack instead of per-CPU variables, all IRQs and NMIs
preserve CR0 and the SSE registers, so this would be safe, right?

kernel_fpu_begin/end cannot be used in interrupts, so that shouldn't
be a concern.
