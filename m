Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXLSJuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXLSJuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXLSJun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:50:43 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52623 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbXLSJum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:50:42 -0500
Date: Wed, 19 Dec 2007 10:50:09 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: Re: [PATCH 4/5] atmel_serial: Split the interrupt handler
Message-ID: <20071219105009.744b6a5e@dhcp-252-066.norway.atmel.com>
In-Reply-To: <4768548C.9040005@gmail.com>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-2-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-3-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-4-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-5-git-send-email-hskinnemoen@atmel.com>
	<4768548C.9040005@gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 00:15:24 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 12/18/2007 06:06 PM, Haavard Skinnemoen wrote:
> >  	port = &atmel_ports[pdev->id];
> >  	atmel_init_port(port, pdev);
> >  
> > +	data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
> > +	if (!data)
> 
> {
>         clk_disable(atmel_port->clk);
>         clk_put(atmel_port->clk);

Indeed, thanks.

Hmm...the existing error path gets this wrong too. It's actually a
bit risky to disable the clock here since we might end up losing the
console.

I wonder what we're really supposed to do if the console is initialized
successfully, but the corresponding device fails to probe...?

> > @@ -1022,6 +1144,7 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
> >  
> >  	if (port) {
> >  		ret = uart_remove_one_port(&atmel_uart, port);
> 
> Don't you need tasklet_kill() here (or somewhere)?

Absolutely. Thanks again.

> > +		kfree(atmel_port->rx_ring.buf);
> >  		kfree(port);

Hmm...this actually looks like a bug too. "port" is allocated
statically, so it shouldn't be freed. I wonder if anyone ever use this
driver as a module?

Haavard
