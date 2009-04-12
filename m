Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbZDLM5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbZDLM5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 08:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759977AbZDLM50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 08:57:26 -0400
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:44170 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759871AbZDLM5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 08:57:25 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sun, 12 Apr 2009 13:54:38 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Problem with kvm on -tip
Message-ID: <20090412125438.GA3988@hades.domain.com>
References: <20090409210738.GA4566@hades.domain.com> <49E08857.2090503@redhat.com> <20090411194546.GA12126@hades.domain.com> <49E1D632.4010200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E1D632.4010200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 02:53:22PM +0300, Avi Kivity wrote:
> Luis Henriques wrote:
>> Hi,
>>
>> On Sat, Apr 11, 2009 at 03:08:55PM +0300, Avi Kivity wrote:
>>   
>>> This might be fixed by the attached patch.
>>>     
>>
>> I confirm that the patch you sent removes the warnings but does it really solve
>> the issue? (Sorry, I really do not know this code so I might be saying something
>> really stupid.)
>>   
>
> It does.  If we are later migrated to another cpu, this code snippet  
> will be called again and re-set the clock.

Ok, understood.  Thank you for the comment and sorry about the noise.

--
Luis Henriques

>> What I understand from your patch is that the only portion of code that needs
>> protection is the __get_cpu_var().  If this is true then a patch like the one
>> below would do a better job.  But I am not sure that nothing else needs
>> protection since the code immediately following the preempt_enable (in your
>> patch) is an invocation to local_irq_save()...
>>
>> ---
>>  arch/x86/kvm/x86.c |   10 +++++++---
>>  1 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8ca100a..cf918b5 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -626,13 +626,17 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
>>  	unsigned long flags;
>>  	struct kvm_vcpu_arch *vcpu = &v->arch;
>>  	void *shared_kaddr;
>> +	uint32_t tsc_khz;
>>   	if ((!vcpu->time_page))
>>  		return;
>>  -	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) 
>> {
>> -		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
>> -		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
>> +	preempt_disable();
>> +	tsc_khz = __get_cpu_var(cpu_tsc_khz);
>> +	preempt_enable();
>> +	if (unlikely(vcpu->hv_clock_tsc_khz != tsc_khz)) {
>> +		kvm_set_time_scale(tsc_khz, &vcpu->hv_clock);
>> +		vcpu->hv_clock_tsc_khz = tsc_khz;
>>  	}
>
> Since the whole thing is unlikely(), there will be no runtime difference  
> between the two patches.
>
> -- 
> error compiling committee.c: too many arguments to function
