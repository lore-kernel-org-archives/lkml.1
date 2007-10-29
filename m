Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXJ2C44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXJ2C44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXJ2C4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:56:49 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37581 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293AbXJ2C4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:56:48 -0400
Message-ID: <47254BEB.2040609@snapgear.com>
Date: Mon, 29 Oct 2007 12:56:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: new style ColdFire UART driver
References: <200710190142.l9J1gfxk003771@goober> <20071026142328.d06a1b3b.akpm@linux-foundation.org>
In-Reply-To: <20071026142328.d06a1b3b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Fri, 19 Oct 2007 11:42:41 +1000
> Greg Ungerer <gerg@snapgear.com> wrote:
> 
>> A new style serial driver for the Freescale ColdFire UART to replace
>> the old style one currently in the tree (drivers/serial/mcfserial.c).
>>
>> Currently this UART is only found in the ColdFire CPU family of parts
>> (thus I prefixed this patch [M68KNOMMU]).
>>
>> This has been around for a long while now, tested on all available
>> platforms.
>>
>> ...
>>
> 
> All of these:
> 
>> +/****************************************************************************/
> 
> don't really add much value.
> 
>> +static unsigned int mcf_get_mctrl(struct uart_port *port)
>> +{
>> +	struct mcf_uart *pp = (struct mcf_uart *) port;
> 
> container_of() would be nicer: it explains what's going on and removes the
> unpleasing requirement that uart_port be the first member of mcf_uart.
> 
>> +static void mcf_set_mctrl(struct uart_port *port, unsigned int sigs)
>> +{
>> +	struct mcf_uart *pp = (struct mcf_uart *) port;
> 
> Many instances..

Ok, I'll change those over to container_of().


>> +static void mcf_set_termios(struct uart_port *port, struct ktermios *termios,
>> +	struct ktermios *old)
>> +{
>> +	unsigned long flags;
>> +	unsigned int baud, baudclk;
>> +	unsigned char mr1, mr2;
> 
> Is this all up-to-date with Alan's recent termios changes?

As far as I can tell, yes.


>> +static struct mcf_uart mcf_ports[3];
>> +
>> +#define	MCF_MAXPORTS	(sizeof(mcf_ports) / sizeof(struct mcf_uart))
> 
> Use ARRAY_SIZE here.

Yep, I'll change that.


>> +/****************************************************************************/
>> +#if defined(CONFIG_SERIAL_MCF_CONSOLE)
>> +/****************************************************************************/
>> +
>> +int __init early_mcf_setup(struct mcf_platform_uart *platp)
> 
> hrm, this is global and has no callers.
> 
>> +{
>> +	struct uart_port *port;
>> +	int i;
>> +
>> +	for (i = 0; ((i < MCF_MAXPORTS) && (platp[i].mapbase)); i++) {
>> +		port = &mcf_ports[i].port;
>> +
>> +		port->line = i;
>> +		port->type = PORT_MCF;
>> +		port->mapbase = platp[i].mapbase;
>> +		port->membase = (platp[i].membase) ? platp[i].membase :
>> +			(unsigned char __iomem *) port->mapbase;
>> +		port->iotype = SERIAL_IO_MEM;
>> +		port->irq = platp[i].irq;
>> +		port->uartclk = MCF_BUSCLK;
>> +		port->flags = ASYNC_BOOT_AUTOCONF;
>> +		port->ops = &mcf_uart_ops;
>> +	}
>> +
>> +	return 0;
>> +}
>> +

It is intended to be used by ColdFire platforms that want early
boot console support. The old driver (drivers/serial/mcfserial.c)
sort of gave you this for free with its fixed resourcing.
I have changes to the ColdFire based m68knommu systems to
use a platform model at init, and this is used there.

Thanks.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
