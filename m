Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0CASo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:44:59 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52599 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0CASo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:44:57 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1911cc1aN7sF7/diTmrYAjA
Date: Mon, 1 Mar 2010 10:46:00 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Govindraj.R" <govindraj.raja@ti.com>
Cc: Greg KH <greg@kroah.com>, linux-serial@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] serial: Add OMAP high-speed UART driver.
Message-ID: <20100301184600.GC3389@atomide.com>
References: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Govindraj.R <govindraj.raja@ti.com> [100301 06:40]:
> --- /dev/null
> +++ b/drivers/serial/omap-serial.c
> +
> +static void serial_omap_stop_tx(struct uart_port *port)
> +{
> +	struct uart_omap_port *up = (struct uart_omap_port *)port;
> +
> +	if (up->use_dma &&
> +		up->uart_dma.tx_dma_channel != OMAP_UART_DMA_CH_FREE) {
> +		/*
> +		 * Check if dma is still active . If yes do nothing,

Looks like an extra space here before the period above.

...

> +static int serial_omap_start_rxdma(struct uart_omap_port *up)
> +{
> +	int ret = 0;
> +
> +	if (up->uart_dma.rx_dma_channel == -1) {
> +		ret = omap_request_dma(up->uart_dma.uart_dma_rx,
> +				"UART Rx DMA",
> +				(void *)uart_rx_dma_callback, up,
> +				&(up->uart_dma.rx_dma_channel));
> +		if (ret < 0)
> +			return ret;
> +
> +		omap_set_dma_src_params(up->uart_dma.rx_dma_channel, 0,
> +				OMAP_DMA_AMODE_CONSTANT,
> +				up->uart_dma.uart_base, 0, 0);
> +		omap_set_dma_dest_params(up->uart_dma.rx_dma_channel, 0,
> +				OMAP_DMA_AMODE_POST_INC,
> +				up->uart_dma.rx_buf_dma_phys, 0, 0);
> +		omap_set_dma_transfer_params(up->uart_dma.rx_dma_channel,
> +				OMAP_DMA_DATA_TYPE_S8,
> +				up->uart_dma.rx_buf_size, 1,
> +				OMAP_DMA_SYNC_ELEMENT,
> +				up->uart_dma.uart_dma_rx, 0);
> +	}
> +	up->uart_dma.prev_rx_dma_pos = up->uart_dma.rx_buf_dma_phys;
> +	if (cpu_is_omap44xx())
> +		omap_writel(0, OMAP44XX_DMA4_BASE
> +			+ OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> +	else
> +		omap_writel(0, OMAP34XX_DMA4_BASE
> +			+ OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));

NAK. Please don't use omap_read/write for for new code. And do not
tinker with the omap hardware registers directly in the driver.

This needs to be done properly in arch/arm/plat-omap/dma.c instead.

We really don't want drivers tinkering with the omap hardware
registers directly except for the driver block registers.

Regards,

Tony
