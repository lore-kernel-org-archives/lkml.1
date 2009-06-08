Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZFHIbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZFHIbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZFHIb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:31:27 -0400
Received: from smtp20.doorway.no ([212.4.49.47]:4601 "EHLO smtp20.doorway.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZFHIb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:31:26 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2009 04:31:25 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] atmel_serial: Fix hang in set_termios when crtscts is enabled
Date: Mon, 8 Jun 2009 10:24:51 +0200
Message-ID: <1DC0FF5051B91B4D88A15F21F1A27F4176AE6A@dware1013.doorway.loc>
In-Reply-To: <1244448921-22942-1-git-send-email-haavard.skinnemoen@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel_serial: Fix hang in set_termios when crtscts is enabled
Thread-Index: AcnoEVCoq+z6VWjTRi+ciPyf39IcYwAACCbw
References: <1244448921-22942-1-git-send-email-haavard.skinnemoen@atmel.com>
From: "Eirik Aanonsen" <eaa@wprmedical.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Cc: <kernel@avr32linux.org>, <linux-kernel@vger.kernel.org>,
       "Nicolas Ferre" <Nicolas.FERRE@atmel.com>,
       "Andrew Victor" <avictor.za@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Fix it by removing the busy-loop altogether.
> 
> Reported-by: Eirik Aanonsen <eaa@wprmedical.com>
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---
> I have not tested this patch yet. Eirik, can you give it a try?
> 
>  drivers/serial/atmel_serial.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/serial/atmel_serial.c
> b/drivers/serial/atmel_serial.c
> index b3497d7..338b15c 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -1104,11 +1104,13 @@ static void atmel_set_termios(struct uart_port
> *port, struct ktermios *termios,
>  	/* update the per-port timeout */
>  	uart_update_timeout(port, termios->c_cflag, baud);
> 
> -	/* save/disable interrupts and drain transmitter */
> +	/*
> +	 * save/disable interrupts. The tty layer will ensure that the
> +	 * transmitter is empty if requested by the caller, so there's
> +	 * no need to wait for it here.
> +	 */
>  	imr = UART_GET_IMR(port);
>  	UART_PUT_IDR(port, -1);
> -	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
> -		cpu_relax();
> 
>  	/* disable receiver and transmitter */
>  	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
> --
> 1.6.0.4

Works like a charm :) Thanx. I sis not use the patch but I just 
Added a 0& inside the condition to the while loop.


Regards
____________________________________________________
 
Eirik Aanonsen
SW Developer
E-mail: eaa@wprmedical.com 
Phone: +47 90 68 11 92
Fax: +47 37 03 56 77
____________________________________________________



