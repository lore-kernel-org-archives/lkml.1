Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYITIZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYITIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYITIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:25:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbYITIZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:25:14 -0400
Date: Sat, 20 Sep 2008 01:24:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Pellegrin <chripell@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Christian Pellegrin <chripell@fsfe.org>
Subject: Re: [PATCH] max3100 driver
Message-Id: <20080920012454.e40f03cc.akpm@linux-foundation.org>
In-Reply-To: <1221895208650-git-send-email-chripell@gmail.com>
References: <1221895208650-git-send-email-chripell@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 09:20:08 +0200 Christian Pellegrin <chripell@gmail.com> wrote:

> This patch adds support for the MAX3100 SPI UART.
> 
>
> ...
>
> + * The initial minor number is 128 in the low-density serial port:
> + * mknod /dev/ttyMAX0 c 204 128
> + */
> +
> +#define MAX3100_MAJOR 204

Allocating a new major is a Big Deal.  It involves getting the major
registered by contacting device@lanana.org.

It's better to dynamically allocate it - let udev handle it.

> +#define MAX3100_MINOR 128
> +/* 4 MAX3100s should be enough for everyone */
> +#define MAX_MAX3100 4
> +
> +#include <linux/bitops.h>
> +#include <linux/console.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/fcntl.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/keyboard.h>
> +#include <linux/major.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/pm.h>
> +#include <linux/reboot.h>
> +#include <linux/sched.h>
> +#include <linux/serial_core.h>
> +#include <linux/serial.h>
> +#include <linux/signal.h>
> +#include <linux/spi/spi.h>
> +#include <linux/string.h>
> +#include <linux/timer.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/uaccess.h>
> +#include <linux/workqueue.h>
> +#include <linux/freezer.h>

Gad. Are all those includes needed?

> +#include <asm/system.h>
> +
> +#include <linux/serial_max3100.h>
> +
>
> ...
>
> +/* the following simulate a status reg for ignore_status_mask */
> +#define MAX3100_STATUS_PE 1
> +#define MAX3100_STATUS_FE 2
> +#define MAX3100_STATUS_OE 4
> +
> +struct max3100_port_s {

`struct max3100_port' is sufficient, and would be more typical.

> +	struct uart_port port;
> +	struct spi_device *spi;
> +
> +	int cts:1;	        /* last CTS received for flow ctrl */
> +	int tx_empty:1;		/* last TX empty bit */

These two bits will share a word and hence locking is needed to prevent
modifications to one from trashing modifications to the other on SMP.

That's OK, but it would be best to document that locking right here, and
to check that it is adhered to.

> +	spinlock_t conf_lock;	/* shared data */
> +	int conf_commit:1;	/* need to make changes */
> +	int conf;		/* configuration for the MAX31000
> +				 * (bits 0-7, bits 8-11 are irqs) */
> +	int rts_commit:1;	/* need to change rts */
> +	int rts:1;		/* rts status */
> +
> +	int parity:3;		/* keeps track if we should send parity */
> +#define MAX3100_PARITY_ON 1
> +#define MAX3100_PARITY_ODD 2
> +#define MAX3100_7BIT 4
> +	int rx_enabled:1;	/* if we should rx chars */
> +
> +	int irq;		/* irq assigned to the max3100 */
> +
> +	int minor;		/* minor number */
> +	int crystal:1;		/* 1 if 3.6864Mhz crystal 0 for 1.8432 */
> +	int loopback:1;		/* 1 if we are in loopback mode */
> +	int only_edge_irq:1;	/* 1 if we have only edge irqs (like PXA) */

Lots of dittoes.

These bitfields perhaps could be reordered to save a bit of space, but
that depends on the implicit locking rules for them.

> +	/* for handling irqs: need workqueue since we do spi_sync */
> +	struct workqueue_struct *workqueue;
> +	struct work_struct work;
> +	/* set to 1 to make the workhandler exit as soon as possible */
> +	int  force_end_work:1;
> +	/* need to know we are suspending to avoid deadlock on workqueue */
> +	int suspending:1;
> +
> +	/* these are for IRQ on/off counting */
> +	int irq_status;
> +	/* avoid race condition on irq_status */
> +	spinlock_t irq_lock;
> +
> +	/* hook for suspending MAX3100 via dedicated pin */
> +	void (*max3100_hw_suspend) (int suspend);
> +
> +	/* poll time (in ms) for ctrl lines */
> +	int poll_time;
> +	/* and it's timer */

s/it's/its/

> +	struct timer_list	timer;
> +};
> +
> +static struct max3100_port_s *max3100s[MAX_MAX3100]; /* the chips */
> +
> +static void irq_state(struct max3100_port_s *s, int on)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&s->irq_lock, flags);
> +	if (s->irq_status != on) {
> +		if (on)
> +			enable_irq(s->irq);
> +		else
> +			disable_irq(s->irq);
> +		s->irq_status = on;
> +	}
> +	spin_unlock_irqrestore(&s->irq_lock, flags);
> +}
> +
> +static int max3100_do_parity(struct max3100_port_s *s, u16 c)
> +{
> +	int parity;
> +	int i, n;
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
> +	for (i = 0; i < n; i++)
> +		parity = parity ^ ((c>>i) & 1);

hrmpf.  Don't we have a library function for that?

Perhaps you could use hweight8(c)&1.

> +	return parity;
> +}
> +
> +static int max3100_check_parity(struct max3100_port_s *s, u16 c)
> +{
> +	return max3100_do_parity(s, c) ==
> +	  ((c >> (s->parity & MAX3100_7BIT ? 7 : 8)) & 1);

<checks his C precedence table>

OK...

> +}
> +
> +static void max3100_calc_parity(struct max3100_port_s *s, u16 *c)
> +{
> +	*c &=  ~MAX3100_PT;

s/  / /

> +	if (s->parity & MAX3100_PARITY_ON)
> +		*c |= max3100_do_parity(s, *c)<<8;

Most people put spaces around <<, but checkpatch pets this through.

> +}
> +
> +static void max3100_work(struct work_struct *w);
> +
> +static void max3100_dowork(struct max3100_port_s *s)
> +{
> +	if (!s->force_end_work && !work_pending(&s->work)) {
> +		PREPARE_WORK(&s->work, max3100_work);

This is a strange place to run PREPARE_WORK().  Normally it would be
done during driver/device initialsiation, and I think that can be done
here.

> +		queue_work(s->workqueue, &s->work);
> +	}
> +}
> +
> +static void max3100_timeout(unsigned long data)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *)data;
> +
> +	if (s->port.info) {
> +		max3100_dowork(s);
> +		mod_timer(&s->timer, jiffies + s->poll_time);
> +	}
> +}
> +
> +static int max3100_sr(struct max3100_port_s *s, u16 tx, u16 *rx)
> +{
> +	struct spi_message message;
> +	struct spi_transfer tran;
> +	u16 etx, erx;
> +	int status;
> +
> +	etx = htons(tx);
> +	spi_message_init(&message);
> +	memset(&tran, 0, sizeof(tran));
> +	tran.tx_buf = &etx;
> +	tran.rx_buf = &erx;
> +	tran.len = 2;

could do

	struct spi_transfer tran = {
		.tx_buf = &etx,
		.rx_buf = &erx
		.len = 2,
	};

and the compiler will zero out the rest.  Minor point.
		
> +	spi_message_add_tail(&tran, &message);
> +	status = spi_sync(s->spi, &message);
> +	if (status) {
> +		dev_warn(&s->spi->dev, "error while calling spi_sync\n");
> +		return -EIO;
> +	}
> +	*rx = ntohs(erx);
> +	s->tx_empty = (*rx & MAX3100_T) > 0;
> +	dev_dbg(&s->spi->dev, "%04x - %04x\n", tx, *rx);
> +	return 0;
> +}
> +
>
> ...
>
> +static unsigned int max3100_get_mctrl(struct uart_port *port)
> +{
> +	struct max3100_port_s *s = container_of(port,
> +						struct max3100_port_s,
> +						port);
> +
> +	dev_dbg(&s->spi->dev, "%s\n", __func__);
> +
> +	/* may not be truely up-to-date */

s/truely/truly/

> +	max3100_dowork(s);
> +	/* always assert DCD and DSR since these lines are not wired */
> +	return (s->cts ? TIOCM_CTS : 0) | TIOCM_DSR | TIOCM_CAR;
> +}
> +
>
> ...
>
> +static int max3100_startup(struct uart_port *port)
> +{
> +	struct max3100_port_s *s = container_of(port,
> +						struct max3100_port_s,
> +						port);
> +	char b[10];
> +	int irq_type;
> +
> +	dev_dbg(&s->spi->dev, "%s\n", __func__);
> +
> +	s->conf = MAX3100_RM;
> +	s->rx_enabled = 1;
> +
> +	if (s->suspending)
> +		return 0;
> +
> +	s->force_end_work = 0;
> +	s->parity = 0;
> +	s->rts = 0;
> +
> +	sprintf(b, "max3100-%d", s->minor);

hm.  This will go nasty if s->minor > 9.  I'd suggest that b[] be made
larger.

> +	s->workqueue = create_freezeable_workqueue(b);
> +	if (!s->workqueue) {
> +		dev_warn(&s->spi->dev, "cannot create workqueue\n");
> +		return -EBUSY;
> +	}
> +	INIT_WORK(&s->work, max3100_work);
> +
> +	s->irq_status = 1;	/* IRQS are on after request */
> +	if (s->only_edge_irq)
> +		irq_type = IRQF_TRIGGER_FALLING;
> +	else
> +		irq_type = IRQF_TRIGGER_LOW;
> +	if (request_irq(s->irq, max3100_irq, irq_type, "max3100", s) < 0) {
> +		dev_warn(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
> +		s->irq = 0;

Shouldn't we tear down that workqueue before returning?

> +		return -EBUSY;
> +	}
> +
> +	if (s->loopback) {
> +		u16 tx, rx;
> +		tx = 0x4001;
> +		max3100_sr(s, tx, &rx);
> +	}
> +
> +	if (s->max3100_hw_suspend)
> +		s->max3100_hw_suspend(0);
> +	s->conf_commit = 1;
> +	max3100_dowork(s);
> +	/* wait for clock to settle */
> +	msleep(50);
> +
> +	max3100_enable_ms(&s->port);
> +
> +	return 0;
> +}
> +
> +static const char *max3100_type(struct uart_port *port)
> +{
> +	struct max3100_port_s *s = container_of(port,
> +						struct max3100_port_s,
> +						port);
> +
> +	dev_dbg(&s->spi->dev, "%s\n", __func__);
> +
> +	return s->port.type == PORT_MAX3100 ? "MAX3100" : NULL;
> +}
> +
> +static void max3100_release_port(struct uart_port *port)
> +{
> +	struct max3100_port_s *s = (struct max3100_port_s *)port;

container_of()

> +	dev_dbg(&s->spi->dev, "%s\n", __func__);
> +}
> +
>
> ...
>

Please cc Alan Cox for the tty things and perhaps
spi-devel-general@lists.sourceforge.net for the SPI bits.

