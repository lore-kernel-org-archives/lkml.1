Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab0CBFv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 00:51:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37558 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0CBFvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 00:51:24 -0500
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Tony Lindgren <tony@atomide.com>,
       "Raja, Govindraj" <govindraj.raja@ti.com>
CC: Greg KH <greg@kroah.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Olof Johansson <olof@lixom.net>
Date: Tue, 2 Mar 2010 11:21:13 +0530
Subject: RE: [PATCH] serial: Add OMAP high-speed UART driver.
Thread-Topic: [PATCH] serial: Add OMAP high-speed UART driver.
Thread-Index: Acq5b17/zA9YukSIR8maWHSqIjS9YwAW7HlA
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E94026ED95FC1@dbde02.ent.ti.com>
References: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
 <20100301184600.GC3389@atomide.com>
In-Reply-To: <20100301184600.GC3389@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Tony Lindgren
> Sent: Tuesday, March 02, 2010 12:16 AM
> To: Raja, Govindraj
> Cc: Greg KH; linux-serial@vger.kernel.org; 
> linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; 
> Kevin Hilman; Olof Johansson
> Subject: Re: [PATCH] serial: Add OMAP high-speed UART driver.
> 
> * Govindraj.R <govindraj.raja@ti.com> [100301 06:40]:
> > --- /dev/null
> > +++ b/drivers/serial/omap-serial.c
> > +
> > +static void serial_omap_stop_tx(struct uart_port *port)
> > +{
> > +	struct uart_omap_port *up = (struct uart_omap_port *)port;
> > +
> > +	if (up->use_dma &&
> > +		up->uart_dma.tx_dma_channel != OMAP_UART_DMA_CH_FREE) {
> > +		/*
> > +		 * Check if dma is still active . If yes do nothing,
> 
> Looks like an extra space here before the period above.
> 
> ...
> 
> > +static int serial_omap_start_rxdma(struct uart_omap_port *up)
> > +{
> > +	int ret = 0;
> > +
> > +	if (up->uart_dma.rx_dma_channel == -1) {
> > +		ret = omap_request_dma(up->uart_dma.uart_dma_rx,
> > +				"UART Rx DMA",
> > +				(void *)uart_rx_dma_callback, up,
> > +				&(up->uart_dma.rx_dma_channel));
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		omap_set_dma_src_params(up->uart_dma.rx_dma_channel, 0,
> > +				OMAP_DMA_AMODE_CONSTANT,
> > +				up->uart_dma.uart_base, 0, 0);
> > +		omap_set_dma_dest_params(up->uart_dma.rx_dma_channel, 0,
> > +				OMAP_DMA_AMODE_POST_INC,
> > +				up->uart_dma.rx_buf_dma_phys, 0, 0);
> > +		
> omap_set_dma_transfer_params(up->uart_dma.rx_dma_channel,
> > +				OMAP_DMA_DATA_TYPE_S8,
> > +				up->uart_dma.rx_buf_size, 1,
> > +				OMAP_DMA_SYNC_ELEMENT,
> > +				up->uart_dma.uart_dma_rx, 0);
> > +	}
> > +	up->uart_dma.prev_rx_dma_pos = up->uart_dma.rx_buf_dma_phys;
> > +	if (cpu_is_omap44xx())
> > +		omap_writel(0, OMAP44XX_DMA4_BASE
> > +			+ OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> > +	else
> > +		omap_writel(0, OMAP34XX_DMA4_BASE
> > +			+ OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> 
> NAK. Please don't use omap_read/write for for new code. And do not
> tinker with the omap hardware registers directly in the driver.
> 
> This needs to be done properly in arch/arm/plat-omap/dma.c instead.

Thanks for the suggestion.

Currently, dma_read/dma_write are #define's in dma.c which cannot be 
accessed outside dma.c. I don't see any API's in dma.c for setting required 
value for this register?

Can we move dma_read/dma_write to header file so that it can be global or 
Is there alternate way to perform this operation with existing dma driver?

-Manjunath