Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYIESeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYIESeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYIESdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:33:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23984 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYIESdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e5dREfHnmyuYcy8vyP+ALvaw6Kv3IdOvSFqrG4EhACic6UyiSu6J9QgVD0PrxfmSdU
         UiRtCpkhRgvhgTMCnYv2nAWZfvzMeChdtFgKRKsAG1gtXC+V0QPS+sdBmkdeat8IEIam
         1r2xWJ8opB7qwuwMxj+Idg5MubS89j5LTWW94=
Date: Fri, 5 Sep 2008 22:33:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080905183347.GB19334@lenovo>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905181111.GG27395@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Sep 05, 2008 at 08:11:11PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Ingo Molnar - Fri, Sep 05, 2008 at 10:04:47AM +0200]
| > | 
| > | * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | 
| > | > Use a nested level for 'for' cycle and break long lines.
| > | > For apic_print we should countinue using KERNEL_DEBUG if
| > | > we have started to.
| > | 
| > | > @@ -1521,32 +1521,35 @@ static void __init setup_IO_APIC_irqs(vo
| > | >  	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
| > | >  
| > | >  	for (apic = 0; apic < nr_ioapics; apic++) {
| > | > -	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
| > | > +		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
| > | >  
| > | > +			idx = find_irq_entry(apic, pin, mp_INT);
| > | > +			if (idx == -1) {
| > | 
| > | hm, i dont really like the super-deep nesting we do here. Could you 
| > | please split out the iterator into a separate function? That makes the 
| > | code a lot easier to understand and saves two extra tabs as well for 
| > | those ugly-looking printk lines.
| > | 
| > | 	Ingo
| > | 
| > 
| > You know it seems we use such a 'cycle on every pin on io-apics'
| > in several places for now:
| > 
| > io_apic.c
| > ---------
| > 	clear_IO_APIC
| > 	save_mask_IO_APIC_setup
| > 	restore_IO_APIC_setup
| > 	IO_APIC_irq_trigger
| > 	setup_IO_APIC_irqs
| > 
| > I've made a one-line macro for this (like for_all_ioapics_pins)
| > _but_ it looks much more ugly then this two nested for(;;) :)
| > 
| > If you meant me to make a separate iterator over the pins I think
| > it will not help a lot - this function is simple enought so the only
| > problem is too-long-printk-form - maybe just print them on separated
| > lines instead of tracking apicids? Or it was made in a sake to not
| > scroll screen too much?
| 
| hm, by iterator i meant the body itself. I.e. something like:
| 
| static void __init setup_IO_APIC_irqs(void)
| {
|         int apic, pin, notcon = 1;
| 
|         apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
| 
|         for (apic = 0; apic < nr_ioapics; apic++)
| 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
| 			notcon = setup_ioapic_irq(apic, pin, notcon);
| 
|         if (!notcon)
|                 apic_printk(APIC_VERBOSE, " not connected.\n");
| }
| 
| this looks quite a bit cleaner, doesnt it? We lose the 'idx' and 'irq' 
| variables and we lose the curly braces as well. The flow looks a lot 
| more trivial. And the new setup_ioapic_irq() function will be simpler as 
| well - it will only have 'idx' and 'irq' as a local variable, the rest 
| comes in as a parameter. It can 'return notcon' instead of 'continue'. 
| And it will be 2 levels of tabs aligned to the left, as an added bonus.
| 
| Hm?
| 
| 	Ingo
| 

Yes Ingo it does look much cleaner _but_ the only thing which bothering
me is that we split 'logical solid' printing into several functions -
i mean we started printing in new setup_ioapic_irq function and finish
it in caller and that is much worser then having long lines printing
in single function i think (but I could be wrong :)

If we just drop original printing (just for a second to get the whole
image) we will get:

---
static void __init setup_IO_APIC_irqs(void)
{
	int apic, pin, idx, irq, first_notcon = 1;

	for (apic = 0; apic < nr_ioapics; apic++) {
		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {

			idx = find_irq_entry(apic, pin, mp_INT);
			if (idx == -1) 
				continue;

			irq = pin_2_irq(idx, apic, pin);
#ifdef CONFIG_X86_32
			if (multi_timer_check(apic, irq))
				continue;
#endif
			add_pin_to_irq(irq, apic, pin);

			setup_IO_APIC_irq(apic, pin, irq,
					irq_trigger(idx), irq_polarity(idx));
		}
	}
---

So as you see it's more then enough self-solid :) So I wouldn't
break it 'cause of printing. If we have enough memory for bit
field - we could just mark there if pin is connected to irq and
print connection map after.
Don't get me wrong please - I just don't want to overload this function
with additional call.

According how many characters have been typed for this message I think
instead of talking I could already have done the patch you supposed :)

		- Cyrill -
