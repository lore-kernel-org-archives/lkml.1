Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYJAVxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYJAVxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYJAVxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:53:34 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:20131 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754051AbYJAVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:53:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Nz7gYiMqioa9IkUTvC0Ar6LVQQRo3KCFqcyB/yaTkNrDC5bHvJZw2ZtMrE5Yr0hO9MqyYFdI+xrTglwe4Bb2IRsooQiHM9hnK+lBhrEFTLProLDggwEHgQeYMim+tNRMMkXHrzIckh8r20/Qs/S7wMq2u5w3mbZhXFWvduFNuvk=  ;
X-YMail-OSG: fU6baqcVM1nPYy_BlAggPgcyP.7rnJYZlLiM34wttJQxyqVUgCMbOOkQMy8JKdJz.vFYbcDV6_4eioG8Our3yMuj.eaBiBOhKnhiugBUPgwJmGqToZHRuLypd6OwxSAbS9nPF5P86y0dA_267KdMHsU77cc18Khoe_pjsxZiAdiWIXfH8w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 2.6.27-rc8 1/2] drivers/mfd/twl4030-core.c
Date: Wed, 1 Oct 2008 14:53:25 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-omap@vger.kernel.org
References: <200810011144.20510.david-b@pacbell.net>
In-Reply-To: <200810011144.20510.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011453.26699.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008, David Brownell wrote:

> NOTE: this is the current code from the linux-omap tree.

This chip being used on a whole bunch of boards:

 - Gumstix Overo
 - BeagleBoard.org
 - Omap ZOOM (Labrador)
 - OMAP 2430 and 3430 SDP,
 - OMAP2 and OMAP3 EVM
 - ... more (openpandora.org ?)

which will get much closer to "usable with mainline kernels"
when their power management chip works in mainline!  :)


> I expect a few things still need to be updated...

... ergo, some comments below.  I'll hope we won't need
too many more iterations of fixes before we get a baseline
suitable for a 2.6.28-rc0 merge.

This version was posted since it's a good milestone, with
a bunch of recent updates from Felipe and me.  I'd think
most of the comments below can be addressed pretty easily.

(Except ones related to threaded IRQ handling in mainline.)


>  include/linux/i2c/twl4030-gpio.h   |   76 ++
>  include/linux/i2c/twl4030-madc.h   |  134 +++
>  include/linux/i2c/twl4030-pwrirq.h |   37 +
>  include/linux/i2c/twl4030.h        |  191 +++++

I suspect that's three headers-too-many, and that the fix
should (a) move register decls needed for IRQ setup into
the twl4030.h file, and (b) move other headers into the
relevant driver(s).

 
> +config TWL4030_CORE
> +	bool "Texas Instruments TWL4030/TPS659x0 Support"
> +	depends on I2C=y && (ARCH_OMAP2 || ARCH_OMAP3)

Hardly any of this code is actually OMAP-specific.  I stuck
those dependencies in to prevent build breakage related to
how the current code expects some global IRQ symbols.  When
that's all fixed I expect those dependencies to vanish.


> --- /dev/null
> +++ b/drivers/mfd/twl4030-core.c
> @@ -0,0 +1,1255 @@
> +/*
> + * twl4030_core.c - driver for TWL4030/TPS659x0 PM and audio CODEC devices
> + *
> 	...

It could probably stand a header comment giving a bit more detail
about the chip and how this driver core supports it.


> +/* Slave address */
> +#define TWL4030_SLAVENUM_NUM0		0x00
> +#define TWL4030_SLAVENUM_NUM1		0x01
> +#define TWL4030_SLAVENUM_NUM2		0x02
> +#define TWL4030_SLAVENUM_NUM3		0x03

I suspect these can/should be replaced with "0", "1", "2", and "3"
everywhere they get used, referring to the relevant I2C address
(0x48 + 0/1/2/3) used to access a given function.  :)

NUM_NUM should be reserved for lolcat usage.


And while I find the register addressing needlessly (?) confusing,
it's not a thing I'd suggest changing right away.  It *could* have
been based on a {slave, register} pairing.  Instead it's based
mapping {module, offset} to those "real" addresses.  Maybe some
older chip revisions needed different mappings.


> +/* TWL4030 BCI registers */
> +#define TWL4030_INTERRUPTS_BCIIMR1A	0x2
> +#define TWL4030_INTERRUPTS_BCIIMR2A	0x3
> +#define TWL4030_INTERRUPTS_BCIIMR1B	0x6
> +#define TWL4030_INTERRUPTS_BCIIMR2B	0x7
> +#define TWL4030_INTERRUPTS_BCIISR1A	0x0
> +#define TWL4030_INTERRUPTS_BCIISR2A	0x1
> +#define TWL4030_INTERRUPTS_BCIISR1B	0x4
> +#define TWL4030_INTERRUPTS_BCIISR2B	0x5
> +
> +/* TWL4030 keypad registers */
> +#define TWL4030_KEYPAD_KEYP_IMR1	0x12
> +#define TWL4030_KEYPAD_KEYP_IMR2	0x14
> +#define TWL4030_KEYPAD_KEYP_ISR1	0x11
> +#define TWL4030_KEYPAD_KEYP_ISR2	0x13

IMO those IRQ registers should be moved into the twl4030.h
header and shared with the relevant subchip drivers...


> +static const u8 __initconst twl4030_keypad_imr_regs[] = {
> +	TWL4030_KEYPAD_KEYP_IMR1,
> +	TWL4030_KEYPAD_KEYP_IMR2,
> +};
> +
> +/* TWL4030 keypad module interrupt status registers */
> +static const u8 __initconst twl4030_keypad_isr_regs[] = {
> +	TWL4030_KEYPAD_KEYP_ISR1,
> +	TWL4030_KEYPAD_KEYP_ISR2,
> +};

This __initconst stuff bothers me a bit.  On one hand
it's "not strictly correct" because the driver could
be unbound from the hardware (e.g. sysfs, or rmmod of
its i2c_adapter) ... and then need this data again if
it gets re-initialized.

On the other hand, anyone trying to break systems like
that will succeed and it's only a question of how quickly
the kablooie happens.  I'd rather just ensure the driver
can't ever be unbound.

On yet another hand (it's good to have lots of them!),
keeping that stuff around would let the driver recover
from certain nastiness (see below)...


> +/* Structure to define on TWL4030 Slave ID */
> +struct twl4030_client {
> +	struct i2c_client *client;
> +	u8 address;
> +	bool inuse;

This "inuse" thing seems wasteful.  Easier to just
have one flag for the whole driver.

> +
> +	/* max numb of i2c_msg required is for read =2 */
> +	struct i2c_msg xfer_msg[2];
> +
> +	/* To lock access to xfer_msg */
> +	struct mutex xfer_lock;
> +};


Now the IRQ handling is important, and is a bit messy.  It can be
cleaned up a bit ... but since TGLX has threatened to merge some
threaded IRQ support soonish, I'd propose waiting for that support
before doing too much work on the IRQ code here.

While various I2C chips have IRQ handlers -- common on embedded
boards but not for x86 -- I don't know of any others which have
yet tried to plug into genirq.  This chip has over 50 independent
IRQ sources, so leveraging genirq seems right.  Now if only the
genirq support for this were friendlier ... ;)


> +/*
> + * do_twl4030_module_irq() is the desc->handle method for each of the twl4030
> + * module interrupts.

Well, each one that's not overridden by a chained handler ...

This top-level IRQ handling code, for the "PIH" (think "Primary
Interrupt Hub"), dispatches to code for the "SIH" ("Secondary...").
Only SIH can mask/unmask IRQs, control which edge(s) trigger, etc.

SIH modules cover:  GPIOs, USB OTG transceiver, Multichannel ADC,
Keypad, battery charger, and "Power" (not entirely a grab-bag for
everything else).

Right now the GPIO and "Power" SIH modules use chained handlers.

(And I'd like to see the "Power" support merged into this core
as part of the initial mainline merge...)


> 				It executes in kernel thread context. 
> + * On entry, cpu interrupts are disabled.
> + */
> +static void do_twl4030_module_irq(unsigned int irq, irq_desc_t *desc)
> +{
> +	struct irqaction *action;
> +	const unsigned int cpu = smp_processor_id();
> +
> +	/*
> +	 * Earlier this was desc->triggered = 1;
> +	 */
> +	desc->status |= IRQ_LEVEL;

Clearly incorrect.  I think the intent is what IRQ_INPROGRESS does;
but maybe not.  Probably IRQ_LEVEL should be set for the PIH
interrupts when they get set up.


> +
> +	/*
> +	 * The desc->handle method would normally call the desc->chip->ack
> +	 * method here, but we won't bother since our ack method is NULL.
> +	 */
> +
> +	if (!desc->depth) {
> +		kstat_cpu(cpu).irqs[irq]++;

I think statistics are supposed to be recorded whether or not
the irq is enabled ...


> +
> +		action = desc->action;
> +		if (action) {
> +			int ret;
> +			int status = 0;
> +			int retval = 0;
> +
> +			local_irq_enable();

Which is highly unusual for non-threaded IRQ handlers.  Maybe
we won't need it when genirq supports threaded ones.   For
that matter maybe we won't need this routine at all.  ;)

The bits below are messy ... desc->action above was referenced
without holding desc->lock; ditto action->next below.  Clearly
this code is racy -- not that systems using these IRQs are
(yet?) doing anything where that would matter.


> +
> +			do {
> +				/* Call the ISR with cpu interrupts enabled */
> +				ret = action->handler(irq, action->dev_id);
> +				if (ret == IRQ_HANDLED)
> +					status |= action->flags;
> +				retval |= ret;
> +				action = action->next;
> +			} while (action);
> +
> +			if (status & IRQF_SAMPLE_RANDOM)
> +				add_interrupt_randomness(irq);
> +
> +			local_irq_disable();
> +
> +			if (retval != IRQ_HANDLED)
> +				printk(KERN_ERR "ISR for TWL4030 module"
> +					" irq %d can't handle interrupt\n",
> +					irq);
> +
> +			/*
> +			 * Here is where we should call the unmask method, but
> +			 * again we won't bother since it is NULL.
> +			 */
> +		} else
> +			printk(KERN_CRIT "TWL4030 module irq %d has no ISR"
> +					" but can't be masked!\n", irq);
> +	} else
> +		printk(KERN_CRIT "TWL4030 module irq %d is disabled but can't"
> +				" be masked!\n", irq);

I'd prefer pr_crit(DRIVER_NAME ": ..." ) or similar.  The nastiness
here could be resolved if the __initconst stuff (noted above) stayed in
memory ... the "can't be masked" thing could be resolved by masking all
that module's IRQs, using the data now being discarded.

(On the other hand I heard a recent report of one of those messages
appearing for a while ... then disappearing.  Unclear what was up.)


> +}


> +		for (module_irq = twl4030_irq_base; 0 != pih_isr;
> +			 pih_isr >>= 1, module_irq++) {
> +			if (pih_isr & 0x1) {
> +				irq_desc_t *d = irq_desc + module_irq;
> +
> +				local_irq_disable();
> +
> +				d->handle_irq(module_irq, d);
> +
> +				local_irq_enable();
> +			}
> +		}
> +
> +		desc->chip->unmask(irq);

The local_irq_{en,dis}able() calls could clearly be moved out of
the loop.  And this whole routine should probably track IRQ_PENDING.

... but again, I'd kind of think genirq support for threaded IRQ
handling should get rid of many of these problems.  And since that
is supposed to come "soon", I'm thinking it'd be good to avoid any
more than minor fixes here...


> +static int add_children(struct twl4030_platform_data *pdata)
> +{
> +	struct platform_device	*pdev = NULL;
> +	struct twl4030_client	*twl = NULL;
> +	int			status = 0;
> +
> +	if (twl_has_bci() && pdata->bci) {
> +		twl = &twl4030_modules[TWL4030_SLAVENUM_NUM3];
> +
> +		pdev = platform_device_alloc("twl4030_bci", -1);
> +		... etc ...

If the "mfd core" stuff were lighter weight, it should be able to
simplify this code a bunch.  Heck, just having a utility function
to pass parent, device name, primary and secondary IRQs, and a
few more bits would be good cleanup, come to think of it.

Sam, you were going to take a look at simplifying mfd-core ... if
that's going to happen for 2.6.28, I'd as soon leave add_children()
the way it is until those updates are ready to simplify it.


> +/*
> + * These three functions should be part of Voltage frame work
> + * added here to complete the functionality for now.

Actually that's not correct.  They configure the clock generation
module, which is important for things like USB and the audio codec.
Comments will be updated.


> +	/* install an irq handler to demultiplex the TWL4030 interrupt */
> +	set_irq_data(irq_num, start_twl4030_irq_thread(irq_num));
> +	set_irq_type(irq_num, IRQ_TYPE_EDGE_FALLING);

Well, not really.  It's level-sensitive.  I'll fix that.

> +	set_irq_chained_handler(irq_num, do_twl4030_irq);


> +static const struct i2c_device_id twl4030_ids[] = {
> +	{ "twl4030", 0 },	/* "Triton 2" */
> +	{ "tps65950", 0 },	/* catalog version of twl4030 */
> +	{ "tps65930", 0 },	/* fewer LDOs and DACs; no charger */
> +	{ "tps65920", 0 },	/* fewer LDOs; no codec or charger */

And "twl5030" it turns out -- minor changes from twl4030.

> +	{ /* end of list */ },
> +};
> +MODULE_DEVICE_TABLE(i2c, twl4030_ids);
