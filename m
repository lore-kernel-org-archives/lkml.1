Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbZCFW7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbZCFW7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZCFW7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:59:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070AbZCFW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:58:59 -0500
Date: Fri, 6 Mar 2009 14:58:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, graf.yang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
Message-Id: <20090306145832.80f1a382.akpm@linux-foundation.org>
In-Reply-To: <1236321885-28938-1-git-send-email-cooloney@kernel.org>
References: <1236321885-28938-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:44:45 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Graf Yang <graf.yang@analog.com>
> 
> Signed-off-by: Graf Yang <graf.yang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Mutter.  Nothing to be said at all?

>  drivers/net/irda/bfin_sir.h |  147 ++++++++
>  4 files changed, 989 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/irda/bfin_sir.c
>  create mode 100644 drivers/net/irda/bfin_sir.h
> 
> diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
> index e631755..0e4d7e0 100644
> --- a/drivers/net/irda/Kconfig
> +++ b/drivers/net/irda/Kconfig
> @@ -17,6 +17,51 @@ config IRTTY_SIR
>  
>  	  If unsure, say Y.
>  
> +config BFIN_SIR
> +	tristate "Blackfin SIR on UART"
> +	depends on BLACKFIN && IRDA
> +	default n
> +	help
> +	  Say Y here if your want to enable SIR function on Blackfin UART 
> +	  devices.
> +
> +	  To activate this driver you can start irattach like:
> +	  "irattach irda0 -s"
> +
> +	  Saying M, it will be built as a module named bfin_sir.
> +
> +	  Note that you need to turn off one of the serial drivers for SIR
> +	  to use that UART.
> +
> +config BFIN_SIR3
> +	bool "Blackfin SIR on UART3"
> +	depends on BFIN_SIR && !SERIAL_BFIN_UART3 && (BF54x)
> +
> +config BFIN_SIR1
> +	bool "Blackfin SIR on UART1"
> +	depends on BFIN_SIR && !SERIAL_BFIN_UART1 && (!BF531 && !BF532 && !BF533 && !BF561)
> +
> +config BFIN_SIR0
> +	bool "Blackfin SIR on UART0"
> +	depends on BFIN_SIR && !SERIAL_BFIN_UART0
> +
> +config BFIN_SIR2
> +	bool "Blackfin SIR on UART2"
> +	depends on BFIN_SIR && !SERIAL_BFIN_UART2 && (BF54x || BF538 || BF539)
> +
> +choice
> +	prompt "SIR Mode"
> +	depends on BFIN_SIR
> +	default SIR_BFIN_DMA
> +
> +config SIR_BFIN_DMA
> +	bool "DMA mode"
> +	depends on !DMA_UNCACHED_NONE
> +
> +config SIR_BFIN_PIO
> +	bool "PIO mode"
> +endchoice

This arrangement is pretty user-hostile.  It requires that people
reconfigure and rebuild their kernel any time they want to change the
driver options.

It would be much better to be able to do this via a kernel boot option.

It would be better still to be able to do this via a module parameter.

It would be better still to be able to do this via a runtime knob:
ioctl, sysfs file, whatever.

it would be better still to do all this automatically at probe time.

What you've chosen here is the worst possible solution, sorry.

>  comment "Dongle support"
>
> ...
>
> +static void turnaround_delay(unsigned long last_jif, int mtt)
> +{
> +	long ticks;
> +
> +	mtt = mtt < 10000 ? 10000 : mtt;
> +	ticks = 1 + mtt / (USEC_PER_SEC / HZ);
> +	schedule_timeout_interruptible(ticks);
> +}

If the calling task has signal_pending() then the
schedule_timeout_interruptible() will return immediately.  I bet this
breaks the driver.

Fixable by using schedule_timeout_uninterruptible().

>
> ...
>
> +static void bfin_sir_stop_tx(struct bfin_sir_port *port)
> +{
> +#ifdef CONFIG_SIR_BFIN_DMA
> +	disable_dma(port->tx_dma_channel);
> +#endif
> +
> +	while (!(SIR_UART_GET_LSR(port) & THRE))
> +		continue;

cpu_relax().

> +	SIR_UART_STOP_TX(port);
> +}
> +
>
> ...
>
> +#ifdef CONFIG_SIR_BFIN_PIO
> +static void bfin_sir_tx_chars(struct net_device *dev)
> +{
> +	unsigned int chr;
> +	struct bfin_sir_self *self = netdev_priv(dev);
> +	struct bfin_sir_port *port = self->sir_port;
> +
> +	if (self->tx_buff.len != 0) {
> +		chr = *(self->tx_buff.data);
> +		SIR_UART_PUT_CHAR(port, chr);
> +		self->tx_buff.data++;
> +		self->tx_buff.len--;

I don't see any locking which protects the tx_buff.

> +	} else {
> +		self->stats.tx_packets++;
> +		self->stats.tx_bytes += self->tx_buff.data - self->tx_buff.head;
> +		if (self->newspeed) {
> +			bfin_sir_set_speed(port, self->newspeed);
> +			self->speed = self->newspeed;
> +			self->newspeed = 0;
> +		}
> +		bfin_sir_stop_tx(port);
> +		bfin_sir_enable_rx(port);
> +		/* I'm hungry! */
> +		netif_wake_queue(dev);
> +	}
> +}
> +
> +static void bfin_sir_rx_chars(struct net_device *dev)
> +{
> +	struct bfin_sir_self *self = netdev_priv(dev);
> +	struct bfin_sir_port *port = self->sir_port;
> +	unsigned char ch;
> +
> +	SIR_UART_CLEAR_LSR(port);
> +	ch = SIR_UART_GET_CHAR(port);
> +	async_unwrap_char(dev, &self->stats, &self->rx_buff, ch);
> +	dev->last_rx = jiffies;
> +}
> +
> +static irqreturn_t bfin_sir_rx_int(int irq, void *dev_id)
> +{
> +	struct net_device *dev = dev_id;
> +	struct bfin_sir_self *self = netdev_priv(dev);
> +	struct bfin_sir_port *port = self->sir_port;

blank line here.

> +	while ((SIR_UART_GET_LSR(port) & DR))
> +		bfin_sir_rx_chars(dev);
> +
> +	return IRQ_HANDLED;
> +}
> +
>
> ...
>
> +static irqreturn_t bfin_sir_dma_tx_int(int irq, void *dev_id)
> +{
> +	struct net_device *dev = dev_id;
> +	struct bfin_sir_self *self = netdev_priv(dev);
> +	struct bfin_sir_port *port = self->sir_port;
> +	spin_lock(&self->lock);

please prefer to put a blank line after end-of-locals and before
start-of-code,

> +	if (!(get_dma_curr_irqstat(port->tx_dma_channel)&DMA_RUN)) {
> +		clear_dma_irqstat(port->tx_dma_channel);
> +		bfin_sir_stop_tx(port);
> +
> +		self->stats.tx_packets++;
> +		self->stats.tx_bytes += self->tx_buff.len;
> +		self->tx_buff.len = 0;
> +		if (self->newspeed) {
> +			bfin_sir_set_speed(port, self->newspeed);
> +			self->speed = self->newspeed;
> +			self->newspeed = 0;
> +		}
> +		bfin_sir_enable_rx(port);
> +		/* I'm hungry! */
> +		netif_wake_queue(dev);
> +		port->tx_done = 1;
> +	}
> +	spin_unlock(&self->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void bfin_sir_dma_rx_chars(struct net_device *dev)
> +{
> +	struct bfin_sir_self *self = netdev_priv(dev);
> +	struct bfin_sir_port *port = self->sir_port;
> +	int i;
> +

like that.

> +	SIR_UART_CLEAR_LSR(port);
> +
> +	for (i = port->rx_dma_buf.head; i < port->rx_dma_buf.tail; i++)
> +		async_unwrap_char(dev, &self->stats, &self->rx_buff, port->rx_dma_buf.buf[i]);
> +}
> +
>
> ...
>
> +static int bfin_sir_stop(struct net_device *dev)
> +{
> +	struct bfin_sir_self *self = netdev_priv(dev);
> +
> +	flush_scheduled_work();

flush_scheduled_work() flushes all work items.  It is preferable to use
flush_work() to flush a single item.


> +	bfin_sir_shutdown(self->sir_port, dev);
> +
> +	if (self->rxskb) {
> +		dev_kfree_skb(self->rxskb);
> +		self->rxskb = NULL;
> +	}
> +
> +	/* Stop IrLAP */
> +	if (self->irlap) {
> +		irlap_close(self->irlap);
> +		self->irlap = NULL;
> +	}
> +
> +	netif_stop_queue(dev);
> +	self->open = 0;
> +
> +	return 0;
> +}
> +
> +static int bfin_sir_init_iobuf(iobuff_t *io, int size)
> +{
> +	io->head = kmalloc(size, GFP_KERNEL | GFP_DMA);

Does it actually _need_ the GFP_DMA?

It is wrong (or at least, contradictory) to combine GFP_KERNEL and
GFP_DMA together in this manner.  Use one or the other.

> +	if (!io->head)
> +		return -ENOMEM;
> +	io->truesize = size;
> +	io->in_frame = FALSE;
> +	io->state    = OUTSIDE_FRAME;
> +	io->data     = io->head;
> +	return 0;
> +}
> +
>
> ...
>

