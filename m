Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbYISORV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbYISORV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYISORE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:17:04 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:33252 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYISORA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:17:00 -0400
Date: Fri, 19 Sep 2008 16:16:25 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anti Sullin <anti.sullin@artecdesign.ee>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91 Serial: update the powersave handler to match
 serial core
Message-ID: <20080919161625.360e514d@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48D3AE78.207@artecdesign.ee>
References: <48CE42C8.1090608@artecdesign.ee>
	<20080919150938.08b2c7be@hskinnemo-gx745.norway.atmel.com>
	<48D3AE78.207@artecdesign.ee>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 14:16:16.0868 (UTC) FILETIME=[47B12A40:01C91A62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anti Sullin <anti.sullin@artecdesign.ee> wrote:
> Haavard Skinnemoen wrote:
> > Not good. I suspect we need to stop DMA as well though...or wait until
> > it's drained.
> Right... I found independently the DMA problem with video controller DMA and suspend a week ago (but as I left some devices
> to do automated testing for the weekend, your patch had fixed it when I looked the kernel on monday morning... how ironic) and
> we wouldn't want another such bug.
> But the serial driver had already switched off the clocks for ages and so long I haven't found any crashes...

Maybe the tty layer ensures that the buffer is empty before
suspending...would be interesting to know. In any case, any such bug
would probably be insanely difficult to trigger, so I think we should
stop the PDC just in case.

> > 
> >> The patch is against 2.6.25.3 + at91 patchset at maxim.org.za. 
> > 
> > It doesn't apply to latest mainline, but I'll try to cram it in somehow.
> Sorry, my production devices are currently using 25.3...
> Use this e-mail just as bug report.

Ok, I think I managed to apply it correctly. I'm going to test it now;
you'll see the result when I send it upstream (this is 2.6.27 material,
I think.)

> After I fixed this and the LCDC DMA, i did 400k suspend cycles on parallel with multiple devices for testing and
> I did not get any crashes.

Nice.

> > A few questions though...
> > 
> >> diff -purN linux-2.6.25.3/drivers/serial/atmel_serial.c linux-2.6.25.3_ok/drivers/serial/atmel_serial.c
> >> --- linux-2.6.25.3/drivers/serial/atmel_serial.c	2008-05-10 07:48:50.000000000 +0300
> >> +++ linux-2.6.25.3_ok/drivers/serial/atmel_serial.c	2008-09-08 12:35:35.000000000 +0300
> >> @@ -132,7 +132,8 @@ struct atmel_uart_char {
> >>  struct atmel_uart_port {
> >>  	struct uart_port	uart;		/* uart */
> >>  	struct clk		*clk;		/* uart clock */
> >> -	unsigned short		suspended;	/* is port suspended? */
> >> +	int			may_wakeup;		/* cached value of device_may_wakeup for times we need to disable it */
> >> +	int			backup_imr;		/* back up the IMR during suspend */
> > 
> > Since this is a hardware register, shouldn't it be u32?
> Yep...

I'll change it.

> > 
> >> @@ -1264,6 +1273,8 @@ void __init atmel_register_uart_fns(stru
> >>  #ifdef CONFIG_SERIAL_ATMEL_CONSOLE
> >>  static void atmel_console_putchar(struct uart_port *port, int ch)
> >>  {
> >> +	if (port->suspended) return;
> >> +
> >>  	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
> >>  		cpu_relax();
> >>  	UART_PUT_CHAR(port, ch);
> >> @@ -1278,6 +1289,8 @@ static void atmel_console_write(struct c
> >>  	unsigned int status, imr;
> >>  	unsigned int pdc_tx;
> >>  
> >> +	if (port->suspended) return;
> >> +
> > 
> > Are both of these checks necessary? It doesn't look like
> > atmel_console_putchar() can be called from anywhere else than
> > atmel_console_write().
> Actually, not so much. I added them for protection so that we wouldn't run into
> a deadlock loop if something changes again. Those while() loops make me cautious.
> And I didn't have the time to look up if the suspend code is thread-safe without this.

I don't think it's much safer with that extra check if suspend can be
called in parallel with this. In that case, the only way to make
_absolutely_ sure would be to move the test inside the while loops.

And I only think this actually matters if console suspend is disabled,
which should probably never happen on a production system. So I'm
wondering if we really need any of those checks.

> I had once a bug in my RTT driver (before there was any RTT driver in mainline),
> that left the RTT interrupt flag set and this blocked the sysc interrupt. This was
> a pain to debug and I try to avoid such problems as much as I can.
> With RTT, even the WDT did not help as the WDT does not reset RTT and so if this
> happened, the device just ran into WDT resetting loop until the battery died.

Understand. 

> > 
> > Also, does the no_console_suspend parameter still work after this?
> Didn't try that one as I do only slow clock suspend, not standby.

Ok, I'll try it.

> Actually, I had an idea to implement the wakeup with GPIO interrupt. So that
> we could wake up even when we're running on slow clock.

Yes, that would be pretty cool.

Haavard
