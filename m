Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYLEVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYLEVyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYLEVyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:54:00 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:47865 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbYLEVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:53:59 -0500
Date: Fri, 5 Dec 2008 23:53:45 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: samuel@sortiz.org, linux-kernel@vger.kernel.org,
       irda-users@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
Subject: Re: [irda-users] [PATCH] OMAP IrDA driver
Message-ID: <20081205215344.GJ18379@frodo>
Reply-To: me@felipebalbi.com
References: <5d5443650812042234y6301148at6658f4855500b105@mail.gmail.com> <ea9ea93a42eaf41cd9ee3ff11ad1a026@localhost> <5d5443650812050148n2b3fca72m272a1af33629c478@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650812050148n2b3fca72m272a1af33629c478@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 03:18:10PM +0530, Trilok Soni wrote:
> +struct omap_irda {
> +	unsigned char open;
> +	int speed;		/* Current IrDA speed */
> +	int newspeed;
> +
> +	struct net_device_stats stats;
> +	struct irlap_cb *irlap;
> +	struct qos_info qos;
> +
> +	int rx_dma_channel;
> +	int tx_dma_channel;
> +
> +	dma_addr_t rx_buf_dma_phys;	/* Physical address of RX DMA buffer */
> +	dma_addr_t tx_buf_dma_phys;	/* Physical address of TX DMA buffer */
> +
> +	void *rx_buf_dma_virt;		/* Virtual address of RX DMA buffer */
> +	void *tx_buf_dma_virt;		/* Virtual address of TX DMA buffer */

should these two be void __iomem * ?

> +
> +	struct device *dev;
> +	struct omap_irda_config *pdata;
> +};
> +
> +static inline void uart_reg_out(int idx, u8 val)
> +{
> +	omap_writeb(val, idx);

__raw_writeb(), pass a reference to struct omap_irda here so you'd have
access to a void __iomem *base (read below).

> +}
> +
> +static inline u8 uart_reg_in(int idx)
> +{
> +	u8 b = omap_readb(idx);

ditto.

> +	return b;
> +}
> +
> +/* forward declarations */
> +static int omap_irda_set_speed(struct net_device *dev, int speed);
> +
> +static void omap_irda_start_rx_dma(struct omap_irda *omap_ir)
> +{
> +	/* Configure DMA */
> +	omap_set_dma_src_params(omap_ir->rx_dma_channel, 0x3, 0x0,
> +				omap_ir->pdata->src_start,
> +				0, 0);
> +
> +	omap_enable_dma_irq(omap_ir->rx_dma_channel, 0x01);
> +
> +	omap_set_dma_dest_params(omap_ir->rx_dma_channel, 0x0, 0x1,
> +				omap_ir->rx_buf_dma_phys,
> +				0, 0);
> +
> +	omap_set_dma_transfer_params(omap_ir->rx_dma_channel, 0x0,
> +				IRDA_SKB_MAX_MTU, 0x1,
> +				0x0, omap_ir->pdata->rx_trigger, 0);
> +
> +	omap_start_dma(omap_ir->rx_dma_channel);
> +}
> +
> +static void omap_start_tx_dma(struct omap_irda *omap_ir, int size)
> +{
> +	/* Configure DMA */
> +	omap_set_dma_dest_params(omap_ir->tx_dma_channel, 0x03, 0x0,
> +				omap_ir->pdata->dest_start, 0, 0);
> +
> +	omap_enable_dma_irq(omap_ir->tx_dma_channel, 0x01);
> +
> +	omap_set_dma_src_params(omap_ir->tx_dma_channel, 0x0, 0x1,
> +				omap_ir->tx_buf_dma_phys,
> +				0, 0);
> +
> +	omap_set_dma_transfer_params(omap_ir->tx_dma_channel, 0x0, size, 0x1,
> +				0x0, omap_ir->pdata->tx_trigger, 0);
> +
> +	/* Start DMA */
> +	omap_start_dma(omap_ir->tx_dma_channel);
> +}
> +
> +/* DMA RX callback - normally, we should not go here,
> + * it calls only if something is going wrong
> + */
> +static void omap_irda_rx_dma_callback(int lch, u16 ch_status, void *data)
> +{
> +	struct net_device *dev = data;
> +	struct omap_irda *omap_ir = netdev_priv(dev);
> +
> +	printk(KERN_ERR "RX Transfer error or very big frame\n");

you have a device pointer in omap_ir, use it and convert these to
dev_dbg() calls.

ditto to all below.

> +static int omap_irda_startup(struct net_device *dev)
> +{
> +	struct omap_irda *omap_ir = netdev_priv(dev);
> +
> +	/* FIXME: use clk_* apis for UART3 clock*/
> +	/* Enable UART3 clock and set UART3 to IrDA mode */
> +	if (machine_is_omap_h2() || machine_is_omap_h3())
> +		omap_writel(omap_readl(MOD_CONF_CTRL_0) | (1 << 31) | (1 << 15),
> +				MOD_CONF_CTRL_0);
> +
> +	/* Only for H2?
> +	 */
> +	if (omap_ir->pdata->transceiver_mode && machine_is_omap_h2()) {
> +		/* Is it select_irda on H2 ? */
> +		omap_writel(omap_readl(FUNC_MUX_CTRL_A) | 7,
> +					FUNC_MUX_CTRL_A);

__raw_writel/__raw_readl.

> +static int omap_irda_probe(struct platform_device *pdev)
> +{
> +	struct net_device *dev;
> +	struct omap_irda *omap_ir;
> +	struct omap_irda_config *pdata = pdev->dev.platform_data;
> +	unsigned int baudrate_mask;
> +	int err = 0;
> +	int irq = NO_IRQ;

you should probably have a struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

and use it to ioremap() the base address. Then you can stop using the
omap_read[bsl]/omap_write[bsl] calls and switch over to standard
__raw_read[bsl]/__raw_write[bsl] ones.

> +
> +	if (!pdata) {
> +		printk(KERN_ERR "IrDA Platform data not supplied\n");

		dev_dbg(&pdev->dev, "..");

> +		return -ENOENT;
> +	}
> +
> +	if (!pdata->rx_channel || !pdata->tx_channel) {
> +		printk(KERN_ERR "IrDA invalid rx/tx channel value\n");
		dev_dbg(&pdev->dev, "..");
> +		return -ENOENT;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0) {
> +		printk(KERN_WARNING "no irq for IrDA\n");

		dev_dbg(&pdev->dev, "..");

> +		return -ENOENT;
> +	}
> +
> +	dev = alloc_irdadev(sizeof(struct omap_irda));
> +	if (!dev)
> +		goto err_mem_1;
> +
> +

one blank line only.

> +	omap_ir = netdev_priv(dev);
> +	omap_ir->dev = &pdev->dev;
> +	omap_ir->pdata = pdata;
> +
> +	dev->hard_start_xmit	= omap_irda_hard_xmit;
> +	dev->open		= omap_irda_start;
> +	dev->stop		= omap_irda_stop;
> +	dev->do_ioctl		= omap_irda_ioctl;
> +	dev->get_stats		= omap_irda_stats;
> +	dev->irq		= irq;
> +
> +	irda_init_max_qos_capabilies(&omap_ir->qos);
> +
> +	baudrate_mask = 0;
> +	if (omap_ir->pdata->transceiver_cap & IR_SIRMODE)
> +		baudrate_mask |= IR_9600|IR_19200|IR_38400|IR_57600|IR_115200;
> +	if (omap_ir->pdata->transceiver_cap & IR_MIRMODE)
> +		baudrate_mask |= IR_57600 | IR_1152000;
> +	if (omap_ir->pdata->transceiver_cap & IR_FIRMODE)
> +		baudrate_mask |= IR_4000000 << 8;
> +
> +	omap_ir->qos.baud_rate.bits &= baudrate_mask;
> +	omap_ir->qos.min_turn_time.bits = 7;
> +
> +	irda_qos_bits_to_value(&omap_ir->qos);
> +
> +	/* Any better way to avoid this? No. */
> +	if (machine_is_omap_h3() || machine_is_omap_h4())
> +		INIT_DELAYED_WORK(&omap_ir->pdata->gpio_expa, NULL);

what does this mean ? what's that gpio_expa??

> +
> +	err = register_netdev(dev);
> +	if (!err)
> +		platform_set_drvdata(pdev, dev);
> +	else
> +		free_netdev(dev);
> +
> +err_mem_1:
> +	return err;
> +}
> +
> +static int omap_irda_remove(struct platform_device *pdev)
> +{
> +	struct net_device *dev = platform_get_drvdata(pdev);
> +
> +	if (pdev) {
> +		unregister_netdev(dev);
> +		free_netdev(dev);
> +	}

pdev is always true here, remove this if().

> +	return 0;
> +}
> +
> +static struct platform_driver omapir_driver = {
> +	.probe		= omap_irda_probe,
> +	.remove		= omap_irda_remove,
> +	.suspend	= omap_irda_suspend,
> +	.resume		= omap_irda_resume,
> +	.driver		= {
> +		.name	= "omapirda",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static char __initdata banner[] = KERN_INFO "OMAP IrDA driver initializing\n";
> +
> +static int __init omap_irda_init(void)
> +{
> +	printk(banner);

you can remove this banner. No need for it.

> +	return platform_driver_register(&omapir_driver);
> +}
> +
> +static void __exit omap_irda_exit(void)
> +{
> +	platform_driver_unregister(&omapir_driver);
> +}
> +
> +module_init(omap_irda_init);
> +module_exit(omap_irda_exit);
> +
> +MODULE_AUTHOR("MontaVista");
> +MODULE_DESCRIPTION("OMAP IrDA Driver");
> +MODULE_LICENSE("GPL");

-- 
balbi
