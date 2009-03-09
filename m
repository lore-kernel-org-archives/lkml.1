Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZCIEgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZCIEgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 00:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZCIEfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 00:35:55 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:4257 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZCIEfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 00:35:53 -0400
X-IronPort-AV: E=Sophos;i="4.38,327,1233550800"; 
   d="scan'208";a="84016239"
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: gyang <graf.yang@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090306145832.80f1a382.akpm@linux-foundation.org>
References: <1236321885-28938-1-git-send-email-cooloney@kernel.org>
	 <20090306145832.80f1a382.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 12:35:33 +0800
Message-Id: <1236573333.5183.70.camel@dy>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2009 04:35:46.0126 (UTC) FILETIME=[8396F6E0:01C9A070]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 14:58 -0800, Andrew Morton wrote:
> On Fri,  6 Mar 2009 14:44:45 +0800
> Bryan Wu <cooloney@kernel.org> wrote:
> 
> > From: Graf Yang <graf.yang@analog.com>
> > 
> > Signed-off-by: Graf Yang <graf.yang@analog.com>
> > Signed-off-by: Bryan Wu <cooloney@kernel.org>
> 
> Mutter.  Nothing to be said at all?
> 
> >  drivers/net/irda/bfin_sir.h |  147 ++++++++
> >  4 files changed, 989 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/net/irda/bfin_sir.c
> >  create mode 100644 drivers/net/irda/bfin_sir.h
> > 
> > diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
> > index e631755..0e4d7e0 100644
> > --- a/drivers/net/irda/Kconfig
> > +++ b/drivers/net/irda/Kconfig
> > @@ -17,6 +17,51 @@ config IRTTY_SIR
> >  
> >  	  If unsure, say Y.
> >  
> > +config BFIN_SIR
> > +	tristate "Blackfin SIR on UART"
> > +	depends on BLACKFIN && IRDA
> > +	default n
> > +	help
> > +	  Say Y here if your want to enable SIR function on Blackfin UART 
> > +	  devices.
> > +
> > +	  To activate this driver you can start irattach like:
> > +	  "irattach irda0 -s"
> > +
> > +	  Saying M, it will be built as a module named bfin_sir.
> > +
> > +	  Note that you need to turn off one of the serial drivers for SIR
> > +	  to use that UART.
> > +
> > +config BFIN_SIR3
> > +	bool "Blackfin SIR on UART3"
> > +	depends on BFIN_SIR && !SERIAL_BFIN_UART3 && (BF54x)
> > +
> > +config BFIN_SIR1
> > +	bool "Blackfin SIR on UART1"
> > +	depends on BFIN_SIR && !SERIAL_BFIN_UART1 && (!BF531 && !BF532 && !BF533 && !BF561)
> > +
> > +config BFIN_SIR0
> > +	bool "Blackfin SIR on UART0"
> > +	depends on BFIN_SIR && !SERIAL_BFIN_UART0
> > +
> > +config BFIN_SIR2
> > +	bool "Blackfin SIR on UART2"
> > +	depends on BFIN_SIR && !SERIAL_BFIN_UART2 && (BF54x || BF538 || BF539)
> > +
> > +choice
> > +	prompt "SIR Mode"
> > +	depends on BFIN_SIR
> > +	default SIR_BFIN_DMA
> > +
> > +config SIR_BFIN_DMA
> > +	bool "DMA mode"
> > +	depends on !DMA_UNCACHED_NONE
> > +
> > +config SIR_BFIN_PIO
> > +	bool "PIO mode"
> > +endchoice
> 
> This arrangement is pretty user-hostile.  It requires that people
> reconfigure and rebuild their kernel any time they want to change the
> driver options.
> 
> It would be much better to be able to do this via a kernel boot option.
> 
> It would be better still to be able to do this via a module parameter.
> 
> It would be better still to be able to do this via a runtime knob:
> ioctl, sysfs file, whatever.
> 
> it would be better still to do all this automatically at probe time.
> 
> What you've chosen here is the worst possible solution, sorry.

Because most of our end-users are using it in embedded devices, they
want the binary be smaller and faster. The compile time overhead is not
a problem.

> 
> >  comment "Dongle support"
> >
> > ...
> >
> > +static void turnaround_delay(unsigned long last_jif, int mtt)
> > +{
> > +	long ticks;
> > +
> > +	mtt = mtt < 10000 ? 10000 : mtt;
> > +	ticks = 1 + mtt / (USEC_PER_SEC / HZ);
> > +	schedule_timeout_interruptible(ticks);
> > +}
> 
> If the calling task has signal_pending() then the
> schedule_timeout_interruptible() will return immediately.  I bet this
> breaks the driver.
> 
> Fixable by using schedule_timeout_uninterruptible().

OK, Thanks.

> 
> >
> > ...
> >
> > +static void bfin_sir_stop_tx(struct bfin_sir_port *port)
> > +{
> > +#ifdef CONFIG_SIR_BFIN_DMA
> > +	disable_dma(port->tx_dma_channel);
> > +#endif
> > +
> > +	while (!(SIR_UART_GET_LSR(port) & THRE))
> > +		continue;
> 
> cpu_relax().
> 
> > +	SIR_UART_STOP_TX(port);
> > +}
> > +
> >
> > ...
> >
> > +#ifdef CONFIG_SIR_BFIN_PIO
> > +static void bfin_sir_tx_chars(struct net_device *dev)
> > +{
> > +	unsigned int chr;
> > +	struct bfin_sir_self *self = netdev_priv(dev);
> > +	struct bfin_sir_port *port = self->sir_port;
> > +
> > +	if (self->tx_buff.len != 0) {
> > +		chr = *(self->tx_buff.data);
> > +		SIR_UART_PUT_CHAR(port, chr);
> > +		self->tx_buff.data++;
> > +		self->tx_buff.len--;
> 
> I don't see any locking which protects the tx_buff.

I will add lock for both tx/rx.

> 
> > +	} else {
> > +		self->stats.tx_packets++;
> > +		self->stats.tx_bytes += self->tx_buff.data - self->tx_buff.head;
> > +		if (self->newspeed) {
> > +			bfin_sir_set_speed(port, self->newspeed);
> > +			self->speed = self->newspeed;
> > +			self->newspeed = 0;
> > +		}
> > +		bfin_sir_stop_tx(port);
> > +		bfin_sir_enable_rx(port);
> > +		/* I'm hungry! */
> > +		netif_wake_queue(dev);
> > +	}
> > +}
> > +
> > +static void bfin_sir_rx_chars(struct net_device *dev)
> > +{
> > +	struct bfin_sir_self *self = netdev_priv(dev);
> > +	struct bfin_sir_port *port = self->sir_port;
> > +	unsigned char ch;
> > +
> > +	SIR_UART_CLEAR_LSR(port);
> > +	ch = SIR_UART_GET_CHAR(port);
> > +	async_unwrap_char(dev, &self->stats, &self->rx_buff, ch);
> > +	dev->last_rx = jiffies;
> > +}
> > +
> > +static irqreturn_t bfin_sir_rx_int(int irq, void *dev_id)
> > +{
> > +	struct net_device *dev = dev_id;
> > +	struct bfin_sir_self *self = netdev_priv(dev);
> > +	struct bfin_sir_port *port = self->sir_port;
> 
> blank line here.
> 
> > +	while ((SIR_UART_GET_LSR(port) & DR))
> > +		bfin_sir_rx_chars(dev);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> >
> > ...
> >
> > +static irqreturn_t bfin_sir_dma_tx_int(int irq, void *dev_id)
> > +{
> > +	struct net_device *dev = dev_id;
> > +	struct bfin_sir_self *self = netdev_priv(dev);
> > +	struct bfin_sir_port *port = self->sir_port;
> > +	spin_lock(&self->lock);
> 
> please prefer to put a blank line after end-of-locals and before
> start-of-code,
> 
> > +	if (!(get_dma_curr_irqstat(port->tx_dma_channel)&DMA_RUN)) {
> > +		clear_dma_irqstat(port->tx_dma_channel);
> > +		bfin_sir_stop_tx(port);
> > +
> > +		self->stats.tx_packets++;
> > +		self->stats.tx_bytes += self->tx_buff.len;
> > +		self->tx_buff.len = 0;
> > +		if (self->newspeed) {
> > +			bfin_sir_set_speed(port, self->newspeed);
> > +			self->speed = self->newspeed;
> > +			self->newspeed = 0;
> > +		}
> > +		bfin_sir_enable_rx(port);
> > +		/* I'm hungry! */
> > +		netif_wake_queue(dev);
> > +		port->tx_done = 1;
> > +	}
> > +	spin_unlock(&self->lock);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static void bfin_sir_dma_rx_chars(struct net_device *dev)
> > +{
> > +	struct bfin_sir_self *self = netdev_priv(dev);
> > +	struct bfin_sir_port *port = self->sir_port;
> > +	int i;
> > +
> 
> like that.
> 
> > +	SIR_UART_CLEAR_LSR(port);
> > +
> > +	for (i = port->rx_dma_buf.head; i < port->rx_dma_buf.tail; i++)
> > +		async_unwrap_char(dev, &self->stats, &self->rx_buff, port->rx_dma_buf.buf[i]);
> > +}
> > +
> >
> > ...
> >
> > +static int bfin_sir_stop(struct net_device *dev)
> > +{
> > +	struct bfin_sir_self *self = netdev_priv(dev);
> > +
> > +	flush_scheduled_work();
> 
> flush_scheduled_work() flushes all work items.  It is preferable to use
> flush_work() to flush a single item.

OK, thanks.

> 
> 
> > +	bfin_sir_shutdown(self->sir_port, dev);
> > +
> > +	if (self->rxskb) {
> > +		dev_kfree_skb(self->rxskb);
> > +		self->rxskb = NULL;
> > +	}
> > +
> > +	/* Stop IrLAP */
> > +	if (self->irlap) {
> > +		irlap_close(self->irlap);
> > +		self->irlap = NULL;
> > +	}
> > +
> > +	netif_stop_queue(dev);
> > +	self->open = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +static int bfin_sir_init_iobuf(iobuff_t *io, int size)
> > +{
> > +	io->head = kmalloc(size, GFP_KERNEL | GFP_DMA);
> 
> Does it actually _need_ the GFP_DMA?
> 
> It is wrong (or at least, contradictory) to combine GFP_KERNEL and
> GFP_DMA together in this manner.  Use one or the other.

OK. Thanks.

> 
> > +	if (!io->head)
> > +		return -ENOMEM;
> > +	io->truesize = size;
> > +	io->in_frame = FALSE;
> > +	io->state    = OUTSIDE_FRAME;
> > +	io->data     = io->head;
> > +	return 0;
> > +}
> > +
> >
> > ...
> >
