Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXDZVtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXDZVtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXDZVtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:49:02 -0400
Received: from mta16.adelphia.net ([68.168.78.211]:54562 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbXDZVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:48:58 -0400
Message-ID: <46311E48.4070106@acm.org>
Date: Thu, 26 Apr 2007 16:48:56 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] serial 8250: move push calls out of lock
References: <20070426205103.GA28569@localdomain> <20070426205847.GB11735@flint.arm.linux.org.uk>
In-Reply-To: <20070426205847.GB11735@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Thu, Apr 26, 2007 at 03:51:03PM -0500, Corey Minyard wrote:
>   
>> This time to lkml...
>>     
>
> NAK.  Did you read your own patch, let alone try to build it?  It's
> also utterly broken.  See comments below.
>   
The patch builds without error or warning and seems to work just fine.
>   
>> Subject: serial 8250: move push calls out of lock
>>
>> Due to previous changes in the 8250 driver, the call to
>> tty_flip_buffer_push is now done with interrupts disabled.  Not really
>> a huge deal, but sub-optimal.
>>
>> This patch moves all of the "wake up, you have data" operations out of
>> the lock.  This will run a little faster by avoiding dropping and
>> retaking the lock in the receive handler and will make the polled
>> serial code (which I am working on) easier to do.
>>
>> >From Alan Cox:
>>
>> This is actually a very good idea as it means you don't have to deal with
>> the problems with low_latency causing re-entry into the driver under the
>> lock so its conceptually much easier to follow the locking
>>
>>
>> Signed-off-by: Corey Minyard <minyard@acm.org>
>> Acked-by: Alan Cox <alan@redhat.com>
>>
>>  drivers/serial/8250.c |   53 +++++++++++++++++++++++++++++++-------------------
>>  1 file changed, 33 insertions(+), 20 deletions(-)
>>
>> Index: linux-2.6.21/drivers/serial/8250.c
>> ===================================================================
>> --- linux-2.6.21.orig/drivers/serial/8250.c
>> +++ linux-2.6.21/drivers/serial/8250.c
>> @@ -1146,7 +1146,7 @@ static void serial8250_stop_tx(struct ua
>>  	}
>>  }
>>  
>> -static void transmit_chars(struct uart_8250_port *up);
>> +static int transmit_chars(struct uart_8250_port *up);
>>  
>>  static void serial8250_start_tx(struct uart_port *port)
>>  {
>> @@ -1195,10 +1195,8 @@ static void serial8250_enable_ms(struct 
>>  	serial_out(up, UART_IER, up->ier);
>>  }
>>  
>> -static void
>> -receive_chars(struct uart_8250_port *up, unsigned int *status)
>> +static int receive_chars(struct uart_8250_port *up, unsigned int *status)
>>  {
>> -	struct tty_struct *tty = up->port.info->tty;
>>  	unsigned char ch, lsr = *status;
>>  	int max_count = 256;
>>  	char flag;
>> @@ -1262,30 +1260,30 @@ receive_chars(struct uart_8250_port *up,
>>  	ignore_char:
>>  		lsr = serial_inp(up, UART_LSR);
>>  	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
>> -	spin_unlock(&up->port.lock);
>> -	tty_flip_buffer_push(tty);
>> -	spin_lock(&up->port.lock);
>>  	*status = lsr;
>> +
>> +	return 1;
>>  }
>>  
>> -static void transmit_chars(struct uart_8250_port *up)
>> +static int transmit_chars(struct uart_8250_port *up)
>>  {
>>  	struct circ_buf *xmit = &up->port.info->xmit;
>>  	int count;
>> +	int xmit_ready = 0;
>>  
>>  	if (up->port.x_char) {
>>  		serial_outp(up, UART_TX, up->port.x_char);
>>  		up->port.icount.tx++;
>>  		up->port.x_char = 0;
>> -		return;
>> +		return 0;
>>  	}
>>  	if (uart_tx_stopped(&up->port)) {
>>  		serial8250_stop_tx(&up->port);
>> -		return;
>> +		return 0;
>>  	}
>>  	if (uart_circ_empty(xmit)) {
>>  		__stop_tx(up);
>> -		return;
>> +		return 0;
>>  	}
>>  
>>  	count = up->tx_loadsz;
>> @@ -1298,18 +1296,22 @@ static void transmit_chars(struct uart_8
>>  	} while (--count > 0);
>>  
>>  	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
>> -		uart_write_wakeup(&up->port);
>> +		xmit_ready = 1;
>>  
>>  	DEBUG_INTR("THRE...");
>>  
>>  	if (uart_circ_empty(xmit))
>>  		__stop_tx(up);
>> +
>> +	return xmit_ready;
>>  }
>>  
>> -static unsigned int check_modem_status(struct uart_8250_port *up)
>> +static int check_modem_status(struct uart_8250_port *up, unsigned int *rstatus)
>>  {
>>  	unsigned int status = serial_in(up, UART_MSR);
>>  
>> +	if (rstatus)
>> +		*rstatus = status;
>>  	if (status & UART_MSR_ANY_DELTA && up->ier & UART_IER_MSI &&
>>  	    up->port.info != NULL) {
>>  		if (status & UART_MSR_TERI)
>> @@ -1320,11 +1322,10 @@ static unsigned int check_modem_status(s
>>  			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
>>  		if (status & UART_MSR_DCTS)
>>  			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
>> -
>> -		wake_up_interruptible(&up->port.info->delta_msr_wait);
>> +		return 1;
>>  	}
>>  
>> -	return status;
>> +	return 0;
>>  }
>>  
>>  /*
>> @@ -1334,6 +1335,9 @@ static inline void
>>  serial8250_handle_port(struct uart_8250_port *up)
>>  {
>>  	unsigned int status;
>> +	int xmit_ready = 0;
>> +	int recv_ready = 0;
>> +	int msr_ready = 0;
>>  	unsigned long flags;
>>  
>>  	spin_lock_irqsave(&up->port.lock, flags);
>> @@ -1343,12 +1347,21 @@ serial8250_handle_port(struct uart_8250_
>>  	DEBUG_INTR("status = %x...", status);
>>  
>>  	if (status & UART_LSR_DR)
>> -		receive_chars(up, &status);
>> -	check_modem_status(up);
>> +		recv_ready = receive_chars(up, &status);
>> +	msr_ready = check_modem_status(up, NULL);
>>  	if (status & UART_LSR_THRE)
>> -		transmit_chars(up);
>> +		xmit_ready = transmit_chars(up);
>>  
>>  	spin_unlock_irqrestore(&up->port.lock, flags);
>> +
>> +	if (recv_ready)
>> +		tty_flip_buffer_push(up->port.info->tty);
>> +
>> +	if (msr_ready)
>> +		wake_up_interruptible(&up->port.info->delta_msr_wait);
>>     
>
> wake_up_interruptible doesn't take any locks.
>
>   
>> +
>> +	if (xmit_ready)
>> +		uart_write_wakeup(&up->port);
>>     
>
> NAK.  uart_write_wakeup() is specifically designed not to take any locks.
> It's also called from the depths of uart_handle_cts_change().  So this
> buys us just additional unnecessary complexity.
>   
True, these things don't take any locks.  However, I'm working on
a polled capability for the serial driver and these operations may
have more to them than what they currently do.  This is certainly
better for the receive case, and it seems that the more things you
can move out of a lock the better.
>   
>>  }
>>  
>>  /*
>> @@ -1551,7 +1564,7 @@ static unsigned int serial8250_get_mctrl
>>  	unsigned int status;
>>  	unsigned int ret;
>>  
>> -	status = check_modem_status(up);
>> +	check_modem_status(up, &status);
>>  
>>  	ret = 0;
>>  	if (status & UART_MSR_DCD)
>>     
>
> Use of an uninitialised variable.  The reason we use check_modem_status
> to return the current status here is because reading the MSR _clears_
> interrupts.  So, repeatedly calling get_mctrl via an ioctl is a great
> way to introduce a hardware race condition if you just read the MSR and
> never act on it.
>   
"status" is used as a return variable; it is set by the call.  I modified
check_modem_status() to return if it detected a change and set the
status if it was passed in.

-corey

