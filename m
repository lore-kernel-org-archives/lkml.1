Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYIIQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYIIQOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYIIQO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:14:28 -0400
Received: from vena.lwn.net ([206.168.112.25]:57279 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYIIQO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:14:26 -0400
Date: Tue, 9 Sep 2008 10:14:22 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device
 driver
Message-ID: <20080909101422.329bd351@bike.lwn.net>
In-Reply-To: <1220933164-10160-3-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<1220933164-10160-3-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config LIRC_SERIAL
> +	tristate "Homebrew Serial Port Receiver"
> +	default n
> +	depends on LIRC_DEV
> +	help
> +	  Driver for Homebrew Serial Port Receivers

What receivers might these be?  Do any actually exist?

> +#ifdef LIRC_SERIAL_IRDEO
> +static int type = LIRC_IRDEO;
> +#elif defined(LIRC_SERIAL_IRDEO_REMOTE)
> +static int type = LIRC_IRDEO_REMOTE;
> +#elif defined(LIRC_SERIAL_ANIMAX)
> +static int type = LIRC_ANIMAX;
> +#elif defined(LIRC_SERIAL_IGOR)
> +static int type = LIRC_IGOR;
> +#elif defined(LIRC_SERIAL_NSLU2)
> +static int type = LIRC_NSLU2;
> +#else
> +static int type = LIRC_HOMEBREW;
> +#endif

So where do all these LIRC_SERIAL_* macros come from?  I can't really tell
what this bunch of ifdeffery is doing or how one might influence it.

> +
> +static struct lirc_serial hardware[] = {
> +	/* home-brew receiver/transmitter */
> +	{
> +		UART_MSR_DCD,
> +		UART_MSR_DDCD,
> +		UART_MCR_RTS|UART_MCR_OUT2|UART_MCR_DTR,
> +		UART_MCR_RTS|UART_MCR_OUT2,
> +		send_pulse_homebrew,
> +		send_space_homebrew,
> +		(
> +#ifdef LIRC_SERIAL_TRANSMITTER
> +		 LIRC_CAN_SET_SEND_DUTY_CYCLE|
> +		 LIRC_CAN_SET_SEND_CARRIER|
> +		 LIRC_CAN_SEND_PULSE|
> +#endif
> +		 LIRC_CAN_REC_MODE2)
> +	},

It would be really nice to use the .field=value structure initialization
conventions here.

> +#if defined(__i386__)
> +/*
> +  From:
> +  Linux I/O port programming mini-HOWTO
> +  Author: Riku Saikkonen <Riku.Saikkonen@hut.fi>
> +  v, 28 December 1997
> +
> +  [...]
> +  Actually, a port I/O instruction on most ports in the 0-0x3ff range
> +  takes almost exactly 1 microsecond, so if you're, for example,using
> +  the parallel port directly, just do additional inb()s from that port
> +  to delay.
> +  [...]
> +*/
> +/* transmitter latency 1.5625us 0x1.90 - this figure arrived at from
> + * comment above plus trimming to match actual measured frequency.
> + * This will be sensitive to cpu speed, though hopefully most of the 1.5us
> + * is spent in the uart access.  Still - for reference test machine was a
> + * 1.13GHz Athlon system - Steve
> + */
> +
> +/* changed from 400 to 450 as this works better on slower machines;
> +   faster machines will use the rdtsc code anyway */
> +
> +#define LIRC_SERIAL_TRANSMITTER_LATENCY 450
> +
> +#else
> +
> +/* does anybody have information on other platforms ? */
> +/* 256 = 1<<8 */
> +#define LIRC_SERIAL_TRANSMITTER_LATENCY 256
> +
> +#endif  /* __i386__ */

This is a little scary.  Maybe hrtimers would be a better way of handling
your timing issues?

> +static inline unsigned int sinp(int offset)
> +{
> +#if defined(LIRC_ALLOW_MMAPPED_IO)
> +	if (iommap != 0) {
> +		/* the register is memory-mapped */
> +		offset <<= ioshift;
> +		return readb(io + offset);
> +	}
> +#endif
> +	return inb(io + offset);
> +}

This all looks like a reimplementation of ioport_map() and the associated
ioread*() and iowrite*() functions...?

> +#ifdef USE_RDTSC
> +/* Version that uses Pentium rdtsc instruction to measure clocks */
> +
> +/* This version does sub-microsecond timing using rdtsc instruction,
> + * and does away with the fudged LIRC_SERIAL_TRANSMITTER_LATENCY
> + * Implicitly i586 architecture...  - Steve
> + */
> +
> +static inline long send_pulse_homebrew_softcarrier(unsigned long length) 
> +{
> +	int flag;
> +	unsigned long target, start, now;
> +
> +	/* Get going quick as we can */
> +	rdtscl(start); on();
> +	/* Convert length from microseconds to clocks */
> +	length *= conv_us_to_clocks;
> +	/* And loop till time is up - flipping at right intervals */
> +	now = start;
> +	target = pulse_width;
> +	flag = 1;
> +	while ((now-start) < length) {
> +		/* Delay till flip time */
> +		do {
> +			rdtscl(now);
> +		} while ((now-start) < target);

This looks like a hard busy wait, without even an occasional, polite,
cpu_relax() call.  There's got to be a better way?

The i2c code has the result of a lot of bit-banging work, I wonder if
there's something there which could be helpful here.

> +static irqreturn_t irq_handler(int i, void *blah)
> +{
> +	struct timeval tv;
> +	int status, counter, dcd;
> +	long deltv;
> +	int data;
> +	static int last_dcd = -1;
> +
> +	if ((sinp(UART_IIR) & UART_IIR_NO_INT)) {
> +		/* not our interrupt */
> +		return IRQ_RETVAL(IRQ_NONE);
> +	}

That should just be IRQ_NONE, no?

> +static void hardware_init_port(void)
> +{
> +	unsigned long flags;
> +	local_irq_save(flags);

That won't help you if an interrupt is handled by another processor.  This
needs proper locking, methinks.

Nothing in this function does anything to assure itself that the port
actually exists and is the right kind of hardware.  Maybe that can't really
be done with this kind of device?

> +static int init_port(void)
> +{
 ...
> +	if (sense == -1) {
> +		/* wait 1/2 sec for the power supply */
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(HZ/2);

msleep(), maybe?

> +static int set_use_inc(void *data)
> +{
> +	int result;
> +	unsigned long flags;
> +
> +	/* Init read buffer. */
> +	if (lirc_buffer_init(&rbuf, sizeof(int), RBUF_LEN) < 0)
> +		return -ENOMEM;
> +
> +	/* initialize timestamp */
> +	do_gettimeofday(&lasttv);
> +
> +	result = request_irq(irq, irq_handler,
> +			   IRQF_DISABLED | (share_irq ? IRQF_SHARED : 0),
> +			   LIRC_DRIVER_NAME, (void *)&hardware);
> +
> +	switch (result) {
> +	case -EBUSY:
> +		printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n", irq);
> +		lirc_buffer_free(&rbuf);
> +		return -EBUSY;
> +	case -EINVAL:
> +		printk(KERN_ERR LIRC_DRIVER_NAME
> +		       ": Bad irq number or handler\n");
> +		lirc_buffer_free(&rbuf);
> +		return -EINVAL;
> +	default:
> +		dprintk("Interrupt %d, port %04x obtained\n", irq,
> io);
> +		break;
> +	};
> +
> +	local_irq_save(flags);
> +
> +	/* Set DLAB 0. */
> +	soutp(UART_LCR, sinp(UART_LCR) & (~UART_LCR_DLAB));
> +
> +	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
> +
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}

OK, so set_use_inc() really is just an open() function.  It still seems
like a strange duplication.

Again, local_irq_save() seems insufficient here.  You need a lock to
serialize access to the hardware.

jon
