Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYIESLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYIESLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYIESLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:11:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYIESLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:11:31 -0400
Date: Fri, 5 Sep 2008 20:11:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080905181111.GG27395@elte.hu>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905180126.GA19334@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Fri, Sep 05, 2008 at 10:04:47AM +0200]
> | 
> | * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | 
> | > Use a nested level for 'for' cycle and break long lines.
> | > For apic_print we should countinue using KERNEL_DEBUG if
> | > we have started to.
> | 
> | > @@ -1521,32 +1521,35 @@ static void __init setup_IO_APIC_irqs(vo
> | >  	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
> | >  
> | >  	for (apic = 0; apic < nr_ioapics; apic++) {
> | > -	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
> | > +		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
> | >  
> | > +			idx = find_irq_entry(apic, pin, mp_INT);
> | > +			if (idx == -1) {
> | 
> | hm, i dont really like the super-deep nesting we do here. Could you 
> | please split out the iterator into a separate function? That makes the 
> | code a lot easier to understand and saves two extra tabs as well for 
> | those ugly-looking printk lines.
> | 
> | 	Ingo
> | 
> 
> You know it seems we use such a 'cycle on every pin on io-apics'
> in several places for now:
> 
> io_apic.c
> ---------
> 	clear_IO_APIC
> 	save_mask_IO_APIC_setup
> 	restore_IO_APIC_setup
> 	IO_APIC_irq_trigger
> 	setup_IO_APIC_irqs
> 
> I've made a one-line macro for this (like for_all_ioapics_pins)
> _but_ it looks much more ugly then this two nested for(;;) :)
> 
> If you meant me to make a separate iterator over the pins I think
> it will not help a lot - this function is simple enought so the only
> problem is too-long-printk-form - maybe just print them on separated
> lines instead of tracking apicids? Or it was made in a sake to not
> scroll screen too much?

hm, by iterator i meant the body itself. I.e. something like:

static void __init setup_IO_APIC_irqs(void)
{
        int apic, pin, notcon = 1;

        apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");

        for (apic = 0; apic < nr_ioapics; apic++)
		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
			notcon = setup_ioapic_irq(apic, pin, notcon);

        if (!notcon)
                apic_printk(APIC_VERBOSE, " not connected.\n");
}

this looks quite a bit cleaner, doesnt it? We lose the 'idx' and 'irq' 
variables and we lose the curly braces as well. The flow looks a lot 
more trivial. And the new setup_ioapic_irq() function will be simpler as 
well - it will only have 'idx' and 'irq' as a local variable, the rest 
comes in as a parameter. It can 'return notcon' instead of 'continue'. 
And it will be 2 levels of tabs aligned to the left, as an added bonus.

Hm?

	Ingo
