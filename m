Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYHNRNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYHNRNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYHNRNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:13:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37001 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHNRNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:13:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	<20080814132638.GA18743@elte.hu> <20080814133652.GA10972@elte.hu>
	<20080814093326.1d8d0a88.akpm@linux-foundation.org>
Date: Thu, 14 Aug 2008 10:03:07 -0700
In-Reply-To: <20080814093326.1d8d0a88.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 14 Aug 2008 09:33:26 -0700")
Message-ID: <m1abffh6lw.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0261]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] irq: sparse irqs, fix #2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 14 Aug 2008 15:36:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
>> +static inline cpumask_t vector_allocation_domain(int cpu)
>> +{
>> +        /* Careful. Some cpus do not strictly honor the set of cpus
>> +         * specified in the interrupt destination when using lowest
>> +         * priority interrupt delivery mode.
>> +         *
>> +         * In particular there was a hyperthreading cpu observed to
>> +         * deliver interrupts to the wrong hyperthread when only one
>> +         * hyperthread was specified in the interrupt desitination.
>> +         */
>> +        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
>> +        return domain;
>> +}
>
> I haven't looked at callers of this, but...
>
> Does it need to be allocated on the stack?  Local cpumask_t's are a
> size problem.  Can we build this in .rodata at compile time instead?
>
> Is this the caller?

Yes.

>
> +	for_each_cpu_mask(cpu, mask) {
> +		cpumask_t domain, new_mask;
> +		int new_cpu;
> +		int vector;
> +
> +		domain = vector_allocation_domain(cpu);
> +		cpus_and(new_mask, domain, cpu_online_map);
>
> If so we could perhaps do
>
>
> static noinline const cpumask_t *vector_allocation_domain(int cpu)
> {
>         /* Careful. Some cpus do not strictly honor the set of cpus
>          * specified in the interrupt destination when using lowest
>          * priority interrupt delivery mode.
>          *
>          * In particular there was a hyperthreading cpu observed to
>          * deliver interrupts to the wrong hyperthread when only one
>          * hyperthread was specified in the interrupt desitination.
>          */
>         static const cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
>         return &domain;
> }
>
>
> ...
>
> +	for_each_cpu_mask(cpu, mask) {
> +		cpumask_t domain, new_mask;
> +		int new_cpu;
> +		int vector;
> +
> +		__cpus_and(new_mask, vector_allocation_domain(cpu),
> +				&cpu_online_map);
>
> otoh, perhaps this new function is one implementation of
> genapic.vector_allocation_domain(), in which case the inlining was
> unneeded and misleading.

Likely.  Why these things live in header files...

> I give up.  Have a little think about the stack bloat, please.
>
> btw, whoever wrote that function is in need of a tab key.

Unfortunate gradual accreation of functionality.

vector_allocation_domain could perhaps be better named.  Round up
this cpu to the set of cpus I need to allocate a vector on.

Eric



