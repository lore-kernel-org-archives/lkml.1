Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbXLLJua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbXLLJua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbXLLJuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:50:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438AbXLLJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:50:18 -0500
Date: Wed, 12 Dec 2007 01:49:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: chripell@gmail.com
Cc: linux-kernel@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>
Subject: Re: [PATCH] max3100 driver
Message-Id: <20071212014941.9bc998bf.akpm@linux-foundation.org>
In-Reply-To: <11968504052105-git-send-email-chripell@gmail.com>
References: <11968504052105-git-send-email-chripell@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Dec 2007 11:26:45 +0100 chripell@gmail.com wrote:

> This patch adds support for the MAX3100 SPI UART.
> 

Doesn't compile on x86_64:

drivers/serial/max3100.c: In function 'startup':
drivers/serial/max3100.c:706: error: 'IRQT_FALLING' undeclared (first use in this function)
drivers/serial/max3100.c:706: error: (Each undeclared identifier is reported only once
drivers/serial/max3100.c:706: error: for each function it appears in.)
drivers/serial/max3100.c:708: error: 'IRQT_LOW' undeclared (first use in this function)

>  include/linux/serial_max3100.h |   25 +
>  4 files changed, 993 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 81b52b7..4e7111b 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -461,6 +461,13 @@ config SERIAL_S3C2410_CONSOLE
>  	  your boot loader about how to pass options to the kernel at
>  	  boot time.)
>  
> +config SERIAL_MAX3100
> +        tristate "MAX3100 support"
> +        depends on SPI
> +        help
> +          MAX3100 chip support
> +

Putting a depends on ARM in here might be sufficient.

> +++ b/drivers/serial/max3100.c
> @@ -0,0 +1,960 @@
> +
> +/* 
> + *
> + *  Copyright (C) 2007 Christian Pellegrin <chripell@evolware.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * version 0.1  31/5/2006   first public release
> + * version 0.2  11/11/2007  ported to kernel 2.6.23

Normally we skip info like this - it's all in the git tree, in better form.

> +static struct tty_driver *serial_driver = NULL;

This initialisation is unneeded and is undesirable because it increases the
kernel image's .data.

Please run the diff through scripts/checkpatch.pl.  It would have mentioned
this, and a whole lot of other things, too.

> +/* global since we do register the driver only once */

I assume this comment refers to the preceding line?

Please put comments like this above the code which they're talking about. 
Doing it this way is quite confusing to kernel developers.

> +#define MAX_MAX3100 4 		/* 4 MAX3100s should be enough for everyone */
> +static struct max3100_port_s * max3100s[MAX_MAX3100]; /* the chips */

No space after the *, please (checkpatch should detect this).

> +
> +#define MAX3100_TX_BUF_N 16
> +/* our buffer for sendind chars */

Typo.  Misplaced comment.

> +#define MAX3100_FLIP_EVERY 8
> +/* how many chars we wait befor flipping tty buffer */

Misplaced comment.

> +static void irq_state(struct max3100_port_s *s, int on) {

That brace should go in column 1.

> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&s->irq_lock, flags);
> +	if (s->irq_status != on) {
> +		if (on) {
> +			enable_irq(s->irq);
> +		}
> +		else {
> +			disable_irq(s->irq);
> +		}

The `else' should be like this:

	} else {

and as the brqaces are unneeded we'd prefer

		if (on)
			enable_irq(s->irq);
		else
			disable_irq(s->irq);

but checkpatch knows about this too.

> +		s->irq_status = on;
> +	}
> +	spin_unlock_irqrestore(&s->irq_lock, flags);		
> +}
> +
> +
> +static int max3100_do_parity(struct max3100_port_s *s, u16 c)
> +{
> +	int parity;
> +	int i,n;
> +
> +	if (s->parity & MAX3100_PARITY_ODD)
> +		parity = 0;
> +	else
> +		parity = 1;
> +	
> +	if (s->parity & MAX3100_7BIT)
> +		n = 7;
> +	else
> +		n = 8;
> +
> +	for(i=0;i<n;i++) {
> +		parity = parity ^ ( (c>>i) & 1);
> +	}

Those three lines will cause a checkpatch frenzy.

> +	return parity;
> +}
> +
> +static inline int max3100_check_parity(struct max3100_port_s *s, u16 c)
> +{
> +	return max3100_do_parity(s, c) == ( (c>>9) & 1);
> +}
> +
> +static inline void max3100_calc_parity(struct max3100_port_s *s, u16 *c)
> +{
> +	*c &=  ~MAX3100_PT;
> +	*c |= max3100_do_parity(s, *c)<<8;
> +}
> +
> +
> +static void max3100_work(struct work_struct *w);
> +
> +static inline void max3100_dowork(struct max3100_port_s *s)
> +{
> +	if (!s->force_end_work) {
> +		PREPARE_WORK(&s->work, max3100_work);
> +		queue_work(s->workqueue, &s->work);
> +	}
> +}

You'd be surprised how small an inlined function can be and yet still be
too large to be inlined (if that sentence makes sense).

I'd suggest that you try removing inlines then recmpiling and doing `size
drivers/serial/max3100.o'.  You'll probably find that most of them are
either unneeded or plain wrong.

> +static int max3100_sr(struct max3100_port_s *s, u16 tx, u16 *rx, int push)
> +{
> +	/* note: we suppose that the T bit fron conf_status is in sync
> +	 * with the hw one, so all the communication must go through
> +	 * this function */
> +	struct spi_message	message;
> +	struct spi_transfer	x;
> +	int status, flag;
> +	u16 etx,erx;
> +	int got_char = 0;
> +
> +	down(&s->spi_txrx);

The semaphore API is deprecated unless one is actually using its counting
feature.  Please prefer to use struct mutex.

I'd have expected checkpatch to warn about that too...

> +	if (s->loopback) {
> +		if ((tx & MAX3100_CMD) == MAX3100_RC)
> +			tx |= 1;
> +	}
> +	etx = htons(tx);
> +	spi_message_init(&message);
> +	memset(&x, 0, sizeof(x));
> +	x.tx_buf = &etx;
> +	x.rx_buf = &erx;
> +	x.len = 2;

`x' is a truly awful identifier.  Please try to come up with something
which means something?

> +	spi_message_add_tail(&x, &message);
> +	status = spi_sync(s->spi, &message);
> +	if (status) {
> +		dev_warn(&s->spi->dev, "error while calling spi_sync\n");
> +		return 0;
> +	}
> +	*rx = ntohs(erx);
> +	//printk("%04x - %04x\n", tx, *rx);

checkpatch won't like the c99-style comment.

> +	if ((tx & MAX3100_CMD) == MAX3100_RD ||
> +	    (tx & MAX3100_CMD) == MAX3100_WD) {
> +		s->last_cts_rx = *rx;
> +	}
> +
> +	if (*rx & MAX3100_R && 
> +	    ((tx & MAX3100_CMD) == MAX3100_RD ||
> +	     (tx & MAX3100_CMD) == MAX3100_WD)) {
> +		unsigned int flags;
> +			
> +		got_char = 1;
> +		if (tty_buffer_request_room(s->tty, 1) == 0) {
> +			dev_warn(&s->spi->dev, "no room in tty buffer\n");
> +			tty_schedule_flip(s->tty);
> +		}
> +
> +		flag = TTY_NORMAL;
> +		if (*rx & MAX3100_RAFE) {
> +			s->port.icount.frame++;
> +			flags = TTY_FRAME;
> +		}
> +		if (s->parity & MAX3100_PARITY_ON && max3100_check_parity(s, *rx)) {
> +			s->port.icount.parity++;
> +			flags = TTY_PARITY;
> +		}
> +		tty_insert_flip_char(s->tty, *rx & MAX3100_DATA, flag);

Local variable 'flags' never gets used.  If it _did_ get used, you'd get a
used-uninitialised-variable warning.

> +	}
> +
> +	up(&s->spi_txrx);
> +
> +	if (push && got_char) {
> +		tty_schedule_flip(s->tty);
> +	}

unneeded braces.

> +	return got_char;
> +}
> +
> +
> +static void max3100_send_conf(struct max3100_port_s *s) 
> +{
> +	u16 tx=0,rx;
> +
> +	tx = MAX3100_WC | (s->conf & 0x0fff);
> +	max3100_sr(s, tx, &rx, 1);
> +}
> +
> +static inline int max3100_ok_to_send(struct max3100_port_s *s) 
> +{
> +	if (C_CRTSCTS(s->tty)) {
> +		if ((s->last_cts_rx & MAX3100_CTS) == 0)
> +			return 0;
> +	}
> +	return ! s->tx_stopped;
> +}
> +
> +static void max3100_work(struct work_struct *w)
> +{
> +	struct max3100_port_s *s = container_of(w, struct max3100_port_s, work);
> +	u16 tx,rx;
> +	unsigned long flags;
> +	int nchars;		/* number of char waiting in the send buf */
> +	int rxchars = 0;	/* chars received */
> +
> +	do {

local variable `flags' could be local to this block.  I think that
restricting variable scope in large functions like this improves
readability.

> +		tx = MAX3100_RD;
> +		rxchars += max3100_sr(s, tx, &rx, 0);
> +		/* rx a char so we get MAX3100_T and CTS current */
> +
> +		spin_lock_irqsave(&s->tx_buf_lock, flags);
> +		nchars = s->tx_buf_tot - s->tx_buf_cur;
> +		tx = MAX3100_WD | s->rts;
> +		tx |= s->tx_buf[s->tx_buf_cur];
> +		spin_unlock_irqrestore(&s->tx_buf_lock, flags);
> +
> +		if ((rx & MAX3100_T) &&	/* tx buffer empty*/
> +		    max3100_ok_to_send(s) &&  /* fw ctrl decision */
> +		    nchars > 0 && /* more to send */
> +		    ! s->force_end_work) {
> +			if (s->parity & MAX3100_PARITY_ON)
> +				max3100_calc_parity(s, &tx);
> +			rxchars += max3100_sr(s, tx, &rx, 0);
> +			nchars -= 1;
> +			spin_lock_irqsave(&s->tx_buf_lock, flags);
> +			s->tx_buf_cur += 1;
> +			spin_unlock_irqrestore(&s->tx_buf_lock, flags);
> +			if (nchars == 0) {
> +				tty_wakeup(s->tty);
> +			}
> +		}		    
> +		if (rxchars > MAX3100_FLIP_EVERY) {
> +			tty_schedule_flip(s->tty);
> +			rxchars = 0;
> +		}
> +	}
> +	while ((nchars > 0 || 	/* more to send */
> +		rx & MAX3100_R) && 	/* try to empy all the RX buffer */
> +	       ! s->force_end_work);
> +	if (rxchars) {
> +		tty_schedule_flip(s->tty);
> +	}
> +	if (! s->only_edge_irq && ! s->force_end_work) 

No space after the !, please (checkpatch)

This patch adds large amounts of trailing whitespace.  I always chop that
off, but it's best that it never arrives, please.

> +		irq_state(s, 1);		
> +}
> +
> +static irqreturn_t max3100_irq(int irqno, void *dev_id)
> +{
> +	struct max3100_port_s	*s = dev_id;
> +	
> +	if (! s->only_edge_irq)
> +		irq_state(s, 0); /* avoid irq storm */
> +	max3100_dowork(s);
> +	return IRQ_HANDLED;
> +}
> +
> +static void rs_stop(struct tty_struct *tty)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +
> +	s->tx_stopped = 1;
> +}
> +
> +static void rs_start(struct tty_struct *tty)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +
> +	s->tx_stopped = 0;
> +}
> +
> +static void rs_flush_chars(struct tty_struct *tty)
> +{
> +}
> +
> +static void rs_waint_until_sent(struct tty_struct *tty, int timeout)

waint?

> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	unsigned long jstop;
> +
> +	jstop = jiffies + timeout;
> +	do {
> +		if (s->tx_buf_tot == 0 || s->tx_buf_tot == s->tx_buf_cur)
> +			return;
> +		schedule();
> +	} while (!timeout || time_before(jiffies, jstop));
> +}

eek, that's a busy-wait.  Can something smarter be done here?

> +static void rs_flush_buffer(struct tty_struct *tty)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&s->tx_buf_lock, flags);
> +	s->tx_buf_cur = 0;
> +	s->tx_buf_tot = 0;
> +	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
> +}
> +
> +static int rs_write(struct tty_struct * tty,
> +		    const unsigned char *buf, int count)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;

Unneded cast of void*.  This is unsightly and defeats typechecking.  PLease
just remove the cast (several instances of this).

> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&s->tx_buf_lock, flags);
> +	if (s->tx_buf_cur < s->tx_buf_tot) {
> +		count = 0;
> +	}
> +	else {

checkpatch...

> +		if (count > MAX3100_TX_BUF_N)
> +			count = MAX3100_TX_BUF_N;
> +		memcpy(s->tx_buf, buf, count);
> +		s->tx_buf_cur = 0;
> +		s->tx_buf_tot = count;
> +	}
> +	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
> +	max3100_dowork(s);
> +	return count;
> +}
> +
> +static int rs_write_room(struct tty_struct *tty)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	int ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&s->tx_buf_lock, flags);
> +	if (s->tx_buf_cur < s->tx_buf_tot)
> +		ret = 0;
> +	else
> +		ret = MAX3100_TX_BUF_N;
> +	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
> +	return ret;
> +}
> +
> +static int rs_chars_in_buffer(struct tty_struct *tty)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	int ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&s->tx_buf_lock, flags);
> +	if (s->tx_buf_cur < s->tx_buf_tot)
> +		ret = MAX3100_TX_BUF_N;
> +	else
> +		ret = 0;
> +	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
> +	return ret;
> +}
> +
> +static void internal_throttle(struct tty_struct * tty, char ch, int rts)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	u16 tx=0,rx;
> +	int old_tx_stopped;
> +
> +	old_tx_stopped = s->tx_stopped;
> +	s->tx_stopped = 1;
> +	tx = MAX3100_RD;
> +	do {			/* wait fot tx buf empty */

typo in comment.

> +		max3100_sr(s, tx, &rx, 1);
> +	} while ((rx & MAX3100_T) == 0);

Another busy-wait.  Avoidable?

> +	if (I_IXOFF(tty)) {
> +		tx = MAX3100_WD | s->rts | (ch&0xff);
> +	}
> +	if (C_CRTSCTS(tty)) {
> +		s->rts = rts ? (MAX3100_RTS) : 0;
> +		tx =  MAX3100_WD | s->rts | MAX3100_TE;
> +	}	
> +	if (tx) {
> +		max3100_sr(s, tx, &rx, 1);
> +	}
> +	s->tx_stopped = old_tx_stopped;
> +}
> +
> +static void rs_throttle(struct tty_struct * tty)
> +{
> +	internal_throttle(tty, STOP_CHAR(tty), 0);
> +}
> +
> +static void rs_unthrottle(struct tty_struct * tty)
> +{
> +	internal_throttle(tty, START_CHAR(tty), 1);
> +}
> +
> +static int get_lsr_info(struct max3100_port_s *s, unsigned int *value)
> +{
> +	unsigned char status;
> +	u16 tx=0,rx;
> +
> +	tx = MAX3100_RD;
> +	max3100_sr(s, tx, &rx, 1);
> +	status = (rx & MAX3100_CTS) > 0;
> +	put_user(status,value);
> +	return 0;
> +}
> +
> +static int rs_ioctl(struct tty_struct *tty, struct file * file,
> +		    unsigned int cmd, unsigned long arg)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	int retval = 0;
> +
> +	switch (cmd) {
> +
> +	case TIOCSERGETLSR: /* Get line status register */
> +		if (access_ok(VERIFY_WRITE, (void *) arg, sizeof(unsigned int)))
> +			return get_lsr_info(s, (unsigned int *) arg);

get_lsr_info() uses put_user() which already does the access_ok() check, so
it should be removed from here.

get_lsr_info() should be changed to return the return value from put_user().

> +		return -EFAULT;
> +
> +	default:
> +		retval = -ENOIOCTLCMD ;
> +	}
> +	return retval;
> +}
> +
> +static void change_speed(struct max3100_port_s *s)
> +{
> +	unsigned cflag;
> +	unsigned i;
> +	u32 param_new;
> +	u32 param_mask;
> +
> +	if (!s->tty || !s->tty->termios)
> +		return;

Can this happen?

> +	cflag = s->tty->termios->c_cflag;
> +	param_new = param_mask = 0;
> +
> +	i = cflag & CBAUD;
> +	/* note: supposed 3.6864 Mhz xtal */
> +	switch(i) {
> +	case B300:
> +		if (s->crystal) {
> +			param_new = 16; 
> +		}
> +		else {
> +			dev_warn(&s->spi->dev, "unsupported baud rate!\n");
> +			param_new = 15; 
> +		}
> +		break;
> +	case B600:
> +		param_new = 15; 
> +		break;
> +	case B1200:
> +		param_new = 14; 
> +		break;
> +	case B2400:
> +		param_new = 13; 
> +		break;
> +	case B4800:
> +		param_new = 12; 
> +		break;
> +	case B9600:
> +		param_new = 11; 
> +		break;
> +	case B19200:
> +		param_new = 10; 
> +		break;
> +	case B38400:
> +		param_new = 9; 
> +		break;
> +	case B57600:
> +		param_new = 2; 
> +		break;
> +	case B115200:
> +		param_new = 1; 
> +		break;
> +	case B230400:
> +		if (s->crystal) {
> +			param_new = 1; 
> +			dev_warn(&s->spi->dev, "unsupported baud rate!\n");
> +		}
> +		else {
> +			param_new = 0; 
> +		}
> +		break;
> +	default:
> +		param_new = 1; 
> +		dev_warn(&s->spi->dev, "invalid baudrate\n");
> +	}
> +	param_new = (param_new - s->crystal) & MAX3100_BAUD;
> +	param_mask |= MAX3100_BAUD;
> +	
> +	if ((cflag & CSIZE) == CS8) {
> +		param_new &= ~MAX3100_L;
> +		s->parity &= ~MAX3100_7BIT;
> +	}
> +	else {
> +		param_new |= MAX3100_L;
> +		s->parity |= MAX3100_7BIT;
> +	}
> +	param_mask |= MAX3100_L;
> +
> +	if (cflag & CSTOPB)
> +		param_new |= MAX3100_ST;
> +	else
> +		param_new &= ~MAX3100_ST;
> +	param_mask |= MAX3100_ST;
> +
> +	if (cflag & PARENB) {
> +		param_new |= MAX3100_PE;
> +		s->parity |= MAX3100_PARITY_ON;
> +	}
> +	else {
> +		param_new &= ~MAX3100_PE;
> +		s->parity &= ~MAX3100_PARITY_ON;
> +	}
> +	param_mask |= MAX3100_PE;
> +
> +	if (cflag & PARODD) {
> +		s->parity |= MAX3100_PARITY_ODD;
> +	}
> +	else {
> +		s->parity &=~ MAX3100_PARITY_ODD;
> +	}

Lots of checkpatch fodder there.

> +	s->conf = (s->conf & ~param_mask) | (param_new & param_mask);
> +	max3100_send_conf(s);
> +
> +	return;
> +}
> +
> +
> +static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +
> +	if (tty->termios->c_cflag == old_termios->c_cflag)
> +		return;
> +
> +	change_speed(s);
> +
> +        if ((old_termios->c_cflag & CRTSCTS) &&
> +            !(tty->termios->c_cflag & CRTSCTS)) {
> +		max3100_dowork(s);
> +        }
> +}

Something went wrong with whitespace in rs_set_termios().

> +static void shutdown(struct max3100_port_s *s)
> +{
> +	s->force_end_work = 1;
> +	if (s->workqueue) {
> +		flush_workqueue(s->workqueue);	
> +		destroy_workqueue(s->workqueue);
> +	}
> +	if (s->irq) 
> +		free_irq(s->irq, s);
> +	kfree(s->tx_buf);
> +	s->tx_buf = NULL;
> +	if (s->tty)
> +		set_bit(TTY_IO_ERROR, &s->tty->flags);
> +}
> +
> +static void rs_hangup(struct tty_struct *tty)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;

unneeded cast..

> +	shutdown(s);
> +}
> +
> +static int startup(struct max3100_port_s *s)
> +{
> +	char b[10];
> +	s->tx_buf = kmalloc(MAX3100_TX_BUF_N, GFP_KERNEL);

Unchecked kmalloc().

> +	s->tx_buf_cur = 0;
> +	s->tx_buf_tot = 0;
> +
> +	s->force_end_work = 0;
> +	s->parity = 0;
> +	s->rts = 0;
> +	s->tx_stopped = 0;
> +	s->conf = MAX3100_RM;
> +
> +	sprintf(b, "max3100-%d", s->minor);
> +	s->workqueue = create_singlethread_workqueue(b);
> +	if (!s->workqueue) {
> +		dev_warn(&s->spi->dev, "cannot create workqueue\n");
> +		return -EBUSY;
> +	}
> +	INIT_WORK(&s->work, max3100_work);
> +
> +	s->irq_status = 1;	/* IRQS are on after request */
> +	if (request_irq(s->irq, max3100_irq, 0, "max3100", s) < 0) {

No need for IRQ sharing?

> +		dev_warn(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
> +		s->irq = 0;
> +		return -EBUSY;

We just leaked the memory at s->tx_buf.

> +	}
> +	if (s->only_edge_irq)
> +		set_irq_type(s->irq, IRQT_FALLING);
> +	else
> +		set_irq_type(s->irq, IRQT_LOW);
> +
> +	if (s->tty)
> +		clear_bit(TTY_IO_ERROR, &s->tty->flags);
> +
> +	change_speed(s);
> +
> +	if (s->loopback) {
> +		u16 tx,rx;
> +		tx = 0x4001;
> +		max3100_sr(s, tx, &rx, 1);
> +	}
> +
> +	return 0;
> +}
> +
> +int rs_open(struct tty_struct *tty, struct file * filp)
> +{
> +	struct max3100_port_s *s;
> +	int 			retval=0, line;
> +
> +	line = tty->index;
> +	
> +	if (line >= MAX_MAX3100 || line < 0)
> +		return -ENODEV;
> +
> +	s = max3100s[line];
> +
> +	if (!s) {
> +		printk("inexistent max3100 for index %d\n", line);

"Nonexistent"

> +		return -ENODEV;
> +	}
> +
> +	down(&s->sem);
> +
> +	s->ref_count++;
> +	
> +	if (s->ref_count == 1) {
> +		tty->driver_data = s;
> +		s->tty = tty;
> +
> +		retval = startup(s);
> +	}
> +
> +	up(&s->sem);
> +
> +	return retval;
> +}
> +
> +static void rs_close(struct tty_struct *tty, struct file * filp)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +
> +	down(&s->sem);
> +
> +	s->ref_count--;
> +	if (s->ref_count == 0) {
> +		rs_waint_until_sent(tty, 5*HZ);

hm, a magic constant.  What's happening here?

> +		shutdown(s);
> +	}
> +
> +	up(&s->sem);
> +}
> +
> +static int rs_tiocmget(struct tty_struct *tty, struct file *file)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	u16 tx,rx;
> +	unsigned int result = 0;

unneeded initialisation.

> +	tx =  MAX3100_RD;
> +	max3100_sr(s, tx, &rx, 1);
> +
> +	result =  ((s->rts) ? TIOCM_RTS : 0)
> +		| ((rx  & MAX3100_CTS) ? TIOCM_CTS : 0);
> +	return result;
> +}
> +
> +static int rs_tiocmset(struct tty_struct *tty, struct file *file,
> +			   unsigned int set, unsigned int clear)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) tty->driver_data;
> +	int old_rts = s->rts;
> +	u16 tx,rx;
> +
> +	if (set & TIOCM_RTS)
> +		s->rts = MAX3100_RTS;
> +	if (clear & TIOCM_RTS)
> +		s->rts = 0;
> +
> +	if (s->rts != old_rts) {
> +		tx =  MAX3100_WD | s->rts | MAX3100_TE;
> +		max3100_sr(s, tx, &rx, 1);
> +	}
> +	return 0;
> +}
> +
> +struct tty_operations rs_ops = {
> +	.open = rs_open,
> +	.close = rs_close,
> +	.write = rs_write,
> +	.flush_chars = rs_flush_chars,
> +	.wait_until_sent = rs_waint_until_sent,
> +	.write_room = rs_write_room,
> +	.chars_in_buffer = rs_chars_in_buffer,
> +	.flush_buffer = rs_flush_buffer,
> +	.ioctl = rs_ioctl,
> +	.throttle = rs_throttle,
> +	.unthrottle = rs_unthrottle,
> +	.set_termios = rs_set_termios,
> +	.stop = rs_stop,
> +	.start = rs_start,
> +	.hangup = rs_hangup,
> +	.tiocmget = rs_tiocmget,
> +	.tiocmset = rs_tiocmset,
> +};

Can this have static scope?

> +static int __devinit max3100_probe(struct spi_device *spi)
> +{
> +	int i;
> +	struct plat_max3100 *pdata;
> +
> +	if (!serial_driver) {
> +		serial_driver = alloc_tty_driver(MAX_MAX3100);
> +		if (!serial_driver) {
> +			printk("Cannot allocate serial driver\n");
> +			return -ENOMEM;
> +		}
> +
> +		serial_driver->name = "ttyMAX";
> +		serial_driver->driver_name = "ttyMAX";
> +		serial_driver->major = TTY_MAJOR;
> +		serial_driver->minor_start = 128; /* this should prevent clashes */
> +		serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
> +		serial_driver->subtype = SERIAL_TYPE_NORMAL;
> +		serial_driver->init_termios = tty_std_termios;
> +		serial_driver->init_termios.c_cflag = 
> +			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
> +		serial_driver->flags = TTY_DRIVER_REAL_RAW |TTY_DRIVER_DYNAMIC_DEV;
> +		tty_set_operations(serial_driver, &rs_ops);
> +
> +		if (tty_register_driver(serial_driver)) {
> +			put_tty_driver(serial_driver);
> +			printk("Couldn't register serial driver\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	for(i=0; i<MAX_MAX3100; i++) 
> +		if (!max3100s[i])
> +			break;
> +	if (i == MAX_MAX3100) {
> +		dev_warn(&spi->dev, "too many MAX3100 chips\n");
> +		return -ENOMEM;
> +	}
> +
> +	max3100s[i] = kmalloc(sizeof(struct max3100_port_s), GFP_KERNEL);
> +	if (!max3100s[i]) {
> +		dev_warn(&spi->dev, "kmalloc for max3100 structure %d failed!\n", i);
> +		return -ENOMEM;
> +	}
> +	memset(max3100s[i], 0, sizeof(struct max3100_port_s));

use kzalloc() above, remove the memset.

> +	max3100s[i]->spi = spi;
> +	max3100s[i]->irq = spi->irq;
> +	init_MUTEX(&max3100s[i]->sem);
> +	init_MUTEX(&max3100s[i]->spi_txrx);

Use struct mutex.

> +	spin_lock_init(&max3100s[i]->tx_buf_lock);
> +	spin_lock_init(&max3100s[i]->irq_lock);
> +	dev_set_drvdata(&spi->dev, &max3100s[i]);
> +	pdata = spi->dev.platform_data;
> +	max3100s[i]->crystal = pdata->crystal;
> +	max3100s[i]->loopback = pdata->loopback;
> +	max3100s[i]->only_edge_irq = pdata->only_edge_irq;
> +	max3100s[i]->minor = i;
> +	tty_register_device(serial_driver, i, &spi->dev);
> +
> +	return 0;
> +}
> +
> +static int __devexit max3100_remove(struct spi_device *spi)
> +{
> +	int i;
> +
> +	i = 0;
> +
> +	for(i=0; i<MAX_MAX3100; i++) 
> +		if (max3100s[i] && max3100s[i]->ref_count > 0)
> +			return -EBUSY;
> +
> +	for(i=0; i<MAX_MAX3100; i++) 
> +		if (max3100s[i]) {
> +			tty_unregister_device(serial_driver, i);
> +			kfree(max3100s[i]);
> +			max3100s[i] = NULL;
> +		}
> +
> +	if (serial_driver)
> +		tty_unregister_driver(serial_driver);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int max3100_suspend(struct spi_device *spi, pm_message_t state)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *) dev_get_drvdata(&spi->dev);
> +	u16 tx,rx;
> +
> +	tx = MAX3100_WC | MAX3100_SHDN;
> +	max3100_sr(s, tx, &rx, 0);
> +	return 0;
> +}
> +
> +static int max3100_resume(struct spi_device *spi) {
> +	struct max3100_port_s *s = (struct max3100_port_s *) dev_get_drvdata(&spi->dev);
> +
> +	max3100_send_conf(s);
> +
> +	return 0;
> +}
> +
> +#else
> +#define max3100_suspend NULL
> +#define max3100_resume  NULL
> +#endif
> +
> +static struct spi_driver max3100_driver = {
> +	.driver = {
> +		.name		= "max3100",
> +		.bus		= &spi_bus_type,
> +		.owner		= THIS_MODULE,
> +	},
> +
> +	.probe		= max3100_probe,
> +	.remove		= __devexit_p(max3100_remove),
> +	.suspend	= max3100_suspend,
> +	.resume		= max3100_resume,	
> +};
> +
> +
> +static int __init max3100_init(void)
> +{
> +	return spi_register_driver(&max3100_driver);
> +}
> +module_init(max3100_init);
> +
> +static void __exit max3100_exit(void)
> +{
> +	spi_unregister_driver(&max3100_driver);
> +}
> +module_exit(max3100_exit);
> +
> +MODULE_DESCRIPTION("MAX3100 driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/serial_max3100.h b/include/linux/serial_max3100.h
> new file mode 100644
> index 0000000..eefac54
> --- /dev/null
> +++ b/include/linux/serial_max3100.h
> @@ -0,0 +1,25 @@
> +

Stray blank line at start of file(s)

> +/* 
> + *
> + *  Copyright (C) 2007 Christian Pellegrin
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +
> +#ifndef _LINUX_SERIAL_MAX3100_H
> +#define _LINUX_SERIAL_MAX3100_H 1
> +
> +struct plat_max3100 {
> +	int loopback;
> +/* force MAX3100 in loopback */
> +	int crystal;
> +/* 0 for 3.6864 Mhz, 1 for 1.8432  */
> +	int only_edge_irq;
> +/* for archs like PXA with only edge irqs */
> +};

Does this header file need to exist?  afaict plat_max3100 is only used by
drivers/serial/max3100.c and hence could be defined there?

