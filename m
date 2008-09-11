Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbYIKUQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbYIKUQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYIKUQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:16:26 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:45837 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYIKUQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:16:25 -0400
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2008 16:16:25 EDT
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Thu, 11 Sep 2008 21:49:25 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: e2797f04c94e20f617a28e26b98a830b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:

> On Tuesday 09 September 2008 12:14:22 Jonathan Corbet wrote:
>> > +#ifdef LIRC_SERIAL_IRDEO
>> > +static int type = LIRC_IRDEO;
>> > +#elif defined(LIRC_SERIAL_IRDEO_REMOTE)
>> > +static int type = LIRC_IRDEO_REMOTE;
>> > +#elif defined(LIRC_SERIAL_ANIMAX)
>> > +static int type = LIRC_ANIMAX;
>> > +#elif defined(LIRC_SERIAL_IGOR)
>> > +static int type = LIRC_IGOR;
>> > +#elif defined(LIRC_SERIAL_NSLU2)
>> > +static int type = LIRC_NSLU2;
>> > +#else
>> > +static int type = LIRC_HOMEBREW;
>> > +#endif
>>
>> So where do all these LIRC_SERIAL_* macros come from?  I can't really
>> tell what this bunch of ifdeffery is doing or how one might influence it.
> 
> Bleah. I believe these get passed in when building lirc userspace and
> drivers together, when manually selected the specific type of serial
> receiver you have in lirc's menu-driven configuration tool thingy...
> 
> In other words, they do us absolutely no good here. We just build for the
> default type (LIRC_HOMEBREW), and users can override the type as necessary
> via the 'type' module parameter. I'll nuke that chunk.
> 
>> > +
>> > +static struct lirc_serial hardware[] = {
>> > +	/* home-brew receiver/transmitter */
>> > +	{
>> > +		UART_MSR_DCD,
>> > +		UART_MSR_DDCD,
>> > +		UART_MCR_RTS|UART_MCR_OUT2|UART_MCR_DTR,
>> > +		UART_MCR_RTS|UART_MCR_OUT2,
>> > +		send_pulse_homebrew,
>> > +		send_space_homebrew,
>> > +		(
>> > +#ifdef LIRC_SERIAL_TRANSMITTER
>> > +		 LIRC_CAN_SET_SEND_DUTY_CYCLE|
>> > +		 LIRC_CAN_SET_SEND_CARRIER|
>> > +		 LIRC_CAN_SEND_PULSE|
>> > +#endif
>> > +		 LIRC_CAN_REC_MODE2)
>> > +	},
>>
>> It would be really nice to use the .field=value structure initialization
>> conventions here.
> 
> Indeed. Done.
> 
>> > +#if defined(__i386__)
>> > +/*
>> > +  From:
>> > +  Linux I/O port programming mini-HOWTO
>> > +  Author: Riku Saikkonen <Riku.Saikkonen@hut.fi>
>> > +  v, 28 December 1997
>> > +
>> > +  [...]
>> > +  Actually, a port I/O instruction on most ports in the 0-0x3ff range
>> > +  takes almost exactly 1 microsecond, so if you're, for example,using
>> > +  the parallel port directly, just do additional inb()s from that port
>> > +  to delay.
>> > +  [...]
>> > +*/
>> > +/* transmitter latency 1.5625us 0x1.90 - this figure arrived at from
>> > + * comment above plus trimming to match actual measured frequency.
>> > + * This will be sensitive to cpu speed, though hopefully most of the
>> > 1.5us + * is spent in the uart access.  Still - for reference test
>> > machine was a + * 1.13GHz Athlon system - Steve
>> > + */
>> > +
>> > +/* changed from 400 to 450 as this works better on slower machines;
>> > +   faster machines will use the rdtsc code anyway */
>> > +
>> > +#define LIRC_SERIAL_TRANSMITTER_LATENCY 450
>> > +
>> > +#else
>> > +
>> > +/* does anybody have information on other platforms ? */
>> > +/* 256 = 1<<8 */
>> > +#define LIRC_SERIAL_TRANSMITTER_LATENCY 256
>> > +
>> > +#endif  /* __i386__ */
>>
>> This is a little scary.  Maybe hrtimers would be a better way of handling
>> your timing issues?
> 
> Sounds plausible, will look into it. Of course, this partially hinges on
> the USE_RDTSC bits, more comments just a little ways down...
> 
>> > +static inline unsigned int sinp(int offset)
>> > +{
>> > +#if defined(LIRC_ALLOW_MMAPPED_IO)
>> > +	if (iommap != 0) {
>> > +		/* the register is memory-mapped */
>> > +		offset <<= ioshift;
>> > +		return readb(io + offset);
>> > +	}
>> > +#endif
>> > +	return inb(io + offset);
>> > +}
>>
>> This all looks like a reimplementation of ioport_map() and the associated
>> ioread*() and iowrite*() functions...?
> 
> Probably. Will see about using those instead.
> 
>> > +#ifdef USE_RDTSC
>> > +/* Version that uses Pentium rdtsc instruction to measure clocks */
>> > +
>> > +/* This version does sub-microsecond timing using rdtsc instruction,
>> > + * and does away with the fudged LIRC_SERIAL_TRANSMITTER_LATENCY
>> > + * Implicitly i586 architecture...  - Steve
>> > + */
>> > +
>> > +static inline long send_pulse_homebrew_softcarrier(unsigned long
>> > length) +{
>> > +	int flag;
>> > +	unsigned long target, start, now;
>> > +
>> > +	/* Get going quick as we can */
>> > +	rdtscl(start); on();
>> > +	/* Convert length from microseconds to clocks */
>> > +	length *= conv_us_to_clocks;
>> > +	/* And loop till time is up - flipping at right intervals */
>> > +	now = start;
>> > +	target = pulse_width;
>> > +	flag = 1;
>> > +	while ((now-start) < length) {
>> > +		/* Delay till flip time */
>> > +		do {
>> > +			rdtscl(now);
>> > +		} while ((now-start) < target);
>>
>> This looks like a hard busy wait, without even an occasional, polite,
>> cpu_relax() call.  There's got to be a better way?
>>
>> The i2c code has the result of a lot of bit-banging work, I wonder if
>> there's something there which could be helpful here.
> 
> Hrm... So at some point in the past, there was an "#if defined(rdtscl)" in
> the lirc_serial.c code that triggered USE_RDTSC being defined. At the
> moment, there's nothing defining it (I probably overzealously nuked it
> during clean- up), so we're not even touching the above code. However,
> this is supposed to be the "better" code path wrt producing a reliable
> waveform, at least on platforms with rdtscl... Will have to do some
> investigating... This actually affects whether or not we bother with
> hrtimers as suggested above too, as LIRC_SERIAL_TRANSMITTER_LATENCY is not
> used at all in the USE_RDTSC case.
> 
>> > +static irqreturn_t irq_handler(int i, void *blah)
>> > +{
>> > +	struct timeval tv;
>> > +	int status, counter, dcd;
>> > +	long deltv;
>> > +	int data;
>> > +	static int last_dcd = -1;
>> > +
>> > +	if ((sinp(UART_IIR) & UART_IIR_NO_INT)) {
>> > +		/* not our interrupt */
>> > +		return IRQ_RETVAL(IRQ_NONE);
>> > +	}
>>
>> That should just be IRQ_NONE, no?
> 
> Yeah, looks like it. Done.
> 
>> > +static void hardware_init_port(void)
>> > +{
>> > +	unsigned long flags;
>> > +	local_irq_save(flags);
>>
>> That won't help you if an interrupt is handled by another processor. 
>> This needs proper locking, methinks.
> 
> Yeah, working on implementing locking right now.
> 
>> Nothing in this function does anything to assure itself that the port
>> actually exists and is the right kind of hardware.  Maybe that can't
>> really be done with this kind of device?
> 
> We should probably try to make sure the port actually exists, but I don't
> think there's a whole lot (if anything) we can do as far as verifying the
> device itself.
> 
>> > +static int init_port(void)
>> > +{
>>
>>  ...
>>
>> > +	if (sense == -1) {
>> > +		/* wait 1/2 sec for the power supply */
>> > +
>> > +		set_current_state(TASK_INTERRUPTIBLE);
>> > +		schedule_timeout(HZ/2);
>>
>> msleep(), maybe?
> 
> Yeah, looks like it.
> 
>> > +static int set_use_inc(void *data)
>> > +{
>> > +	int result;
>> > +	unsigned long flags;
>> > +
>> > +	/* Init read buffer. */
>> > +	if (lirc_buffer_init(&rbuf, sizeof(int), RBUF_LEN) < 0)
>> > +		return -ENOMEM;
>> > +
>> > +	/* initialize timestamp */
>> > +	do_gettimeofday(&lasttv);
>> > +
>> > +	result = request_irq(irq, irq_handler,
>> > +			   IRQF_DISABLED | (share_irq ? IRQF_SHARED : 0),
>> > +			   LIRC_DRIVER_NAME, (void *)&hardware);
>> > +
>> > +	switch (result) {
>> > +	case -EBUSY:
>> > +		printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n", irq);
>> > +		lirc_buffer_free(&rbuf);
>> > +		return -EBUSY;
>> > +	case -EINVAL:
>> > +		printk(KERN_ERR LIRC_DRIVER_NAME
>> > +		       ": Bad irq number or handler\n");
>> > +		lirc_buffer_free(&rbuf);
>> > +		return -EINVAL;
>> > +	default:
>> > +		dprintk("Interrupt %d, port %04x obtained\n", irq,
>> > io);
>> > +		break;
>> > +	};
>> > +
>> > +	local_irq_save(flags);
>> > +
>> > +	/* Set DLAB 0. */
>> > +	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
>> > +
>> > +	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
>> > +
>> > +	local_irq_restore(flags);
>> > +
>> > +	return 0;
>> > +}
>>
>> OK, so set_use_inc() really is just an open() function.  It still seems
>> like a strange duplication.
> 
> Going to let the duplication be for the moment, since I don't know the
> history behind why there's duplication, and there are enough other
> mountains to climb first... :)
> 
>> Again, local_irq_save() seems insufficient here.  You need a lock to
>> serialize access to the hardware.
> 
> Will do.

I just want to thank you very much for your work and give you my Tested-By. 
Todays git (b2e9c18a32423310a309f94ea5a659c4bb264378) works well here with 
lirc-0.8.3 userspace on a Pentium 3/i815-system.

But I've had a section mismatch in the lirc code, don't know if this is 
serious.

WARNING: drivers/input/lirc/lirc_serial.o(.init.text+0x11e): Section mismatch 
in reference from the function init_module() to the 
function .exit.text:lirc_serial_exit()
The function __init init_module() references
a function __exit lirc_serial_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
lirc_serial_exit() so it may be used outside an exit section.


Regards,
Stefan
