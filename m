Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXLRXPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXLRXPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbXLRXPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:15:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:3031 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbXLRXPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SqR3NxPWOacLgGt8rxZE58lTpGH0flwxgl8FnXJmwFaOAMF6Gu4gPLFAIM3yl63zIE83Vk9IwiqtxQtEDIy8G0sJzTkdUSLK7QxZAPn+Cn/vkATGadRWRNfAso5ugbOCQlXca9c1njTyYqrI7RnbJTejys8x6czq4S1XQFQFd5w=
Message-ID: <4768548C.9040005@gmail.com>
Date: Wed, 19 Dec 2007 00:15:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: Re: [PATCH 4/5] atmel_serial: Split the interrupt handler
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-2-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-3-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-4-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-5-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1197997575-13292-5-git-send-email-hskinnemoen@atmel.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2007 06:06 PM, Haavard Skinnemoen wrote:
> From: Remy Bohmer <hskinnemoen@atmel.com>
> 
> This patch splits up the interrupt handler of the serial port
> into a interrupt top-half and a tasklet.
[...]
> [hskinnemoen@atmel.com: misc cleanups and simplifications]
> Signed-off-by: Remy Bohmer <linux@bohmer.net>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/serial/atmel_serial.c |  215 ++++++++++++++++++++++++++++++++---------
>  1 files changed, 169 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index a6b3828..990d3ab 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
[...]
> @@ -994,11 +1108,19 @@ static int atmel_serial_resume(struct platform_device *pdev)
>  static int __devinit atmel_serial_probe(struct platform_device *pdev)
>  {
>  	struct atmel_uart_port *port;
> +	void *data;
>  	int ret;
>  
> +	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
> +
>  	port = &atmel_ports[pdev->id];
>  	atmel_init_port(port, pdev);
>  
> +	data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
> +	if (!data)

{
        clk_disable(atmel_port->clk);
        clk_put(atmel_port->clk);


> +		return -ENOMEM;

}

> +	port->rx_ring.buf = data;
> +
>  	ret = uart_add_one_port(&atmel_uart, &port->uart);
>  	if (!ret) {
>  		device_init_wakeup(&pdev->dev, 1);
> @@ -1022,6 +1144,7 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
>  
>  	if (port) {
>  		ret = uart_remove_one_port(&atmel_uart, port);

Don't you need tasklet_kill() here (or somewhere)?

> +		kfree(atmel_port->rx_ring.buf);
>  		kfree(port);
>  	}
>  
