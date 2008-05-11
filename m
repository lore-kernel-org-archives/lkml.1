Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbYEKNyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbYEKNyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYEKNye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:54:34 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:60850 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751546AbYEKNyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:54:32 -0400
Message-ID: <4826FAC8.4010604@seznam.cz>
Date: Sun, 11 May 2008 15:55:20 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 08/56] microblaze_v2: Interrupt handling, timer support,
 supported function
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu> <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu> <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu> <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu> <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu> <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu> <alpine.LFD.1.10.0805070813160.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805070813160.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

comments are below.

> Michal,
> 
> On Sun, 4 May 2008, monstr@seznam.cz wrote:
>> From: Michal Simek <monstr@monstr.eu>
> 
>> +/* NOTE
>> + * self-modified part of code for improvement of interrupt controller
>> + * save instruction in interrupt rutine
>> + */
>> +void function_hack(const int *arr_fce, const unsigned int base)
>> +{
>> +	unsigned int flags = 0;
> 
> no need to initialize flags 
> 
>> +	unsigned int j, i;
>> +	unsigned int *addr = NULL;
> 
> Just a coding style nit:
> 
>        unsigned int i, j, flags, *addr = NULL;
> 
> saves 2 lines of code :)

Saving lines are good. :-)

>> +	local_irq_save(flags);
>> +	__disable_icache();
>> +
>> +	/* zero terminated array */
>> +	for (j = 0; arr_fce[j] != 0; j++) {
>> +		/* get start address of function */
>> +		addr = (unsigned int *) arr_fce[j];
>> +		pr_debug("%s: func(%d) at 0x%x\n",
>> +					__func__, j, (unsigned int) addr);
>> +		for (i = 0;; i++) {
>> +			pr_debug("%s: instruction code at %d: 0x%x\n",
>> +						__func__, i, addr[i]);
>> +			if (addr[i] == 0xb0001234) {
> 
> Please replace all those hex constants with proper named defines so
> the code becomes readable

I added some macros which I hope clear this code.

>> +				/* detecting of lwi or swi instruction */
>> +				if ((addr[i+1] & 0xec00ff00) == 0xe800ff00) {
>> +					pr_debug("%s: curr instr, "
>> +						"(%d):0x%x, "
>> +						"next(%d):0x%x\n",
>> +						 __func__, i, addr[i], i+1,
>> +								addr[i+1]);
>> +					addr[i] = 0xb0000000 + (base >> 16);
>> +					addr[i+1] = (addr[i+1] & 0xffff00ff) +
>> +							(base & 0xffff);
>> +					__invalidate_icache(addr[i]);
>> +					__invalidate_icache(addr[i+1]);
>> +					pr_debug("%s: hack instr, "
>> +						"(%d):0x%x, "
>> +						"next(%d):0x%x\n",
>> +						 __func__, i, addr[i], i+1,
>> +								addr[i+1]);
> 
> Please split this modification code out into a separate function. The
> same code is used below.

Add Macro.

>> +				} else /* detection addik for ack */
>> +				if ((addr[i+1] & 0xfc00ff00) == 0x3000ff00) {
>> +					pr_debug("%s: curr instr, "
>> +						"(%d):0x%x, "
>> +						"next(%d):0x%x\n",
>> +						 __func__, i, addr[i], i+1,
>> +								addr[i+1]);
>> +					addr[i] = 0xb0000000 + (base >> 16);
>> +					addr[i+1] = (addr[i+1] & 0xffff00ff) +
>> +							(base & 0xffff);
>> +					__invalidate_icache(addr[i]);
>> +					__invalidate_icache(addr[i+1]);
>> +					pr_debug("%s: hack instr, "
>> +						"(%d):0x%x, "
>> +						"next(%d):0x%x\n",
>> +						 __func__, i, addr[i], i+1,
>> +								addr[i+1]);
>> +				}
> 
>> +#include <linux/init.h>
>> +#include <linux/irq.h>
>> +#include <linux/autoconf.h>
>> +#include <asm/page.h>
>> +#include <asm/io.h>
>> +
>> +#include <asm/prom.h>
>> +#include <asm/irq.h>
>> +
>> +#ifdef CONFIG_HACK
>> +#include <asm/hack.h>
>> +#else
>> +static unsigned int intc_baseaddr;
>> +#endif
>> +
>> +unsigned int NR_IRQ;
> 
> Please use lower case for variables

fixed

>> +/* No one else should require these constants, so define them locally here. */
>> +#define ISR 0x00			/* Interrupt Status Register */
>> +#define IPR 0x04			/* Interrupt Pending Register */
>> +#define IER 0x08			/* Interrupt Enable Register */
>> +#define IAR 0x0c			/* Interrupt Acknowledge Register */
>> +#define SIE 0x10			/* Set Interrupt Enable bits */
>> +#define CIE 0x14			/* Clear Interrupt Enable bits */
>> +#define IVR 0x18			/* Interrupt Vector Register */
>> +#define MER 0x1c			/* Master Enable Register */
>> +
>> +#define MER_ME (1<<0)
>> +#define MER_HIE (1<<1)
>>
>>
>>
>> +static void intc_enable(unsigned int irq)
>> +{
>> +	unsigned int mask = (0x00000001 << (irq & 31));
>> +	pr_debug("enable: %d\n", irq);
>> +#ifdef CONFIG_HACK
> 
> Please use a sensible name for that config switch and the constants
> (e.g. HACK_BASE_ADDR)

SELFMOD

>> +	iowrite32(mask, HACK_BASE_ADDR + SIE);
>> +#else
>> +	iowrite32(mask, intc_baseaddr + SIE);
>> +#endif
> 
> Please create a macro for that instead of uglyfying each function with
> ifdeffery
> 
> #ifdef CONFIG_XXXX
> # define INTC_BASE	XXX_BASE_ADDR
> #else
> # define INTC_BASE	intc_baseaddr
> #endif
> 
> So now your functions reads simple:
> 
>        unsigned int mask = (0x00000001 << (irq & 31));
> 
>        iowrite32(mask, INTC_BASE_ADDR + SIE);

Fixed intc and timer functions

>> +}
>> +
>> +static void intc_disable(unsigned int irq)
>> +{
>> +	unsigned long mask = (0x00000001 << (irq & 31));
>> +	pr_debug("disable: %d\n", irq);
>> +#ifdef CONFIG_HACK
>> +	iowrite32(mask, HACK_BASE_ADDR + CIE);
>> +#else
>> +	iowrite32(mask, intc_baseaddr + CIE);
>> +#endif
>> +}
>> +
>> +static void intc_disable_and_ack(unsigned int irq)
>> +{
>> +	unsigned long mask = (0x00000001 << (irq & 31));
>> +	pr_debug("disable_and_ack: %d\n", irq);
>> +#ifdef CONFIG_HACK
>> +	iowrite32(mask, HACK_BASE_ADDR + CIE);
>> +	/* ack edge triggered intr */
>> +	if (!(irq_desc[irq].status & IRQ_LEVEL))
>> +		iowrite32(mask, HACK_BASE_ADDR + IAR);
> 
> Please do not do that. Create two irq_chips one for level and one for
> edge with different implementations of the functions so you don't have
> to check for level/edge in the functions itself.
> 
>> +
>> +	for (i = 0; i < NR_IRQ; ++i) {
>> +		irq_desc[i].chip = &intc_dev;
>> +
>> +		if (handle & (0x00000001 << i))
>> +			irq_desc[i].status &= ~IRQ_LEVEL;
>> +		else
>> +			irq_desc[i].status |= IRQ_LEVEL;
>> +	}
> 
> With two irq chips this would be:
> 
> 	for (i = 0; i < NR_IRQ; ++i) {
> 		if (handle & (0x00000001 << i)) {
> 		        set_irq_chip_and_handler(irq, &intc_edge, handle_edge_irq);
> 			irq_desc[i].status &= ~IRQ_LEVEL;
> 		} else {
> 		        set_irq_chip_and_handler(irq, &intc_level, handle_level_irq);
> 			irq_desc[i].status |= IRQ_LEVEL;
> 		}
> 	}

Two chips - two levels.

>> +}
>> diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
>> new file mode 100644
>> index 0000000..4cd30aa
>> --- /dev/null
>> +++ b/arch/microblaze/kernel/irq.c
>> @@ -0,0 +1,100 @@
>> +/*
>> + * arch/microblaze/kernel/process.c
> 
> Please remove those useless (and in this case even wrong) file names.

Removing from all Microblaze code.
>> +void do_IRQ(struct pt_regs *regs)
>> +{
>> +	unsigned int irq;
>> +
>> +	irq_enter();
>> +	set_irq_regs(regs);
>> +	irq = get_irq(regs);
>> +	BUG_ON(irq == -1U);
>> +	__do_IRQ(irq);
> 
> Please do not use __do_IRQ() use the handlers which provide per
> interrupt type optimized handlers.
> 
> 	  struct irq_desc *desc = irq_desc + irq;
> 
> 	  desc->handle(irq);

It is a little bit different but with sililar style. You can check it in next
set of patches.

>> +	irq_exit();
>> +}
> 
>> +
>> +/*unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
>> +{
>> +	printk ("ERROR %s\n",__FUNCTION__);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(irq_of_parse_and_map);*/
> 
> Please remove unused code

This function is implemented above file.

>> +static void timer_ack(void)
>> +{
>> +#ifdef CONFIG_HACK
>> +	iowrite32(ioread32(HACK_BASE_ADDR + TCSR0), HACK_BASE_ADDR + TCSR0);
>> +#else
>> +	iowrite32(ioread32(timer_baseaddr + TCSR0), timer_baseaddr + TCSR0);
>> +#endif
> 
> Same thing as the interrupt one

<snip>

>> +}
>> +
>> +irqreturn_t timer_interrupt(int irq, void *dev_id)
>> +{
>> +#ifdef CONFIG_HEART_BEAT
>> +	heartbeat();
>> +#endif
>> +	timer_ack();
>> +
>> +	write_seqlock(&xtime_lock);
>> +
>> +	do_timer(1);
> 
> Can you please move a new architecture to clockevents / clocksource
> right from the beginning ? No need to invent another incompatible set
> of time(r) related functions.

I move whole code to GENERIC_TIME. Did you meant any others changes?

>> +	update_process_times(user_mode(get_irq_regs()));
>> +	profile_tick(CPU_PROFILING);
>> +
>> +	write_sequnlock(&xtime_lock);
>> +
>> +	return IRQ_HANDLED;
>> +}
> 
>> +/*
>> + * HACK_BASE_ADDR is constant address for hack function.
>> + * do not change this value - it is hardcoded in hack function
>> + * arch/microblaze/kernel/hack.c:function_hack()
> 
> Grr. Please use defines for everything and do not hardcode stuff here
> and there and make a define depend on some hardcoded value in a c
> function.

BARRIER_BASE_ADDR

>> + */
>> +
>> +#define HACK_BASE_ADDR	0x1234ff00
> 
> 
>> +#ifndef _ASM_MICROBLAZE_IRQ_H
>> +#define _ASM_MICROBLAZE_IRQ_H
>> +
>> +#include <linux/seq_file.h>
>> +#define NR_IRQS 32
> 
> Eeew.
> 
>> +#include <linux/irq.h>
> 
> asm/irq.h is included from linux/irq.h not the other way round

fixed

>> +extern unsigned int NR_IRQ;
>> +extern void ledoff(void);
> 
> Is ledoff an interrupt function ?

I think no - removed.

>> +#define NO_IRQ (-1)
>> +
>> +static inline int irq_canonicalize(int irq)
>> +{
>> +	return (irq);
>> +}
> 
> Why is this needed ? Any users ?

is used in serial_core.c
 684         new_serial.irq = irq_canonicalize(new_serial.irq);

>> +struct pt_regs;
>> +extern void do_IRQ(struct pt_regs *regs);
>> +extern void __init init_IRQ(void);
> 
>> +int show_interrupts(struct seq_file *p, void *v);
> 
> Already defined in include/linux/interrupt.h

fixed.

> Thanks,
> 	tglx
> 

Thanks for your review,

Michal Simek
