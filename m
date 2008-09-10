Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYIJRmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYIJRmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYIJRml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:42:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44547 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYIJRmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:42:40 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Wed, 10 Sep 2008 13:40:18 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-3-git-send-email-jwilson@redhat.com> <20080909101422.329bd351@bike.lwn.net>
In-Reply-To: <20080909101422.329bd351@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101340.19254.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 12:14:22 Jonathan Corbet wrote:
> > +#ifdef LIRC_SERIAL_IRDEO
> > +static int type = LIRC_IRDEO;
> > +#elif defined(LIRC_SERIAL_IRDEO_REMOTE)
> > +static int type = LIRC_IRDEO_REMOTE;
> > +#elif defined(LIRC_SERIAL_ANIMAX)
> > +static int type = LIRC_ANIMAX;
> > +#elif defined(LIRC_SERIAL_IGOR)
> > +static int type = LIRC_IGOR;
> > +#elif defined(LIRC_SERIAL_NSLU2)
> > +static int type = LIRC_NSLU2;
> > +#else
> > +static int type = LIRC_HOMEBREW;
> > +#endif
>
> So where do all these LIRC_SERIAL_* macros come from?  I can't really tell
> what this bunch of ifdeffery is doing or how one might influence it.

Bleah. I believe these get passed in when building lirc userspace and drivers 
together, when manually selected the specific type of serial receiver you have 
in lirc's menu-driven configuration tool thingy...

In other words, they do us absolutely no good here. We just build for the 
default type (LIRC_HOMEBREW), and users can override the type as necessary via 
the 'type' module parameter. I'll nuke that chunk.

> > +
> > +static struct lirc_serial hardware[] = {
> > +	/* home-brew receiver/transmitter */
> > +	{
> > +		UART_MSR_DCD,
> > +		UART_MSR_DDCD,
> > +		UART_MCR_RTS|UART_MCR_OUT2|UART_MCR_DTR,
> > +		UART_MCR_RTS|UART_MCR_OUT2,
> > +		send_pulse_homebrew,
> > +		send_space_homebrew,
> > +		(
> > +#ifdef LIRC_SERIAL_TRANSMITTER
> > +		 LIRC_CAN_SET_SEND_DUTY_CYCLE|
> > +		 LIRC_CAN_SET_SEND_CARRIER|
> > +		 LIRC_CAN_SEND_PULSE|
> > +#endif
> > +		 LIRC_CAN_REC_MODE2)
> > +	},
>
> It would be really nice to use the .field=value structure initialization
> conventions here.

Indeed. Done.

> > +#if defined(__i386__)
> > +/*
> > +  From:
> > +  Linux I/O port programming mini-HOWTO
> > +  Author: Riku Saikkonen <Riku.Saikkonen@hut.fi>
> > +  v, 28 December 1997
> > +
> > +  [...]
> > +  Actually, a port I/O instruction on most ports in the 0-0x3ff range
> > +  takes almost exactly 1 microsecond, so if you're, for example,using
> > +  the parallel port directly, just do additional inb()s from that port
> > +  to delay.
> > +  [...]
> > +*/
> > +/* transmitter latency 1.5625us 0x1.90 - this figure arrived at from
> > + * comment above plus trimming to match actual measured frequency.
> > + * This will be sensitive to cpu speed, though hopefully most of the
> > 1.5us + * is spent in the uart access.  Still - for reference test
> > machine was a + * 1.13GHz Athlon system - Steve
> > + */
> > +
> > +/* changed from 400 to 450 as this works better on slower machines;
> > +   faster machines will use the rdtsc code anyway */
> > +
> > +#define LIRC_SERIAL_TRANSMITTER_LATENCY 450
> > +
> > +#else
> > +
> > +/* does anybody have information on other platforms ? */
> > +/* 256 = 1<<8 */
> > +#define LIRC_SERIAL_TRANSMITTER_LATENCY 256
> > +
> > +#endif  /* __i386__ */
>
> This is a little scary.  Maybe hrtimers would be a better way of handling
> your timing issues?

Sounds plausible, will look into it. Of course, this partially hinges on the 
USE_RDTSC bits, more comments just a little ways down...

> > +static inline unsigned int sinp(int offset)
> > +{
> > +#if defined(LIRC_ALLOW_MMAPPED_IO)
> > +	if (iommap != 0) {
> > +		/* the register is memory-mapped */
> > +		offset <<= ioshift;
> > +		return readb(io + offset);
> > +	}
> > +#endif
> > +	return inb(io + offset);
> > +}
>
> This all looks like a reimplementation of ioport_map() and the associated
> ioread*() and iowrite*() functions...?

Probably. Will see about using those instead.

> > +#ifdef USE_RDTSC
> > +/* Version that uses Pentium rdtsc instruction to measure clocks */
> > +
> > +/* This version does sub-microsecond timing using rdtsc instruction,
> > + * and does away with the fudged LIRC_SERIAL_TRANSMITTER_LATENCY
> > + * Implicitly i586 architecture...  - Steve
> > + */
> > +
> > +static inline long send_pulse_homebrew_softcarrier(unsigned long length)
> > +{
> > +	int flag;
> > +	unsigned long target, start, now;
> > +
> > +	/* Get going quick as we can */
> > +	rdtscl(start); on();
> > +	/* Convert length from microseconds to clocks */
> > +	length *= conv_us_to_clocks;
> > +	/* And loop till time is up - flipping at right intervals */
> > +	now = start;
> > +	target = pulse_width;
> > +	flag = 1;
> > +	while ((now-start) < length) {
> > +		/* Delay till flip time */
> > +		do {
> > +			rdtscl(now);
> > +		} while ((now-start) < target);
>
> This looks like a hard busy wait, without even an occasional, polite,
> cpu_relax() call.  There's got to be a better way?
>
> The i2c code has the result of a lot of bit-banging work, I wonder if
> there's something there which could be helpful here.

Hrm... So at some point in the past, there was an "#if defined(rdtscl)" in the 
lirc_serial.c code that triggered USE_RDTSC being defined. At the moment, 
there's nothing defining it (I probably overzealously nuked it during clean-
up), so we're not even touching the above code. However, this is supposed to 
be the "better" code path wrt producing a reliable waveform, at least on 
platforms with rdtscl... Will have to do some investigating... This actually 
affects whether or not we bother with hrtimers as suggested above too, as 
LIRC_SERIAL_TRANSMITTER_LATENCY is not used at all in the USE_RDTSC case.

> > +static irqreturn_t irq_handler(int i, void *blah)
> > +{
> > +	struct timeval tv;
> > +	int status, counter, dcd;
> > +	long deltv;
> > +	int data;
> > +	static int last_dcd = -1;
> > +
> > +	if ((sinp(UART_IIR) & UART_IIR_NO_INT)) {
> > +		/* not our interrupt */
> > +		return IRQ_RETVAL(IRQ_NONE);
> > +	}
>
> That should just be IRQ_NONE, no?

Yeah, looks like it. Done.

> > +static void hardware_init_port(void)
> > +{
> > +	unsigned long flags;
> > +	local_irq_save(flags);
>
> That won't help you if an interrupt is handled by another processor.  This
> needs proper locking, methinks.

Yeah, working on implementing locking right now.

> Nothing in this function does anything to assure itself that the port
> actually exists and is the right kind of hardware.  Maybe that can't really
> be done with this kind of device?

We should probably try to make sure the port actually exists, but I don't 
think there's a whole lot (if anything) we can do as far as verifying the 
device itself.

> > +static int init_port(void)
> > +{
>
>  ...
>
> > +	if (sense == -1) {
> > +		/* wait 1/2 sec for the power supply */
> > +
> > +		set_current_state(TASK_INTERRUPTIBLE);
> > +		schedule_timeout(HZ/2);
>
> msleep(), maybe?

Yeah, looks like it.

> > +static int set_use_inc(void *data)
> > +{
> > +	int result;
> > +	unsigned long flags;
> > +
> > +	/* Init read buffer. */
> > +	if (lirc_buffer_init(&rbuf, sizeof(int), RBUF_LEN) < 0)
> > +		return -ENOMEM;
> > +
> > +	/* initialize timestamp */
> > +	do_gettimeofday(&lasttv);
> > +
> > +	result = request_irq(irq, irq_handler,
> > +			   IRQF_DISABLED | (share_irq ? IRQF_SHARED : 0),
> > +			   LIRC_DRIVER_NAME, (void *)&hardware);
> > +
> > +	switch (result) {
> > +	case -EBUSY:
> > +		printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n", irq);
> > +		lirc_buffer_free(&rbuf);
> > +		return -EBUSY;
> > +	case -EINVAL:
> > +		printk(KERN_ERR LIRC_DRIVER_NAME
> > +		       ": Bad irq number or handler\n");
> > +		lirc_buffer_free(&rbuf);
> > +		return -EINVAL;
> > +	default:
> > +		dprintk("Interrupt %d, port %04x obtained\n", irq,
> > io);
> > +		break;
> > +	};
> > +
> > +	local_irq_save(flags);
> > +
> > +	/* Set DLAB 0. */
> > +	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
> > +
> > +	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
> > +
> > +	local_irq_restore(flags);
> > +
> > +	return 0;
> > +}
>
> OK, so set_use_inc() really is just an open() function.  It still seems
> like a strange duplication.

Going to let the duplication be for the moment, since I don't know the history 
behind why there's duplication, and there are enough other mountains to climb 
first... :)

> Again, local_irq_save() seems insufficient here.  You need a lock to
> serialize access to the hardware.

Will do.

-- 
Jarod Wilson
jarod@redhat.com

