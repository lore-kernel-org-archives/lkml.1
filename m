Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZCJLs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZCJLs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZCJLsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:48:47 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:29189 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZCJLsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:48:46 -0400
X-IronPort-AV: E=Sophos;i="4.38,336,1233550800"; 
   d="scan'208";a="67630821"
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: gyang <graf.yang@analog.com>
To: graff yang <graff.yang@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       cooloney@kernel.org
In-Reply-To: <7d86d44a0903100425y2ed41d72p3ec43021f554af96@mail.gmail.com>
References: <1236670166-3910-1-git-send-email-graff.yang@gmail.com>
	 <8bd0f97a0903100103w6fc3dfc8se6076c98dbe5d8b4@mail.gmail.com>
	 <7d86d44a0903100425y2ed41d72p3ec43021f554af96@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 19:48:18 +0800
Message-Id: <1236685698.5183.86.camel@dy>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2009 11:48:30.0592 (UTC) FILETIME=[2207D000:01C9A176]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 19:25 +0800, graff yang wrote:
> 
> 
> On Tue, Mar 10, 2009 at 4:03 PM, Mike Frysinger <vapier.adi@gmail.com>
> wrote:
>         On Tue, Mar 10, 2009 at 03:29,  <graff.yang@gmail.com> wrote:
>         > +config BFIN_SIR3
>         > +       bool "Blackfin SIR on UART3"
>         
>         > +config BFIN_SIR1
>         > +       bool "Blackfin SIR on UART1"
>         
>         > +config BFIN_SIR0
>         > +       bool "Blackfin SIR on UART0"
>         
>         > +config BFIN_SIR2
>         > +       bool "Blackfin SIR on UART2"
>         
>         
>         looks like an odd order for things.  or maybe you count to 3
>         differently from me :).
>         
>         > +static int bfin_sir_set_speed(struct bfin_sir_port *port,
>         int speed)
>         > +{
>         > +       int ret = -EINVAL;
>         > +       unsigned int quot;
>         > +       unsigned short val, lsr, lcr = 0;
>         > +
>         > +       lcr = WLS(8);
>         
>         
>         the lcr init to 0 looks pretty pointless to me ...
>         
>         > +               quot = (port->clk + (8 * speed)) / (16 *
>         speed);
>         
>         isnt the SIR affected by the same anomalies as the UART ?  in
>         other
>         words, you just made that adjustment to the UART recently ...
>  
> SIR hasn't encounter such anomalies. Anyway, I will add it. 
> 
>         
>         
>         > +               do {
>         > +                       lsr = SIR_UART_GET_LSR(port);
>         > +               } while (!(lsr & TEMT));
>         
>         
>         i'm pretty sure we determined that it is not the job of the
>         kernel to
>         make sure the line is clear before we go changing speeds.

But we should prevent changing speed when the byte is sending out.

>           plus, we
>         had a few bugs on the UART driver when polling for bits on a
>         peripheral that wasnt enabled yet ...
>         
>         > +               SIR_UART_PUT_DLL(port, quot & 0xFF);
>         > +               SSYNC();
>         > +               SIR_UART_PUT_DLH(port, (quot >> 8) & 0xFF);
>         > +               SSYNC();
>         
>         
>         i'm pretty sure that first SSYNC is not needed
>         
>         > +               /*printk(KERN_DEBUG "bfin_sir: Set new speed
>         %d\n", speed);*/
>         
>         pr_debug() ?
>         
>         > +static irqreturn_t bfin_sir_dma_tx_int(int irq, void
>         *dev_id)
>         > +{
>         > +       struct net_device *dev = dev_id;
>         > +       struct bfin_sir_self *self = netdev_priv(dev);
>         > +       struct bfin_sir_port *port = self->sir_port;
>         > +
>         > +       spin_lock(&self->lock);
>         > +       if
>         (!(get_dma_curr_irqstat(port->tx_dma_channel)&DMA_RUN)) {
>         
>         
>         really should be whitespace around that &
>         
>         > +static irqreturn_t bfin_sir_dma_rx_int(int irq, void
>         *dev_id)
>         > +{
>         
>         > +....
>         > +       mod_timer(&(port->rx_dma_timer), jiffies +
>         DMA_SIR_RX_FLUSH_JIFS);
>         
>         those paren are unnecessary
>         
>         > +static int bfin_sir_startup(struct bfin_sir_port *port,
>         struct net_device *dev)
>         > +{
>         > +#ifdef CONFIG_SIR_BFIN_DMA
>         > +       dma_addr_t dma_handle;
>         > +#endif /* CONFIG_SIR_BFIN_DMA */
>         > +
>         > +       if (request_dma(port->rx_dma_channel,
>         "BFIN_UART_RX") < 0) {
>         > +               printk(KERN_WARNING "bfin_sir: Unable to
>         attach SIR RX DMA channel\n");
>         
>         
>         should be dev_warn(&dev->dev, ...) ?  if so, i'd check all the
>         places
>         where printk() is used when a net_device is available ...
>         
>         > +static int __devinit bfin_sir_probe(struct platform_device
>         *pdev)
>         > +{
>         > +       struct net_device *dev;
>         > +       struct bfin_sir_self *self;
>         > +       unsigned int baudrate_mask;
>         > +       struct bfin_sir_port *sir_port;
>         > +       int err = 0;
>         > +
>         > +       err = peripheral_request(per[pdev->id][0],
>         DRIVER_NAME);
>         > +       if (err)
>         > +               return err;
>         > +       err = peripheral_request(per[pdev->id][1],
>         DRIVER_NAME);
>         > +       if (err)
>         > +               return err;
>         
>         
>         the first per list was just leaked ...
>         
>         > +       sir_port = kmalloc(sizeof(struct bfin_sir_port),
>         GFP_KERNEL);
>         
>         sizeof(*sir_port)
>         
>         > +       dev = alloc_irdadev(sizeof(struct bfin_sir_self));
>         
>         sizeof(*dev)
>         
>         > +       baudrate_mask = IR_9600;
>         > +
>         > +       switch (max_rate) {
>         > +       case 115200:
>         > +               baudrate_mask |= IR_115200;
>         > +       case 57600:
>         > +               baudrate_mask |= IR_57600;
>         > +       case 38400:
>         > +               baudrate_mask |= IR_38400;
>         > +       case 19200:
>         > +               baudrate_mask |= IR_19200;
>         > +       }
>         
>         
>         what if someone specified max_rate = 1231245 ?
> 
> The  initial value of baudrate_mask is IR_9600.
> 
>         
>         
>         > +       if (err) {
>         > +err_mem_3:
>         > +               kfree(self->tx_buff.head);
>         > +err_mem_2:
>         > +               kfree(self->rx_buff.head);
>         > +err_mem_1:
>         > +               free_netdev(dev);
>         > +err_mem_0:
>         > +               kfree(sir_port);
>         > +       }
>         
>         
>         the peripheral pins are leaked here as well
>         
>         > +       if (err == 0)
>         > +               platform_set_drvdata(pdev, sir_port);
>         
>         
>         considering you tested "if (err)" right before, an "} else"
>         would make
>         more sense
>         
>         > +MODULE_AUTHOR("Graf.Yang <graf.yang@analog.com>");
>         
>         
>         i think your name has no "." ? :)
> 
> Thanks.
>  
> 
>         
>         
>         > --- /dev/null
>         > +++ b/drivers/net/irda/bfin_sir.h
>         
>         > +#ifdef CONFIG_SIR_BFIN_DMA
>         > +struct dma_rx_buf {
>         > +       char *buf;
>         > +       int head;
>         > +       int tail;
>         > +       };
>         
>         
>         no indentation in closing brace
>         
>         > +static unsigned short per[][2] = {
>         > +       {P_UART0_RX, P_UART0_TX},
>         > +       {P_UART1_RX, P_UART1_TX},
>         > +       {P_UART2_RX, P_UART2_TX},
>         > +       {P_UART3_RX, P_UART3_TX},
>         > +       };
>         
>         
>         no indentation in closing brace and really this should be
>         const
>         -mike
> 
