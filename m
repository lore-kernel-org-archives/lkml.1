Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbXKAQAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbXKAQAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXKAP75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:59:57 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:48785 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXKAP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:59:56 -0400
Date: Thu, 1 Nov 2007 16:59:14 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikael.starvik@axis.com, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH 10/16] CRIS architecture: Correct compile errors
Message-ID: <20071101155914.GB11960@axis.com>
References: <20071030093328.GM11960@axis.com> <20071030151417.43d2f286.akpm@linux-foundation.org> <20071101104810.GA11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101104810.GA11960@axis.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 11:48:11AM +0100, Jesper Nilsson wrote:
> On Tue, Oct 30, 2007 at 03:14:17PM -0700, Andrew Morton wrote:
> > On Tue, 30 Oct 2007 10:33:28 +0100
> > Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> > 
> > > New and improved serial driver for cris v10.
> > 
> > I wasn't able to apply this due to extensive patch rejects.
> 
> Here is an updated patch, I've cleaned up all checkpatch warnings and errors,
> and also removed a lot of stuff that wasn't needed anymore.

Unfortunately, I failed to include the headerfile, which had a number
of checkpatch warnings. I've removed all except the volatile warnings,
which need a rewrite of the driver. I'll put that one on the list to
be looked at.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 crisv10.h |  151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)

--- /dev/null	2007-10-06 06:38:38.348072750 +0200
+++ drivers/serial/crisv10.h	2007-11-01 16:39:35.000000000 +0100
@@ -0,0 +1,151 @@
+/*
+ * serial.h: Arch-dep definitions for the Etrax100 serial driver.
+ *
+ * Copyright (C) 1998-2007 Axis Communications AB
+ */
+
+#ifndef _ETRAX_SERIAL_H
+#define _ETRAX_SERIAL_H
+
+#include <linux/circ_buf.h>
+#include <asm/termios.h>
+#include <asm/dma.h>
+#include <asm/arch/io_interface_mux.h>
+
+/* Software state per channel */
+
+#ifdef __KERNEL__
+/*
+ * This is our internal structure for each serial port's state.
+ *
+ * Many fields are paralleled by the structure used by the serial_struct
+ * structure.
+ *
+ * For definitions of the flags field, see tty.h
+ */
+
+#define SERIAL_RECV_DESCRIPTORS 8
+
+struct etrax_recv_buffer {
+	struct etrax_recv_buffer *next;
+	unsigned short length;
+	unsigned char error;
+	unsigned char pad;
+
+	unsigned char buffer[0];
+};
+
+struct e100_serial {
+	int baud;
+	volatile u8	*port;	/* R_SERIALx_CTRL */
+	u32		irq;	/* bitnr in R_IRQ_MASK2 for dmaX_descr */
+
+	/* Output registers */
+	volatile u8 *oclrintradr;	/* adr to R_DMA_CHx_CLR_INTR */
+	volatile u32 *ofirstadr;	/* adr to R_DMA_CHx_FIRST */
+	volatile u8 *ocmdadr;		/* adr to R_DMA_CHx_CMD */
+	const volatile u8 *ostatusadr;	/* adr to R_DMA_CHx_STATUS */
+
+	/* Input registers */
+	volatile u8 *iclrintradr;	/* adr to R_DMA_CHx_CLR_INTR */
+	volatile u32 *ifirstadr;	/* adr to R_DMA_CHx_FIRST */
+	volatile u8 *icmdadr;		/* adr to R_DMA_CHx_CMD */
+	volatile u32 *idescradr;	/* adr to R_DMA_CHx_DESCR */
+
+	int flags;	/* defined in tty.h */
+
+	u8 rx_ctrl;	/* shadow for R_SERIALx_REC_CTRL */
+	u8 tx_ctrl;	/* shadow for R_SERIALx_TR_CTRL */
+	u8 iseteop;	/* bit number for R_SET_EOP for the input dma */
+	int enabled;	/* Set to 1 if the port is enabled in HW config */
+
+	u8 dma_out_enabled:1;	/* Set to 1 if DMA should be used */
+	u8 dma_in_enabled:1;	/* Set to 1 if DMA should be used */
+
+	/* end of fields defined in rs_table[] in .c-file */
+	int		dma_owner;
+	unsigned int	dma_in_nbr;
+	unsigned int	dma_out_nbr;
+	unsigned int	dma_in_irq_nbr;
+	unsigned int	dma_out_irq_nbr;
+	unsigned long	dma_in_irq_flags;
+	unsigned long	dma_out_irq_flags;
+	char		*dma_in_irq_description;
+	char		*dma_out_irq_description;
+
+	enum cris_io_interface io_if;
+	char            *io_if_description;
+
+	u8		uses_dma_in;  /* Set to 1 if DMA is used */
+	u8		uses_dma_out; /* Set to 1 if DMA is used */
+	u8		forced_eop;   /* a fifo eop has been forced */
+	int			baud_base;     /* For special baudrates */
+	int			custom_divisor; /* For special baudrates */
+	struct etrax_dma_descr	tr_descr;
+	struct etrax_dma_descr	rec_descr[SERIAL_RECV_DESCRIPTORS];
+	int			cur_rec_descr;
+
+	volatile int		tr_running; /* 1 if output is running */
+
+	struct tty_struct	*tty;
+	int			read_status_mask;
+	int			ignore_status_mask;
+	int			x_char;	/* xon/xoff character */
+	int			close_delay;
+	unsigned short		closing_wait;
+	unsigned short		closing_wait2;
+	unsigned long		event;
+	unsigned long		last_active;
+	int			line;
+	int			type;  /* PORT_ETRAX */
+	int			count;	    /* # of fd on device */
+	int			blocked_open; /* # of blocked opens */
+	struct circ_buf		xmit;
+	struct etrax_recv_buffer *first_recv_buffer;
+	struct etrax_recv_buffer *last_recv_buffer;
+	unsigned int		recv_cnt;
+	unsigned int		max_recv_cnt;
+
+	struct work_struct	work;
+	struct async_icount	icount;   /* error-statistics etc.*/
+	struct ktermios		normal_termios;
+	struct ktermios		callout_termios;
+#ifdef DECLARE_WAITQUEUE
+	wait_queue_head_t	open_wait;
+	wait_queue_head_t	close_wait;
+#else
+	struct wait_queue	*open_wait;
+	struct wait_queue	*close_wait;
+#endif
+
+	unsigned long char_time_usec;       /* The time for 1 char, in usecs */
+	unsigned long flush_time_usec;      /* How often we should flush */
+	unsigned long last_tx_active_usec;  /* Last tx usec in the jiffies */
+	unsigned long last_tx_active;       /* Last tx time in jiffies */
+	unsigned long last_rx_active_usec;  /* Last rx usec in the jiffies */
+	unsigned long last_rx_active;       /* Last rx time in jiffies */
+
+	int break_detected_cnt;
+	int errorcode;
+
+#ifdef CONFIG_ETRAX_RS485
+	struct rs485_control	rs485;  /* RS-485 support */
+#endif
+};
+
+/* this PORT is not in the standard serial.h. it's not actually used for
+ * anything since we only have one type of async serial-port anyway in this
+ * system.
+ */
+
+#define PORT_ETRAX 1
+
+/*
+ * Events are used to schedule things to happen at timer-interrupt
+ * time, instead of at rs interrupt time.
+ */
+#define RS_EVENT_WRITE_WAKEUP	0
+
+#endif /* __KERNEL__ */
+
+#endif /* !_ETRAX_SERIAL_H */


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
