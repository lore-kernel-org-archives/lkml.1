Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYDHIcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYDHIcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYDHIci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:32:38 -0400
Received: from mail.hevs.ch ([153.109.23.10]:60964 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbYDHIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:32:38 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] atmel serial reduce trasmitting window & code style patch
Date: Tue, 8 Apr 2008 10:32:31 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <524838.25009.qm@web26206.mail.ukl.yahoo.com>
In-Reply-To: <524838.25009.qm@web26206.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081032.32883.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I just inlined your second patch for commenting.

On Thursday 03 April 2008, Michael Trimarchi wrote:
> Hi,
...
> http://it.docs.yahoo.com/mail/overview/index.html

> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 9f58eb3..511a0cc 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -123,6 +123,7 @@ struct atmel_uart_char {
>  };
>  
>  #define ATMEL_SERIAL_RINGSIZE	1024
> +#define ATMEL_SERIAL_TXSIZE	32
>  
>  /*
>   * We wrap our port structure around the generic uart_port.
> @@ -426,6 +427,7 @@ static void atmel_rx_chars(struct uart_port *port)
>  static void atmel_tx_chars(struct uart_port *port)
>  {
>  	struct circ_buf *xmit = &port->info->xmit;
> +	int count = 0;
 
>  	if (port->x_char && UART_GET_CSR(port) & ATMEL_US_TXRDY) {
>  		UART_PUT_CHAR(port, port->x_char);
> @@ -435,10 +437,12 @@ static void atmel_tx_chars(struct uart_port *port)
>  	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
>  		return;
>  
> -	while (UART_GET_CSR(port) & ATMEL_US_TXRDY) {
> +	while (UART_GET_CSR(port) & ATMEL_US_TXRDY &&
> +	       count < ATMEL_SERIAL_TXSIZE) {
>  		UART_PUT_CHAR(port, xmit->buf[xmit->tail]);
>  		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
>  		port->icount.tx++;
> +		count++;
>  		if (uart_circ_empty(xmit))
>  			break;
>  	}
For me this loop will never run more than 2-3 times.
The CPU is much faster than the serial transmitter, so after 2 loops
UART_GET_CSR(port) & ATMEL_US_TXRDY will be false and the loop will exit.

If your patch does something, I can't understand how!

Best regards

Marc
