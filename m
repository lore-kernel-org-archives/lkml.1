Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYA2XMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYA2XMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYA2XMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:12:31 -0500
Received: from ms01.sssup.it ([193.205.80.99]:58241 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbYA2XMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:12:30 -0500
Message-ID: <479FB2D7.4020804@gandalf.sssup.it>
Date: Wed, 30 Jan 2008 00:12:23 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>, Marc Pignat <marc.pignat@hevs.ch>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>
In-Reply-To: <20080129224316.GA23155@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> From: Remy Bohmer <linux@bohmer.net>
>>
>> This patch splits up the interrupt handler of the serial port
>> into a interrupt top-half and a tasklet.
>>
>> The goal is to get the interrupt top-half as short as possible to
>> minimize latencies on interrupts. But the old code also does some
>> calls in the interrupt handler that are not allowed on preempt-RT
>> in IRQF_NODELAY context. This handler is executed in this context
>> because of the interrupt sharing with the timer interrupt.
>> +static void
>> +atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
>> +		     unsigned int ch)
>> +{
>> +	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
>> +	struct circ_buf *ring = &atmel_port->rx_ring;
>> +	struct atmel_uart_char *c;
>>     

I'm testing this patch on an at91sam9260 on 2.6.24-rt. I'm using this
patch with the tclib support for hrtimer and the clocksource pit_clk.
These are the results:

- Voluntary Kernel Preemption the system (crash)
- Preemptible  Kernel (crash)

/*
 * Drop the lock here since it might end up calling
 * uart_start(), which takes the lock.
   spin_unlock(&port->lock);
 */
    tty_flip_buffer_push(port->info->tty);
/*
    spin_lock(&port->lock);
 */
The same code with this comments out runs

Complete Preemption (Real-Time) ok but the serials is just unusable due
to too many overruns (just using lrz)

The system is stable and doesn't crash reverting this patch.
I don't test with the thread hardirqs active.

>> +
>> +	if (!CIRC_SPACE(ring->head, ring->tail, ATMEL_SERIAL_RINGSIZE))
>> +		/* Buffer overflow, ignore char */
>> +		return;
>> +
>> +	c = &((struct atmel_uart_char *)ring->buf)[ring->head];
>> +	c->status	= status;
>> +	c->ch		= ch;
>> +
>> +	/* Make sure the character is stored before we update head. */
>> +	smp_wmb();
>> +
>> +	ring->head = (ring->head + 1) & (ATMEL_SERIAL_RINGSIZE - 1);
>> +}
>> +
>>     
...
>> +
>>  	port = &atmel_ports[pdev->id];
>>  	atmel_init_port(port, pdev);
>>  
>> +	ret = -ENOMEM;
>> +	data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
>> +	if (!data)
>> +		goto err_alloc_ring;
>> +	port->rx_ring.buf = data;
>> +
>>  	ret = uart_add_one_port(&atmel_uart, &port->uart);
>>     
Is the kmalloc correct?
maybe:
data = kmalloc(ATMEL_SERIAL_RINGSIZE * sizeof(struct atmel_uart_char), 
GFP_KERNEL);
>>  	if (ret)
>>  		goto err_add_port;
>> @@ -1013,6 +1142,9 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
>>  	return 0;
>>  
>>  err_add_port:
>> +	kfree(port->rx_ring.buf);
>> +	port->rx_ring.buf = NULL;
>> +err_alloc_ring:
>>  	if (!atmel_is_console_port(&port->uart)) {
>>  		clk_disable(port->clk);
>>  		clk_put(port->clk);
>> @@ -1033,6 +1165,9 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
>>  
>>  	ret = uart_remove_one_port(&atmel_uart, port);
>>  
>> +	tasklet_kill(&atmel_port->tasklet);
>> +	kfree(atmel_port->rx_ring.buf);
>> +
>>     
Why the tasklet_kill is not done in atmel_shutdown?

Regards
Michael


