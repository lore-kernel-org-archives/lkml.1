Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbXBFHwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbXBFHwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbXBFHwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:52:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbXBFHwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:52:11 -0500
Date: Tue, 6 Feb 2007 08:36:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
Message-ID: <20070206073616.GA15016@elte.hu>
References: <200701221116.13154.luigi.genoni@pirelli.com> <200702021848.55921.luigi.genoni@pirelli.com> <m1ejp85tgm.fsf@ebiederm.dsl.xmission.com> <200702021905.39922.luigi.genoni@pirelli.com> <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com> <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> When making the interrupt vectors per cpu I failed to handle a case 
> during irq migration.  If the same interrupt comes in while we are 
> servicing the irq but before we migrate it the pending bit in the 
> local apic IRR register will be set for that irq.

hm. I think this needs more work. For example this part of the fix looks 
quite ugly to me:

> +static unsigned apic_in_service_vector(void)
> +{
> +	unsigned isr, vector;
> +	/* Figure out which vector we are servicing */
> +	for (vector = FIRST_EXTERNAL_VECTOR; vector < FIRST_SYSTEM_VECTOR; vector += 32) {
> +		isr = apic_read(APIC_ISR + ((vector/32) * 0x10));
> +		if (isr)
> +			break;
> +	}
> +	/* Find the low bits of the vector we are servicing */
> +	vector += __ffs(isr);
> +	return vector;

so we read the hardware to figure out what the hell we are doing. The 
problem is - why doesnt the kernel know at this point what it is doing? 
It knows the CPU and it should know all the vector numbers. It also has 
an irq number.

> +	/* If the irq we are servicing has moved and is not pending
> +	 * free it's vector.
> +	 */
> +	irr = apic_read(APIC_IRR + ((vector/32) * 0x10));

the IRR is quite fragile. It's a rarely used hardware field and it has 
erratums attached to it. Again, it seems like this function too tries to 
recover information it /should/ already have.

> @@ -1400,19 +1439,24 @@ static int ioapic_retrigger_irq(unsigned int irq)
>  
>  static void ack_apic_edge(unsigned int irq)
>  {
> -	move_native_irq(irq);
> +	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
> +		move_native_irq(irq);
> +		apic_handle_pending_vector(apic_in_service_vector());
> +	}
>  	ack_APIC_irq();

this looks a bit ugly and a bit fragile. We had a simple 
'move_native_irq()' call for IRQ balancing, which is straightforward, 
but now we've got this complex condition open coded.

If then this should be done in some sort of helper - but even then, the 
whole approach looks a bit erroneous.

To me the cleanest way to migrate an IRQ between two different vectors 
on two different CPUs would be to first mask the IRQ source in the PIC, 
then to do the migration /atomically/ (no intermediary state), and then 
unmask. If the PIC loses edges while masked then that's a problem of the 
irq chip implementation of the PIC: its ->set_affinity() method should 
refuse to migrate edge-triggered IRQs if it can lose edges while 
unmasked!

	Ingo
