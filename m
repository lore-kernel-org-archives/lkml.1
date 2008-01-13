Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYAMWvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYAMWvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbYAMWvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:51:11 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:41728 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754334AbYAMWvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:51:09 -0500
Message-ID: <478A95DB.80407@suspend2.net>
Date: Mon, 14 Jan 2008 09:51:07 +1100
From: nigel@suspend2.net
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't
 drain
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk> <20080111101721.GA4463@ucw.cz>
In-Reply-To: <20080111101721.GA4463@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Pavel Machek wrote:
> On Tue 2008-01-08 11:57:03, Russell King wrote:
>> Some ports seem to be unable to drain their transmitters on shut down.
>> Such a problem can occur if the port is programmed for hardware imposed
>> flow control, characters are in the FIFO but the CTS signal is inactive.
>>
>> Normally, this isn't a problem because most places where we wait for the
>> transmitter to drain have a time-out.  However, there is no timeout in
>> the suspend path.
>>
>> Give a port 30ms to drain; this is an arbitary value chosen to avoid
>> long delays if there are many such ports in the system, while giving a
>> reasonable chance for a single port to drain.  Should a port not drain
>> within this timeout, issue a warning.
>>
>> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>>
>> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
>> index 3bb5d24..4ce219c 100644
>> --- a/drivers/serial/serial_core.c
>> +++ b/drivers/serial/serial_core.c
>> @@ -1977,6 +1977,7 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
>>  
>>  	if (state->info && state->info->flags & UIF_INITIALIZED) {
>>  		const struct uart_ops *ops = port->ops;
>> +		int tries;
>>  
>>  		state->info->flags = (state->info->flags & ~UIF_INITIALIZED)
>>  				     | UIF_SUSPENDED;
>> @@ -1990,9 +1991,14 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
>>  		/*
>>  		 * Wait for the transmitter to empty.
>>  		 */
>> -		while (!ops->tx_empty(port)) {
>> +		for (tries = 3; !ops->tx_empty(port) && tries; tries--) {
>>  			msleep(10);
>>  		}
>> +		if (!tries)
>> +			printk(KERN_ERR "%s%s%s%d: Unable to drain transmitter\n",
>> +			       port->dev ? port->dev->bus_id : "",
>> +			       port->dev ? ": " : "",
>> +			       drv->dev_name, port->line);
>>  
>>  		ops->shutdown(port);
>>  	}
>>
> 
> Is printk() enough for 'we've just lost your data' condition? Maybe we
> should abort suspend if we can't drain fifo?

No way. Think about this from a users' perspective. No one wants suspend
to ram or hibernate functionality that works sometimes and not others.
They want it to work reliably so they don't have to worry about their
laptop overheating while they're getting on the bus or airplane.
Aborting isn't an option.

Regards,

Nigel
