Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZDLLyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZDLLyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760138AbZDLLxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:53:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760464AbZDLLxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:53:48 -0400
Message-ID: <49E1D632.4010200@redhat.com>
Date: Sun, 12 Apr 2009 14:53:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Problem with kvm on -tip
References: <20090409210738.GA4566@hades.domain.com> <49E08857.2090503@redhat.com> <20090411194546.GA12126@hades.domain.com>
In-Reply-To: <20090411194546.GA12126@hades.domain.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques wrote:
> Hi,
>
> On Sat, Apr 11, 2009 at 03:08:55PM +0300, Avi Kivity wrote:
>   
>> This might be fixed by the attached patch.
>>     
>
> I confirm that the patch you sent removes the warnings but does it really solve
> the issue? (Sorry, I really do not know this code so I might be saying something
> really stupid.)
>   

It does.  If we are later migrated to another cpu, this code snippet 
will be called again and re-set the clock.

> What I understand from your patch is that the only portion of code that needs
> protection is the __get_cpu_var().  If this is true then a patch like the one
> below would do a better job.  But I am not sure that nothing else needs
> protection since the code immediately following the preempt_enable (in your
> patch) is an invocation to local_irq_save()...
>
> ---
>  arch/x86/kvm/x86.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8ca100a..cf918b5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -626,13 +626,17 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
>  	unsigned long flags;
>  	struct kvm_vcpu_arch *vcpu = &v->arch;
>  	void *shared_kaddr;
> +	uint32_t tsc_khz;
>  
>  	if ((!vcpu->time_page))
>  		return;
>  
> -	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) {
> -		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
> -		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
> +	preempt_disable();
> +	tsc_khz = __get_cpu_var(cpu_tsc_khz);
> +	preempt_enable();
> +	if (unlikely(vcpu->hv_clock_tsc_khz != tsc_khz)) {
> +		kvm_set_time_scale(tsc_khz, &vcpu->hv_clock);
> +		vcpu->hv_clock_tsc_khz = tsc_khz;
>  	}

Since the whole thing is unlikely(), there will be no runtime difference 
between the two patches.

-- 
error compiling committee.c: too many arguments to function

