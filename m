Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXKBKjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXKBKjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXKBKjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:39:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:12452 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXKBKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fWjTBN8k8Sne55djdC7qOHG2hNfTcK8NFFo2R49AGmwM9BHXz5IxHGrhCEno095bz2vul/ZMDKQ9UZsgZIInT3k3qqJwCZ1ZPk9mlf0Uhb1IMx6Fj37R5NvLll36XhXwdyAb4UauRQOSOhr7ApsU+XKcGKD9rrvmv8/61D6ghr8=
Message-ID: <472AFE4D.5030308@gmail.com>
Date: Fri, 02 Nov 2007 11:39:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRISv10 serial driver rewrite
References: <20071102093432.GD7621@axis.com>
In-Reply-To: <20071102093432.GD7621@axis.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2007 10:34 AM, Jesper Nilsson wrote:
> Resubmission of the new and improved serial driver for CRISv10,
> this time with both patches in the same mail and with hopefully
> useful subject.
> 
> - Removed CVS tags.
> - Removed defines and comments for CRIS_BUF_SIZE and TTY_THRESHOLD_THROTTLE
>   (no longer used).
> - Merge of CRISv10 from Axis internal CVS.
[...]
>  #ifdef SERIAL_DEBUG_IO
> @@ -1440,12 +1094,11 @@ e100_rts(struct e100_serial *info, int set)
>  {
>  #ifndef CONFIG_SVINTO_SIM
>  	unsigned long flags;
> -	save_flags(flags);
> -	cli();
> +	local_irq_save(flags);

Is this enough? Don't you need also spin lock (i.e. spin_lock_irqsave())?

>  	info->rx_ctrl &= ~E100_RTS_MASK;
>  	info->rx_ctrl |= (set ? 0 : E100_RTS_MASK);  /* RTS is active low */
>  	info->port[REG_REC_CTRL] = info->rx_ctrl;
> -	restore_flags(flags);
> +	local_irq_restore(flags);
>  #ifdef SERIAL_DEBUG_IO
>  	printk("ser%i rts %i\n", info->line, set);
>  #endif

[...]

> @@ -4434,7 +3941,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
>  	if (tty_hung_up_p(filp) ||
>  	    (info->flags & ASYNC_CLOSING)) {
>  		if (info->flags & ASYNC_CLOSING)
> -			interruptible_sleep_on(&info->close_wait);
> +			wait_event_interruptible(info->close_wait, 0);

Aiee, this is nonsense, 0 will never be 1, only signal will stop this, use
completion instead.

>  #ifdef SERIAL_DO_RESTART
>  		if (info->flags & ASYNC_HUP_NOTIFY)
>  			return -EAGAIN;
> @@ -4472,21 +3979,19 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
>  	printk("block_til_ready before block: ttyS%d, count = %d\n",
>  	       info->line, info->count);
>  #endif
> -	save_flags(flags);
> -	cli();
> +	local_irq_save(flags);
>  	if (!tty_hung_up_p(filp)) {
>  		extra_count++;
>  		info->count--;
>  	}
> -	restore_flags(flags);
> +	local_irq_restore(flags);
>  	info->blocked_open++;
>  	while (1) {
> -		save_flags(flags);
> -		cli();
> +		local_irq_save(flags);
>  		/* assert RTS and DTR */
>  		e100_rts(info, 1);
>  		e100_dtr(info, 1);
> -		restore_flags(flags);
> +		local_irq_restore(flags);
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		if (tty_hung_up_p(filp) ||
>  		    !(info->flags & ASYNC_INITIALIZED)) {
> @@ -4538,9 +4043,9 @@ rs_open(struct tty_struct *tty, struct file * filp)
>  	struct e100_serial	*info;
>  	int 			retval, line;
>  	unsigned long           page;
> +	int                     allocated_resources = 0;
>  
>  	/* find which port we want to open */
> -
>  	line = tty->index;
>  
>  	if (line < 0 || line >= NR_PORTS)
> @@ -4581,7 +4086,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
>  	if (tty_hung_up_p(filp) ||
>  	    (info->flags & ASYNC_CLOSING)) {
>  		if (info->flags & ASYNC_CLOSING)
> -			interruptible_sleep_on(&info->close_wait);
> +			wait_event_interruptible(info->close_wait, 0);

also here.

>  #ifdef SERIAL_DO_RESTART
>  		return ((info->flags & ASYNC_HUP_NOTIFY) ?
>  			-EAGAIN : -ERESTARTSYS);
> @@ -4591,19 +4096,118 @@ rs_open(struct tty_struct *tty, struct file * filp)
>  	}
>  
>  	/*
> +	 * If DMA is enabled try to allocate the irq's.
> +	 */
> +	if (info->count == 1) {
> +		allocated_resources = 1;
> +		if (info->dma_in_enabled) {
> +			if (request_irq(info->dma_in_irq_nbr,
> +					rec_interrupt,
> +					info->dma_in_irq_flags,
> +					info->dma_in_irq_description,
> +					info)) {
> +				printk(KERN_WARNING "DMA irq '%s' busy; "
> +					"falling back to non-DMA mode\n",
> +					info->dma_in_irq_description);
> +				/* Make sure we never try to use DMA in */
> +				/* for the port again. */
> +				info->dma_in_enabled = 0;
> +			} else if (cris_request_dma(info->dma_in_nbr,
> +					info->dma_in_irq_description,
> +					DMA_VERBOSE_ON_ERROR,
> +					info->dma_owner)) {
> +				free_irq(info->dma_in_irq_nbr, info);
> +				printk(KERN_WARNING "DMA '%s' busy; "
> +					"falling back to non-DMA mode\n",
> +					info->dma_in_irq_description);
> +				/* Make sure we never try to use DMA in */
> +				/* for the port again. */
> +				info->dma_in_enabled = 0;
> +			}
> +#ifdef SERIAL_DEBUG_OPEN
> +			else
> +				printk(KERN_DEBUG "DMA irq '%s' allocated\n",
> +					info->dma_in_irq_description);
> +#endif
> +		}
> +		if (info->dma_out_enabled) {
> +			if (request_irq(info->dma_out_irq_nbr,
> +					       tr_interrupt,
> +					       info->dma_out_irq_flags,
> +					       info->dma_out_irq_description,
> +					       info)) {
> +				printk(KERN_WARNING "DMA irq '%s' busy; "
> +					"falling back to non-DMA mode\n",
> +					info->dma_out_irq_description);
> +				/* Make sure we never try to use DMA out */
> +				/* for the port again. */
> +				info->dma_out_enabled = 0;
> +			} else if (cris_request_dma(info->dma_out_nbr,
> +					     info->dma_out_irq_description,
> +					     DMA_VERBOSE_ON_ERROR,
> +					     info->dma_owner)) {
> +				free_irq(info->dma_out_irq_nbr, info);
> +				printk(KERN_WARNING "DMA '%s' busy; "
> +					"falling back to non-DMA mode\n",
> +					info->dma_out_irq_description);
> +				/* Make sure we never try to use DMA out */
> +				/* for the port again. */
> +				info->dma_out_enabled = 0;
> +			}
> +#ifdef SERIAL_DEBUG_OPEN
> +			else
> +				printk(KERN_DEBUG "DMA irq '%s' allocated\n",
> +					info->dma_out_irq_description);
> +#endif
> +		}
> +	}
> +
> +	/*
>  	 * Start up the serial port
>  	 */
>  
>  	retval = startup(info);
> -	if (retval)
> +	if (retval) {
> +		if (allocated_resources) {
> +			if (info->dma_out_enabled) {
> +				cris_free_dma(info->dma_out_nbr,
> +					info->dma_out_irq_description);
> +				free_irq(info->dma_out_irq_nbr,
> +					 info);
> +			}
> +			if (info->dma_in_enabled) {
> +				cris_free_dma(info->dma_in_nbr,
> +					info->dma_in_irq_description);
> +				free_irq(info->dma_in_irq_nbr,
> +					 info);
> +			}
> +		}

You maybe want to create a function for this deinit invoked from more places in
the new code.

> +		/* FIXME Decrease count info->count here too? */
>  		return retval;
>  
> +	}
> +
> +
>  	retval = block_til_ready(tty, filp, info);
>  	if (retval) {
>  #ifdef SERIAL_DEBUG_OPEN
>  		printk("rs_open returning after block_til_ready with %d\n",
>  		       retval);
>  #endif
> +		if (allocated_resources) {
> +			if (info->dma_out_enabled) {
> +				cris_free_dma(info->dma_out_nbr,
> +					info->dma_out_irq_description);
> +				free_irq(info->dma_out_irq_nbr,
> +					info);
> +			}
> +			if (info->dma_in_enabled) {
> +				cris_free_dma(info->dma_in_nbr,
> +					info->dma_in_irq_description);
> +				free_irq(info->dma_in_irq_nbr,
> +					info);
> +			}
> +		}

...

>  		return retval;
>  	}
>  
> @@ -4793,6 +4397,8 @@ static const struct tty_operations rs_ops = {
>  	.send_xchar = rs_send_xchar,
>  	.wait_until_sent = rs_wait_until_sent,
>  	.read_proc = rs_read_proc,
> +	.tiocmget = rs_tiocmget,
> +	.tiocmset = rs_tiocmset
>  };
>  
>  static int __init
> @@ -4812,7 +4418,26 @@ rs_init(void)
>  #if !defined(CONFIG_ETRAX_SERIAL_FAST_TIMER)
>  	init_timer(&flush_timer);
>  	flush_timer.function = timed_flush_handler;

Side note, this should be setup_timer without accessing .function.

> -	mod_timer(&flush_timer, jiffies + CONFIG_ETRAX_SERIAL_RX_TIMEOUT_TICKS);
> +	mod_timer(&flush_timer, jiffies + 5);
> +#endif
> +
> +#if defined(CONFIG_ETRAX_RS485)
> +#if defined(CONFIG_ETRAX_RS485_ON_PA)
> +	if (cris_io_interface_allocate_pins(if_ser0, 'a', rs485_pa_bit,
> +			rs485_pa_bit)) {
> +		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
> +			"RS485 pin\n");
> +		return -EBUSY;
> +	}
> +#endif
> +#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
> +	if (cris_io_interface_allocate_pins(if_ser0, 'g', rs485_pa_bit,
> +			rs485_port_g_bit)) {
> +		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
> +			"RS485 pin\n");
> +		return -EBUSY;
> +	}
> +#endif
>  #endif
>  
>  	/* Initialize the tty_driver structure */
> @@ -4839,6 +4464,16 @@ rs_init(void)
>  	/* do some initializing for the separate ports */
>  
>  	for (i = 0, info = rs_table; i < NR_PORTS; i++,info++) {
> +		if (info->enabled) {
> +			if (cris_request_io_interface(info->io_if,
> +					info->io_if_description)) {
> +				printk(KERN_CRIT "ETRAX100LX async serial: "
> +					"Could not allocate IO pins for "
> +					"%s, port %d\n",
> +					info->io_if_description, i);
> +				info->enabled = 0;
> +			}
> +		}
>  		info->uses_dma_in = 0;
>  		info->uses_dma_out = 0;
>  		info->line = i;
> @@ -4872,7 +4507,7 @@ rs_init(void)
>  		info->rs485.delay_rts_before_send = 0;
>  		info->rs485.enabled = 0;
>  #endif
> -		INIT_WORK(&info->work, do_softint, info);
> +		INIT_WORK(&info->work, do_softint);
>  
>  		if (info->enabled) {
>  			printk(KERN_INFO "%s%d at 0x%x is a builtin UART with DMA\n",
> @@ -4890,64 +4525,17 @@ rs_init(void)
>  #endif
>  
>  #ifndef CONFIG_SVINTO_SIM
> +#ifndef CONFIG_ETRAX_KGDB
>  	/* Not needed in simulator.  May only complicate stuff. */
>  	/* hook the irq's for DMA channel 6 and 7, serial output and input, and some more... */
>  
> -	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial ", NULL))
> -		panic("irq8");
> +	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt,
> +			IRQF_SHARED | IRQF_DISABLED, "serial ", driver))
> +		panic("%s: Failed to request irq8", __FUNCTION__);

Is the panic needed here? Can't the cris architecture live without the driver?

>  
> -#ifdef CONFIG_ETRAX_SERIAL_PORT0
> -#ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA6_OUT
> -	if (request_irq(SER0_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_DISABLED, "serial 0 dma tr", NULL))
> -		panic("irq22");
> -#endif
> -#ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA7_IN
> -	if (request_irq(SER0_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_DISABLED, "serial 0 dma rec", NULL))
> -		panic("irq23");
> -#endif
> -#endif
> -
> -#ifdef CONFIG_ETRAX_SERIAL_PORT1
> -#ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA8_OUT
> -	if (request_irq(SER1_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_DISABLED, "serial 1 dma tr", NULL))
> -		panic("irq24");
> -#endif
> -#ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA9_IN
> -	if (request_irq(SER1_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_DISABLED, "serial 1 dma rec", NULL))
> -		panic("irq25");
> -#endif
> -#endif
> -#ifdef CONFIG_ETRAX_SERIAL_PORT2
> -	/* DMA Shared with par0 (and SCSI0 and ATA) */
> -#ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA2_OUT
> -	if (request_irq(SER2_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 2 dma tr", NULL))
> -		panic("irq18");
> -#endif
> -#ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA3_IN
> -	if (request_irq(SER2_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 2 dma rec", NULL))
> -		panic("irq19");
> -#endif
> -#endif
> -#ifdef CONFIG_ETRAX_SERIAL_PORT3
> -	/* DMA Shared with par1 (and SCSI1 and Extern DMA 0) */
> -#ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA4_OUT
> -	if (request_irq(SER3_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 3 dma tr", NULL))
> -		panic("irq20");
> -#endif
> -#ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA5_IN
> -	if (request_irq(SER3_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 3 dma rec", NULL))
> -		panic("irq21");
> -#endif
> -#endif
> -
> -#ifdef CONFIG_ETRAX_SERIAL_FLUSH_DMA_FAST
> -	if (request_irq(TIMER1_IRQ_NBR, timeout_interrupt, IRQF_SHARED | IRQF_DISABLED,
> -		       "fast serial dma timeout", NULL)) {
> -		printk(KERN_CRIT "err: timer1 irq\n");
> -	}
>  #endif
>  #endif /* CONFIG_SVINTO_SIM */
> -	debug_write_function = rs_debug_write_function;
> +
>  	return 0;
>  }
>  
> --- /dev/null	2007-10-06 06:38:38.348072750 +0200
> +++ linux-2.6.23/drivers/serial/crisv10.h	2007-11-01 16:39:35.000000000 +0100
> @@ -0,0 +1,151 @@
> +/*
> + * serial.h: Arch-dep definitions for the Etrax100 serial driver.
> + *
> + * Copyright (C) 1998-2007 Axis Communications AB
> + */
> +
> +#ifndef _ETRAX_SERIAL_H
> +#define _ETRAX_SERIAL_H
> +
> +#include <linux/circ_buf.h>
> +#include <asm/termios.h>
> +#include <asm/dma.h>
> +#include <asm/arch/io_interface_mux.h>
> +
> +/* Software state per channel */
> +
> +#ifdef __KERNEL__
> +/*
> + * This is our internal structure for each serial port's state.
> + *
> + * Many fields are paralleled by the structure used by the serial_struct
> + * structure.
> + *
> + * For definitions of the flags field, see tty.h
> + */
> +
> +#define SERIAL_RECV_DESCRIPTORS 8
> +
> +struct etrax_recv_buffer {
> +	struct etrax_recv_buffer *next;
> +	unsigned short length;
> +	unsigned char error;
> +	unsigned char pad;
> +
> +	unsigned char buffer[0];
> +};
> +
> +struct e100_serial {
> +	int baud;
> +	volatile u8	*port;	/* R_SERIALx_CTRL */
> +	u32		irq;	/* bitnr in R_IRQ_MASK2 for dmaX_descr */
> +
> +	/* Output registers */
> +	volatile u8 *oclrintradr;	/* adr to R_DMA_CHx_CLR_INTR */
> +	volatile u32 *ofirstadr;	/* adr to R_DMA_CHx_FIRST */
> +	volatile u8 *ocmdadr;		/* adr to R_DMA_CHx_CMD */
> +	const volatile u8 *ostatusadr;	/* adr to R_DMA_CHx_STATUS */
> +
> +	/* Input registers */
> +	volatile u8 *iclrintradr;	/* adr to R_DMA_CHx_CLR_INTR */
> +	volatile u32 *ifirstadr;	/* adr to R_DMA_CHx_FIRST */
> +	volatile u8 *icmdadr;		/* adr to R_DMA_CHx_CMD */
> +	volatile u32 *idescradr;	/* adr to R_DMA_CHx_DESCR */
> +
> +	int flags;	/* defined in tty.h */
> +
> +	u8 rx_ctrl;	/* shadow for R_SERIALx_REC_CTRL */
> +	u8 tx_ctrl;	/* shadow for R_SERIALx_TR_CTRL */
> +	u8 iseteop;	/* bit number for R_SET_EOP for the input dma */
> +	int enabled;	/* Set to 1 if the port is enabled in HW config */
> +
> +	u8 dma_out_enabled:1;	/* Set to 1 if DMA should be used */
> +	u8 dma_in_enabled:1;	/* Set to 1 if DMA should be used */

bitfileds generate ugly code.

> +
> +	/* end of fields defined in rs_table[] in .c-file */
> +	int		dma_owner;
> +	unsigned int	dma_in_nbr;
> +	unsigned int	dma_out_nbr;
> +	unsigned int	dma_in_irq_nbr;
> +	unsigned int	dma_out_irq_nbr;
> +	unsigned long	dma_in_irq_flags;
> +	unsigned long	dma_out_irq_flags;
> +	char		*dma_in_irq_description;
> +	char		*dma_out_irq_description;
> +
> +	enum cris_io_interface io_if;
> +	char            *io_if_description;
> +
> +	u8		uses_dma_in;  /* Set to 1 if DMA is used */
> +	u8		uses_dma_out; /* Set to 1 if DMA is used */
> +	u8		forced_eop;   /* a fifo eop has been forced */
> +	int			baud_base;     /* For special baudrates */
> +	int			custom_divisor; /* For special baudrates */
> +	struct etrax_dma_descr	tr_descr;
> +	struct etrax_dma_descr	rec_descr[SERIAL_RECV_DESCRIPTORS];
> +	int			cur_rec_descr;
> +
> +	volatile int		tr_running; /* 1 if output is running */

What's the volatile for here? atomic_t?

> +
> +	struct tty_struct	*tty;
> +	int			read_status_mask;
> +	int			ignore_status_mask;
> +	int			x_char;	/* xon/xoff character */
> +	int			close_delay;
> +	unsigned short		closing_wait;
> +	unsigned short		closing_wait2;
> +	unsigned long		event;
> +	unsigned long		last_active;
> +	int			line;
> +	int			type;  /* PORT_ETRAX */
> +	int			count;	    /* # of fd on device */
> +	int			blocked_open; /* # of blocked opens */
> +	struct circ_buf		xmit;
> +	struct etrax_recv_buffer *first_recv_buffer;
> +	struct etrax_recv_buffer *last_recv_buffer;
> +	unsigned int		recv_cnt;
> +	unsigned int		max_recv_cnt;
> +
> +	struct work_struct	work;
> +	struct async_icount	icount;   /* error-statistics etc.*/
> +	struct ktermios		normal_termios;
> +	struct ktermios		callout_termios;
> +#ifdef DECLARE_WAITQUEUE
> +	wait_queue_head_t	open_wait;
> +	wait_queue_head_t	close_wait;
> +#else
> +	struct wait_queue	*open_wait;
> +	struct wait_queue	*close_wait;
> +#endif

We know, we have it, don't we?

> +
> +	unsigned long char_time_usec;       /* The time for 1 char, in usecs */
> +	unsigned long flush_time_usec;      /* How often we should flush */
> +	unsigned long last_tx_active_usec;  /* Last tx usec in the jiffies */
> +	unsigned long last_tx_active;       /* Last tx time in jiffies */
> +	unsigned long last_rx_active_usec;  /* Last rx usec in the jiffies */
> +	unsigned long last_rx_active;       /* Last rx time in jiffies */
> +
> +	int break_detected_cnt;
> +	int errorcode;
> +
> +#ifdef CONFIG_ETRAX_RS485
> +	struct rs485_control	rs485;  /* RS-485 support */
> +#endif
> +};
> +
> +/* this PORT is not in the standard serial.h. it's not actually used for
> + * anything since we only have one type of async serial-port anyway in this
> + * system.
> + */
> +
> +#define PORT_ETRAX 1
> +
> +/*
> + * Events are used to schedule things to happen at timer-interrupt
> + * time, instead of at rs interrupt time.
> + */
> +#define RS_EVENT_WRITE_WAKEUP	0
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* !_ETRAX_SERIAL_H */
> 
> /^JN - Jesper Nilsson


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
