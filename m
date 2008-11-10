Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYKJQLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYKJQLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYKJQLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:11:42 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:9719 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYKJQLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GkWZ4HMFMIP+LKX1q3p1WTuM7keqNdMhYOxCNiHHA0qFzEk/a6f7N+CVVzW1nW1xmk
         wsJyQEDacohzPviMjSmrABv8p+L0wqWCQmzlMWD4WZhm05bOOzdnDdRTSxL0fWUYJ1R5
         imvtUJkEEwivZq9LHg403Na4EoaeuArCSiuCc=
Date: Mon, 10 Nov 2008 19:11:33 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
Message-ID: <20081110161133.GB16522@localhost>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <491843C4.9090306@cosmosbay.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Dumazet - Mon, Nov 10, 2008 at 03:23:00PM +0100]
> Andi Kleen a écrit :
>> Eric Dumazet <dada1@cosmosbay.com> writes:
>>
>>> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
>>> index 3f1b81a..716d26f 100644
>>> --- a/arch/x86/oprofile/op_model_ppro.c
>>> +++ b/arch/x86/oprofile/op_model_ppro.c
>>> @@ -69,7 +69,7 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>>>  	int i;
>>>   	if (!reset_value) {
>>> -		reset_value = kmalloc(sizeof(unsigned) * num_counters,
>>> +		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
>>
>> Thanks for tracking this down.
>>
>> But that still doesn't explain why 2.6.27 fails too?
>
> Desesperatly Seeking Oprofile, next round.
>
> I know *nothing* about APIC but spent few hours to try several tricks
> and finally found something.
>
> It solved my problem : oprofile can run several hours without
> any freeze of NMI on any core.
>
> # grep NMI /proc/interrupts
> NMI:   10902884    9635871   10333815    8372989    7971483    8298373    8877495   10206963   Non-maskable interrupts
> ...
> # grep NMI /proc/interrupts
> NMI:   15518834   14340713   15038694   13078235   12676585   13003394   13582115   14912146   Non-maskable interrupts
>
>
> Can anybody understand and explain what is happening ?
>
> Is it a software or hardware problem ?
>
> [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
>
> While using oprofile on my HP BL460c G1, (two quad core intel E5450 CPU),
> I noticed that one CPU after the other could not get anymore NMI.
>
> After a while, all cores where blocked (ie not generating events for oprofile)
> I tried all major linux versions and all where affected by this freeze.
>
> I found that we have to re-arm APIC_DM_NMI *before* writing to MSR counter
> when we get event notification.
>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> arch/x86/oprofile/op_model_ppro.c |    8 +++++---
> 1 files changed, 5 insertions(+), 3 deletions(-)

| diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
| index 3f1b81a..7b142da 100644
| --- a/arch/x86/oprofile/op_model_ppro.c
| +++ b/arch/x86/oprofile/op_model_ppro.c
| @@ -132,13 +132,15 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
|  		rdmsrl(msrs->counters[i].addr, val);
|  		if (CTR_OVERFLOWED(val)) {
|  			oprofile_add_sample(regs, i);
| +			/*
| +			 * We need to unmask the apic vector *before*
| +			 * writing reset_value to msr counter
| +			 */
| +			apic_write(APIC_LVTPC, APIC_DM_NMI);
|  			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
|  		}
|  	}
|  
| -	/* Only P6 based Pentium M need to re-unmask the apic vector but it
| -	 * doesn't hurt other P6 variant */
| -	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
|  
|  	/* We can't work out if we really handled an interrupt. We
|  	 * might have caught a *second* counter just after overflowing

Hi Eric,

for the record

	apic_write(APIC_LVTPC, APIC_DM_NMI);

is not just 'unmask' but also *zeroify* (not sure if I wrote this
word right :) all fields when the origianl code was just 'unmasking'
TPC register

	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);

that is why apic_read() was in former.

		- Cyrill -
